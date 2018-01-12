--[[
--=====================================================================================================--
Script Name: Teleport Manager (utility), for SAPP (PC & CE)
Description: Allows the user to create custom teleports and warp to them on demand.

What this mod does:
This mod allows you to create custom teleport locations. You can then warp to those locations on demand from anywhere on the map with a simple command.

To create a new custom teleport location, simply type /setwarp [portal name]

When a teleport location is set, the mod will save some data to a text file called teleports.txt.
The data saved is:
- Portal Name
- Map Name
- x,y,z coordinates

To teleport to the new location, type /warp [portal name]

To view a list of portals linked to the current map you are on, type /warplist
To view all portals including teleports that aren't associated with the current map you're on, type /warplistall

To delete a portal linked with the current map, first type /warplist. 
To the left of the portal name you will see an index id in square brackets - this is the number you will type when deleting that teleport location.
Now type /delwarp [number]

If you wish to delete a teleport that isn't linked to the current map, type /warplistall to display the entire contents of the teleports.txt file.

Do the same as above, /delwarp [number]
This time you will be prompted to confirm or cancel this operation as you have chosen to delete a portal that isn't linked to the current map.
In chat, type YES or NO to confirm/deny this operation.


Note: You don't really have to type /warplist or /warplistall every time you want to teleport to, or delete a portal.
      It's there so you can retrieve the Index ID of the portal you want to work with, 
      in case you don't happen to keep track, and can't remember the index id of a specific portal.
             
Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 
-- configuration starts --
set_command = "setwarp"
goto_command = "warp"
list_command = "warplist"
list_all_command = "warplistall"

delete_command = {}
delete_command[1] = { "delwarp", "tpd"}

sapp_dir = "sapp\\teleports.txt"
permission_level = -1
-- configuration ends  --

api_version = "1.12.0.0"
canset = {}
wait_for_response = {}

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload() end

function OnGameStart()
    check_file_status()
    mapname = get_var(0, "$map")
end

function OnPlayerLeave(PlayerIndex)
    wait_for_response[PlayerIndex] = false
end

function OnPlayerChat(PlayerIndex, Message, type)
    if wait_for_response[PlayerIndex] then
        if Message == ("yes") then
            delete_from_file(sapp_dir, response_starting_line, response_num_lines , PlayerIndex)
            rprint(PlayerIndex, "Successfully deleted teleport id #" ..response_starting_line)
            wait_for_response[PlayerIndex] = false
            return false
        elseif Message == ("no") then
            rprint(PlayerIndex, "Process Cancelled")
            wait_for_response[PlayerIndex] = false
            return false
        end
        if Message ~= "yes" or Message ~= "no" then
            rprint(PlayerIndex, "That is not a valid response, please try again. Type YES|NO")
            wait_for_response[PlayerIndex] = true
            return false
        end
    end
end

function OnServerCommand(PlayerIndex, Command, Environment)
    local UnknownCMD = nil
    local t = tokenizestring(Command)
    ---------------------------------------------------------
    -- SET COMMAND --
    if t[1] ~= nil then
        if t[1] == string.lower(set_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                if t[2] ~= nil then
                    check_file_status()
                    if not empty_file then
                        local lines = lines_from(sapp_dir)
                        for k, v in pairs(lines) do
                            if t[2] == v:match("[%a%d+_]*") then
                                rprint(PlayerIndex, "That portal name already exists!")
                                canset[PlayerIndex] = false
                                break
                            else
                                canset[PlayerIndex] = true
                            end
                        end
                    else
                        canset[PlayerIndex] = true
                    end
                    if t[2] == t[2]:match(mapname) then
                        rprint(PlayerIndex, "Teleport name cannot be the same as the current map name!")
                        canset[PlayerIndex] = false
                    end
                    if canset[PlayerIndex] == true then
                        if PlayerInVehicle(PlayerIndex) then
                            x1, y1, z1 = read_vector3d(get_object_memory(read_dword(get_dynamic_player(PlayerIndex) + 0x11C)) + 0x5c)
                        else
                            x1, y1, z1 = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
                        end
                        local file = io.open(sapp_dir, "a+")
                        local line = t[2] .. " [Map: " .. mapname .. "] X " .. x1 .. ", Y " .. y1 .. ", Z " .. z1
                        file:write(line, "\n")
                        file:close()
                        rprint(PlayerIndex, "Teleport location set to: " .. x1 .. ", " .. y1 .. ", " .. z1)
                    end
                else
                    rprint(PlayerIndex, "Invalid Syntax. Command Usage: /" .. set_command .. " <teleport name>")
                end
            else
                rprint(PlayerIndex, "You're not allowed to execute /" .. set_command)
            end
            UnknownCMD = false
        end
    end
    ---------------------------------------------------------
    -- GO TO COMMAND --
    if t[1] ~= nil then
        if t[1] == string.lower(goto_command) then
            check_file_status()
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                if t[2] ~= nil then
                    if not empty_file then
                        local found = nil
                        local lines = lines_from(sapp_dir)
                        for k, v in pairs(lines) do
                            local valid = nil
                            if t[2] == v:match("[%a%d+_]*") then
                                if string.find(v, mapname) then
                                    found = true
                                    -- numbers without decimal points -----------------------------------------------------------------------------
                                    if string.match(v, ("X%s*%d+,%s*Y%s*%d+,%s*Z%s*%d+")) then
                                        valid = true -- 0
                                        x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
                                        y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
                                        z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))
                                    elseif string.match(v, ("X%s*-%d+,%s*Y%s*-%d+,%s*Z%s*-%d+")) then 
                                        valid = true -- *
                                    x = string.gsub(string.match(v, "X%s*-%d+"), "X%s*-%d+", string.match(string.match(v, "X%s*-%d+"), "-%d+"))
                                        y = string.gsub(string.match(v, "Y%s*-%d+"), "Y%s*-%d+", string.match(string.match(v, "Y%s*-%d+"), "-%d+"))
                                        z = string.gsub(string.match(v, "Z%s*-%d+"), "Z%s*-%d+", string.match(string.match(v, "Z%s*-%d+"), "-%d+"))
                                    elseif string.match(v, ("X%s*-%d+,%s*Y%s*%d+,%s*Z%s*%d+")) then  
                                        valid = true -- 1
                                        x = string.gsub(string.match(v, "X%s*-%d+"), "X%s*-%d+", string.match(string.match(v, "X%s*-%d+"), "-%d+"))
                                        y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
                                        z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))
                                    elseif string.match(v, ("X%s*%d+,%s*Y%s*-%d+,%s*Z%s*%d+")) then  
                                        valid = true -- 2
                                        x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
                                        y = string.gsub(string.match(v, "Y%s*-%d+"), "Y%s*-%d+", string.match(string.match(v, "Y%s*-%d+"), "-%d+"))
                                        z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))
                                    elseif string.match(v, ("X%s*%d+,%s*Y%s*%d+,%s*Z%s*-%d+")) then  
                                        valid = true -- 3
                                        x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
                                        y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
                                        z = string.gsub(string.match(v, "Z%s*-%d+"), "Z%s*-%d+", string.match(string.match(v, "Z%s*-%d+"), "-%d+"))
                                    elseif string.match(v, ("X%s*-%d+,%s*Y%s*-%d+,%s*Z%s*%d+")) then 
                                        valid = true -- 1 & 2
                                        x = string.gsub(string.match(v, "X%s*-%d+"), "X%s*-%d+", string.match(string.match(v, "X%s*-%d+"), "-%d+"))
                                        y = string.gsub(string.match(v, "Y%s*-%d+"), "Y%s*-%d+", string.match(string.match(v, "Y%s*-%d+"), "-%d+"))
                                        z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))
                                    elseif string.match(v, ("X%s*-%d+,%s*Y%s*%d+,%s*Z%s*-%d+")) then 
                                        valid = true -- 1 & 3
                                        x = string.gsub(string.match(v, "X%s*-%d+"), "X%s*-%d+", string.match(string.match(v, "X%s*-%d+"), "-%d+"))
                                        y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
                                        z = string.gsub(string.match(v, "Z%s*-%d+"), "Z%s*-%d+", string.match(string.match(v, "Z%s*-%d+"), "-%d+"))
                                    elseif string.match(v, ("X%s*%d+,%s*Y%s*-%d+,%s*Z%s*-%d+")) then 
                                        valid = true -- 2 & 3
                                        x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
                                        y = string.gsub(string.match(v, "Y%s*-%d+"), "Y%s*-%d+", string.match(string.match(v, "Y%s*-%d+"), "-%d+"))
                                        z = string.gsub(string.match(v, "Z%s*-%d+"), "Z%s*-%d+", string.match(string.match(v, "Z%s*-%d+"), "-%d+")) 
                                    -- numbers with decimal points -----------------------------------------------------------------------------
                                    elseif string.match(v, ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")) then
                                        valid = true -- 0
                                        x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                        y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                        z = string.gsub(string.match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", string.match(string.match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                                    elseif string.match(v, ("X%s*-%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                        valid = true -- *
                                        x = string.gsub(string.match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", string.match(string.match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                        y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                        z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                                    elseif string.match(v, ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")) then
                                        valid = true -- 1
                                        x = string.gsub(string.match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", string.match(string.match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                        y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                        z = string.gsub(string.match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", string.match(string.match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                                    elseif string.match(v, ("X%s*%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*%d+.%d+")) then
                                        valid = true -- 2
                                        x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                        y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                        z = string.gsub(string.match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", string.match(string.match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                                    elseif string.match(v, ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                        valid = true -- 3
                                        x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                        y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                        z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                                    elseif string.match(v, ("X%s*-%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*%d+.%d+")) then
                                        valid = true -- 1 & 2
                                        x = string.gsub(string.match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", string.match(string.match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                        y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                        z = string.gsub(string.match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", string.match(string.match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                                    elseif string.match(v, ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                        valid = true -- 1 & 3
                                        x = string.gsub(string.match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", string.match(string.match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                        y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                        z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                                    elseif string.match(v, ("X%s*%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                        valid = true  -- 2 & 3
                                        x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                        y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                        z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                                    else
                                        rprint(PlayerIndex, "Script Error! Coordinates for that teleport do not match the regex expression!")
                                        cprint("Script Error! Coordinates for that teleport do not match the regex expression!", 4+8)
                                    end
                                    if (v ~= nil and valid == true) then
                                        if not PlayerInVehicle(PlayerIndex) then
                                            write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, tonumber(x), tonumber(y), tonumber(z))
                                            rprint(PlayerIndex, "Teleporting to [" .. t[2] .. "] " .. math.floor(x) .. ", " .. math.floor(y).. ", " .. math.floor(z))
                                            valid = false
                                        else
                                            TeleportPlayer(read_dword(get_dynamic_player(PlayerIndex) + 0x11C), tonumber(x), tonumber(y), tonumber(z) + 0.5)
                                            rprint(PlayerIndex, "Teleporting to [" .. t[2] .. "] " .. math.floor(x) .. ", " .. math.floor(y).. ", " .. math.floor(z))
                                            valid = false
                                        end
                                    end
                                else
                                    found = true
                                    rprint(PlayerIndex, "That warp is not linked to this map!")
                                end
                            end
                        end
                        if found ~= true then
                            rprint(PlayerIndex, "That teleport name is not valid!")
                        end
                    else
                        rprint(PlayerIndex, "The teleport list is empty!")
                    end
                else
                    rprint(PlayerIndex, "Invalid Syntax. Command Usage: /" .. goto_command .. " <teleport name>")
                end
            else
                rprint(PlayerIndex, "You're not allowed to execute /" .. goto_command)
            end
            UnknownCMD = false
        ---------------------------------------------------------
        -- LIST COMMAND --
        elseif t[1] == string.lower(list_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                check_file_status()
                if not empty_file then
                    local lines = lines_from(sapp_dir)
                    for k,v in pairs(lines) do
                        if v:match(mapname) then
                            rprint(PlayerIndex, "["..k.."] " .. v)
                        end
                    end
                else
                    rprint(PlayerIndex, "The teleport list is empty!")
                end
            else
                rprint(PlayerIndex, "You're not allowed to execute /" .. list_command)
            end
            UnknownCMD = false
        ---------------------------------------------------------
        -- LIST ALL COMMAND --
        elseif t[1] == string.lower(list_all_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                check_file_status()
                if not empty_file then
                    local lines = lines_from(sapp_dir)
                    for k,v in pairs(lines) do
                        rprint(PlayerIndex, "["..k.."] " .. v)
                    end
                else
                    rprint(PlayerIndex, "The teleport list is empty!")
                end
            else
                rprint(PlayerIndex, "You're not allowed to execute /" .. list_all_command)
            end
            UnknownCMD = false
        ---------------------------------------------------------
        -- DELETE COMMAND --
        elseif t[1] == string.lower(delete_command[1][1]) or t[1] == string.lower(delete_command[1][2]) then
            local command = t[1]
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                if t[2] ~= nil then
                    check_file_status()
                    if not empty_file then
                        local lines = lines_from(sapp_dir)
                        local del_found = nil
                        for k, v in pairs(lines) do
                            if k ~= nil then
                                if t[2] == v:match(k) then
                                    del_found = true
                                    response_starting_line = nil
                                    response_num_lines = nil
                                    if string.find(v, mapname) then
                                        delete_from_file(sapp_dir, k, 1 , PlayerIndex)
                                        rprint(PlayerIndex, "Successfully deleted teleport id #" ..k)
                                    else
                                        wait_for_response[PlayerIndex] = true
                                        rprint(PlayerIndex, "Warning: That teleport is not linked to this map.")
                                        rprint(PlayerIndex, "Type 'YES' to delete, type 'NO' to cancel.")
                                        response_starting_line = k
                                        response_num_lines = 1
                                    end
                                end
                            end
                        end
                        if del_found ~= true then
                            rprint(PlayerIndex, "Teleport Index ID does not exist!")
                        end
                    else
                        rprint(PlayerIndex, "The teleport list is empty!")
                    end
                else
                    rprint(PlayerIndex, "Invalid Syntax. Command Usage: /" .. command .. " <index id>")
                end
            else
                rprint(PlayerIndex, "You're not allowed to execute /" .. command)
            end
            UnknownCMD = false
        end
    end
    return UnknownCMD
end

function lines_from(file)
    lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end

function check_file_status()
    local fileX = io.open(sapp_dir, "rb")
    if fileX then 
        fileX:close()
    else
        local fileY = io.open(sapp_dir, "a+")
        if fileY then 
            fileY:close() 
        end
        rprint(PlayerIndex, sapp_dir .. " doesn't exist. Creating...")
        cprint(sapp_dir .. " doesn't exist. Creating...")
    end
    local fileZ = io.open(sapp_dir, "r")
    local line = fileZ:read()
    if line == nil then
        empty_file = true
    else
        empty_file = false
    end
    fileZ:close()
end

function tokenizestring(inputString, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = { }; i = 1
    for str in string.gmatch(inputString, "([^" .. separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function delete_from_file(filename, starting_line, num_lines, player)
    local fp = io.open(filename, "r")
    if fp == nil then 
        check_file_status() 
    end
    content = {}
    i = 1;
    for line in fp:lines() do
        if i < starting_line or i >= starting_line + num_lines then
            content[#content+1] = line
        end
        i = i + 1
    end
    if i > starting_line and i < starting_line + num_lines then
        rprint(player, "Warning: End of File! No entries to delete.")
        cprint("Warning: End of File! No entries to delete.")
    end
    fp:close()
    fp = io.open( filename, "w+")
    for i = 1, #content do
        fp:write(string.format("%s\n", content[i]))
    end
    fp:close()
end

function PlayerInVehicle(PlayerIndex)
    if (get_dynamic_player(PlayerIndex) ~= 0) then
        local VehicleID = read_dword(get_dynamic_player(PlayerIndex) + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

function TeleportPlayer(ObjectID, x, y, z)
    if get_object_memory(ObjectID) ~= 0 then
        local veh_obj = get_object_memory(read_dword(get_object_memory(ObjectID) + 0x11C))
        write_vector3d((veh_obj ~= 0 and veh_obj or get_object_memory(ObjectID)) + 0x5C, x, y, z)
    end
end

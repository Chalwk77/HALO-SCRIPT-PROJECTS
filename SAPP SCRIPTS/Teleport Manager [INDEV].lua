--[[
--=====================================================================================================--
Script Name: Teleport Management (utility), for SAPP (PC & CE)
Description: Allows the user to create custom teleports and warp to them on demand.

Warning: This script implements a heavy use of pattern matching (regex) and is extremely complicated. 
         Modify only if you know what you're doing!

Use this command to set a new teleport location
/setportal [teleport name]

Use this command to teleport to the desired teleport location
/tpo [teleport name]

Use this command to list all custom portals
/tplist
             
Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

-- configuration starts --

set_command = "setportal"
goto_command = "tpo"
list_command = "tplist"
sapp_dir = "sapp\\teleports.txt"
permission_level = -1
-- configuration ends  --

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload() end

function OnServerCommand(PlayerIndex, Command, Environment)
    local UnknownCMD = nil
    local t = tokenizestring(Command)
    ---------------------------------------------------------
    -- SET COMMAND --
    if t[1] ~= nil then
        if t[1] == string.lower(set_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                -- do to:
                -- check if portal name already exists
                if t[2] ~= nil then
                    local player = get_dynamic_player(PlayerIndex)
                    local x, y, z = read_vector3d(player + 0x5C)
                    local file = io.open(sapp_dir, "a+")
                    local line = t[2] .. ": X" .. x .. ", Y" .. y .. ", Z" .. z
                    file:write(line, "\n")
                    file:close()
                    say(PlayerIndex, "Teleport location set to: " .. x .. ", " .. y .. ", " .. z)
                else
                    say(PlayerIndex, "Invalid Syntax. Command Usage: /" .. set_command .. " <teleport name>")
                end
            else
                say(PlayerIndex, "You're not allowed to execute /" .. set_command)
            end
            UnknownCMD = false
        end
    end
    ---------------------------------------------------------
    -- GO TO COMMAND --
    if t[1] ~= nil then
        if t[1] == string.lower(goto_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                if t[2] ~= nil then
                    local file = sapp_dir
                    local lines = lines_from(file)
                    for k, v in pairs(lines) do
                        local teleport_name = v:match("[%a%d+_]*")
                        if t[2] == teleport_name then
                            local regex_1 = ("%d+,%s*%d+,%s*%d+")
                            local regex_2 = ("-%d+,%s*-%d+,%s*-%d+")
                            local regex_3 = ("-%d+,%s*%d+,%s*%d+")
                            local regex_4 = ("%d+,%s*-%d+,%s*%d+")
                            local regex_5 = ("%d+,%s*%d+,%s*-%d+")
                            local regex_6 = ("-%d+,%s*-%d+,%s*%d+")
                            local regex_7 = ("-%d+,%s*%d+,%s*-%d+")
                            local regex_8 = ("%d+,%s*-%d+,%s*-%d+")
                            local regex_9 = ("%d+.%d+,%s*%d+.%d+,%s*%d+.%d+")
                            local regex_10 = ("-%d+.%d+,%s*-%d+.%d+,%s*-%d+.%d+")
                            local regex_11 = ("-%d+.%d+,%s*%d+.%d+,%s*%d+.%d+")
                            local regex_12 = ("%d+.%d+,%s*-%d+.%d+,%s*%d+.%d+")
                            local regex_13 = ("%d+.%d+,%s*%d+.%d+,%s*-%d+.%d+")
                            local regex_14 = ("-%d+.%d+,%s*-%d+.%d+,%s*%d+.%d+")
                                               
                            local regex_15 = ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")
                            
                            local regex_16 = ("%d+.%d+,%s*-%d+.%d+,%s*-%d+.%d+")
                            local coordinates = nil

                            if string.match(v, regex_15) then
                            
                                -- identifier for X
                                local x1 = tostring(string.match(v, "X%s*-%d+.%d+"))
                                -- replacement for X
                                local x2 = tostring(string.match(v, "-%d+.%d+"))
                                -- swap the identifier with the replacement
                                local x = string.gsub(x1, "X%s*-%d+.%d+", x2)
                                cprint(x .. "", 2+8)
                                
                                
                            elseif string.match(v, regex_2) then 
                                coordinates = string.match(v, regex_2)
                            elseif string.match(v, regex_3) then 
                                coordinates = string.match(v, regex_3)
                            elseif string.match(v, regex_4) then 
                                coordinates = string.match(v, regex_4)
                            elseif string.match(v, regex_5) then 
                                coordinates = string.match(v, regex_5)
                            elseif string.match(v, regex_6) then 
                                coordinates = string.match(v, regex_6)
                            elseif string.match(v, regex_7) then 
                                coordinates = string.match(v, regex_7)
                            elseif string.match(v, regex_8) then 
                                coordinates = string.match(v, regex_8)
                            elseif string.match(v, regex_9) then
                                coordinates = string.match(v, regex_9)
                            elseif string.match(v, regex_10) then
                                coordinates = string.match(v, regex_10)
                            elseif string.match(v, regex_11) then
                                coordinates = string.match(v, regex_11)
                            elseif string.match(v, regex_12) then
                                coordinates = string.match(v, regex_12)
                            elseif string.match(v, regex_13) then
                                coordinates = string.match(v, regex_13)
                            elseif string.match(v, regex_14) then
                                coordinates = string.match(v, regex_14)
                            elseif string.match(v, regex_15) then
                                coordinates = string.match(v, regex_15)
                            elseif string.match(v, regex_16) then
                                coordinates = string.match(v, regex_16)
                            else
                                rprint(PlayerIndex, "Script Error! Coordinates for that teleport do not match the regex expression!")
                                cprint("Script Error! Coordinates for that teleport do not match the regex expression!", 4+8)
                            end
                            if (v ~= nil) then
                                -- write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, tostring(coordinates))
                            end
                        end
                    end
                    UnknownCMD = false
                else
                    say(PlayerIndex, "Invalid Syntax. Command Usage: /" .. goto_command .. " <teleport name>")
                end
            else
                say(PlayerIndex, "You're not allowed to execute /" .. goto_command)
            end
            UnknownCMD = false
        end
    end
    ---------------------------------------------------------
    -- LIST COMMAND --
    if t[1] ~= nil then
        if t[1] == string.lower(list_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                local file = sapp_dir
                local lines = lines_from(file)
                for k,v in pairs(lines) do
                    rprint(PlayerIndex, "["..k.."] " .. v)
                end
            else
                say(PlayerIndex, "You're not allowed to execute /" .. list_command)
            end
            UnknownCMD = false
        end
    end
    return UnknownCMD
end

function file_exists(file)
    local File = io.open(file, "rb")
    if File then 
        File:close() 
    end
    return File ~= nil
end

function lines_from(file)
    if not file_exists(file) then 
        return {} 
    end
    lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
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

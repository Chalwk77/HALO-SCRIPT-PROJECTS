--[[
--=====================================================================================================--
Script Name: Server Fun Plus, for SAPP (PC & CE)

Features: 
    rocket:             turn a player into a rocket (player's in vehicles only)
*   force chat:         force a player to say something
*   fake join:          pretend player joins the game
*   fake quit:          pretend player left the game
    random tp:          teleport player to a random location on the map
*   slap:               slap target player
    spam:               spam a message to the designated player
    zap:                zap target player (deals X damage)
*   god:                broadcast a message as god
    explode:            explode the target player
    colour changer:     change a player's colour
    
    IN DEVELOPMENT
    
             
Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

api_version = "1.12.0.0"

-- ROCKET --
-- /rocket null|me
-- /rocket null|me x, y, z, (optional: yaw, pitch, roll)
-- /rocket [index id]
-- /rocket [index id] x, y, z, (optional: yaw, pitch, roll)
rocket_command = "rocket"
rocket_permission_level = 1
values_specified = {}
x1 = {}
y1 = {}
z1 = {}
yaw = {}
pitch = {}
roll = {}

-- FORCE CHAT --
-- /fchat [index id] (message)
force_chat_command = "fchat"
fc_permission_level = 1

-- SLAP --
-- /slap [index id]
slap_command = "slap"
slap_permission_level = 1

-- FAKE JOIN | FAKE QUIT --
-- /fakejoin [name]
-- /fakequit [name]
fake_join_command = "fakejoin"
fake_quit_command = "fakequit"
fake_permission_level = 1

-- BROADCAST AS GOD --
god_command = "bgod"
god_permission_level = 1

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload() end

function OnPlayerChat(PlayerIndex, Message, type)
    local t = tokenizestring(Message)
    local executor = get_var(PlayerIndex, "$n")
    if t[1] ~= nil then
        if t[1] == ("/" .. string.lower(force_chat_command)) or t[1] == ("\\" .. string.lower(force_chat_command)) then
            if tonumber(get_var(executor, "$lvl")) >= fc_permission_level then
                if t[2] ~= nil then
                    local index = tonumber(t[2])
                    if string.match(t[2], "%d") then
                        if t[3] ~= nil then
                            if index ~= tonumber(executor) then
                                if index ~= nil and index > 0 and index < 17 then
                                    if player_present(index) then
                                        execute_command("msg_prefix \"\"")
                                        local broadcast = string.gsub(Message, "/" .. force_chat_command .. " %d", "")
                                        say_all(get_var(index, "$name") .. ":" .. broadcast)
                                        execute_command("msg_prefix \"** SERVER ** \"")
                                        return false
                                    else
                                        rprint(executor, "Invalid Player Index")
                                        return false
                                    end
                                end
                            else
                                rprint(executor, "You cannot broadcast as yourself!")
                                return false
                            end
                        else
                            rprint(executor, "You didn't type a message!")
                            return false
                        end
                    end
                else
                    rprint(executor, "Invalid Syntax. Type /" .. force_chat_command .. " [index id]")
                    return false
                end
            else
                rprint(executor, "You do not have permission to execute that command!")
                return false
        end
    elseif t[1] == ("/" .. string.lower(god_command)) or t[1] == ("\\" .. string.lower(god_command)) then
            if tonumber(get_var(executor, "$lvl")) >= god_permission_level then
                if t[2] ~= nil then
                    execute_command("msg_prefix \"\"")
                    local broadcast = string.gsub(Message, "/" .. god_command, "")
                    say_all("God:" .. broadcast)
                    execute_command("msg_prefix \"** SERVER ** \"")
                    return false
                end
            end
        end
    end
    return true
end

function OnServerCommand(PlayerIndex, Command)
    local UnknownCMD = nil
    local t = tokenizestring(Command)
    if t[1] ~= nil then
        if t[1] == string.lower(rocket_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= rocket_permission_level then
                local index = tonumber(t[2])
                local executor = PlayerIndex
                -- t 1-2
                -- /rocket null|me x, y, z
                if (t[2] == nil) or (t[2] ~= nil and t[2] == "me") then
                    Rocket(executor, executor, X, Y, Z, Yaw, Pitch, Roll)
                    if PlayerInVehicle(executor) then 
                        values_specified[executor] = false
                        rprint(executor, "You have been rocketed!") 
                    end
                elseif (t[2] ~= nil and t[2] ~= "me") and (t[3] == nil) and (t[4] == nil) and (t[5] == nil) then
                    if player_present(index) then
                        Rocket(index, executor, X, Y, Z, Yaw, Pitch, Roll)
                        if PlayerInVehicle(index) then 
                            values_specified[index] = false
                            rprint(index, "You have been rocketed!") 
                        end
                    else
                        rprint(PlayerIndex, "Invalid Player ID!")
                    end
                -- t 1-4
                -- /rocket x, y, z 
                elseif (t[2] ~= nil and t[2] ~= "me") and (t[3] ~= nil) and (t[4] ~= nil) and (t[5] == nil) then
                    X = t[2]
                    Y = t[3]
                    Z = t[4]
                    Rocket(executor, executor, X, Y, Z, Yaw, Pitch, Roll)
                    if PlayerInVehicle(executor) then 
                        values_specified[executor] = true
                        rprint(executor, "You have been rocketed!") 
                    end
                -- t 1-2  
                -- /rocket [id]
                -- t 1-5
                -- /rocket [id] x, y, z 
                elseif (t[2] ~= nil and t[2] ~= "me") and (t[3] ~= nil) and (t[4] ~= nil) and (t[5] ~= nil) then
                    if string.match(t[2], "%d") then
                        if index ~= nil and index > 0 and index < 17 then
                            if t[3] ~= nil and t[4] ~= nil and t[5] ~= nil then
                                X = t[3]
                                Y = t[4]
                                Z = t[5]
                                values_specified[index] = true
                            else
                                values_specified[index] = false
                            end
                            if player_present(index) then
                                if index == get_var(executor, "$n") then
                                    Rocket(executor, X, Y, Z, Yaw, Pitch, Roll)
                                    if PlayerInVehicle(executor) then
                                        rprint(executor, "You have been rocketed!")
                                    end
                                else
                                    Rocket(index, executor, X, Y, Z, Yaw, Pitch, Roll)
                                    if PlayerInVehicle(index) then
                                        rprint(index, "You have been rocketed!")
                                        rprint(executor, get_var(index, "$name") .. " has been rocketed!")
                                    end
                                end
                            else
                                rprint(PlayerIndex, "Invalid Player ID!")
                            end
                        end
                    else
                        rprint(PlayerIndex, "Invalid Player Index!")
                    end
                end
            else
                rprint(PlayerIndex, "You do not have permission to execute that command!")
            end
            UnknownCMD = false
        end
    end
    if t[1] ~= nil then
        if t[1] == string.lower(slap_command) then
            local executor = get_var(PlayerIndex, "$n")
            if tonumber(get_var(PlayerIndex, "$lvl")) >= slap_permission_level then
                if t[2] ~= nil then
                    local index = tonumber(t[2])
                    if index ~= tonumber(executor) then
                        if string.match(t[2], "%d") then
                            if index ~= nil and index > 0 and index < 17 then
                                if player_present(index) then
                                    if not PlayerInVehicle(index) then
                                        local x, y, z = read_vector3d(get_dynamic_player(index) + 0x5C)
                                        write_vector3d(get_dynamic_player(index) + 0x5C, x + 0.50, y + 0.50, z + 4)
                                        rprint(executor, "You slapped " .. get_var(index, "$name"))
                                        rprint(index, "You were slapped by " .. get_var(executor, "$name"))
                                    else
                                        rprint(executor, get_var(index, "$name") .. " is in a vehicle!")
                                    end
                                else
                                    rprint(PlayerIndex, "Invalid Player ID!")
                                end
                            end
                        end
                    else
                        rprint(executor, "You cannot slap yourself!")
                    end
                else
                    rprint(executor, "Invalid Syntax. Type /" .. slap_command .. " [index id]")
                end
            else
                rprint(PlayerIndex, "You do not have permission to execute that command!")
            end
            UnknownCMD = false
        end
    end
    if t[1] ~= nil then
        if t[1] == string.lower(fake_join_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= fake_permission_level then
                if t[2] ~= nil then
                    if t[3] == nil then
                        local fake_name = tostring(t[2])
                        local char_len = string.len(fake_name)
                        if char_len > 11 then 
                            rprint(PlayerIndex, "Name can only be 11 characters! You typed " .. char_len .. " characters!")
                        else
                            execute_command("msg_prefix \"\"")
                            say_all("Welcome " .. fake_name)
                            execute_command("msg_prefix \"** SERVER ** \"")
                        end
                    else
                        rprint(PlayerIndex, "The name can only be one word!")
                    end
                else
                    rprint(PlayerIndex, "Invalid Syntax. Type /" .. fake_join_command .. " [name]")
                end
            else
                rprint(PlayerIndex, "You do not have permission to execute that command!")
            end
            UnknownCMD = false
        elseif t[1] == string.lower(fake_quit_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= fake_permission_level then
                if t[2] ~= nil then
                    if t[3] == nil then
                        local fake_name = tostring(t[2])
                        local char_len = string.len(fake_name)
                        if char_len > 11 then 
                            rprint(PlayerIndex, "Name can only be 11 characters! You typed " .. char_len .. " characters!")
                        else
                            execute_command("msg_prefix \"\"")
                            say_all(fake_name .. " Quit")
                            execute_command("msg_prefix \"** SERVER ** \"")
                        end
                    else
                        rprint(PlayerIndex, "The name can only be one word!")
                    end
                else
                    rprint(PlayerIndex, "Invalid Syntax. Type /" .. fake_quit_command .. " [name]")
                end
            else
                rprint(PlayerIndex, "You do not have permission to execute that command!")
            end
            UnknownCMD = false
        end
    end
    return UnknownCMD
end

function Rocket(index, executor, X, Y, Z, Yaw, Pitch, Roll)
    local player_object = get_dynamic_player(index)
    if player_object then
        if PlayerInVehicle(index) then
            local VehicleObj = get_object_memory(read_dword(player_object + 0x11c))
            local vehicle_tag = read_string(read_dword(read_word(VehicleObj) * 32 + 0x40440038))
            if VehicleObj ~= nil then
                write_bit(VehicleObj + 0x10, 2, 0)
                if values_specified[index] then
                    x1[index] = X
                    y1[index] = Y
                    z1[index] = Z
                    yaw[index] = Yaw
                    pitch[index] = Pitch
                    roll[index] = Roll
                else
                    x1[index] = 0
                    y1[index] = 0
                    z1[index] = 0.75
                    yaw[index] = 1
                    pitch[index] = 1
                    roll[index] = 15
                end
                write_float(VehicleObj + 0x68, x1[index])
                write_float(VehicleObj + 0x6C, y1[index])
                write_float(VehicleObj + 0x70, z1[index])
                write_float(VehicleObj + 0x90, yaw[index])
                write_float(VehicleObj + 0x8C, pitch[index])
                write_float(VehicleObj + 0x94, roll[index])
            end
        else
            if get_var(index, "$n") == get_var(executor, "$n") then
                rprint(executor, "You're not in a vehicle!")
            else
                rprint(executor, get_var(index, "$name") .. " is not in a vehicle!")
            end
        end
    end
end

function PlayerInVehicle(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local VehicleID = read_dword(player_object + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { }; i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

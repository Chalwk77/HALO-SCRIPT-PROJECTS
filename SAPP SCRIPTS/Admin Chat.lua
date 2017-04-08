--[[
------------------------------------
Script Name: AdminChat (utility), for SAPP | (PC\CE)

Description: Chat privately with other admins. 
             Command Syntax: /achat on|off
             
This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"

-- configuration starts here --
-- Minimin admin level required to use /achat command
min_admin_level = 1

-- Admin Chat prefix
prefix = "[ADMIN CHAT] "

-- If this is enabled, your admin chat will be restored to its previous state (ON|OFF) when you reconnect.
Restore_Previous_State = true

-- Print message to Rcon Console or Chat?
-- Valid input: rcon or chat
Format = "rcon"
-- configuration ends here --

-- tables --
data = { }
players = { }
adminchat = { }
stored_data = { }
boolean = { }

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    for i = 1,16 do
        if player_present(i) then
            players[get_var(i, "$name")].adminchat = nil
            players[get_var(i, "$name")].boolean = nil
        end
    end
end

function OnScriptUnload() 
    for i = 1,16 do
        if player_present(i) then
            players[get_var(i, "$name")].adminchat = false
            players[get_var(i, "$name")].boolean = false
        end
    end
end

function OnNewGame()
    for i = 1,16 do
        if player_present(i) then
            players[get_var(i, "$name")].adminchat = nil
            players[get_var(i, "$name")].boolean = nil
        end
    end
end

function OnGameEnd()
    for i = 1,16 do
        if player_present(i) then
            if (Restore_Previous_State == true) then
                if players[get_var(i, "$name")].adminchat == true then bool = "true" else bool = "false" end
                data[i] = get_var(i, "$name") .. ":" .. bool
                stored_data[data] = stored_data[data] or { }
                table.insert(stored_data[data], tostring(data[i]))
            else
                players[get_var(i, "$name")].adminchat = false
                players[get_var(i, "$name")].boolean = false
            end
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    players[get_var(PlayerIndex, "$name")] = { }
    players[get_var(PlayerIndex, "$name")].adminchat = nil
    players[get_var(PlayerIndex, "$name")].boolean = nil
    if (Restore_Previous_State == true) then
        local t = tokenizestring(tostring(data[PlayerIndex]), ":")
        if t[2] == "true" then
            rprint(PlayerIndex, "Your admin chat is on!")
            players[get_var(PlayerIndex, "$name")].adminchat = true
            players[get_var(PlayerIndex, "$name")].boolean = true
        else
            players[get_var(PlayerIndex, "$name")].adminchat = false
            players[get_var(PlayerIndex, "$name")].boolean = false
        end
    else
        players[get_var(PlayerIndex, "$name")].adminchat = false
        players[get_var(PlayerIndex, "$name")].boolean = false
    end
end

function OnPlayerLeave(PlayerIndex)
    if PlayerIndex ~= 0 then
        if (Restore_Previous_State == true) then
            if players[get_var(PlayerIndex, "$name")].adminchat == true then bool = "true" else bool = "false" end
            data[PlayerIndex] = get_var(PlayerIndex, "$name") .. ":" .. bool
            stored_data[data] = stored_data[data] or { }
            table.insert(stored_data[data], tostring(data[PlayerIndex]))
        else
            players[get_var(PlayerIndex, "$name")].adminchat = false
            players[get_var(PlayerIndex, "$name")].boolean = false
        end
    end
end

function OnServerCommand(PlayerIndex, Command, Environment)
    local t = tokenizestring(Command)
    response = nil
    if t[1] == "achat" then
        if PlayerIndex ~= -1 and PlayerIndex >= 1 and PlayerIndex < 16 then
            if (tonumber(get_var(PlayerIndex,"$lvl"))) >= min_admin_level then
                if t[2] == "on" or t[2] == "1" or t[2] == "true" or t[2] == '"1"' or t[2] == '"on"' or t[2] == '"true"' then
                    if players[get_var(PlayerIndex, "$name")].boolean ~= true then 
                        rprint(PlayerIndex, "Admin Chat enabled.")
                        players[get_var(PlayerIndex, "$name")].adminchat = true
                        players[get_var(PlayerIndex, "$name")].boolean = true
                    else
                        rprint(PlayerIndex, "Admin Chat is already enabled.")
                    end
                elseif t[2] == "off" or t[2] == "0" or t[2] == "false" or t[2] == '"off"' or t[2] == '"0"' or t[2] == '"false"' then
                    if players[get_var(PlayerIndex, "$name")].boolean ~= false then
                        players[get_var(PlayerIndex, "$name")].adminchat = false
                        rprint(PlayerIndex, "Admin Chat disabled.")
                        players[get_var(PlayerIndex, "$name")].boolean = false
                    else
                        rprint(PlayerIndex, "Admin Chat is already disabled.")
                    end
                else
                    rprint(PlayerIndex, "Invalid Syntax: Type /achat on|off")
                end
            else
                rprint(PlayerIndex, "You do not have permission to execute that command!")
            end
        else
            cprint("The Server cannot execute this command!", 4+8)
        end
        response = false
    end
    return response
end

function OnPlayerChat(PlayerIndex, Message)
    local message = tokenizestring(Message)
    if #message == 0 then return nil end
    if players[get_var(PlayerIndex, "$name")].adminchat == true then
        for i = 0, #message do
            if message[i] then
                if string.sub(message[1], 1, 1) == "/" or string.sub(message[1], 1, 1) == "\\" then
                    return true
                else
                    AdminChat(prefix .. " " .. get_var(PlayerIndex, "$name") .. ":  " .. Message, PlayerIndex)
                    return false
                end
            end
        end
    end
end

function AdminChat(Message, PlayerIndex)
    for i = 1, 16 do
        if player_present(i) then
            if (tonumber(get_var(i,"$lvl"))) >= min_admin_level then
                if (Format == "rcon") then
                    rprint(i, "|l" .. Message)
                elseif (Format == "chat") then
                    execute_command("msg_prefix \"\"")
                    say(i, Message)
                    execute_command("msg_prefix \"** SERVER ** \"")
                else
                    cprint("Error in adminchat.lua - Format not defined properly. Line 34", 4+8)
                end
            end
        end
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function OnError(Message)
    print(debug.traceback())
end

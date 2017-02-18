--[[
    Script Name: Hurt me Plenty! (command), for SAPP | (PC\CE)
    Implementing API version: 1.11.0.0

    Description: Hurt yoursels or others
                 Minimum admin level required is 1 by default.
                 Sets your health to 1 bar and removes your shields. 
                 Note: Shield bar does not sync!

                 Command Syntax:
                                    /hurt [player# 1-16]
                                    /hurt me

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
]]

api_version = "1.11.0.0"
ADMIN_LEVEL = 1
COMMAND = "hurt"

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload() end

function OnServerCommand(PlayerIndex, Command)
    local response = nil
    local t = tokenizestring(Command)
    if t[1] ~= nil then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= ADMIN_LEVEL and(t[1] == string.lower(COMMAND)) then
            response = false
            if t[2] ~= nil then
                if (t[2] == "me") then
                    index = tonumber(get_var(PlayerIndex, "$n"))
                else
                    index = tonumber(t[2])
                end
                if t[3] ~= nil then
                    if string.match(t[3], "[A-Za-z]") then
                        containsString = true
                    else
                        containsString = false
                    end
                end
                if index ~= nil and index > 16 and index < 99999 then
                    respond("Invalid index! Please enter a number between 1-16", PlayerIndex)
                elseif index ~= nil and index > 0 and index < 17 then
                    receiver = get_var(index, "$name")
                    executor = get_var(PlayerIndex, "$name")
                    if player_present(index) then
                        if (containsString == true) then
                            respond("Invalid index! Please enter a number, not letter(s).", PlayerIndex)
                            containsString = false
                        else
                            HurtPlayer(index, PlayerIndex)
                        end
                    else
                        respond("Invalid Player Index!", PlayerIndex)
                    end
                end
            else
                respond("--- Invalid Syntax ---", PlayerIndex)
                respond("/hurt me", PlayerIndex)
                respond("/hurt [player# 1-16]", PlayerIndex)
            end
        end
    end
    return response
end

function HurtPlayer(index, PlayerIndex)
    local player_object = get_dynamic_player(index)
    if (player_object ~= 0) then
        local health = read_float(player_object + 0xE0)
        local shields = read_float(player_object + 0xE4)
        if health >= 1 and shields == 1 or shields == 3 then
            write_float(player_object + 0xE0, 0.001)
            write_float(player_object + 0xE4, 0)
            if tonumber(get_var(PlayerIndex, "$n")) == index then
                respond("Ouch!", PlayerIndex)
            else
                respond(executor .. " hurt you plenty!", index)
            end
        else
            if tonumber(get_var(PlayerIndex, "$n")) == index then
                respond("Unable to hurt youself.", index)
            else
                respond(receiver .. " has been though enough. Have some compassion!", PlayerIndex)
            end
        end
    end
end
           
function respond(Command, PlayerIndex)
    if Command then
        if Command == "" then
            return
        elseif type(Command) == "table" then
            Command = Command[1]
        end
        PlayerIndex = tonumber(PlayerIndex)
        if tonumber(PlayerIndex) and PlayerIndex ~= nil and PlayerIndex ~= -1 and PlayerIndex >= 0 and PlayerIndex < 16 then
            cprint(Command, 2 + 8)
            rprint(PlayerIndex, Command)
        else
            cprint(Command, 2 + 8)
        end
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

function OnError(Message)
    print(debug.traceback())
end
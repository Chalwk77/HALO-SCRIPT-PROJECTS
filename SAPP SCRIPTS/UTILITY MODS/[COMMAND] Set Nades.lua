--[[
--=====================================================================================================--
Script Name: SetNades (command), for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description: Set frag|plasma grenades for yourself (or others)
Command Syntax:
    /frags [player# 1-16] <amount>
    /frags me <amount>
    /plasmas [player# 1-16] <amount>
    /plasmas me <amount>

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

api_version = "1.12.0.0"
ADMIN_LEVEL = 1
FRAG_COMMAND = "frags"
PLASMA_COMMAND = "plasmas"

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload()
end

function OnServerCommand(PlayerIndex, Command)
    local response = nil
    local t = tokenizestring(Command)
    if t[1] ~= nil then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= ADMIN_LEVEL and (t[1] == string.lower(FRAG_COMMAND)) or (t[1] == string.lower(PLASMA_COMMAND)) then
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
                        value = tonumber(t[3])
                        if (value >= 1 and value < 255) then
                            ValueWasDefined = true
                        else
                            respond("Cannot set 0. Enter a number between [1-255]", PlayerIndex)
                            ValueWasDefined = false
                        end
                    end
                end
                if index ~= nil and index > 0 and index < 17 then
                    receiver = get_var(index, "$name")
                    executor = get_var(PlayerIndex, "$name")
                    if player_present(index) then
                        if (containsString == true) then
                            respond("Invalid index!", PlayerIndex)
                            containsString = false
                        else
                            if (t[1] == FRAG_COMMAND) then
                                SetFrags(index, PlayerIndex)
                            elseif (t[1] == PLASMA_COMMAND) then
                                SetPlasmas(index, PlayerIndex)
                            end
                        end
                    else
                        respond("Invalid Player Index!", PlayerIndex)
                    end
                end
            else
                respond("Invalid Syntax: /" .. t[1] .. " me | [player# 1-16] <amount>", PlayerIndex)
            end
        end
    end
    return response
end

function SetFrags(index, PlayerIndex)
    local player_object = get_dynamic_player(index)
    local frags = read_float(player_object + 0x31E)
    if (player_object ~= 0) then
        if tonumber(frags) <= 255 then
            write_byte(player_object + 0x31E, tonumber(value))
            if tonumber(get_var(PlayerIndex, "$n")) == index then
                respond("Setting frag grenades to " .. value, PlayerIndex)
            else
                respond("Setting " .. receiver .. "'s frag grenades to " .. value, PlayerIndex)
                respond(executor .. " has set your frag grenades to " .. value, index)
            end
        else
            if (ValueWasDefined == true) then
                value = value
                write_byte(player_object + 0x31E, value)
                if tonumber(get_var(PlayerIndex, "$n")) == index then
                    respond("Setting frag grenades to " .. value, PlayerIndex)
                else
                    respond("Setting " .. receiver .. "'s frag grenades to " .. value, PlayerIndex)
                    respond(executor .. " has set your frag grenades to " .. value, index)
                end
            end
        end
    end
end

function SetPlasmas(index, PlayerIndex)
    local player_object = get_dynamic_player(index)
    local plasmas = read_float(player_object + 0x31F)
    if (player_object ~= 0) then
        if tonumber(plasmas) <= 255 then
            write_byte(player_object + 0x31F, tonumber(value))
            if tonumber(get_var(PlayerIndex, "$n")) == index then
                respond("Setting plasma grenades to " .. value, PlayerIndex)
            else
                respond("Setting " .. receiver .. "'s plasma grenades to " .. value, PlayerIndex)
                respond(executor .. " has set your plasma grenades to " .. value, index)
            end
        else
            if (ValueWasDefined == true) then
                value = value
                write_byte(player_object + 0x31F, value)
                if tonumber(get_var(PlayerIndex, "$n")) == index then
                    respond("Setting plasma grenades to " .. value, PlayerIndex)
                else
                    respond("Setting " .. receiver .. "'s plasma grenades to " .. value, PlayerIndex)
                    respond(executor .. " has set your plasma grenades to " .. value, index)
                end
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
    local t = { };
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function OnError(Message)
    print(debug.traceback())
end

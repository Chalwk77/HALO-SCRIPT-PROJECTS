--[[
--=====================================================================================================--
Script Name: Heal Me (command), for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description: Heal yourself or others
Command Syntax:
    /heal [player# 1-16] [0.001-1000]
    /heal [player# 1-16]
    /heal me [0.001-1000]
    /heal me

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

api_version = "1.12.0.0"
-- Minimum admin level required to execute /heal command.
ADMIN_LEVEL = 1
COMMAND = "heal"

settings = {
    -- Toggle on|off console output
    ["DisplayConsoleOutput"] = false,
    -- Log to file (sapp.log)
    ["LogToFile"] = false
}

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
                        value = tonumber(t[3])
                        if (value > 0.001 and value < 1000) then
                            ValueWasDefined = true
                        else
                            ValueWasDefined = false
                        end
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
                            HealPlayer(index, PlayerIndex)
                        end
                    else
                        respond("Invalid Player Index!", PlayerIndex)
                    end
                end
            else
                respond("--- Invalid Syntax ---", PlayerIndex)
                respond("Available Commands:", PlayerIndex)
                respond("/heal [player# 1-16] [0.001-1000]", PlayerIndex)
                respond("/heal [player# 1-16]", PlayerIndex)
                respond("/heal me [0.001-1000]", PlayerIndex)
                respond("/heal me", PlayerIndex)
            end
        end
    end
    return response
end

function HealPlayer(index, PlayerIndex)
    local player_object = get_dynamic_player(index)
    if (player_object ~= 0) then
        local health = read_float(player_object + 0xE0)
        if health < 1 then
            local vehicleId = read_dword(player_object + 0x11C)
            if vehicleId == nil then
                local x, y, z = GetPlayerCoords(player_object)
                local healthpack = spawn_object("eqip", "powerups\\health pack", x, y, z + 0.5)
                if healthpack ~= nil then
                    write_float(get_object_memory(healthpack) + 0x70, -2)
                end
            else
                if ValueWasDefined then value = value else value = 1 end
                write_float(player_object + 0xE0, value)
            end
            if tonumber(get_var(PlayerIndex, "$n")) == index then
                respond("You have healed yourself!", PlayerIndex)
            else
                respond("You have healed " .. receiver, PlayerIndex)
                respond("You have been healed by " .. executor, index)
            end
        else
            if tonumber(get_var(PlayerIndex, "$n")) == index then
                respond("You are already at full health! ", PlayerIndex)
            else
                respond(receiver .. " is already at full health", PlayerIndex)
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
            if settings["DisplayConsoleOutput"] then
                cprint("Response to: " .. get_var(PlayerIndex, "$name"), 4 + 8)
                cprint(Command, 2 + 8)
            end
            rprint(PlayerIndex, Command)
            if settings["LogToFile"] then
                note = string.format('[COMMAND-HEAL] -->> ' .. get_var(PlayerIndex, "$name") .. ': ' .. Command)
                execute_command("log_note \"" .. note .. "\"")
            end
        else
            if settings["DisplayConsoleOutput"] then cprint(Command, 2 + 8) end
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

--[[
    Script Name: Heal Me! (command), for SAPP | (PC\CE)
    Implementing API version: 1.11.0.0

    Description: Heal yourself or others
                 Minimum admin level required is 1 by default.
                 Command Syntax: /heal me, /heal [number 1-16]
                 
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
COMMAND = "heal"
function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload() end

function OnServerCommand(PlayerIndex, Command)
    local response = nil
    local t = tokenizestring(Command)
    count = #t
    if t[1] ~= nil then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= ADMIN_LEVEL and (t[1] == COMMAND) then
            response = false
            if t[2] ~= nil then
                if (t[2] == "me") then 
                    Player = tonumber(get_var(PlayerIndex, "$n"))
                else
                    Player = tonumber(t[2])
                end
                if Player ~= nil and Player > 16 and Player < 99999 then
                    respond("Invalid Player! Please enter a number between 1-16", PlayerIndex)
                elseif Player ~= nil and Player > 0 and Player < 17 then
                    name = get_var(Player, "$name")
                    Executor = get_var(PlayerIndex, "$name")
                    if player_present(Player) then
                        HealPlayer(Player, PlayerIndex)
                    else
                        respond("Invalid Player!", PlayerIndex)
                    end
                end
            else
                respond("Invalid Syntax! Syntax: " .. t[1] .. " [number 1-16]", PlayerIndex)
            end
        end
    end
    return response
end

function HealPlayer(Player, PlayerIndex)
    local player_object = get_dynamic_player(Player)
    if (player_object ~= 0) then
        local health = read_float(player_object + 0xE0)
        if health < 1 then
            local vehicleId = read_dword(player_object + 0x11C)
            if vehicleId == nil then
                local x, y, z = GetPlayerCoords(player_object)
                local healthpack = spawn_object("eqip", "powerups\\health pack", x, y, z + 0.5)
                if healthpack ~= nil then write_float(get_object_memory(healthpack) + 0x70, -2) end
            else
                write_float(player_object + 0xE0, 1)
            end            
            if tonumber(get_var(PlayerIndex, "$n")) == Player then
                respond("You have healed yourself!", PlayerIndex)
            else
                respond("You have healed " .. name, PlayerIndex)
                respond("You have been healed by " .. Executor, Player)
            end
        else
            if tonumber(get_var(PlayerIndex, "$n")) == Player then
                respond("You are already at full health! ", PlayerIndex)
            else
                respond(name .. " is already at full health", PlayerIndex)
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
            cprint("Response to: " .. get_var(PlayerIndex, "$name"), 4+8)
            cprint(Command, 2+8)
            rprint(PlayerIndex, Command)
            note = string.format('[COMMAND-HEAL] -->> ' .. get_var(PlayerIndex, "$name") .. ': ' .. Command)
            execute_command("log_note \""..note.."\"")
        else
            cprint(Command, 2+8)
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

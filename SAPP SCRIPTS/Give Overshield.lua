--[[
    Script Name: Give Overshield, for SAPP | (PC\CE)
    Implementing API version: 1.11.0.0

    Description: Give yourself (or others) an overshiled
                 Minimum admin level required is 1 by default.

                 Command Syntax:
                                    /os [player# 1-16]
                                    /os me

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
COMMAND = "os"

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
                if index ~= nil and index > 0 and index < 17 then
                    receiver = get_var(index, "$name")
                    executor = get_var(PlayerIndex, "$name")
                    if player_present(index) then
                        GiveOvershield(index, PlayerIndex)
                    else
                        respond("Invalid Player Index!", PlayerIndex)
                    end
                end
            else
                respond("Invalid Syntax: /" .. COMMAND .. " me | [player# 1-16]", PlayerIndex)
            end
        end
    end
    return response
end

function GiveOvershield(index, PlayerIndex)
    local player_object = get_dynamic_player(index)
    if (player_object ~= 0) then
        local shields = read_float(player_object + 0xE4)
        if shields <= 1 then
            local vehicleId = read_dword(player_object + 0x11C)
            if vehicleId == nil then
                local x, y, z = GetPlayerCoords(player_object)
                local overshield = spawn_object("eqip", "powerups\\over shield", x, y, z + 0.5)
                if overshield ~= nil then
                    write_float(get_object_memory(overshield) + 0x70, -2)
                end
            else
                write_float(player_object + 0xE4, 3)
            end
            if tonumber(get_var(PlayerIndex, "$n")) == index then
                respond("You have given yourself an overshield", PlayerIndex)
                local obj_shields = read_float(player_object + 0xE4)
                local obj_max_shields = read_float(player_object + 0xDC)
                obj_shields = round(obj_shields * 100)
                obj_max_shields = round(obj_shields * obj_max_shields)
                respond("Shields: " .. obj_shields .. "% (" .. obj_max_shields .. ")", PlayerIndex)
            else
                respond("You have given " .. receiver .. " an Over-Shield", PlayerIndex)
                respond(executor .. " has given you an Over-Shield", index)
                respond("Shields: " .. obj_shields .. "% (" .. obj_max_shields .. ")", index)
            end
        else
            if tonumber(get_var(PlayerIndex, "$n")) == index then
                respond("You already have an Over-Shield", PlayerIndex)
            else
                respond(receiver .. " already has an Over-Shield", PlayerIndex)
            end
        end
    end
end

function round(val, decimal)
    if (decimal) then
        return math.floor((val * 10 ^ decimal) + 0.5) /(10 ^ decimal)
    else
        return math.floor(val + 0.5)
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

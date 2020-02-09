--[[
--======================================================================================================--
Script Name: Race Assistant (v1.0), for SAPP (PC & CE)
Description: N/A ...

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [Starts] -----------
local warning_message = "[Not in Vehicle] - Warning, you will be killed in %seconds% seconds. Warnings Left: %current%/%total%"
local on_kill = "You were killed because you were not racing in a vehicle"
local warnings = 2 -- Consecutive Warnings
local punishment = "k" -- Valid Actions: "k" = kick, "b" = ban, "crash"
local time_until_warn = 90 -- In seconds
local time_until_kill = 120 -- In seconds
-- Configuration [Ends] -----------


-- Do Not Touch --
local players = {}
local time_scale, game_started = 0.03333333333333333
local floor, gsub = math.floor, string.gsub

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    if (get_var(0, "$gt") ~= "n/a") then
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

function OnGameStart()
    game_started = true
end

function OnGameEnd()
    game_started = false
end

function OnPlayerSpawn(PlayerIndex)
    players[PlayerIndex].seconds, players[PlayerIndex].warn = 0, true
end

function OnTick()
    if (game_started) then
        for player, params in pairs(players) do
            if (player) then
                if player_present(player) and player_alive(player) then
                    local DynamicPlayer = get_dynamic_player(player)
                    if (DynamicPlayer ~= 0) then
                        if not InVehicle(player, DynamicPlayer) then

                            params.seconds = params.seconds + time_scale
                            if (params.seconds > time_until_warn) and (params.warn) then
                                params.warn = false
                                params.warnings = params.warnings - 1

                                local time_remaining = floor((time_until_kill - params.seconds)) + 1
                                local msg = gsub(gsub(gsub(warning_message,
                                        "%%seconds%%", time_remaining),
                                        "%%current%%", params.warnings),
                                        "%%total%%", warnings)

                                say(player, msg)
                            elseif (params.seconds >= time_until_kill) then
                                if (params.warnings <= 0) then
                                    execute_command(tostring(punishment) .. " " .. player)
                                else
                                    execute_command("kill " .. player)
                                    say(player, on_kill)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnPlayerDisconnect(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function InitPlayer(PlayerIndex, reset)
    if (reset) then
        players[PlayerIndex] = {}
    else
        players[PlayerIndex] = { seconds = 0, warn = true, warnings = warnings }
    end
end

function InVehicle(PlayerIndex, DynamicPlayer)
    if player_alive(PlayerIndex) then
        local VehicleID = read_dword(DynamicPlayer + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            return false
        else
            if (players[PlayerIndex].warn) then
                players[PlayerIndex].seconds = 0
            end
            return true
        end
    end
    return false
end

function OnScriptUnload()
    -- N/A
end
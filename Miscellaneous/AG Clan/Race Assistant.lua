--[[
--======================================================================================================--
Script Name: Race Assistant (v1.2), for SAPP (PC & CE)
Description: This script will monitor all players and ensure they are all racing.
             Players who are not in a vehicle will be warned after "time_until_warn" seconds.
             After "time_until_kill" seconds the player will be killed.

             Players get a maximum of 5 warnings by default.
             If their warnings are depleted the player will be punished (kicked by default)

             Note: "time_until_warn" and "time_until_kill" can be edited in the config section.

             Change Log: Added

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [Starts] ----------------------------------------------------------------------------------------
local actions = { -- Only one action can be enabled at a time.
    ["take_weapons"] = {
        enabled = true,
        warning = "[Not in Vehicle] - Warning, your weapons will be taken in %seconds% seconds. Warnings Left: %current%/%total%",
        on_action = "Your weapons have been taken away because you were not racing"
    },
    ["kill"] = {
        enabled = false,
        warning = "[Not in Vehicle] - Warning, you will be killed in %seconds% seconds. Warnings Left: %current%/%total%",
        on_action = "You were killed because you were not racing in a vehicle"
    }
}

local warnings = 5 -- Warnings per game

-- If true players will be kicked or banned after 5 repeat warnings.
local severe_punishment = true
local punishment = "k" -- Valid Actions: "k" = kick, "b" = ban (severe_punishment must be enabled)

local time_until_warn = 90 -- In seconds
local time_until_kill = 120 -- In seconds

-- If true admins will be exempt from action taken against them (including warnings)
local ignore_admins = true
-- Admins who are this level (or above) will be exempt (ignore_admins must be enabled)
local min_level = 1
-- Configuration [Ends] ----------------------------------------------------------------------------------------

-- Do Not Touch --
local players = {}
local time_scale, game_started = 0.03333333333333333
local floor, gsub = math.floor, string.gsub

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    if (get_var(0, "$gt") ~= "n/a") then
        if RegisterSAPPEvents() then
            for i = 1, 16 do
                if player_present(i) then
                    local ignore = (tonumber(get_var(i, "$lvl")) >= min_level and ignore_admins)
                    if (not ignore) then
                        InitPlayer(i, false)
                    end
                end
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        RegisterSAPPEvents()
    end
end

function OnGameEnd()
    game_started = false
end

function OnTick()
    if (game_started) then
        for player, params in pairs(players) do
            if (player) then
                if player_present(player) and player_alive(player) then
                    local DynamicPlayer = get_dynamic_player(player)
                    if (DynamicPlayer ~= 0) then
                        if not InVehicle(player, DynamicPlayer) then

                            if (params.init) then
                                params.seconds = params.seconds + time_scale
                                if (params.seconds > time_until_warn) and (params.warn) then
                                    params.warn = false
                                    params.warnings = params.warnings - 1

                                    local _, action = GetAction()
                                    local time_remaining = floor((time_until_kill - params.seconds)) + 1
                                    local msg = gsub(gsub(gsub(action.warning,
                                            "%%seconds%%", time_remaining),
                                            "%%current%%", params.warnings),
                                            "%%total%%", warnings)

                                    say(player, msg)
                                elseif (params.seconds >= time_until_kill) then
                                    local Type, action = GetAction()
                                    if (Type == "kill") then
                                        execute_command("kill " .. player)
                                    elseif (Type == "take_weapons") then
                                        params.init = false
                                        execute_command("wdel " .. player)
                                    end

                                    if (params.warnings <= 0 and severe_punishment) then
                                        execute_command(tostring(punishment) .. " " .. player)
                                    else
                                        say(player, action.on_action)
                                    end
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
    local ignore = (tonumber(get_var(PlayerIndex, "$lvl")) >= min_level and ignore_admins)
    if (not ignore) then
        InitPlayer(PlayerIndex, false)
    end
end

function OnPlayerSpawn(PlayerIndex)
    if (players[PlayerIndex]) then
        players[PlayerIndex].seconds, players[PlayerIndex].init, players[PlayerIndex].warn = 0, true, true
    end
end

function OnPlayerDisconnect(PlayerIndex)
    if (players[PlayerIndex]) then
        InitPlayer(PlayerIndex, true)
    end
end

function InitPlayer(PlayerIndex, reset)
    if (reset) then
        players[PlayerIndex] = {}
    else
        players[PlayerIndex] = { seconds = 0, init = true, warn = true, warnings = warnings }
    end
end

function GetAction()
    for k, v in pairs(actions) do
        if (v.enabled) then
            return k, v
        end
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

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
    local Type, _ = GetAction()
    if (players[PlayerIndex] and Type == "take_weapons") then
        if (not players[PlayerIndex].init) then
            execute_command("wdel " .. PlayerIndex)
        end
    end
end

function RegisterSAPPEvents()
    if (get_var(0, "$gt") == "race") then
        game_started = true
        register_callback(cb["EVENT_TICK"], "OnTick")
        register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
        register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
        register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
        register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
        register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
        return true
    else
        game_started = false
        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_SPAWN'])
        unregister_callback(cb['EVENT_LEAVE'])
        unregister_callback(cb['EVENT_GAME_END'])
        unregister_callback(cb['EVENT_WEAPON_PICKUP'])
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
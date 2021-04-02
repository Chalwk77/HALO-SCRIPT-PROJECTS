--[[
--======================================================================================================--
Script Name: Race Assistant (v1.3), for SAPP (PC & CE)
Description: This script will monitor all players and ensure they are all racing.
             Players who are not in a vehicle will be warned after "time_until_warn" seconds.
             After "time_until_kill" seconds the player will be killed.

             Players get a maximum of 5 warnings by default.
             If their warnings are depleted the player will be punished (kicked by default)

Copyright (c) 2020-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

api_version = "1.12.0.0"

-- config starts --
local actions = { -- Only one action can be enabled at a time.
    ["kill"] = {
        enabled = true,
        warning = "[Not in Vehicle] - Warning, you will be killed in %seconds% seconds. Warnings Left: %current%/%total%",
        on_action = "You were killed because you were not racing in a vehicle"
    },
    ["take_weapons"] = {
        enabled = false,
        warning = "[Not in Vehicle] - Warning, your weapons will be taken in %seconds% seconds. Warnings Left: %current%/%total%",
        on_action = "Your weapons have been taken away because you were not racing"
    }
}

local warnings = 5 -- Warnings per game

-- If true players will be kicked or banned after 5 repeat warnings.
local severe_punishment = true
local punishment = "k" -- Valid Actions: "k" = kick, "b" = ban (severe_punishment must be enabled)

local time_until_warn = 90 -- In seconds
local time_until_kill = 180 -- In seconds

-- If true admins will be exempt from action taken against them (including warnings)
local ignore_admins = true

-- Admins who are this level (or above) will be exempt (ignore_admins must be enabled)
local min_level = 1
-- config ends -

local players = { }
local time_scale, game_started = 1 / 30
local floor, gsub = math.floor, string.gsub

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    OnGameStart()
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        if RegisterSAPPEvents() then
            for i = 1, 16 do
                if player_present(i) then
                    CheckIgnore(i)
                end
            end
        end
    end
end

function OnGameEnd()
    game_started = false
end

local function GetAction()
    for k, v in pairs(actions) do
        if (v.enabled) then
            return k, v
        end
    end
end

local function InitPlayer(Ply, Reset)
    if (not Reset) then
        players[Ply] = {
            seconds = 0,
            init = true,
            warn = true,
            warnings = warnings
        }
    else
        players[Ply] = nil
    end
end

function OnTick()
    if (game_started) then
        for i, v in pairs(players) do
            if player_present(i) then
                local DyN = get_dynamic_player(i)
                if (DyN ~= 0) then
                    if not InVehicle(i, DyN) then

                        if (v.init) then
                            v.seconds = v.seconds + time_scale
                            if (v.seconds > time_until_warn) and (v.warn) then
                                v.warn = false
                                v.warnings = v.warnings - 1

                                local _, action = GetAction()
                                local time_remaining = floor((time_until_kill - v.seconds)) + 1
                                local msg = gsub(gsub(gsub(action.warning,
                                        "%%seconds%%", time_remaining),
                                        "%%current%%", v.warnings),
                                        "%%total%%", warnings)

                                say(i, msg)
                            elseif (v.seconds >= time_until_kill) then
                                local Type, action = GetAction()
                                if (Type == "kill") then
                                    execute_command("kill " .. i)
                                elseif (Type == "take_weapons") then
                                    execute_command("wdel " .. i)
                                end
                                v.init = false
                                if (v.warnings <= 0 and severe_punishment) then
                                    execute_command(tostring(punishment) .. " " .. i)
                                else
                                    say(i, action.on_action)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function CheckIgnore(Ply)
    local ignore = (tonumber(get_var(Ply, "$lvl")) >= min_level and ignore_admins)
    if (not ignore) then
        InitPlayer(Ply, false)
    end
end

function OnPlayerConnect(Ply)
    CheckIgnore(Ply)
end

function OnPlayerSpawn(Ply)
    if (players[Ply]) then
        players[Ply].seconds = 0
        players[Ply].init = true
        players[Ply].warn = true
    end
end

function OnPlayerDisconnect(Ply)
    InitPlayer(Ply, true)
end

function InVehicle(Ply, DyN)
    local VehicleID = read_dword(DyN + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        return false
    else
        if (players[Ply].warn) then
            players[Ply].seconds = 0
        end
        return true
    end
    return false
end

function OnWeaponPickup(Ply, _, _)
    if (not players[Ply].init and GetAction() == "take_weapons") then
        execute_command("wdel " .. Ply)
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
        cprint("[Race Assistant] The current game mode is not RACE. Script will not work!", 12)
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
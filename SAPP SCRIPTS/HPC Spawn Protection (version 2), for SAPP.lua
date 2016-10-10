--[[
Script Name: HPC Spawn Protection (version 2), for SAPP
- Implementing API version: 1.11.0.0

    Description: By default, you will spawn with invisibility(7s), godmode(7s), and a speed boost(7s/1.3+) for every 10 consecutive deaths.

    This script will allow you to:
        - optionally turn on:
            * temporary godmode (invulnerability)
            * temporary speed boost + define amount to boost by, (1.3 by default)
            * temporary invisibility
        
    There are two modes:
        Mode 1 uses a method based on 'consecutive deaths'. 
        If this setting is enabled, for every 10 consecutive deaths you have, you will spawn with the defined attributes.
            
        Mode 2 uses a similar method based on a Death Counter in increments of 10, 15 and 20 through 135+.
            
    TO DO:
        - Detect if Killer is camping
        - Punish Killer
        * Suggestions? https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues/5

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
]]

api_version = "1.11.0.0"

-- Configuration--
local settings = {
    ["UseBasedOnDeathCount"] = false,
    ["UseConsecutiveDeaths"] = true,
    ["UseCamo"] = true,
    ["UseSpeedBoost"] = true,
    ["UseInvulnerability"] = true,
}

-- attributes given every 10 deaths, (victim)
ConsecutiveDeaths = 10

-- Normal running speed
ResetSpeedTo = 1.0
-- Amount to boost by
SpeedBoost = 1.3
-- Speedboost activation time (in seconds)
SpeedDuration = 7.0
-- Godmode activation time (in seconds)
Invulnerable = 7.0
-- Camo activation time (in seconds)
CamoTime = 7.0
-- Configuration Ends --

-- Only edit these values if you know what you're doing!
-- If Victim has exactly this many deaths, he will spawn with protection.
_10_Deaths = 10
_20_Deaths = 20
_30_Deaths = 30
_45_Deaths = 45
_60_Deaths = 60
_75_Deaths = 75
_75_Deaths = 95
_75_Deaths = 115
_75_Deaths = 135

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
end

function OnScriptUnload() end

DEATHS = { }

function OnPlayerJoin(PlayerIndex)
    DEATHS[PlayerIndex] = { 0 }
end

function OnPlayerLeave(PlayerIndex)
    DEATHS[PlayerIndex] = { 0 }
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local victim = tonumber(VictimIndex)
    local killer = tonumber(KillerIndex)
    if (killer > 0) then
        DEATHS[victim][1] = DEATHS[victim][1] + 1
    end
end

function ApplyCamo(PlayerIndex)
    execute_command("camo me " .. CamoTime, PlayerIndex)
end

function Invulnerability(PlayerIndex)
    timer(Invulnerable * 1000, "ResetInvulnerability", PlayerIndex)	
    execute_command("god me", PlayerIndex)
end

function GiveSpeedBoost(PlayerIndex)
    timer(SpeedDuration * 1000, "ResetPlayerSpeed", PlayerIndex)
    local PlayerIndex = tonumber(PlayerIndex)
    local victim = get_player(PlayerIndex)
    if (player_present(PlayerIndex)) then
        write_float(victim + 0x6C, SpeedBoost)
    end
end

function ResetPlayerSpeed(PlayerIndex)
    local PlayerIndex = tonumber(PlayerIndex)
    local victim = get_player(PlayerIndex)
    if (player_present(PlayerIndex)) then
        write_float(victim + 0x6C, ResetSpeedTo)
    end
end

function ResetInvulnerability(PlayerIndex)
	execute_command("ungod me", PlayerIndex)
	return false
end

function CheckSettings(PlayerIndex)
    if (player_present(PlayerIndex)) then
        execute_command("msg_prefix \"\"")
        say(PlayerIndex, "You have received Spawn Protection!")
        execute_command("msg_prefix \"**SERVER** \"")
        if settings["UseCamo"] then
            timer(0, "ApplyCamo", PlayerIndex)
        end
        if settings["UseSpeedBoost"] then 
            GiveSpeedBoost(PlayerIndex)
        end
        if settings["UseInvulnerability"] then
            Invulnerability(PlayerIndex)
        end
    end
end


function OnPlayerSpawn(PlayerIndex)
    if PlayerIndex then
        if settings["UseConsecutiveDeaths"] and not settings["UseBasedOnDeathCount"] then
            if DEATHS[PlayerIndex][1] == ConsecutiveDeaths then
                CheckSettings(PlayerIndex)
                DEATHS[PlayerIndex][1] = 0
                if settings["UseCamo"] == false and settings["UseSpeedBoost"] == false and settings["UseInvulnerability"] == false then
                    local note = string.format("[SCRIPT ERROR] Spawn Protection - You don't have any sub-settings enabled for UseConsecutiveDeaths!")
                    cprint("[SCRIPT ERROR] Spawn Protection - You don't have any sub-settings enabled for UseConsecutiveDeaths!", 4+8)
                    execute_command("log_note \""..note.."\"")
                return false
                end
            end
        end
        if settings["UseBasedOnDeathCount"] and not settings["UseConsecutiveDeaths"] then
            if DEATHS[PlayerIndex][1] == _10_Deaths then
                CheckSettings(PlayerIndex)
                elseif DEATHS[PlayerIndex][1] == _20_Deaths then
                CheckSettings(PlayerIndex)
                elseif DEATHS[PlayerIndex][1] == _30_Deaths then
                CheckSettings(PlayerIndex)
                elseif DEATHS[PlayerIndex][1] == _45_Deaths then
                CheckSettings(PlayerIndex)
                elseif DEATHS[PlayerIndex][1] == _60_Deaths then
                CheckSettings(PlayerIndex)
                elseif DEATHS[PlayerIndex][1] == _75_Deaths then
                CheckSettings(PlayerIndex)
                elseif DEATHS[PlayerIndex][1] == _95_Deaths then
                CheckSettings(PlayerIndex)
                elseif DEATHS[PlayerIndex][1] == _115_Deaths then
                CheckSettings(PlayerIndex)
                elseif DEATHS[PlayerIndex][1] == _135_Deaths then
                CheckSettings(PlayerIndex)
            end
            if settings["UseCamo"] == false and settings["UseSpeedBoost"] == false and settings["UseInvulnerability"] == false then
                local note = string.format("[SCRIPT ERROR] Spawn Protection - You don't have any sub-settings enabled for UseBasedOnDeathCount!")
                cprint("[SCRIPT ERROR] Spawn Protection - You don't have any sub-settings enabled for UseBasedOnDeathCount!", 4+8)
                execute_command("log_note \""..note.."\"")
            return false
            end
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end

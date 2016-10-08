--[[
Script Name: HPC Spawn Protection (version 2), for SAPP
- Implementing API version: 1.11.0.0

    Description: By default, you will spawn with invisibility/Godmode/speedboost for 5 seconds for every 10 consecutive deaths.
    
    This script will allow you to:
        - optionally turn on:
            * temporary godmode (invulnerability)
            * temporary speed boost
            * temporary invisibility
        
        There are two modes:
            Mode 1 uses a method based on 'consecutive deaths'. 
            If this setting is enabled, for every 10 consecutive deaths you have, you will spawn with the defined attributes.
            
            Mode 2 uses a similar method based on a Death Counter in increments of 5.
            If this mode is enabled, by default you will receive the defined attributes for every 5 deaths.
            
    Default configuration is listed at the bottom of this script.

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
]]

api_version = "1.11.0.0"

-- Configuration--
local settings = {
    ["UseConsecutiveDeaths"] = true,
    ["UseBasedOnDeathCount"] = false,
    ["UseCamo"] = true,
    ["UseInvulnerability"] = true,
    ["UseSpeedBoost"] = true,
}

ConsecutiveDeaths = 10

-- Normal running speed
ResetSpeedTo = 1.0
-- Amount to boost by
SpeedBoost = 1.3
-- Speedboost activation time (in seconds)
SpeedDuration = 5
-- Godmode activation time (in seconds)
Invulnerable = 5
-- Camo activation time (in seconds)
CamoTime = 5
-- Configuration Ends --

-- Only edit these values if you know what you're doing!
_5_Deaths = 5
_10_Deaths = 10
_15_Deaths = 15
_20_Deaths = 20
_25_Deaths = 25
_30_Deaths = 30
_35_Deaths = 35
_40_Deaths = 40
_45_Deaths = 45
_50_Deaths = 50

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
    execute_command("camo me " ..CamoTime, PlayerIndex)
end

function Invulnerability(PlayerIndex)
    timer(Invulnerable * 1000, "ResetInvulnerability", PlayerIndex)	
    execute_command_sequence("god me;s me 1.75;hp me +2", PlayerIndex)
end

function GiveSpeedBoost(PlayerIndex)
    timer(SpeedDuration*1000, "ResetPlayerSpeed", PlayerIndex)
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

function InvulnerableRemove(PlayerIndex)
	execute_command("ungod me", PlayerIndex)
	return false
end

function OnPlayerSpawn(PlayerIndex)
    if PlayerIndex then
        if settings["UseConsecutiveDeaths"] and not settings["UseBasedOnDeathCount"] then
            if DEATHS[PlayerIndex][1] == ConsecutiveDeaths then
                if settings["UseCamo"] then
                -- Using a timer here beacuse the player cannot pick up an active camouflage before or after 'CamoTime' has deactivated
                -- if you call ApplyCamo immediately after they spawn. There has to be some delay for whatever reason.
                    timer(0, "ApplyCamo", PlayerIndex)
                end
                if settings["UseSpeedBoost"] then 
                    GiveSpeedBoost(PlayerIndex)
                end
                if settings["UseInvulnerability"] then
                    Invulnerability(PlayerIndex)
                end
                DEATHS[PlayerIndex][1] = 0
                say(PlayerIndex, "You have received Spawn Protection!")
                if settings["UseCamo"] == false and settings["UseSpeedBoost"] == false and settings["UseInvulnerability"] == false then
                local note = string.format("[SCRIPT ERROR] Spawn Protection - You don't have any settings enabled for UseConsecutiveDeaths!")
                cprint("[SCRIPT ERROR] Spawn Protection - You don't have any settings enabled for UseConsecutiveDeaths!", 4+8)
                execute_command("log_note \""..note.."\"")
                return false
                end
            end
        end
        if settings["UseBasedOnDeathCount"] and not settings["UseConsecutiveDeaths"] then
            if DEATHS[PlayerIndex][1] == _5_Deaths then
                if settings["UseCamo"] then timer(0, "ApplyCamo", PlayerIndex) end
            elseif DEATHS[PlayerIndex][1] == _10_Deaths then
                if settings["UseCamo"] then timer(0, "ApplyCamo", PlayerIndex) end
            elseif DEATHS[PlayerIndex][1] == _15_Deaths then
                if settings["UseCamo"] then timer(0, "ApplyCamo", PlayerIndex) end
            elseif DEATHS[PlayerIndex][1] == _20_Deaths then
                if settings["UseCamo"] then timer(0, "ApplyCamo", PlayerIndex) end
            elseif DEATHS[PlayerIndex][1] == _25_Deaths then
                if settings["UseCamo"] then timer(0, "ApplyCamo", PlayerIndex) end
            elseif DEATHS[PlayerIndex][1] == _30_Deaths then
                if settings["UseCamo"] then timer(0, "ApplyCamo", PlayerIndex) end
            elseif DEATHS[PlayerIndex][1] == _35_Deaths then
                if settings["UseCamo"] then timer(0, "ApplyCamo", PlayerIndex) end
            elseif DEATHS[PlayerIndex][1] == _40_Deaths then
                if settings["UseCamo"] then timer(0, "ApplyCamo", PlayerIndex) end
            elseif DEATHS[PlayerIndex][1] == _45_Deaths then
                if settings["UseCamo"] then timer(0, "ApplyCamo", PlayerIndex) end
            elseif DEATHS[PlayerIndex][1] == _50_Deaths then
                if settings["UseCamo"] then timer(0, "ApplyCamo", PlayerIndex) end
                if settings["UseSpeedBoost"] then 
                    GiveSpeedBoost(PlayerIndex)
                end
                if settings["UseInvulnerability"] then
                    Invulnerability(PlayerIndex)
                end
            end
            say(PlayerIndex, "You have received Spawn Protection!")
            if settings["UseCamo"] == false and settings["UseSpeedBoost"] == false and settings["UseInvulnerability"] == false then
            local note = string.format("[SCRIPT ERROR] Spawn Protection - You don't have any settings enabled for UseBasedOnDeathCount!")
            cprint("[SCRIPT ERROR] Spawn Protection - You don't have any settings enabled for UseBasedOnDeathCount!", 4+8)
            execute_command("log_note \""..note.."\"")
            return false
            end
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end

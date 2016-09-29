--[[
Script Name: HPC Spawn Protection, for SAPP
- Implementing API version: 1.11.0.0

    Description: By default, you will spawn with a Camouflage and OverShield after 7 Consecutive Deaths.
                 - You will also receive temporary godmode, and a speed boost. (optional)
                 - Speedboost and godmode last for 5 seconds by default. (editable) 
    
    This script will allow you to:
        - optionally turn on temporary 'godmode' or (invulnerability)
        - optionally turn on temporary speed boost.
        
        There are two modes to this script.
            The First mode uses a method based on 'consecutive deaths'. 
            If this setting is enabled, for every 7 consecutive deaths you have, you will spawn with special attributes.
            
            The second mode uses a method based on a Death Counter in increments of 5.
            If this mode is enabled, by default you will receive special attributes for every 5 deaths.
        
Suggestions?
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues/5

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
]]

api_version = "1.11.0.0"

-- Configuration--
UseConsecutiveDeaths = true
UseBasedOnDeathCount = false
UseInvulnerability = true
UseSpeedBoost = true
ConsecutiveDeaths = 7

-- Normal running speed
NormalSpeed = 1.0
-- Amount to boost by
SpeedBoost = 2.5
-- Speedboost activation time (in seconds)
SpeedDuration = 5
-- Godmode activation time (in seconds)
Invulnerable = 5
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
LOCATION = { }
for i = 1, 16 do LOCATION[i] = { } end
OverShield = "powerups\\over shield"
Camouflage = "powerups\\active camouflage"

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

function Invulnerability(PlayerIndex)
    local PlayerIndex = tonumber(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_present(PlayerIndex)) then
        write_float(player_object + 0xE0, 999999)
    end
end

function GiveSpeedBoost(PlayerIndex)
    local PlayerIndex = tonumber(PlayerIndex)
    local victim = get_player(PlayerIndex)
    if (player_present(PlayerIndex)) then
        write_float(victim + 0x6C, SpeedBoost)
    end
end

function ResetPlayerSpeed(PlayerIndex)
    local PlayerIndex = tonumber(PlayerIndex)
    local victim = get_player(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_present(PlayerIndex)) then
        write_float(victim + 0x6C, NormalSpeed)
    end
end

function ResetInvulnerability(PlayerIndex)
    local PlayerIndex = tonumber(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_present(PlayerIndex)) then
        write_float(player_object + 0xE0, 1)
        write_float(player_object + 0xE4, 1)
    end
end

function MessagePlayer(PlayerIndex)
    local PlayerIndex = tonumber(PlayerIndex)
    if (player_present(PlayerIndex)) then
        rprint(PlayerIndex, "|c>-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<")
        rprint(PlayerIndex, "|c**Spawn Protection**")
        rprint(PlayerIndex, "|cYou have received an OverShield and Camouflage.")
        if UseInvulnerability then 
            rprint(PlayerIndex, "|cYou are invulnerable for " ..Invulnerable.. " seconds.")
        end
        if UseSpeedBoost then 
            rprint(PlayerIndex, "|cYou have speed boost for " ..SpeedDuration.. " seconds.")
        end
        rprint(PlayerIndex, "|c>-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<")
        rprint(PlayerIndex, "|n")
        rprint(PlayerIndex, "|n")
        rprint(PlayerIndex, "|n")
        rprint(PlayerIndex, "|n")
        rprint(PlayerIndex, "|n")
        rprint(PlayerIndex, "|n")
        rprint(PlayerIndex, "|n")
        rprint(PlayerIndex, "|n")
    end
end

function OnPlayerSpawn(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    local xAxis, yAxis, zAxis = read_vector3d(player_object + 0x5C)
    LOCATION[PlayerIndex][1] = xAxis
    LOCATION[PlayerIndex][2] = yAxis
    LOCATION[PlayerIndex][3] = zAxis
    if PlayerIndex then
        if UseConsecutiveDeaths and not UseBasedOnKills then
            if DEATHS[PlayerIndex][1] == ConsecutiveDeaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
                DEATHS[PlayerIndex][1] = 0
                if UseSpeedBoost then 
                    GiveSpeedBoost(PlayerIndex)
                    timer(SpeedDuration*1000, "ResetPlayerSpeed", PlayerIndex)
                end
                if UseInvulnerability then
                    Invulnerability(PlayerIndex)
                    timer(Invulnerable*1000, "ResetInvulnerability", PlayerIndex)
                end
                MessagePlayer(PlayerIndex)
            end
        end
        if UseBasedOnDeathCount and not UseConsecutiveDeaths then
            if DEATHS[PlayerIndex][1] == _5_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
            elseif DEATHS[PlayerIndex][1] == _10_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
            elseif DEATHS[PlayerIndex][1] == _15_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
            elseif DEATHS[PlayerIndex][1] == _20_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
            elseif DEATHS[PlayerIndex][1] == _25_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
            elseif DEATHS[PlayerIndex][1] == _30_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
            elseif DEATHS[PlayerIndex][1] == _35_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
            elseif DEATHS[PlayerIndex][1] == _40_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
            elseif DEATHS[PlayerIndex][1] == _45_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
            elseif DEATHS[PlayerIndex][1] == _50_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
                MessagePlayer(PlayerIndex)
            end
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end

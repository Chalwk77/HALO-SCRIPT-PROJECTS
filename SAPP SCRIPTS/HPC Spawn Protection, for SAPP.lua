--[[
Script Name: HPC Spawn Protection, for SAPP
- Implementing API version: 1.11.0.0

    Description: For every 7 consecutive deaths, your victim will spawn with an overshield and camouflage.

        [!] To Do:
            -->> Detect if Killer is camping
            -->> DelayTimer (between deaths) for another future update
            -->> Punish Killer?
            -->> Other editable attributes?
Suggestions?
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues/5

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
]]

api_version = "1.11.0.0"

UseConsecutiveDeaths = true
UseBasedOnDeathCount = false
-- For every 7 consecutive deaths, your victim will spawn with an overshield and camouflage.
-- Kill Count resets every 7 deaths.
ConsecutiveDeaths = 7

-- Deaths are in increments of 5
-- After exactly 5 Deaths, your victim will spawn with an overshield and camouflage
-- After exactly 10 Deaths, your victim will spawn with an overshield and camouflage, and so on.
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
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.")
                execute_command("msg_prefix \"** SAPP ** \"")
                DEATHS[PlayerIndex][1] = 0
            end
        end
        if UseBasedOnDeathCount and not UseConsecutiveDeaths then
            if DEATHS[PlayerIndex][1] == _5_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.")
                execute_command("msg_prefix \"** SAPP ** \"")
            elseif DEATHS[PlayerIndex][1] == _10_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.")
                execute_command("msg_prefix \"** SAPP ** \"")
            elseif DEATHS[PlayerIndex][1] == _15_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.")
                execute_command("msg_prefix \"** SAPP ** \"")
            elseif DEATHS[PlayerIndex][1] == _20_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.")
                execute_command("msg_prefix \"** SAPP ** \"")
            elseif DEATHS[PlayerIndex][1] == _25_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.")
                execute_command("msg_prefix \"** SAPP ** \"")
            elseif DEATHS[PlayerIndex][1] == _30_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.")
                execute_command("msg_prefix \"** SAPP ** \"")
            elseif DEATHS[PlayerIndex][1] == _35_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.")
                execute_command("msg_prefix \"** SAPP ** \"")
            elseif DEATHS[PlayerIndex][1] == _40_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.")
                execute_command("msg_prefix \"** SAPP ** \"")
            elseif DEATHS[PlayerIndex][1] == _45_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.")
                execute_command("msg_prefix \"** SAPP ** \"")
            elseif DEATHS[PlayerIndex][1] == _50_Deaths then
                spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5)
                spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5)
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.")
                execute_command("msg_prefix \"** SAPP ** \"")
            end
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end
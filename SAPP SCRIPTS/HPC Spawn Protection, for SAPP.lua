--[[
Script Name: HPC Spawn Protection, for SAPP
- Implementing API version: 1.11.0.0

    Description: After 5,9,14,17 and 21 consecutive deaths, your victim will spawn with an overshield and camouflage.

        [!] To Do:
            -->> Detect if Killer is camping
            -->> DelayTimer (between deaths)
            -->> Punish Killer
            -->> Other editable attributes
Suggestions?
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues/5

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
]]

api_version = "1.11.0.0"

function OnScriptUnload() end

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
end

ConsecutiveDeaths = 7

DEATHS = { }
VICTIM_LOCATION = { }
for i = 1, 16 do VICTIM_LOCATION[i] = { } end
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
        if killer then
            if DEATHS[killer][1] ~= 0 then
                DEATHS[killer][1] = 0
            end
        end
    end
end

function OnPlayerSpawn(PlayerIndex)
    local victimName = tostring(get_var(PlayerIndex, "$name"))
    local player = get_player(PlayerIndex)
    local rotation = read_float(player + 0x138)
    local player_object = get_dynamic_player(PlayerIndex)
    local xAxis, yAxis, zAxis = read_vector3d(player_object + 0x5C)
    VICTIM_LOCATION[PlayerIndex][1] = xAxis
    VICTIM_LOCATION[PlayerIndex][2] = yAxis
    VICTIM_LOCATION[PlayerIndex][3] = zAxis
    if PlayerIndex then
        if DEATHS[PlayerIndex][1] == ConsecutiveDeaths then
            spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5, rotation)
            spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5, rotation)
            execute_command("msg_prefix \"\"")
            say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.")
            execute_command("msg_prefix \"** SAPP ** \"")
            DEATHS[PlayerIndex][1] = 0
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end
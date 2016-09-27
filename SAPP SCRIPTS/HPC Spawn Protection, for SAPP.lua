--[[
Script Name: HPC Spawn Protection, for SAPP
- Implementing API version: 1.11.0.0

    Description: After 5,9,14,17 and 21 consecutive deaths, your victim will spawn with an overshield and camouflage.

        [!] To Do:
            Detect if Killer is camping
            Write a DelayTimer between victim deaths
            Punish Killer
            Other special Attributes?
            * Suggestions? Email me.
To Do list: https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues/5

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

deaths = {
    ["ProtectAfter[5]Deaths"] = 5,
    ["ProtectAfter[9]Deaths"] = 9,
    ["ProtectAfter[13]Deaths"] = 13,
    ["ProtectAfter[17]Deaths"] = 17,
    ["ProtectAfter[21]Deaths"] = 21,
}

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
    local player_object = get_dynamic_player(PlayerIndex)
    local xAxis, yAxis, zAxis = read_vector3d(player_object + 0x5C)
    local player = get_player(PlayerIndex)
    local rotation = read_float(player + 0x138)
    VICTIM_LOCATION[PlayerIndex][1] = xAxis
    VICTIM_LOCATION[PlayerIndex][2] = yAxis
    VICTIM_LOCATION[PlayerIndex][3] = zAxis
    if PlayerIndex then
        if DEATHS[PlayerIndex][1] == deaths["ProtectAfter[1]Deaths"] then
            spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5, rotation)
            spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5, rotation)
            execute_command("msg_prefix \"\"")
            say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.", false)
            execute_command("msg_prefix \"** SAPP ** \"")
        elseif DEATHS[PlayerIndex][1] == deaths["ProtectAfter[2]Deaths"] then
            spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5, rotation)
            spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5, rotation)
            execute_command("msg_prefix \"\"")
            say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.", false)
            execute_command("msg_prefix \"** SAPP ** \"")
        elseif DEATHS[PlayerIndex][1] == deaths["ProtectAfter[3]Deaths"] then
            spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5, rotation)
            spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5, rotation)
            execute_command("msg_prefix \"\"")
            say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.", false)
            execute_command("msg_prefix \"** SAPP ** \"")
        elseif DEATHS[PlayerIndex][1] == deaths["ProtectAfter[4]Deaths"] then
            spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5, rotation)
            spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5, rotation)
            execute_command("msg_prefix \"\"")
            say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.", false)
            execute_command("msg_prefix \"** SAPP ** \"")
        elseif DEATHS[PlayerIndex][1] == deaths["ProtectAfter[5]Deaths"] then
            spawn_object("eqip", OverShield, xAxis, yAxis, zAxis + 0.5, rotation)
            spawn_object("eqip", Camouflage, xAxis, yAxis, zAxis + 0.5, rotation)
            execute_command("msg_prefix \"\"")
            say(PlayerIndex, "[!] Spawn Protection: You have been given an OverShield and Camouflage.", false)
            execute_command("msg_prefix \"** SAPP ** \"")
        end
    end
    DEATHS[PlayerIndex][1] = 0
end

function OnError(Message)
    print(debug.traceback())
end

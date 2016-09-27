--[[
Script Name: HPC Spawn Where Killed, for SAPP
- Implementing API version: 1.11.0.0

    Description: You will spawn where you died...

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
]]

api_version = "1.11.0.0"
DEATH_LOCATION = { }

for i = 1, 16 do DEATH_LOCATION[i] = { } end
function OnScriptUnload() end

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local victim = tonumber(VictimIndex)
    local killer = tonumber(KillerIndex)
    if (killer == -1) then
        local player_object = get_dynamic_player(victim)
        local xAxis, yAxis, zAxis = read_vector3d(player_object + 0x5C)
        DEATH_LOCATION[victim][1] = xAxis
        DEATH_LOCATION[victim][2] = yAxis
        DEATH_LOCATION[victim][3] = zAxis
    end
end

function OnPlayerLeave(VictimIndex)
    local victim = tonumber(VictimIndex)
    for i = 1, 3 do
        DEATH_LOCATION[victim][i] = nil
    end
end

function OnPlayerSpawn(VictimIndex)
    local victim = tonumber(VictimIndex)
    if victim then
        if DEATH_LOCATION[victim][1] ~= nil and DEATH_LOCATION[victim][2] ~= nil then
            write_vector3d(get_dynamic_player(victim) + 0x5C, DEATH_LOCATION[victim][1], DEATH_LOCATION[victim][2], DEATH_LOCATION[victim][3])
            for i = 1, 3 do
                DEATH_LOCATION[victim][i] = nil
            end
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end
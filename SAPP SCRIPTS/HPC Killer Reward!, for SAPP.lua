--[[
    ------------------------------------
Script Name: HPC Killer Reward!, for SAPP
    - Implementing API version: 1.11.0.0

Description: This script will drop a special item from the EQUIPMENT_TABLE at the victims death location.

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.11.0.0"

VICTIM_LOCATION = { }
EQUIPMENT_TABLE = { }
EQUIPMENT_TABLE[1] = "powerups\\active camouflage"
EQUIPMENT_TABLE[2] = "powerups\\health pack"
EQUIPMENT_TABLE[3] = "powerups\\over shield"
EQUIPMENT_TABLE[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
EQUIPMENT_TABLE[5] = "powerups\\needler ammo\\needler ammo"
EQUIPMENT_TABLE[6] = "powerups\\pistol ammo\\pistol ammo"
EQUIPMENT_TABLE[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
EQUIPMENT_TABLE[8] = "powerups\\shotgun ammo\\shotgun ammo"
EQUIPMENT_TABLE[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
EQUIPMENT_TABLE[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
EQUIPMENT_TABLE[11] = "powerups\\double speed"
EQUIPMENT_TABLE[12] = "powerups\\full-spectrum vision"

for i = 1, 16 do VICTIM_LOCATION[i] = { } end

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
end

function OnScriptUnload() end

function OnPlayerDeath(VictimIndex, KillerIndex)

    local victim = tonumber(VictimIndex)
    local killer = tonumber(KillerIndex)
    local kills = tonumber(get_var(KillerIndex, "$kills"))
    local player_object = get_dynamic_player(VictimIndex)
    if victim and killer ~= KillerIndex then
        if (kills == 10) then
            -- Equal to 10 Kills
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
        elseif (kills == 20) then
            -- Equal to 20 Kills
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
        elseif (kills == 30) then
            -- Equal to 30 Kills
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
        elseif (kills == 40) then
            -- Equal to 40 Kills
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
        elseif (kills == 50) then
            -- Equal to 50 Kills
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
        elseif (kills == 60) then
            -- Equal to 60 Kills
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
        elseif (kills == 70) then
            -- Equal to 70 Kills
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
        elseif (kills == 80) then
            -- Equal to 80 Kills
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
        elseif (kills == 90) then
            -- Equal to 90 Kills
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
        elseif (kills >= 100) then
            -- Equal to or greater than 100 kills
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
        end
    end
end

function DropTable(victim, x, y, z)
    itemtoDrop = EQUIPMENT_TABLE[math.random(0, #EQUIPMENT_TABLE - 1)]
    local player = get_player(victim)
    local rotation = read_float(player + 0x138)
    spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
end

function OnError(Message)
    print(debug.traceback())
end

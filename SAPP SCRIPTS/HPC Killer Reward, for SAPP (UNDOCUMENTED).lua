--[[
Script Name: HPC Killer Reward, for SAPP (UNDOCUMENTED)
    - Implementing API version: 1.11.0.0

Description: This script will drop a random item from an EQUIPMENT TABLE at the victims death location.

*** DOCUMENTATION ***
    - If you would prefer to view a documented version of this script, please visit:
    https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/SAPP%20SCRIPTS/HPC%20Killer%20Reward%2C%20for%20SAPP%20(DOCUMENTED).lua

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
--]]

api_version = "1.11.0.0"

BasedOnMap = false
BasedOnGameType = false
NonGlobalKillsRequired = false
GlobalSettings = true
GlobalNoKills = true

VICTIM_LOCATION = { }

GLOBAL_EQUIPMENT_TABLE = { }
GLOBAL_EQUIPMENT_TABLE[1] = "powerups\\active camouflage"
GLOBAL_EQUIPMENT_TABLE[2] = "powerups\\health pack"
GLOBAL_EQUIPMENT_TABLE[3] = "powerups\\over shield"
GLOBAL_EQUIPMENT_TABLE[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
GLOBAL_EQUIPMENT_TABLE[5] = "powerups\\needler ammo\\needler ammo"
GLOBAL_EQUIPMENT_TABLE[6] = "powerups\\pistol ammo\\pistol ammo"
GLOBAL_EQUIPMENT_TABLE[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
GLOBAL_EQUIPMENT_TABLE[8] = "powerups\\shotgun ammo\\shotgun ammo"
GLOBAL_EQUIPMENT_TABLE[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
GLOBAL_EQUIPMENT_TABLE[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
GLOBAL_EQUIPMENT_TABLE[11] = "weapons\\assault rifle\\assault rifle"
GLOBAL_EQUIPMENT_TABLE[12] = "weapons\\flamethrower\\flamethrower"
GLOBAL_EQUIPMENT_TABLE[13] = "weapons\\needler\\mp_needler"
GLOBAL_EQUIPMENT_TABLE[14] = "weapons\\pistol\\pistol"
GLOBAL_EQUIPMENT_TABLE[15] = "weapons\\plasma pistol\\plasma pistol"
GLOBAL_EQUIPMENT_TABLE[16] = "weapons\\plasma rifle\\plasma rifle"
GLOBAL_EQUIPMENT_TABLE[17] = "weapons\\plasma_cannon\\plasma_cannon"
GLOBAL_EQUIPMENT_TABLE[18] = "weapons\\rocket launcher\\rocket launcher"
GLOBAL_EQUIPMENT_TABLE[19] = "weapons\\shotgun\\shotgun"
GLOBAL_EQUIPMENT_TABLE[20] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_BLOODGULCH = { }
MAP_EQ_TABLE_BLOODGULCH[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_BLOODGULCH[2] = "powerups\\health pack"
MAP_EQ_TABLE_BLOODGULCH[3] = "powerups\\over shield"
MAP_EQ_TABLE_BLOODGULCH[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_BLOODGULCH[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_BLOODGULCH[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_BLOODGULCH[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_BLOODGULCH[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_BLOODGULCH[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_BLOODGULCH[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

MAP_EQ_TABLE_RATRACE = { }
MAP_EQ_TABLE_RATRACE[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_RATRACE[2] = "powerups\\health pack"
MAP_EQ_TABLE_RATRACE[3] = "powerups\\over shield"
MAP_EQ_TABLE_RATRACE[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_RATRACE[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_RATRACE[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_RATRACE[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_RATRACE[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_RATRACE[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_RATRACE[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

GAMETYPE_EQ_TABLE_BLOODGULCH = { }
GAMETYPE_EQ_TABLE_BLOODGULCH[1] = "powerups\\active camouflage"
GAMETYPE_EQ_TABLE_BLOODGULCH[2] = "powerups\\health pack"
GAMETYPE_EQ_TABLE_BLOODGULCH[3] = "powerups\\over shield"
GAMETYPE_EQ_TABLE_BLOODGULCH[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
GAMETYPE_EQ_TABLE_BLOODGULCH[5] = "powerups\\needler ammo\\needler ammo"
GAMETYPE_EQ_TABLE_BLOODGULCH[6] = "powerups\\pistol ammo\\pistol ammo"
GAMETYPE_EQ_TABLE_BLOODGULCH[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
GAMETYPE_EQ_TABLE_BLOODGULCH[8] = "powerups\\shotgun ammo\\shotgun ammo"
GAMETYPE_EQ_TABLE_BLOODGULCH[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
GAMETYPE_EQ_TABLE_BLOODGULCH[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

GAMETYPE_EQ_TABLE_RATRACE = { }
GAMETYPE_EQ_TABLE_RATRACE[1] = "powerups\\active camouflage"
GAMETYPE_EQ_TABLE_RATRACE[2] = "powerups\\health pack"
GAMETYPE_EQ_TABLE_RATRACE[3] = "powerups\\over shield"
GAMETYPE_EQ_TABLE_RATRACE[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
GAMETYPE_EQ_TABLE_RATRACE[5] = "powerups\\needler ammo\\needler ammo"
GAMETYPE_EQ_TABLE_RATRACE[6] = "powerups\\pistol ammo\\pistol ammo"
GAMETYPE_EQ_TABLE_RATRACE[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
GAMETYPE_EQ_TABLE_RATRACE[8] = "powerups\\shotgun ammo\\shotgun ammo"
GAMETYPE_EQ_TABLE_RATRACE[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
GAMETYPE_EQ_TABLE_RATRACE[10] = "powerups\\flamethrower ammo\\flamethrower ammo"

for i = 1, 16 do VICTIM_LOCATION[i] = { } end

function LoadMaps()
    mapnames = {
        "beavercreek",
        "bloodgulch",
        "boardingaction",
        "carousel",
        "chillout",
        "damnation",
        "dangercanyon",
        "deathisland",
        "gephyrophobia",
        "hangemhigh",
        "icefields",
        "infinity",
        "longest",
        "prisoner",
        "putput",
        "ratrace",
        "sidewinder",
        "timberland",
        "wizard"
    }
    map_name = get_var(1, "$map")
    mapnames[map_name] = mapnames[map_name] or false
end

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    if get_var(0, "$gt") ~= "n/a" then
        game_started = true
        map_name = get_var(1, "$map")
        game_type = get_var(0, "$gt")
        LoadMaps()
    end
end

function OnScriptUnload() end

function OnNewGame()
    game_started = true
end

function OnGameEnd()
    game_started = false
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local victim = tonumber(VictimIndex)
    local killer = tonumber(KillerIndex)
    local kills = tonumber(get_var(killer, "$kills"))
    local player_object = get_dynamic_player(victim)

    if killer == victim then
        return false
    elseif (killer == 0) then
        return false
    elseif (killer == -1) then
        return false
    elseif (killer == nil) then
        return false
    end

    if game_started == true then
        if NonGlobalKillsRequired == true then
            if killer and victim ~= nil then
                if (killer > 0) then
                    if (kills == 10) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 20) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 30) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 40) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 50) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 60) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 70) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 80) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills == 90) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)

                    elseif (kills >= 100) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        DropTable(victim, x, y, z)
                    end
                end
            end
        elseif NonGlobalKillsRequired == false and GlobalSettings == true and GlobalNoKills == true then
            if (killer > 0) then
                local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local tag_id = "eqip" or "weap"
                spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)
                cprint("doing something")
            end
        elseif NonGlobalKillsRequired == false and GlobalSettings == true and GlobalNoKills == false then
            if (killer > 0) then
                if (kills == 10) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local tag_id = "eqip" or "weap"
                    spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                elseif (kills == 20) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local tag_id = "eqip" or "weap"
                    spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                elseif (kills == 30) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local tag_id = "eqip" or "weap"
                    spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                elseif (kills == 40) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local tag_id = "eqip" or "weap"
                    spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                elseif (kills == 50) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local tag_id = "eqip" or "weap"
                    spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                elseif (kills == 60) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local tag_id = "eqip" or "weap"
                    spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                elseif (kills == 70) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local tag_id = "eqip" or "weap"
                    spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                elseif (kills == 80) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local tag_id = "eqip" or "weap"
                    spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                elseif (kills == 90) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local tag_id = "eqip" or "weap"
                    spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                elseif (kills >= 100) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local tag_id = "eqip" or "weap"
                    spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)
                end
            end
        end
    end
end

function DropTable(victim, x, y, z)

    if BasedOnMap == true and BasedOnGameType == false then
        if map_name == "bloodgulch" then
            itemtoDrop = MAP_EQ_TABLE_BLOODGULCH[math.random(0, #MAP_EQ_TABLE_BLOODGULCH - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            local tag_id = "eqip" or "weap"
            spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)
        elseif map_name == "ratrace" then
            itemtoDrop = MAP_EQ_TABLE_RATRACE[math.random(0, #MAP_EQ_TABLE_RATRACE - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            local tag_id = "eqip" or "weap"
            spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)
        end
    end

    if BasedOnGameType == true and BasedOnMap == false then
        if game_type == "ctf" then
            itemtoDrop = GAMETYPE_EQ_TABLE_BLOODGULCH[math.random(0, #GAMETYPE_EQ_TABLE_BLOODGULCH - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            local tag_id = "eqip" or "weap"
            spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)
        elseif game_type == "slayer" then
            itemtoDrop = GAMETYPE_EQ_TABLE_RATRACE[math.random(0, #GAMETYPE_EQ_TABLE_RATRACE - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            local tag_id = "eqip" or "weap"
            spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end
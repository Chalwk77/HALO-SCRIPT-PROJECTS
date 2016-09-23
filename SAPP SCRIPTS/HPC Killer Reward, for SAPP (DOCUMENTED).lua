--[[
    ------------------------------------
Script Name: HPC Killer Reward, for SAPP (DOCUMENTED)
    - Implementing API version: 1.11.0.0
    
Description: This script will drop a random item from an EQUIPMENT TABLE at the victims death location.


*** DOCUMENTATION ***
    - If you would prefer to view a UN-documented version of this script, please visit:
    https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/SAPP%20SCRIPTS/HPC%20Killer%20Reward!%2C%20for%20SAPP%20(DOCUMENTED).lua
      
      
-- Five Settings available:

[1] BasedOnMap
[2] BasedOnGameType
[3] NonGlobalKillsRequired
[4] GlobalSettings
[5] GlobalNoKills

    Currently, settings [1] and [2] cannot be used in conjunction with global settings.
    Settings [1] and [2] are used independently. This might change in a future [enhancement] update.
    
    * BasedOnMap:           Script will pull random items from the MAP EQUIPMENT TABLE.
    * BasedOnGameType:      Script will pull random items from the GAMETYPE EQUIPMENT TABLE.
    * GlobalSettings:       Script will pull random items from the GLOBAL EQUIPMENT TABLE
    * GlobalNoKills:         Toggle on\off required-kill-threshold
    
    The current configuration of this script is set up so the 'Killer' has to reach a required kill-threshold in order for his victim to
    drop an item from (global) EQUIPMENT_TABLE drop table.
    
    You can turn on|off (true/false) a setting called 'GlobalNoKills'. 
    
    - If true, the Killer will have to reach 10 kills first, and only then will his victim drop an item. 
    - Then after 20 kills, his victim will drop another item and so on. 
    - You can change these values in the OnPlayerDeath function.
    
    If 'GlobalNoKills' is set to "false", the victim will indefinitely drop an item from the GLOBAL EQUIPMENT TABLE.
    - GlobalNoKills cannot be used in conjunction with BasedOnMap, and BasedOnGameType.
    
Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

-- Do Not Touch!
api_version = "1.11.0.0"

BasedOnMap = false
BasedOnGameType = false
NonGlobalKillsRequired = false
-- Global Settings do not take into account the gametype or map.
GlobalSettings = true
GlobalNoKills = false

-- Do Not Touch!
VICTIM_LOCATION = { }

-- =====================================================================================================--

-- Global Settings --
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

-- Based On Map --
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

-- Based On Map --
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

-- Based on Game-Type --
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

-- Based on Game-Type --
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
-- =====================================================================================================--

-- Do Not Touch!
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
    -- Do Not Touch!
    game_started = true
end

function OnGameEnd()
    -- Do Not Touch!
    game_started = false
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    -- victim = Victim? (Player who died).
    local victim = tonumber(VictimIndex)
    -- killer = Killer? (Player whom killed the Victim - RIP!!).
    local killer = tonumber(KillerIndex)
    -- kills = retrieves the value of how many kills the Killer has under their belt, (so-to-speak).
    local kills = tonumber(get_var(killer, "$kills"))
    local player_object = get_dynamic_player(victim)

    -- Suicide
    if killer == victim then
        return false
    -- Killed by Vehicle
    elseif (killer == 0) then
        return false
    -- Killed by Server
    elseif (killer == -1) then
        return false
    -- Killer is unknown
    elseif (killer == nil) then
        return false
    end

    if game_started == true then
        if NonGlobalKillsRequired == true then
            -- Check if killer and victim are valid.
            if killer and victim ~= nil then
                -- Killed by another player.
                if (killer > 0) then
                    -- Equal to 10 Kills.
                    if (kills == 10) then
                        -- Get victim Coordinates.
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        -- Call DropTable Function.
                        DropTable(victim, x, y, z)

                        -- Equal to 20 Kills.
                    elseif (kills == 20) then
                        -- Get victim Coordinates.
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        -- Call DropTable Function.
                        DropTable(victim, x, y, z)

                        -- Equal to 30 Kills.
                    elseif (kills == 30) then
                        -- Get victim Coordinates.
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        -- Call DropTable Function.
                        DropTable(victim, x, y, z)

                        -- Equal to 40 Kills.
                    elseif (kills == 40) then
                        -- Get victim Coordinates.
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        -- Call DropTable Function.
                        DropTable(victim, x, y, z)

                        -- Equal to 50 Kills.
                    elseif (kills == 50) then
                        -- Get victim Coordinates.
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        -- Call DropTable Function
                        DropTable(victim, x, y, z)

                        -- Equal to 60 Kills.
                    elseif (kills == 60) then
                        -- Get victim Coordinates.
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        -- Call DropTable Function.
                        DropTable(victim, x, y, z)

                        -- Equal to 70 Kills.
                    elseif (kills == 70) then
                        -- Get victim Coordinates.
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        -- Call DropTable Function.
                        DropTable(victim, x, y, z)

                        -- Equal to 80 Kills.
                    elseif (kills == 80) then
                        -- Get victim Coordinates.
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        -- Call DropTable Function.
                        DropTable(victim, x, y, z)

                        -- Equal to 90 Kills.
                    elseif (kills == 90) then
                        -- Get victim Coordinates.
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        -- Call DropTable Function
                        DropTable(victim, x, y, z)

                        -- Equal to or greater than 100 kills.
                    elseif (kills >= 100) then
                        -- Get victim Coordinates.
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        -- Call DropTable Function
                        DropTable(victim, x, y, z)
                        -- Global Settings --
                    end
                end
            end
        -- Kills NOT Required, and uses Global Equipment Table (does not take into account the gametype or map)
        elseif NonGlobalKillsRequired == false and GlobalSettings == true and GlobalNoKills == true then
          -- Killed by another player.
          if (killer > 0) then 
            -- Get victim Coordinates.
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            local tag_id = "eqip" or "weap"
            -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
            spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)
          end
        -- Kills Required, and uses Global Equipment Table (does not take into account the gametype or map)
        elseif NonGlobalKillsRequired == false and GlobalSettings == true and GlobalNoKills == false then
            if (killer > 0) then
                if (kills == 10) then
                -- Get victim Coordinates.
                local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local tag_id = "eqip" or "weap"
                -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
                spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                -- Equal to 20 Kills.
            elseif (kills == 20) then
                -- Get victim Coordinates.
                local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local tag_id = "eqip" or "weap"
                -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
                spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                -- Equal to 30 Kills.
            elseif (kills == 30) then
                -- Get victim Coordinates.
                local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local tag_id = "eqip" or "weap"
                -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
                spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                -- Equal to 40 Kills.
            elseif (kills == 40) then
                -- Get victim Coordinates.
                 local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local tag_id = "eqip" or "weap"
                -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
                spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                -- Equal to 50 Kills.
            elseif (kills == 50) then
                -- Get victim Coordinates.
                local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local tag_id = "eqip" or "weap"
                -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
                spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                -- Equal to 60 Kills.
            elseif (kills == 60) then
                -- Get victim Coordinates.
                local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local tag_id = "eqip" or "weap"
                -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
                spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                -- Equal to 70 Kills.
            elseif (kills == 70) then
                -- Get victim Coordinates.
                local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local tag_id = "eqip" or "weap"
                -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
                spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                -- Equal to 80 Kills.
            elseif (kills == 80) then
                -- Get victim Coordinates.
                local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local tag_id = "eqip" or "weap"
                -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
                spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                -- Equal to 90 Kills.
            elseif (kills == 90) then
                -- Get victim Coordinates.
                local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local tag_id = "eqip" or "weap"
                -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
                spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)

                -- Equal to or greater than 100 kills.
            elseif (kills >= 100) then
                -- Get victim Coordinates.
                local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                itemtoDrop = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local tag_id = "eqip" or "weap"
                -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
                spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)
                end
            end
        end
    end
end

function DropTable(victim, x, y, z)

    -- Based On Map --
    -- Used when BasedOnMap is true, but BasedOnGameType and GlobalSettings must be set to false.
    if BasedOnMap == true and BasedOnGameType == false then
        -- Check if map is bloodgulch.
        if map_name == "bloodgulch" then
            -- pick 1 of (up to 20) random items from the respective table.
            itemtoDrop = MAP_EQ_TABLE_BLOODGULCH[math.random(0, #MAP_EQ_TABLE_BLOODGULCH - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            local tag_id = "eqip" or "weap"
            -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
            spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)
            -- Check if map is ratrace.
        elseif map_name == "ratrace" then
            -- pick 1 of (up to 20) random items from the respective table.
            itemtoDrop = MAP_EQ_TABLE_RATRACE[math.random(0, #MAP_EQ_TABLE_RATRACE - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            local tag_id = "eqip" or "weap"
            -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
            spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)
        end
    end

    -- Based on Game-Type --
    -- Used when BasedOnGameType is true, but BasedOnMap, and GlobalSettings must be set to false.
    if BasedOnGameType == true and BasedOnMap == false then
        -- Check if gametype is CTF.
        if game_type == "ctf" then
            -- pick 1 of (up to 20) random items from the respective table.
            itemtoDrop = GAMETYPE_EQ_TABLE_BLOODGULCH[math.random(0, #GAMETYPE_EQ_TABLE_BLOODGULCH - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            local tag_id = "eqip" or "weap"
            -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
            spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)
            -- Check if gametype is slayer.
        elseif game_type == "slayer" then
            -- pick 1 of (up to 20) random items from the respective table.
            itemtoDrop = GAMETYPE_EQ_TABLE_RATRACE[math.random(0, #GAMETYPE_EQ_TABLE_RATRACE - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            local tag_id = "eqip" or "weap"
            -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
            spawn_object(tag_id, itemtoDrop, x, y, z + 0.5, rotation)
        end
    end
end

-- Do Not Touch!
function OnError(Message)
    print(debug.traceback())
end

--[[

    -- Equipment --
"eqip", "powerups\\active camouflage"
"eqip", "powerups\\health pack"
"eqip", "powerups\\over shield"
"eqip", "powerups\\assault rifle ammo\\assault rifle ammo"
"eqip", "powerups\\needler ammo\\needler ammo"
"eqip", "powerups\\pistol ammo\\pistol ammo"
"eqip", "powerups\\rocket launcher ammo\\rocket launcher ammo"
"eqip", "powerups\\shotgun ammo\\shotgun ammo"
"eqip", "powerups\\sniper rifle ammo\\sniper rifle ammo"
"eqip", "powerups\\flamethrower ammo\\flamethrower ammo"

    -- Weapons --
"weap", "weapons\\assault rifle\\assault rifle"
"weap", "weapons\\flamethrower\\flamethrower"
"weap", "weapons\\needler\\mp_needler"
"weap", "weapons\\pistol\\pistol"
"weap", "weapons\\plasma pistol\\plasma pistol"
"weap", "weapons\\plasma rifle\\plasma rifle"
"weap", "weapons\\plasma_cannon\\plasma_cannon"
"weap", "weapons\\rocket launcher\\rocket launcher"
"weap", "weapons\\shotgun\\shotgun"
"weap", "weapons\\sniper rifle\\sniper rifle"

]]
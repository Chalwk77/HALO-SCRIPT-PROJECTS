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

globalsettings = true
BasedOnMap = false
BasedOnGameType = false

VICTIM_LOCATION = { }

-- Global Settings -- 
-- Used when BasedOnMap and BasedOnGameType are both false
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

-- Based On Map --
--Used when BasedOnMap is true, but BasedOnGameType must be false
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
MAP_EQ_TABLE_BLOODGULCH[11] = "powerups\\double speed"
MAP_EQ_TABLE_BLOODGULCH[12] = "powerups\\full-spectrum vision"

-- Based On Map --
--Used when BasedOnMap is true, but BasedOnGameType must be false
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
MAP_EQ_TABLE_RATRACE[11] = "powerups\\double speed"
MAP_EQ_TABLE_RATRACE[12] = "powerups\\full-spectrum vision"

-- Based on Game-Type --
-- Used when BasedOnGameType is true, but BasedOnMap must be false
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
GAMETYPE_EQ_TABLE_BLOODGULCH[11] = "powerups\\double speed"
GAMETYPE_EQ_TABLE_BLOODGULCH[12] = "powerups\\full-spectrum vision"

-- Based on Game-Type --
-- Used when BasedOnGameType is true, but BasedOnMap must be false
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
GAMETYPE_EQ_TABLE_RATRACE[11] = "powerups\\double speed"
GAMETYPE_EQ_TABLE_RATRACE[12] = "powerups\\full-spectrum vision"

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
    map_name = get_var(1, "$map")
    game_type = get_var(0, "$gt")
    LoadMaps()
end

function OnScriptUnload() end

function OnPlayerDeath(VictimIndex, KillerIndex)

    local victim = tonumber(VictimIndex)
    local killer = tonumber(KillerIndex)
    local kills = tonumber(get_var(killer, "$kills"))
    local player_object = get_dynamic_player(victim)
    
    -- Check if killer and victim are valid.
    if killer and victim ~= nil then
            -- Equal to 10 Kills
        if (kills == 10) then
        -- Get Player Coordinates
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
            -- Equal to 20 Kills
        elseif (kills == 20) then
        -- Get Player Coordinates
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
            -- Equal to 30 Kills
        elseif (kills == 30) then
        -- Get Player Coordinates
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
            -- Equal to 40 Kills
        elseif (kills == 40) then
        -- Get Player Coordinates
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
            -- Equal to 50 Kills
        elseif (kills == 50) then
        -- Get Player Coordinates
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
            -- Equal to 60 Kills
        elseif (kills == 60) then
        -- Get Player Coordinates
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
            -- Equal to 70 Kills
        elseif (kills == 70) then
        -- Get Player Coordinates
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
            -- Equal to 80 Kills
        elseif (kills == 80) then
        -- Get Player Coordinates
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
            -- Equal to 90 Kills
        elseif (kills == 90) then
        -- Get Player Coordinates
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
            -- Equal to or greater than 100 kills
        elseif (kills >= 100) then
        -- Get Player Coordinates
            local x, y, z = read_vector3d(player_object + 0x5C)
            VICTIM_LOCATION[victim][1] = x
            VICTIM_LOCATION[victim][2] = y
            VICTIM_LOCATION[victim][3] = z
            DropTable(victim, x, y, z)
        end
    end
end

function DropTable(victim, x, y, z)
    
-- Based On Map --
--Used when BasedOnMap is true, but BasedOnGameType must be false
    if BasedOnMap == true and BasedOnGameType == false then 
        -- Check if map is bloodgulch
        if map_name == "bloodgulch" then
            -- pick 1 of 12 random items from the respective table
            itemtoDrop = MAP_EQ_TABLE_BLOODGULCH[math.random(0, #MAP_EQ_TABLE_BLOODGULCH - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            -- Summon random <item> from respective equipment table at the coordinates of the victims death location
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
    -- Check if map is ratrace
    elseif map_name == "ratrace" then
    -- pick 1 of 12 random items from the respective table
    itemtoDrop = MAP_EQ_TABLE_RATRACE[math.random(0, #MAP_EQ_TABLE_RATRACE - 1)]
        local player = get_player(victim)
        local rotation = read_float(player + 0x138)
        -- Summon random <item> from respective equipment table at the coordinates of the victims death location
        spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        end
    end

-- Based on Game-Type --
-- Used when BasedOnGameType is true, but BasedOnMap must be false
    if BasedOnGameType == true and BasedOnMap == false then 
        -- Check if gametype is CTF
        if game_type == "ctf" then
            -- pick 1 of 12 random items from the respective table
            itemtoDrop = GAMETYPE_EQ_TABLE_BLOODGULCH[math.random(0, #GAMETYPE_EQ_TABLE_BLOODGULCH - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            -- Summon random <item> from respective equipment table at the coordinates of the victims death location
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
            -- Check if gametype is slayer
    elseif game_type == "slayer" then
            -- pick 1 of 12 random items from the respective table
            itemtoDrop = GAMETYPE_EQ_TABLE_RATRACE[math.random(0, #GAMETYPE_EQ_TABLE_RATRACE - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            -- Summon random <item> from respective equipment table at the coordinates of the victims death location
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        end
    end
    
 
-- Global Settings -- 
-- Used when BasedOnMap and BasedOnGameType are both false
    if globalsettings == true then
        if BasedOnGameType == false and BasedOnMap == false then 
            -- pick 1 of 12 random items from the respective table
            itemtoDrop = EQUIPMENT_TABLE[math.random(0, #EQUIPMENT_TABLE - 1)]
            local player = get_player(victim)
            local rotation = read_float(player + 0x138)
            -- Summon random <item> from respective equipment table at the coordinates of the victims death location at the coordinates of the victims death location
            spawn_object("eqip", itemtoDrop, x, y, z + 0.5, rotation)
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end

--[[
    
    -- Equipment --
"eqip", "powerups\\active camouflage"
"eqip", "powerups\\health pack"
"eqip", "powerups\\over shield"
"eqip", "powerups\\double speed"
"eqip", "powerups\\full-spectrum vision"
"eqip", "weapons\\frag grenade\\frag grenade"
"eqip", "weapons\\plasma grenade\\plasma grenade"
"eqip", "powerups\\assault rifle ammo\\assault rifle ammo"
"eqip", "powerups\\needler ammo\\needler ammo"
"eqip", "powerups\\pistol ammo\\pistol ammo"
"eqip", "powerups\\rocket launcher ammo\\rocket launcher ammo"
"eqip", "powerups\\shotgun ammo\\shotgun ammo"
"eqip", "powerups\\sniper rifle ammo\\sniper rifle ammo"
"eqip", "powerups\\flamethrower ammo\\flamethrower ammo"

    -- Weapons --
"weap", "weapons\\assault rifle\\assault rifle"
"weap", "weapons\\ball\\ball"
"weap", "weapons\\flag\\flag"
"weap", "weapons\\flamethrower\\flamethrower"
"weap", "weapons\\gravity rifle\\gravity rifle"
"weap", "weapons\\needler\\mp_needler"
"weap", "weapons\\pistol\\pistol"
"weap", "weapons\\plasma pistol\\plasma pistol"
"weap", "weapons\\plasma rifle\\plasma rifle"
"weap", "weapons\\plasma_cannon\\plasma_cannon"
"weap", "weapons\\rocket launcher\\rocket launcher"
"weap", "weapons\\shotgun\\shotgun"
"weap", "weapons\\sniper rifle\\sniper rifle"
    
]]

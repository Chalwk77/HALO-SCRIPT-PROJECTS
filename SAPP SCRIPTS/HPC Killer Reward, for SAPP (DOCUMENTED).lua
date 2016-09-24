--[[
    ------------------------------------
Script Name: HPC Killer Reward, for SAPP (DOCUMENTED)
    - Implementing API version: 1.11.0.0

Description: This script will drop a random item from the respective Equipment/Weapon table at the victims death location.


*** DOCUMENTATION ***
    - If you would prefer to view a UN-documented version of this script, please visit:
    https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/SAPP%20SCRIPTS/HPC%20Killer%20Reward%2C%20for%20SAPP%20(UNDOCUMENTED).lua

-- Eight Settings available:

[1] BasedOnMap
[2] BasedOnGameType
[3] NonGlobalKillsRequired
[4] GlobalSettings
[5] GlobalNoKills

[!] These settings are used in conjunction with BasedOnMap and BasedOnGameType:
    [6] Weapons_And_Equipment = true
    [7] Just_Equipment = false
    [8] Just_Weapons = false


[!] Based on GameType now supports global settings.
    To use BasedOnGameType with global Settings, set the following to 'true': "GlobalSettings", "BasedOnGameType".
        - But set the following to 'false': "NonGlobalKillsRequired", "BasedOnMap".
        If you want to force the killer to reach a certain kill-threshold, set the follow to 'false': "GlobalNoKills".
        If you want the victim to drop something regardless of kills, set "GlobalNoKills" to 'true'.


        Global (BasedOnMap) will come in a future update!
        The only gamemodes currently supported are CTF and SLAYER.

    ** IMPORTANT **
    -   In order to use global settings, you must have NonGlobalKillsRequired set to false.
    -   Global Settings do not take into account the gametype or map.

    * BasedOnMap:           Script will pull random items from the respective MAP EQUIPMENT TABLE.
    * BasedOnGameType:      Script will pull random items from the respective GAMETYPE EQUIPMENT TABLE.
    * GlobalSettings:       Script will pull random items from the respective GLOBAL EQUIPMENT TABLE
    * GlobalNoKills:        Toggle on\off required-kill-threshold

    The current configuration of this script is set up so the 'Killer' has to reach a required kill-threshold in order for his victim to
    drop an item from (global) GLOBAL_EQUIPMENT_TABLE drop table.

    You can turn on|off (true/false) a setting called 'GlobalNoKills'.

    - If true, the Killer will have to reach 10 kills first, and only then will his victim drop an item.
    - Then after 20 kills, his victim will drop another item and so on.
    - You can change these values in the OnPlayerDeath function.

    If 'GlobalNoKills' is set to "false", the victim will indefinitely drop an item from the GLOBAL EQUIPMENT TABLE.
    - GlobalNoKills cannot be used in conjunction with BasedOnMap, and BasedOnGameType.



    true = Enabled
    false = Disabled


Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"

-- Configuration --
BasedOnMap = false
BasedOnGameType = false
-- [!] This must be true in order to use BasedOnMap or BasedOnGameType
NonGlobalKillsRequired = false
-- [!] Global Settings do not take into account the MAP, but it does support gametype
GlobalSettings = true
GlobalNoKills = true

-- [!] Used only for BasedOnMap, and BasedOnGameType
-- Item Set
Weapons_And_Equipment = true
Just_Equipment = false
Just_Weapons = false
-- Configuration Ends --

-- Do Not Touch!
weap = "weap"
eqip = "eqip"
GameHasStarted = false
VICTIM_LOCATION = { }
for i = 1, 16 do VICTIM_LOCATION[i] = { } end

function LoadMaps()
    if GameHasStarted then
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
end

function OnScriptLoad()
    -- >> register_callback: This function registers a function that will be called every time the event is called.
    -- >> You may only have one function registered per event.
    -- >> Callback IDs are in the cb global variable and are retrieved using cb[“EVENT_ID”].
    -- >> Ref: http://halo.isimaginary.com/lua_info/#register_callback
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    -- >> This function retrieves an event variable, or a custom variable set by var_add.
    -- >> Ref: http://halo.isimaginary.com/lua_info/#get_var
    if get_var(0, "$gt") ~= "n/a" then
        GameHasStarted = true
        map_name = get_var(1, "$map")
        game_type = get_var(0, "$gt")
        LoadMaps()
    end
end

function OnScriptUnload() end

function OnNewGame()
    -- Do Not Touch!
    GameHasStarted = true
    map_name = get_var(1, "$map")
    game_type = get_var(0, "$gt")
    if map_name == "beavercreek" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_BEAVERCREEK
            TableToUse2 = MAP_WEAPON_TABLE_BEAVERCREEK
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_BEAVERCREEK
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_BEAVERCREEK
        end
    elseif map_name == "bloodgulch" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_BLOODGULCH
            TableToUse2 = MAP_WEAPON_TABLE_BLOODGULCH
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_BLOODGULCH
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_BLOODGULCH
        end
    elseif map_name == "boardingaction" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_BOARDINGACTION
            TableToUse2 = MAP_WEAPON_TABLE_BOARDINGACTION
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_BOARDINGACTION
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_BOARDINGACTION
        end
    elseif map_name == "carousel" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_CAROUSEL
            TableToUse2 = MAP_WEAPON_TABLE_CAROUSEL
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_CAROUSEL
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_CAROUSEL
        end
    elseif map_name == "chillout" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_BEAVERCREEK
            TableToUse2 = MAP_WEAPON_TABLE_BEAVERCREEK
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_BEAVERCREEK
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_BEAVERCREEK
        end
    elseif map_name == "damnation" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_DAMNATION
            TableToUse2 = MAP_WEAPON_TABLE_DAMNATION
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_DAMNATION
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_DAMNATION
        end
    elseif map_name == "dangercanyon" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_DANGERCANYON
            TableToUse2 = MAP_WEAPON_TABLE_DANGERCANYON
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_DANGERCANYON
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_DANGERCANYON
        end
    elseif map_name == "deathisland" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_DEATHISLAND
            TableToUse2 = MAP_WEAPON_TABLE_DEATHISLAND
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_DEATHISLAND
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_DEATHISLAND
        end
    elseif map_name == "gephyrophobia" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_GEPHYROPHOBIA
            TableToUse2 = MAP_WEAPON_TABLE_GEPHYROPHOBIA
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_GEPHYROPHOBIA
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_GEPHYROPHOBIA
        end
    elseif map_name == "hangemhigh" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_HANGEMHIGH
            TableToUse2 = MAP_WEAPON_TABLE_HANGEMHIGH
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_HANGEMHIGH
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_HANGEMHIGH
        end
    elseif map_name == "icefields" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_ICEFIELDS
            TableToUse2 = MAP_WEAPON_TABLE_ICEFIELDS
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_ICEFIELDS
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_ICEFIELDS
        end
    elseif map_name == "infinity" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_INFINITY
            TableToUse2 = MAP_WEAPON_TABLE_INFINITY
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_INFINITY
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_INFINITY
        end
    elseif map_name == "longest" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_LONGEST
            TableToUse2 = MAP_WEAPON_TABLE_LONGEST
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_LONGEST
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_LONGEST
        end
    elseif map_name == "prisoner" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_PRISONER
            TableToUse2 = MAP_WEAPON_TABLE_PRISONER
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_PRISONER
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_PRISONER
        end
    elseif map_name == "putput" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_PUTPUT
            TableToUse2 = MAP_WEAPON_TABLE_PUTPUT
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_PUTPUT
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_PUTPUT
        end
    elseif map_name == "ratrace" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_RATRACE
            TableToUse2 = MAP_WEAPON_TABLE_RATRACE
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_RATRACE
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_RATRACE
        end
    elseif map_name == "sidewinder" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_SIDEWINDER
            TableToUse2 = MAP_WEAPON_TABLE_SIDEWINDER
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_SIDEWINDER
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_SIDEWINDER
        end
    elseif map_name == "timberland" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_TIMBERLAND
            TableToUse2 = MAP_WEAPON_TABLE_TIMBERLAND
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_TIMBERLAND
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_TIMBERLAND
        end
    elseif map_name == "wizard" then
        if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
            access = WAE
            TableToUse1 = MAP_EQ_TABLE_WIZARD
            TableToUse2 = MAP_WEAPON_TABLE_WIZARD
        elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
            access = JW
            TableToUse = MAP_WEAPON_TABLE_WIZARD
        elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
            access = JE
            TableToUse = MAP_EQ_TABLE_WIZARD
        end
    end
    -- ====================================GAME TYPE MODES====================================--
    -- =======================================================================================--
    if game_type == "ctf" then
        if BasedOnGameType == true and BasedOnMap == false then
            if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
                access = GT_WAE
                TableToUse1 = GAMETYPE_EQ_TABLE_CTF
                TableToUse2 = GAMETYPE_WEAPON_TABLE_CTF
            elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
                access = GT_JW
                TableToUse = GAMETYPE_WEAPON_TABLE_CTF
            elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
                access = GT_JE
                TableToUse = GAMETYPE_EQ_TABLE_CTF
            end
        end
    end
    if game_type == "slayer" then
        if BasedOnGameType == true and BasedOnMap == false then
            if Weapons_And_Equipment == true and Just_Equipment == false and Just_Weapons == false then
                access = GT_WAE
                TableToUse1 = GAMETYPE_EQ_TABLE_SLAYER
                TableToUse2 = GAMETYPE_WEAPON_TABLE_SLAYER
            elseif Just_Weapons == true and Weapons_And_Equipment == false and Just_Equipment == false then
                access = GT_JW
                TableToUse = GAMETYPE_WEAPON_TABLE_SLAYER
            elseif Just_Equipment == true and Just_Weapons == false and Weapons_And_Equipment == false then
                access = GT_JE
                TableToUse = GAMETYPE_EQ_TABLE_SLAYER
            end
        end
    end
end

function OnGameEnd()
    -- Do Not Touch!
    GameHasStarted = false
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    -- victim = Victim? (Player who died).
    local victim = tonumber(VictimIndex)
    -- killer = Killer? (Player whom killed the Victim - RIP!!).
    local killer = tonumber(KillerIndex)
    -- victimName = retrieves victim's Name
    local victimName = tostring(get_var(victim, "$name"))
    -- kills = retrieves the value of how many kills the Killer has under their belt, (so-to-speak).
    local kills = tonumber(get_var(killer, "$kills"))
    game_type = get_var(0, "$gt")

    -- >> Gets the player's object if the player is alive.
    -- >> Ref: http://halo.isimaginary.com/lua_info/#get_dynamic_player
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

    if GameHasStarted then
        if NonGlobalKillsRequired == true then
            -- Check if killer and victim are valid.
            if killer and victim ~= nil then
                -- Killed by another player.
                if (killer > 0) then
                    -- Equal to 10 Kills.
                    if (kills == 0) then
                        -- >> Get victim Coordinates.
                        -- >> Reads three 32-bit floats. This function retrieves three single-precision floating point numbers, or nil if failed
                        -- >> Ref: http://halo.isimaginary.com/lua_info/#read_vector3d
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        -- Call GameSettings Function.
                        GameSettings(victim, x, y, z)

                    elseif (kills == 20) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        GameSettings(victim, x, y, z)

                    elseif (kills == 30) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        GameSettings(victim, x, y, z)

                    elseif (kills == 40) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        GameSettings(victim, x, y, z)

                    elseif (kills == 50) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        GameSettings(victim, x, y, z)

                    elseif (kills == 60) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        GameSettings(victim, x, y, z)

                    elseif (kills == 70) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        GameSettings(victim, x, y, z)

                    elseif (kills == 80) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        GameSettings(victim, x, y, z)

                    elseif (kills == 90) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        GameSettings(victim, x, y, z)
                        -- Equal to or greater than 100 kills.
                    elseif (kills >= 100) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        GameSettings(victim, x, y, z)
                    end
                end
            end
            -- Kills NOT Required, and uses Global Equipment Table (does not take into account the gametype or map)
        elseif NonGlobalKillsRequired == false and GlobalSettings == true and GlobalNoKills == true then
            if (killer > 0) then
                local x, y, z = read_vector3d(player_object + 0x5C)
                VICTIM_LOCATION[victim][1] = x
                VICTIM_LOCATION[victim][2] = y
                VICTIM_LOCATION[victim][3] = z
                math.randomseed(os.time())
                -- pick 1 of (up to 20) random items from the respective table.
                local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                local player = get_player(victim)
                local rotation = read_float(player + 0x138)
                local eqTable = math.random(1, 2)
                if (tonumber(eqTable) == 1) then
                    -- Summon random <item> from respective equipment table at the coordinates of the victims death location.
                    -- >> This function spawns an object at the specified coordiantes.
                    -- >> If TagID is specified, then TagType and TagPath are not read and effectively become optional arguments.
                    -- >> It will return the Object ID of the spawned object.
                    -- >> Ref: http://halo.isimaginary.com/lua_info/#spawn_object
                    spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                elseif (tonumber(eqTable) == 2) then
                    spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                end
            end
            --     [!]      GAMETYPE GLOBAL SETTINGS --
            --     [!]      Kills NOT Required
        elseif NonGlobalKillsRequired == false and BasedOnGameType == true and GlobalSettings == true and GlobalNoKills == true then
            if game_type == "ctf" then
                if (killer > 0) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_CTF - 1)]
                    local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_CTF - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end
                elseif game_type == "slayer" then
                    if (killer > 0) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_SLAYER - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end
                    end
                end
            end
            --     [!]      GAMETYPE GLOBAL SETTINGS --
            --     [!]      Kills Required
        elseif NonGlobalKillsRequired == false and BasedOnGameType == true and GlobalSettings == true and GlobalNoKills == false then
            if game_type == "ctf" then
                if (killer > 0) then
                    if (kills == 10) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_CTF - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_CTF - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 20) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_CTF - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_CTF - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 30) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_CTF - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_CTF - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 40) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_CTF - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_CTF - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 50) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_CTF - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_CTF - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 60) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_CTF - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_CTF - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 70) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_CTF - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_CTF - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 80) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_CTF - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_CTF - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 90) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_CTF - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_CTF - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills >= 100) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_CTF - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_CTF - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end
                    end
                end

            elseif game_type == "ctf" then
                if (killer > 0) then
                    if (kills == 10) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_SLAYER - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 20) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_SLAYER - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 30) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_SLAYER - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 40) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_SLAYER - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 50) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_SLAYER - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 60) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_SLAYER - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 70) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_SLAYER - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 80) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_SLAYER - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills == 90) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_SLAYER - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end

                    elseif (kills >= 100) then
                        local x, y, z = read_vector3d(player_object + 0x5C)
                        VICTIM_LOCATION[victim][1] = x
                        VICTIM_LOCATION[victim][2] = y
                        VICTIM_LOCATION[victim][3] = z
                        math.randomseed(os.time())
                        local itemtoDrop1 = GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_EQ_GLOBAL_TABLE_SLAYER - 1)]
                        local itemtoDrop2 = GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[math.random(0, #GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER - 1)]
                        local player = get_player(victim)
                        local rotation = read_float(player + 0x138)
                        local eqTable = math.random(1, 2)
                        if (tonumber(eqTable) == 1) then
                            spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                        elseif (tonumber(eqTable) == 2) then
                            spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                        end
                    end
                end
            end

            -- Kills Required, and uses Global Equipment Table (does not take into account the gametype or map)
        elseif NonGlobalKillsRequired == false and GlobalSettings == true and GlobalNoKills == false then
            if (killer > 0) then
                if (kills == 10) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 20) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 30) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 40) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 50) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 60) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 70) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 80) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills == 90) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end

                elseif (kills >= 100) then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    VICTIM_LOCATION[victim][1] = x
                    VICTIM_LOCATION[victim][2] = y
                    VICTIM_LOCATION[victim][3] = z
                    math.randomseed(os.time())
                    local itemtoDrop1 = GLOBAL_EQUIPMENT_TABLE[math.random(0, #GLOBAL_EQUIPMENT_TABLE - 1)]
                    local itemtoDrop2 = GLOBAL_WEAPON_TABLE[math.random(0, #GLOBAL_WEAPON_TABLE - 1)]
                    local player = get_player(victim)
                    local rotation = read_float(player + 0x138)
                    local eqTable = math.random(1, 2)
                    if (tonumber(eqTable) == 1) then
                        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
                    elseif (tonumber(eqTable) == 2) then
                        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
                    end
                end
            end
        end
    end
end

function WeaponsAndEquipment(victim, x, y, z)
    math.randomseed(os.time())
    local itemtoDrop1 = TableToUse1[math.random(0, #TableToUse1 - 1)]
    local itemtoDrop2 = TableToUse2[math.random(0, #TableToUse2 - 1)]
    local player = get_player(victim)
    local rotation = read_float(player + 0x138)
    local eqTable = math.random(1, 2)
    if (tonumber(eqTable) == 1) then
        spawn_object(tostring(eqip), itemtoDrop1, x, y, z + 0.5, rotation)
    elseif (tonumber(eqTable) == 2) then
        spawn_object(tostring(weap), itemtoDrop2, x, y, z + 0.5, rotation)
    end
end

function JustEquipment(victim, x, y, z)
    math.randomseed(os.time())
    local itemtoDrop = TableToUse[math.random(0, #TableToUse - 1)]
    local player = get_player(victim)
    local rotation = read_float(player + 0x138)
    spawn_object(tostring(eqip), itemtoDrop, x, y, z + 0.5, rotation)
end

function JustWeapons(victim, x, y, z)
    math.randomseed(os.time())
    local itemtoDrop = TableToUse[math.random(0, #TableToUse - 1)]
    local player = get_player(victim)
    local rotation = read_float(player + 0x138)
    spawn_object(tostring(weap), itemtoDrop, x, y, z + 0.5, rotation)
end

function GameSettings(victim, x, y, z)
    map_name = get_var(1, "$map")
    if BasedOnMap == true and BasedOnGameType == false then
        if map_name == "beavercreek" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "bloodgulch" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "boardingaction" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "carousel" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "chillout" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "damnation" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "dangercanyon" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "deathisland" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "gephyrophobia" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "hangemhigh" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "icefields" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "infinity" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "longest" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "prisoner" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "putput" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "ratrace" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "sidewinder" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        elseif map_name == "wizard" then
            if access == WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == JW then
                JustWeapons(victim, x, y, z)
            elseif access == JE then
                JustEquipment(victim, x, y, z)
            end
        end
    end
    -- Based on Map --
    if BasedOnGameType == true and BasedOnMap == false then
        if game_type == "ctf" then
            if access == GT_WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == GT_JW then
                JustWeapons(victim, x, y, z)
            elseif access == GT_JE then
                JustEquipment(victim, x, y, z)
            end
        elseif game_type == "slayer" then
            if access == GT_WAE then
                WeaponsAndEquipment(victim, x, y, z)
            elseif access == GT_JW then
                JustWeapons(victim, x, y, z)
            elseif access == GT_JE then
                JustEquipment(victim, x, y, z)
            end
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
GLOBAL_WEAPON_TABLE = { }
GLOBAL_WEAPON_TABLE[1] = "weapons\\assault rifle\\assault rifle"
GLOBAL_WEAPON_TABLE[2] = "weapons\\flamethrower\\flamethrower"
GLOBAL_WEAPON_TABLE[3] = "weapons\\needler\\mp_needler"
GLOBAL_WEAPON_TABLE[4] = "weapons\\pistol\\pistol"
GLOBAL_WEAPON_TABLE[5] = "weapons\\plasma pistol\\plasma pistol"
GLOBAL_WEAPON_TABLE[6] = "weapons\\plasma rifle\\plasma rifle"
GLOBAL_WEAPON_TABLE[7] = "weapons\\plasma_cannon\\plasma_cannon"
GLOBAL_WEAPON_TABLE[8] = "weapons\\rocket launcher\\rocket launcher"
GLOBAL_WEAPON_TABLE[9] = "weapons\\shotgun\\shotgun"
GLOBAL_WEAPON_TABLE[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_BEAVERCREEK = { }
MAP_EQ_TABLE_BEAVERCREEK[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_BEAVERCREEK[2] = "powerups\\health pack"
MAP_EQ_TABLE_BEAVERCREEK[3] = "powerups\\over shield"
MAP_EQ_TABLE_BEAVERCREEK[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_BEAVERCREEK[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_BEAVERCREEK[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_BEAVERCREEK[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_BEAVERCREEK[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_BEAVERCREEK[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_BEAVERCREEK[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_BEAVERCREEK = { }
MAP_WEAPON_TABLE_BEAVERCREEK[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_BEAVERCREEK[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_BEAVERCREEK[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_BEAVERCREEK[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_BEAVERCREEK[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_BEAVERCREEK[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_BEAVERCREEK[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_BEAVERCREEK[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_BEAVERCREEK[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_BEAVERCREEK[10] = "weapons\\sniper rifle\\sniper rifle"

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
MAP_WEAPON_TABLE_BLOODGULCH = { }
MAP_WEAPON_TABLE_BLOODGULCH[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_BLOODGULCH[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_BLOODGULCH[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_BLOODGULCH[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_BLOODGULCH[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_BLOODGULCH[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_BLOODGULCH[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_BLOODGULCH[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_BLOODGULCH[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_BLOODGULCH[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_BOARDINGACTION = { }
MAP_EQ_TABLE_BOARDINGACTION[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_BOARDINGACTION[2] = "powerups\\health pack"
MAP_EQ_TABLE_BOARDINGACTION[3] = "powerups\\over shield"
MAP_EQ_TABLE_BOARDINGACTION[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_BOARDINGACTION[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_BOARDINGACTION[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_BOARDINGACTION[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_BOARDINGACTION[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_BOARDINGACTION[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_BOARDINGACTION[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_BOARDINGACTION = { }
MAP_WEAPON_TABLE_BOARDINGACTION[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_BOARDINGACTION[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_BOARDINGACTION[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_BOARDINGACTION[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_BOARDINGACTION[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_BOARDINGACTION[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_BOARDINGACTION[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_BOARDINGACTION[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_BOARDINGACTION[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_BOARDINGACTION[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_CAROUSEL = { }
MAP_EQ_TABLE_CAROUSEL[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_CAROUSEL[2] = "powerups\\health pack"
MAP_EQ_TABLE_CAROUSEL[3] = "powerups\\over shield"
MAP_EQ_TABLE_CAROUSEL[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_CAROUSEL[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_CAROUSEL[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_CAROUSEL[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_CAROUSEL[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_CAROUSEL[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_CAROUSEL[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_CAROUSEL = { }
MAP_WEAPON_TABLE_CAROUSEL[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_CAROUSEL[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_CAROUSEL[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_CAROUSEL[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_CAROUSEL[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_CAROUSEL[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_CAROUSEL[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_CAROUSEL[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_CAROUSEL[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_CAROUSEL[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_CHILLOUT = { }
MAP_EQ_TABLE_CHILLOUT[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_CHILLOUT[2] = "powerups\\health pack"
MAP_EQ_TABLE_CHILLOUT[3] = "powerups\\over shield"
MAP_EQ_TABLE_CHILLOUT[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_CHILLOUT[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_CHILLOUT[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_CHILLOUT[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_CHILLOUT[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_CHILLOUT[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_CHILLOUT[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_CHILLOUT = { }
MAP_WEAPON_TABLE_CHILLOUT[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_CHILLOUT[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_CHILLOUT[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_CHILLOUT[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_CHILLOUT[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_CHILLOUT[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_CHILLOUT[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_CHILLOUT[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_CHILLOUT[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_CHILLOUT[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_DAMNATION = { }
MAP_EQ_TABLE_DAMNATION[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_DAMNATION[2] = "powerups\\health pack"
MAP_EQ_TABLE_DAMNATION[3] = "powerups\\over shield"
MAP_EQ_TABLE_DAMNATION[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_DAMNATION[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_DAMNATION[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_DAMNATION[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_DAMNATION[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_DAMNATION[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_DAMNATION[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_DAMNATION = { }
MAP_WEAPON_TABLE_DAMNATION[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_DAMNATION[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_DAMNATION[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_DAMNATION[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_DAMNATION[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_DAMNATION[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_DAMNATION[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_DAMNATION[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_DAMNATION[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_DAMNATION[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_DANGERCANYON = { }
MAP_EQ_TABLE_DANGERCANYON[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_DANGERCANYON[2] = "powerups\\health pack"
MAP_EQ_TABLE_DANGERCANYON[3] = "powerups\\over shield"
MAP_EQ_TABLE_DANGERCANYON[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_DANGERCANYON[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_DANGERCANYON[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_DANGERCANYON[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_DANGERCANYON[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_DANGERCANYON[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_DANGERCANYON[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_DANGERCANYON = { }
MAP_WEAPON_TABLE_DANGERCANYON[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_DANGERCANYON[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_DANGERCANYON[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_DANGERCANYON[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_DANGERCANYON[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_DANGERCANYON[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_DANGERCANYON[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_DANGERCANYON[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_DANGERCANYON[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_DANGERCANYON[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_DEATHISLAND = { }
MAP_EQ_TABLE_DEATHISLAND[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_DEATHISLAND[2] = "powerups\\health pack"
MAP_EQ_TABLE_DEATHISLAND[3] = "powerups\\over shield"
MAP_EQ_TABLE_DEATHISLAND[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_DEATHISLAND[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_DEATHISLAND[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_DEATHISLAND[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_DEATHISLAND[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_DEATHISLAND[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_DEATHISLAND[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_DEATHISLAND = { }
MAP_WEAPON_TABLE_DEATHISLAND[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_DEATHISLAND[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_DEATHISLAND[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_DEATHISLAND[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_DEATHISLAND[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_DEATHISLAND[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_DEATHISLAND[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_DEATHISLAND[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_DEATHISLAND[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_DEATHISLAND[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_GEPHYROPHOBIA = { }
MAP_EQ_TABLE_GEPHYROPHOBIA[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_GEPHYROPHOBIA[2] = "powerups\\health pack"
MAP_EQ_TABLE_GEPHYROPHOBIA[3] = "powerups\\over shield"
MAP_EQ_TABLE_GEPHYROPHOBIA[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_GEPHYROPHOBIA[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_GEPHYROPHOBIA[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_GEPHYROPHOBIA[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_GEPHYROPHOBIA[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_GEPHYROPHOBIA[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_GEPHYROPHOBIA[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_GEPHYROPHOBIA = { }
MAP_WEAPON_TABLE_GEPHYROPHOBIA[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_GEPHYROPHOBIA[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_GEPHYROPHOBIA[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_GEPHYROPHOBIA[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_GEPHYROPHOBIA[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_GEPHYROPHOBIA[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_GEPHYROPHOBIA[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_GEPHYROPHOBIA[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_GEPHYROPHOBIA[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_GEPHYROPHOBIA[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_HANGEMHIGH = { }
MAP_EQ_TABLE_HANGEMHIGH[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_HANGEMHIGH[2] = "powerups\\health pack"
MAP_EQ_TABLE_HANGEMHIGH[3] = "powerups\\over shield"
MAP_EQ_TABLE_HANGEMHIGH[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_HANGEMHIGH[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_HANGEMHIGH[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_HANGEMHIGH[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_HANGEMHIGH[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_HANGEMHIGH[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_HANGEMHIGH[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_HANGEMHIGH = { }
MAP_WEAPON_TABLE_HANGEMHIGH[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_HANGEMHIGH[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_HANGEMHIGH[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_HANGEMHIGH[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_HANGEMHIGH[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_HANGEMHIGH[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_HANGEMHIGH[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_HANGEMHIGH[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_HANGEMHIGH[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_HANGEMHIGH[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_ICEFIELDS = { }
MAP_EQ_TABLE_ICEFIELDS[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_ICEFIELDS[2] = "powerups\\health pack"
MAP_EQ_TABLE_ICEFIELDS[3] = "powerups\\over shield"
MAP_EQ_TABLE_ICEFIELDS[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_ICEFIELDS[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_ICEFIELDS[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_ICEFIELDS[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_ICEFIELDS[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_ICEFIELDS[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_ICEFIELDS[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_ICEFIELDS = { }
MAP_WEAPON_TABLE_ICEFIELDS[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_ICEFIELDS[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_ICEFIELDS[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_ICEFIELDS[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_ICEFIELDS[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_ICEFIELDS[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_ICEFIELDS[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_ICEFIELDS[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_ICEFIELDS[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_ICEFIELDS[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_INFINITY = { }
MAP_EQ_TABLE_INFINITY[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_INFINITY[2] = "powerups\\health pack"
MAP_EQ_TABLE_INFINITY[3] = "powerups\\over shield"
MAP_EQ_TABLE_INFINITY[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_INFINITY[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_INFINITY[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_INFINITY[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_INFINITY[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_INFINITY[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_INFINITY[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_INFINITY = { }
MAP_WEAPON_TABLE_INFINITY[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_INFINITY[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_INFINITY[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_INFINITY[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_INFINITY[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_INFINITY[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_INFINITY[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_INFINITY[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_INFINITY[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_INFINITY[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_LONGEST = { }
MAP_EQ_TABLE_LONGEST[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_LONGEST[2] = "powerups\\health pack"
MAP_EQ_TABLE_LONGEST[3] = "powerups\\over shield"
MAP_EQ_TABLE_LONGEST[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_LONGEST[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_LONGEST[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_LONGEST[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_LONGEST[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_LONGEST[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_LONGEST[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_LONGEST = { }
MAP_WEAPON_TABLE_LONGEST[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_LONGEST[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_LONGEST[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_LONGEST[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_LONGEST[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_LONGEST[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_LONGEST[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_LONGEST[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_LONGEST[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_LONGEST[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_PRISONER = { }
MAP_EQ_TABLE_PRISONER[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_PRISONER[2] = "powerups\\health pack"
MAP_EQ_TABLE_PRISONER[3] = "powerups\\over shield"
MAP_EQ_TABLE_PRISONER[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_PRISONER[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_PRISONER[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_PRISONER[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_PRISONER[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_PRISONER[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_PRISONER[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_PRISONER = { }
MAP_WEAPON_TABLE_PRISONER[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_PRISONER[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_PRISONER[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_PRISONER[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_PRISONER[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_PRISONER[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_PRISONER[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_PRISONER[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_PRISONER[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_PRISONER[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_PUTPUT = { }
MAP_EQ_TABLE_PUTPUT[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_PUTPUT[2] = "powerups\\health pack"
MAP_EQ_TABLE_PUTPUT[3] = "powerups\\over shield"
MAP_EQ_TABLE_PUTPUT[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_PUTPUT[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_PUTPUT[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_PUTPUT[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_PUTPUT[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_PUTPUT[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_PUTPUT[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_PUTPUT = { }
MAP_WEAPON_TABLE_PUTPUT[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_PUTPUT[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_PUTPUT[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_PUTPUT[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_PUTPUT[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_PUTPUT[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_PUTPUT[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_PUTPUT[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_PUTPUT[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_PUTPUT[10] = "weapons\\sniper rifle\\sniper rifle"

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
MAP_WEAPON_TABLE_RATRACE = { }
MAP_WEAPON_TABLE_RATRACE[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_RATRACE[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_RATRACE[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_RATRACE[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_RATRACE[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_RATRACE[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_RATRACE[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_RATRACE[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_RATRACE[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_RATRACE[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_SIDEWINDER = { }
MAP_EQ_TABLE_SIDEWINDER[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_SIDEWINDER[2] = "powerups\\health pack"
MAP_EQ_TABLE_SIDEWINDER[3] = "powerups\\over shield"
MAP_EQ_TABLE_SIDEWINDER[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_SIDEWINDER[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_SIDEWINDER[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_SIDEWINDER[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_SIDEWINDER[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_SIDEWINDER[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_SIDEWINDER[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_SIDEWINDER = { }
MAP_WEAPON_TABLE_SIDEWINDER[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_SIDEWINDER[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_SIDEWINDER[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_SIDEWINDER[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_SIDEWINDER[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_SIDEWINDER[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_SIDEWINDER[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_SIDEWINDER[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_SIDEWINDER[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_SIDEWINDER[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_TIMBERLAND = { }
MAP_EQ_TABLE_TIMBERLAND[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_TIMBERLAND[2] = "powerups\\health pack"
MAP_EQ_TABLE_TIMBERLAND[3] = "powerups\\over shield"
MAP_EQ_TABLE_TIMBERLAND[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_TIMBERLAND[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_TIMBERLAND[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_TIMBERLAND[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_TIMBERLAND[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_TIMBERLAND[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_TIMBERLAND[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_TIMBERLAND = { }
MAP_WEAPON_TABLE_TIMBERLAND[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_TIMBERLAND[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_TIMBERLAND[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_TIMBERLAND[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_TIMBERLAND[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_TIMBERLAND[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_TIMBERLAND[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_TIMBERLAND[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_TIMBERLAND[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_TIMBERLAND[10] = "weapons\\sniper rifle\\sniper rifle"

MAP_EQ_TABLE_WIZARD = { }
MAP_EQ_TABLE_WIZARD[1] = "powerups\\active camouflage"
MAP_EQ_TABLE_WIZARD[2] = "powerups\\health pack"
MAP_EQ_TABLE_WIZARD[3] = "powerups\\over shield"
MAP_EQ_TABLE_WIZARD[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
MAP_EQ_TABLE_WIZARD[5] = "powerups\\needler ammo\\needler ammo"
MAP_EQ_TABLE_WIZARD[6] = "powerups\\pistol ammo\\pistol ammo"
MAP_EQ_TABLE_WIZARD[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
MAP_EQ_TABLE_WIZARD[8] = "powerups\\shotgun ammo\\shotgun ammo"
MAP_EQ_TABLE_WIZARD[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
MAP_EQ_TABLE_WIZARD[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
MAP_WEAPON_TABLE_WIZARD = { }
MAP_WEAPON_TABLE_WIZARD[1] = "weapons\\assault rifle\\assault rifle"
MAP_WEAPON_TABLE_WIZARD[2] = "weapons\\flamethrower\\flamethrower"
MAP_WEAPON_TABLE_WIZARD[3] = "weapons\\needler\\mp_needler"
MAP_WEAPON_TABLE_WIZARD[4] = "weapons\\pistol\\pistol"
MAP_WEAPON_TABLE_WIZARD[5] = "weapons\\plasma pistol\\plasma pistol"
MAP_WEAPON_TABLE_WIZARD[6] = "weapons\\plasma rifle\\plasma rifle"
MAP_WEAPON_TABLE_WIZARD[7] = "weapons\\plasma_cannon\\plasma_cannon"
MAP_WEAPON_TABLE_WIZARD[8] = "weapons\\rocket launcher\\rocket launcher"
MAP_WEAPON_TABLE_WIZARD[9] = "weapons\\shotgun\\shotgun"
MAP_WEAPON_TABLE_WIZARD[10] = "weapons\\sniper rifle\\sniper rifle"

-- ================================================================================================--
-- ================================================================================================--
GAMETYPE_EQ_TABLE_CTF = { }
GAMETYPE_EQ_TABLE_CTF[1] = "powerups\\active camouflage"
GAMETYPE_EQ_TABLE_CTF[2] = "powerups\\health pack"
GAMETYPE_EQ_TABLE_CTF[3] = "powerups\\over shield"
GAMETYPE_EQ_TABLE_CTF[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
GAMETYPE_EQ_TABLE_CTF[5] = "powerups\\needler ammo\\needler ammo"
GAMETYPE_EQ_TABLE_CTF[6] = "powerups\\pistol ammo\\pistol ammo"
GAMETYPE_EQ_TABLE_CTF[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
GAMETYPE_EQ_TABLE_CTF[8] = "powerups\\shotgun ammo\\shotgun ammo"
GAMETYPE_EQ_TABLE_CTF[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
GAMETYPE_EQ_TABLE_CTF[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
GAMETYPE_WEAPON_TABLE_CTF = { }
GAMETYPE_WEAPON_TABLE_CTF[1] = "weapons\\assault rifle\\assault rifle"
GAMETYPE_WEAPON_TABLE_CTF[2] = "weapons\\flamethrower\\flamethrower"
GAMETYPE_WEAPON_TABLE_CTF[3] = "weapons\\needler\\mp_needler"
GAMETYPE_WEAPON_TABLE_CTF[4] = "weapons\\pistol\\pistol"
GAMETYPE_WEAPON_TABLE_CTF[5] = "weapons\\plasma pistol\\plasma pistol"
GAMETYPE_WEAPON_TABLE_CTF[6] = "weapons\\plasma rifle\\plasma rifle"
GAMETYPE_WEAPON_TABLE_CTF[7] = "weapons\\plasma_cannon\\plasma_cannon"
GAMETYPE_WEAPON_TABLE_CTF[8] = "weapons\\rocket launcher\\rocket launcher"
GAMETYPE_WEAPON_TABLE_CTF[9] = "weapons\\shotgun\\shotgun"
GAMETYPE_WEAPON_TABLE_CTF[10] = "weapons\\sniper rifle\\sniper rifle"

GAMETYPE_EQ_TABLE_SLAYER = { }
GAMETYPE_EQ_TABLE_SLAYER[1] = "powerups\\active camouflage"
GAMETYPE_EQ_TABLE_SLAYER[2] = "powerups\\health pack"
GAMETYPE_EQ_TABLE_SLAYER[3] = "powerups\\over shield"
GAMETYPE_EQ_TABLE_SLAYER[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
GAMETYPE_EQ_TABLE_SLAYER[5] = "powerups\\needler ammo\\needler ammo"
GAMETYPE_EQ_TABLE_SLAYER[6] = "powerups\\pistol ammo\\pistol ammo"
GAMETYPE_EQ_TABLE_SLAYER[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
GAMETYPE_EQ_TABLE_SLAYER[8] = "powerups\\shotgun ammo\\shotgun ammo"
GAMETYPE_EQ_TABLE_SLAYER[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
GAMETYPE_EQ_TABLE_SLAYER[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
GAMETYPE_WEAPON_TABLE_SLAYER = { }
GAMETYPE_WEAPON_TABLE_SLAYER[1] = "weapons\\assault rifle\\assault rifle"
GAMETYPE_WEAPON_TABLE_SLAYER[2] = "weapons\\flamethrower\\flamethrower"
GAMETYPE_WEAPON_TABLE_SLAYER[3] = "weapons\\needler\\mp_needler"
GAMETYPE_WEAPON_TABLE_SLAYER[4] = "weapons\\pistol\\pistol"
GAMETYPE_WEAPON_TABLE_SLAYER[5] = "weapons\\plasma pistol\\plasma pistol"
GAMETYPE_WEAPON_TABLE_SLAYER[6] = "weapons\\plasma rifle\\plasma rifle"
GAMETYPE_WEAPON_TABLE_SLAYER[7] = "weapons\\plasma_cannon\\plasma_cannon"
GAMETYPE_WEAPON_TABLE_SLAYER[8] = "weapons\\rocket launcher\\rocket launcher"
GAMETYPE_WEAPON_TABLE_SLAYER[9] = "weapons\\shotgun\\shotgun"
GAMETYPE_WEAPON_TABLE_SLAYER[10] = "weapons\\sniper rifle\\sniper rifle"

-- ================================================================================================--
-- ================================================================================================--
GAMETYPE_EQ_GLOBAL_TABLE_SLAYER = { }
GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[1] = "powerups\\active camouflage"
GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[2] = "powerups\\health pack"
GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[3] = "powerups\\over shield"
GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[5] = "powerups\\needler ammo\\needler ammo"
GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[6] = "powerups\\pistol ammo\\pistol ammo"
GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[8] = "powerups\\shotgun ammo\\shotgun ammo"
GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
GAMETYPE_EQ_GLOBAL_TABLE_SLAYER[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER = { }
GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[1] = "weapons\\assault rifle\\assault rifle"
GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[2] = "weapons\\flamethrower\\flamethrower"
GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[3] = "weapons\\needler\\mp_needler"
GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[4] = "weapons\\pistol\\pistol"
GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[5] = "weapons\\plasma pistol\\plasma pistol"
GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[6] = "weapons\\plasma rifle\\plasma rifle"
GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[7] = "weapons\\plasma_cannon\\plasma_cannon"
GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[8] = "weapons\\rocket launcher\\rocket launcher"
GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[9] = "weapons\\shotgun\\shotgun"
GAMETYPE_WEAPON_GLOBAL_TABLE_SLAYER[10] = "weapons\\sniper rifle\\sniper rifle"
GAMETYPE_EQ_GLOBAL_TABLE_CTF = { }
GAMETYPE_EQ_GLOBAL_TABLE_CTF[1] = "powerups\\active camouflage"
GAMETYPE_EQ_GLOBAL_TABLE_CTF[2] = "powerups\\health pack"
GAMETYPE_EQ_GLOBAL_TABLE_CTF[3] = "powerups\\over shield"
GAMETYPE_EQ_GLOBAL_TABLE_CTF[4] = "powerups\\assault rifle ammo\\assault rifle ammo"
GAMETYPE_EQ_GLOBAL_TABLE_CTF[5] = "powerups\\needler ammo\\needler ammo"
GAMETYPE_EQ_GLOBAL_TABLE_CTF[6] = "powerups\\pistol ammo\\pistol ammo"
GAMETYPE_EQ_GLOBAL_TABLE_CTF[7] = "powerups\\rocket launcher ammo\\rocket launcher ammo"
GAMETYPE_EQ_GLOBAL_TABLE_CTF[8] = "powerups\\shotgun ammo\\shotgun ammo"
GAMETYPE_EQ_GLOBAL_TABLE_CTF[9] = "powerups\\sniper rifle ammo\\sniper rifle ammo"
GAMETYPE_EQ_GLOBAL_TABLE_CTF[10] = "powerups\\flamethrower ammo\\flamethrower ammo"
GAMETYPE_WEAPON_GLOBAL_TABLE_CTF = { }
GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[1] = "weapons\\assault rifle\\assault rifle"
GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[2] = "weapons\\flamethrower\\flamethrower"
GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[3] = "weapons\\needler\\mp_needler"
GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[4] = "weapons\\pistol\\pistol"
GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[5] = "weapons\\plasma pistol\\plasma pistol"
GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[6] = "weapons\\plasma rifle\\plasma rifle"
GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[7] = "weapons\\plasma_cannon\\plasma_cannon"
GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[8] = "weapons\\rocket launcher\\rocket launcher"
GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[9] = "weapons\\shotgun\\shotgun"
GAMETYPE_WEAPON_GLOBAL_TABLE_CTF[10] = "weapons\\sniper rifle\\sniper rifle"

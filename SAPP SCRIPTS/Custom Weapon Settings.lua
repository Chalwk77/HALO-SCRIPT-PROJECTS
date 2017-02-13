--[[
------------------------------------
Script Name: Custom Weapon Spawns, for SAPP | (PC\CE)
    - Implementing API version: 1.11.0.0
Written for FIG Community

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]--
-- Do not touch --
api_version = "1.11.0.0"
weapon = { }
weapons = { }
frags = { }
plasmas = { }
weapons[00000] = "nil\\nil\\nil"
MapIsListed = nil
-- ^^ Do not touch ^^ --

-- ==================================================================================--
-- ==================================================================================--
-- CONFIGURATION STARTS HERE -- 
gamesettings = {
    ["Give_Frag_Grenades"] = true,
    ["Give_Plasma_Grenades"] = true
}

function LoadMaps()
    -- mapnames table --
    mapnames = {
--      [!] Default Maps
        "beavercreek",
        "bloodgulch",
        "boardingaction",
        "carousel",
        "dangercanyon",
        "deathisland",
        "gephyrophobia",
        "icefields",
        "infinity",
        "sidewinder",
        "timberland",
        "hangemhigh",
        "ratrace",
        "damnation",
        "putput",
        "prisoner",
        "wizard",
--      [!] Custom Maps
        "dustbeta",
        "snowdrop",
        "MAP_NAME_HERE",
        "MAP_NAME_HERE",
        "MAP_NAME_HERE" -- Make sure the last entry in the table doesn't have a comma at the end. 
    }
end

-------- Weapon Table -----------------------------------------------------------------------------------------------------------
-- Default Weapons --
weapons[1] = "weapons\\pistol\\pistol"
weapons[2] = "weapons\\sniper rifle\\sniper rifle"
weapons[3] = "weapons\\plasma_cannon\\plasma_cannon"
weapons[4] = "weapons\\rocket launcher\\rocket launcher"
weapons[5] = "weapons\\plasma pistol\\plasma pistol"
weapons[6] = "weapons\\plasma rifle\\plasma rifle"
weapons[7] = "weapons\\assault rifle\\assault rifle"
weapons[8] = "weapons\\flamethrower\\flamethrower"
weapons[9] = "weapons\\needler\\mp_needler"
weapons[10] = "weapons\\shotgun\\shotgun"
 ---------------------------------------------------------------------------------------------------------------------------------
-- Custom Weapons --
-- dust beta --
weapons[11] = "weapons\\p90\\p90"
weapons[12] = "cod4\\weapons\\desert eagle\\desert eagle"
weapons[13] = "weapons\\scout\\scout"
weapons[14] = "weapons\\m4a1\\m4a1"
weapons[15] = "weapons\\m249\\m249 saw"
weapons[16] = "weapons\\m16\\m16" -- Varient 1
weapons[17] = "weapons\\bomb\\bomb"
weapons[18] = "weapons\\92fs\\92fs pistol"
weapons[19] = "cod4\\weapons\\mp5\\mp5"
weapons[20] = "cod4\\weapons\\m82\\m82"
weapons[21] = "cod4\\weapons\\m16\\m16" -- Varient 2
weapons[22] = "cod4\\weapons\\g36\\g36"
-- snowdrop --
weapons[23] = "cmt\\weapons\\human\\ma5k\\ma5k mp"
weapons[24] = "cmt\\weapons\\human\\shotgun\\shotgun"
weapons[25] = "halo3\\weapons\\battle rifle\\tactical battle rifle"
weapons[26] = "haloceripper.webs.com\\zteam\\vehicles\\h_turrent\\turrent gun" -- DOES NOT WORK (confirmed)
weapons[27] = "weapons\\cad assault rifle\\assault rifle"
weapons[28] = "weapons\\gauss sniper\\gauss sniper"
weapons[29] = "weapons\\<weapon_name>\\<weapon_name>"
weapons[30] = "weapons\\<weapon_name>\\<weapon_name>"

-- If your gamemode is set up so that you spawn with infinite grenades, 
-- this script will respect that, and you will continue to spawn with infinite grenades (:

function GrenadeTable()
--  frag grenades table --
    frags = {
--  [!] - Default Maps -    
        beavercreek = 3,
        bloodgulch = 4,
        boardingaction = 1,
        carousel = 3,
        dangercanyon = 4,
        deathisland = 1,
        gephyrophobia = 3,
        icefields = 1,
        infinity = 2,
        sidewinder = 3,
        timberland = 2,
        hangemhigh = 3,
        ratrace = 3,
        damnation = 1,
        putput = 4,
        prisoner = 2,
        wizard = 1,
--  [!] - Custom Maps -  
        h2_momentum = 2,
        snowdrop = 3,
        dustbeta = 2,
        ewok = 1,
        trainingday = 4,
        hydroxide = 2,
        deltaruins = 1,
        garden_ce = 3,
--      <map name> = <number><comma>
        MAP_NAME_HERE = 0,
        MAP_NAME_HERE = 0,
        MAP_NAME_HERE = 0,
        MAP_NAME_HERE = 0,
        MAP_NAME_HERE = 0 -- Make sure the last entry in the table doesn't have a comma at the end. 
    }
--  plasma grenades table --
    plasmas = {
--  [!] - Default Maps -    
        beavercreek = 1,
        bloodgulch = 2,
        boardingaction = 3,
        carousel = 3,
        dangercanyon = 4,
        deathisland = 1,
        gephyrophobia = 3,
        icefields = 1,
        infinity = 4,
        sidewinder = 2,
        timberland = 4,
        hangemhigh = 3,
        ratrace = 2,
        damnation = 3,
        putput = 1,
        prisoner = 1,
        wizard = 2,
--  [!] - Custom Maps -  
        h2_momentum = 1,
        snowdrop = 4,
        dustbeta = 1, -- Dust Beta doesn't have Plasma Grenades
        ewok = 2,
        trainingday = 4,
        hydroxide = 1,
        deltaruins = 2,
        garden_ce = 1,
--      <map name> = <number><comma>
        MAP_NAME_HERE = 0,
        MAP_NAME_HERE = 0,
        MAP_NAME_HERE = 0,
        MAP_NAME_HERE = 0,
        MAP_NAME_HERE = 0 -- Make sure the last entry in the table doesn't have a comma at the end. 
    }
end
-- CONFIGURATION ENDS HERE --
-- ==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^               
-- ==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^==^


-- [!] Warning: do not touch anything below unless you know what you are doing.
function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    if get_var(0, "$gt") ~= "n/a" then
        mapname = get_var(0, "$map")
        GrenadeTable()
        LoadMaps()
    end
end

function OnScriptUnload()
    frags = { }
    plasmas = { }
    weapon = { }
    weapons = { }
    maps = { }
end

function OnPlayerSpawn(PlayerIndex)
    weapon[PlayerIndex] = 0
    mapname = get_var(0, "$map")
    if player_alive(PlayerIndex) then
        local player_object = get_dynamic_player(PlayerIndex)
        if (player_object ~= 0) then
            if (gamesettings["Give_Frag_Grenades"] == true) then
                if (frags[mapname] == nil) then 
                    -- Use default grenade settings instead.
                    Error = 'Error: ' .. mapname .. ' is not listed in the Frag Grenade Table - Line 108 | Unable to set frags.'
                    cprint(Error, 4+8)
                    execute_command("log_note \""..Error.."\"")
                else
                    write_word(player_object + 0x31E, frags[mapname])
                end
            end
            if (gamesettings["Give_Plasma_Grenades"] == true) then
                if (plasmas[mapname] == nil) then 
                    -- Use default grenade settings instead.
                    Error = 'Error: ' .. mapname .. ' is not listed in the Plasma Grenade Table - Line 144 | Unable to set plasmas.'
                    cprint(Error, 4+8)
                    execute_command("log_note \""..Error.."\"")
                else
                    write_word(player_object + 0x31F, plasmas[mapname])
                end
            end
        end
    end
end

function table.match(table, value)
    for k,v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function OnNewGame()
    mapname = get_var(0, "$map")
    GrenadeTable()
    LoadMaps()
    if (table.match(mapnames, mapname) == nil) then 
        MapIsListed = false
        Error = 'Error: ' .. mapname .. ' is not listed in "mapnames table" - line 38'
        cprint(Error, 4+8)
        execute_command("log_note \""..Error.."\"")
    else
        MapIsListed = true
    end
end

--      TO ASSIGN A WEAPON:
--      Change the numbers "00000" to match the corrosponding index number in the weapon table at the top of the script.
--      [!] Note, you cannot import weapons from one map to another with this script.

--      The only lines you need to edit below are:
--          this one --->>>         assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
--          this one --->>>         if (mapname == "MAP_NAME_HERE") then
--          Change MAP_NAME_HERE to the name of the map you want to assign weapons to.
--      [!] Note, map names are case/character sensitive.

function OnTick()
    for i = 1, 16 do
        if (player_alive(i)) then
            if MapIsListed == false then
                -- Map is not listed under "mapnames table" - line 38. 
                -- Players will spawn with default weapons for this map.
                return false
            else
                local player = get_dynamic_player(i)
                if (weapon[i] == 0) then
                    execute_command("wdel " .. i)
                    local x, y, z = read_vector3d(player + 0x5C)
--                  ====== INFO ======
--                  Remove the comment(s) to use these additional weapon entries.
--                  A comment starts anywhere with a double hyphen ( -- ).
                    if (mapname == "dustbeta") then
                        assign_weapon(spawn_object("weap", weapons[11], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[12], x, y, z), i)
                        -- assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        -- assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "snowdrop") then
                        assign_weapon(spawn_object("weap", weapons[27], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[24], x, y, z), i)
                        -- assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        -- assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = 1                    
-----------------------------------------------------------------------------------------------------
-- =================================== D E F A U L T   M A P S =================================== --
                    elseif (mapname == "beavercreek") then
                        assign_weapon(spawn_object("weap", weapons[8], x, y, z), i) -- Flame Thrower
                        assign_weapon(spawn_object("weap", weapons[3], x, y, z), i) -- Plasma Cannon
                        weapon[i] = 1
                    elseif (mapname == "bloodgulch") then
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) -- Rocket Launcher
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i) -- Sniper Rifle
                        weapon[i] = 1
                    elseif (mapname == "boardingaction") then
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i) -- Plasma Rifle
                        assign_weapon(spawn_object("weap", weapons[5], x, y, z), i) -- Plasma Pistol
                        weapon[i] = 1
                    elseif (mapname == "carousel") then
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i) -- Sniper Rifle
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        weapon[i] = 1
                    elseif (mapname == "dangercanyon") then
                        assign_weapon(spawn_object("weap", weapons[8], x, y, z), i) -- Flame Thrower
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) -- Rocket Launcher
                        weapon[i] = 1
                    elseif (mapname == "deathisland") then
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i) -- Sniper Rifle
                        assign_weapon(spawn_object("weap", weapons[5], x, y, z), i) -- Plasma Pistol
                        weapon[i] = 1
                    elseif (mapname == "gephyrophobia") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i) -- Sniper Rifle
                        weapon[i] = 1
                    elseif (mapname == "icefields") then
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) -- Rocket Launcher
                        assign_weapon(spawn_object("weap", weapons[10], x, y, z), i) -- Shotgun
                        weapon[i] = 1
                    elseif (mapname == "infinity") then
                        assign_weapon(spawn_object("weap", weapons[7], x, y, z), i) -- Assault Rifle
                        assign_weapon(spawn_object("weap", weapons[10], x, y, z), i) -- Shotgun
                        weapon[i] = 1
                    elseif (mapname == "sidewinder") then
                        assign_weapon(spawn_object("weap", weapons[9], x, y, z), i) -- Needler
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i) -- Plasma Rifle
                        weapon[i] = 1
                    elseif (mapname == "timberland") then
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i) -- Plasma Rifle
                        assign_weapon(spawn_object("weap", weapons[10], x, y, z), i) -- Shotgun
                        weapon[i] = 1
                    elseif (mapname == "hangemhigh") then
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i) -- Sniper Rifle
                        assign_weapon(spawn_object("weap", weapons[8], x, y, z), i) -- Flame Thrower
                        weapon[i] = 1
                    elseif (mapname == "ratrace") then
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) -- Rocket Launcher
                        assign_weapon(spawn_object("weap", weapons[3], x, y, z), i) -- Plasma Cannon
                        weapon[i] = 1
                    elseif (mapname == "damnation") then
                        assign_weapon(spawn_object("weap", weapons[8], x, y, z), i) -- Flame Thrower
                        assign_weapon(spawn_object("weap", weapons[9], x, y, z), i) -- Needler
                        weapon[i] = 1
                    elseif (mapname == "putput") then
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) -- Rocket Launcher
                        assign_weapon(spawn_object("weap", weapons[5], x, y, z), i) -- Plasma Pistol
                        weapon[i] = 1
                    elseif (mapname == "prisoner") then
                        assign_weapon(spawn_object("weap", weapons[7], x, y, z), i) -- Assault Rifle
                        assign_weapon(spawn_object("weap", weapons[9], x, y, z), i) -- Needler
                        weapon[i] = 1
                    elseif (mapname == "wizard") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i) -- Plasma Rifle
                        weapon[i] = 1
                    end
                end
            end
        end
    end
end

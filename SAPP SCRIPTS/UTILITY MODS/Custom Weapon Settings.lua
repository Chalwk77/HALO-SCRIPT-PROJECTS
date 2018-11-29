--[[
--=====================================================================================================--
Script Name: Custom Weapon Spawns, for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Written for FIG Community

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--
-- Do not touch --
api_version = "1.12.0.0"
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
        "amysroom_beta",
        --[[
        "dustbeta",
        "snowdrop",
        "Homestead",
        "snowdrop",
        "[H2]_Ivory_Tower",
        "dmt_racing",
        "deltaruined_intense",
        "tension",
        "dustbeta",
        "Armageddon",
        "tactics",
        "nitra",
        "Garden_CE",
        "lucidity_rc_b",
        "ewok",
        "bc_Carousel_mp",
        "bounce_arena",
        "church",
        "smallprawn",
        "Cell2",
        "Bridge_crossing",
        "lavaflows",
        "Crimson_Woods",
        "DMT-Goldeneye_Stack-BETA",
        "sniperbluff",
        "helix_canyon",
        "UMT_Archive",
        "fission_point",
        "Nyctophobia",
        "FeelGoodInc",
        "[Z-5]-chillout_alpha",
        "CMT_V2_Dissolution",
        "siege",
        "Dredwerkz_PB2",
        "EMT_Inverno",
        "tm_immolate",
        "destiny",
        "corrupted",
        "Division",
        "Hornets_Nest",
        "headquarters_beta_v2",
        "hmf_marecage",
        "Ambush",
        "sidewinder_v2",
        "TrainingDay",
        "[h3] core",
        "pass_bridge",
        "Serenity(ADB)",
        "old_cemetery",
        "river",
        "Dance",
        "Claustrophobia2",
        "ancient_sanctuary_beta",
        "municipality",
        "paranoia",
        "CMT_G3_Augur",
        "Train.Station",
        "fates_gulch",
        "tower",
        "Bigass",
        "aquarii_final",
        "OverGrown",
        "huh-what_3",
        "Lake_Serenity",
        "Orion_final",
        "fissurefall",
        "deagle6_texture",
        "disco",
        "obelisk",
        "[H4-beta]re-damnation",
        "CMT_G3_MouseTrap",
        "integrity",
        "No_Remorse",
        "[H2]_ascension",
        "tempo",
        "infested",
        "treehouse",
        "fox_condensedGAMMA",
        "Enigma",
        "Dead_End",
        "confined",
        "complex",
        "Seclusion_redux",
        "combat_arena",
        "camden_place",
        "ivory_tower_final",
        "bacon",
        "dioptase",
        "airball",
        "aboveandbelow",
        "tunnel",
        "triduct",
        "xbox_decidia_h1.5_rc_final",
        "Powerhouse",
        "Toys_In_The_Warehouse",
        "extermination",
        "windfall_island",
        "lolcano",
        "xbox_hotbox_h1.5_rc_final",
        "pac-man",
        "Valis",
        "revolutions",
        "Zanzibar_INTENSE",
        "longest",
        "[halo4-reach]re-prisoner",
        "hydroxide",
        "mermaids_plaza",
        "newgulch_5",
        "H2_Momentum",
        "[CoD]Templo-En-Guerra",
        "CMT_Tensity",
        "battlecreek_v2",
        "pipeline",
        "carnage_springs",
        "CnR_Island",
        "chaos_zanzibar",
        "Falujah_1.2",
        "djw-pacman",
        "Sniper_Training",
        "Medical Block"
]]
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
        snowdrop = 4,
        dustbeta = 2,
        amysroom_beta = 0,
        --      <map name> = <number><comma>
        --[[
        Homestead = 4,
        [H2]_Ivory_Tower = 1,
        dmt_racing = 4,
        deltaruined_intense = 3,
        tension = 1,
        Armageddon = 1,
        tactics = 2,
        nitra = 4,
        Garden_CE = 3,
        lucidity_rc_b = 2,
        ewok = 4,
        bc_Carousel_mp = 3,
        bounce_arena = 2,
        church = 4,
        smallprawn = 3,
        Cell2 = 3,
        Bridge_crossing = 4,
        lavaflows = 3,
        Crimson_Woods = 4,
        DMT-Goldeneye_Stack-BETA = 2,
        sniperbluff = 1,
        helix_canyon = 2,
        UMT_Archive = 3,
        fission_point = 1,
        Nyctophobia = 3,
        FeelGoodInc = 2,
        [Z-5]-chillout_alpha = 4,
        CMT_V2_Dissolution = 1,
        siege = 2,
        Dredwerkz_PB2 = 3,
        EMT_Inverno = 2,
        tm_immolate = 1,
        destiny = 2,
        corrupted = 2,
        Division = 3,
        Hornets_Nest = 2,
        headquarters_beta_v2 = 1,
        hmf_marecage = 4,
        Ambush = 3,
        sidewinder_v2 = 2,
        TrainingDay = 1,
        [h3] core = 2,
        pass_bridge = 1,
        Serenity(ADB) = 1,
        old_cemetery = 1,
        river = 2,
        Dance = 3,
        Claustrophobia2 = 1,
        ancient_sanctuary_beta = 3,
        municipality = 3,
        paranoia = 1,
        CMT_G3_Augur = 3,
        Train.Station = 1,
        fates_gulch = 3,
        tower = 4,
        Bigass = 4,
        aquarii_final = 1,
        OverGrown = 3,
        huh-what_3 = 1,
        Lake_Serenity = 3,
        Orion_final = 2,
        fissurefall = 1,
        deagle6_texture = 3,
        disco = 1,
        obelisk = 4,
        [H4-beta]re-damnation = 2,
        CMT_G3_MouseTrap = 2,
        integrity = 3,
        No_Remorse = 3,
        [H2]_ascension = 1,
        tempo = 4,
        infested = 3,
        treehouse = 1,
        fox_condensedGAMMA = 3,
        Enigma = 2,
        Dead_End = 1,
        confined = 1,
        complex = 3,
        Seclusion_redux = 3,
        combat_arena = 2,
        camden_place = 3,
        ivory_tower_final = 4,
        bacon = 1,
        amysroom_beta = 4,
        dioptase = 2,
        airball = 4,
        aboveandbelow = 3,
        tunnel = 2,
        triduct = 4,
        xbox_decidia_h1.5_rc_final = 4,
        Powerhouse = 2,
        Toys_In_The_Warehouse = 2,
        extermination = 1,
        windfall_island = 3,
        lolcano = 2,
        xbox_hotbox_h1.5_rc_final = 3,
        pac-man = 4,
        Valis = 1,
        revolutions = 4,
        Zanzibar_INTENSE = 1,
        longest = 2,
        [halo4-reach]re-prisoner = 2,
        hydroxide = 1,
        mermaids_plaza = 1,
        newgulch_5 = 3,
        H2_Momentum = 4,
        [CoD]Templo-En-Guerra = 3,
        CMT_Tensity = 2,
        battlecreek_v2 = 2,
        pipeline = 1,
        carnage_springs = 3,
        CnR_Island = 1,
        chaos_zanzibar = 3,
        Falujah_1.2 = 1,
        djw-pacman = 3,
        Sniper_Training = 4,
        Medical Block = 2,
]]
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
        snowdrop = 4,
        dustbeta = 0, -- WARNING - KEEP ZERO! Dust Beta doesn't have Plasma Grenades.
        amysroom_beta = 0,
        --      <map name> = <number><comma>
        --[[
        Homestead = 3,
        [H2]_Ivory_Tower = 2,
        dmt_racing = 1,
        deltaruined_intense = 3,
        tension = 4,
        Armageddon = 2,
        tactics = 1,
        nitra = 1,
        Garden_CE = 1,
        lucidity_rc_b = 2,
        ewok = 4,
        bc_Carousel_mp = 3,
        bounce_arena = 4,
        church = 2,
        smallprawn = 3,
        Cell2 = 2,
        Bridge_crossing = 4,
        lavaflows = 1,
        Crimson_Woods = 2,
        DMT-Goldeneye_Stack-BETA = 3,
        sniperbluff = 4,
        helix_canyon = 3,
        UMT_Archive = 1,
        fission_point = 2,
        Nyctophobia = 4,
        FeelGoodInc = 4,
        [Z-5]-chillout_alpha = 3,
        CMT_V2_Dissolution = 3,
        siege = 4,
        Dredwerkz_PB2 = 1,
        EMT_Inverno = 3,
        tm_immolate = 1,
        destiny = 4,
        corrupted = 2,
        Division = 3,
        Hornets_Nest = 1,
        headquarters_beta_v2 = 1,
        hmf_marecage = 3,
        Ambush = 2,
        sidewinder_v2 = 2,
        TrainingDay = 1,
        [h3] core = 3,
        pass_bridge = 3,
        Serenity(ADB) = 1,
        old_cemetery = 3,
        river = 2,
        Dance = 4,
        Claustrophobia2 = 2,
        ancient_sanctuary_beta = 4,
        municipality = 2,
        paranoia = 1,
        CMT_G3_Augur = 3,
        Train.Station = 4,
        fates_gulch = 1,
        tower = 4,
        Bigass = 2,
        aquarii_final = 4,
        OverGrown = 2,
        huh-what_3 = 4,
        Lake_Serenity = 2,
        Orion_final = 4,
        fissurefall = 1,
        deagle6_texture = 1,
        disco = 2,
        obelisk = 1,
        [H4-beta]re-damnation = 2,
        CMT_G3_MouseTrap = 2,
        integrity = 1,
        No_Remorse = 3,
        [H2]_ascension = 4,
        tempo = 3,
        infested = 1,
        treehouse = 3,
        fox_condensedGAMMA = 2,
        Enigma = 4,
        Dead_End = 3,
        confined = 4,
        complex = 1,
        Seclusion_redux = 4,
        combat_arena = 1,
        camden_place = 3,
        ivory_tower_final = 4,
        bacon = 2,
        amysroom_beta = 4,
        dioptase = 1,
        airball = 4,
        aboveandbelow = 2,
        tunnel = 2,
        triduct = 3,
        xbox_decidia_h1.5_rc_final = 4,
        Powerhouse = 1,
        Toys_In_The_Warehouse = 1,
        extermination = 3,
        windfall_island = 2,
        lolcano = 2,
        xbox_hotbox_h1.5_rc_final = 3,
        pac-man = 3,
        Valis = 1,
        revolutions = 3,
        Zanzibar_INTENSE = 2,
        longest = 3,
        [halo4-reach]re-prisoner = 1,
        hydroxide = 2,
        mermaids_plaza = 4,
        newgulch_5 = 4,
        H2_Momentum = 1,
        [CoD]Templo-En-Guerra = 4,
        CMT_Tensity = 1,
        battlecreek_v2 = 3,
        pipeline = 2,
        carnage_springs = 2,
        CnR_Island = 1,
        chaos_zanzibar = 1,
        Falujah_1.2 = 2,
        djw-pacman = 2,
        Sniper_Training = 2,
        Medical Block = 3,
]]
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
    weapon[PlayerIndex] = true
    mapname = get_var(0, "$map")
    if player_alive(PlayerIndex) then
        local player_object = get_dynamic_player(PlayerIndex)
        if (player_object ~= 0) then
            if (gamesettings["Give_Frag_Grenades"] == true) then
                if (frags[mapname] == nil) then
                    -- Use default grenade settings instead.
                    Error = 'Error: ' .. mapname .. ' is not listed in the Frag Grenade Table - Line 228 | Unable to set frags.'
                    cprint(Error, 4 + 8)
                    execute_command("log_note \"" .. Error .. "\"")
                else
                    write_word(player_object + 0x31E, frags[mapname])
                    -- cprint("Spawning with " ..frags[mapname].. " frags!", 2+8)
                end
            end
            if (gamesettings["Give_Plasma_Grenades"] == true) then
                if (plasmas[mapname] == nil) then
                    -- Use default grenade settings instead.
                    Error = 'Error: ' .. mapname .. ' is not listed in the Plasma Grenade Table - Line 373 | Unable to set plasmas.'
                    cprint(Error, 4 + 8)
                    execute_command("log_note \"" .. Error .. "\"")
                else
                    write_word(player_object + 0x31F, plasmas[mapname])
                    -- cprint("Spawning with " ..plasmas[mapname].. " plasmas!", 2+8)
                end
            end
        end
    end
end

function table.match(table, value)
    for k, v in pairs(table) do
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
        cprint(Error, 4 + 8)
        execute_command("log_note \"" .. Error .. "\"")
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
                if (weapon[i] == true) then
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
                        weapon[i] = false
                    elseif (mapname == "snowdrop") then
                        assign_weapon(spawn_object("weap", weapons[27], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[24], x, y, z), i)
                        -- assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        -- assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                        -----------------------------------------------------------------------------------------------------
                        -- =================================== D E F A U L T   M A P S =================================== --
                    elseif (mapname == "beavercreek") then
                        assign_weapon(spawn_object("weap", weapons[8], x, y, z), i) -- Flame Thrower
                        assign_weapon(spawn_object("weap", weapons[3], x, y, z), i) -- Plasma Cannon
                        weapon[i] = false
                    elseif (mapname == "bloodgulch") then
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) -- Rocket Launcher
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i) -- Sniper Rifle
                        weapon[i] = false
                    elseif (mapname == "boardingaction") then
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i) -- Plasma Rifle
                        assign_weapon(spawn_object("weap", weapons[5], x, y, z), i) -- Plasma Pistol
                        weapon[i] = false
                    elseif (mapname == "carousel") then
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i) -- Sniper Rifle
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        weapon[i] = false
                    elseif (mapname == "dangercanyon") then
                        assign_weapon(spawn_object("weap", weapons[8], x, y, z), i) -- Flame Thrower
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) -- Rocket Launcher
                        weapon[i] = false
                    elseif (mapname == "deathisland") then
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i) -- Sniper Rifle
                        assign_weapon(spawn_object("weap", weapons[5], x, y, z), i) -- Plasma Pistol
                        weapon[i] = false
                    elseif (mapname == "gephyrophobia") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i) -- Sniper Rifle
                        weapon[i] = false
                    elseif (mapname == "icefields") then
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) -- Rocket Launcher
                        assign_weapon(spawn_object("weap", weapons[10], x, y, z), i) -- Shotgun
                        weapon[i] = false
                    elseif (mapname == "infinity") then
                        assign_weapon(spawn_object("weap", weapons[7], x, y, z), i) -- Assault Rifle
                        assign_weapon(spawn_object("weap", weapons[10], x, y, z), i) -- Shotgun
                        weapon[i] = false
                    elseif (mapname == "sidewinder") then
                        assign_weapon(spawn_object("weap", weapons[9], x, y, z), i) -- Needler
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i) -- Plasma Rifle
                        weapon[i] = false
                    elseif (mapname == "timberland") then
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i) -- Plasma Rifle
                        assign_weapon(spawn_object("weap", weapons[10], x, y, z), i) -- Shotgun
                        weapon[i] = false
                    elseif (mapname == "hangemhigh") then
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i) -- Sniper Rifle
                        assign_weapon(spawn_object("weap", weapons[8], x, y, z), i) -- Flame Thrower
                        weapon[i] = false
                    elseif (mapname == "ratrace") then
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) -- Rocket Launcher
                        assign_weapon(spawn_object("weap", weapons[3], x, y, z), i) -- Plasma Cannon
                        weapon[i] = false
                    elseif (mapname == "damnation") then
                        assign_weapon(spawn_object("weap", weapons[8], x, y, z), i) -- Flame Thrower
                        assign_weapon(spawn_object("weap", weapons[9], x, y, z), i) -- Needler
                        weapon[i] = false
                    elseif (mapname == "putput") then
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) -- Rocket Launcher
                        assign_weapon(spawn_object("weap", weapons[5], x, y, z), i) -- Plasma Pistol
                        weapon[i] = false
                    elseif (mapname == "prisoner") then
                        assign_weapon(spawn_object("weap", weapons[7], x, y, z), i) -- Assault Rifle
                        assign_weapon(spawn_object("weap", weapons[9], x, y, z), i) -- Needler
                        weapon[i] = false
                    elseif (mapname == "wizard") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i) -- Plasma Rifle
                        weapon[i] = false
                        -----------------------------------------------------------------------------------------------------
                        -- =================================== C U S T O M   M A P S =================================== --
                    elseif (mapname == "amysroom_beta") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                        --[[
                    elseif (mapname == "[H2]_Ivory_Tower") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "dmt_racing") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "deltaruined_intense") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "tension") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "dustbeta") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Armageddon") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "tactics") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "nitra") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Garden_CE") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "lucidity_rc_b") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "ewok") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "bc_Carousel_mp") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "bounce_arena") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "church") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "smallprawn") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Cell2") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Bridge_crossing") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "lavaflows") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Crimson_Woods") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "DMT-Goldeneye_Stack-BETA") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "sniperbluff") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "helix_canyon") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "UMT_Archive") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "fission_point") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Nyctophobia") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "FeelGoodInc") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "[Z-5]-chillout_alpha") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "CMT_V2_Dissolution") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "siege") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Dredwerkz_PB2") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "EMT_Inverno") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "tm_immolate") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "destiny") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "corrupted") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Division") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Hornets_Nest") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "headquarters_beta_v2") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "hmf_marecage") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Ambush") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "sidewinder_v2") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "TrainingDay") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "[h3] core") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "pass_bridge") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Serenity(ADB)") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "old_cemetery") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "river") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Dance") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Claustrophobia2") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "ancient_sanctuary_beta") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "municipality") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "paranoia") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "CMT_G3_Augur") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Train.Station") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "fates_gulch") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "tower") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Bigass") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "aquarii_final") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "OverGrown") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "huh-what_3") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Lake_Serenity") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Orion_final") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "fissurefall") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "deagle6_texture") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "disco") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "obelisk") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "[H4-beta]re-damnation") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "CMT_G3_MouseTrap") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "No_Remorse") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "[H2]_ascension") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "tempo") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "infested") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "treehouse") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "fox_condensedGAMMA") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Enigma") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Dead_End") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "confined") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "complex") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Seclusion_redux") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "combat_arena") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "camden_place") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "ivory_tower_final") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "bacon") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "amysroom_beta") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "dioptase") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "airball") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "aboveandbelow") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "tunnel") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "triduct") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "xbox_decidia_h1.5_rc_final") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Powerhouse") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Toys_In_The_Warehouse") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "extermination") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "windfall_island") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "lolcano") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "xbox_hotbox_h1.5_rc_final") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "pac-man") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Valis") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "revolutions") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Zanzibar_INTENSE") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "longest") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "[halo4-reach]re-prisoner") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "hydroxide") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "mermaids_plaza") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "newgulch_5") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "H2_Momentum") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "[CoD]Templo-En-Guerra") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "CMT_Tensity") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "battlecreek_v2") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "pipeline") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "carnage_springs") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "CnR_Island") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "chaos_zanzibar") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Falujah_1.2") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "pacman") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Sniper_Training") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
                    elseif (mapname == "Medical Block") then
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[00000], x, y, z), i)
                        weapon[i] = false
]]
                    end
                end
            end
        end
    end
end

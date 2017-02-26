--[[
Script Name: LEVEL UP (beta v1.0), for SAPP | (PC\CE)
Implementing API version: 1.11.0.0

    Acknowledgments
    Credits to "Giraffe" for his AutoVehicle-Flip functions.
    Credits to 002 for his get_tag_info function (return metaid)
    
This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
]]

api_version = "1.11.0.0"
Starting_Level = 1 -- Must match beginning of level[#]
Spawn_Invunrable_Time = nil -- Seconds - nil disabled
Speed_Powerup = 2 -- in seconds
Speed_Powerup_duration = 20 -- in seconds
Spawn_Where_Killed = false -- Spawn at the same location as player died
Melee_Multiplier = 4 -- Multiplier to meele damage. 1 = normal damage
Normal_Damage = 1 -- Normal weppon damage multiplier. 1 = normal damage
CTF_ENABLED = true
Check_Radius = 1 -- Radius determining if player is in scoring area
Check_Time = 0 -- Mili-seconds to check if player in scoring area
FLAG_SPEED = 2.0 -- Flag-Holder running speed
CAMO_TIME = 15 -- Flag-Holder invisibility time
ADMIN_LEVEL = 1 -- Default admin level required to use chat commandss
-- Giraffe's --
PLAYER_VEHICLES_ONLY = true -- true or false, whether or not to only auto flip vehicles that players are in
WAIT_FOR_IMPACT = true -- true or false, whether or not to wait until impact before auto flipping vehicle
-----------------------------------------------------------------------------------------------------------

-- Objects to drop when someone dies
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
-- Objects to drop when someone dies
WEAPON_TABLE = { }
WEAPON_TABLE[1] = "weapons\\assault rifle\\assault rifle"
WEAPON_TABLE[2] = "weapons\\flamethrower\\flamethrower"
WEAPON_TABLE[3] = "weapons\\needler\\mp_needler"
WEAPON_TABLE[4] = "weapons\\pistol\\pistol"
WEAPON_TABLE[5] = "weapons\\plasma pistol\\plasma pistol"
WEAPON_TABLE[6] = "weapons\\plasma rifle\\plasma rifle"
WEAPON_TABLE[7] = "weapons\\plasma_cannon\\plasma_cannon"
WEAPON_TABLE[8] = "weapons\\rocket launcher\\rocket launcher"
WEAPON_TABLE[9] = "weapons\\shotgun\\shotgun"
WEAPON_TABLE[10] = "weapons\\sniper rifle\\sniper rifle"
-- Choose what to drop when someone dies.
PowerUpSettings = {
    ["WeaponsAndEquipment"] = false,
    ["JustEquipment"] = false,
    ["JustWeapons"] = false
}
rider_ejection = nil
object_table_ptr = nil
CURRENT_FLAG_HOLDER = nil
FLAG = { }
players = { }
last_damage = { }
Stored_Levels = { }
Equipment_Tags = { }
DEATH_LOCATION = { }
for i = 1, 16 do DEATH_LOCATION[i] = { } end
vehi_type_id = "vehi"
weap_type_id = "weap"
-- Red Base, Blue Base, Flag Location
FLAG["bloodgulch"] = { { 95.687797546387, - 159.44900512695, - 0.10000000149012 }, { 40.240600585938, - 79.123199462891, - 0.10000000149012 }, { 65.749893188477, - 120.40949249268, 0.11860413849354 } }
FLAG["deathisland"] = { { - 26.576030731201, - 6.9761986732483, 9.6631727218628 }, { 29.843469619751, 15.971487045288, 8.2952880859375 }, { - 30.282138824463, 31.312761306763, 16.601940155029 } }
FLAG["icefields"] = { { 24.85000038147, - 22.110000610352, 2.1110000610352 }, { - 77.860000610352, 86.550003051758, 2.1110000610352 }, { - 26.032163619995, 32.365093231201, 9.0070295333862 } }
FLAG["infinity"] = { { 0.67973816394806, - 164.56719970703, 15.039022445679 }, { - 1.8581243753433, 47.779975891113, 11.791272163391 }, { 9.6316251754761, - 64.030670166016, 7.7762198448181 } }
FLAG["sidewinder"] = { { - 32.038200378418, - 42.066699981689, - 3.7000000476837 }, { 30.351499557495, - 46.108001708984, - 3.7000000476837 }, { 2.0510597229004, 55.220195770264, - 2.8019363880157 } }
FLAG["timberland"] = { { 17.322099685669, - 52.365001678467, - 17.751399993896 }, { - 16.329900741577, 52.360000610352, - 17.741399765015 }, { 1.2504668235779, - 1.4873152971268, - 21.264007568359 } }

FLAG["dangercanyon"] = { { - 12.104507446289, - 3.4351840019226, - 2.2419033050537 }, { 12.007399559021, - 3.4513700008392, - 2.2418999671936 }, { - 0.47723594307899, 55.331966400146, 0.23940123617649 } }
FLAG["beavercreek"] = { { 29.055599212646, 13.732000350952, - 0.10000000149012 }, { - 0.86037802696228, 13.764800071716, - 0.0099999997764826 }, { 14.01514339447, 14.238339424133, - 0.91193699836731 } }
FLAG["boardingaction"] = { { 1.723109960556, 0.4781160056591, 0.60000002384186 }, { 18.204000473022, - 0.53684097528458, 0.60000002384186 }, { 4.3749675750732, - 12.832932472229, 7.2201852798462 } }
FLAG["carousel"] = { { 5.6063799858093, - 13.548299789429, - 3.2000000476837 }, { - 5.7499198913574, 13.886699676514, - 3.2000000476837 }, { 0.033261407166719, 0.0034416019916534, - 0.85620224475861 } }
FLAG["chillout"] = { { 7.4876899719238, - 4.49059009552, 2.5 }, { - 7.5086002349854, 9.750340461731, 0.10000000149012 }, { 1.392117857933, 4.7001452445984, 3.108856678009 } }
FLAG["damnation"] = { { 9.6933002471924, - 13.340399742126, 6.8000001907349 }, { - 12.17884349823, 14.982703208923, - 0.20000000298023 }, { - 2.0021493434906, - 4.3015551567078, 3.3999974727631 } }
FLAG["gephyrophobia"] = { { 26.884338378906, - 144.71551513672, - 16.049139022827 }, { 26.727857589722, 0.16621616482735, - 16.048349380493 }, { 63.513668060303, - 74.088592529297, - 1.0624552965164 } }
FLAG["hangemhigh"] = { { 13.047902107239, 9.0331249237061, - 3.3619771003723 }, { 32.655700683594, - 16.497299194336, - 1.7000000476837 }, { 21.020147323608, - 4.6323413848877, - 4.2290902137756 } }
FLAG["longest"] = { { - 12.791899681091, - 21.6422996521, - 0.40000000596046 }, { 11.034700393677, - 7.5875601768494, - 0.40000000596046 }, { - 0.80207985639572, - 14.566205024719, 0.16665624082088 } }
FLAG["prisoner"] = { { - 9.3684597015381, - 4.9481601715088, 5.6999998092651 }, { 9.3676500320435, 5.1193399429321, 5.6999998092651 }, { 0.90271377563477, 0.088873945176601, 1.392499089241 } }
FLAG["putput"] = { { - 18.89049911499, - 20.186100006104, 1.1000000238419 }, { 34.865299224854, - 28.194700241089, 0.10000000149012 }, { - 2.3500289916992, - 21.121452331543, 0.90232092142105 } }
FLAG["ratrace"] = { { - 4.2277698516846, - 0.85564690828323, - 0.40000000596046 }, { 18.613000869751, - 22.652599334717, - 3.4000000953674 }, { 8.6629104614258, - 11.159770965576, 0.2217468470335 } }
FLAG["wizard"] = { { - 9.2459697723389, 9.3335800170898, - 2.5999999046326 }, { 9.1828498840332, - 9.1805400848389, - 2.5999999046326 }, { - 5.035900592804, - 5.0643291473389, - 2.7504394054413 } }

function LoadLarge()
    Level = { }
    Level[1] = { "weapons\\shotgun\\shotgun", "Shotgun", "Melee or Nades!", 1, { 6, 6 }, 0 }
    Level[2] = { "weapons\\assault rifle\\assault rifle", "Assualt Rifle", "Aim and unload!", 2, { 2, 2 }, 120 }
    Level[3] = { "weapons\\pistol\\pistol", "Pistol", "Aim for the head", 3, { 2, 1 }, 12 }
    Level[4] = { "weapons\\sniper rifle\\sniper rifle", "Sniper Rifle", "Aim, Exhale and fire!", 4, { 3, 2 }, 4 }
    Level[5] = { "weapons\\rocket launcher\\rocket launcher", "Rocket Launcher", "Blow people up!", 5, { 1, 1 }, 4 }
    Level[6] = { "weapons\\plasma_cannon\\plasma_cannon", "Fuel Rod", "Bombard anything that moves!", 6, { 3, 1 }, 1 }
    Level[7] = { "vehicles\\ghost\\ghost_mp", "Ghost", "Run people down!", 7, { 0, 0 }, 0 }
    Level[8] = { "vehicles\\rwarthog\\rwarthog", "Rocket Hog", "Blow em' up!", 8, { 0, 0 }, 0 }
    Level[9] = { "vehicles\\scorpion\\scorpion_mp", "Tank", "Wreak havoc!", 9, { 0, 0 }, 0 }
    Level[10] = { "vehicles\\banshee\\banshee_mp", "Banshee", "Hurry up and win!", 10, { 0, 0 }, 0 }
    for k, v in pairs(Level) do
        if string.find(v[1], "vehicles") then
            v[11] = v[1]
            v[12] = 1
        else
            v[11] = v[1]
            v[12] = 0
        end
    end
end

function LoadSmall()
    Level = { }
    Level[1] = { "weapons\\shotgun\\shotgun", "Shotgun", "Melee or Nades!", 1, { 6, 6 }, 0 }
    Level[2] = { "weapons\\assault rifle\\assault rifle", "Assualt Rifle", "Aim and unload!", 2, { 2, 2 }, 120 }
    Level[3] = { "weapons\\pistol\\pistol", "Pistol", "Aim for the head", 3, { 2, 1 }, 12 }
    Level[4] = { "weapons\\sniper rifle\\sniper rifle", "Sniper Rifle", "Aim, Exhale and fire!", 4, { 3, 2 }, 4 }
    Level[5] = { "weapons\\rocket launcher\\rocket launcher", "Rocket Launcher", "Blow people up!", 5, { 1, 1 }, 4 }
    Level[6] = { "weapons\\plasma_cannon\\plasma_cannon", "Fuel Rod", "Bombard anything that moves!", 6, { 3, 1 }, 1 }
    for k, v in pairs(Level) do
        if string.find(v[1], "weapons") then
            v[7] = v[1]
            v[8] = 1
        else
            v[7] = v[1]
            v[8] = 0
        end
    end
end  
     
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerLeave")
    register_callback(cb["EVENT_GAME_START"], "OnNewGame")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_WEAPON_DROP'], "OnWeaponDrop")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPrespawn")
    register_callback(cb["EVENT_VEHICLE_EXIT"], "OnVehicleExit")
    register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")
    -- Giraffe's object_table_ptr --
    object_table_ptr = sig_scan("8B0D????????8B513425FFFF00008D")
    LoadItems()
    MAP_NAME = get_var(1, "$map")
    -- Check if valid GameType
    CheckType()
    gametype = get_var(0, "$gt")
    -- set score limit --
    execute_command("scorelimit 250")
    -- disable vehicle entry --
    execute_command("disable_all_vehicles 0 1")
    -- disable weapon pickups --
    execute_command("disable_object 'weapons\\assault rifle\\assault rifle'")
    execute_command("disable_object 'weapons\\flamethrower\\flamethrower'")
    execute_command("disable_object 'weapons\\needler\\mp_needler'")
    execute_command("disable_object 'weapons\\pistol\\pistol'")
    execute_command("disable_object 'weapons\\plasma pistol\\plasma pistol'")
    execute_command("disable_object 'weapons\\plasma rifle\\plasma rifle'")
    execute_command("disable_object 'weapons\\plasma_cannon\\plasma_cannon'")
    execute_command("disable_object 'weapons\\rocket launcher\\rocket launcher'")
    execute_command("disable_object 'weapons\\shotgun\\shotgun'")
    execute_command("disable_object 'weapons\\sniper rifle\\sniper rifle'")
    -- disable grenade pickups --
    execute_command("disable_object 'weapons\\frag grenade\\frag grenade'")
    execute_command("disable_object 'weapons\\plasma grenade\\plasma grenade'")
    for i = 1, 16 do
        if player_present(i) then
            last_damage[i] = 0
        end
    end
     -- Giraffe's --
    if (halo_type == "CE") then
        rider_ejection = read_byte(0x59A34C)
        write_byte(0x59A34C, 0)
    else
        rider_ejection = read_byte(0x6163EC)
        write_byte(0x6163EC, 0)
    end
    -- =========================================--
end

function OnScriptUnload()
    FLAG = { }
    players = { }
    last_damage = { }
    WEAPON_TABLE = { }
    Stored_Levels = { }
    DEATH_LOCATION = { }
    Equipment_Tags = { }
    EQUIPMENT_TABLE = { }
    rider_ejection = nil
    object_table_ptr = nil
    CURRENT_FLAG_HOLDER = nil
    if (halo_type == "CE") then -- Giraffe's
        write_byte(0x59A34C, rider_ejection)
    else
        write_byte(0x6163EC, rider_ejection)
    end
    -- ========================================--
end

function WelcomeHandler(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "Welcome to vm315 - LEVEL UP (beta v1.0)")
    say(PlayerIndex, "Type @info if you don't know How to Play")
    say(PlayerIndex, "Type @stats to view your current stats.")
    execute_command("msg_prefix \"** SERVER ** \"")
end

function InfoHandler(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "Kill players to gain a Level.")
    say(PlayerIndex, "Being meeled or committing suicide will result in moving down a Level.")
    say(PlayerIndex, "There is a Flag somewhere on the map - Return it to a base to gain a Level.")
    execute_command("msg_prefix \"** SERVER ** \"")
end

function OnNewGame()
    game_over = false
    CheckType()
    LoadItems()
    MAP_NAME = get_var(1, "$map")
    gametype = get_var(0, "$gt")
    for i = 1, 16 do
        if player_present(i) then
            last_damage[i] = 0
        end
    end
    if CTF_ENABLED == true then SPAWN_FLAG() end
    GameHasStarted = true
    if MAP_NAME == "bloodgulch" or MAP_NAME == "timberland"
        or MAP_NAME == "sidewinder" or MAP_NAME == "dangercanyon" or MAP_NAME == "deathisland"
        or MAP_NAME == "icefields" or MAP_NAME == "infinity" then
        LargeMapConfiguration = true
        LoadLarge()
    end
    if MAP_NAME == "beavercreek" or MAP_NAME == "boardingaction" or MAP_NAME == "carousel"
        or MAP_NAME == "chillout" or MAP_NAME == "damnation" or MAP_NAME == "gephyrophobia"
        or MAP_NAME == "hangemhigh" or MAP_NAME == "longest" or MAP_NAME == "prisoner"
        or MAP_NAME == "putput" or MAP_NAME == "ratrace" or MAP_NAME == "wizard" then
        LargeMapConfiguration = false
        LoadSmall()
    end
end

function OnGameEnd()
    last_damage = { }
    Level = { }
    rider_ejection = nil
    object_table_ptr = nil
    CURRENT_FLAG_HOLDER = nil
    for i = 1, 16 do
        if player_present(i) then
            last_damage[i] = 0
        end
    end
    GameHasStarted = false
end

function SPAWN_FLAG()
    MAP_NAME = get_var(1, "$map")
    local t = FLAG[MAP_NAME][3]
    -- Spawn flag at x,y,z
    flag_objId = spawn_object("weap", "weapons\\flag\\flag", t[1], t[2], t[3])
end

function OnTick()
    -- Giraffe's Fucntion --
    if (PLAYER_VEHICLES_ONLY) then
        for i = 1, 16 do
            if (player_alive(i)) then
                local player = get_dynamic_player(i)
                local player_vehicle_id = read_dword(player + 0x11C)
                if (player_vehicle_id ~= 0xFFFFFFFF) then
                    local vehicle = get_object_memory(player_vehicle_id)
                    flip_vehicle(vehicle)
                end
            end
        end
    else
        local object_table = read_dword(read_dword(object_table_ptr + 2))
        local object_count = read_word(object_table + 0x2E)
        local first_object = read_dword(object_table + 0x34)
        for i = 0, object_count - 1 do
            local object = read_dword(first_object + i * 0xC + 0x8)
            if (object ~= 0 and object ~= 0xFFFFFFFF) then
                if (read_word(object + 0xB4) == 1) then
                    flip_vehicle(object)
                end
            end
        end
    end
end

function flip_vehicle(Object)
    -- Giraffe's Fucntion --
    if (read_bit(Object + 0x8B, 7) == 1) then
        if (WAIT_FOR_IMPACT and read_bit(Object + 0x10, 1) == 0) then
            return
        end
        write_vector3d(Object + 0x80, 0, 0, 1)
    end
end

function OnVehicleExit(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if player_object ~= 0 then
        vehicle_Id = read_dword(player_object + 0x11C)
        obj_id = get_object_memory(vehicle_Id)
        exit_vehicle(PlayerIndex)
        timer(1000*2, "DestroyVehicle", vehicle_Id)
        execute_command("msg_prefix \"\"")
        say(PlayerIndex, 'Type "/enter me" to enter your previous vehicle.')
        execute_command("msg_prefix \"** SERVER ** \"")
    end
end

function WriteNavs(killer)
    for i = 1, 16 do
        if getplayer(i) then
            local m_player = getplayer(i)
            if m_player then
                local slayer_target = read_word(m_player, 0x88)
                if slayer_target < 16 and slayer_target > -1 then
                    write_word(m_player, 0x88, killer)
                end
            end
        end
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    -- local player = get_player(PlayerIndex)
    -- write_dword(player + 0x2C, 1 * 33)
    ------------------------------------------
    -- If victim was in a vehicle, destroy it...
    local player_object = get_dynamic_player(victim)
    if PlayerInVehicle(victim) then
        if player_object ~= 0 then
            vehicle_Id = read_dword(player_object + 0x11C)
            timer(0, "DestroyVehicle", vehicle_Id)
        end
    end
    -- PvP --
    if (killer > 0) and (victim ~= killer) --[[and get_var(victim, "$team") ~= get_var(killer, "$team")]] then
        if last_damage[PlayerIndex] == assault_melee or
            last_damage[PlayerIndex] == ball_melee or
            last_damage[PlayerIndex] == flag_melee or
            last_damage[PlayerIndex] == flame_melee or
            last_damage[PlayerIndex] == needle_melee or
            last_damage[PlayerIndex] == pistol_melee or
            last_damage[PlayerIndex] == ppistol_melee or
            last_damage[PlayerIndex] == prifle_melee or
            last_damage[PlayerIndex] == pcannon_melee or
            last_damage[PlayerIndex] == rocket_melee or
            last_damage[PlayerIndex] == shotgun_melee or
            last_damage[PlayerIndex] == sniper_melee then
            -- Player was melee'd, move them down a level
            MELEE_VICTIM = tonumber(PlayerIndex)
            --VICTIM_WAS_MELEED = true
            cycle_level(victim, true) -- update, level down
        end
        -- Add kill to Killer | Check if victim was Flag Holder.
        add_kill(killer, victim)
        if Spawn_Where_Killed == true then
            local player_object = get_dynamic_player(victim)
            local xAxis, yAxis, zAxis = read_vector3d(player_object + 0x5C)
            DEATH_LOCATION[victim][1] = xAxis
            DEATH_LOCATION[victim][2] = yAxis
            DEATH_LOCATION[victim][3] = zAxis
            if (PowerUpSettings["WeaponsAndEquipment"] == true) then
                WeaponsAndEquipment(xAxis, yAxis, zAxis)
            elseif (PowerUpSettings["JustEquipment"] == true) then
                JustEquipment(xAxis, yAxis, zAxis)
            elseif (PowerUpSettings["JustWeapons"] == true) then
                JustWeapons(xAxis, yAxis, zAxis)
            end
        end
    -- SUICIDE --
    elseif tonumber(PlayerIndex) == tonumber(KillerIndex) then
        VICTIM_SUICIDE = tonumber(PlayerIndex)
        -- Player Committed Suicide, move them down a level
        cycle_level(victim, true) -- update, level down
        if Spawn_Where_Killed == true then
            local player_object = get_dynamic_player(victim)
            local xAxis, yAxis, zAxis = read_vector3d(player_object + 0x5C)
            DEATH_LOCATION[victim][1] = xAxis
            DEATH_LOCATION[victim][2] = yAxis
            DEATH_LOCATION[victim][3] = zAxis
            if (PowerUpSettings["WeaponsAndEquipment"] == true) then
                WeaponsAndEquipment(xAxis, yAxis, zAxis)
            elseif (PowerUpSettings["JustEquipment"] == true) then
                JustEquipment(xAxis, yAxis, zAxis)
            elseif (PowerUpSettings["JustWeapons"] == true) then
                JustWeapons(xAxis, yAxis, zAxis)
            end
        end
        timer(500, "delay_score", PlayerIndex)
        timer(500, "delay_score", KillerIndex)
    end
    -- KILLED BY SERVER --
    if (killer == -1) then
        return false
    end
    -- UNKNOWN/GLITCHED --
    if (killer == nil) then
        return false
    end
    -- KILLED BY VEHICLE --
    if (killer == 0) then
        return false
    end
    last_damage[PlayerIndex] = 0
end

function add_kill(killer, victim)
    -- If the Flag Holder (victim) is killed, respawn the flag, but only if they died from being melee'd.
    if (victim == CURRENT_FLAG_HOLDER) and (victim == MELEE_VICTIM) then
        SPAWN_FLAG()
    end
    -- add on a kill
    local kills = players[killer][2]
    players[killer][2] = kills + 1
    -- check to see if player advances
    if players[killer][2] == Level[players[killer][1]][4] then
        if (killer == CURRENT_FLAG_HOLDER) then 
            drop_weapon(killer)
            -- Killer Melee'd someone while holding the flag - delay scoring to avoid deleting their flag on cycle_level.
            timer(1, "delay_cycle", killer)
        else
            -- PvP, level up (update, advance)
            cycle_level(killer, true, true)
        end
    end
end

function delay_score(id, count, PlayerIndex)
    if PlayerIndex then
        setscore(PlayerIndex, players[PlayerIndex][1])
    end
    return 0
end

function delay_cycle(killer)
    local Player = tonumber(killer)
    cycle_level(Player, true, true)
end

function DropPowerup(x, y, z)
    local num = rand(1, #Equipment_Tags)
    spawn_object(Equipment_Tags[num], x, y, z + 0.5)
end

function OnPlayerJoin(PlayerIndex)
    -- set level
    players[PlayerIndex] = { Starting_Level, 0 }

    local saved_data = get_var(PlayerIndex, "$hash") .. ":" .. get_var(PlayerIndex, "$name")
    -- Check for Previous Statistics --
    for k, v in pairs(Stored_Levels) do
        if tostring(k) == tostring(saved_data) then
            players[PlayerIndex][1] = Stored_Levels[saved_data][1]
            players[PlayerIndex][2] = Stored_Levels[saved_data][2]
            break
        end
    end
    -- Assign Weapons, Frags, and Ammo --
    timer(1000*6, "WelcomeHandler", PlayerIndex)
    -- Update score to reflect changes.
    setscore(PlayerIndex, players[PlayerIndex][1]) -- First initial score is equal to Level 1 (score point 1)
end

function OnPlayerLeave(PlayerIndex)
    last_damage[PlayerIndex] = nil
    local saved_data = get_var(PlayerIndex, "$hash") .. ":" .. get_var(PlayerIndex, "$name")
    -- Create Table Key for Player --
    Stored_Levels[saved_data] = { players[PlayerIndex][1], players[PlayerIndex][2] }
    -- Wipe Saved Spawn Locations
    for i = 1, 3 do
        -- reset death location --
        DEATH_LOCATION[PlayerIndex][i] = nil
    end
end

function OnPlayerPrespawn(PlayerIndex)
    -- reset last damage --
    last_damage[PlayerIndex] = 0
    if spawn_where_killed == true then
        local victim = tonumber(PlayerIndex)
        if PlayerIndex then
            if DEATH_LOCATION[victim][1] ~= nil then
                -- spawn at death location --
                write_vector3d(get_dynamic_player(victim) + 0x5C, DEATH_LOCATION[victim][1], DEATH_LOCATION[victim][2], DEATH_LOCATION[victim][3])
                for i = 1, 3 do
                    -- reset death location --
                    DEATH_LOCATION[victim][i] = nil
                end
            end
        end
    end
end

function OnPlayerSpawn(PlayerIndex)
    if getplayer(PlayerIndex) then
        default_speed = 1
        execute_command("s " .. PlayerIndex .. " :" .. default_speed)
        --  assign weapons or vehicle according to level --
        if (LargeMapConfiguration == true) then 
            WeaponHandler(PlayerIndex)
        elseif (LargeMapConfiguration == false) then
            WeaponHandlerAlternate(PlayerIndex)
        end
        --  Setup Invulnerable Timer --
        if Spawn_Invunrable_Time ~= nil and Spawn_Invunrable_Time > 0 then
            write_float(PlayerIndex + 0xE0, 99999999)
            -- Health. (0 to 1) (Normal = 1)
            write_float(PlayerIndex + 0xE4, 99999999)
            -- Overshield. (0 to 3) (Normal = 1) (Full overshield = 3)
            timer(Spawn_Invunrable_Time * 1000, "RemoveSpawnProtect", PlayerIndex)
        end
        rprint(PlayerIndex, "Level: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level))
        rprint(PlayerIndex, "Kills Needed Advance: " .. tostring(Level[players[PlayerIndex][1]][4]))
        rprint(PlayerIndex, "Your Weapon: " .. tostring(Level[players[PlayerIndex][1]][2]))
        rprint(PlayerIndex, "Your Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
        rprint(PlayerIndex, " ")
        CURRENT_LEVEL = tonumber(players[PlayerIndex][1])
    end
end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
    if tonumber(Type) == 1 then
        if get_var(0, "$gt") ~= "n/a" then
            flag_id = read_dword(read_dword(read_dword(lookup_tag("matg", "globals\\globals") + 0x14) + 0x164 + 4) + 0x0 + 0xC)
            local player_object = get_dynamic_player(PlayerIndex)
            local weapon_object = get_object_memory(read_dword(player_object + 0x2F8 +(tonumber(WeaponIndex) -1) * 4))
            local MetaID = read_dword(weapon_object)
            if (MetaID ~= nil) then
                if (MetaID == flag_id) then
                    DROPPED = false
                    CURRENT_FLAG_HOLDER = tonumber(PlayerIndex)
                    MonitorLocation(PlayerIndex)
                    rprint(CURRENT_FLAG_HOLDER, "|cReturn the flag to a base to gain an instant level!")
                    rprint(CURRENT_FLAG_HOLDER, "|c")
                    rprint(CURRENT_FLAG_HOLDER, "|c")
                    rprint(CURRENT_FLAG_HOLDER, "|c")
                    rprint(CURRENT_FLAG_HOLDER, "|c")
                    SayToAll(get_var(CURRENT_FLAG_HOLDER, "$name") .. " has the flag!", PlayerIndex)
                    -- Prevent them from dropping the flag
                    for i = 1, 16 do
                        if get_player(i) then
                            write_word(player_object + 0x88, PlayerIndex)
                        end
                    end
                end
            end
        end
    end
end

function OnWeaponDrop(PlayerIndex)
    if player_alive(PlayerIndex) then
        DROPPED = true
        CURRENT_FLAG_HOLDER = nil
    end
end

-- Monitor flag holders location.
function MonitorLocation(PlayerIndex)
    if (CURRENT_FLAG_HOLDER ~= nil) then
        if player_alive(CURRENT_FLAG_HOLDER) then
            if not (DROPPED) then
                execute_command("s " .. CURRENT_FLAG_HOLDER .. " :" .. FLAG_SPEED)
                execute_command("camo " .. CURRENT_FLAG_HOLDER .. " " .. CAMO_TIME)
                if inSphere(PlayerIndex, FLAG[MAP_NAME][1][1], FLAG[MAP_NAME][1][2], FLAG[MAP_NAME][1][3], Check_Radius) == true or inSphere(PlayerIndex, FLAG[MAP_NAME][2][1], FLAG[MAP_NAME][2][2], FLAG[MAP_NAME][2][3], Check_Radius) == true then
                    ctf_score(CURRENT_FLAG_HOLDER)
                    ResetSpeed(PlayerIndex)
                    execute_command("msg_prefix \"\"")
                    say_all(get_var(PlayerIndex, "$name") .. " scored a flag!")
                    execute_command("msg_prefix \"** SERVER ** \"")
                    CURRENT_FLAG_HOLDER = nil
                end
                -- Monitor flag holders location. (loop until flag is captured, flag is dropped, or flag holder dies)
                timer(Check_Time, "MonitorLocation", PlayerIndex)
            end
        else -- Reset --
            CURRENT_FLAG_HOLDER = nil
        end
    else -- Reset --
        CURRENT_FLAG_HOLDER = nil
        ResetSpeed(PlayerIndex)
    end
end

function ResetSpeed(PlayerIndex)
    if (player_alive(PlayerIndex)) then
        execute_command("s " .. PlayerIndex .. " 1")
    else 
        return false
    end
end

function SayToAll(Message, PlayerIndex)
    for i = 1, 16 do
        if player_present(i) then
            if i ~= PlayerIndex then
                rprint(i, "|c" .. Message)
                rprint(i, "|c")
                rprint(i, "|c")
                rprint(i, "|c")
                rprint(i, "|c")
            end
        end
    end
end

function OnWin(Message, PlayerIndex)
    for i = 1, 16 do
        if player_present(i) then
            if i ~= PlayerIndex then
                rprint(i, "|c" .. Message)
            end
        end
    end
end

function inSphere(PlayerIndex, x, y, z, radius)
    if PlayerIndex then
        local player_static = get_player(PlayerIndex)
        local obj_x = read_float(player_static + 0xF8)
        local obj_y = read_float(player_static + 0xFC)
        local obj_z = read_float(player_static + 0x100)
        local x_diff = x - obj_x
        local y_diff = y - obj_y
        local z_diff = z - obj_z
        local dist_from_center = math.sqrt(x_diff ^ 2 + y_diff ^ 2 + z_diff ^ 2)
        if dist_from_center <= radius then
            return true
        end
    end
    return false
end

function moveobject(ObjectID, x, y, z)
    local object = get_object_memory(ObjectID)
    if get_object_memory(ObjectID) ~= 0 then
        local veh_obj = get_object_memory(read_dword(object + 0x11C))
        write_vector3d((veh_obj ~= 0 and veh_obj or object) + 0x5C, x, y, z)
    end
end

function ctf_score(Player)
    PlayerIndex = Player
    CURRENT_FLAG_HOLDER = nil
    cycle_level(Player, true, true)
    SPAWN_FLAG()
    timer(300, "delay_move", PlayerIndex)
end

-- Player is ranking up to a Vehicle Level. If they score on a map where the flag is located 'inside' a building, 
-- move them outside the building upon leveling up. Otherwise they might get stuck inside the walls of the building.
function delay_move(PlayerIndex)
    if PlayerInVehicle(PlayerIndex) then
        local player_object = get_dynamic_player(PlayerIndex)
        local VehicleObj = get_object_memory(read_dword(player_object + 0x11c))
        local seat = read_word(player_object + 0x2F0)
        if (VehicleObj ~= 0) and (seat == 0) or (seat == 1) or (seat == 2) or (seat == 3) or (seat == 4) or (seat == 5) then
            local vehicleId = read_dword(player_object + 0x11C)
            player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
            player_obj_id = vehicleId
            local added_height = 0.3
            -- [!] -- Red Base, Blue Base
            -- inSphere Red, else inSphere Blue base. 
            if (MAP_NAME == "bloodgulch") then
                if inSphere(PlayerIndex, 95.687797546387, - 159.44900512695, - 0.10000000149012, 3) == true then
                    moveobject(vehicleId, 95.01, -150.62, 0.07 + added_height)
                else
                    moveobject(vehicleId, 35.87, -70.73, 0.02 + added_height)
                end
            elseif (MAP_NAME == "deathisland") then
                if inSphere(PlayerIndex, - 26.576030731201, - 6.9761986732483, 9.6631727218628, 3) == true then
                    moveobject(vehicleId, -30.59, -1.81, 9.43 + added_height)
                else
                    moveobject(vehicleId, 33.06, 11.04, 8.05 + added_height)
                end
            elseif (MAP_NAME == "icefields") then
                if inSphere(PlayerIndex, 24.85000038147, - 22.110000610352, 2.1110000610352, 3) == true then
                    moveobject(vehicleId, 33.98, -25.61, 0.84 + added_height)
                else
                    moveobject(vehicleId, -86.37, 83.64, 0.87 + added_height)
                end
            elseif (MAP_NAME == "infinity") then
                if inSphere(PlayerIndex, 0.67973816394806, - 164.56719970703, 15.039022445679, 3) == true then
                    moveobject(vehicleId, 6.54, -160, 13.76 + added_height)
                else
                    moveobject(vehicleId, -6.23, 41.98, 10.48 + added_height)
                end
                
            elseif (MAP_NAME == "sidewinder") then
                -- RED BASE
                if inSphere(PlayerIndex, -32.038, -42.067, -3.831, 3) == true then
                    moveobject(vehicleId, -32.73, -25.67, -3.81 + added_height)
                -- BLUE BASE
                elseif inSphere(PlayerIndex, 30.351, -46.108, -3.831, 3) == true then
                    moveobject(vehicleId, 30.37, -29.36, -3.59 + added_height)
                end
                
            elseif (MAP_NAME == "timberland") then
                if inSphere(PlayerIndex, 17.322099685669, - 52.365001678467, - 17.751399993896, 3) == true then
                    moveobject(vehicleId, 16.93, -43.98, -18.16 + added_height)
                else
                    moveobject(vehicleId, 3-15.02, 45.36, -18 + added_height)
                end
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    last_damage[PlayerIndex] = MetaID
    if MetaID == ghost_bolt then
        return true, Damage * 2
    end
    if MetaID == assault_melee or
        MetaID == ball_melee or
        MetaID == flag_melee or
        MetaID == flame_melee or
        MetaID == needle_melee or
        MetaID == pistol_melee or
        MetaID == ppistol_melee or
        MetaID == prifle_melee or
        MetaID == pcannon_melee or
        MetaID == rocket_melee or
        MetaID == shotgun_melee or
        MetaID == sniper_melee then
        return true, Damage * Melee_Multiplier
    end
end

function RemoveSpawnProtect(PlayerIndex)
    if (player_alive(PlayerIndex)) then
        -- Health. (0 to 1) (Normal = 1)
        write_float(PlayerIndex + 0xE0, 1)
        -- Overshield. (0 to 3) (Normal = 1) (Full overshield = 3)
        write_float(PlayerIndex + 0xE4, 1)
    end
    return 0
end

function delay_weapons(PlayerIndex)
    if (LargeMapConfiguration == true) then 
        WeaponHandler(PlayerIndex)
    elseif (LargeMapConfiguration == false) then
        WeaponHandlerAlternate(PlayerIndex)
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    local response = nil
    local Message = string.lower(Message)
    if (Message == "@info") then
        timer(0, "InfoHandler", PlayerIndex)
        response = false
        return false
    end
    if (Message == "@stats") then
        if tonumber(players[PlayerIndex][1]) >= 7 then
            rprint(PlayerIndex, "Level: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level) .. "  |  Kills Needed Advance: " .. tostring(Level[players[PlayerIndex][1]][4]))
            rprint(PlayerIndex, "Vehicle: " .. tostring(Level[players[PlayerIndex][1]][2]))
            rprint(PlayerIndex, "Your Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
        else
            local nades_tbl = Level[players[PlayerIndex][1]][5]
            rprint(PlayerIndex, "Level: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level) .. "  |  Kills Needed Advance: " .. tostring(Level[players[PlayerIndex][1]][4]))
            rprint(PlayerIndex, "Weapon: " .. tostring(Level[players[PlayerIndex][1]][2]))
            rprint(PlayerIndex, "Ammo Multiplier: " .. tostring(Level[players[PlayerIndex][1]][6]))
            rprint(PlayerIndex, "Frags: " ..tostring(nades_tbl[1]))
            rprint(PlayerIndex, "Plasmas: ".. tostring(nades_tbl[2]))
            rprint(PlayerIndex, "Your Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
        end
        response = false
    end
    return response
end

function OnServerCommand(PlayerIndex, Command)
    local response = nil
    local t = tokenizestring(Command)
    if t[1] ~= nil then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= ADMIN_LEVEL and (t[1] == string.lower("level")) then
            response = false
            if t[2] ~= nil then
                if t[2] == "up" then
                    -- update, advance 
                    cycle_level(PlayerIndex, true, true)
                elseif t[2] == "down" then
                    -- update
                    cycle_level(PlayerIndex, true)
                else
                    rprint(PlayerIndex, "Action not defined - up or down")
                end
            end
            elseif tonumber(get_var(PlayerIndex, "$lvl")) >= 0 and (t[1] == string.lower("enter")) then
                response = false
                if PlayerInVehicle(PlayerIndex) then
                    rprint(PlayerIndex, "You're already in a vehicle!")
                else
                    if t[2] ~= nil then
                        if t[2] == "me" then
                            local player_object = get_dynamic_player(PlayerIndex)
                            local x, y, z = read_vector3d(player_object + 0x5c)
                            local vehicleId = spawn_object(vehi_type_id, Level[players[PlayerIndex][1]][11], x, y, z + 0.5)
                            if (CURRENT_LEVEL <= 6) then 
                                rprint(PlayerIndex, "You're not allowed to enter a vehicle. You're only level: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level))
                                rprint(PlayerIndex, "You must be level 8 or higher!")
                            elseif (CURRENT_LEVEL == 8) then
                                -- Rocket Hog (Gunner & Drivers Seat)
                                enter_vehicle(vehicleId, PlayerIndex, 0)
                                enter_vehicle(vehicleId, PlayerIndex, 2)
                                enter_vehicle(vehicleId, PlayerIndex, 2)
                            else
                                -- All other vehicles.
                                enter_vehicle(vehicleId, PlayerIndex, 0)
                            end
                        else
                            rprint(PlayerIndex, "Invalid Command. Usage: /enter me")
                        end
                    else
                        rprint(PlayerIndex, "Invalid Command. Usage: /enter me")
                    end
                end
            end
        end
    return response
end

function cycle_level(PlayerIndex, update, advance)
    local current_Level = players[PlayerIndex][1]
    if advance == true then
        local cur = current_Level + 1
        if cur == (#Level + 1) then
            game_over = true
            -- ON WIN --
            OnWin("--<->--<->--<->--<->--<->--<->--<->--", PlayerIndex)
            OnWin(get_var(PlayerIndex, "$name") .. " WON THE GAME!", PlayerIndex)
            OnWin("--<->--<->--<->--<->--<->--<->--<->--", PlayerIndex)
            OnWin(" ", PlayerIndex)
            OnWin(" ", PlayerIndex)
            OnWin(" ", PlayerIndex)
            -------------------------------------------------------------------------
            rprint(PlayerIndex, "|c-<->-<->-<->-<->-<->-<->-<->")
            rprint(PlayerIndex, "|cYOU WIN!")
            rprint(PlayerIndex, "|c-<->-<->-<->-<->-<->-<->-<->")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            execute_command("map_next")
            execute_command("mapvote_begin")
        end
        if current_Level < #Level then
            players[PlayerIndex][1] = current_Level + 1
            local name = get_var(PlayerIndex, "$name")
            rprint(PlayerIndex, "|c****** LEVEL UP ******")
            rprint(PlayerIndex, "|cLevel: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level))
            rprint(PlayerIndex, "|cKills Needed Advance: " .. tostring(Level[players[PlayerIndex][1]][4]))
            rprint(PlayerIndex, "|cYour Weapon: " .. tostring(Level[players[PlayerIndex][1]][2]))
            rprint(PlayerIndex, "|cYour Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
        end
        if current_Level == (#Level + 1) then
            game_over = true
            -- ON WIN --
            OnWin("--<->--<->--<->--<->--<->--<->--<->--", PlayerIndex)
            OnWin(get_var(PlayerIndex, "$name") .. " WON THE GAME!", PlayerIndex)
            OnWin("--<->--<->--<->--<->--<->--<->--<->--", PlayerIndex)
            OnWin(" ", PlayerIndex)
            OnWin(" ", PlayerIndex)
            OnWin(" ", PlayerIndex)
            OnWin(" ", PlayerIndex)
            -------------------------------------------------------------------------
            rprint(PlayerIndex, "|c-<->-<->-<->-<->-<->-<->-<->")
            rprint(PlayerIndex, "|cYOU WIN!")
            rprint(PlayerIndex, "|c-<->-<->-<->-<->-<->-<->-<->")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            execute_command("map_next")
            execute_command("mapvote_begin")
        end
    else
        if current_Level > Starting_Level then
            local name = get_var(PlayerIndex, "$name")
            players[PlayerIndex][1] = current_Level - 1
            if (PlayerIndex == VICTIM_SUICIDE) then 
                rprint(PlayerIndex, "|c****** SUICIDE - LEVEL DOWN ******")
            elseif (PlayerIndex == MELEE_VICTIM) then 
                rprint(PlayerIndex, "|c****** MELEED - LEVEL DOWN ******")            
            else
                rprint(PlayerIndex, "|c****** LEVEL DOWN ******")
            end
            rprint(PlayerIndex, "|cLevel: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level))
            rprint(PlayerIndex, "|cKills Needed Advance: " .. tostring(Level[players[PlayerIndex][1]][4]))
            rprint(PlayerIndex, "|cYour Weapon: " .. tostring(Level[players[PlayerIndex][1]][2]))
            rprint(PlayerIndex, "|cYour Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
        end
    end
    if (update == true) and not game_over then
        setscore(PlayerIndex, players[PlayerIndex][1])
    end
    --  assign weapons or vehicle according to level --
    if not game_over then
        if (LargeMapConfiguration == true) then 
            WeaponHandler(PlayerIndex)
        elseif (LargeMapConfiguration == false) then
            WeaponHandlerAlternate(PlayerIndex)
        end
        -- Reset Kills --
        players[PlayerIndex][2] = 0
    end
end

-- Check if player is in a Vehicle. Returns boolean --
function PlayerInVehicle(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local VehicleID = read_dword(player_object + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

-- destroy old vehicle --
function DestroyVehicle(old_vehicle_id)
    if old_vehicle_id then
        destroy_object(old_vehicle_id)
    end
    return 0
end

function WeaponHandler(PlayerIndex)
    if (player_alive(PlayerIndex)) then
        local player_object = get_dynamic_player(PlayerIndex)
        -- If already in vehicle when they level up, destroy the old one
        vbool = false
        if PlayerInVehicle(PlayerIndex) then
            vbool = true
            if player_object ~= 0 then
                -- destroy old vehicle --
                vehicle_Id = read_dword(player_object + 0x11C)
                obj_id = get_object_memory(vehicle_Id)
                exit_vehicle(PlayerIndex)
                timer(0, "DestroyVehicle", vehicle_Id)
            end
        end        
        -- For Vehicle Exits
        APPROPRIATE_ID = Level[players[PlayerIndex][1]][11]
        
        if (Level[players[PlayerIndex][1]][12]) == 1 then
            -- remove weapon --
            local weaponId = read_dword(player_object + 0x118)
            if weaponId ~= 0 then
                for j = 0, 3 do
                    local m_weapon = read_dword(player_object + 0x2F8 + j * 4)
                    destroy_object(m_weapon)
                end
            end
            if vbool == true then
                if (tonumber(players[PlayerIndex][1]) == 8) then
                    -- Spawn in Rocket Hog as Gunner/Driver --
                    local x, y, z = read_vector3d(obj_id + 0x5c)
                    -- added_height (important for moving vehicle objects on scoring)
                    --  Can't be higher than 0.3 otherwise players get stuck in walls on large maps when flag capturing and leveling up to a Vehicle Level.
                    added_height = 0.3
                    local vehicleId = spawn_object(vehi_type_id, Level[players[PlayerIndex][1]][11], x, y, z + added_height)
                    enter_vehicle(vehicleId, PlayerIndex, 0)
                    -- Creating two instances here because the player doesn't always spawn in the gunners seat. This seems to do the trick.
                    enter_vehicle(vehicleId, PlayerIndex, 2)
                    enter_vehicle(vehicleId, PlayerIndex, 2)
                else
                    -- handle other vehicle spawns --
                    local x, y, z = read_vector3d(obj_id + 0x5c)
                    -- added_height (important for moving vehicle objects on scoring)
                    --  Can't be higher than 0.3 otherwise players get stuck in walls.
                    added_height = 0.3
                    local vehicleId = spawn_object(vehi_type_id, Level[players[PlayerIndex][1]][11], x, y, z + added_height)
                    enter_vehicle(vehicleId, PlayerIndex, 0)
                end
            else
                local x, y, z = read_vector3d(player_object + 0x5c)
                -- added_height (important for moving vehicle objects on scoring)
                --  Can't be higher than 0.3 otherwise players get stuck in walls.
                added_height = 0.3
                local vehicleId = spawn_object(vehi_type_id, Level[players[PlayerIndex][1]][11], x, y, z + added_height)
                enter_vehicle(vehicleId, PlayerIndex, 0)
            end
        else
        -- remove weapon --
        local weaponId = read_dword(player_object + 0x118)
        if weaponId ~= 0 then
            for j = 0, 3 do
                local m_weapon = read_dword(player_object + 0x2F8 + j * 4)
                destroy_object(m_weapon)
            end
        end
            -- assign weapon --
            local x, y, z = read_vector3d(player_object + 0x5C)
            local weapid = assign_weapon(spawn_object(weap_type_id, Level[players[PlayerIndex][1]][11], x, y, z + 0.5), PlayerIndex)
            local wait_time = 1
            -- Sync Ammo --
            if tonumber(Level[players[PlayerIndex][1]][6]) then
                execute_command_sequence("w8 " .. wait_time .. "; ammo " .. PlayerIndex .. " " .. Level[players[PlayerIndex][1]][6])
                execute_command_sequence("w8 " .. wait_time .. "; mag " .. PlayerIndex .. " " .. Level[players[PlayerIndex][1]][6])
            end
            -- write nades --
            local nades_tbl = Level[players[PlayerIndex][1]][5]
            if nades_tbl then
                safe_write(true)
                local PLAYER = get_dynamic_player(PlayerIndex)
                -- Frags
                write_word(PLAYER + 0x31E, tonumber(nades_tbl[1]))
                -- Plasmas
                write_word(PLAYER + 0x31F, tonumber(nades_tbl[2]))
                safe_write(false)
            end
        end
    end
end

function WeaponHandlerAlternate(PlayerIndex)
    if (player_alive(PlayerIndex)) then
        local player_object = get_dynamic_player(PlayerIndex)      
        -- remove weapon --
        local weaponId = read_dword(player_object + 0x118)
        if weaponId ~= 0 then
            for j = 0, 3 do
                local m_weapon = read_dword(player_object + 0x2F8 + j * 4)
                destroy_object(m_weapon)
            end
        end
        -- assign weapon --
        local x, y, z = read_vector3d(player_object + 0x5C)
        local weapid = assign_weapon(spawn_object(weap_type_id, Level[players[PlayerIndex][1]][7], x, y, z + 0.5), PlayerIndex)
        local wait_time = 1
        -- Sync Ammo --
        if tonumber(Level[players[PlayerIndex][1]][6]) then
            execute_command_sequence("w8 " .. wait_time .. "; ammo " .. PlayerIndex .. " " .. Level[players[PlayerIndex][1]][6])
            execute_command_sequence("w8 " .. wait_time .. "; mag " .. PlayerIndex .. " " .. Level[players[PlayerIndex][1]][6])
        end
        -- write nades --
        local nades_tbl = Level[players[PlayerIndex][1]][5]
        if nades_tbl then
            safe_write(true)
            local PLAYER = get_dynamic_player(PlayerIndex)
            -- Frags
            write_word(PLAYER + 0x31E, tonumber(nades_tbl[1]))
            -- Plasmas
            write_word(PLAYER + 0x31F, tonumber(nades_tbl[2]))
            safe_write(false)
        end
    end
end

function getplayer(PlayerIndex)
    if tonumber(PlayerIndex) then
        if tonumber(PlayerIndex) ~= 0 then
            local m_player = get_player(PlayerIndex)
            if m_player ~= 0 then return m_player end
        end
    end
    return nil
end

function setscore(PlayerIndex, score)
    if tonumber(score) then
        if get_var(0, "$gt") == "ctf" then
            local m_player = getplayer(PlayerIndex)
            if score >= 0x7FFF then
                write_word(m_player + 0xC8, 0x7FFF)
            elseif score <= -0x7FFF then
                write_word(m_player + 0xC8, -0x7FFF)
            else
                write_word(m_player + 0xC8, score)
            end
        elseif get_var(0, "$gt") == "slayer" then
            if score >= 0x7FFF then
                execute_command("score " .. PlayerIndex .. " +1")
            elseif score <= -0x7FFF then
                execute_command("score " .. PlayerIndex .. " -1")
            else
                execute_command("score " .. PlayerIndex .. " " .. score)
            end
        end
    end
end

function CheckType()
    type_is_koth = get_var(1, "$gt") == "koth"
    type_is_oddball = get_var(1, "$gt") == "oddball"
    type_is_race = get_var(1, "$gt") == "race"
    if (type_is_koth) or (type_is_oddball) or (type_is_race) then
        cprint("Warning: This script doesn't support ODDBALL, KOTH or RACE", 4 + 8)
        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb["EVENT_JOIN"])
        unregister_callback(cb["EVENT_DIE"])
        unregister_callback(cb['EVENT_CHAT'])
        unregister_callback(cb["EVENT_GAME_END"])
        unregister_callback(cb['EVENT_SPAWN'])
        unregister_callback(cb["EVENT_LEAVE"])
        unregister_callback(cb["EVENT_GAME_START"])
        unregister_callback(cb['EVENT_COMMAND'])
        unregister_callback(cb['EVENT_PRESPAWN'])
        unregister_callback(cb["EVENT_DAMAGE_APPLICATION"])
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { }; i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function WeaponsAndEquipment(victim, xAxis, yAxis, zAxis)
    math.randomseed(os.time())
    local e = EQUIPMENT_TABLE[math.random(1, #EQUIPMENT_TABLE - 1)]
    local w = WEAPON_TABLE[math.random(1, #WEAPON_TABLE - 1)]
    local player = get_player(victim)
    local rotation = read_float(player + 0x138)
    local GetRandomNumber = math.random(1, 2)
    if (tonumber(GetRandomNumber) == 1) then
        spawn_object(tostring(eqip), e, xAxis, yAxis, zAxis + 0.5, rotation)
    elseif (tonumber(GetRandomNumber) == 2) then
        spawn_object(tostring(weap), w, xAxis, yAxis, zAxis + 0.5, rotation)
    end
end

function JustEquipment(victim, xAxis, yAxis, zAxis)
    math.randomseed(os.time())
    local e = EQUIPMENT_TABLE[math.random(0, #EQUIPMENT_TABLE - 1)]
    local player = get_player(victim)
    local rotation = read_float(player + 0x138)
    spawn_object(tostring(eqip), e, xAxis, yAxis, zAxis + 0.5, rotation)
end

function JustWeapons(victim, xAxis, yAxis, zAxis)
    math.randomseed(os.time())
    local w = WEAPON_TABLE[math.random(0, #WEAPON_TABLE - 1)]
    local player = get_player(victim)
    local rotation = read_float(player + 0x138)
    spawn_object(tostring(weap), w, xAxis, yAxis, zAxis + 0.5, rotation)
end

function get_tag_info(tagclass, tagname)
    -- Credits to 002 for this function. Return metaid
    local tagarray = read_dword(0x40440000)
    for i = 0, read_word(0x4044000C) -1 do
        local tag = tagarray + i * 0x20
        local class = string.reverse(string.sub(read_string(tag), 1, 4))
        if (class == tagclass) then
            if (read_string(read_dword(tag + 0x10)) == tagname) then
                return read_dword(tag + 0xC)
            end
        end
    end
    return nil
end

function LoadTableLarge()
    if get_var(0, "$gt") ~= "n/a" then

    end
end

function LoadItems()
    if get_var(0, "$gt") ~= "n/a" then
        assault_melee = get_tag_info("jpt!", "weapons\\assault rifle\\melee")
        ball_melee = get_tag_info("jpt!", "weapons\\ball\\melee")
        flag_melee = get_tag_info("jpt!", "weapons\\flag\\melee")
        flame_melee = get_tag_info("jpt!", "weapons\\flamethrower\\melee")
        needle_melee = get_tag_info("jpt!", "weapons\\needler\\melee")
        pistol_melee = get_tag_info("jpt!", "weapons\\pistol\\melee")
        ppistol_melee = get_tag_info("jpt!", "weapons\\plasma pistol\\melee")
        prifle_melee = get_tag_info("jpt!", "weapons\\plasma rifle\\melee")
        rocket_melee = get_tag_info("jpt!", "weapons\\rocket launcher\\melee")
        shotgun_melee = get_tag_info("jpt!", "weapons\\shotgun\\melee")
        sniper_melee = get_tag_info("jpt!", "weapons\\sniper rifle\\melee")
        pcannon_melee = get_tag_info("jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_melee")
        ghost_bolt = get_tag_info("jpt!", "vehicles\\ghost\\ghost bolt")
    end
end
        
function OnError(Message)
    print(debug.traceback())
end

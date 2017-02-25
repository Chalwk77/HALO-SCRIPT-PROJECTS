api_version = "1.11.0.0"

Starting_Level = 1 -- Must match beginning of level[#]
Spawn_Invunrable_Time = nil -- Seconds - nil disabled
Speed_Powerup = 2 -- in seconds
Speed_Powerup_duration = 20 -- in seconds
Spawn_Where_Killed = false -- Spawn at the same location as player died
Melee_Multiplier = 4 -- Multiplier to meele damage. 1 = normal damage
Normal_Damage = 1 -- Normal weppon damage multiplier. 1 = normal damage
CTF_ENABLED = false
Check_Radius = 1 -- Radius determining if player is in scoring area
Check_Time = 500 -- Mili-seconds to check if player in scoring area
FLAG_SPEED = 2.0 -- Flag-Holder running speed
CAMO_TIME = 15 -- Flag-Holder invisibility time
ADMIN_LEVEL = 1 -- Default admin level required to use chat commandss

Level = { }
-- Level[ number ] = {"weapon given","Description", "Instructions", Number of Kills required to advance, Nades{frag,plasmas}, Ammo multiplier) Internal stuff - (mapID of tagname[10], vehicle bool[11])
Level[1] = { "weapons\\shotgun\\shotgun", "Shotgun", "Melee or Nades!", 1, { 6, 6 }, 0 }
Level[2] = { "weapons\\assault rifle\\assault rifle", "Assualt Rifle", "Aim and unload!", 2, { 2, 2 }, 120 }
Level[3] = { "weapons\\pistol\\pistol", "Pistol", "Aim for the head", 3, { 2, 1 }, 12 }
Level[4] = { "weapons\\sniper rifle\\sniper rifle", "Sniper Rifle", "Aim, Exhale and fire!", 4, { 3, 2 }, 4 }
Level[5] = { "weapons\\rocket launcher\\rocket launcher", "Rocket Launcher", "Blow people up!", 5, { 1, 1 }, 4 }
Level[6] = { "weapons\\plasma_cannon\\plasma_cannon", "Fuel Rod", "Bombard anything that moves!", 6, { 3, 1 }, 1 }
Level[7] = { "vehicles\\ghost\\ghost_mp", "Ghost", "Run people down!", 7, { 0, 0 }, 0 }
Level[8] = { "vehicles\\rwarthog\\rwarthog", "Rocket Hog", "Blow em' up!", 8, { 0, 0 }, 0 }
Level[9] = { "vehicles\\scorpion\\scorpion_mp", "Tank", "Blow people up!", 9, { 0, 0 }, 0 }
Level[10] = { "vehicles\\banshee\\banshee_mp", "Banshee", "Hurry up and win!", 10, { 0, 0 }, 0 }

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
PowerUpSettings = {
    ["WeaponsAndEquipment"] = false,
    ["JustEquipment"] = false,
    ["JustWeapons"] = false
}

-- Messages --
CTF_GLOBALS = nil
Exit = nil
FLAG = { }
players = { }
FLAGGERS = { }
last_damage = { }
DEATH_LOCATION = { }
for i = 1, 16 do DEATH_LOCATION[i] = { } end
Stored_Levels = { }
flagball_weap = { }
Equipment_Tags = { }
Current_FlagHolder = nil
vehi_type_id = "vehi"
weap_type_id = "weap"
FLAG["bloodgulch"] = { { 95.687797546387, - 159.44900512695, - 0.10000000149012 }, { 40.240600585938, - 79.123199462891, - 0.10000000149012 }, { 65.749893188477, - 120.40949249268, 0.11860413849354 } }
FLAG["beavercreek"] = { { 29.055599212646, 13.732000350952, - 0.10000000149012 }, { - 0.86037802696228, 13.764800071716, - 0.0099999997764826 }, { 14.01514339447, 14.238339424133, - 0.91193699836731 } }
FLAG["boardingaction"] = { { 1.723109960556, 0.4781160056591, 0.60000002384186 }, { 18.204000473022, - 0.53684097528458, 0.60000002384186 }, { 4.3749675750732, - 12.832932472229, 7.2201852798462 } }
FLAG["carousel"] = { { 5.6063799858093, - 13.548299789429, - 3.2000000476837 }, { - 5.7499198913574, 13.886699676514, - 3.2000000476837 }, { 0.033261407166719, 0.0034416019916534, - 0.85620224475861 } }
FLAG["chillout"] = { { 7.4876899719238, - 4.49059009552, 2.5 }, { - 7.5086002349854, 9.750340461731, 0.10000000149012 }, { 1.392117857933, 4.7001452445984, 3.108856678009 } }
FLAG["damnation"] = { { 9.6933002471924, - 13.340399742126, 6.8000001907349 }, { - 12.17884349823, 14.982703208923, - 0.20000000298023 }, { - 2.0021493434906, - 4.3015551567078, 3.3999974727631 } }
FLAG["dangercanyon"] = { { - 12.104507446289, - 3.4351840019226, - 2.2419033050537 }, { 12.007399559021, - 3.4513700008392, - 2.2418999671936 }, { - 0.47723594307899, 55.331966400146, 0.23940123617649 } }
FLAG["deathisland"] = { { - 26.576030731201, - 6.9761986732483, 9.6631727218628 }, { 29.843469619751, 15.971487045288, 8.2952880859375 }, { - 30.282138824463, 31.312761306763, 16.601940155029 } }
FLAG["gephyrophobia"] = { { 26.884338378906, - 144.71551513672, - 16.049139022827 }, { 26.727857589722, 0.16621616482735, - 16.048349380493 }, { 63.513668060303, - 74.088592529297, - 1.0624552965164 } }
FLAG["hangemhigh"] = { { 13.047902107239, 9.0331249237061, - 3.3619771003723 }, { 32.655700683594, - 16.497299194336, - 1.7000000476837 }, { 21.020147323608, - 4.6323413848877, - 4.2290902137756 } }
FLAG["icefields"] = { { 24.85000038147, - 22.110000610352, 2.1110000610352 }, { - 77.860000610352, 86.550003051758, 2.1110000610352 }, { - 26.032163619995, 32.365093231201, 9.0070295333862 } }
FLAG["infinity"] = { { 0.67973816394806, - 164.56719970703, 15.039022445679 }, { - 1.8581243753433, 47.779975891113, 11.791272163391 }, { 9.6316251754761, - 64.030670166016, 7.7762198448181 } }
FLAG["longest"] = { { - 12.791899681091, - 21.6422996521, - 0.40000000596046 }, { 11.034700393677, - 7.5875601768494, - 0.40000000596046 }, { - 0.80207985639572, - 14.566205024719, 0.16665624082088 } }
FLAG["prisoner"] = { { - 9.3684597015381, - 4.9481601715088, 5.6999998092651 }, { 9.3676500320435, 5.1193399429321, 5.6999998092651 }, { 0.90271377563477, 0.088873945176601, 1.392499089241 } }
FLAG["putput"] = { { - 18.89049911499, - 20.186100006104, 1.1000000238419 }, { 34.865299224854, - 28.194700241089, 0.10000000149012 }, { - 2.3500289916992, - 21.121452331543, 0.90232092142105 } }
FLAG["ratrace"] = { { - 4.2277698516846, - 0.85564690828323, - 0.40000000596046 }, { 18.613000869751, - 22.652599334717, - 3.4000000953674 }, { 8.6629104614258, - 11.159770965576, 0.2217468470335 } }
FLAG["sidewinder"] = { { - 32.038200378418, - 42.066699981689, - 3.7000000476837 }, { 30.351499557495, - 46.108001708984, - 3.7000000476837 }, { 2.0510597229004, 55.220195770264, - 2.8019363880157 } }
FLAG["timberland"] = { { 17.322099685669, - 52.365001678467, - 17.751399993896 }, { - 16.329900741577, 52.360000610352, - 17.741399765015 }, { 1.2504668235779, - 1.4873152971268, - 21.264007568359 } }
FLAG["wizard"] = { { - 9.2459697723389, 9.3335800170898, - 2.5999999046326 }, { 9.1828498840332, - 9.1805400848389, - 2.5999999046326 }, { - 5.035900592804, - 5.0643291473389, - 2.7504394054413 } }

function OnScriptLoad()
    --register_callback(cb['EVENT_TICK'],"OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
	register_callback(cb["EVENT_GAME_END"], "OnGameEnd")	
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerLeave")
    register_callback(cb["EVENT_GAME_START"], "OnNewGame")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPrespawn")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")
    local ctf_globals_pointer = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if (ctf_globals_pointer == 3) then return end
    CTF_GLOBALS = read_dword(ctf_globals_pointer)
    LoadItems()
    if (halo_type == "PC") then
        gametype_base = 0x671340
        slayer_globals = 0x63A0E8
    else
        gametype_base = 0x5F5498
        slayer_globals = 0x5BE108
    end
    -- set score limit --
    write_byte(gametype_base, 0x58, 256)
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
    for i=1,16 do
        if player_present(i) then
            last_damage[i] = 0
        end
    end
end

function OnScriptUnload()
    FLAG = { }
    Level = { }
    players = { }
    FLAGGERS = { }
    last_damage = { }
    WEAPON_TABLE = { } 
    Stored_Levels = { }
    flagball_weap = { }
    DEATH_LOCATION = { }
    Equipment_Tags = { }
    EQUIPMENT_TABLE = { }
end

function WelcomeHandler(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "Welcome to Level Up!")
    say(PlayerIndex, "Type @info if you don't know How to Play")
    say(PlayerIndex, "Type @stats for your current stats.")
    execute_command("msg_prefix \"** SERVER ** \"")
end

function InfoHandler(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "Kill players to gain a Level.")
    say(PlayerIndex, "Being meeled will result in moving down a Level.")
    say(PlayerIndex, "There is a Flag somewhere on the map. Return it to a base to gain a Level!")
    execute_command("msg_prefix \"** SERVER ** \"")
end

function OnNewGame()
    LoadItems()
    map_name = get_var(1, "$map")
    for k, v in pairs(Level) do
        if string.find(v[1], "vehicles") then
            v[11] = v[1]
            v[12] = 1
        else
            v[11] = v[1]
            v[12] = 0
        end
    end
    if CTF_ENABLED == true then SPAWN_FLAG() end	
	for i = 1 , 16 do
		if player_present(i) then	
			last_damage[i] = 0
		end
	end		
end

function OnGameEnd() 
    FLAG = { }
    Level = { }
    players = { }
    FLAGGERS = { }
    WEAPON_TABLE = { } 
    Stored_Levels = { }
    flagball_weap = { }
    DEATH_LOCATION = { }
    Equipment_Tags = { }
    EQUIPMENT_TABLE = { }
	for i=1,16 do
		if player_present(i) then		
			last_damage[i] = 0
		end
	end	
end

function SPAWN_FLAG()
    local t = FLAG[map_name][3]
    -- Spawn flag at x,y,z
    flag_objId = spawn_object("weap", "weapons\\flag\\flag", t[1], t[2], t[3])
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    -- PVP --
    if (killer > 0) and (victim ~= killer) and get_var(victim, "$team") ~= get_var(killer, "$team") then
        add_kill(killer)
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
            cycle_level(victim, true) -- update, level down
        end
        if Spawn_Where_Killed == true then
            local player_object = get_dynamic_player(victim)
            local xAxis, yAxis, zAxis = read_vector3d(player_object + 0x5C)
            DEATH_LOCATION[victim][1] = xAxis
            DEATH_LOCATION[victim][2] = yAxis
            DEATH_LOCATION[victim][3] = zAxis
            if (PowerUpSettings["WeaponsAndEquipment"] == true) then
                WeaponsAndEquipment(xAxis, yAxis, zAxis)
            elseif(PowerUpSettings["JustEquipment"] == true) then
                JustEquipment(xAxis, yAxis, zAxis)
            elseif (PowerUpSettings["JustWeapons"] == true) then
                JustWeapons(xAxis, yAxis, zAxis)
            end
        end
        -- Suicide --
    elseif tonumber(PlayerIndex) == tonumber(KillerIndex) then
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
            elseif(PowerUpSettings["JustEquipment"] == true) then
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

function delay_score(id, count, PlayerIndex)
    if PlayerIndex then
        setscore(PlayerIndex, players[PlayerIndex][1])
    end
    return 0
end

function add_kill(killer)
    -- add on a kill
    local kills = players[killer][2]
    players[killer][2] = kills + 1
    -- check to see if player advances
    if players[killer][2] == Level[players[killer][1]][4] then
        cycle_level(killer, true, true)
    end
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
    timer(0, "WelcomeHandler", PlayerIndex)
    -- Update score to reflect changes.
    setscore(PlayerIndex, players[PlayerIndex][1]) -- First initial score is equal to Level 1 (score point 1)
end

function OnPlayerLeave(PlayerIndex)
    last_damage[PlayerIndex] = nil
    local saved_data = get_var(PlayerIndex, "$hash") .. ":" .. get_var(PlayerIndex, "$name")
    -- Create Table Key for Player --
	Stored_Levels[saved_data] = {players[PlayerIndex][1], players[PlayerIndex][2]}
    -- Wipe Saved Spawn Locations
    for i = 1, 3 do
        -- reset death location --
        DEATH_LOCATION[PlayerIndex][i] = nil
    end
end

function OnPlayerPrespawn(PlayerIndex)
    -- reset last damage --
	last_damage[PlayerIndex] = 0
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

function OnPlayerSpawn(PlayerIndex)	
    if getplayer(PlayerIndex) then
        --  assign weapons or vehicle according to level --
        WeaponHandler(PlayerIndex)
        if Spawn_Invunrable_Time ~= nil and Spawn_Invunrable_Time > 0 then
            --  Setup Invulnerable Timer --
            write_float(PlayerIndex + 0xE0, 99999999) -- Health. (0 to 1) (Normal = 1)
            write_float(PlayerIndex + 0xE4, 99999999) -- Overshield. (0 to 3) (Normal = 1) (Full overshield = 3)
            timer(Spawn_Invunrable_Time * 1000, "RemoveSpawnProtect", PlayerIndex)
        end
        rprint(PlayerIndex, "Your Current Level: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level) .. " | Kills Needed: " .. tostring(Level[players[PlayerIndex][1]][4]))
        rprint(PlayerIndex, "Your Weapon: " .. tostring(Level[players[PlayerIndex][1]][2]) .. " | Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
    end
end

function objectidtoplayer(ObjectID) -- returns PlayerIndex from an ObjectID
    local object = get_object_memory(ObjectID)
    if object ~= 0 then
    local playerId = read_word(object + 0xC0) -- Full DWORD ID of player.
    return to_player_index(playerId) ~= 0 and playerId or nil end
end

function takenavsaway()
	for i = 1,16 do
		if player_present(i) then
			local m_player = getplayer(i)
			local player = to_real_index(i)
			if m_player ~= 0 then
				write_word(m_player + 0x88, player) -- NAV Marker. Slayer Target Player
            end
        end
    end
end

function setnavesto(Player)
	for i = 1,16 do
		if player_present(i) then
			local m_player = get_player(i)
			local player = to_real_index(Player)
			if m_player ~= 0 then
				write_word(m_player + 0x88, player) -- NAV Marker. Slayer Target Player
            end
        end
    end
end

function check_loc(PlayerIndex)
    if PlayerIndex ~= nil then
        local PlayerIndex = objectidtoplayer(PlayerIndex)
        if Current_FlagHolder then
            if tonumber(PlayerIndex) == tonumber(Current_FlagHolder) and inSphere(PlayerIndex, FLAG[map_name][1][1], FLAG[map_name][1][2], FLAG[map_name][1][3], Check_Radius) == true or inSphere(PlayerIndex, FLAG[map_name][2][1], FLAG[map_name][2][2], FLAG[map_name][2][3], Check_Radius) == true then
                ctf_score(PlayerIndex)
            end
        end
    else
        return 0
    end
    return 1
end

function inSphere(PlayerIndex, x, y, z, radius)
    if PlayerIndex then
        local player_static = get_player(PlayerIndex)
        local obj_x = read_float(player_static + 0xF8)  -- Player X Coord
        local obj_y = read_float(player_static + 0xFC)  -- Player Y Coord
        local obj_z = read_float(player_static + 0x100) -- Player Z Coord
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

function ctf_score(PlayerIndex)
    Current_FlagHolder = nil
    cycle_level(PlayerIndex, true, true)
    SPAWN_FLAG()
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    last_damage[PlayerIndex] = MetaID
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
    else
        return true, Damage * Normal_Damage
	end
end

function RemoveSpawnProtect(PlayerIndex)
    write_float(PlayerIndex + 0xE0, 1) -- Health. (0 to 1) (Normal = 1)
    write_float(PlayerIndex + 0xE4, 1) -- Overshield. (0 to 3) (Normal = 1) (Full overshield = 3)
    return 0
end

function delay_weaps(PlayerIndex)
    --  assign weapons or vehicle according to level --
    WeaponHandler(PlayerIndex)
    return 0
end

function OnPlayerChat(PlayerIndex, Message, type)
    local Message = string.lower(Message)
    if (Message == "@info") then
        timer(0, "InfoHandler", PlayerIndex)
        return false
    end
    if (Message == "@stats") then
        rprint(PlayerIndex, "Current Level: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level) .. " | Kills Needed: " .. tostring(Level[players[PlayerIndex][1]][4]))
        rprint(PlayerIndex, "Your Weapon: " .. tostring(Level[players[PlayerIndex][1]][2]) .. " | Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
        return false
    end
end

function OnServerCommand(PlayerIndex, Command)
    local response = nil
    local t = tokenizestring(Command)
    if t[1] ~= nil then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= ADMIN_LEVEL and (t[1] == string.lower("level")) then
            response = false
            if t[2] ~= nil then
                if t[2] == "up" then
                    cycle_level(PlayerIndex, true, true) -- update, advance 
                elseif t[2] == "down" then
                    cycle_level(PlayerIndex, true) -- update
                else
                    rprint(PlayerIndex, "Action not defined - up or down")
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
            rprint(PlayerIndex, "|cYOU WIN!")
            rprint(PlayerIndex, "|c-----------------------")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            execute_command("map_next")
        end
        if current_Level < #Level then
            players[PlayerIndex][1] = current_Level + 1
            local name = get_var(PlayerIndex, "$name")
            rprint(PlayerIndex, "Your Current Level: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level) .. " | Kills Needed: " .. tostring(Level[players[PlayerIndex][1]][4]))
            rprint(PlayerIndex, "Your Weapon: " .. tostring(Level[players[PlayerIndex][1]][2]) .. " | Your Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
        end
        if current_Level == (#Level + 1) then
            rprint(PlayerIndex, "|cYOU WIN!")
            rprint(PlayerIndex, "|c-----------------------")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            rprint(PlayerIndex, "|c ")
            execute_command("map_next")
        end
        else
        if current_Level > Starting_Level then
            local name = get_var(PlayerIndex, "$name")
            players[PlayerIndex][1] = current_Level - 1
            rprint(PlayerIndex, "LEVEL DOWN!")
            rprint(PlayerIndex, "Your Current Level: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level) .. " | Kills Needed: " .. tostring(Level[players[PlayerIndex][1]][4]))
            rprint(PlayerIndex, "Your Weapon: " .. tostring(Level[players[PlayerIndex][1]][2]) .. " | Your Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
        end
    end
    if update == true then
        local name = get_var(PlayerIndex, "$name")
        setscore(PlayerIndex, players[PlayerIndex][1])
    end
    --  assign weapons or vehicle according to level --
    WeaponHandler(PlayerIndex)
    -- Reset Kills --
    players[PlayerIndex][2] = 0
end

function OnObjectInteraction(PlayerIndex, objId, mapId)
    for i = 0, #Equipment_Tags do
        if mapId == Equipment_Tags[i] then
            if mapId == doublespeed_id or mapId == full_spec_id then
                timer(500, "delaydestroyobject", objId)
                if mapId == doublespeed_id then
                    applyspeed(PlayerIndex)
                    else
                    
                end
                return 0
            end
            return 1
        end
    end
    if objId == flag_objId then
        Current_FlagHolder = PlayerIndex
        flagball_weap[PlayerIndex] = weapid
        for i = 1, 16 do
            if getplayer(i) then
                write_word(getplayer(PlayerIndex) + 0x88, Current_FlagHolder)
            end
        end
        rprint(Current_FlagHolder, "Return the Flag to a base to gain a Level!")
        if getplayer(PlayerIndex) == nil then return false end
        say("{" .. tostring(PlayerIndex) .. "}  has the Flag! Kill him!", false)
        return 1
    end
end

-- Check if player has the flag
function PlayerHasTheFlag(PlayerIndex)
    local dynamic_player = get_dynamic_player(PlayerIndex)
    local flag_red_objectid = read_dword(CTF_GLOBALS + 0x8)
    local flag_blue_objectid = read_dword(CTF_GLOBALS + 0xC)
    for k=0,3 do
        local oid = read_dword(dynamic_player + 0x2F8 + 4 * k)
        if(oid == flag_blue_objectid or oid == flag_red_objectid) then return true end
    end
    
    return false
end

function OnTick()
    if(get_var(1,"$gt") ~= "ctf") then return end
    for i = 1,16 do
        if player_alive(i) then
            if FLAGGERS[i] and PlayerHasTheFlag(i) == false then
                execute_command("s " .. i .. " 1")
                FLAGGERS[i] = nil
                Current_FlagHolder = nil
            elseif PlayerHasTheFlag(i) and FLAGGERS[i] == nil then
                -- Timer for Flag Captures
                --timer(Check_Time, "check_loc", i)
                FLAGGERS[i] = true
                execute_command("s " .. i .. " :" .. FLAG_SPEED)
                execute_command("camo " .. i .. " " .. CAMO_TIME)
                Current_FlagHolder = i
                rprint(i, "Return the Flag to your base to gain a Level!")
                SayToAll(get_var(i, "$name") .. " picked up the flag!", i)
            end
        end
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

-- Destroy old vehicle --
function DestroyVehicle(old_vehicle_id)
    if old_vehicle_id then
        destroy_object(old_vehicle_id)
    end
    return 0
end

function WeaponHandler(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    -- If already in vehicle when they level up, destroy the old one
    vbool = false
    if PlayerInVehicle(PlayerIndex) then
        vbool = true
        if player_object ~= 0 then
            -- remove old vehicle --
            vehicle_Id = read_dword(player_object + 0x11C)
            obj_id = get_object_memory(vehicle_Id)
            exit_vehicle(PlayerIndex)
            timer(0, "DestroyVehicle", vehicle_Id)
        end
    end
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
                local vehicleId = spawn_object(vehi_type_id, Level[players[PlayerIndex][1]][11], x, y, z + 1.5)
                enter_vehicle(vehicleId, PlayerIndex, 0)
                enter_vehicle(vehicleId, PlayerIndex, 2)
            else
                -- handle other vehicle spawns --
                local x, y, z = read_vector3d(obj_id + 0x5c)
                local vehicleId = spawn_object(vehi_type_id, Level[players[PlayerIndex][1]][11], x, y, z + 1.5)
                enter_vehicle(vehicleId, PlayerIndex, 0)
            end
        else
            local x, y, z = read_vector3d(player_object + 0x5c)
            local vehicleId = spawn_object(vehi_type_id, Level[players[PlayerIndex][1]][11], x, y, z + 1.5)
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
        if tonumber(Level[players[PlayerIndex][1]][6]) then
            execute_command_sequence("w8 "..wait_time.."; ammo " .. PlayerIndex .. " "..Level[players[PlayerIndex][1]][6])
            execute_command_sequence("w8 "..wait_time.."; mag " .. PlayerIndex .. " "..Level[players[PlayerIndex][1]][6])
        end
        -- write nades --
        local nades_tbl = Level[players[PlayerIndex][1]][5]
        if nades_tbl then
            safe_write(true)
            local PLAYER = get_dynamic_player(PlayerIndex)
            write_word(PLAYER + 0x31E, tonumber(nades_tbl[1])) -- Frags
            write_word(PLAYER + 0x31F, tonumber(nades_tbl[2])) -- Plasmas
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
            local m_player = getplayer(PlayerIndex)
            if score >= 0x7FFFFFFF then
                execute_command("score " .. PlayerIndex .. " +1")
            elseif score <= -0x7FFFFFFF then
                execute_command("score " .. PlayerIndex .. " -1")
            else
                execute_command("score " .. PlayerIndex .. " +1")
            end
        end
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

function SayToAll(Message, Player1, Player2)
	for i = 1 , 16 do
		if player_present(i) and (Message ~= nil) then
			if (Player1 ~= i) and (Player2 ~= i) then
                execute_command("msg_prefix \"\"")
				say(i, Message)
                execute_command("msg_prefix \"** SERVER ** \"")
				break
			end
		end	
	end
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

function get_tag_info(tagclass,tagname) -- Credits to 002 for this function. Return metaid
    local tagarray = read_dword(0x40440000)
    for i=0,read_word(0x4044000C)-1 do
        local tag = tagarray + i * 0x20
        local class = string.reverse(string.sub(read_string(tag),1,4))
        if (class == tagclass) then
            if (read_string(read_dword(tag + 0x10)) == tagname) then
                return read_dword(tag + 0xC)
            end
        end
    end
    return nil
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
	end	
end

function OnError(Message)
    print(debug.traceback())
end

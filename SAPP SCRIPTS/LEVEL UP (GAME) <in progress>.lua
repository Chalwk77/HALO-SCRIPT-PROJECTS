api_version = "1.11.0.0"

Starting_Level = 1
Spawn_Invunrable_Time = nil
Speed_Powerup = 2
HandleNades = true
Speed_Powerup_duration = 20
Spawn_Where_Killed = false
Melee_Multiplier = 4
CTF_ENABLED = true
Check_Radius = 1
Check_Time = 500
FLAG_SPEED = 2.0
CAMO_TIME = 15

Level = { }
-- 1 Level[1-9]
-- 2 Weapon Given = "weapons\\shotgun\\shotgun"
-- 3 Description = "shotgun"
-- 4 Instructions = "Aim and unload!"
-- 5 Number of kills required to advance
-- 6 nades {<amount>,<amount>}
-- 7 Ammo multiplier
-- 8 mapID of tagname[10]
-- 9 vehicle bool[11]

-- Level[ number ] = {"weapon given","Description", "Instructions", Number of Kills required to advance, Nades{plasma,frag}, Ammo multiplier) Internal stuff - (mapID of tagname[10], vehicle bool[11])
Level[1] = { "weapons\\shotgun\\shotgun", "Shotgun", "Nades", 1, { 0, 0 }, 0 }
Level[2] = { "weapons\\shotgun\\shotgun", "Shotgun", "Aim and unload!", 2, { 3, 3 }, 4 }
Level[3] = { "weapons\\pistol\\pistol", "Pistol", "Aim for the head", 3, { 2, 0 }, 4 }
Level[4] = { "weapons\\sniper rifle\\sniper rifle", "Sniper Rifle", "Aim, Exhale and fire!", 4, { 2, 0 }, 4 }
Level[5] = { "weapons\\rocket launcher\\rocket launcher", "Rocket Launcher", "Blow people up!", 5, { 2, 0 }, 4 }
Level[6] = { "weapons\\plasma_cannon\\plasma_cannon", "Fuel Rod", "Bombard anything that moves!", 6, { 2, 0 }, 1 }
Level[7] = { "vehicles\\ghost\\ghost_mp", "Ghost", "Run people down!", 7, { 0, 0 }, 0 }
Level[8] = { "vehicles\\scorpion\\scorpion_mp", "Tank", "Blow people up!", 8, { 0, 0 }, 0 }
Level[9] = { "vehicles\\banshee\\banshee_mp", "Banshee", "Hurry up and win!", 9, { 0, 0 }, 0 }

-- Objects to drop when someone dies
EQUIPMENT = { }
EQUIPMENT[1] = { "powerups\\active camouflage" }
EQUIPMENT[2] = { "powerups\\health pack" }
EQUIPMENT[3] = { "powerups\\over shield" }
EQUIPMENT[4] = { "powerups\\assault rifle ammo\\assault rifle ammo" }
EQUIPMENT[5] = { "powerups\\needler ammo\\needler ammo" }
EQUIPMENT[6] = { "powerups\\pistol ammo\\pistol ammo" }
EQUIPMENT[7] = { "powerups\\rocket launcher ammo\\rocket launcher ammo" }
EQUIPMENT[8] = { "powerups\\shotgun ammo\\shotgun ammo" }
EQUIPMENT[9] = { "powerups\\sniper rifle ammo\\sniper rifle ammo" }
EQUIPMENT[10] = { "powerups\\flamethrower ammo\\flamethrower ammo" }
EQUIPMENT[11] = { "powerups\\double speed" }
-- EQUIPMENT[12] = {"powerups\\full-spectrum vision"}

-- Messages --
WELCOME_MESSAGE = "Welcome to Level Up!\n Type @info if you don't know How to Play\nType @stats for your current stats."
INFO_MESSAGE = "Kill players to gain a Level.\nBeing meeled will result in moving down a Level.\nThere is a Flag somewhere on the map. Return it to a base to gain a Level!"
FLAGGERS = {}
CTF_GLOBALS = nil
players = { }
Death_Loc = { }
for i = 1, 16 do Death_Loc[i] = { } end
Stored_Levels = { }
FlagBall_Weapon = { }
Equipment_Tags = { }
Current_FlagHolder = nil
FLAG = { }
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
    register_callback(cb['EVENT_TICK'],"OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
	register_callback(cb["EVENT_GAME_END"], "OnGameEnd")	
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerLeave")
    register_callback(cb["EVENT_GAME_START"], "OnNewGame")
	register_callback(cb["EVENT_PRESPAWN"], "OnPlayerPreSpawn")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")
    local ctf_globals_pointer = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if (ctf_globals_pointer == 3) then return end
    CTF_GLOBALS = read_dword(ctf_globals_pointer)
	WELCOME_MESSAGE = string.format(WELCOME_MESSAGE)
    --write_byte(0x671340, 0x58, 254)
end

function get_tag_info(obj_type, obj_name)
	local tag_id = lookup_tag(obj_type, obj_name)
	return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end	

function OnScriptUnload()
    weapons = { }
end

function OnNewGame()
    for k, v in pairs(Level) do
        if string.find(v[1], "vehicles") then
            local tag_id = get_tag_info("vehi", v[1])
            v[10] = tag_id
            v[11] = 1
        else
            local tag_id = get_tag_info("weap", v[1])
            v[10] = tag_id
            v[11] = 0
        end
    end
    
    -- Objects to drop (Spawn where Killed)
    for k, v in pairs(EQUIPMENT) do
        local tag_id = get_tag_info("eqip", v[1])
        table.insert(Equipment_Tags, tag_id)
    end
    doublespeed_id = get_tag_info("eqip", "powerups\\double speed")
    full_spec_id = get_tag_info("eqip", "powerups\\full-spectrum vision")
    map_name = get_var(1, "$map")
    if CTF_ENABLED == true then
        SPAWN_FLAG()
    end
end

function OnGameEnd() end

function SPAWN_FLAG()
    local t = FLAG[map_name][3]
    flag_objId = spawn_object("weap", "weapons\\flag\\flag", 0, 11, t[1], t[2], t[3])
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local victim = tonumber(VictimIndex)
    local killer = tonumber(KillerIndex)
    local player_object = get_dynamic_player(victim)
    -- Killed by another PlayerIndex
    if (killer > 0) then
        ADD_KILL(killer)
        if Spawn_Where_Killed == true then
            local x, y, z = read_vector3d(player_object + 0x5C)
            Death_Loc[victim][1] = x
            Death_Loc[victim][2] = y
            Death_Loc[victim][3] = z
            DropPowerup(x, y, z)
        end
    -- Betray
    elseif tonumber(KillerIndex) ~= PlayerIndex and get_var(KillerIndex,"$team") == get_var(PlayerIndex,"$team") then
        ADD_KILL(KillerIndex)
        if Spawn_Where_Killed == true then
            local x, y, z = read_vector3d(player_object + 0x5C)
            Death_Loc[victim][1] = x
            Death_Loc[victim][2] = y
            Death_Loc[victim][3] = z
            DropPowerup(x, y, z)
        end
    -- Suicide
    elseif PlayerIndex == killer then
        cycle_Level(VictimIndex) -- Move down a level on suicide
        if Spawn_Where_Killed == true then
            local x, y, z = read_vector3d(player_object + 0x5C)
            Death_Loc[victim][1] = x
            Death_Loc[victim][2] = y
            Death_Loc[victim][3] = z
        end
        --timer(500, "DelayScore", victim)
        --timer(500, "DelayScore", killer)
    end
end

function ADD_KILL(killer)
    local kills = players[killer][2]
    players[killer][2] = kills + 1
    -- 		Check if PlayerIndex advances
    if players[killer][2] == Level[players[killer][1]][4] then
        cycle_Level(killer, false, true) -- Move up a level on kill
    end
end

function DropPowerup(x, y, z)
    local num = getrandomnumber(1, #Equipment_Tags)
    createobject(Equipment_Tags[num], 0, 10, false, x, y, z + 0.5)
end

function DelayScore(PlayerIndex)
    if PlayerIndex then
        setscore(PlayerIndex, players[player][1])
    end
end

function OnPlayerJoin(PlayerIndex)
    -- 		Set Level
    players[PlayerIndex] = { Starting_Level, 0 }

    local saved_data = get_var(PlayerIndex, "$hash") .. ":" .. get_var(PlayerIndex, "$name")
    -- 			Check for Previous Statistics
    for k, v in pairs(Stored_Levels) do
        if tostring(k) == tostring(saved_data) then
				players[PlayerIndex][1] = Stored_Levels[saved_data][1]
				players[PlayerIndex][2] = Stored_Levels[saved_data][2]
            break
        end
    end
    -- 		Update score to reflect changes.
    setscore(PlayerIndex, players[PlayerIndex][1])
    say(PlayerIndex, WELCOME_MESSAGE)
    cycle_Level(PlayerIndex, false, false)
    if tonumber(players[PlayerIndex][1]) == 1 then
        level = 1
    elseif tonumber(players[PlayerIndex][1]) == 2 then
        level = 2
    elseif tonumber(players[PlayerIndex][1]) == 3 then
        level = 3
    elseif tonumber(players[PlayerIndex][1]) == 4 then
        level = 4
    elseif tonumber(players[PlayerIndex][1]) == 5 then
        level = 5
    elseif tonumber(players[PlayerIndex][1]) == 6 then
        level = 6
    elseif tonumber(players[PlayerIndex][1]) == 7 then
        level = 7
    elseif tonumber(players[PlayerIndex][1]) == 8 then
        level = 8
    elseif tonumber(players[PlayerIndex][1]) == 9 then
        level = 9
    end
end

function OnPlayerLeave(PlayerIndex)
    local saved_data = get_var(PlayerIndex, "$hash") .. ":" .. get_var(PlayerIndex, "$name")
    -- 		Create Table Key for Player
	Stored_Levels[saved_data] = {players[PlayerIndex][1], players[PlayerIndex][2]}
    -- 		Wipe Saved Spawn Locations
    for i = 1, 3 do
        Death_Loc[PlayerIndex][i] = nil
    end
end

function OnPlayerPreSpawn(PlayerIndex)
end

function OnPlayerSpawn(PlayerIndex)
    if getplayer(PlayerIndex) then
        if Spawn_Where_Killed == true then
            if Death_Loc[PlayerIndex][1] ~= nil and Death_Loc[PlayerIndex][2] ~= nil then
                write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, Death_Loc[PlayerIndex][1], Death_Loc[PlayerIndex][2], Death_Loc[PlayerIndex][3])
                for i = 1, 3 do
                    Death_Loc[PlayerIndex][i] = nil
                end
            end
        end
        local m_player = getplayer(PlayerIndex)
        timer(0, "delay_weaps", PlayerIndex)
        if Spawn_Invunrable_Time ~= nil and Spawn_Invunrable_Time > 0 then
            --  Setup Invulnerable Timer
            write_float(PlayerIndex + 0xE0, 99999999)
            write_float(PlayerIndex + 0xE4, 99999999)
            timer(Spawn_Invunrable_Time * 1000, "RemoveSpawnProtect", m_object)
        end
        -- Timer for Flag Captures
        timer(Check_Time, "check_loc", PlayerIndex)
        rprint(PlayerIndex, "Your Current Level: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level) .. " | Kills Needed To Advance: " .. tostring(Level[players[PlayerIndex][1]][4]))
        rprint(PlayerIndex, "Your Weapon: " .. tostring(Level[players[PlayerIndex][1]][2]) .. " | Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
        if Current_FlagHolder ~= nil then
            -- 		Navigation Point
            write_word(PlayerIndex + 0x88, Current_FlagHolder)
        else
            -- 		Navigation Point	
            write_word(m_player + 0x88, PlayerIndex)
        end
    end
end

function objectidtoplayer(ObjectID) -- returns PlayerIndex from an ObjectID
    local object = get_object_memory(ObjectID)
    if object ~= 0 then
    local playerId = read_word(object + 0xC0)
    return to_player_index(playerId) ~= 0 and playerId or nil end
end

function check_loc(player)
    if player ~= nil then
        local PlayerIndex = objectidtoplayer(player)
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

-- function inSphere(m_objId, x, y, z, r)
    -- local ox, oy, oz = getobjectcoords(m_objId)
    -- local x_dist = x - ox
    -- local y_dist = y - oy
    -- local z_dist = z - oz
    -- local dist = math.sqrt(x_dist ^ 2 + y_dist ^ 2 + z_dist ^ 2)
    -- if dist <= r then
        -- return true
    -- end
-- end

function ctf_score(PlayerIndex)
    Current_FlagHolder = nil
    cycle_Level(PlayerIndex, true, true)
    SPAWN_FLAG()
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
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
    local causer = tonumber(CauserIndex)
    local receiver = tonumber(PlayerIndex)
    if MetaID == assault_melee or 
        MetaID == assault_melee or
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
        name = MetaID
        if name ~= Level[1][1] and name ~= Level[2][1] then
            cycle_Level(PlayerIndex)
            timer(500, "DelayScore", PlayerIndex)
        end
        return true, Damage * Melee_Multiplier
    end	
end

function RemoveSpawnProtect(id, count, m_object)
    write_float(m_object + 0xE0, 1)
    write_float(m_object + 0xE4, 1)
    return 0
end

function delay_weaps(PlayerIndex)
    WeaponHandler(PlayerIndex)
    return 0
end

function OnVehicleEntry(PlayerIndex, vehiId, seat, mapId, voluntary)
    return false
end

function OnServerChat(PlayerIndex, type, message)
    local t = tokenizestring(message, " ")
    local count = #t
    if t[1] == nil then
        return false
    end
    if t[1] == "!Level" and isadmin(PlayerIndex) == true then
        if t[2] == "up" then
            privatesay(PlayerIndex, "Next Level")
            cycle_Level(PlayerIndex, true, true) -- update, advance
            return false
        elseif t[2] == "down" then
            privatesay(PlayerIndex, "Previous Level")
            cycle_Level(PlayerIndex, true) -- update
            return false
        else
            privatesay(PlayerIndex, "Action not defined - up or down")
            return false
        end
        return false
    elseif t[1] == "@info" then
        privatesay(PlayerIndex, INFO_MESSAGE)
    elseif t[1] == "@stats" then
        rprint(PlayerIndex, "Your current Level: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level) .. " | Kills Needed To Advance: " .. tostring(Level[players[PlayerIndex][1]][4]))
        rprint(PlayerIndex, "Your Weapon: " .. tostring(Level[players[PlayerIndex][1]][2]) .. " | Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
    end
end

function cycle_Level(PlayerIndex, update, advance)
    if getplayer(PlayerIndex) then
        local current_Level = players[PlayerIndex][1]
        if advance == true then
            cprint("ADVANCE", 2+8)
            local cur = current_Level + 1
            if cur == (#Level + 1) then
                rprint(PlayerIndex, "|cYOU WIN!")
                execute_command("map_next")
            end
            if current_Level < #Level then
                players[PlayerIndex][1] = current_Level + 1
                rprint(PlayerIndex, "|cLEVEL UP!")
                rprint(PlayerIndex, "Your Current Level: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level) .. " | Kills Needed To Advance: " .. tostring(Level[players[PlayerIndex][1]][4]))
                rprint(PlayerIndex, "Your Weapon: " .. tostring(Level[players[PlayerIndex][1]][2]) .. " | Your Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
                if tonumber(players[PlayerIndex][1]) == 1 then
                    level = 1
                elseif tonumber(players[PlayerIndex][1]) == 2 then
                    level = 2
                elseif tonumber(players[PlayerIndex][1]) == 3 then
                    level = 3
                elseif tonumber(players[PlayerIndex][1]) == 4 then
                    level = 4
                elseif tonumber(players[PlayerIndex][1]) == 5 then
                    level = 5
                elseif tonumber(players[PlayerIndex][1]) == 6 then
                    level = 6
                elseif tonumber(players[PlayerIndex][1]) == 7 then
                    level = 7
                elseif tonumber(players[PlayerIndex][1]) == 8 then
                    level = 8
                elseif tonumber(players[PlayerIndex][1]) == 9 then
                    level = 9
                end
            end
            if current_Level == (#Level + 1) then
                rprint(PlayerIndex, "|cYOU WIN!")
                execute_command("map_next")
            end
        else
            if current_Level > Starting_Level then
                players[PlayerIndex][1] = current_Level - 1
                rprint(PlayerIndex, "Level DOWN!")
                rprint(PlayerIndex, "Your Current Level: " .. tostring(players[PlayerIndex][1]) .. "/" .. tostring(#Level) .. " | Kills Needed To Advance: " .. tostring(Level[players[PlayerIndex][1]][4]))
                rprint(PlayerIndex, "Your Weapon: " .. tostring(Level[players[PlayerIndex][1]][2]) .. " | Your Instructions: " .. tostring(Level[players[PlayerIndex][1]][3]))
            end
        end
        if update == true then
            setscore(PlayerIndex, players[PlayerIndex][1])
        end
        WeaponHandler(PlayerIndex)
        players[PlayerIndex][2] = 0
    end
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
        FlagBall_Weapon[PlayerIndex] = weapid
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

function delaydestroyobject(id, count, objId)
    if objId then
        destroyobject(objId)
    end
    return 0
end

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
            if(get_var(i, "$team") == "blue") then
                team_name = "RED TEAM"
            else
                team_name = "BLUE TEAM"
            end
            if FLAGGERS[i] and PlayerHasTheFlag(i) == false then
                execute_command("s " .. i .. " 1")
                FLAGGERS[i] = nil
            elseif PlayerHasTheFlag(i) and FLAGGERS[i] == nil then
                FLAGGERS[i] = true
                execute_command("s " .. i .. " :" .. FLAG_SPEED)
                execute_command("camo " .. i .. " " .. CAMO_TIME)
                rprint(i, "|cReturn the Flag to a base to gain a Level!")
                SayToAllExcept(get_var(i, "$name") .. " picked up the " .. team_name .. "'s flag!", i)
            end
        end
    end
end

function SayToAllExcept(message, player1, player2)
	for i=1,16 do
		if player_present(i) and (message ~= nil) then
			if (player1 ~= i) and (player2 ~= i) then
                execute_command("msg_prefix \"\"")
				say(i, message)
                execute_command("msg_prefix \"** SERVER ** \"")
				break
			end
		end	
	end
end

function delay_destroyveh(id, count, vehicle_Id)
    if vehicle_Id then
        destroyobject(vehicle_Id)
    end
    return 0
end

function isinvehicle(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if player_object ~= 0 then
        local vehicleId = read_dword(player_object + 0x11C)
        if vehicleId == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

function WeaponHandler(PlayerIndex)
    local vbool = false
    if isinvehicle(PlayerIndex) then
        vbool = true
        vehicle_Id = getplayervehicleid(PlayerIndex)
        exitvehicle(PlayerIndex)
        timer(500, "delay_destroyveh", vehicle_Id)
    end
    -- if Level[players[PlayerIndex][1]][11] == 1 then
        -- local m_objectId = getplayerobjectid(PlayerIndex)
        -- if m_objectId then
            -- local m_object = getobject(m_objectId)
            -- if m_object then
                -- for j = 0, 3 do
                    -- local m_weaponId = read_dword(m_object + 0x2F8 + j * 4)
                    -- local m_weapon = getobject(m_weaponId)
                    -- if m_weapon then
                        -- destroyobject(m_weaponId)
                    -- end
                -- end
                -- FlagBall_Weapon[PlayerIndex] = nil
                -- if vbool == true then
                    -- local x, y, z = getobjectcoords(vehicle_Id)
                    -- local vechid = createobject(Level[players[PlayerIndex][1]][10], 0, 0, false, x, y, z + 0.5)
                    -- entervehicle(PlayerIndex, vechid, 0)
                -- else
                    -- local x, y, z = getobjectcoords(m_objectId)
                    -- local vechid = createobject(Level[players[PlayerIndex][1]][10], 0, 0, false, x, y, z + 0.5)
                    -- entervehicle(PlayerIndex, vechid, 0)
                -- end
            -- end
        -- end
    -- else
        --  remove current weapons | 'call' "AssignWeapons"
        execute_command("wdel " .. PlayerIndex)
        timer(1300, "AssignWeapons", PlayerIndex)
    --end
end

level_items = {}
level_items[1] = "weapons\\shotgun\\shotgun"
level_items[2] = "weapons\\shotgun\\shotgun"
level_items[3] = "weapons\\pistol\\pistol"
level_items[4] = "weapons\\sniper rifle\\sniper rifle"
level_items[5] = "weapons\\rocket launcher\\rocket launcher"
level_items[6] = "weapons\\plasma_cannon\\plasma_cannon"
level_items[7] = "vehicles\\ghost\\ghost_mp"
level_items[8] = "vehicles\\scorpion\\scorpion_mp"
level_items[9] = "vehicles\\banshee\\banshee_mp"

function AssignWeapons(PlayerIndex)
    -- 			Spawn New Weapons
    local player = get_dynamic_player(PlayerIndex)
    local x, y, z = read_vector3d(player + 0x5C)
    -- assign_weapon(spawn_object(Level[players[player][1]][10], x, y, z + 1, 0.0), player)
    if level == 1 then
        assign_weapon(spawn_object("weap", level_items[1], x, y, z + 1, 0.0), player)
    elseif level == 2 then 
        assign_weapon(spawn_object("weap", level_items[2], x, y, z + 1, 0.0), player)
    elseif level == 3 then 
        assign_weapon(spawn_object("weap", level_items[3], x, y, z + 1, 0.0), player)
    elseif level == 4 then 
        assign_weapon(spawn_object("weap", level_items[4], x, y, z + 1, 0.0), player)
    elseif level == 5 then 
        assign_weapon(spawn_object("weap", level_items[5], x, y, z + 1, 0.0), player)
    elseif level == 6 then 
        assign_weapon(spawn_object("weap", level_items[6], x, y, z + 1, 0.0), player)
    elseif level == 7 then 
        assign_weapon(spawn_object("vehi", level_items[7], x, y, z + 1, 0.0), player)
    elseif level == 8 then 
        assign_weapon(spawn_object("vehi", level_items[8], x, y, z + 1, 0.0), player)
    elseif level == 9 then 
        assign_weapon(spawn_object("vehi", level_items[9], x, y, z + 1, 0.0), player)
    end
    -- local m_weaponId = read_dword(player + 0x118)
    -- if m_weaponId then
        -- local unloaded_ammo = read_dword(m_weaponId + 0x2B6)
        -- local loaded_ammo = read_dword(m_weaponId + 0x2B8)
        -- if tonumber(unloaded_ammo) and tonumber(Level[players[PlayerIndex][1]][6]) then
            -- write_dword(m_weaponId + 0x2B6, tonumber(unloaded_ammo * Level[players[PlayerIndex][1]][6]))
            -- -- Sync Ammo?
        -- end
    -- end
    
    -- 		 Write Nades
    -- local nades_tbl = Level[players[player][1]][5]
    -- if nades_tbl then
        -- -- 		Frags	
        -- writebyte(m_object, 0x31E, nades_tbl[2])
        -- -- 	Nades		
        -- writebyte(m_object, 0x31F, nades_tbl[1])
    -- end
    
     -- Write Nades
    if HandleNades then
        --  frags
        write_word(player + 0x31E, frags)
        --  Plasmas
        write_word(player + 0x31F, Plasmas)
    end
end

function getplayervehicleid(PlayerIndex)
	local m_object = get_dynamic_player(PlayerIndex)
	if m_object ~= 0 then
		local m_vehicleId = read_dword(m_object + 0x11C)
		return m_vehicleId
	end
	return nil
end

-- function getplayervehicleid(PlayerIndex)
    -- local obj_id = getplayerobjectid(PlayerIndex)
    -- if obj_id then return read_dword(getobject(obj_id) + 0x11C) end
-- end

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
        end
    end
end

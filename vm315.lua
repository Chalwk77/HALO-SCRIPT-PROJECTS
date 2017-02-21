Starting_Level = 1
Spawn_Invunrable_Time = nil
Speed_Powerup = 2
Speed_Powerup_duration = 20
Spawn_Where_Killed = false
AFK_Time = 20
AFK_Warn_Time = 120
AFK_Kick_Time = 180
Melee_Multiplier = 1.5
CTF_ENABLED = true
Check_Radius = 1
Check_Time = 500
Message_Time = 10

Level = { }
-- Level[ number ] = {"weapon given","Description", "Instructions", Number of Kills required to advance, Nades{plasma,frag}, Ammo multiplier) Internal stuff - (mapID of tagname[10], vehicle bool[11])
Level[1] = { "weapons\\shotgun\\shotgun", "Shotgun", "Nades", 1, { 6, 6 }, 0 }
Level[2] = { "weapons\\shotgun\\shotgun", "Shotgun", "Aim and unload!", 2, { 2, 0 }, 4 }
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
AFK_WARN_MESSAGE = "**Warning**: You will be kicked in " .. AFK_Kick_Time - AFK_Warn_Time .. " seconds for being AFK!"
AFK_KICK_MESSAGE = " has been kicked for being AFK."
WELCOME_MESSAGE = "Welcome to %s\n Look at the bottum left corner for your stats!\nType @info if you don't know How to Play\nType @stats for your current stats."
INFO_MESSAGE = "Kill players to gain a Level.\nBeing meeled will result in moving down a Level.\nThere is a Flag somewhere on the map. Return it to a base to gain a Level!"
console = { }
console.__index = console
registertimer(100, "ConsoleTimer")
phasor_sendconsoletext = sendconsoletext
math.inf = 1 / 0
players = { }
Death_Loc = { }
for i = 0, 15 do Death_Loc[i] = { } end
Stored_Levels = { }
FlagBall_Weapon = { }
Equipment_Tags = { }
AFK = { }
Current_FlagHolder = nil
FLAG = { }
FLAG["beavercreek"] = { { 29.055599212646, 13.732000350952, - 0.10000000149012 }, { - 0.86037802696228, 13.764800071716, - 0.0099999997764826 }, { 14.01514339447, 14.238339424133, - 0.91193699836731 } }
FLAG["bloodgulch"] = { { 95.687797546387, - 159.44900512695, - 0.10000000149012 }, { 40.240600585938, - 79.123199462891, - 0.10000000149012 }, { 65.749893188477, - 120.40949249268, 0.11860413849354 } }
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

function GetRequiredVersion()
    return 200
end

function OnScriptLoad(processId, game, persistent)
    if game == true or game == "PC" then
        GAME = "PC"
    else
        GAME = "CE"
    end
    GetGameAddresses(GAME)
    if persistent == true then
        raiseerror("WARNING: This script doesn't support persistance!")
    end
    gametype = readbyte(gametype_base + 0x30)
    writebyte(gametype_base, 0x58, 254)
    WELCOME_MESSAGE = string.format(WELCOME_MESSAGE, getservername())
end

function OnNewGame(map)
    for k, v in pairs(Level) do
        if string.find(v[1], "vehicles") then
            local tag_id = gettagid("vehi", v[1])
            v[10] = tag_id
            v[11] = 1
        else
            local tag_id = gettagid("weap", v[1])
            v[10] = tag_id
            v[11] = 0
        end
    end
    for k, v in pairs(EQUIPMENT) do
        local tag_id = gettagid("eqip", v[1])
        table.insert(Equipment_Tags, tag_id)
    end
    doublespeed_id = gettagid("eqip", "powerups\\double speed")
    full_spec_id = gettagid("eqip", "powerups\\full-spectrum vision")
    flag_id = gettagid("weap", "weapons\\flag\\flag")
    map_name = tostring(map)
    if CTF_ENABLED == true then
        SPAWN_FLAG()
    end
end

function SPAWN_FLAG()
    local t = FLAG[map_name][3]
    flag_objId = createobject(flag_id, 0, 11, false, t[1], t[2], t[3])
end

function OnPlayerKill(killer, victim, mode)
    if mode == 4 then
        ADD_KILL(killer)
        if Spawn_Where_Killed == true then
            local x, y, z = getobjectcoords(getplayerobjectid(victim))
            Death_Loc[victim][1] = x
            Death_Loc[victim][2] = y
            Death_Loc[victim][3] = z
            DropPowerup(x, y, z)
        end
    elseif mode == 5 then
        ADD_KILL(killer)
        if Spawn_Where_Killed == true then
            local x, y, z = getobjectcoords(getplayerobjectid(victim))
            Death_Loc[victim][1] = x
            Death_Loc[victim][2] = y
            Death_Loc[victim][3] = z
            DropPowerup(x, y, z)
        end
    elseif mode == 6 then
        cycle_Level(victim)
        if Spawn_Where_Killed == true then
            local x, y, z = getobjectcoords(getplayerobjectid(victim))
            Death_Loc[victim][1] = x
            Death_Loc[victim][2] = y
            Death_Loc[victim][3] = z
        end
        registertimer(500, "DelayScore", victim)
        registertimer(500, "DelayScore", killer)
    end
end

function ADD_KILL(player)
    if getplayer(player) then
        -- 		Add-On-Kill
        local kills = players[player][2]
        players[player][2] = kills + 1
        -- 		Check if player advances
        if players[player][2] == Level[players[player][1]][4] then
            cycle_Level(player, false, true)
        end
    end
end

function DropPowerup(x, y, z)
    local num = getrandomnumber(1, #Equipment_Tags)
    createobject(Equipment_Tags[num], 0, 10, false, x, y, z + 0.5)
end

function DelayScore(id, count, player)
    if player then
        setscore(player, players[player][1])
    end
    return 0
end

function OnPlayerJoin(player)
    -- 		Set Level
    players[player] = { Starting_Level, 0 }

    local ip = getip(player) .. ":" .. getport(player)
    -- 			Check for Previous Statistics
    for k, v in pairs(Stored_Levels) do
        if tostring(k) == tostring(ip) then
            players[player][1] = Stored_Levels[ip][1]
            players[player][2] = Stored_Levels[ip][2]
            break
        end
    end
    -- 		Update score to reflect changes.
    setscore(player, players[player][1])
    privatesay(player, WELCOME_MESSAGE)
    -- 		AFK Related Code
    AFK[player] = { }
    AFK[player].orientation = { }
    AFK[player].response = true
    AFK[player].time = 0
    AFK[player].boolean = false
    AFK[player].timerid = registertimer(1000, "AFKTimer", player)
end

function OnPlayerLeave(player)
    local ip = getip(player) .. ":" .. getport(player)
    -- 		Create Table Key for Player
    Stored_Levels[ip] = { players[player][1], players[player][2] }
    -- 		Wipe Saved Spawn Locations
    for i = 1, 3 do
        Death_Loc[player][i] = nil
    end
    -- 		Stop Printing Messages to Empty Slot
    local message = getmessage(player, 1)
    if message then
        message:delete()
    end
    local message = getmessage(player, 2)
    if message then
        message:delete()
    end

    removetimer(AFK[player].timerid)
    AFK[player] = nil
end

function OnPlayerSpawn(player)
    if getplayer(player) then
        if Spawn_Where_Killed == true then
            if Death_Loc[player][1] ~= nil and Death_Loc[player][2] ~= nil then
                movobjectcoords(getplayerobjectid(player), Death_Loc[player][1], Death_Loc[player][2], Death_Loc[player][3])
                for i = 1, 3 do
                    Death_Loc[player][i] = nil
                end
            end
        end
        local m_player = getplayer(player)
        local objId = readdword(m_player, 0x34)
        local m_object = getobject(objId)
        registertimer(0, "delay_weaps", player)
        if Spawn_Invunrable_Time ~= nil and Spawn_Invunrable_Time > 0 then
            -- 			Setup Invulnerable Timer
            writefloat(m_object + 0xE0, 99999999)
            writefloat(m_object + 0xE4, 99999999)
            registertimer(Spawn_Invunrable_Time * 1000, "RemoveSpawnProtect", m_object)
        end
        -- 			Timer for Flag Captures
        registertimer(Check_Time, "check_loc", objId)
        sendconsoletext(player, "Your Current Level: " .. tostring(players[player][1]) .. "/" .. tostring(#Level) .. " | Kills Needed To Advance: " .. tostring(Level[players[player][1]][4]), Message_Time, 1, "left")
        sendconsoletext(player, "Your Weapon: " .. tostring(Level[players[player][1]][2]) .. " | Instructions: " .. tostring(Level[players[player][1]][3]), Message_Time, 2, "left")
        if Current_FlagHolder ~= nil then
            -- 		Navigation Point
            writeword(m_player + 0x88, Current_FlagHolder)
        else
            -- 		Navigation Point	
            writeword(m_player + 0x88, player)
        end
    end
end

function check_loc(id, count, objId)
    if getobject(objId) ~= nil then
        local player = objectidtoplayer(objId)
        if Current_FlagHolder then
            if tonumber(player) == tonumber(Current_FlagHolder) and inSphere(objId, FLAG[map_name][1][1], FLAG[map_name][1][2], FLAG[map_name][1][3], Check_Radius) == true or inSphere(objId, FLAG[map_name][2][1], FLAG[map_name][2][2], FLAG[map_name][2][3], Check_Radius) == true then
                ctf_score(player)
            end
        end
    else
        return 0
    end
    return 1
end

function inSphere(m_objId, x, y, z, r)

    local ox, oy, oz = getobjectcoords(m_objId)
    local x_dist = x - ox
    local y_dist = y - oy
    local z_dist = z - oz
    local dist = math.sqrt(x_dist ^ 2 + y_dist ^ 2 + z_dist ^ 2)
    if dist <= r then
        return true
    end
end

function ctf_score(player)
    Current_FlagHolder = nil
    cycle_Level(player, true, true)
    SPAWN_FLAG()
end

function OnDamageLookup(receiver, causer, mapId)
    local name, type = gettaginfo(mapId)
    local tag = tokenizestring(name, "\\")
    if tag[3] == "melee" and causer then
        local receiver_pl = objectidtoplayer(receiver)
        if receiver_pl ~= nil then
            if tonumber(receiver_pl) ~= nil then
                if getplayer(receiver_pl) then
                    if name ~= Level[1][1] and name ~= Level[2][1] then
                        cycle_Level(receiver_pl)
                        registertimer(500, "DelayScore", receiver_pl)
                    end
                end
            end
        end
        odl_multiplier(Melee_Multiplier)
    end
end

function RemoveSpawnProtect(id, count, m_object)
    writefloat(m_object + 0xE0, 1)
    writefloat(m_object + 0xE4, 1)
    return 0
end

function delay_weaps(id, count, player)
    set_weapon(player)
    return 0
end

function OnVehicleEntry(player, vehiId, seat, mapId, voluntary)
    return false
end

function OnWeaponReload(player, weapId)
    if player then
        if isinvehicle(player) ~= true then
            AFK[player].time = -1
            AFK[player].boolean = false
        end
    end
end

function OnServerChat(player, type, message)
    local t = tokenizestring(message, " ")
    local count = #t
    if t[1] == nil then
        return false
    end
    if t[1] == "!Level" and isadmin(player) == true then
        if t[2] == "up" then
            privatesay(player, "Next Level")
            cycle_Level(player, true, true)
            return false
        elseif t[2] == "down" then
            privatesay(player, "Previous Level")
            cycle_Level(player, true)
            return false
        else
            privatesay(player, "Action not defined - up or down")
            return false
        end
        return false
    elseif t[1] == "@info" then
        privatesay(player, INFO_MESSAGE)
    elseif t[1] == "@stats" then
        sendconsoletext(player, "Your current Level: " .. tostring(players[player][1]) .. "/" .. tostring(#Level) .. " | Kills Needed To Advance: " .. tostring(Level[players[player][1]][4]), Message_Time, 1, "left")
        sendconsoletext(player, "Your Weapon: " .. tostring(Level[players[player][1]][2]) .. " | Instructions: " .. tostring(Level[players[player][1]][3]), Message_Time, 2, "left")
    end
    if player and type < 4 then
        AFK[player].time = -1
        AFK[player].boolean = false
    end
end

function cycle_Level(player, update, advance)
    if getplayer(player) then
        local current_Level = players[player][1]
        if advance == true then
            local cur = current_Level + 1
            if cur ==(#Level + 1) then
                sendconsoletext(player, "YOU WIN!", 1, 3, "center")
                svcmd("sv_mnext")
            end
            if current_Level < #Level then
                players[player][1] = current_Level + 1
                sendconsoletext(player, "Level UP!", 1, 3, "center")
                sendconsoletext(player, "Your Current Level: " .. tostring(players[player][1]) .. "/" .. tostring(#Level) .. " | Kills Needed To Advance: " .. tostring(Level[players[player][1]][4]), 5, 1, "left")
                sendconsoletext(player, "Your Weapon: " .. tostring(Level[players[player][1]][2]) .. " | Your Instructions: " .. tostring(Level[players[player][1]][3]), 5, 2, "left")
            end
            if current_Level ==(#Level + 1) then
                sendconsoletext(player, "YOU WIN!", 1, 3, "center")
                svcmd("sv_mnext")
            end
        else
            if current_Level > Starting_Level then
                players[player][1] = current_Level - 1
                sendconsoletext(player, "Your Current Level: " .. tostring(players[player][1]) .. "/" .. tostring(#Level) .. " | Kills Needed To Advance: " .. tostring(Level[players[player][1]][4]), 5, 1, "left")
                sendconsoletext(player, "Your Weapon: " .. tostring(Level[players[player][1]][2]) .. " | Your Instructions: " .. tostring(Level[players[player][1]][3]), 5, 2, "left")
                sendconsoletext(player, "Level DOWN!", 1, 3, "center")
            end
        end
        if update == true then
            setscore(player, players[player][1])
        end
        set_weapon(player)
        players[player][2] = 0
    end
end

function OnObjectInteraction(player, objId, mapId)
    for i = 0, #Equipment_Tags do
        if mapId == Equipment_Tags[i] then
            if mapId == doublespeed_id or mapId == full_spec_id then
                registertimer(500, "delaydestroyobject", objId)
                if mapId == doublespeed_id then
                    applyspeed(player)
                else

                end
                return 0
            end
            return 1
        end
    end
    if objId == flag_objId then
        Current_FlagHolder = player
        FlagBall_Weapon[player] = weapid
        for i = 0, 15 do
            if getplayer(i) then
                writeword(getplayer(player) + 0x88, Current_FlagHolder)
            end
        end
        sendconsoletext(Current_FlagHolder, "Return the Flag to a base to gain a Level!")
        if getplayer(player) == nil then return false end
        say("{" .. tostring(player) .. "}  has the Flag! Kill him!", false)
        return 1
    end
    if mapId ~= Level[players[player][1]][10] then
        return 0
    end
end

function delaydestroyobject(id, count, objId)
    if objId then
        destroyobject(objId)
    end
    return 0
end

function OnObjectCreationAttempt(mapId, parentId, player)

    if player then
        local tagname, tagtype = gettaginfo(mapId)
        if tagtype == "proj" then
            if AFK[player] then
                AFK[player].time = -1
                AFK[player].boolean = false
            end
        end
    end
end

function applyspeed(player)
    if player then
        setspeed(player, tonumber(Speed_Powerup))
        registertimer(Speed_Powerup_duration * 1000, "resetspeed", player)
        privatesay(player, "Speed Powerup!")
    end
end

function resetspeed(id, count, player)
    setspeed(player, 1)
    privatesay(player, "Speed Reset!")
    return 0
end

function OnClientUpdate(player)
    local m_player = getplayer(player)
    if m_player then
        local m_objectId = getplayerobjectid(player)
        if m_objectId == nil then return end
        local m_object = getobject(m_objectId)
        if m_object then
            if FlagBall_Weapon[player] then
                if readbit(m_object + 0x209, 3) == true or readbit(m_object + 0x209, 4) == true then
                    Current_FlagHolder = nil
                    FlagBall_Weapon[player] = nil
                    for i = 0, 15 do
                        if getplayer(i) then
                            writeword(getplayer(i) + 0x88, i)
                        end
                    end
                end
            end
            local melee_key = readbit(m_object, 0x208, 0)
            local action_key = readbit(m_object, 0x208, 1)
            local flashlight_key = readbit(m_object, 0x208, 3)
            local jump_key = readbit(m_object, 0x208, 6)
            local crouch_key = readbit(m_object, 0x208, 7)
            local right_mouse = readbit(m_object, 0x209, 3)
            if melee_key or action_key or flashlight_key or jump_key or crouch_key or right_mouse then
                AFK[player].time = -1
                AFK[player].boolean = false
            end
        end
    end
end

function AFKTimer(id, count, player)

    local m_player = getplayer(player)
    if m_player then
        local objId = readdword(m_player, 0x34)
        local m_object = getobject(objId)
        if m_object then
            local x_aim = readfloat(m_object, 0x230)
            local y_aim = readfloat(m_object, 0x234)
            local z_aim = readfloat(m_object, 0x238)
            local bool = true

            if x_aim ==(AFK[player].orientation.x or x_aim) and y_aim ==(AFK[player].orientation.y or y_aim) and z_aim ==(AFK[player].orientation.z or z_aim) then
                local walking = readbyte(m_object, 0x4D2)
                if walking == 0 then
                    bool = false
                end
            end

            AFK[player].orientation.x = x_aim
            AFK[player].orientation.y = y_aim
            AFK[player].orientation.z = z_aim
            AFK[player].response = bool

            if AFK[player].response == false then
                AFK[player].time = AFK[player].time + 1
            else
                AFK[player].time = 0
            end

            if AFK[player].time == 0 then
                AFK[player].boolean = false
            elseif AFK[player].time == AFK_Time then
                AFK[player].boolean = true
            elseif AFK[player].time == AFK_Warn_Time then
                if isadmin(player) == false then
                    privatesay(player, AFK_WARN_MESSAGE, false)
                end
            elseif AFK[player].time == AFK_Kick_Time then
                if isadmin(player) == false then
                    say(getname(player) .. AFK_KICK_MESSAGE, false)
                    svcmd("sv_kick " .. resolveplayer(player))
                end
            end
        else
            AFK[player].orientation.x = nil
            AFK[player].orientation.y = nil
            AFK[player].orientation.z = nil
        end
    end

    return true
end

function isAFK(player)
    if player then
        if AFK[player] then
            return AFK[player].boolean
        end
    end
end

function OnVehicleEject(player, voluntary)
    return false
end

function delay_destroyveh(id, count, vehicle_Id)
    if vehicle_Id then
        destroyobject(vehicle_Id)
    end
    return 0
end

function set_weapon(player)
    local vbool = false
    if isinvehicle(player) then
        vbool = true
        vehicle_Id = getplayervehicleid(player)
        exitvehicle(player)
        registertimer(500, "delay_destroyveh", vehicle_Id)
    end
    if Level[players[player][1]][11] == 1 then
        local m_objectId = getplayerobjectid(player)
        if m_objectId then
            local m_object = getobject(m_objectId)
            if m_object then
                for j = 0, 3 do
                    local m_weaponId = readdword(m_object + 0x2F8 + j * 4)
                    local m_weapon = getobject(m_weaponId)
                    if m_weapon then
                        destroyobject(m_weaponId)
                    end
                end
                FlagBall_Weapon[player] = nil
                if vbool == true then
                    local x, y, z = getobjectcoords(vehicle_Id)
                    local vechid = createobject(Level[players[player][1]][10], 0, 0, false, x, y, z + 0.5)
                    entervehicle(player, vechid, 0)
                else
                    local x, y, z = getobjectcoords(m_objectId)
                    local vechid = createobject(Level[players[player][1]][10], 0, 0, false, x, y, z + 0.5)
                    entervehicle(player, vechid, 0)
                end
            end
        end
    else
        -- 		Remove Current Weapons
        local m_objectId = getplayerobjectid(player)
        if m_objectId then
            local m_object = getobject(m_objectId)
            if m_object then
                for j = 0, 3 do
                    local m_weaponId = readdword(m_object + 0x2F8 + j * 4)
                    local m_weapon = getobject(m_weaponId)
                    if m_weapon then
                        destroyobject(m_weaponId)
                    end
                end
                FlagBall_Weapon[player] = nil
                -- 			Spawn New Weapons
                local x, y, z = getobjectcoords(getplayerobjectid(player))
                local weapid = createobject(Level[players[player][1]][10], m_objectId, 10, false, x + 1, y, z + 2)
                local m_weapon = getobject(weapid)
                if m_weapon then
                    local unloaded_ammo = readdword(m_weapon + 0x2B6)
                    local loaded_ammo = readdword(m_weapon + 0x2B8)
                    if tonumber(unloaded_ammo) and tonumber(Level[players[player][1]][6]) then
                        writedword(m_weapon + 0x2B6, tonumber(unloaded_ammo * Level[players[player][1]][6]))
                        updateammo(weapid)
                    end
                end
                -- 			Assign Weapons to Player
                assignweapon(player, weapid)
            end
            -- 		 Write Nades
            local nades_tbl = Level[players[player][1]][5]
            if nades_tbl then
                -- 		Frags	
                writebyte(m_object, 0x31E, nades_tbl[2])
                -- 	Nades		
                writebyte(m_object, 0x31F, nades_tbl[1])
            end
        end
    end
end

function getplayervehicleid(player)
    local obj_id = getplayerobjectid(player)
    if obj_id then return readdword(getobject(obj_id) + 0x11C) end
end

function setscore(player, score)
    if tonumber(score) then
        if gametype == 1 then
            local m_player = getplayer(player)
            if score >= 0x7FFF then
                writeword(m_player + 0xC8, 0x7FFF)
            elseif score <= -0x7FFF then
                writeword(m_player + 0xC8, -0x7FFF)
            else
                writeword(m_player + 0xC8, score)
            end
        elseif gametype == 2 then
            if score >= 0x7FFFFFFF then
                writeword(slayer_globals + 0x40 + player * 4, 0x7FFFFFFF)
            elseif score <= -0x7FFFFFFF then
                writeword(slayer_globals + 0x40 + player * 4, -0x7FFFFFFF)
            else
                writeword(slayer_globals + 0x40 + player * 4, score)
            end
        elseif gametype == 3 then
            local oddball_game = readbyte(gametype_base + 0x8C)
            if oddball_game == 0 or oddball_game == 1 then
                if score * 30 >= 0x7FFFFFFF then
                    writeword(oddball_globals + 0x84 + player * 4, 0x7FFFFFFF)
                elseif score * 30 <= -0x7FFFFFFF then
                    writeword(oddball_globals + 0x84 + player * 4, -1 * 0x7FFFFFFF)
                else
                    writeword(oddball_globals + 0x84 + player * 4, score * 30)
                end
            else
                if score > 0x7FFFFC17 then
                    writeword(oddball_globals + 0x84 + player * 4, 0x7FFFFC17)
                elseif score <= -0x7FFFFC17 then
                    writeword(oddball_globals + 0x84 + player * 4, -0x7FFFFC17)
                else
                    writeword(oddball_globals + 0x84 + player * 4, score)
                end
            end
        elseif gametype == 4 then
            local m_player = getplayer(player)
            if score * 30 >= 0x7FFF then
                writeword(m_player + 0xC4, 0x7FFF)
            elseif score * 30 <= -0x7FFF then
                writeword(m_player + 0xC4, -0x7FFF)
            else
                writeword(m_player + 0xC4, score * 30)
            end
        elseif gametype == 5 then
            local m_player = getplayer(player)
            if score >= 0x7FFF then
                writeword(m_player + 0xC6, 0x7FFF)
            elseif score <= -0x7FFF then
                writeword(m_player + 0xC6, -0x7FFF)
            else
                writeword(m_player + 0xC6, score)
            end
        end
    end
end

function sendconsoletext(player, message, time, order, align, func)

    console[player] = console[player] or { }

    local temp = { }
    temp.player = player
    temp.id = nextid(player, order)
    temp.message = message or ""
    temp.time = time or 5
    temp.remain = temp.time
    temp.align = align or "left"

    if type(func) == "function" then
        temp.func = func
    elseif type(func) == "string" then
        temp.func = _G[func]
    end

    console[player][temp.id] = temp
    setmetatable(console[player][temp.id], console)
    return console[player][temp.id]
end
function GetGameAddresses(GAME)
    if GAME == "PC" then
        oddball_globals = 0x639E18
        slayer_globals = 0x63A0E8
        name_base = 0x745D4A
        specs_addr = 0x662D04
        hashcheck_addr = 0x59c280
        versioncheck_addr = 0x5152E7
        map_pointer = 0x63525c
        gametype_base = 0x671340
        gametime_base = 0x671420
        machine_pointer = 0x745BA0
        timelimit_address = 0x626630
        special_chars = 0x517D6B
        gametype_patch = 0x481F3C
        devmode_patch1 = 0x4A4DBF
        devmode_patch2 = 0x4A4E7F
        hash_duplicate_patch = 0x59C516
    else
        oddball_globals = 0x5BDEB8
        slayer_globals = 0x5BE108
        name_base = 0x6C7B6A
        specs_addr = 0x5E6E63
        hashcheck_addr = 0x530130
        versioncheck_addr = 0x4CB587
        map_pointer = 0x5B927C
        gametype_base = 0x5F5498
        gametime_base = 0x5F55BC
        machine_pointer = 0x6C7980
        timelimit_address = 0x5AA5B0
        special_chars = 0x4CE0CD
        gametype_patch = 0x45E50C
        devmode_patch1 = 0x47DF0C
        devmode_patch2 = 0x47DFBC
        hash_duplicate_patch = 0x5302E6
    end
end

function nextid(player, order)

    if not order then
        local x = 0
        for k, v in pairs(console[player]) do
            if k > x + 1 then
                return x + 1
            end

            x = x + 1
        end

        return x + 1
    else
        local original = order
        while console[player][order] do
            order = order + 0.001
            if order == original + 0.999 then break end
        end

        return order
    end
end

function getmessage(player, order)

    if console[player] then
        if order then
            return console[player][order]
        end
    end
end

function getmessages(player)

    return console[player]
end

function getmessageblock(player, order)

    local temp = { }

    for k, v in opairs(console[player]) do
        if k >= order and k < order + 1 then
            table.insert(temp, console[player][k])
        end
    end

    return temp
end

function console:getmessage()
    return self.message
end

function console:append(message, reset)

    if console[self.player] then
        if console[self.player][self.id] then
            if getplayer(self.player) then
                if reset then
                    if reset == true then
                        console[self.player][self.id].remain = console[self.player][self.id].time
                    elseif tonumber(reset) then
                        console[self.player][self.id].time = tonumber(reset)
                        console[self.player][self.id].remain = tonumber(reset)
                    end
                end

                console[self.player][self.id].message = message or ""
                return true
            end
        end
    end
end

function console:shift(order)

    local temp = console[self.player][self.id]
    console[self.player][self.id] = console[self.player][order]
    console[self.player][order] = temp
end

function console:pause(time)

    console[self.player][self.id].pausetime = time or 5
end

function console:delete()

    console[self.player][self.id] = nil
end

function ConsoleTimer(id, count)

    for i, _ in opairs(console) do
        if tonumber(i) then
            if getplayer(i) then
                for k, v in opairs(console[i]) do
                    if console[i][k].pausetime then
                        console[i][k].pausetime = console[i][k].pausetime - 0.1
                        if console[i][k].pausetime <= 0 then
                            console[i][k].pausetime = nil
                        end
                    else
                        if console[i][k].func then
                            if not console[i][k].func(i) then
                                console[i][k] = nil
                            end
                        end

                        if console[i][k] then
                            console[i][k].remain = console[i][k].remain - 0.1
                            if console[i][k].remain <= 0 then
                                console[i][k] = nil
                            end
                        end
                    end
                end

                if table.len(console[i]) > 0 then

                    local paused = 0
                    for k, v in pairs(console[i]) do
                        if console[i][k].pausetime then
                            paused = paused + 1
                        end
                    end

                    if paused < table.len(console[i]) then
                        local str = ""
                        for i = 0, 30 do
                            str = str .. " \n"
                        end

                        phasor_sendconsoletext(i, str)

                        for k, v in opairs(console[i]) do
                            if not console[i][k].pausetime then
                                if console[i][k].align == "right" or console[i][k].align == "center" then
                                    phasor_sendconsoletext(i, consolecenter(string.sub(console[i][k].message, 1, 78)))
                                else
                                    phasor_sendconsoletext(i, string.sub(console[i][k].message, 1, 78))
                                end
                            end
                        end
                    end
                end
            else
                console[i] = nil
            end
        end
    end

    return true
end

function consolecenter(text)

    if text then
        local len = string.len(text)
        for i = len + 1, 78 do
            text = " " .. text
        end

        return text
    end
end

function opairs(t)

    local keys = { }
    for k, v in pairs(t) do
        table.insert(keys, k)
    end
    table.sort(keys,
    function(a, b)
        if type(a) == "number" and type(b) == "number" then
            return a < b
        end
        an = string.lower(tostring(a))
        bn = string.lower(tostring(b))
        if an ~= bn then
            return an < bn
        else
            return tostring(a) < tostring(b)
        end
    end )
    local count = 1
    return function()
        if table.unpack(keys) then
            local key = keys[count]
            local value = t[key]
            count = count + 1
            return key, value
        end
    end
end

function table.len(t)

    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end

    return count
end

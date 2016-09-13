-- Script Requirements
--socket = require("socket")
--http = require("socket.http")
 
-- Basic Variables
-- base_url = "http://shstats.wikiop.in/remote_content.php"
access_token = "NDrVDilCi1gjalH7TDPY"
stats = {}
weapons = {}
gametypes = {}
first_strike = nil
killers = {}
assists_table = {}
wheelman_table = {}
last_damage = {}
spree_table = {}
join_time = {}
ctf_stats = {}
rank_table = {
	"Recruit",
	"Private",
	"Corporal",
	"Corporal Grade 1",
	"Sergeant",
	"Sergeant Grade 1",
	"Sergeant Grade 2",
	"Warrant Officer",
	"Warrant Officer Grade 1",
	"Warrant Officer Grade 2",
	"Warrant Officer Grade 3",
	"Captain",
	"Captain Grade 1",
	"Captain Grade 2",
	"Captain Grade 3",
	"Major",
	"Major Grade 1",
	"Major Grade 2",
	"Major Grade 3",
	"Lt. Colonel",
	"Lt. Colonel Grade 1",
	"Lt. Colonel Grade 2",
	"Lt. Colonel Grade 3",
	"Commander",
	"Commander Grade 1",
	"Commander Grade 2",
	"Commander Grade 3",
	"Colonel",
	"Colonel Grade 1",
	"Colonel Grade 2",
	"Colonel Grade 3",
	"Brigadier",
	"Brigadier Grade 1",
	"Brigadier Grade 2",
	"Brigadier Grade 3",
	"General",
	"General Grade 1",
	"General Grade 2",
	"General Grade 3",
	"General Grade 4",
	"Field Marshall",
	"Hero",
	"Legend",
	"Mythic",
	"Noble",
	"Eclipse",
	"Nova",
	"Forerunner",
	"Reclaimer",
	"Inheritor"
}

function GetRequiredVersion() return 200 end
function OnScriptLoad(processId, game, persistent) 

	if game == "PC" then
		gametype_base = 0x671340
	elseif game == "CE" then
		gametype_base = 0x5F5498
	end
	main_timer = registertimer(500, "MainTimer")
	gametype = readbyte(gametype_base + 0x30)

end

function MainTimer(id, count)

	for i = 0, 15 do 
		if getplayer(i) then
			local hash = gethash(i)
			if gametype == 1 then
				local captured = readword(getplayer(i) + 0xC8)
				if captured ~= ctf_stats[hash].captures then
					ctf_stats[hash].captures = captured
					sendconsoletext(i, "Flag Capture")
				end
				local returns = readword(getplayer(i) + 0xC6)
				if returns ~= ctf_stats[hash].returns then
					ctf_stats[hash].returns = returns 
					sendconsoletext(i, "Flag Return")
				end
				local grabs = readword(getplayer(i) + 0xC4)
				if grabs ~= ctf_stats[hash].grabs then
					ctf_stats[hash].grabs = grabs
					sendconsoletext(i, "Flag Grab")
				end
			end
		end
	end
	return true
end
					
function OnScriptUnload() end
function OnNewGame(map) end
function OnGameEnd(stage)

	if stage == 1 then
		for i = 0, 15 do 
			if getplayer(i) then	
				local hash = gethash(i)
				time = os.time() - join_time[hash]
				if stats[hash].timeplayed == nil then
					stats[hash].timeplayed = time
				else
					stats[hash].timeplayed = stats[hash].timeplayed + time
				end
				if stats[hash].gamesplayed == nil then
					stats[hash].gamesplayed = 1
				else
					stats[hash].gamesplayed = stats[hash].gamesplayed + 1
				end
			end
		end
	end
end

function OnServerChat(player, type, message)
        --return true, message, type
end

function OnServerCommandAttempt(player, command, password)
        --return true
end

function OnServerCommand(admin, command)
        --return true
end

function OnNameRequest(hash, name)
        --return true, name
end

function OnBanCheck(hash, ip)    
        --return true
end

function OnPlayerJoin(player)

	local hash = gethash(player)
	local name = getname(player)
	killers[player] = {}
	join_time[hash] = os.time()
	if gametype == 1 then
		ctf_stats[hash] = {}
		ctf_stats[hash].grabs = 0
		ctf_stats[hash].returns = 0
		ctf_stats[hash].captures = 0	
	end
	-- local new_url = base_url .. "?act=load&accesstoken=" .. access_token .. "&name=" .. tostring(name) .. "&hash=" .. tostring(hash)
	-- local b, c, h = http.request(new_url)
    b = tostring(b)
	
	if b == "nf" or b == "notfound" or b == "error" then
		stats[hash] = {}
		stats[hash].kills = 0
		stats[hash].deaths = 0
		stats[hash].assists = 0
		stats[hash].names = tostring(name)
		stats[hash].credits = 0
		stats[hash].multikill = 0
		stats[hash].spree = 0
		stats[hash].gamesplayed = 0
		stats[hash].longestkill = 0
		stats[hash].timeplayed = 0
		weapons[hash] = {}
		weapons[hash].kills = {}
		weapons[hash].deaths = {}
		gametypes[hash] = {}
		gametypes[hash].ctf = {}
		gametypes[hash].slayer = {}
		gametypes[hash].koth = {}
		gametypes[hash].oddball = {}
		gametypes[hash].race = {}
		gametypes[hash].ctf.captures = 0
		gametypes[hash].ctf.returns = 0
		gametypes[hash].ctf.grabs = 0
		gametypes[hash].ctf.killswithflag = 0
		gametypes[hash].slayer.kills = 0
		gametypes[hash].koth.timeinhill = 0
		gametypes[hash].oddball.timewithball = 0
		gametypes[hash].oddball.killswithoddball = 0
		gametypes[hash].oddball.oddballkills = 0
		gametypes[hash].race.laps = 0
		gametypes[hash].race.besttime = 0
	else
		-- Load stats
	end
end

function OnPlayerLeave(player) 

end

function OnPlayerKill(killer, victim, mode)
 
	if game_started == true then
		if mode == 4 then
			local vhash = gethash(victim)
			local khash = gethash(killer)
			local k_player = getplayer(killer)
			local v_player = getplayer(victim)
			local spree = readword(k_player + 0x96)
			local multikill = readword(k_player + 0x98)
			local v_object = getobject(readdword(v_player + 0x34))
			local k_object = getobject(readdword(k_player + 0x34))
			local k_vehicle = readdwordsigned(k_object + 0x11C)
			local tagname = last_damage[vhash]
			local distance = ((readfloat(k_player + 0xF8) - readfloat(v_player + 0xF8))^2 + (readfloat(k_player + 0xFC) - readfloat(v_player + 0xFC))^2 + (readfloat(k_player + 0x100) - readfloat(v_player + 0x100))^2)^0.5
			assists_table[vhash] = 0
			wheelman_table[vhash] = 0
			if table.find(killers[victim], killer) == nil then
				table.insert(killers[victim], killer)
			end
				
			if distance > tonumber(stats[khash].longestkill) then
				stats[khash].longestkill = round(distance, 0)
				sendconsoletext(killer, "New Longest Kill : " .. tonumber(round(distance, 0)))
			end
			
			if spree > tonumber(stats[khash].spree) then
				stats[khash].spree = spree
			end
			
			if multikill > tonumber(stats[khash].multikill) then
				stats[khash].multikill = multikill
			end
			
			CheckFirstStrike(killer)
			CheckKillFromGrave(killer, k_object)
			CheckKilljoy(killer, v_player)
			CheckRevenge(killer, victim)
			CheckReloading(killer, v_object)
			CheckAssists(khash)
			CheckDownshift(khash)
			
			if tagname == "weapons\\sniper rifle\\sniper bullet" then
				if spree_table[khash]["sniper"] == nil then
					spree_table[khash]["sniper"] = 1 
				else
					spree_table[khash]["sniper"] = spree_table[khash]["sniper"] + 1
				end
				
				if spree_table[khash]["sniper"] == 5 then
					sendconsoletext(killer, "Sniper Spree")
				elseif spree_table[khash]["sniper"] == 10 then
					sendconsoletext(killer, "Sharpshooter")
				elseif spree_table[khash]["sniper"] >= 15 and spree_table[khash]["sniper"] % 5 == 0 then
					sendconsoletext(killer, "Be the bullet")
				end
			elseif tagname == "weapons\\shotgun\\pellet" then
				if spree_table[khash]["shotty"] == nil then
					spree_table[khash]["shotty"] = 1
				else
					spree_table[khash]["shotty"] = spree_table[khash]["shotty"] + 1
				end
				
				if spree_table[khash]["shotty"] == 5 then
					sendconsoletext(killer, "Shotty Spree")
				elseif spree_table[khash]["shotty"] == 10 then
					sendconsoletext(killer, "Open Season")
				elseif spree_table[khash]["shotty"] >= 15 and spree_table[khash]["shotty"] % 5 == 0 then
					sendconsoletext(killer, "Buck Wild")
				end
			end	
		end
	end
end

function CheckDownshift(khash)

	for i = 0, 15 do 
		if getplayer(i) then
			local hash = gethash(i)
			if hash ~= khash then
				local m_object = getobject(readdword(getplayer(i) + 0x34))
				local m_vehicle = readdwordsigned(m_object + 0x11C)
				local m_seat = readbyte(m_object + 0x2A0)
				if m_vehicle ~= -1 and m_vehicle ~= 0 and m_vehicle ~= nil and k_vehicle ~= -1 and k_vehicle ~= nil and k_vehicle ~= 0 then
					if m_seat == 0 or m_seat == 13 then
						if k_vehicle == m_vehicle then
							if wheelman_table[hash] == nil then
								wheelman_table[hash] = 1
							else
								wheelman_table[hash] = wheelman_table[hash] + 1
							end
							
							if wheelman_table[hash] == 5 then
								sendconsoletext(i, "Wheelman Spree")
							elseif wheelman_table[hash] == 10 then
								sendconsoletext(i, "Road Hog")
							elseif wheelman_table[hash] >= 15 and wheelman_table[hash]%5 == 0 then
								sendconsoletext(i, "Road Rage")
							end
							break
						end
					end
				end
			end
		end
	end
end
								
function CheckAssists(khash)

	for i = 0, 15 do 
		if getplayer(i) then
			local hash = gethash(i)
			if hash ~= khash then
				local assists = readword(getplayer(i) + 0xA4)
				if assists > assists_table[hash] then
					sendconsoletext(i, "Assist")
					assists_table[hash] = assists
					
					if assists_table[hash] == 5 then
						sendconsoletext(i, "Assist Spree")
					elseif assists_table[hash] == 10 then
						sendconsoletext(i, "Sidekick")
					elseif assists_table[hash] >= 15 and assists_table[hash]%5 == 0 then
						sendconsoletext(i, "Second Gunman")
					end
					break 
				end
			end
		end
	end
end
		
function CheckFirstStrike(kplayer)
 
	if first_strike == nil then
		first_strike = true
		sendconsoletext(kplayer, "First Strike")
	end
end

function CheckKillFromGrave(kplayer, object)

	if readfloat(object + 0xE0) == 0 then
		sendconsoletext(kplayer, "Kill from the grave")
	end
end

function CheckKilljoy(kplayer, vobjplayer)

	if readword(vobjplayer + 0x96) >= 5 then
		sendconsoletext(kplayer, "Killjoy")
	end
end

function CheckRevenge(killer, victim)

	for k,v in pairs(killers[killer]) do
		if v == victim then
			table.remove(killers[killer], k)
			sendconsoletext(killer, "Revenge")
		end
	end
end

function CheckReloading(killer, obejct)

	local obj_action3 = readbyte(object + 0x2A4)
	
	if obj_action3 == 5 then
		sendconsoletext(killer, "Reload This")
	end
end

function OnKillMultiplier(player, multiplier)
 
        -- Multipliers:
        -- 7: Double Kill
        -- 9: Triple Kill
        -- 10: Killtacular
        -- 11: Killing Spree
        -- 12: Running Riot
        -- 16: Double Kill w/ Score
        -- 17: Triple Kill w/ Score
        -- 14: Killtacular w/ Score
        -- 18: Killing Spree w/ Score
        -- 17: Running Riot w/ Score
end

function OnPlayerSpawn(player)
       
end

function OnPlayerSpawnEnd(player, m_objectId)
 
end

function OnWeaponAssignment(player, objId, slot, weapId)   
        --return mapId
end

function OnWeaponReload(player, weapId)
        --return true
end

function OnObjectCreationAttempt(mapId, parentId, player)    
        --return mapId
end

function OnObjectCreation(objId)
 
end

function OnObjectInteraction(player, objId, mapId)
 
end

function OnTeamDecision(team)
        --return team
end

function OnTeamChange(player, old_team, new_team, voluntary)  
        --return true
end

function OnDamageLookup(receiver, causer, mapId)      
        --return true
end

function OnDamageApplication(receiving, causing, tagid, hit, backtap)

    if receiving then
		local r_object = getobject(receiving)
		if r_object then
            local receiver = objectaddrtoplayer(r_object)
            if receiver then
                if not backtap then
                    local tagname,tagtype = gettaginfo(tagid)
                    last_damage[gethash(receiver)] = tagname
                 else
                    last_damage[gethash(receiver)] = "melee"
                end
            end
        end
    end
end

function OnVehicleEntry(player, vehiId, seat, mapId, voluntary)    
        --return true
end

function OnVehicleEject(player, voluntary)
        --return true
end

function OnClientUpdate(player)
 
end

function round(val, decimal)
 
    return math.floor( ( val * 10 ^ ( tonumber( decimal ) or 0 ) + 0.5 ) ) / ( 10 ^ ( tonumber( decimal ) or 0 ) )
       
end

function table.find(t, v)

	for k,val in pairs(t) do
		if v == val then
			return k
		end
	end
end

function table.string(t)

	local str = ""

	for k,v in pairs(t) do
		if type(v) ~= "table" then
			str = tostring(v)
		end
	end
	
	return string.sub(str, 1, string.len(str))	
end
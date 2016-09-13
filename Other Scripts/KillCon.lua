print_message = "chat"
tags = {}
cur_players = 0
score = {}

function GetRequiredVersion() return 200 end
function OnScriptLoad(processId, game, persistent) 
	if game == "PC" then
		gametype_base = 0x671340
		slayer_globals = 0x63A0E8
	else
		gametype_base = 0x5F5498
		slayer_globals = 0x5BE108
	end
end

function OnClientUpdate(player)
	if getplayer(player) then
		writedword(slayer_globals + player * 4 + 0x40, score[player])
	end
end

function setscore(id, count)

	local multi = nil
	if cur_players >= 3 and cur_players <= 5 then
		multi = 15
	elseif cur_players >= 5 and cur_players <= 10 then
		multi = 30
	elseif cur_players >= 10 and cur_players <= 16 then
		multi = 50
	end
	if multi ~= nil then
		writebyte(gametype_base + 0x58, multi + 1)
		sendmsg("The Score Limit has been changed to " .. multi .. "!")
	else
		-- raiseerror("The Score limit could not be set!")
	end
end

 
function OnNewGame(map)
	score_timer = registertimer(20000, "setscore")
end
 
function OnPlayerJoin(player)
	score[player] = 0
	cur_players = cur_players + 1
end

function OnPlayerLeave(player)
	score[player] = 0
	cur_players = cur_players - 1
end

function OnPlayerKill(killer, victim, mode)
	if mode == 4 then
		local xcoord = readfloat(getplayer(victim) + 0xF8) 
        local ycoord = readfloat(getplayer(victim) + 0xFC) 
		local zcoord = readfloat(getplayer(victim) + 0x100) 
		local tagid = gettagid("eqip", "powerups\\full-spectrum vision")
		local object = createobject(tagid, 0, -1, false, xcoord, ycoord, zcoord + 0.5)
		local m_object = getobject(object)
		tags[m_object] = gethash(victim) .. ":" .. gethash(killer) .. ":" .. resolveplayer(victim) .. ":" .. resolveplayer(killer)
	end
end

function OnObjectInteraction(player, objId, mapId)
	local tagName, tagType = gettaginfo(mapId)
	if tagName == "powerups\\full-spectrum vision" then
		if tags[getobject(objId)] ~= nil then
			local t = tokenizestring(tostring(tags[getobject(objId)]), ":")
			OnTagPickup(player, t[1], t[2], t[3], t[4])
		end
	end
end

function OnTagPickup(player, vhash, khash, vrcon, krcon)
	local kplayer = rresolveplayer(krcon)
	local vplayer = rresolveplayer(vrcon)
	if vhash and khash and vrcon and krcon and kplayer and vplayer then
		if gethash(player) == khash and getteam(vplayer) ~= getteam(kplayer) then
			sendmsg(getname(player) .. " confirmed their kill on " .. getname(vplayer) .. "!")
			score[player] = score[player] + 1
		elseif gethash(player) ~= khash or gethash(player) ~= vhash and getteam(player) == getteam(kplayer) then
			if getname(player) ~= getname(vplayer) then
				if getteam(player) ~= getteam(vplayer) then
					sendmsg(getname(player) .. " confirmed " .. getname(kplayer) .. "'s kill on " .. getname(vplayer) .. "!")
					score[player] = score[player] + 1
				end
			end
		end
		if getteam(player) == getteam(vplayer) and player ~= vplayer then
			sendmsg(getname(player) .. " denied " .. getname(kplayer) .. "'s kill on " .. getname(vplayer) .. "!")
		end
		if player == vplayer then
			sendmsg(getname(player) .. " denied " .. getname(kplayer) .. "'s kill on themselves!")
		end
	end
end

function sendmsg(msg)
	if print_message == 'console' then
		for i = 0, 15 do 
			if getplayer(i) then
				sendconsoletext(i, msg)
			end
		end
	elseif print_message == 'chat' then
		say(msg, false)
	else
		say(msg, false)
	end
end
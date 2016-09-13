vehicles = {}
delay = {}
map_ids = {}

function GetRequiredVersion()
	return 200
end

function OnScriptLoad(process, game, persistent)
	for i=0,15 do delay[i] = nil end
	LoadTags()
end

function OnNewGame(map)
	for i=0,15 do delay[i] = nil end
	LoadTags()
end

function OnDamageLookup(receiving, causing, tagid, tagdata)
	if receiving and causing and receiving ~= causing then
		local c_player = objectidtoplayer(causing)
		if delay[c_player] then 
			return nil
		end
		if tagid == pistol_id or tagid == sniper_id then
			local bool, driver, passenger, gunner = false, false, false, false
			local mapId = readdword(getobject(receiving))
			if not bool and ghost_tag_id == mapId then
				bool = true
				passenger = true
				gunner = true
			else
				for k,v in pairs(map_ids) do
					if mapId == v then
						bool = true
						break
					end
				end
			end
			if bool then
				if c_player then
					for k,v in pairs(vehicles) do
						if vehicles[k].vehiId == receiving and getplayer(k) and getteam(c_player) == getteam(k) then
							if vehicles[k].seat == 0 then 
								driver = true 
							elseif vehicles[k].seat == 2 then 
								gunner = true
							elseif vehicles[k].seat == 1 then 
								passenger = true
							end
						end
					end
					if not isinvehicle(c_player) then
						if not driver then
							entervehicle(c_player, receiving, 0)
						elseif not gunner then
							delay[c_player] = registertimer(1000, "damagetimer", c_player)
							entervehicle(c_player, receiving, 2)
						elseif not passenger then
							delay[c_player] = registertimer(1000, "damagetimer", c_player)
							entervehicle(c_player, receiving, 1)
						end
					end
				end
			end
		end
	end
	return nil	
end

function OnPlayerJoin(player)
	vehicles[player] = {}
	announce = registertimer(2001, "timedannounce", player)
end

function timedannounce(id, count, player)
	if getplayer(player) then sendconsoletext(player, "Pistol Entry is Enabled.") end
	return false
end

function OnVehicleEntry(player, veh_id, seat, mapId, relevant)
	vehicles[player] = {}
	vehicles[player].vehiId = veh_id
	vehicles[player].seat = seat
	return nil
end

function OnVehicleEject(player, relevant)
	vehicles[player] = nil
	return nil
end

function damagetimer(id, count, player)
	delay[player] = nil
	return false
end

function LoadTags()
	pistol_id = gettagid("jpt!", "weapons\\pistol\\bullet")
	sniper_id = gettagid("jpt!", "weapons\\sniper rifle\\sniper bullet")
	ghost_tag_id = gettagid("vehi", "vehicles\\ghost\\ghost_mp")
	table.insert(map_ids, gettagid("vehi", "vehicles\\rwarthog\\rwarthog"))
	table.insert(map_ids, gettagid("vehi", "vehicles\\warthog\\mp_warthog"))
    table.insert(map_ids, gettagid("vehi", "vehicles\\banshee\\banshee_mp"))
    table.insert(map_ids, gettagid("vehi", "vehicles\\scorpion\\scorpion_mp"))
end
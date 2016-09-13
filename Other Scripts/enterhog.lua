function LoadTags()
	Map_IDs["bloodgulch"] = gettagid("vehi", "vehicles\\rwarthog\\rwarthog")
	-- Map_IDs["bloodgulch"] = gettagid("vehi", "vehicles\\warthog\\mp_warthog")
end
Hog_Limit = 5 -- How many Hogs each player is allowed to spawn per game.
hogs, Map_IDs = {}, {} -- Do Not Touch.
Hog_Spawn = {} -- Do Not Touch.
-- 				Map:						Boolean:
Hog_Spawn.		bloodgulch	 		= 		true				
-----------------------------------------------------
function GetRequiredVersion() return 200 end
function OnScriptLoad(process, game, persistent)
	if game == true or game == "PC" then
		GAME = "PC"
		Map_Name = readstring(0x698F21)
	else
		GAME = "CE"
		Map_Name = readstring(0x61D151)
	end
	LoadTags()
	for i=0,15 do
		hogs[i] = 0, {}
		if getplayer(i) then
			local player_obj_id = getplayerobjectid(i)
			if player_obj_id then
				local m_object = getobject(player_obj_id)
			end
		end
	end
end


function OnNewGame(map)
	if GAME == "PC" then
		Map_Name = readstring(0x698F21)
	elseif GAME == "CE" then
		Map_Name = readstring(0x61D151)
	end
	LoadTags()	
end

function OnPlayerJoin(player)
	hogs[player] = 0, {}
end

function OnServerChat(player, type, message)
	local response = nil
	if player then
	if string.lower(message) == "hog" then
			local m_player = getplayer(player)
			if m_player then
				if Hog_Spawn[Map_Name] then
					if not isinvehicle(player) then
						local m_player = getplayerobjectid(player)
						if m_player ~= nil then 
							local x,y,z = getobjectcoords(m_player)
							if not Hog_Limit or hogs[player] < Hog_Limit then						
								local m_vehicleId = createobject(Map_IDs[Map_Name], 0, 15, false, x,y,z+0.4)
								entervehicle(player, m_vehicleId, 0)
								hogs[player] = hogs[player] + 1
								sendconsoletext(player, "You have " .. Hog_Limit - hogs[player] .. " hog calls remaining.")
								hprintf("H O G   S P A W N   -   " .. getname(player) .. " spawned themselves a hog.")
							else -- Player has reached their max allocation for that game.
								sendconsoletext(player, "Sorry, You have reached the max amount of hog calls for this game.")
							end
						else -- Player is Re-Spawning
							sendconsoletext(player, "You cannot spawn a hog while dead. ")
						end	
					else -- Player is already in a Vehicle
						sendconsoletext(player, "You already have a vehicle!")
					end
				else -- Map Boolean (Hog Spawn enabled / disabled for the map)
					sendconsoletext(player, "Feature Disabled!")
				end	
			end
		response = false
	end
	end
end
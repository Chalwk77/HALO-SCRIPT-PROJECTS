--[[ 
Document Name: Aim Bot Detection Script.
Edited by {ØZ}Çhälwk' for {OZ}-12 Elite Combat Server - OZ Clan
Xfire : Chalwk77
Website(s): www.joinoz.proboards.com AND www.phasor.proboards.com
Gaming Clan: {ØZ} Elite SDTM Clan - on HALO PC.
Server Name: {OZ}-12 Elite Combat Server - OZ Clan
]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
max_score = 115
score_timeout = 2.5
points_reduced = 1
max_ping = 500
warnings_needed = 1
default_action = "notify"
default_ban_time = 0
logwarnings = true
notify_player = false
notify_admins = true
notify_server = false
same_team_detect = true
snap_max_angle = 180
snap_min_angle = 5
snap_stop_angle = 0.42
degrees_subtracted = 0.015
distance_variable = 4.5

score_snap_angle =  {
	{4, 8, 10}, {9, 14, 15},
	{15, 20, 17}, {21, 26, 19},
	{25, 32, 21}, {33, 38, 23},
	{39, 44, 25}, {45, 50, 27},
	{51, 56, 29}, {57, 62, 31},
	{63, 68, 33}, {69, 74, 33},
	{75, 80, 27}, {81, 86, 25},
	{85, 92, 23}, {92, 98, 21},
	{99, 180, 19}
}

camera_table = {}
watch_table = {}
snap_table = {}
warning_table = {}
snap_angle = {}
player_score = {}
isSpawning = {}
actionTaken = {}
loc = {}

function GetRequiredVersion() return 200 end
function OnAimbotDetection(player)
	return (not isSpawning[player] )
end

function OnScriptLoad(process, game, persistent)
	for i = 0,15 do
		loc[i] = {}
		player_score[i] = 0
	end
	log_file = getprofilepath() .. "\\logs\\Aim-Bot Records.log"
	registertimer(score_timeout * 1000, "ScoreTimeoutTimer", points_reduced)
end
--[[
IN-GAME RESULTS:
-------------------------------------
>> AIM-BOT DETECTION RECORDS <<
Viewing Records for (Player X)
Snaps   |   Angle   |   Date & Time
  0			  0		      HMS DMY 
<no more records to display>
-------------------------------------
]]
function OnServerCommand(player, command, password)
	local timestamp = os.date ("%H:%M:%S: %d/%m/%Y")
	local response = nil
	t = tokenizecmdstring(command)
	count = #t
	if t[1] == "sv_aimbotrecord" then -- For Individule players.
		response = false
		if t[2] and rresolveplayer( t[2] ) then
			local id = rresolveplayer( t[2] )
			sendresponse("-------------------------------------", player)
			sendresponse(">> AIM-BOT DETECTION RECORDS <<", player)
			sendresponse("Viewing Records for: " ..getname(id), player)
			sendresponse("Snaps   |   Angle   |   Date & Time ", player)
			sendresponse("("..player_score[id]..")                  (" ..tostring(count)..")        " ..timestamp, player)
			sendresponse("<no more records to display>", player)
			sendresponse("-------------------------------------", player)
		else
			sendresponse("Error. You need to specify a player. Use  sv_aimbotrecord [ Player ID ]", player)
		end
	elseif t[1] == "sv_aimbotrecords" then -- For All Players currently in the server.
		response = false
		sendresponse("-------------------------------------", player)
		sendresponse(">> AIM-BOT DETECTION RECORDS <<")
		sendresponse("Viewing Records for all players", player)
		sendresponse("Name     |   Snaps     |   Angle     |   Date & Time ", player)
	for i = 0,15 do
		if getplayer(i) then
		sendresponse(getname(i) .. "    (".. player_score[i]..")             (" ..tostring(count)..")        " ..timestamp, player)
		sendresponse("<no more records to display>", player)
		sendresponse("-------------------------------------", player)
		end
	end
end
	return response
end

function OnPlayerJoin(player)
	snap_angle[player] = 0
	warning_table[player] = 0
	player_score[player] = 0
	snap_table[player] = {0}
end

function OnPlayerLeave(player)
	camera_table[player] = nil
	watch_table[player] = nil
	snap_angle[player] = nil
	warning_table[player] = nil
	player_score[player] = 0
	snap_table[player] = {0}
end

function OnPlayerKill(killer, victim, mode)
	camera_table[victim] = nil
	watch_table[victim] = nil
	snap_angle[victim] = 0
end

function OnPlayerSpawn(player)
	camera_table[player] = nil
	watch_table[player] = nil
	snap_angle[player] = 0
	isSpawning[player] = true
	registertimer(500, "playerIsSpawning", player)
end

function OnPlayerSpawnEnd(player)
	camera_table[player] = nil
	watch_table[player] = nil
	snap_angle[player] = 0
end

function OnClientUpdate(player)
local m_objectId = getplayerobjectid( player )
local m_object = getobject( m_objectId )
local x,y,z = getobjectcoords( m_objectId )

local distance
	if x ~= loc[player][1] or y ~= loc[player][2] or z ~= loc[player][3] then
		if loc[player][1] == nil then
			loc[player][1] = x
				loc[player][2] = y
					loc[player][3] = z
		elseif m_object then
			distance = math.sqrt((loc[player][1] - x)^2 + (loc[player][2] - y)^2 + (loc[player][3] - z)^2)
			local result = true
				if distance >= 10 then result = OnPlayerTeleport( player ) end
					if result == 0 or not result then
						movobjectcoords(m_objectId, loc[player][1], loc[player][2], loc[player][3])
			else
				loc[player][1] = x
					loc[player][2] = y
						loc[player][3] = z
			end
		end
	end

local camera_x = readfloat(m_object + 0x230)
local camera_y = readfloat(m_object + 0x234)
local camera_z = readfloat(m_object + 0x238)

	if camera_table[player] == nil then
		camera_table[player] = {camera_x, camera_y, camera_z}
		return
	end

local last_camera_x = camera_table[player][1]
local last_camera_y = camera_table[player][2]
local last_camera_z = camera_table[player][3]

	camera_table[player] = {camera_x, camera_y, camera_z}

	if 	last_camera_x == 0 and
		last_camera_y == 0 and
		last_camera_z == 0 then
		return
	end

local movement = math.sqrt(
	(camera_x - last_camera_x) ^ 2 +
	(camera_y - last_camera_y) ^ 2 +
	(camera_z - last_camera_z) ^ 2)

local angle = math.acos((2 - movement ^ 2) / 2)
	angle = angle * 180 / math.pi

	if watch_table[player] ~= nil then
		watch_table[player] = nil
		local value = ( snap_stop_angle - ( degrees_subtracted * ( ( distance or 0 ) / distance_variable ) ) )
	if angle < value and OnAimbotDetection(player) then
			for i = 0, 15 do
				if IsLookingAt(player, i) then
					TallyPlayer(player)
					break
				end
			end
		end
		return
	end
	if angle > snap_min_angle and angle < snap_max_angle then
		watch_table[player] = true
		snap_angle[player] = angle
	end
end

function OnPlayerTeleport( player )
	isSpawning[player] = true
	registertimer(600, "playerIsSpawning", player)
	return true
end

function playerIsSpawning(id, count, player)
	isSpawning[player] = false
	return false
end

function ScoreTimeoutTimer(id, count, score_depletion)
	for i = 0,15 do
		if player_score[i] and player_score[i] ~= 0  then
			player_score[i] = player_score[i] - score_depletion
			if player_score[i] <= 0 then
				player_score[i] = 0
			end
		end
	end
	return true
end

function TallyPlayer(player)
	if getplayer(player) == nil then
		return
	end
	if notify_admins then -- Notifies all admins in the server that (player x) has been suspected of Aim-Botting. ( HIGHLY RECOMMENDED )
		for i = 0, 15 do
			if getplayer(i) ~= nil and isadmin(i) then
	if 				getping(player) <= max_ping then
		for i = 1,#score_snap_angle do
			if snap_angle[player] >= score_snap_angle[i][1] and snap_angle[player] <= score_snap_angle[i][2] then
				player_score[player] = player_score[player] + score_snap_angle[i][3]
				hprintf("-    -    -    -    -    -    -    -    -    -    -    -    -    -    -    -")
				hprintf("                      *  *  W  A  R  N  I  N  G  *  *")
				hprintf(tostring(getname(player)) .. " has been suspected of Aim-Botting! Registered Snap Angle: " .. tostring(score_snap_angle[i][3]))
				hprintf("-    -    -    -    -    -    -    -    -    -    -    -    -    -    -    -")
				privatesay(i, "** W A R N I N G **  | " .. getplayer(i) .. " has been suspected of Aim-Botting! Registered Angle: " .. tostring(score_snap_angle[i][3]))
				break
				end
			end
		end
	end
	end
		if player_score[player] >= max_score then
			if warning_table[player] == nil then warning_table[player] = 0 end
			warning_table[player] = warning_table[player] + 1
			if warning_table[player] >= warnings_needed then
				snap_table[player][1] = snap_table[player][1] + 1
				local count = snap_table[player][1]
				if default_action == "kick" then
					svcmd("sv_kick " .. resolveplayer(player))
					if notify_player then
						privatesay(player, "You are being kicked for using an Aim-Bot.")
						hprintf("** S E R V E R **  to | " ..name.. "You are being kicked for using an Aim-Bot.")
					end
					if notify_admins then
						for i = 0, 15 do
							if getplayer(i) ~= nil and isadmin(i) then
								privatesay(getplayer(i) .. " was kicked for using an Aim-Bot.")
								--privatesay(i, getname(player) .. " was kicked for using an Aim-Bot.")
								hprintf("** S E R V E R **  | " ..name.. " was kicked for using an Aim-Bot.")
							end
						end
					end
					if notify_server then -- Notifies every player currently on the server that (player x) has been kicked for Aim-Botting ( NOT RECOMMENDED ).
						for i = 0, 15 do
							if getplayer(i) ~= nil then
								if not isadmin(i) then
									privatesay(i, getname(player) .. " was kicked for aimbotting.")
									hprintf("** S E R V E R **  | " ..name.. " was kicked for using an Aim-Bot.")
								end
							end
						end
					end
				elseif default_action == "notify" then -- Notifies the 'botter' that they have been suspected of Aim-Botting ( NOT RECOMMENDED ).
					if notify_player then
						privatesay(player, "You have been suspected of aimbotting (Count: " .. tostring(count) ..  ")")
						hprintf("** S E R V E R **  to | " ..name.. " You have been suspected of Aim-Botting! (Registered snaps: " .. tostring(count) .. ")")
					end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					if notify_admins then -- Notifies all admins in the server that (player x) has been suspected of Aim-Botting. ( HIGHLY RECOMMENDED )
						for i = 0, 15 do
							if getplayer(i) ~= nil and isadmin(i) then
								privatesay(i, "** W A R N I N G **  | " .. getplayer(i) .. " Has been suspected of Aim-Botting! (Registered Snaps: " .. tostring(count) .. ") Angle: " .. tostring(score_snap_angle[i][3]).."", false)
								hprintf("** W A R N I N G **  | " ..name.. " Has been suspected of Aim-Botting! (Registered Snaps: " .. tostring(count) .. ")")
							end
						end
					end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------					
					if notify_server then -- Notifies every player on the server that (player x) has been suspected of Aim-Botting ( NOT RECOMMENDED ).
						for i = 0, 15 do
							if getplayer(i) ~= nil then
								if not isadmin(i) then
									privatesay(i, getname(player) .. " Has been suspected of Aim-Botting! (Snaps: " .. tostring(count) .. ")")
									hprintf("** W A R N I N G **  | " ..name.. " Has been suspected of Aim-Botting! (Snaps: " .. tostring(count) .. ")")
								end
							end
						end
					end
				elseif default_action == "ban" then -- NOT RECOMMENDED. 
					svcmd("sv_ban " .. resolveplayer(player) .. " " .. default_ban_time)
					if notify_player then
						privatesay(player, "You have been banned for using an Aim-Bot!")
						hprintf(name.. "Has been banned for using an Aim-Bot!")
					end
					if notify_admins then
						for i = 0, 15 do
							if getplayer(i) ~= nil and isadmin(i) then
								privatesay(i, getname(player) .. " was banned for using an Aim-Bot!")
								hprintf(name.. "Has been banned for using an Aim-Bot!")
							end
						end
					end
					if notify_server then -- NOT RECOMMENDED.
						for i = 0, 15 do
							if getplayer(i) ~= nil then
								if not isadmin(i) then
									privatesay(i, getname(player) .. " was banned for using an Aim-Bot!")
								end
							end
						end
					end
				end
				-- Action Taken --
					player_score[player] = 0
					if logwarnings then
					local name = getname(player) or "Unknown"
					local hash = gethash(player) or "Unknown"
					local ip = getip(player) or "Unknown"
					local ping = getping(player) or "Unknown"
					local line = "%s registered a snap. (Hash: %s) (IP: %s) (ping: %s)."
					line = string.format(line, name, hash, ip, ping)
					WriteLog(log_file, line)
				end
			end
		end
	end
end
function sayExcept(message, player)
	for i = 0, 15 do
		if i ~= player then
			privatesay(i, message)
		end
	end
end

function getping(player)
local m_player = getplayer(player)
	if m_player then return readword(m_player + 0xDC) end
end

function IsLookingAt(player1, player2)

	if getplayer(player1) == nil or getplayer(player2) == nil then
		return
	end

local m_playerObjId1 = getplayerobjectid( player1 )
local m_playerObjId2 = getplayerobjectid( player2 )

	if m_playerObjId1 == nil or m_playerObjId2 == nil then
		return
	end

	if same_team_detect and getteam( player1 ) == getteam( player2 ) then
		return false
	end

local m_object1 = getobject( m_playerObjId1 )
local m_object2 = getobject( m_playerObjId2 )
local camera_x = math.round( readfloat(m_object1 + 0x230) , 1)
local camera_y = math.round( readfloat(m_object1 + 0x234) , 1)
local camera_z = math.round( readfloat(m_object1 + 0x238) , 1)
local location1_x = readfloat(m_object1 + 0x5C)
local location1_y = readfloat(m_object1 + 0x60)
local location1_z = checkState( readbyte(m_object1 + 0x2A7) , readfloat(m_object1 + 0x64) )
local location2_x = readfloat(m_object2 + 0x5C)
local location2_y = readfloat(m_object2 + 0x60)
local location2_z = checkState( readbyte(m_object2 + 0x2A7) , readfloat(m_object2 + 0x64) )

	if location1_z == nil  or location2_z == nil then
		return
	end

local local_x = (location2_x - location1_x)
local local_y = (location2_y - location1_y)
local local_z = (location2_z - location1_z)

local radius = math.sqrt( (local_x) ^ 2 + (local_y) ^ 2 + (local_z) ^ 2 )

local point_x = math.round(1 / radius * local_x, 1)
local point_y = math.round(1 / radius * local_y, 1)
local point_z = math.round(1 / radius * local_z, 1)

local isLookingAt = (camera_x == point_x and camera_y == point_y and camera_z == point_z)
return isLookingAt

end

function checkState(state, location_z)
	if state == 2 then
		return location_z + 0.6
	elseif state == 3 then
		return location_z + 0.3
	end
	return nil
end

function sendresponse(message, player)
	if player then
		sendconsoletext(player, message)
	else
		hprintf(message)
	end
end

function math.round(number, place)
	return math.floor(number * ( 10 ^ (place or 0) ) + 0.5) / ( 10 ^ (place or 0) )
end

function WriteLog(filename, value)
	local file = io.open(filename, "a")
	if file then
		file:write( string.format("%s\t%s\n", os.date("!%d/%m/%Y %H:%M:%S"), tostring(value) ) )
		file:close()
	end
end
ctf_enabled = true
check_time = 500
check_radius = 1
cur_flagholder = nil
flag = {}
flag["bloodgulch"] = {{95.687797546387,-159.44900512695,-0.10000000149012},{40.240600585938,-79.123199462891,-0.10000000149012},{65.749893188477,-120.40949249268,0.11860413849354}}
flagball_weap = {}

function GetRequiredVersion() return 200 end
function OnScriptLoad(processId, game, persistent) 
	respawn_time = 7
	flag_respawn_addr = 0x488A7E
	writedword(flag_respawn_addr, 0, 0xFFFFFFFF)
	writedword(0x671340, 0x48, respawn_time * 30)
	flags = {}
	shared_spawns = false 
end
function ctf_score(player)
	cur_flagholder = nil
	spawn_flag()
end

function OnNewGame(map)
	flag_id = gettagid("weap","weapons\\flag\\flag")
	map_name = tostring(map)
	if ctf_enabled == true then
		spawn_flag()
	end
end

function spawn_flag()
	local t = flag[map_name][3]
	flag_objId = createobject(flag_id, 0, 11, false, t[1],t[2],t[3])
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
	cur_flagholder = nil
	spawn_flag()
end

function OnPlayerSpawn(player)
	local m_player = getplayer(player)
	local objId = readdword(m_player, 0x34)
	local m_object = getobject(objId)

	if cur_flagholder ~= nil then
		writeword(m_player + 0x88, cur_flagholder)
	else
		writeword(m_player + 0x88, player)
	end
end

function OnObjectInteraction(player, objId, mapId)
	if objId == flag_objId then
		cur_flagholder = player
		flagball_weap[player] = weapid
		for i =0,15 do
			if getplayer(i) then
			writeword(getplayer(player) + 0x88, cur_flagholder)
			end
		end
		sendconsoletext(cur_flagholder, "This is the Staff of Influence. Capture this bad boy and you'll be rewarded with cookies!")
		return 1
	end
end

function OnClientUpdate(player)
	local m_player = getplayer(player)
	if m_player then
		local m_objectId = getplayerobjectid(player)
		if m_objectId == nil then return end
		local m_object = getobject(m_objectId)
		if m_object then
		if flagball_weap[player] then
			if readbit(m_object + 0x209, 3) == true or readbit(m_object + 0x209, 4) == true then
				cur_flagholder = nil
					flagball_weap[player] = nil
						for  i=0,15 do
							if getplayer(i) then
							writeword(getplayer(i) + 0x88, i)
						end
					end
				end
			end
		end
	end
end

function OnGameEnd(stage)
	if stage == 3 then
		flag_respawn_addr = 0x488A7E
		writedword(flag_respawn_addr, 0, 17 * 30)
	end
end


function CreationDelay(id, count)

		
	local ctf_globals = 0x639B98
	for i = 0,1 do
		ctf_flag_coords_pointer = readdword(ctf_globals + i * 4, 0x0)
		writefloat(ctf_flag_coords_pointer, 0)
		writefloat(ctf_flag_coords_pointer + 4, 0)
		writefloat(ctf_flag_coords_pointer + 8, -1000)
	end
	
	if staff_of_influence then
		if #staff.spawns[this_map] > 0 then
			local mapId = gettagid("weap", "weapons\\flag\\flag")
			local rand = getrandomnumber(1, #staff.spawns[this_map] + 1)
			staff.x = staff.spawns[this_map][rand][1]
			staff.y = staff.spawns[this_map][rand][2]
			staff.z = staff.spawns[this_map][rand][3]
			staff.objId = createobject(mapId, 0, staff.respawn, true, staff.x, staff.y, staff.z)
			staff.respawn_remain = staff.respawn
			
			registertimer(1000, "Respawn", "staff")
		else
			hprintf("There are no Staff of Influence spawn points for " .. this_map)
		end
	end
	
	registertimer(10, "SphereMonitor")
	
	return false
end

function Respawn(id, count, item)

	if _G[item].player then
		_G[item].respawn_remain = _G[item].respawn
	else
		local objId = _G[item].objId
		local m_object = getobject(objId)
		if m_object then
			local x, y, z = getobjectcoords(objId)
			if math.round(x, 1) == math.round(_G[item].x, 1) and math.round(y, 1) == math.round(_G[item].y, 1) and math.round(z, 1) == math.round(_G[item].z, 1) then
				_G[item].respawn_remain = _G[item].respawn
			else
				_G[item].respawn_remain = _G[item].respawn_remain - 1
				if _G[item].respawn_remain <= 0 then
					movobjectcoords(objId, _G[item].x, _G[item].y, _G[item].z)
					_G[item].respawn_remain = _G[item].respawn
				end
			end
		else
			_G[item].respawn_remain = _G[item].respawn_remain - 1
			if _G[item].respawn_remain <= 0 then
				local mapId
				if item == "ball" then
					mapId = gettaginfo("weap", "weapons\\ball\\ball")
				elseif item == "staff" then
					mapId = gettaginfo("weap", "weapons\\flag\\flag")
				end
				
				_G[item].objId = createobject(mapId, 0, 0, false, _G[item].x, _G[item].y, _G[item].z)
				_G[item].respawn_remain = _G[item].respawn
			end
		end
	end
	
	return true
end
	
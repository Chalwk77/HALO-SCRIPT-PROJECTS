CTF_ENABLED = true
Current_FlagHolder = nil

FLAG = {}
FLAG["beavercreek"] = {{29.055599212646,13.732000350952,-0.10000000149012},{-0.86037802696228,13.764800071716,-0.0099999997764826},{14.01514339447,14.238339424133,-0.91193699836731}}
FLAG["bloodgulch"] = {{95.687797546387,-159.44900512695,-0.10000000149012},{40.240600585938,-79.123199462891,-0.10000000149012},{65.749893188477,-120.40949249268,0.11860413849354}}
FLAG["boardingaction"] = {{1.723109960556,0.4781160056591,0.60000002384186},{18.204000473022,-0.53684097528458,0.60000002384186},{4.3749675750732,-12.832932472229,7.2201852798462}}
FLAG["carousel"] = {{5.6063799858093,-13.548299789429,-3.2000000476837},{-5.7499198913574,13.886699676514,-3.2000000476837},{0.033261407166719,0.0034416019916534,-0.85620224475861}}
FLAG["chillout"] = {{7.4876899719238,-4.49059009552,2.5},{-7.5086002349854,9.750340461731,0.10000000149012},{1.392117857933,4.7001452445984,3.108856678009}}
FLAG["damnation"] = {{9.6933002471924,-13.340399742126,6.8000001907349},{-12.17884349823,14.982703208923,-0.20000000298023},{-2.0021493434906,-4.3015551567078,3.3999974727631}}
FLAG["dangercanyon"] = {{-12.104507446289,-3.4351840019226,-2.2419033050537},{12.007399559021,-3.4513700008392,-2.2418999671936},{-0.47723594307899,55.331966400146,0.23940123617649}}
FLAG["deathisland"] = {{-26.576030731201,-6.9761986732483,9.6631727218628},{29.843469619751,15.971487045288,8.2952880859375},{-30.282138824463,31.312761306763,16.601940155029}}
FLAG["gephyrophobia"] = {{26.884338378906,-144.71551513672,-16.049139022827},{26.727857589722,0.16621616482735,-16.048349380493},{63.513668060303,-74.088592529297,-1.0624552965164}}
FLAG["hangemhigh"] = {{13.047902107239,9.0331249237061,-3.3619771003723},{32.655700683594,-16.497299194336,-1.7000000476837},{21.020147323608,-4.6323413848877,-4.2290902137756}}
FLAG["icefields"] = {{24.85000038147,-22.110000610352,2.1110000610352},{-77.860000610352,86.550003051758,2.1110000610352},{-26.032163619995,32.365093231201,9.0070295333862}}
FLAG["infinity"] = {{0.67973816394806,-164.56719970703,15.039022445679},{-1.8581243753433,47.779975891113,11.791272163391},{9.6316251754761,-64.030670166016,7.7762198448181}}
FLAG["longest"] = {{-12.791899681091,-21.6422996521,-0.40000000596046},{11.034700393677,-7.5875601768494,-0.40000000596046},{-0.80207985639572,-14.566205024719,0.16665624082088}}
FLAG["prisoner"] = {{-9.3684597015381,-4.9481601715088,5.6999998092651},{9.3676500320435,5.1193399429321,5.6999998092651},{0.90271377563477,0.088873945176601,1.392499089241}}
FLAG["putput"] = {{-18.89049911499,-20.186100006104,1.1000000238419},{34.865299224854,-28.194700241089,0.10000000149012},{-2.3500289916992,-21.121452331543,0.90232092142105}}
FLAG["ratrace"] = {{-4.2277698516846,-0.85564690828323,-0.40000000596046},{18.613000869751,-22.652599334717,-3.4000000953674},{8.6629104614258,-11.159770965576,0.2217468470335}}
FLAG["sidewinder"] = {{-32.038200378418,-42.066699981689,-3.7000000476837},{30.351499557495,-46.108001708984,-3.7000000476837},{2.0510597229004,55.220195770264,-2.8019363880157}}
FLAG["timberland"] = {{17.322099685669,-52.365001678467,-17.751399993896},{-16.329900741577,52.360000610352,-17.741399765015},{1.2504668235779,-1.4873152971268,-21.264007568359}}
FLAG["wizard"] = {{-9.2459697723389,9.3335800170898,-2.5999999046326},{9.1828498840332,-9.1805400848389,-2.5999999046326},{-5.035900592804,-5.0643291473389,-2.7504394054413}}

function OnNewGame(map)
	FLAG_id = gettagid("weap","weapons\\flag\\flag")
	map_name = tostring(map)
	if CTF_ENABLED == true then
		SPAWN_FLAG()
	end
end

function SPAWN_FLAG()
	local t = FLAG[map_name][3]
	FLAG_objId = createobject(FLAG_id, 0, 11, false, t[1],t[2],t[3])
end

function CTF_Score(player)
	Current_FlagHolder = nil
	SPAWN_FLAG()
end

function check_loc (id,count,objId)
	if getobject(objId) ~= nil then
	local player = objectidtoplayer(objId)
		if Current_FlagHolder then
			if tonumber(player) == tonumber(Current_FlagHolder) and inSphere(objId, FLAG[map_name][1][1], FLAG[map_name][1][2], FLAG[map_name][1][3], Check_Radius) == true or inSphere(objId, FLAG[map_name][2][1], FLAG[map_name][2][2], FLAG[map_name][2][3], Check_Radius) == true then
				CTF_Score(player)
			end
		end
	else
		return 0
	end
	return 1
end

function OnPlayerSpawn(player)
	if getplayer(player) then
		if Spawn_Where_Killed == true then
			if Death_Loc[player][1] ~= nil and Death_Loc[player][2] ~= nil then
				movobjectcoords(getplayerobjectid(player), Death_Loc[player][1], Death_Loc[player][2], Death_Loc[player][3])
				for i = 1,3 do
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
	registertimer(Check_Time,"check_loc",objId)
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

function OnObjectInteraction(player, objId, mapId)
	for i=0,#Equipment_Tags do
		if mapId == Equipment_Tags[i] then
			if mapId == doublespeed_id or mapId == full_spec_id then
				registertimer(500,"delaydestroyobject", objId)
				if mapId == doublespeed_id then
					applyspeed(player)
				else

				end
				return 0
			end
			return 1
		end
	end
	if objId == FLAG_objId then
		Current_FlagHolder = player
		FlagBall_Weapon[player] = weapid
		for i =0,15 do
			if getplayer(i) then
			writeword(getplayer(player) + 0x88, Current_FlagHolder)
			end
		end
		sendconsoletext(Current_FlagHolder, "Return the Flag to a base to gain a Level!")
		if getplayer(player) == nil then return false end
		say("{"..tostring(player).."}  has the Flag! Kill him!", false)
		return 1
	end
	if mapId ~= Level[players[player][1]][10] then
		return 0
	end
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
						for  i=0,15 do
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
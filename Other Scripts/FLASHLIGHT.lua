function OnClientUpdate(player)

	local m_player = getplayer(player)
	if m_player then
		local objId = readdword(m_player, 0x34)
		local m_object = getobject(objId)
		if m_object then
			local melee_key = readbit(m_object, 0x208, 0)
			local action_key = readbit(m_object, 0x208, 1)
			local flashlight_key = readbit(m_object, 0x208, 3)
			local jump_key = readbit(m_object, 0x208, 6)
			local crouch_key = readbit(m_object, 0x208, 7)
			local right_mouse = readbit(m_object, 0x209, 3)
			if melee_key or action_key or flashlight_key or jump_key or crouch_key or right_mouse then
				afk[player].time = -1
				afk[player].boolean = false
			end
		end
	end
end


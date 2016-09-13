function MainTimer(id, count)
	for i = 0,15 do
		if getplayer(i) ~= nil and getobject(i) ~= nil then
			local m_playerObjId = getplayerobjectid(i)
			if m_playerObjId ~= 0xFFFFFFFF then
				for j = 1,2 do
					if player_in_sphere(portal[j][1], portal[j][2], portal[j][3], portal[j][4], i) then
						movobjcoords(m_playerObjId, portal[7][1], portal[7][2], portal[7][3])
					elseif player_in_sphere(portal[j+2][1], portal[j+2][2], portal[j+2][3], portal[j+2][4], i) then
						movobjcoords(m_playerObjId, portal[8][1], portal[8][2], portal[8][3])
					end
				end
				if player_in_sphere(portal[5][1], portal[5][2], portal[5][3], portal[5][4], i) then
					movobjcoords(m_playerObjId, portal[9][1], portal[9][2], portal[9][3])
				elseif player_in_sphere(portal[6][1], portal[6][2], portal[6][3], portal[6][4], i) then
					movobjcoords(m_playerObjId, portal[10][1], portal[10][2], portal[10][3])
				end
			end
		end
	end
	for i = 1,#packs do
		if getobject(packs[i][1]) == nil then
			packs[i][1] = createobject("eqip", "powerups\\health pack", 0, 60, false, packs[i][2], packs[i][3], packs[i][4])
		end
	end
	return 1
end

function object_in_sphere(X, Y, Z, R, m_objectId)
	Pass = false
	if getobject(m_objectId) ~= nil then
		local x,y,z = getobjectcoords(m_objectId)
		if (X - x)^2 + (Y - y)^2 + (Z - z)^2 <= R then
            Pass = true
        end
    end
    return Pass
end

function set_weapon(player)
    local vbool = false
    if isinvehicle(player) then
        vbool = true
        vehicle_Id = getplayervehicleid(player)
        exitvehicle(player)
        registertimer(500, "delay_destroyveh", vehicle_Id)
    end
    if level[players[player][1]][11] == 1 then
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
                flagball_weap[player] = nil
                if vbool == true then
                    local x, y, z = getobjectcoords(vehicle_Id)
                    local vechid = createobject(level[players[player][1]][10], 0, 0, false, x, y, z + 0.5)
                    entervehicle(player, vechid, 0)
                else
                    local x, y, z = getobjectcoords(m_objectId)
                    local vechid = createobject(level[players[player][1]][10], 0, 0, false, x, y, z + 0.5)
                    entervehicle(player, vechid, 0)
                end
            end
        end
    else
        -- remove current weps
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
                flagball_weap[player] = nil
                -- spawn new wep
                local x, y, z = getobjectcoords(getplayerobjectid(player))
                local weapid = createobject(level[players[player][1]][10], m_objectId, 10, false, x + 1, y, z + 2)
                local m_weapon = getobject(weapid)
                if m_weapon then
                    local unloaded_ammo = readdword(m_weapon + 0x2B6)
                    local loaded_ammo = readdword(m_weapon + 0x2B8)
                    if tonumber(unloaded_ammo) and tonumber(level[players[player][1]][6]) then
                        writedword(m_weapon + 0x2B6, tonumber(unloaded_ammo * level[players[player][1]][6]))
                        updateammo(weapid)
                    end
                end
                -- assign wep to player
                assignweapon(player, weapid)
            end
            -- write nades
            local nades_tbl = level[players[player][1]][5]
            if nades_tbl then
                writebyte(m_object, 0x31E, nades_tbl[2])
                -- frags
                writebyte(m_object, 0x31F, nades_tbl[1])
                -- plasmas
            end
        end
    end
end

--[[
------------------------------------
Description: HPC Assign Weapons-Ammo, Phasor V2+
Copyright © 2016-2017 Jericho Crosby
* Author: Jericho Crosby
* IGN: Chalwk
* Written and Created by Jericho Crosby
-----------------------------------
]]--

function OnPlayerSpawnEnd(player, m_objectId)
    if map_name == "beavercreek"
        or map_name == "bloodgulch"
        or map_name == "ratrace"
        or map_name == "timberland"
        or map_name == "wizard" then
        if getplayer(player) then
            local m_objectId = getplayerobjectid(player)
            local m_object = getobject(m_objectId)
            local ammo = 4
            -- edit backpack ammo amount
            local clip = 3
            -- edit clip/magazine amount
            if m_objectId then
                for i = 0, 3 do
                    local weapID = readdword(getobject(m_objectId), 0x2F8 + i * 4)
                    if weapID ~= 0xFFFFFFFF then
                        destroyobject(weapID)
                    end
                end
                if m_object then
                    writebyte(m_object, 0x31E, 4)
                    -- frags
                    writebyte(m_object, 0x31F, 4)
                    -- stickies
                end
                local m_weaponId = createobject(gettagid("weap", "weapons\\sniper rifle\\sniper rifle"), 0, 10, false, 0, 0, 0)
                assignweapon(player, m_weaponId)
                local m_weapon = getobject(m_weaponId)
                if m_weapon then
                    writeword(m_weapon + 0x2B6, ammo)
                    writeword(m_weapon + 0x2B8, clip)
                    updateammo(m_weaponId)
                end
            end
        end
    end
end

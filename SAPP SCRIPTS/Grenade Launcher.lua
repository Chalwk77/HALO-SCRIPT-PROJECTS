--[[
------------------------------------
Script Name: Grenade Launcher, for SAPP | (PC\CE)
    - Implementing API version: 1.10.0.0

    Description: When you fire your pistol, this script will change the Pistol Bullet projectile and turn it into a greande.
                 You can change the Grenade Velocity and Distance on lines 23 and 24.
                
This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"

VELOCITY = 0.5 -- Velocity to launch projectile
DISTANCE = 0.4 -- Distance from player to spawn projectile

function OnScriptLoad()
    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
end


function OnScriptUnload() end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID) 
    if MapID == get_tag_info("proj", "weapons\\pistol\\bullet") then
        timer(0, "ChangeProjectile", ObjectID, ParentID)
        return false
    end	
end

function ChangeProjectile(PlayerIndex, ObjectID, ParentID)
    local player_object = get_dynamic_player(PlayerIndex)
    if player_object ~= nil then
        local m_objectId = get_object_memory(ObjectID)
        if m_objectId ~= nil then
            local X_Aim = read_float(m_objectId, 0x230)
            local Y_aim = read_float(m_objectId, 0x234)
            local Z_aim = read_float(m_objectId, 0x238)
            local x = read_float(m_objectId, 0x5C)
            local y = read_float(m_objectId, 0x60)
            local z = read_float(m_objectId, 0x64)
            local ProjX = x + DISTANCE * math.sin(X_Aim)
            local ProjY = y + DISTANCE * math.sin(Y_aim)
            local ProjZ = z + DISTANCE * math.sin(Z_aim) + 0.5
            local nade_proj = spawn_object("proj", "weapons\\frag grenade\\frag grenade", ProjX, ProjY, ProjZ)
            local weapon_proj = get_object_memory(nade_proj)
            if weapon_proj then
                write_float(weapon_proj + 0x68, VELOCITY * math.sin(X_Aim))
                write_float(weapon_proj + 0x6C, VELOCITY * math.sin(Y_aim))
                write_float(weapon_proj + 0x70, VELOCITY * math.sin(Z_aim))
            end
            -- cprint("ProjX: " .. ProjX .. ", " .. "ProjY: " .. ProjY .. ", " .. "ProjZ: " .. ProjZ .. "", 2+8)
        end
    end
end

function get_tag_info(tagclass, tagname)
    local tagarray = read_dword(0x40440000)
    for i = 0, read_word(0x4044000C) -1 do
        local tag = tagarray + i * 0x20
        local class = string.reverse(string.sub(read_string(tag), 1, 4))
        if (class == tagclass) then
            if (read_string(read_dword(tag + 0x10)) == tagname) then
                return read_dword(tag + 0xC)
            end
        end
    end
    return nil
end

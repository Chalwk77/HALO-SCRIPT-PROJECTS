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

function get_tag_info(obj_type, obj_name)
	local tag_id = lookup_tag(obj_type, obj_name)
	return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end	

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID) 
    if MapID == get_tag_info("proj", "weapons\\pistol\\bullet") then
        timer(0, "HandleProjectile", PlayerIndex, ParentID)
        return false
    end	
end

function HandleProjectile(PlayerIndex)
    ChangeProjectile(PlayerIndex)
end

function ChangeProjectile(PlayerIndex)
    local m_object = get_dynamic_player(PlayerIndex)
    if (m_object ~= 0) then
        local WeaponID = get_object_memory(read_dword(m_object + 0x2F8))
        local X_Aim = read_float(WeaponID, 0x230)
        local Y_aim = read_float(WeaponID, 0x234)
        local Z_aim = read_float(WeaponID, 0x238)
        local x = read_float(WeaponID, 0x5C)
        local y = read_float(WeaponID, 0x60)
        local z = read_float(WeaponID, 0x64)
        local ProjX = x + DISTANCE * math.sin(X_Aim)
        local ProjY = y + DISTANCE * math.sin(Y_aim)
        local ProjZ = z + DISTANCE * math.sin(Z_aim) + 0.5
        local projId = spawn_object("proj", "weapons\\frag grenade\\frag grenade", ProjX, ProjY, ProjZ)
        local WeaponObj = get_object_memory(projId)
        if WeaponObj then
            write_float(WeaponObj, 0x68, tonumber(VELOCITY) * math.sin(X_Aim))
            write_float(WeaponObj, 0x6C, tonumber(VELOCITY) * math.sin(Y_aim))
            write_float(WeaponObj, 0x70, tonumber(VELOCITY) * math.sin(Z_aim))
        end
    end
end

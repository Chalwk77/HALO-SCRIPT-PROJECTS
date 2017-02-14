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

velocity = 0.5 -- Velocity to launch projectile
distance = 0.4 -- Distance from player to spawn projectile

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
        NewProjectile = get_tag_info("proj", "weapons\\frag grenade\\frag grenade")
        timer(0, "Change_Projectile", ParentID)
        return false
    end	
end

function Change_Projectile(PlayerIndex)
    ChangeProjectile(PlayerIndex)
end

function ChangeProjectile(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local m_weaponId = read_dword(player_object + 0x118)
        local x_aim = read_float(m_weaponId, 0x230)
        local y_aim = read_float(m_weaponId, 0x234)
        local z_aim = read_float(m_weaponId, 0x238)
        local x = read_float(m_weaponId, 0x5C)
        local y = read_float(m_weaponId, 0x60)
        local z = read_float(m_weaponId, 0x64)
        local projx = x + distance * math.sin(x_aim)
        local projy = y + distance * math.sin(y_aim)
        local projz = z + distance * math.sin(z_aim) + 0.5
        local projId = spawn_object(m_weaponId, projx, projy, projz)
        local WeaponObj = get_object_memory(projId)
        if WeaponObj then
            cprint("WeaponObj appears to be valid", 2+8)
            cprint("Writing projectile velocity...", 2+8)
            write_float(WeaponObj, 0x68, tonumber(velocity) * math.sin(x_aim))
            write_float(WeaponObj, 0x6C, tonumber(velocity) * math.sin(y_aim))
            write_float(WeaponObj, 0x70, tonumber(velocity) * math.sin(z_aim))
        end
    end
end

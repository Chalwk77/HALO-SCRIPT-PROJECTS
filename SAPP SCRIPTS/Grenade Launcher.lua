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

function Change_Projectile(NewProjectile)
    ChangeProjectile(NewProjectile)
end

function ChangeProjectile(PlayerIndex)
    local PlayerObj = get_dynamic_player(PlayerIndex)
    local projectile = get_object_memory(read_dword(PlayerObj + 0x2F8))
    local x_aim = read_float(projectile, 0x230)
    local y_aim = read_float(projectile, 0x234)
    local z_aim = read_float(projectile, 0x238)
    local x = read_float(projectile, 0x5C)
    local y = read_float(projectile, 0x60)
    local z = read_float(projectile, 0x64)
    local projx = x + distance * math.sin(x_aim)
    local projy = y + distance * math.sin(y_aim)
    local projz = z + distance * math.sin(z_aim) + 0.5
    local projId = spawn_object(NewProjectile, projx, projy, projz)
    local WeaponObj = get_object_memory(tonumber(projId))
    if WeaponObj then
        write_float(WeaponObj, 0x68, tonumber(velocity) * math.sin(x_aim))
        write_float(WeaponObj, 0x6C, tonumber(velocity) * math.sin(y_aim))
        write_float(WeaponObj, 0x70, tonumber(velocity) * math.sin(z_aim))
    end
end

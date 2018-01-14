--[[
--=====================================================================================================--
Script Name: Grenade Launcher, for SAPP (PC & CE)
                
Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

velocity = 1 -- velocity to launch projectile
distance = 1 -- distance from player to spawn projectile

function OnScriptLoad()
    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
end

function OnScriptUnload() end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID) 
    if MapID == TagInfo("proj", "weapons\\pistol\\bullet") then
        return true, ChangeProjectile(PlayerIndex, ParentID)
    end
end

function ChangeProjectile(PlayerIndex, ParentID)
    if get_dynamic_player(PlayerIndex) ~= nil then
        local object_id = get_object_memory(ParentID)
        if object_id ~= nil then
        
            local x_aim = read_float(object_id + 0x230)
            local y_aim = read_float(object_id + 0x234)
            local z_aim = read_float(object_id + 0x238)

            local x = read_float(object_id + 0x5C)
            local y = read_float(object_id + 0x60)
            local z = read_float(object_id + 0x64)
            
            local proj_x = x + distance * math.sin(x_aim)
            local proj_y = y + distance * math.sin(y_aim)
            local proj_z = z + distance * math.sin(z_aim) + 0.5
            
            local frag_frenage = spawn_object("proj", "weapons\\frag grenade\\frag grenade", proj_x, proj_y, proj_z)
            local frag_projectile = get_object_memory(frag_frenage)
            
            if frag_projectile then
                write_float(frag_projectile + 0x68, velocity * math.sin(x_aim))
                write_float(frag_projectile + 0x6C, velocity * math.sin(y_aim))
                write_float(frag_projectile + 0x70, velocity * math.sin(z_aim))
            end
        end
    end
end

function TagInfo(obj_type, obj_name)
    local tag_id = lookup_tag(obj_type, obj_name)
    return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end

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

-- configuration starts --
-- default projectile
projectile_type = "weapons\\frag grenade\\frag grenade"

-- velocity to launch projectile
default_velocity = 0.6
-- distance from player to spawn projectile
default_distance = 0.5

-- minimum admin level required to execute cucsotm commands
command_permission_level = 1

-- command to enable the grenade launcher       Syntax: /launcher on|off|1|2|true|false
enable_launcher_command = "launcher"
-- command to change velocity and distance.     Syntax: /lvd [velocity] [distance]
change_vd_command = "lvd"
-- command to change projectile type.           Syntax: /nadetype frag|plasma|1|2
change_projectile_type = "nadetype"
-- configuration ends --

-- do not touch --
values_specified = { }
launcher_mode = {}

function OnScriptLoad()
    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload() end

function OnPlayerJoin(PlayerIndex)
    values_specified[PlayerIndex] = false
    launcher_mode[PlayerIndex] = false
end

function OnServerCommand(PlayerIndex, Command, Environment)
    local UnknownCMD = nil
    local t = tokenizestring(Command)
    if t[1] == string.lower(enable_launcher_command) then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= command_permission_level then
            if t[2] ~= nil then
                if t[2] == string.lower("1") or t[2] == string.lower("on") or t[2] == string.lower("true") then
                    launcher_mode[PlayerIndex] = true
                    rprint(PlayerIndex, "Grenade Launcher Activated")
                    UnknownCMD = false
                elseif t[2] == string.lower("0") or t[2] == string.lower("off") or t[2] == string.lower("false") then
                    launcher_mode[PlayerIndex] = false
                    rprint(PlayerIndex, "Grenade Launcher Deactivated")
                    UnknownCMD = false
                end
            else
                rprint(PlayerIndex, "Invalid Syntax! Type: /" .. enable_launcher_command .. " on|off|1|2|true|false")
                UnknownCMD = false
            end
        else
            rprint(PlayerIndex, "You do not have permission to execute that command")
            UnknownCMD = false
        end
    elseif t[1] == string.lower(change_vd_command) then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= command_permission_level then
            if t[2] ~= nil and t[3] ~= nil then
                if string.match(t[2], "%d+") and string.match(t[3], "%d+") then
                    values_specified[PlayerIndex] = true
                    new_velocity = tonumber(t[2])
                    new_distance = tonumber(t[3])
                    rprint(PlayerIndex, "Velocity set to: " .. t[2] .. "    Distance set to: " .. t[3])
                    UnknownCMD = false
                end
            else
                rprint(PlayerIndex, "Invalid Syntax! Type: /" .. change_vd_command .. " [velocity] [distance]")
                UnknownCMD = false
            end
        else
            rprint(PlayerIndex, "You do not have permission to execute that command")
            UnknownCMD = false
        end
    elseif t[1] == string.lower(change_projectile_type) then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= command_permission_level then
            if t[2] ~= nil then
                if t[2] == string.lower("frag") or t[2] == string.lower("1") then
                    projectile_type = "weapons\\frag grenade\\frag grenade"
                    rprint(PlayerIndex, "Now shooting Frag Grenades")
                    UnknownCMD = false
                elseif t[2] == string.lower("plasma") or t[2] == string.lower("2") then
                    projectile_type = "weapons\\plasma grenade\\plasma grenade"
                    rprint(PlayerIndex, "Now shooting Plasma Grenades")
                    UnknownCMD = false
                end
            else
                rprint(PlayerIndex, "Invalid Syntax! Type /" .. change_projectile_type .. " frag|plasma|1|2")
                UnknownCMD = false
            end
        else
            rprint(PlayerIndex, "You do not have permission to execute that command")
            UnknownCMD = false
        end
    end
    return UnknownCMD
end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    if (launcher_mode[PlayerIndex] == true) then
        if MapID == TagInfo("proj", "weapons\\pistol\\bullet") 
            or MapID == TagInfo("proj", "weapons\\assault rifle\\bullet") then
            return false, ChangeProjectile(PlayerIndex, ParentID)
        end
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
            
            if not (values_specified[PlayerIndex]) then
                proj_x = x + default_distance * math.sin(x_aim)
                proj_y = y + default_distance * math.sin(y_aim)
                proj_z = z + default_distance * math.sin(z_aim) + 0.5
            else
                proj_x = x + new_distance * math.sin(x_aim)
                proj_y = y + new_distance * math.sin(y_aim)
                proj_z = z + new_distance * math.sin(z_aim) + 0.5
            end

            local tag_id = TagInfo("proj", projectile_type)
            local frag_projectile = spawn_projectile(tag_id, PlayerIndex, proj_x, proj_y, proj_z)
            local frag = get_object_memory(frag_projectile)
            
            if frag then
                if not (values_specified[PlayerIndex]) then
                    write_float(frag + 0x68, default_velocity * math.sin(x_aim))
                    write_float(frag + 0x6C, default_velocity * math.sin(y_aim))
                    write_float(frag + 0x70, default_velocity * math.sin(z_aim))
                else
                    write_float(frag + 0x68, new_velocity * math.sin(x_aim))
                    write_float(frag + 0x6C, new_velocity * math.sin(y_aim))
                    write_float(frag + 0x70, new_velocity * math.sin(z_aim))
                end
            end
        end
    end
end

function TagInfo(obj_type, obj_name)
    local tag_id = lookup_tag(obj_type, obj_name)
    return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { }; i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end


-- valid projectiles
-- "weapons\\plasma grenade\\plasma grenade"
-- "weapons\\frag grenade\\frag grenade"

-- "vehicles\\banshee\\banshee bolt"
-- "vehicles\\banshee\\mp_banshee fuel rod"
-- "vehicles\\c gun turret\\mp gun turret"
-- "vehicles\\ghost\\ghost bolt"
-- "vehicles\\scorpion\\bullet"
-- "vehicles\\scorpion\\tank shell"
-- "vehicles\\warthog\\bullet"

-- "weapons\\assault rifle\\bullet"
-- "weapons\\flamethrower\\flame"
-- "weapons\\needler\\mp_needle"
-- "weapons\\pistol\\bullet"
-- "weapons\\plasma pistol\\bolt"
-- "weapons\\plasma rifle\\bolt"
-- "weapons\\plasma rifle\\charged bolt"
-- "weapons\\rocket launcher\\rocket"
-- "weapons\\shotgun\\pellet"
-- "weapons\\sniper rifle\\sniper bullet"
-- "weapons\\plasma_cannon\\plasma_cannon"    

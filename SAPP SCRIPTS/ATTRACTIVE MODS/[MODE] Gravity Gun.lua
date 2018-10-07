--[[
--=====================================================================================================--
Script Name: [MODE] Gravity Gun, for SAPP (PC & CE)

Pick up vehicles!
To activate Gravity Gun Mode, Type /ggun on (/ggun off to disable)
Aim at a vehicle, fire your "pistol" to pick up the vehicle. Fire again to launch the vehicle away!

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Created by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

api_version = '1.12.0.0'

command1, command2 = "gravitygun", "ggun"
ggun_type, ggun_name = "proj", "weapons\\pistol\\bullet"
permission_level = 1

vehicles = {}
vehicles[1] = { "vehi", "vehicles\\warthog\\mp_warthog", "Warthog"}
vehicles[2] = { "vehi", "vehicles\\ghost\\ghost_mp", "Ghost"}
vehicles[3] = { "vehi", "vehicles\\rwarthog\\rwarthog", "RocketHog"}
vehicles[4] = { "vehi", "vehicles\\banshee\\banshee_mp", "Banshee"}
vehicles[5] = { "vehi", "vehicles\\scorpion\\scorpion_mp", "Tank"}
vehicles[6] = { "vehi", "vehicles\\c gun turret\\c gun turret_mp", "Turret"}

gravity_mode = {}
weapon_status = {}
holding_object = {}
bool = {}
function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_TICK'], "OnTick")
end

function OnScriptUnload()

end

function OnPlayerSpawn(PlayerIndex)
    gravity_mode[PlayerIndex] = false
    weapon_status[PlayerIndex] = 0
    holding_object[PlayerIndex] = false
    bool[PlayerIndex] = true
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            if player_alive(i) then
                if (gravity_mode[i] == true) then
                    local success, target = false, nil
                    local player_object = get_dynamic_player(i)
                    local playerX, playerY, playerZ = read_float(player_object + 0x230), read_float(player_object + 0x234), read_float(player_object + 0x238)
                    local shot_fired
                    local couching = read_float(player_object + 0x50C)
                    local px, py, pz = read_vector3d(player_object + 0x5c)
                    if (couching == 0) then
                        pz = pz + 0.65
                    else
                        pz = pz + (0.35 * couching)
                    end
                    local ignore_player = read_dword(get_player(i) + 0x34)
                    local success, a, b, c, target = intersect(px, py, pz, playerX * 1000, playerY * 1000, playerZ * 1000, ignore_player)
                    if (success == true and target ~= 0xFFFFFFFF) then
                        target_object = get_object_memory(target)
                        shot_fired = read_float(player_object + 0x490)
                        if(shot_fired ~= weapon_status[i] and shot_fired == 1 and bool[i] == true) then
                            holding_object[i] = true
                            bool[i] = false
                        end
                        weapon_status[i] = shot_fired
                    end
                    if (holding_object[i] == true) then
                        write_bit(target_object + 0x10, 5, 0)
                        local distance = 5
                        local playerXAim, playerYAim, playerZAim = read_float(player_object + 0x230), read_float(player_object + 0x234), read_float(player_object + 0x238)
                        local playerXCoord, playerYCoord, playerZCoord = read_float(player_object + 0x5C), read_float(player_object + 0x60), read_float(player_object + 0x64)

                        write_float(target_object + 0x5C, playerXCoord + distance * math.sin(playerXAim))
                        write_float(target_object + 0x60, playerYCoord + distance * math.sin(playerYAim))
                        write_float(target_object + 0x64, playerZCoord + distance * math.sin(playerZAim) + 0.5)

                        write_float(target_object + 0x68, 0)
                        write_float(target_object + 0x6C, 0)
                        write_float(target_object + 0x70, 0.01285)
                        write_float(target_object + 0x90, 0.15)
                        write_float(target_object + 0x8C, 0.15)
                        write_float(target_object + 0x94, 0.15)
                    end
                    if (holding_object[i] == false and bool[i] == false) then
                        bool[i] = true
                        local velocity = 35
                        write_float(target_object + 0x5C, read_float(player_object + 0x5C) + velocity * math.sin(read_float(player_object + 0x230)))
                        write_float(target_object + 0x60, read_float(player_object + 0x60) + velocity * math.sin(read_float(player_object + 0x234)))
                        write_float(target_object + 0x64, read_float(player_object + 0x64) + velocity * math.sin(read_float(player_object + 0x238)))
                    end
                end
            end
        end
    end
end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    if (holding_object[PlayerIndex] == true) then
        if MapID == TagInfo(ggun_type, ggun_name) then
            holding_object[PlayerIndex] = false
        end
    end
end

function OnServerCommand(PlayerIndex, Command)
    local UnknownCMD = nil
    local t = tokenizestring(Command)
    if t[1] ~= nil then
        if (t[1] == string.lower(command1) or t[1] == string.lower(command2)) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                if t[2] ~= nil then
                    if t[2] == "on" or t[2] == "1" or t[2] == "true" then
                        gravity_mode[PlayerIndex] = true
                        rprint(PlayerIndex, "Gravity Gun mode enabled")
                        UnknownCMD = false
                    elseif t[2] == "off" or t[2] == "0" or t[2] == "false" then
                        gravity_mode[PlayerIndex] = false
                        rprint(PlayerIndex, "Gravity Gun mode disabled")
                        UnknownCMD = false
                    end
                else
                    rprint(PlayerIndex, "Invalid Syntax")
                    UnknownCMD = false
                end
            else
                rprint(PlayerIndex, "You do not have permission to execute that command!")
                UnknownCMD = false
            end
        end
        return UnknownCMD
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
for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    t[i] = str
    i = i + 1
end
return t
end

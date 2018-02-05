--[[
--=====================================================================================================--
Script Name: Pistol Entry, for SAPP (PC & CE)

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Created by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

api_version = '1.12.0.0'

vehicles = {}
vehicles[1] = { "vehi", "vehicles\\warthog\\mp_warthog", "Warthog"}
vehicles[2] = { "vehi", "vehicles\\ghost\\ghost_mp", "Ghost"}
vehicles[3] = { "vehi", "vehicles\\rwarthog\\rwarthog", "RocketHog"}
vehicles[4] = { "vehi", "vehicles\\banshee\\banshee_mp", "Banshee"}
vehicles[5] = { "vehi", "vehicles\\scorpion\\scorpion_mp", "Tank"}
vehicles[6] = { "vehi", "vehicles\\c gun turret\\c gun turret_mp", "Turret"}

weapon_status = {}
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
end

function OnScriptUnload()

end

function OnPlayerSpawn(PlayerIndex)
    weapon_status[PlayerIndex] = 0
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
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
            local success, v1, v1, v3, target = intersect(px, py, pz, playerX * 1000, playerY * 1000, playerZ * 1000, ignore_player)
            if (success == true and target ~= nil) then
                local object_id = read_dword(get_object_memory(target))
                for k, v in pairs(vehicles) do
                    if object_id == TagInfo(tostring(v[1]), tostring(v[2])) then
                        shot_fired = read_float(player_object + 0x490)
                        if(shot_fired ~= weapon_status[i] and shot_fired == 1) then
                            enter_vehicle(target, i, 0)
                            rprint(i, "Entering " .. v[3])
                            break
                        end
                        weapon_status[i] = shot_fired
                    end
                end
            end
        end
    end
end

function TagInfo(obj_type, obj_name)
    local tag_id = lookup_tag(obj_type, obj_name)
    return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end

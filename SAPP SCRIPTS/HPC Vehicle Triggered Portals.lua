--[[
------------------------------------
Script Name: Vehicle Triggered Portals (PC/CE), for SAPP
    - Implementing API version: 1.10.0.0

Description: Jump into the passengers seat of the warthog located at X,Y,Z and it will teleport you to X location.

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
------------------------------------
]]--

api_version = "1.10.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_VEHICLE_ENTER'], "OnVehicleEntry")
    if get_var(0, "$gt") ~= "n/a" then
        mapname = get_var(0, "$map")
    end
end

function OnScriptUnload() end

function OnNewGame(map)
    mapname = get_var(0, "$map")
end

function OnVehicleEntry(PlayerIndex, Seat)
    if player_alive(PlayerIndex) then
        if (mapname == "bloodgulch") then
            local player_object = get_dynamic_player(PlayerIndex)
            if (player_object ~= 0) then
                if inSphere(PlayerIndex, 86.79, -172.32, 0.53, 5) == true then
                    local PlayerObj = get_dynamic_player(PlayerIndex)
                    local VehicleObj = get_object_memory(read_dword(PlayerObj + 0x11c))
                    local MetaIndex = read_dword(VehicleObj)
                    if MetaIndex == 0xE3D40260 then
                        if Seat == "1" then
                            local player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
                            local vehicleId = read_dword(player_object + 0x11C)
                            local m_vehicle = get_object_memory(vehicleId)
                            player_obj_id = vehicleId
                            moveobject(vehicleId, 122.482, -176.335, 4.695 + 0.15)
                            timer(1000*0.50, "exitvehicle", PlayerIndex)
                            execute_command("msg_prefix \"\"")
                            say(PlayerIndex, "[VTP] Teleporting!")
                            execute_command("msg_prefix \"** SERVER ** \"")
                        end
                    end
                end
            end
        end
    end
end

function exitvehicle(PlayerIndex)
    exit_vehicle(PlayerIndex)
end

function moveobject(ObjectID, x, y, z)
    local object = get_object_memory(ObjectID)
    if get_object_memory(ObjectID) ~= 0 then
        local veh_obj = get_object_memory(read_dword(object + 0x11C))
        write_vector3d((veh_obj ~= 0 and veh_obj or object) + 0x5C, x, y, z)
    end
end

function inSphere(PlayerIndex, x, y, z, radius)
    if PlayerIndex then
        local player_static = get_player(PlayerIndex)
        local obj_x = read_float(player_static + 0xF8)
        local obj_y = read_float(player_static + 0xFC)
        local obj_z = read_float(player_static + 0x100)
        local x_diff = x - obj_x
        local y_diff = y - obj_y
        local z_diff = z - obj_z
        local dist_from_center = math.sqrt(x_diff ^ 2 + y_diff ^ 2 + z_diff ^ 2)
        if dist_from_center <= radius then
            return true
        end
    end
    return false
end

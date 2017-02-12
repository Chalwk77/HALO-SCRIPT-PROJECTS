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
-----------------------------------
]]--

api_version = "1.10.0.0"
gamesettings = {
    ["DestroyVehicle"] = false,
}
-- X,Y,Z,Radius (From Coordinates)
TeleportFrom = {}
TeleportFrom[1] = { 86.79, -172.32, 0.53, 5 }   -- Chain gun Hog (beside redbase)
TeleportFrom[2] = { 64.16, 176.91, 4.48, 5 }    -- Chain gun Hog (far right-hand corner of redbase <slope>)
TeleportFrom[3] = { 28.85, -90.83, 0.84, 5}     -- Chain gun Hog, Left side of Blue Base
TeleportFrom[4] = { 46.17, -64.97, 1.64, 5}     -- Chain gun Hog, Behind Blue Base

-- X,Y,Z (To Coordinates)
TeleportTo = { }
TeleportTo[1] = { 82.05, -163.83, 0.11 }
TeleportTo[2] = { 96.83, -150.45, 0.07 }
TeleportTo[3] = { 83.08, -131, 0.37 }
TeleportTo[4] = { 56.18, -133.71, 1.13 }
TeleportTo[5] = { 58.76, -122.98, 0.28 }
TeleportTo[6] = { 78.11, -120.07, 0.22 }
TeleportTo[7] = { 87.22, -99.72, 1.51 }
TeleportTo[8] = { 70.55, -137.45, 1.02 }
TeleportTo[9] = { 91.62, -128.01, 1.02 }
TeleportTo[10] = { 83.66, -146.55, 0.02 }

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
    player_object = get_dynamic_player(PlayerIndex)
    VehicleObj = get_object_memory(read_dword(player_object + 0x11c))
    MetaIndex = read_dword(VehicleObj)
    player_obj_id = read_dword(get_player(PlayerIndex) + 0x34)
    vehicleId = read_dword(player_object + 0x11C)
    local coordinates = SelectRandomPortal()
    if player_alive(PlayerIndex) then
        if (mapname == "bloodgulch") then
            if (player_object ~= 0) then
                if inSphere(PlayerIndex, TeleportFrom[1][1], TeleportFrom[1][2], TeleportFrom[1][3], TeleportFrom[1][4]) == true then
                    if MetaIndex == 0xE3D40260 then
                        if Seat == "1" then
                            player_obj_id = vehicleId
                            if coordinates then
                                moveobject(vehicleId, TeleportTo[coordinates][1], TeleportTo[coordinates][2], TeleportTo[coordinates][3] + 0.32)
                                timer(1000*0.955, "exitvehicle", PlayerIndex)
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
end

function Destroyvehicle(PlayerIndex, VehicleObj)
    if not PlayerInVehicle(PlayerIndex) then
        destroy_object(vehicleId)
    end
end

function exitvehicle(PlayerIndex)
    exit_vehicle(PlayerIndex)
    if gamesettings["DestroyVehicle"] then
        timer(1000*1, "Destroyvehicle", PlayerIndex)
    end
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

function SelectRandomPortal()
    if #TeleportTo > 0 then
        local index = rand(1, #TeleportTo + 1)
        local coord = TeleportTo[index]
        return index
    end
    return nil
end

function PlayerInVehicle(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local VehicleID = read_dword(player_object + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

function OnError(Message)
    print(debug.traceback())
end     

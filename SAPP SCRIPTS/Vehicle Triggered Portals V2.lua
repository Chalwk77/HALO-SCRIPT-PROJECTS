--[[
Script Name: Vehicle Triggered Portals V2, for SAPP - (PC|CE)

Description: Jump into the passengers seat of a warthog or rocket-hog located at X,Y,Z and it will teleport you to X location.
See REMARKS at the bottom of the script if you're having trouble configuring.

This is a re-write of version 1. 
Similar concept except this version does away with choosing a random teleport to go to.
This version is also a lot more user friendly in the way of configuring. 

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
]]--

api_version = "1.11.0.0"
coordiantes = { }
gamesettings = {
    -- Removes the vehicle once exited.
    -- Note, once removed, they will not respawn!
    ["DestroyVehicle"] = true,
}

--          Vehicle ID                            from x,y,z             radius           to x,y,z                height      Seat
coordiantes["bloodgulch"] = {
    { "vehicles\\rwarthog\\rwarthog",         33.631, -65.569, 0.370,         5,      108.474, -109.085, 2.032,       0.1,        1},
    { "vehicles\\rwarthog\\rwarthog",         41.703, -128.663, 0.247,        5,      63.874, -82.054, 0.830,         0.1,        1},
    { "vehicles\\rwarthog\\rwarthog",         50.655, -87.787, 0.079,         5,      78.136, -131.176, 0.095,        0.1,        1},
    { "vehicles\\rwarthog\\rwarthog",         101.940, -170.440, 0.197,       5,      51.114, -137.351, 0.686,        0.1,        1},
    { "vehicles\\rwarthog\\rwarthog",         81.617, -116.049, 0.486,        5,      33.066, -83.425, -0.017,        0.1,        1},
    { "vehicles\\rwarthog\\rwarthog",         78.208, -152.914, 0.091,        5,      69.677, -97.071, 1.635,         0.1,        1},
    { "vehicles\\warthog\\mp_warthog",        64.178, -176.802, 3.960,        5,      49.697, -123.671, -0.094,       0.1,        1},
    { "vehicles\\warthog\\mp_warthog",        102.312, -144.626, 0.580,       5,      97.611, -94.770, 4.379,         0.1,        1},
    { "vehicles\\warthog\\mp_warthog",        86.825, -172.542, 0.215,        5,      98.662, -113.261, 4.201,        0.1,        1},
    { "vehicles\\warthog\\mp_warthog",        65.846, -70.301, 1.690,         5,      48.019, -118.214, 0.332,        0.1,        1},
    { "vehicles\\warthog\\mp_warthog",        28.861, -90.757, 0.303,         5,      73.953, -103.604, 4.042,        0.1,        1},
    { "vehicles\\warthog\\mp_warthog",        46.341, -64.700, 1.113,         5,      111.826, -139.331, 0.311,       0.1,        1},
}

-- To add other maps, repeat the structure above. 
-- Where    x,y,z|radius|x,y,z|height|seat    is located in the table, replace with data as seen above.
coordiantes["mapname"] = {
    { "vehicle_tag_id",     x,y,z,      radius,     x,y,z,      height,     seat},
}

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_VEHICLE_ENTER'], "OnVehicleEntry")
end

function OnScriptUnload() end

function OnNewGame()
    mapname = get_var(0, "$map")
end

function OnVehicleEntry(PlayerIndex, Seat)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local VehicleObject = get_object_memory(read_dword(player_object + 0x11c))
        local seat = read_word(player_object + 0x2F0)
        local vehicleId = read_dword(player_object + 0x11C)
        for j = 1, #coordiantes[mapname] do
            if VehicleTagID(VehicleObject) == coordiantes[mapname][j][1] then
                if seat == coordiantes[mapname][j][10] then
                    if coordiantes[mapname] ~= { } and coordiantes[mapname][j] ~= nil then
                        if inSphere(PlayerIndex, coordiantes[mapname][j][2], coordiantes[mapname][j][3], coordiantes[mapname][j][4], coordiantes[mapname][j][5]) == true then
                            TeleportPlayer(vehicleId, coordiantes[mapname][j][6], coordiantes[mapname][j][7], coordiantes[mapname][j][8] + coordiantes[mapname][j][9])
                            timer(1000*0.955, "exitvehicle", PlayerIndex, vehicleId)
                        end
                    end
                end
            end
        end
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

function TeleportPlayer(ObjectID, x, y, z)
    local object = get_object_memory(ObjectID)
    if get_object_memory(ObjectID) ~= 0 then
        local veh_obj = get_object_memory(read_dword(object + 0x11C))
        write_vector3d((veh_obj ~= 0 and veh_obj or object) + 0x5C, x, y, z + 0.3)
    end
end

function exitvehicle(PlayerIndex, vehicleId)
    exit_vehicle(PlayerIndex)
    if gamesettings["DestroyVehicle"] then
        timer(1000*1.5, "Destroyvehicle", PlayerIndex, vehicleId)
    end
end

function Destroyvehicle(PlayerIndex, vehicleId)
    local player_object = get_dynamic_player(PlayerIndex)
    local VehicleID = read_dword(player_object + 0x11C)
    if VehicleID == 0xFFFFFFFF then
        destroy_object(vehicleId)
    end
end

function VehicleTagID(VehicleObject)
	if VehicleObject ~= nil and VehicleObject ~= 0 then
		return read_string(read_dword(read_word(VehicleObject) * 32 + 0x40440038))
	else
		return ""
	end
end

function OnError(Message)
    print(debug.traceback())
end
--[[
    -- ===== REMARKS ===== --


    -- SEATS --
     Warthog:
     Seat 0 = Drivers Seat
     Seat 1 = Passengers Seat
     Seat 2 = Gunners Seat

     Rocket Hog:
     Seat 0 = Drivers Seat
     Seat 1 = Passengers Seat
     Seat 2 = Gunners Seat

     Ghost, Banshee and Turret:
     Seat 0 = Drivers Seat

     Scorpion Tank
     Seat 0 = Drivers Seat
     Seat 1 - 5 = Passengers Seat
     
     
     
     -- VEHICLE ID --
    "vehicles\\warthog\\mp_warthog"
    "vehicles\\ghost\\ghost_mp"
    "vehicles\\rwarthog\\rwarthog"
    "vehicles\\banshee\\banshee_mp"
    "vehicles\\scorpion\\scorpion_mp"
    "vehicles\\c gun turret\\c gun turret_mp"
     
     
     
    -- VEHICLE COORDINATES --
                    X Coord   Y Coord   Z Coord   radius
    Example:        33.631,   -65.569,   0.370,     5
     
     
     
    -- HEIGHT (#) --
    Sometimes your vehicle will become stuck in the ground upon teleporting. 
    We can compensate for this by adding additional HEIGHT to the vectors.
    Height = number of meters to spawn above the ground on teleport.
]]
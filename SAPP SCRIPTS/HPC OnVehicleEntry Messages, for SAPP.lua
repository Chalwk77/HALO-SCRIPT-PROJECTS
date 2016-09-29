--[[
------------------------------------
Script Name: HPC OnVehicleEntry Messages, SAPP
    - Implementing API version: 1.11.0.0

Description: This script will print Vehicle Name and Seat positions (to console)
when a player enters a vehicle.

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

--      Warthog:
--      Seat 0 = Drivers Seat
--      Seat 1 = Passengers Seat
--      Seat 2 = Gunners Seat

--      Rocket Hog:
--      Seat 0 = Drivers Seat
--      Seat 1 = Passengers Seat
--      Seat 2 = Gunners Seat

--      Ghost, Banshee and Turret:
--      Seat 0 = Drivers Seat

--      Scorpion Tank
--      Seat 0 = Drivers Seat
--      Seat 1 - 5 = Passengers Seat

api_version = "1.11.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_VEHICLE_ENTER'], "OnVehicleEnter")
end

function OnScriptUnload() end

function OnVehicleEnter(PlayerIndex, Seat)

    local PlayerObj = get_dynamic_player(PlayerIndex)
    local VehicleObj = get_object_memory(read_dword(PlayerObj + 0x11c))
    local MetaIndex = read_dword(VehicleObj)
    local name = get_var(PlayerIndex, "$name")

    if MetaIndex == 0xE3D40260 then
        Vehicle_Name = "Warthog"
        if Seat == "0" then
            Seat_Position = "Drivers Seat"
        elseif Seat == "1" then
            Seat_Position = "Passengers Seat"
        elseif Seat == "2" then
            Seat_Position = "Gunners Seat"
        end
    end

    if MetaIndex == 0xE5050391 then
        Vehicle_Name = "Rocket Hog"
        if Seat == "0" then
            Seat_Position = "Drivers Seat"
        elseif Seat == "1" then
            Seat_Position = "Passengers Seat"
        elseif Seat == "2" then
            Seat_Position = "Gunners Seat"
        end
    end

    if MetaIndex == 0xE45702E3 then
        Vehicle_Name = "Scorpion Tank"
        if Seat == "0" then
            Seat_Position = "Drivers Seat"
        elseif Seat == "1" then
            Seat_Position = "Passengers Seat"
        elseif Seat == "2" then
            Seat_Position = "Passengers Seat"
        elseif Seat == "3" then
            Seat_Position = "Passengers Seat"
        elseif Seat == "4" then
            Seat_Position = "Passengers Seat"
        end
    end

    if MetaIndex == 0xE4B70343 then
        Vehicle_Name = "Ghost"
        if Seat == "0" then
            Seat_Position = "Drivers Seat"
        end
    end

    if MetaIndex == 0xE54003CC then
        Vehicle_Name = "Banshee"
        if Seat == "0" then
            Seat_Position = "Drivers Seat"
        end
    end
    cprint(name .. " entered the " .. tostring(Seat_Position) .. " of a " .. tostring(Vehicle_Name))
end

function OnError(Message)
    print(debug.traceback())
end
--[[
------------------------------------
Script Name: HPC OnVehicleEntry Messages, SAPP
    - Implementing API version: 1.11.0.0

Description: This script will print your Vehicle Name and Seat position - (see optional settings on line 42)

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

[!] Change Log:
    - Added Turret 

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

--[[
    
Set color of console (0-255). Setting to 0 is white over black. !
0 - Black, 1 - Blue, 2 - Green, 3 - Cyan, 4 - Red
5 - Magenta, 6 - Gold, 7 - White. !
Add 8 to make text bold. !
Add 16 x Color to set background color.
    
]]

-- Console only -- 
OutputColor = 2+8 -- Blue

settings = {
    ["LogToServerConsole"] = true,
    ["ShowInGameConsole"] = true,
    ["ShowInGameChat"] = false,
    ["SappLog"] = true,
}

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
        if Seat == "0" then -- Drivers Seat
    -- You don't drive a banshee, you fly it.
            Seat_Position = "Pilots Seat"
        end
    end
    
    if MetaIndex == 0xE86906F5 then
        Vehicle_Name = "Turret"
        if Seat == "0" then -- Drivers Seat 
    -- It's weird to me to say that PlayerX entered the 'drivers' seat of a turret - It's not something you drive.
    -- 'Operators Seat' could also pass, but not drivers seat - that's just weird!
            Seat_Position = "Gunners Seat"
        end
    end
    if settings["LogToServerConsole"] then
        cprint(name .. " entered the " .. tostring(Seat_Position) .. " of a " .. tostring(Vehicle_Name), OutputColor)
    end
    if settings["ShowInGameChat"] then
        execute_command("msg_prefix \"\"")
        say(PlayerIndex, tostring(Vehicle_Name) .. " - " .. tostring(Seat_Position))
        execute_command("msg_prefix \"**SERVER** \"")
    end
    if settings["ShowInGameConsole"] then
        rprint(PlayerIndex, "|c" .. tostring(Vehicle_Name) .. " - " .. tostring(Seat_Position))
    end
    if settings["SappLog"] then
        local Log = string.format("\n[VEHICLE ENTRY]: " .. name .. " entered the " .. tostring(Seat_Position) .. " of a " .. tostring(Vehicle_Name) .. "\n")
        execute_command("log_note \""..Log.."\"")
    end
end

function OnError(Message)
    print(debug.traceback())
end

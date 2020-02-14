--[[
--======================================================================================================--
Script Name: Uber, for SAPP (PC & CE)
Description: N/A

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

api_version = "1.12.0.0"
local uber = {

    -- Configuration Starts --
    command = "uber",
    calls_per_game = 5,
    messages = {
        [1] = "There are no Ubers available right now",
        [2] = "You are already in a vehicle!",
        [3] = { -- on vehicle entry
            "Driver: %name%",
            "Gunner: %name%",
            "Passenger: %name%"
        },
    }
    -- Configuration Ends --
}

local lower, upper = string.lower, string.upper

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
end

function OnServerCommand(Executor, Command, _, _)
    local Cmd = CmdSplit(Command)
    if (#Cmd == 0) then
        return
    else
        Cmd[1] = lower(Cmd[1]) or upper(Cmd[1])
        if (Cmd[1] == uber.command) then
            if (Executor ~= 0) then
                if (not uber:isInVehicle(Executor)) then
                    local available_vehicles = uber:isavailable(Executor)
                    local gunner_seats_available, passenger_seats_available = {}, {}
                    for k, vehicle in pairs(available_vehicles) do
                        if (k) then

                            if (vehicle.gunner) then
                                gunner_seats_available[#gunner_seats_available + 1] = {
                                    vehicle = vehicle.vehicle
                                }
                            end
                            if (vehicle.passenger) then
                                passenger_seats_available[#passenger_seats_available + 1] = {
                                    vehicle = vehicle.vehicle
                                }
                            end

                            math.randomseed(os.time())
                            if (#gunner_seats_available > 0) then
                                local vehicle = gunner_seats_available[math.random(1, #gunner_seats_available)]
                                uber:InsertPlayer(vehicle.vehicle, Executor, 2)
                            elseif (#passenger_seats_available > 0) then
                                local vehicle = passenger_seats_available[math.random(1, #passenger_seats_available)]
                                uber:InsertPlayer(vehicle.vehicle, Executor, 1)
                            else
                                rprint(Executor, uber.messages[1])
                            end
                        else
                            rprint(Executor, uber.messages[1])
                        end
                    end
                else
                    rprint(Executor, uber.messages[2])
                end
            else
                cprint("This command can only be executed by a player", 4 + 8)
            end
            return false
        end
    end
end

function uber:isavailable(PlayerIndex)
    local vehicles, names = {}, {}
    for i = 1, 16 do
        if player_present(i) and player_alive(i) and (i ~= PlayerIndex) then
            local same_team = (get_var(i, "$team") == get_var(PlayerIndex, "$team"))
            if (same_team) then
                local CurrentVehicle, VehicleObjectMemory = uber:isInVehicle(i)
                if (VehicleObjectMemory ~= 0 and VehicleObjectMemory ~= nil) then

                    local driver = read_dword(VehicleObjectMemory + 0x324)
                    if (driver ~= 0xFFFFFFFF) then
                        print(get_var(i, "$name"))
                        local gunner = read_dword(VehicleObjectMemory + 0x328)
                        local passenger = read_dword(VehicleObjectMemory + 0x32C)

                        vehicles[VehicleObjectMemory] = {
                            gunner = (gunner == 0xFFFFFFFF or gunner == 0),
                            passenger = (passenger == 0xFFFFFFFF or passenger == 0),
                            vehicle = CurrentVehicle,
                        }
                    end
                end
            end
        end
    end
    return vehicles
end

function uber:InsertPlayer(Player, Vehicle, Seat)
    enter_vehicle(Player, Vehicle, Seat)
end

function uber:isInVehicle(PlayerIndex)
    local dynamic_player = get_dynamic_player(PlayerIndex)
    local CurrentVehicle = read_dword(dynamic_player + 0x11C)
    local VehicleObjectMemory = get_object_memory(CurrentVehicle)
    if (CurrentVehicle ~= 0xFFFFFFFF) then
        return CurrentVehicle, VehicleObjectMemory
    end
    return false
end

function CmdSplit(Command)
    local t, i = {}, 1
    for Args in Command:gmatch("([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

function OnScriptUnload()
    -- N/A
end
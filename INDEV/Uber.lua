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

-- TODO: Auto Eject passengers and gunners if no driver
-- TODO: ... other stuff

api_version = "1.12.0.0"
local uber = {

    -- Configuration Starts --
    command = "uber",
    calls_per_game = 100,
    crouch_to_uber = true,
    messages = {
        [1] = "There are no Ubers available right now",
        [2] = "You are already in a vehicle!",
        [3] = "You have used up your Uber Calls for this game!",
        [4] = "Please wait until you respawn.",
        [5] = { -- on vehicle entry
            "Driver: %name%",
            "Gunner: %name%",
            "Passenger: %name%"
        },
    }
    -- Configuration Ends --
}

local lower, upper = string.lower, string.upper
local players, vehicles = {}

function OnScriptLoad()
    register_callback(cb["EVENT_CHAT"], "OnServerChat")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb['EVENT_VEHICLE_EXIT'], "OnVehicleExit")
    register_callback(cb['EVENT_VEHICLE_ENTER'], "OnVehicleEntry")

    if (uber.crouch_to_uber) then
        register_callback(cb["EVENT_TICK"], "OnTick")
    end

    if (get_var(0, "$gt") ~= "n/a") then
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, true)
            end
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function OnPlayerDisconnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            local dynamic_player = get_dynamic_player(i)
            if (dynamic_player ~= 0) then
                local crouching = read_float(dynamic_player + 0x50C)
                if (not uber:isInVehicle(i)) and (crouching > 0) then
                    uber:CheckVehicles(i)
                end
            end
        end
    end
end

function OnServerChat(Executor, Message, Type)
    local Str = StrSplit(Message)
    if (#Str == 0) then
        return
    elseif (Type ~= 6) then
        Str[1] = lower(Str[1]) or upper(Str[1])
        if (Str[1] == uber.command) then
            if (Executor ~= 0) then
                if player_alive(Executor) then
                    if (players[Executor].calls > 0) then
                        players[Executor].calls = players[Executor].calls - 1
                        if (not uber:isInVehicle(Executor)) then
                            uber:CheckVehicles(Executor)
                        else
                            rprint(Executor, uber.messages[2])
                        end
                    else
                        rprint(Executor, uber.messages[3])
                    end
                else
                    rprint(Executor, uber.messages[4])
                end
            else
                cprint("This command can only be executed by a player", 4 + 8)
            end
            return false
        end
    end
end

function uber:CheckVehicles(Executor)
    local gunner_seats_available, passenger_seats_available = {}, {}
    for k, vehicle in pairs(vehicles) do
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
                local Vehicle = gunner_seats_available[math.random(1, #gunner_seats_available)]
                uber:InsertPlayer(Vehicle, Executor, 2)
                vehicles[k].gunner = false
            elseif (#passenger_seats_available > 0) then
                local Vehicle = passenger_seats_available[math.random(1, #passenger_seats_available)]
                uber:InsertPlayer(Vehicle, Executor, 1)
                vehicles[k].passenger = false
            else
                cls(Executor, 25)
                rprint(Executor, uber.messages[1])
            end
        else
            cls(Executor, 25)
            rprint(Executor, uber.messages[1])
        end
    end
end

function uber:InsertPlayer(Vehicle, Player, Seat, names)
    enter_vehicle(Vehicle.vehicle, Player, Seat)
end

function OnVehicleEntry(PlayerIndex)
    CheckSeats(PlayerIndex, false)
end

function OnVehicleExit(PlayerIndex)
    CheckSeats(PlayerIndex, true)
end

function CheckSeats(PlayerIndex, Type)
    local dynamic_player = get_dynamic_player(PlayerIndex)
    if (dynamic_player ~= 0) then
        vehicles = vehicles or {}
        local CurrentVehicle = read_dword(dynamic_player + 0x11C)
        local VehicleObjectMemory = get_object_memory(CurrentVehicle)
        if (CurrentVehicle ~= 0xFFFFFFFF) then
            local seat = read_word(dynamic_player + 0x2F0)

            local previous_state = vehicles[VehicleObjectMemory]
            previous_state = previous_state or { driver = false, gunner = true, passenger = true }

            if (seat == 0) then
                vehicles[VehicleObjectMemory] = {
                    driver = Type,
                    vehicle = CurrentVehicle,
                    gunner = previous_state.gunner,
                    passenger = previous_state.passenger
                }
            elseif (seat == 1) then
                vehicles[VehicleObjectMemory] = {
                    passenger = Type,
                    vehicle = CurrentVehicle,
                    gunner = previous_state.gunner,
                    driver = previous_state.driver
                }
            elseif (seat == 2) then
                vehicles[VehicleObjectMemory] = {
                    gunner = Type,
                    vehicle = CurrentVehicle,
                    driver = previous_state.driver,
                    passenger = previous_state.passenger
                }
            end
        end
    end
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

function StrSplit(Str)
    local t, i = {}, 1
    for Args in Str:gmatch("([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

function InitPlayer(PlayerIndex, Init)
    if (Init) then
        players[PlayerIndex] = {
            calls = uber.calls_per_game
        }
    else
        players[PlayerIndex] = {}
    end
end

function cls(PlayerIndex, Count)
    for _ = 1, Count do
        rprint(PlayerIndex, " ")
    end
end

function OnScriptUnload()
    -- N/A
end
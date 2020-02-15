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
    crouch_to_uber = false,
    messages = {
        [1] = "There are no Ubers available right now",
        [2] = "You are already in a vehicle!",
        [3] = "You have used up your Uber Calls for this game!",
        [4] = "Please wait until you respawn.",
        [5] = { -- on vehicle entry
            "Driver: %dname%",
            "Gunner: %gname%",
            "Passenger: %pname%"
        },
    }
    -- Configuration Ends --
}

local lower, upper, gsub = string.lower, string.upper, string.gsub
local players, vehicles = {}

function OnScriptLoad()
    register_callback(cb["EVENT_CHAT"], "OnServerChat")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb['EVENT_VEHICLE_EXIT'], "OnVehicleExit")
    register_callback(cb['EVENT_VEHICLE_ENTER'], "OnVehicleEntry")

    if (uber.crouch_to_uber) then
        register_callback(cb["EVENT_TICK"], "OnTick")
        register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
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
    CheckForReset(true)
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            local dynamic_player = get_dynamic_player(i)
            if (dynamic_player ~= 0) then
                if not uber:isInVehicle(i) then
                    local crouching = read_float(dynamic_player + 0x50C)
                    if (crouching ~= players.crouch_state and crouching > 0) then
                        uber:CheckVehicles(i)
                    end
                    players.crouch_state = crouching
                end
            end
        end
    end
end

function OnPlayerSpawn(PlayerIndex)
    players[PlayerIndex].crouch_state = 0
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
    local Error
    local g_seats, p_seats = {}, {}
    if (vehicles ~= nil) then
        for k, v in pairs(vehicles) do
            if (k) then
                local team = get_var(Executor, "$team")

                if (team == v.team and v.driver) then

                    if (v.gunner) then
                        g_seats[#g_seats + 1] = { vehicle = v.vehicle }
                    end
                    if (v.passenger) then
                        p_seats[#p_seats + 1] = { vehicle = v.vehicle }
                    end
                end

                math.randomseed(os.time())
                if (#g_seats > 0) then
                    local Vehicle = g_seats[math.random(1, #g_seats)]
                    v.g_name = get_var(Executor, "$name")
                    uber:InsertPlayer(Vehicle, Executor, 2, v)
                elseif (#p_seats > 0) then
                    local Vehicle = p_seats[math.random(1, #p_seats)]
                    v.p_name = get_var(Executor, "$name")
                    uber:InsertPlayer(Vehicle, Executor, 1, v)
                else
                    Error = true
                end
            end
        end
    else
        Error = true
    end
    if (Error) then
        cls(Executor, 25)
        rprint(Executor, uber.messages[1])
    end
end

function uber:InsertPlayer(Vehicle, PlayerIndex, Seat, Tab)
    enter_vehicle(Vehicle.vehicle, PlayerIndex, Seat)
end

function OnVehicleEntry(PlayerIndex)
    CheckSeats(PlayerIndex, "enter")
end

function OnVehicleExit(PlayerIndex)
    CheckSeats(PlayerIndex, "exit")
end

function CheckSeats(PlayerIndex, Type)
    local dynamic_player = get_dynamic_player(PlayerIndex)
    if (dynamic_player ~= 0) then
        vehicles = vehicles or {}
        local CurrentVehicle = read_dword(dynamic_player + 0x11C)
        local VehicleObjectMemory = get_object_memory(CurrentVehicle)
        if (VehicleObjectMemory ~= 0) then
            if (CurrentVehicle ~= 0xFFFFFFFF) then
                local seat = read_word(dynamic_player + 0x2F0)
                local team = get_var(PlayerIndex, "$team")
                local previous_state = vehicles[VehicleObjectMemory]

                previous_state = previous_state or { -- table index is nil, create new:
                    driver = false, gunner = true, passenger = true,
                    d_name = "N/A", g_name = "N/A", p_name = "N/A",
                }
                if (seat == 0) then

                    if (Type == "exit") then
                        Type = false
                    else
                        Type = true
                    end

                    -- driver
                    vehicles[VehicleObjectMemory] = {
                        team = team,
                        d_name = get_var(PlayerIndex, "$name"),
                        g_name = previous_state.g_name,
                        p_name = previous_state.p_name,

                        driver = Type,
                        vehicle = CurrentVehicle,
                        gunner = previous_state.gunner,
                        passenger = previous_state.passenger
                    }
                elseif (seat == 1) then

                    if (Type == "exit") then
                        Type = true
                    else
                        Type = false
                    end

                    -- passenger
                    vehicles[VehicleObjectMemory] = {
                        team = team,
                        d_name = previous_state.d_name,
                        g_name = previous_state.g_name,
                        p_name = get_var(PlayerIndex, "$name"),

                        passenger = Type,
                        vehicle = CurrentVehicle,
                        gunner = previous_state.gunner,
                        driver = previous_state.driver
                    }
                elseif (seat == 2) then

                    if (Type == "exit") then
                        Type = true
                    else
                        Type = false
                    end

                    -- gunner
                    vehicles[VehicleObjectMemory] = {
                        team = team,
                        d_name = previous_state.d_name,
                        g_name = get_var(PlayerIndex, "$name"),
                        p_name = previous_state.p_name,

                        gunner = Type,
                        vehicle = CurrentVehicle,
                        driver = previous_state.driver,
                        passenger = previous_state.passenger
                    }
                end
                local t, msg = vehicles[VehicleObjectMemory], ""
                for i = 1, #uber.messages[5] do
                    msg = gsub(gsub(gsub(uber.messages[5][i],
                            "%%dname%%", t.d_name),
                            "%%gname%%", t.g_name),
                            "%%pname%%", t.p_name)
                    rprint(PlayerIndex, msg)
                end
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

function CheckForReset(exit)
    if (vehicles ~= nil) then
        for k, v in pairs(vehicles) do
            if (k) then
                local count = 0

                local driver = read_dword(k + 0x324)
                local gunner = read_dword(k + 0x328)
                local passenger = read_dword(k + 0x32C)

                if (driver == 0xFFFFFFFF or driver == 0) then
                    count = count + 1
                    v.team, v.driver, v.d_name = "", false, "N/A"
                end
                if (gunner == 0xFFFFFFFF or passenger == 0) then
                    count = count + 1
                    v.team, v.gunner, v.g_name = "", true, "N/A"
                end
                if (passenger == 0xFFFFFFFF or passenger == 0) then
                    count = count + 1
                    v.team, v.passenger, v.p_name = "", true, "N/A"
                end

                if (exit and count == 3) then
                    k = nil
                end
            end
        end
    end
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
            crouch_state = 0,
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
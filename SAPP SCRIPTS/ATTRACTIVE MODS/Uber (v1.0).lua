--[[
--======================================================================================================--
Script Name: Uber (v1.0), for SAPP (PC & CE)
Description: Inject yourself into a teammates vehicle by typing "uber".

             This script will scan all available vehicles that are occupied by teammates.
             The first scan checks available gunner seats. If one is available, you will enter into it.
             If no gunner seats are available, the script will then scan for available passenger seats and insert you into one.
             If neither gunner or passenger seats are vacant the script will send you an error.

            Features:
            (all features are configurable)
            * Custom "keywords", i.e, "uber", "taxi"
            * Limit uber calls per game (10 by default)
            * Crouch to call an uber (on by default)
            * Auto Ejector: Vehicle occupants without a driver will be ejected after X seconds (on by default)
            * Customizable messages
            * Works on most custom maps

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

api_version = "1.12.0.0"
local uber = {

    -- Configuration Starts --
    command = { "uber", "taxi", "cab" },

    -- Maximum number of uber calls per game:
    calls_per_game = 20,

    -- If true, players holding the flag or oddball will not be able to call an uber.
    block_objective = true,

    -- If true, players will be able to call an uber by crouching
    crouch_to_uber = true,

    -- If true, Vehicle Occupants without a driver will be ejected
    eject_players_without_driver = true,
    -- Vehicle Occupants without a driver will be ejected after this amount of time (in seconds)
    ejection_period = 5,

    -- Custom Message
    messages = {
        [1] = "There are no Ubers available right now",
        [2] = "You are already in a vehicle!",
        [3] = "You have used up your Uber calls for this game!",
        [4] = "Please wait until you respawn.",
        [5] = "[No Driver] You will be ejected in %seconds% seconds.",
        [6] = "You cannot call an uber while holding the objective",
        [7] = { --< on vehicle entry
            "--- UBER ---",
            "Driver: %dname%",
            "Gunner: %gname%",
            "Passenger: %pname%",
            "Uber Calls remaining: %remaining%"
        }
    }
    -- Configuration Ends --
}

local time_scale = 0.03333333333333333
local lower, upper, gsub = string.lower, string.upper, string.gsub
local players, vehicles = {}

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb["EVENT_CHAT"], "OnServerChat")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb['EVENT_VEHICLE_EXIT'], "OnVehicleExit")
    register_callback(cb['EVENT_VEHICLE_ENTER'], "OnVehicleEntry")
    if (get_var(0, "$gt") ~= "n/a") then
        players, vehicles = {}, {}
        for i = 1, 16 do
            if player_present(i) then
                uber:InitPlayer(i, true)
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        players, vehicles = {}, {}
    end
end

function OnPlayerConnect(PlayerIndex)
    uber:InitPlayer(PlayerIndex, true)
end

function OnPlayerDisconnect(PlayerIndex)
    uber:InitPlayer(PlayerIndex, false)
    CheckSeats(PlayerIndex, true)
end

function OnPlayerDeath(PlayerIndex)
    CheckSeats(PlayerIndex, true)
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            local dynamic_player = get_dynamic_player(i)
            if (dynamic_player ~= 0) then
                local CurrentVehicle, VehicleObjectMemory = uber:isInVehicle(i)
                if (uber.crouch_to_uber) then
                    if not (CurrentVehicle) then

                        local crouching = read_float(dynamic_player + 0x50C)
                        if (crouching ~= players[i].crouch_state and crouching > 0) then
                            if (players[i].calls > 0) then
                                uber:CheckVehicles(i)
                            else
                                cls(i, 25)
                                rprint(i, uber.messages[3])
                            end
                            players[i].crouch_state = crouching
                        end
                    end
                end
                if (uber.eject_players_without_driver) then
                    if (CurrentVehicle) then
                        local driver = read_dword(VehicleObjectMemory + 0x324)
                        if (not players[i].eject) then
                            if (driver == 0xFFFFFFFF or driver == 0) then
                                players[i].eject = true
                                local ejection_warning_message = gsub(uber.messages[5], "%%seconds%%", uber.ejection_period)
                                rprint(i, ejection_warning_message)
                            end
                        elseif (players[i].eject) and (driver ~= 0xFFFFFFFF) then
                            players[i].eject = false
                            players[i].eject_timer = 0
                        else
                            players[i].eject_timer = players[i].eject_timer + time_scale
                            if (players[i].eject_timer >= uber.ejection_period) then
                                exit_vehicle(i)
                                players[i].eject = false
                                players[i].eject_timer = 0
                                CheckSeats(i, true)
                            end
                        end
                    elseif (players[i].eject) then
                        players[i].eject = false
                        players[i].eject_timer = 0
                    end
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
        for i = 1, #uber.command do
            if (Str[1] == uber.command[i]) then
                if (Executor ~= 0) then
                    if player_alive(Executor) then
                        if (players[Executor].calls > 0) then
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
end

function uber:CheckVehicles(Executor)
    if (not uber.block_objective) or (uber.block_objective and not uber:HasObjective(Executor)) then
        local count = 0
        local team = get_var(Executor, "$team")
        for _, v in pairs(vehicles) do
            if (v.driver and v.team == team) then
                count = count + 1
                if (v.gunner) then
                    v.gunner = false
                    uber:InsertPlayer(v.vehicle, Executor, 2)
                    break
                elseif (v.passenger) then
                    v.passenger = false
                    uber:InsertPlayer(v.vehicle, Executor, 1)
                    break
                else
                    count = 0
                end
            end
        end
        if (count == 0) then
            cls(Executor, 25)
            rprint(Executor, uber.messages[1])
        end
    end
end

function uber:InsertPlayer(Vehicle, PlayerIndex, Seat)
    players[PlayerIndex].calls = players[PlayerIndex].calls - 1
    enter_vehicle(Vehicle, PlayerIndex, Seat)
end

function OnVehicleEntry(PlayerIndex)
    CheckSeats(PlayerIndex, false, true)
end

function OnVehicleExit(PlayerIndex)
    CheckSeats(PlayerIndex, true)
    players[PlayerIndex].eject = false
    players[PlayerIndex].eject_timer = 0
end

local SetTeam = function(State, Vehicle)
    if (State) then
        if (Vehicle.driver) then
            return Vehicle.team
        else
            return "N/A"
        end
    elseif (Vehicle.driver) then
        return Vehicle.team
    else
        return "N/A"
    end
end

function CheckSeats(PlayerIndex, State, Enter)

    local dynamic_player = get_dynamic_player(PlayerIndex)
    if (dynamic_player ~= 0) then
        local CurrentVehicle = read_dword(dynamic_player + 0x11C)
        local VehicleObjectMemory = get_object_memory(CurrentVehicle)
        if (VehicleObjectMemory ~= 0) then
            if (CurrentVehicle ~= 0xFFFFFFFF) then

                local team = get_var(PlayerIndex, "$team")
                local name = get_var(PlayerIndex, "$name")

                local seat = read_word(dynamic_player + 0x2F0)
                local previous_state = vehicles[VehicleObjectMemory]

                local valid = uber:ValidateVehicle(VehicleObjectMemory)
                if (valid) then
                    previous_state = previous_state or { -- table index is nil, create new:
                        driver = false, gunner = true, passenger = true,
                        d_name = "N/A", g_name = "N/A", p_name = "N/A",
                        team = "N/A"
                    }

                    if (seat == 0) then
                        if (not State) then
                            State = true
                        else
                            team = "N/A"
                            State = false
                        end
                        -- driver
                        vehicles[VehicleObjectMemory] = {
                            d_name = name,
                            g_name = previous_state.g_name,
                            p_name = previous_state.p_name,
                            team = team,

                            driver = State, -- true if occupied
                            vehicle = CurrentVehicle,
                            gunner = previous_state.gunner,
                            passenger = previous_state.passenger
                        }
                    elseif (seat == 1) then

                        -- passenger
                        vehicles[VehicleObjectMemory] = {
                            team = SetTeam(State, previous_state),
                            d_name = previous_state.d_name,
                            g_name = previous_state.g_name,
                            p_name = name,

                            passenger = State, -- false if occupied
                            vehicle = CurrentVehicle,
                            gunner = previous_state.gunner,
                            driver = previous_state.driver
                        }
                    elseif (seat == 2) then
                        -- gunner
                        vehicles[VehicleObjectMemory] = {
                            team = SetTeam(State, previous_state),
                            d_name = previous_state.d_name,
                            g_name = name,
                            p_name = previous_state.p_name,

                            gunner = State, -- false if occupied
                            vehicle = CurrentVehicle,
                            driver = previous_state.driver,
                            passenger = previous_state.passenger
                        }
                    end

                    if (Enter) then
                        cls(PlayerIndex, 25)
                        local t, msg = vehicles[VehicleObjectMemory], ""
                        for i = 1, #uber.messages[7] do
                            msg = gsub(gsub(gsub(gsub(uber.messages[7][i],
                                    "%%dname%%", t.d_name),
                                    "%%gname%%", t.g_name),
                                    "%%pname%%", t.p_name),
                                    "%%remaining%%", players[PlayerIndex].calls)
                            rprint(PlayerIndex, msg)
                        end
                    end
                end
            end
        end
    end
    uber:CheckForReset()
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

function uber:CheckForReset()
    if (vehicles ~= nil) then
        for k, v in pairs(vehicles) do
            if (k) then
                local count = 0
                local driver = read_dword(k + 0x324)
                local gunner = read_dword(k + 0x328)
                local passenger = read_dword(k + 0x32C)
                if (driver == 0xFFFFFFFF or driver == 0) then
                    count, v.d_name, v.team = count + 1, "N/A", "N/A"
                end
                if (gunner == 0xFFFFFFFF or passenger == 0) then
                    count, v.g_name = count + 1, "N/A"
                end
                if (passenger == 0xFFFFFFFF or passenger == 0) then
                    count, v.p_name = count + 1, "N/A"
                end
                if (count == 3) then
                    vehicles[k] = nil
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

function uber:InitPlayer(PlayerIndex, Init)
    if (Init) then
        players[PlayerIndex] = {
            crouch_state = 0,
            calls = uber.calls_per_game,
            eject = false,
            eject_timer = 0
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

function uber:ValidateVehicle(VehicleObjectMemory)
    if (VehicleObjectMemory ~= 0) then
        local vehicle = read_string(read_dword(read_word(VehicleObjectMemory) * 32 + 0x40440038))
        local keywords = { "hog", "hawg", "civi", "vulcan", "puma", "scorpion", "lav" }
        for _, word in pairs(keywords) do
            if (vehicle:find(word)) then
                return true
            end
        end
    end
    return false
end

function uber:HasObjective(PlayerIndex)
    local has_objective
    if (get_var(0, "$gt") == "ctf") or (get_var(0, "$gt") == "oddball") then
        local player_object = get_dynamic_player(PlayerIndex)
        if player_alive(PlayerIndex) then
            for i = 0, 3 do
                local weapon_id = read_dword(player_object + 0x2F8 + 0x4 * i)
                if (weapon_id ~= 0xFFFFFFFF) then
                    local weap_object = get_object_memory(weapon_id)
                    if (weap_object ~= 0) then
                        local tag_address = read_word(weap_object)
                        local tagdata = read_dword(read_dword(0x40440000) + tag_address * 0x20 + 0x14)
                        if (read_bit(tagdata + 0x308, 3) == 1) then
                            has_objective = true
                        end
                    end
                end
            end
        end
    else
        has_objective = false
    end
    if (has_objective) then
        rprint(PlayerIndex, uber.messages[6])
    end
    return has_objective
end

function OnScriptUnload()
    -- N/A
end
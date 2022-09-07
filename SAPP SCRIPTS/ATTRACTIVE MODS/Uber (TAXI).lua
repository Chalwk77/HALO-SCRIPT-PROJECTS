--[[
--=====================================================================================================--
Script Name: Uber, for SAPP (PC & CE)
Description: Inject yourself into a teammates vehicle by saying "uber" in chat.

------------ [ FEATURES ] ------------
- Players are limited to 20 uber calls per game.
- Crouch to call an uber (or say "uber" in chat).
- Players must wait 10 seconds before calling another uber.
- Players are ejected from a vehicle if the driver leaves for more than 5 seconds.
- If no uber is available, the player will be notified.
- Eject players from vehicles with no driver.
- Priority scanning:
  * Configure what vehicle types are scanned for available seats first.
  * Then the seats in that vehicle are scanned in a configurable order too.
  * The first seat that is available will be used.

- [!] NOTE: This mod is designed for STOCK MAPS ONLY and may not work on custom maps.
-------------------------------------------------------------------------------------

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local Uber = {

    -- List of common phrases that can be used to call an uber:
    -- Set the phrase to false to disable it.
    --
    phrases = {
        ['uber'] = true,
        ['taxi'] = true,
        ['cab'] = true,
        ['taxo'] = true,
        ['taxii'] = true,
        ['taxci'] = true,
        ['taci'] = true,
        ['takse'] = true
    },


    -- Players will be inserted into a vehicle in this seat order:
    -- The first seat that is available will be used.
    -- 0 = driver
    -- 1 = passenger
    -- 2 = gunner
    -- 3 = passenger
    -- 4 = passenger
    -- 5 = passenger
    --
    insertion_order = {
        0, 1, 2, 3, 4
    },


    -- List of vehicles that are allowed to be used with Uber:
    -- Format: {'class', 'name', '{seat ids}', enabled/disabled, Vehicle Label, Priority}
    --
    -- Vehicles with a higher priority will be scanned first.
    -- Make sure each vehicle has a unique priority.
    --
    valid_vehicles = {

        { 'vehi', 'vehicles\\rwarthog\\rwarthog', {
            [0] = 'driver',
            [1] = 'passenger',
            [2] = 'gunner'
        }, true, 'Rocket Hog', 3 },

        { 'vehi', 'vehicles\\warthog\\mp_warthog', {
            [0] = 'driver',
            [1] = 'passenger',
            [2] = 'gunner',
        }, true, 'Chain Gun Hog', 2 },

        { 'vehi', 'vehicles\\scorpion\\scorpion_mp', {
            [0] = 'driver',
            [1] = 'passenger',
            [2] = 'passenger',
            [3] = 'passenger',
            [4] = 'passenger'
        }, false, 'Tank', 1 },

        --
        -- Repeat the above format for each vehicle you want to add.
        -- Only add vehicles that have a driver seat (and at least one passenger seat).
        --

    },


    -- Maximum number of uber calls per game:
    -- Default: 20
    --
    calls_per_game = 20,


    -- Prevent players holding the objective from calling an uber:
    -- Default: true
    --
    block_objective = true,


    -- Time (in seconds) before a player is ejected from a vehicle:
    -- Do not set lower than 3.
    -- Default: 3
    --
    block_objective_time = 5,


    -- Players must crouch to call an uber:
    -- Default: true
    --
    crouch_to_uber = true,


    -- Players must wait this many seconds before calling another uber:
    -- Default: true
    --
    cooldown = true,


    -- Time (in seconds) a player must wait before they can call another uber:
    -- Default: 10
    --
    cooldown_period = 10,


    -- Players who enter a vehicle that is disabled in the 'valid_vehicles' table,
    -- will be ejected from the it.
    -- Default: true
    --
    eject_from_disabled_vehicle = true,


    -- Eject players from disabled vehicles after this many seconds:
    -- Do not set lower than 3.
    -- Default: 3
    --
    eject_from_disabled_vehicle_time = 3,


    -- Eject players from vehicles with no driver:
    --
    eject_without_driver = true,


    -- Eject players after this many seconds if there is no driver:
    -- Do not set lower than 3.
    -- Default: 3
    --
    eject_without_driver_time = 5
}

local objective
local players = {}
local vehicles = {}

local time = os.time
local floor = math.floor
local insert = table.insert

api_version = '1.12.0.0'

function OnScriptLoad()

    register_callback(cb['EVENT_CHAT'], 'OnChat')
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
    register_callback(cb['EVENT_VEHICLE_EXIT'], 'OnVehicleExit')
    register_callback(cb['EVENT_VEHICLE_ENTER'], 'OnVehicleEnter')
    OnStart()
end

function OnStart()

    local game_type = get_var(0, '$gt')
    if (game_type ~= 'n/a') then
        objective = (game_type == 'ctf' or game_type == 'oddball') or nil
        players = {}
        vehicles = Uber:TagsToID()
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

local function GetTag(Class, Name)
    local tag = lookup_tag(Class, Name)
    return (tag ~= 0 and read_dword(tag + 0xC)) or nil
end

local function NewVehicle(label, seats, vehicle_id, priority)
    return {
        label = label,
        seats = seats,
        occupants = {},
        priority = priority,
        vehicle_id = vehicle_id
    }
end

local function NewEject(object, delay)
    return {
        object = object or 0,
        start = time,
        finish = time() + delay
    }
end

local function AvailableSeats(seats, seat)

    local t = {}
    for s, _ in pairs(seats) do
        if (s == seat) then
            t[s] = nil
        else
            t[s] = seats[s]
        end
    end

    return t
end

local function HasObjective(dyn)
    for i = 0, 3 do
        local weapon = read_dword(dyn + 0x2F8 + 0x4 * i)
        local object = get_object_memory(weapon)
        if (weapon ~= 0xFFFFFFFF and object ~= 0) then
            local tag_address = read_word(object)
            local tag_data = read_dword(read_dword(0x40440000) + tag_address * 0x20 + 0x14)
            if (read_bit(tag_data + 0x308, 3) == 1) then
                return true
            end
        end
    end
    return false
end

local function InVehicle(dyn)
    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)
    return (vehicle ~= 0xFFFFFFFF and object ~= 0 and true) or false, object, vehicle
end

function Uber:NewPlayer(o)

    setmetatable(o, { __index = self })
    self.__index = self

    o.crouching = 0
    o.calls = self.calls_per_game

    return o
end

function Uber:TagsToID()

    local t = {}

    for i = 1, #self.valid_vehicles do

        local v = self.valid_vehicles[i]
        local class, name = v[1], v[2]
        local seats = v[3]
        local enabled = v[4]
        local label = v[5]
        local priority = v[6]

        local tag = GetTag(class, name)
        if (tag and enabled) then
            t[tag] = {
                label = label,
                seats = seats,
                priority = priority
            }
        end
    end

    return t
end

function Uber:Tell(s, cls)
    if (cls) then
        for _ = 1, 25 do
            rprint(self.id, ' ')
        end
    end
    rprint(self.id, s)
end

function Uber:ValidateVehicle(object)
    object = object or 0
    local meta_id = read_dword(object)
    return vehicles[meta_id] or nil
end

function Uber:DoChecks()
    local cooldown = self.call_cooldown
    local dyn = get_dynamic_player(self.id)
    if (dyn == 0) then
        self:Tell('Something went wrong.', true)
        return false
    elseif not player_alive(self.id) then
        self:Tell('You must be alive to call an uber.', true)
        return false
    elseif (InVehicle(dyn)) then
        self:Tell('You cannot call an uber while in a vehicle.', true)
        return false
    elseif (self.block_objective and objective and HasObjective(dyn)) then
        self:Tell('You cannot insert while carrying an objective.', true)
        return false
    elseif (self.calls <= 0) then
        self:Tell('You have no more uber calls left.', true)
        return false
    elseif (cooldown) then
        local start = cooldown.start
        local finish = cooldown.finish
        local time_remaining = floor(finish - start())
        self:Tell('Please wait ' .. time_remaining .. ' seconds before calling another uber.', true)
        return false
    end
    return true
end

function Uber:GetVehicles()

    local t = { }
    local done = {}
    local index = 0

    for i, v in ipairs(players) do

        local alive = player_alive(i)
        local dyn = get_dynamic_player(i)
        if (i ~= self.id and alive and dyn ~= 0 and v.team == self.team) then

            local in_vehicle, object, vehicle_id = InVehicle(dyn)
            local vehicle = self:ValidateVehicle(object)

            if (in_vehicle and vehicle) then

                if (not done[vehicle]) then
                    done[vehicle] = true
                    index = index + 1
                end

                local seat = read_word(dyn + 0x2F0)
                local seat_label = vehicle.seats[seat]

                if (seat_label) then

                    local seats = AvailableSeats(vehicle.seats, seat)

                    t[index] = t[index] or NewVehicle(vehicle.label, seats, vehicle_id, vehicle.priority)
                    --insert(t[index].occupants, v)
                end
            end
        end
    end

    table.sort(t, function(a, b)
        return a.priority > b.priority
    end)

    return t
end

function Uber:CallUber()

    if (self:DoChecks()) then

        self.call_cooldown = self.call_cooldown or {
            start = time,
            finish = time() + self.cooldown_period
        }

        local seat_order = self.insertion_order
        local t = self:GetVehicles() -- table of vehicles

        for _, v in ipairs(t) do

            local vehicle_id = v.vehicle_id
            --local occupants = v.occupants
            local available_seats = v.seats

            for j = 1, #seat_order do

                local seat = seat_order[j]
                local label = available_seats[seat]
                if (label) then

                    self.calls = self.calls - 1
                    enter_vehicle(vehicle_id, self.id, seat)
                    self:Tell('Entering ' .. v.label .. ' as a ' .. label .. '.', false)
                    self:Tell('You have ' .. self.calls .. ' uber calls left.', false)

                    goto done
                end
            end
        end

        self:Tell('Uber is not available right now (no available seats).', true)

        :: done ::
    end
end

function OnJoin(Ply)
    players[Ply] = Uber:NewPlayer({
        id = Ply,
        team = get_var(Ply, '$team'),
        name = get_var(Ply, '$name')
    })
end

function OnQuit(Ply)
    players[Ply] = nil
end

function OnTick()
    for i, v in ipairs(players) do
        local dyn = get_dynamic_player(i)
        if (i and dyn ~= 0 and player_alive(i)) then

            -- Call an uber on crouch:
            if (v.crouch_to_uber) then
                local crouching = read_bit(dyn + 0x208, 0)
                if (crouching == 1 and v.crouching ~= crouching) then
                    v:CallUber()
                end
                v.crouching = crouching
            end

            -- Auto eject from vehicles that are disabled or have no driver:
            local eject = v.auto_eject
            if (eject and eject.start() > eject.finish) then
                v.auto_eject = nil
                exit_vehicle(i)
            end

            -- Uber cooldown
            local cooldown = v.call_cooldown
            if (cooldown and cooldown.start() > cooldown.finish) then
                v.call_cooldown = nil
            end
        end
    end
end

local function CancelEjection(Ply, Obj)
    for i, v in ipairs(players) do
        local dyn = get_dynamic_player(i)
        if (i ~= Ply and dyn ~= 0 and player_alive(i) and v.auto_eject and v.auto_eject.object == Obj) then
            v.auto_eject = nil
            v:Tell('Auto-eject cancelled', false)
        end
    end
end

function OnVehicleEnter(Ply, Seat)

    local p = players[Ply]
    local dyn = get_dynamic_player(Ply)

    if (p.block_objective and objective and HasObjective(dyn)) then

        local _time_ = p.block_objective_time
        p:Tell('You cannot enter a vehicle while carrying an objective.', true)
        p:Tell('Ejecting in ' .. _time_ .. ' seconds...', false)

        p.auto_eject = NewEject(_, _time_)

        return false
    end

    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)
    local allowed = p:ValidateVehicle(object)

    local driver = read_dword(object + 0x324)
    local no_driver = (driver == 0xFFFFFFFF or driver == 0)

    if (not allowed and p.eject_from_disabled_vehicle) then

        local _time_ = p.eject_from_disabled_vehicle_time
        p:Tell('You cannot enter this vehicle.', false)
        p:Tell('Ejecting in ' .. _time_ .. ' seconds...', false)
        p.auto_eject = NewEject(_, _time_)

    elseif (allowed and p.eject_without_driver and Seat ~= 0 and no_driver) then

        local _time_ = p.eject_without_driver_time
        p.auto_eject = NewEject(object, _time_)
        p:Tell('This vehicle has no driver.', false)
        p:Tell('Ejecting in ' .. _time_ .. ' seconds...', false)

    elseif (tonumber(Seat) == 0) then
        CancelEjection(Ply, object) -- cancel ejection for all other occupants
    end
end

function OnVehicleExit(Ply)
    players[Ply].auto_eject = nil
end

function OnDeath(Ply)
    players[Ply].auto_eject = nil
end

function OnSwitch(Ply)
    players[Ply].team = get_var(Ply, '$team')
end

function OnChat(Ply, MSG)
    local player = players[Ply]
    if (player.phrases[MSG]) then
        player:CallUber()
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
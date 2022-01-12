--[[
--=====================================================================================================--
Script Name: Vehicle Spawner, for SAPP (PC & CE)
Description: A custom vehicle spawner that works on any game mode.

             This was designed to fix a problem with vehicles that are created using
             spawn_object() on race game modes - they do not respawn at the origin x,y,z.
             This fixes that.


Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

-- Distance (in world units) from origin x,y,z
-- that an unoccupied vehicle must be before the respawn timer is triggered:
--
local distance = 1

-- Custom object spawns:
-- {type, name, x, y, z, rotation, respawn delay (in seconds) }
--
local vehicles = {
    { "vehi", "vehicles\\warthog\\mp_warthog", 47.15, -79.28, 0.12, 0, 30 },
}
-- config ends --

api_version = "1.12.0.0"

-- Register needed event callbacks:
--
function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnStart")
    register_callback(cb["EVENT_TICK"], "GameTick")
    OnStart()
end

-- Spawns a new vehicle object from vehicles{}
-- @Param v, vehicle object table.
--
local function SpawnVehicle(v)

    -- Technical note:
    -- Teleporting a vehicle using write_vector3d() causes unwanted behavior.
    -- Therefore, we delete the object and re create it with spawn_object().

    -- Destroy existing:
    --
    destroy_object(v.vehicle ~= 0 and v.vehicle or 0)

    local type, name = v[1], v[2] -- tag name, tag type
    local x, y, z, r = v[3], v[4], v[5], v[6]

    v.timer = 0
    v.vehicle = spawn_object(type, name, x, y, z, r)
    v.object = get_object_memory(v.vehicle)
end

-- Checks if a player is occupying a vehicle:
-- Compares the object memory address of the current vehicle against v.object.
-- @Param v, vehicle object table.
local function Occupied(v)
    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            local DyN = get_dynamic_player(i)
            if (DyN ~= 0) then
                local VehicleID = read_dword(DyN + 0x11C)
                local object = get_object_memory(VehicleID)
                if (VehicleID ~= 0xFFFFFFFF and object ~= 0) then
                    return (v.object == object or false)
                end
            end
        end
    end
    return false
end

-- Distance function using pythagoras theorem:
--
local sqrt = math.sqrt
local function GetDist(x1, y1, z1, x2, y2, z2)
    return sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
end

-- Respawn a vehicle that has moved from its starting location:
-- Called every 1/30th second:
--
function GameTick()
    for _, v in pairs(vehicles) do
        local object = get_object_memory(v.vehicle)
        if (object ~= 0 and not Occupied(v)) then
            local x, y, z = read_vector3d(object + 0x5C)
            local dist = GetDist(x, y, z, v[3], v[4], v[5])
            v.timer = (dist > distance and v.timer + 1 / 30) or 0
            if (v.timer >= v[7]) then
                SpawnVehicle(v)
            end
        end
    end
end

-- Function is called when a new game has started.
-- Responsible for spawning all vehicles initially:
--
function OnStart()
    if (get_var(0, "$gt") ~= "n/a") then
        for _, v in pairs(vehicles) do
            SpawnVehicle(v)
        end
    end
end

function OnScriptUnload()
    -- N/A
end
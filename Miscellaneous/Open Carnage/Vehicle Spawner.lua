--[[
--=====================================================================================================--
Script Name: Vehicle Spawner, for SAPP (PC & CE)
Description: A custom vehicle spawner that works on any game mode.

             This was designed to fix a problem with vehicles that are created using
             spawn_object() or execute_command("spawn ... ") on race game types - they do not respawn at the origin x,y,z.
             This fixes that.

             NOTE:
             If you're using this on any RACE game type,
             you must set the game type flag "VEHICLE RESPAWN TIME" to NEVER.


Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

--[[
	FORMAT:
	{type, name, x, y, z, rotation, respawn delay, distance}

	TECHNICAL NOTES:
	* Rotation must be in radians not degrees.
	* Respawn Delay must be in seconds.
	* The distance property is the distance (in world units) from the origin x,y,z
	  that an unoccupied vehicle must be (or greater)
	  before the respawn timer for that vehicle is triggered.
--]]

local vehicles = {
    ["bloodgulch"] = {
        -- Example vehicle: (right of blue base):
        { "vehi", "vehicles\\warthog\\mp_warthog", 47.15, -79.28, 0.12, 0, 30, 1 },
        --
        -- repeat the structure to add more vehicle entries.
        --
    },

    ["deathisland"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["icefields"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["infinity"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["sidewinder"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["timberland"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["dangercanyon"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["beavercreek"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["boardingaction"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["carousel"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["chillout"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["damnation"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["gephyrophobia"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["hangemhigh"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["longest"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["prisoner"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["putput"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["ratrace"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    ["wizard"] = {
        { "vehi", "", 0, 0, 0, 0, 30, 1 },
    },

    --
    -- repeat the structure to add more map entries.
    --

}
-- config ends --

api_version = "1.12.0.0"

-- Stores a copy of vehicles[map name]:
--
local objects

-- Register needed event callbacks:
--
function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnStart")
    OnStart()
end

-- Spawns a new vehicle object from vehicles{}:
-- @Param v, vehicle object table.
--
local function SpawnVehicle(v)

    -- Technical note:
    -- Teleporting a vehicle using write_vector3d() causes unwanted behavior.
    -- Therefore, we delete the object and re create it with spawn_object().

    -- Destroy previously created vehicle:
    --
    destroy_object(v.vehicle ~= 0 and v.vehicle or 0)

    -- tag name, tag type:
    local type, name = v[1], v[2]

    -- x,y,z, rotation coordinates:
    local x, y, z, r = v[3], v[4], v[5], v[6]

    -- Set initial timer property to 0:
    -- This is incremented automatically when we initialize a vehicles respawn timer.
    v.timer = 0

    -- Spawn the vehicle and store its object id [number] in v.vehicle:
    v.vehicle = spawn_object(type, name, x, y, z, r)

    -- Store its memory address [number] in property v.object:
    v.object = get_object_memory(v.vehicle)
end

-- Checks if a player is occupying a vehicle:
-- @Param v, vehicle object table.
-- @return Returns true if vehicle memory address equals v.object.
--
local function Occupied(v)
    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            local DyN = get_dynamic_player(i)
            if (DyN ~= 0) then
                local VID = read_dword(DyN + 0x11C)
                local OBJ = get_object_memory(VID)
                return (OBJ ~= 0 and VID ~= 0xFFFFFFFF and OBJ == v.object)
            end
        end
    end
    return false
end

-- Distance function using pythagoras theorem:
-- @Param x1, y1, z1 (origin x,y,z)  [floating point numbers]
-- @Param x2, y2, z2 (current x,y,z) [floating point numbers]
-- @return Sqrt of (x1-x2)*2(y1-y2)*(z1-z2)
--
local sqrt = math.sqrt
local function GetDist(x1, y1, z1, x2, y2, z2)
    return sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
end

-- Respawn a vehicle that has moved from its starting location:
-- Called every 1/30th second.
--
function GameTick()

    -- Loop through all tables in objects (vehicles[map name]):
    for _, v in pairs(objects) do

        -- Check if vehicle is exists, is valid and isn't occupied:
        local object = get_object_memory(v.vehicle)
        if (object ~= 0 and not Occupied(v)) then

            -- Get this vehicles x,y,z coordinates (three 32-bit floating point numbers):
            local x, y, z = read_vector3d(object + 0x5C)

            -- Calculate distance from this vehicles origin x,y,z:
            local dist = GetDist(x, y, z, v[3], v[4], v[5])

            -- Increment timer by itself + 1/30 if distance > v[8].
            v.timer = (dist > v[8] and v.timer + 1 / 30) or 0

            -- Respawn this vehicle if the timer reaches v[7]:
            if (v.timer >= v[7]) then
                SpawnVehicle(v)
            end
        end
    end
end

-- This function is called when a new game has started:
--
function OnStart()

    objects = nil

    if (get_var(0, "$gt") ~= "n/a") then

        local map = get_var(0, "$map")
        objects = vehicles[map]

        if (objects) then

            -- Loop through all tables relevant to the current map and
            -- call SpawnVehicle(); Pass the vehicle table to it.
            for _, v in pairs(objects) do
                SpawnVehicle(v)
            end

            -- Register needed event callback:
            register_callback(cb["EVENT_TICK"], "GameTick")
            goto done
        end

        -- Unregister if map not configured in vehicles array:
        unregister_callback(cb["EVENT_TICK"])
        cprint("[Vehicle Spawner] " .. map .. " is not configured in vehicles array", 12)

        :: done ::
    end
end

function OnScriptUnload()
    -- N/A
end
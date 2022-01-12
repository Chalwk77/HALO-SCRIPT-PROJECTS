--[[
--=====================================================================================================--
Script Name: Vehicle Spawner, for SAPP (PC & CE)
Description: A custom vehicle spawner that works on any game mode.

             This was designed to fix a problem with vehicles that are created using
             spawn_object() on race game modes - they do not respawn at the origin x,y,z.
             This fixes that.

             NOTE:
             If you're using this on any RACE game mode,
             set the game type flag "VEHICLE RESPAWN TIME" to NEVER.


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
	* Rotation must be in radians.
	* Respawn Delay must be in seconds.
	* The distance property is the distance (in world units) from the origin x,y,z
	  that an unoccupied vehicle must be (or greater)
	  before the respawn timer for that vehicle is triggered.
--]]

local vehicles = {
    ["bloodgulch"] = {
        -- Example vehicle: (right of blue base)
        { "vehi", "vehicles\\warthog\\mp_warthog", 47.15, -79.28, 0.12, 0, 30, 1 },
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
}
-- config ends --

api_version = "1.12.0.0"

-- Stores vehicles[map name]:
--
local object_spawns

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

    local type, name = v[1], v[2] -- tag name, tag type
    local x, y, z, r = v[3], v[4], v[5], v[6]

    v.timer = 0
    v.vehicle = spawn_object(type, name, x, y, z, r)
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
    for _, v in pairs(object_spawns) do
        local object = get_object_memory(v.vehicle)
        if (object ~= 0 and not Occupied(v)) then
            local x, y, z = read_vector3d(object + 0x5C)
            local dist = GetDist(x, y, z, v[3], v[4], v[5])
            v.timer = (dist > v[8] and v.timer + 1 / 30) or 0
            if (v.timer >= v[7]) then
                SpawnVehicle(v)
            end
        end
    end
end

-- This function is called when a new game has started:
-- Responsible for all initial vehicle spawns.
--
function OnStart()

    object_spawns = nil

    if (get_var(0, "$gt") ~= "n/a") then

        local map = get_var(0, "$map")
        object_spawns = vehicles[map]

        if (object_spawns) then
            for _, v in pairs(object_spawns) do
                SpawnVehicle(v)
            end

            -- Register needed event callback:
            register_callback(cb["EVENT_TICK"], "GameTick")
            goto done
        end

        -- Unregister if map not configured in vehicles array:
        unregister_callback(cb["EVENT_TICK"])
        :: done ::
    end
end

function OnScriptUnload()
    -- N/A
end
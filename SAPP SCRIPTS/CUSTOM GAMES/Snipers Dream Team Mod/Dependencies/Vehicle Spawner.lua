-- Snipers Dream Team Mod [Vehicle Spawner File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local SDTM = {}

-- Spawns a new vehicle object from vehicles{}:
-- @Param v, vehicle object table.
--
local function SpawnVehicle(v)

    -- Technical note:
    -- Teleporting an unoccupied vehicle using write_vector3d() seems to cause glitchy behavior.
    -- Therefore, we delete the object and re create it with spawn_object().

    -- Destroy previously created vehicle:
    --
    destroy_object(v.vehicle ~= 0 and v.vehicle or 0)

    -- tag name, tag type:
    local type, name = v[1], v[2]

    -- x,y,z,r coordinates:
    local x, y, z, r = v[3], v[4], v[5], v[6]

    -- Set initial timer property to 0:
    -- This is incremented automatically when we initialize a vehicles respawn timer.
    v.timer = 0

    -- Spawn the vehicle and store its object id [number] in property v.vehicle:
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

-- Called every 1/30th second;
-- * Respawn a vehicle that has moved from its starting location.
--
function SDTM:RespawnVehicle()

    if (self.objects) then

        -- Loop through objects table (vehicles[map name]):
        for _, v in pairs(self.objects) do

            -- Check if vehicle is exists, is valid and isn't occupied:
            local object = get_object_memory(v.vehicle)
            if (object ~= 0 and not Occupied(v)) then

                -- Get this vehicles x,y,z coordinates (three 32-bit floating point numbers):
                local x, y, z = read_vector3d(object + 0x5C)

                -- Calculate distance from this vehicles origin x,y,z:
                local dist = self:GetDist(x, y, z, v[3], v[4], v[5])

                -- Increment timer by itself + 1/30 if distance > v[8].
                v.timer = (dist > v[8] and v.timer + 1 / 30) or 0

                -- Respawn this vehicle if the timer reaches v[7]:
                if (v.timer >= v[7]) then
                    SpawnVehicle(v)
                end
            end
        end
    end
end

-- Called when a new game has started:
-- Loops through vehicle table: settings[map][vehicles][mode]
-- Pass vehicle table (v) to SpawnVehicle().
function SDTM:Load()
    local map = self.map
    map = self.settings[map]
    if (map and map.vehicles[self.mode]) then
        self.objects = (map.vehicles[self.mode]) or nil
        for _, v in pairs(self.objects) do
            SpawnVehicle(v)
        end
    end
end

return SDTM
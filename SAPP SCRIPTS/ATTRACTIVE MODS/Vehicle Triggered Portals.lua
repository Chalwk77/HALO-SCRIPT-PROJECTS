--[[
--=====================================================================================================--
Script Name: Vehicle Triggered Portals, for SAPP (PC & CE)
Description: This script implements custom teleporter pairs that can ony be accessed while
             occupying a vehicle.

Copyright (c) 2016-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local maps = {
    ['bloodgulch'] = {

        -- format:
        -- The first 3 elements are the origin x,y,z coords.
        -- The next 3 elements are the destination x,y,z coords.
        -- The last number is the radius a player must be from the origin coordinates to teleport themselves (and the vehicle they occupy)
        -- to the destination coordinates.

        -- Example coordinates:
        -- Cave to Back of redbase
        { 98.77, -108.72, 4.32, 65.52, -179.70, 4.37, 5 },
    },

    --
    -- repeat the structure to add more maps and teleporter pairs:
    --
    ['map name here'] = {
        {}
    }
}

local coordinates

api_version = '1.12.0.0'

function OnScriptLoad()

    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    OnStart()
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        local map = get_var(0, '$map')
        if (maps[map]) then

            register_callback(cb['EVENT_TICK'], 'OnTick')

            coordinates = maps[map]

            return true
        end

        unregister_callback(cb['EVENT_TICK'])
    end
end

local function GetXYZ(dyn)

    local x, y, z = 0, 0, 0
    local crouch = read_float(dyn + 0x50C)
    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)
    if (vehicle ~= 0xFFFFFFFF and object ~= 0) then
        x, y, z = read_vector3d(object + 0x5C)
    end

    return x, y, (crouch == 0 and z + 0.65 or z + 0.35), (object + 0x5C)
end

local sqrt = math.sqrt
local function GetDist(x1, y1, z1, x2, y2, z2)
    return sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
end

local function Teleport(vehicle, x, y, z)

    -- z offset (to prevent vehicle from falling thru the map):
    local z_off = 0.3

    write_vector3d(vehicle, x, y, z + z_off)
end

function OnTick()
    for i = 1, 16 do

        if player_present(i) then
            local dyn = get_dynamic_player(i)
            if (player_alive(i) and dyn ~= 0) then

                local x, y, z, vehicle = GetXYZ(dyn)
                if (x) then
                    for j = 1, #coordinates do

                        local t = coordinates[j]

                        -- Teleport origin x,y,z:
                        local ox, oy, oz = t[1], t[2], t[3]

                        -- Teleport origin trigger radius:
                        local r = t[#t]

                        if (GetDist(x, y, z, ox, oy, oz) <= r) then

                            -- Teleport destination x,y,z:
                            local dx, dy, dz = t[4], t[5], t[6]

                            Teleport(vehicle, dx, dy, dz)

                            rprint(i, 'Woosh!')
                            goto done
                        end
                    end
                end
            end
        end

        :: done ::
    end
end

function OnScriptUnload()
    -- N/A
end
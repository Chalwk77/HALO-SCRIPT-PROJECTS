-- Custom Teleports, by Chalwk
-- For Naked Chick.

api_version = "1.12.0.0"

-------------------
-- config starts --
-------------------
local Teleports = {

    -- Each teleport pair must be an array: {}.
    -- The first three values are the teleport location x,y,z coordinates.
    -- The 4th value is the radius (in world-units) that a player must be to trigger the teleport logic.
    -- The 5th, 6th and 7th values are the associative exit-teleport location x,y,z coordinates.
    -- The last value is the z axis height offset for the aforementioned exit-teleport.

    ["Sniper Island"] = {
        { 20.5739, 129.558, 17.6009, 0.5, 39.0283, 65.921, 16.3919, 0.2 },

        -- Fill these values in to add more teleport locations:
        --
        { 000, 000, 000, 0, 000, 000, 000, 0 },
    },

    -- Repeat the structure to add more maps:
    --
    ["map_name_here"] = {
        { 000, 000, 000, 0, 000, 000, 000, 0 },
    },
}
-----------------
-- config ends --
-----------------

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_TICK"], "OnTick")
    OnGameStart()
end

local coordinates
local sqrt = math.sqrt

function OnGameStart()
    coordinates = nil
    if (get_var(0, "$gt") ~= "n/a") then

        -- Define the map-name-associated teleport array:
        --
        coordinates = Teleports[get_var(0, "$map")] or nil
    end
end

local function GetPortal(x, y, z)
    for _, t in pairs(coordinates) do

        local px1, py1, pz1 = t[1], t[2], t[3] -- teleport coordinates.
        local px2, py2, pz2 = t[5], t[6], t[7] -- associative exit-teleport location coordinates.

        local radius = t[4] -- trigger radius for this teleport.
        local height = t[8] -- z height offset for associative exit-teleport coordinate.

        -- Checks if player is within X world-units of this teleport
        -- and returns target location coordinates as an array:
        --
        if sqrt((x - px1) ^ 2 + (y - py1) ^ 2 + (z - pz1) ^ 2) <= radius then
            return { x = px2, y = py2, z = pz2 + height }
        end
    end
    return nil
end

function OnTick()

    if (coordinates) then

        -- Loop through all players online and alive:
        --
        for i = 1, 16 do
            if player_present(i) and player_alive(i) then

                -- Check if player is not in a vehicle:
                --
                local DyN = get_dynamic_player(i)
                local VehicleID = read_dword(DyN + 0x11C)
                if (DyN ~= 0 and VehicleID == 0xFFFFFFFF) then

                    -- Get the location coordinates of teleport exit-location:
                    --
                    local x, y, z = read_vector3d(DyN + 0x5c)
                    local new_pos = GetPortal(x, y, z)

                    -- Move player to teleport exit-location:
                    --
                    if (new_pos) then
                        write_vector3d(DyN + 0x5C, new_pos.x, new_pos.y, new_pos.z)
                    end
                end
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end
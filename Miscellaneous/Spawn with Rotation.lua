-- One-time load of Coordinates library:
local coordinates = assert(loadfile "Coordinates.lib")()

-- coordinates[map].ffa
-- coordinates[map].red
-- coordinates[map].blue
-- coordinates[map].random

---------------------------------------------------------------
-- EXAMPLE USAGE:

api_version = "1.12.0.0"

local map_table

function OnScriptLoad()
    register_callback(cb["EVENT_PRESPAWN"], "OnPreSpawn")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    OnGameStart()
end

function OnGameStart()
    map_table = nil
    if (get_var(0, "$gt") ~= "n/a") then
        map_table = coordinates[get_var(0, "$map")]
    end
end

function OnPreSpawn(Ply)
    if (map_table) then
        local DyN = get_dynamic_player(Ply)
        if (DyN ~= 0) then

            math.randomseed(os.clock())

            -- Use this to access the relevant team tables for this map;
            --local team = get_var(Ply, "$team")
            --local pos = map_table[team]

            -- Use ffa table for this map:
            local pos = map_table.ffa

            -- Pick random coordinate from ffa table:
            local n = math.random(1, #pos)
            local x, y, z, r = pos[n][1], pos[n][2], pos[n][3], pos[n][4]

            -- Update player x,y,z coordinate
            write_vector3d(DyN + 0x5C, x, y, z)

            -- Update player rotation:
            write_vector3d(DyN + 0x74, math.cos(r), math.sin(r), 0)
        end
    end
end
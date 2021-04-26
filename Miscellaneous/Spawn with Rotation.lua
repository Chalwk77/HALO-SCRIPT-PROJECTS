local coordinates = assert(loadfile "Coordinates.lib")()

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "START")
    register_callback(cb["EVENT_PRESPAWN"], "PreSpawn")
end

local map_table
function START()
    local map = get_var(0, "$map")
    map_table = coordinates[map]
end

function PreSpawn(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then

        math.randomseed(os.clock())
        math.random();
        math.random();
        math.random();

        local pos = map_table.ffa
        local n = math.random(1,#pos)
        local x, y, z, r = pos[n][1], pos[n][2], pos[n][3], pos[n][4]

        write_vector3d(DyN + 0x5C, x, y, z)
        write_vector3d(DyN + 0x74, math.cos(r), math.sin(r), 0)
    end
end
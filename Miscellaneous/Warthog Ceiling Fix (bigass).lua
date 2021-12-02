-- Warthog ceiling bug fix for the map Bigass
-- Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>

-- This script will automatically teleport a glitched warthog back to its starting position (w/ proper rotation).

local vehicles = {
    { type = 'vehi', -- red base
      name = 'bourrin\\halo reach\\vehicles\\warthog\\reach gauss hog',
      pos = { -130.70635986328, -71.420547485352, -0.12882445752621, 6.6630392247964e-37 } },
    { type = 'vehi', -- red base
      name = 'bourrin\\halo reach\\vehicles\\warthog\\h2 mp_warthog',
      pos = { -128.29974365234, -70.520027160645, -0.14425709843636, -6.4093676162253e+14 } },
    { type = 'vehi', -- blue base
      name = 'bourrin\\halo reach\\vehicles\\warthog\\h2 mp_warthog',
      pos = { 149.50099182129, 40.949211120605, -0.79486745595932, 3.5092477183271e+25 } },
    { type = 'vehi', -- blue base
      name = 'bourrin\\halo reach\\vehicles\\warthog\\reach gauss hog',
      pos = { 152.07527160645, 40.980175018311, -0.78609919548035, 8.9575530326513e-10 } }
}

local delay = 1
local game_started

api_version = "1.12.0.0"

function Init()

    game_started = false

    if (get_var(0, "$gt") ~= "n/a") then

        game_started = true

        for _, v in pairs(vehicles) do
            v.object = 0
        end

        timer(1000 * delay, "CheckVehicles")
    end
end

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
    Init()
end

function OnGameStart()
    Init()
end

function OnGameEnd()
    game_started = false
end

-- Distance function using pythagoras theorem:
--
local function GetDistance(x1, y1, z1, x2, y2, z2, r)
    return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2) <= r
end

function CheckVehicles()
    for _, v in pairs(vehicles) do

        local object = get_object_memory(v.object)
        if (object ~= 0 and object ~= 0xFFFFFFFF) then

            -- Where it currently is: x,y,z
            --
            local vx, vy, vz = read_vector3d(object + 0x5C)

            -- Where it should be: x,y,z,r
            --
            local x = v.pos[1]
            local y = v.pos[2]
            local z = v.pos[3]
            local r = v.pos[4]

            -- Check if the vehicle is near its starting location (within 0.500 world units):
            --
            if (GetDistance(vx, vy, vz, x, y, z, 0.500)) then

                -- Check if its floating above the ground (+0.3 world units above z):
                --
                local height_offset = math.sqrt((vz ^ 2) + (z ^ 2))
                if (height_offset > 0.3) then

                    -- Respawn this vehicle:
                    --
                    destroy_object(object)
                    spawn_object(v.type, v.name, x, y, z, r)
                end
            end
        end
    end
    return game_started
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return (Tag ~= 0 and read_dword(Tag + 0xC)) or nil
end

function OnObjectSpawn(_, MapID, _, ObjectID)
    for _, v in pairs(vehicles) do
        if (MapID == GetTag(v.type, v.name)) then
            -- Save this vehicles object id:
            --
            v.object = ObjectID
        end
    end
end

function OnScriptUnload()
    -- N/A
end
--[[
--=====================================================================================================--
Script Name: OnTeleport, for SAPP (PC & CE)
Description: An example script that detects when a player has teleported.
             This script is intended to be used by other developers.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Distance (in world/units) a player must have moved
-- to have been considered teleporting...
--
local max_distance = 10

--
-- do not touch below this point --
--

api_version = '1.12.0.0'

local players = {}
local delay = 0.001
local time = os.time

function OnScriptLoad()

    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    OnStart()
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnJoin(Ply)
    players[Ply] = {
        name = get_var(Ply, '$name'),
        pos = {
            { -- old pos
                0,
                0,
                0
            },
            { -- new pos
                0,
                0,
                0
            }
        }
    }
end

function OnQuit(Ply)
    players[Ply] = nil
end

function OnSpawn(Ply)
    players[Ply].get_old = true
end

local function GetXYZ(dyn)
    local x, y, z

    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)

    -- not in a vehicle:
    if (vehicle == 0xFFFFFFFF) then
        x, y, z = read_vector3d(dyn + 0x5C)

        -- in a vehicle:
    elseif (object ~= 0) then
        x, y, z = read_vector3d(object + 0x5C)
    end

    return x, y, z
end

local sqrt = math.sqrt
local function GetDist(old, new)

    local x1, y1, z1 = old[1], old[2], old[3]
    local x2, y2, z2 = new[1], new[2], new[3]

    return sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
end

function OnTick()
    for i, v in ipairs(players) do

        local dyn = get_dynamic_player(i)
        if (dyn ~= 0 and player_alive(i)) then

            if (v.get_old) then
                v.get_old = false

                -- old player coordinates:
                local oldX, oldY, oldZ = GetXYZ(dyn)

                v.pos[1][1] = oldX
                v.pos[1][2] = oldY
                v.pos[1][3] = oldZ

            elseif (not v.get_old) then

                -- current player coordinates:
                local newX, newY, newZ = GetXYZ(dyn)

                v.pos[2][1] = newX
                v.pos[2][2] = newY
                v.pos[2][3] = newZ

                local distance = GetDist(v.pos[1], v.pos[2])
                if (distance > max_distance) then
                    OnTeleport(v)
                end

                v.get_old = true
            end
        end
    end
end

function OnTeleport(player)
    print(player.name .. ' teleported')
    --
    -- do something here ...
    --
end

function OnScriptUnload()
    -- N/A
end
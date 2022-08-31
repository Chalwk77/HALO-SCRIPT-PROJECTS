--[[
--=====================================================================================================--
Script Name: Rocket Launcher Malfunction, for SAPP (PC & CE)
Description: Your rocket launcher will spontaneously explode at random times, killing you and nearby players.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-------------------
-- Config starts --
-------------------

-- Number of rocket projectiles to spawn:
-- These simulate an explosion.
--
local projectiles = 10

-- Minimum possible time (in seconds) that an explosion may occur:
local min_time = 5

-- Max possible time (in seconds) that an explosion may occur:
local max_time = 10

-----------------
-- Config ends --
-----------------

api_version = '1.12.0.0'

local rocket_proj
local rocket_weap
local players = {}

function OnScriptLoad()
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

local function GetTag(class, name)
    local tag = lookup_tag(class, name)
    return (tag ~= nil and read_dword(tag + 0xC)) or nil
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        rocket_proj = GetTag('proj', 'weapons\\rocket launcher\\rocket')
        rocket_weap = GetTag('weap', 'weapons\\rocket launcher\\rocket launcher')
        if (rocket_proj and rocket_weap) then
            register_callback(cb['EVENT_TICK'], 'OnTick')
            for i = 1, #players do
                if player_present(i) then
                    ResetTimer(i)
                end
            end
        else
            unregister_callback(cb['EVENT_TICK'])
        end
    end
end

function OnSpawn(Ply)
    players[Ply] = {
        timer = 0,
        interval = rand(min_time, max_time + 1)
    }
end

function OnQuit(Ply)
    players[Ply] = nil
end

local function InVehicle(dyn)
    local vehicle = read_dword(dyn + 0x11C)
    return (vehicle ~= 0xFFFFFFFF)
end

local function SpawnProjectiles(Ply, dyn)

    local x, y, z = read_vector3d(dyn + 0x5C)
    for _ = 1, projectiles do

        local payload = spawn_object('', '', x, y, z + 0.1, 0, rocket_proj)
        local projectile = get_object_memory(payload)

        -- Update z velocity:
        if (payload and projectile ~= 0) then
            write_float(projectile + 0x70, -1)
        end
    end

    rprint(Ply, 'Your rocket launcher has blown up')
end

local time_scale = 1 / 30
function OnTick()

    for i, v in ipairs(players) do
        local dyn = get_dynamic_player(i)
        if (player_present(i) and player_alive(i) and dyn ~= 0) then

            local weapon = read_dword(dyn + 0x118)
            local object = get_object_memory(weapon)

            if (v.timer and object ~= 0 and read_dword(object) == rocket_weap and not InVehicle(dyn)) then

                v.timer = v.timer + time_scale
                if (v.timer >= v.interval) then
                    SpawnProjectiles(i, dyn)
                end
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end
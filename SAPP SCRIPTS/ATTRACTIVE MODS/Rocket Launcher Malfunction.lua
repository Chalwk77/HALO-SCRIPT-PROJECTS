--[[
--=====================================================================================================--
Script Name: Rocket Launcher Malfunction, for SAPP (PC & CE)
Description: A gag mod - Your rocket launcher will spontaneously explode at a random time, killing you and nearby players.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Config [STARTS] ---------------------------------------------------------------------

local WeaponTagName = "weapons\\rocket launcher\\rocket launcher"
local WeaponProjectileTag = { "proj", "weapons\\rocket launcher\\rocket" }

-- To simulate an explosion, we simply spawn multiple rockets at the players X, Y, Z coordinates.
-- Set higher values for a greater effect!
local projectile_count = 10

-- Minimum time until rocket launcher explodes:
local min_time = 1 -- in seconds
-- Maximum time until rocket launcher explodes:
local max_time = 300 -- in seconds
-- Config [ENDS] ---------------------------------------------------------------------

local players = {}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_SPAWN'], 'OnPlayerSpawn')
    register_callback(cb['EVENT_JOIN'], 'OnPlayerConnect')
    register_callback(cb['EVENT_LEAVE'], 'OnPlayerDisconnect')
    if (get_var(0, "$gt") ~= "n/a") then
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnPlayerDisconnect(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function OnPlayerSpawn(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function InitPlayer(PlayerIndex, Reset)
    if (Reset) then
        players[PlayerIndex] = {}
    else
        math.randomseed(os.clock())
        players[PlayerIndex] = {
            timer = 0,
            interval = math.random(min_time, max_time)
        }
    end
end

function OnTick()
    for player, v in pairs(players) do
        if player_present(player) then

            local DynamicPlayer = get_dynamic_player(player)
            if (DynamicPlayer ~= 0) then

                local weapon = read_dword(DynamicPlayer + 0x118)
                local Object = get_object_memory(weapon)
                if (Object ~= 0) then
                    local tag_name = read_string(read_dword(read_word(Object) * 32 + 0x40440038))
                    if (tag_name == WeaponTagName) then

                        v.timer = v.timer + 1 / 30
                        if (v.timer >= v.interval) then
                            v.timer = 0

                            local px, py, pz = read_vector3d(DynamicPlayer + 0x5C)

                            for _ = 1, projectile_count do

                                -- Spawn a projectile at 1 world unit above the player's head
                                local payload = spawn_object(WeaponProjectileTag[1], WeaponProjectileTag[2], px, py, pz + 1)
                                local projectile = get_object_memory(payload)

                                -- Change the Z Velocity by -1 world unit every 1/30th second.
                                if (projectile ~= 0) then
                                    write_float(projectile + 0x70, -1)
                                end
                            end
                        end
                    elseif (v.timer ~= 0) then
                        InitPlayer(player, false)
                    end
                end
            end
        end
    end
end

function OnScriptUnload()

end

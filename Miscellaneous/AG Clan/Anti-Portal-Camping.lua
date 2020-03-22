--[[
--======================================================================================================--
Script Name: Anti-Portal-Camping (v1.0), for SAPP (PC & CE)
Description: Details will come at a later date.

* Made specifically for AG Clan (http://agclan1.proboards.com/)

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

-- Configuration Starts --
local time_until_kill = 10 -- in seconds
local warning_message = "Warning. You will be killed in %seconds% seconds for portal-camping. Move away!"
local on_kill_message = "You were killed for Portal Camping."
-- Configuration Ends --

local players = {}
local game_over, mapname
local delta_time = 1 / 30
local trigger_distance = 3.5 -- world units
local floor = math.floor

local portals = {
    ["ratrace"] = {
        { -4.878, -16.255, -2.118 },
        { 8.945, -26.794, -3.611 },
        { 22.394, -5.786, -2.115 },
        { 8.383, -8.004, 0.223 }
    },
}

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")

    if get_var(0, "$gt") ~= "n/a" then
        game_over, mapname = false, get_var(0, "$map")
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

function OnScriptUnload()

end

function OnGameStart()
    game_over, mapname = false, get_var(0, "$map")
end

function OnGameEnd()
    game_over = true
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


-- This function called every 1/30th second
function OnTick()
    if (not game_over) then
        for i, player in pairs(players) do
            if (i) then
                if player_present(i) and player_alive(i) then

                    local dynamic_player = get_dynamic_player(i)
                    if (dynamic_player ~= 0) then

                        local coords = getXYZ(dynamic_player)
                        if (coords) then
                            local x1, y1, z1, t = coords.x, coords.y, coords.z, portals[mapname]
                            if (t) then -- map array
                                for j = 1, #t do
                                    local x2, y2, z2 = t[j][1], t[j][2], t[j][3]
                                    if CheckCoordinates(x1, y1, z1, x2, y2, z2) then
                                        if (player.init) then
                                            player.timer = player.timer + delta_time
                                            if (floor(player.timer) == floor(time_until_kill / 2)) then
                                                -- todo: warn player
                                            elseif (floor(player.timer) > floor(time_until_kill)) then
                                                player.init = false
                                                -- todo: kill logic
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function InitPlayer(PlayerIndex, Reset)
    if (not Reset) then
        players[PlayerIndex] = { timer = 0, init = true }
    else
        players[PlayerIndex] = {}
    end
end

function getXYZ(PlayerObject)
    local coords, x, y, z = {}
    local VehicleID = read_dword(PlayerObject + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        coords.invehicle = false
        x, y, z = read_vector3d(PlayerObject + 0x5c)
    else
        coords.invehicle = true
        x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end
    coords.x, coords.y, coords.z = x, y, z
    return coords
end

function CheckCoordinates(x1, y1, z1, x2, y2, z2)
    local distance = math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
    if (distance <= trigger_distance) then
        return distance
    end
end

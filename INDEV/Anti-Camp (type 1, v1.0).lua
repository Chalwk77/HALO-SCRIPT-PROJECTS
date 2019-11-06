--[[
--=====================================================================================================--
Script Name: Anti-Camp (type 1, v1.0), for SAPP (PC & CE)
Description: N/A

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"


-- config starts -- 
local max_distance = 80
local total_camp_time = 30
-- config ends --

-- Do Not Touch:
local players = {}
local format, gsub = string.format, string.gsub
local floor, sqrt = math.floor, math.sqrt
local gamestarted, delta_time = 0.03333333333333333

function OnScriptLoad()

    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    if (get_var(0, '$gt') ~= "n/a") then
        gamestarted = true
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, true)
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, '$gt') ~= "n/a") then
        gamestarted = true
    end
end

function OnGameEnd()
    gamestarted = false
end

function OnPlayerConnect(p)
    InitPlayer(p, true)
end

function OnPlayerDisconnect(p)
    InitPlayer(p, false)
end

local function GetDistance(pX, pY, pZ, sX, sY, sZ, R)
    return sqrt((pX - sX) ^ 2 + (pY - sY) ^ 2 + (pZ - sZ) ^ 2)
end

function OnTick()
    if (#players > 0) and (gamestarted) then
        for i, player in pairs(players) do
            if player_alive(i) then
                local player_object = get_dynamic_player(i)
                if (player_object ~= 0) then
                
                    local coords = getXYZ(i, player_object)
                    local oldX,oldY,oldZ = coords.x,coords.y,coords.z
                    
                    player.timer = player.timer + delta_time
                    local delay = (1 - floor(player.timer % 60))
                    if (delay <= 0) then
                        player.timer = 0
                    
                        local coords = getXYZ(i, player_object)
                        local newX,newY,newZ = coords.x,coords.y,coords.z
                        local distance = GetDistance(oldX,oldY,oldZ,newX,newY,newZ)
                        if (distance < max_distance) then
                            player.stationary_time = player.stationary_time + delta_time
                        else
                            player.stationary_time = 0
                            player.warned = false
                        end
                        
                        local time_remaining = (total_camp_time - floor(player.stationary_time % 60))
                        if (time_remaining == (time_remaining/2) and (not player.warned)) then
                            cprint("You have 10 seconds to move")
                            player.warned = true
                        end
                        if (time_remaining <= 0) and (warned) then
                            cprint('kicking player')
                            player.warned = false
                        end
                    end
                end 
            end
        end
    end
end

function initPlayer(PlayerIndex, Init)
    if (PlayerIndex) then
        if (Init) then
            players[PlayerIndex] = {
                timer = 0,
                warned = false,
                stationary_time = 0,
                name = get_var(PlayerIndex, "$name"),
            }
        else
            players[PlayerIndex] = nil
        end
    end
    return true
end

function getXYZ(PlayerIndex, PlayerObject)
    local coords, x, y, z = { }
    if player_alive(PlayerIndex) then
        local VehicleID = read_dword(PlayerObject + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            coords.invehicle = false
            x, y, z = read_vector3d(PlayerObject + 0x5c)
        else
            coords.invehicle = true
            x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
        end

        if (coords.invehicle) then
            z = z + 1
        end
        coords.x, coords.y, coords.z = x, y, z
    end
    return coords
end

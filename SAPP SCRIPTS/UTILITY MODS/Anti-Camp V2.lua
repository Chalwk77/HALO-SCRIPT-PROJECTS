--[[
--=====================================================================================================--
Script Name: Anti-Camp V2 (v1.0), for SAPP (PC & CE)

- Description -
Checks if a player is camping anywhere at any time regardless of map or game type.
Kills the player if they haven't moved beyond (max_distance) before (max_camp_time) seconds has elapsed.
Broadcasts two custom messages afterwards.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"


-- config starts -- 
-- Script will check if the player has moved beyond (max_distance) every (max_camp_time) seconds
local max_camp_time = 30 

-- Distance (in world units) the player must travel before (max_camp_time) seconds elapses
local max_distance = 10

-- Player will receive a warning message after (max_camp_time/2) seconds
local on_camp = "Anti-Camp: You have %seconds% second%s% to out of the area!"
local on_kill = {
    "You were killed for camping",
    "%name% was killed for camping",
}

-- Should admins be excluded from Anti-Camp checks?
local ignore_admins = true
-- Levels >= minimum_admin_level will be ignored
local minimum_admin_level = 1

-- config ends --

-- Do Not Touch:
local players = {}
local format, gsub = string.format, string.gsub
local floor, sqrt = math.floor, math.sqrt
local gamestarted, delta_time = nil, 0.03333333333333333

function OnScriptLoad()

    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_PRESPAWN"], "OnPlayerPreSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    if (get_var(0, '$gt') ~= "n/a") then
        gamestarted = true
        for i = 1, 16 do
            if player_present(i) then
                initPlayer(i, true)
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
    initPlayer(p, true)
end

function OnPlayerDisconnect(p)
    initPlayer(p, false)
end

local function GetDistance(p)
    local newX,newY,newZ = p.new[1],p.new[2],p.new[3]
    local oldX,oldY,oldZ = p.old[1],p.old[2],p.old[3]
    return sqrt((newX - oldX) ^ 2 + (newY - oldY) ^ 2 + (newZ - oldZ) ^ 2)
end

function OnTick()
    if (#players > 0) and (gamestarted) then
        for i, player in pairs(players) do
            if player_alive(i) then
                
                local level = tonumber(get_var(i, "$lvl"))
                if (ignore_admins and level < minimum_admin_level) or (not ignore_admins) then
                    
                    local player_object = get_dynamic_player(i)
                    if (player_object ~= 0) then
                        
                        if (player.getold) then
                            player.getold = false
                            local coords = getXYZ(i, player_object)
                            player.old[1],player.old[2],player.old[3] = coords.x,coords.y,coords.z
                        end
      
                        local coords = getXYZ(i, player_object)
                        player.new[1],player.new[2],player.new[3] = coords.x,coords.y,coords.z
                        
                        local distance = GetDistance(player)
                        if (distance < max_distance) then
                            player.camp_time = player.camp_time + delta_time
                        else
                            player.camp_time = 0
                            player.warned, player.getold = false, true
                        end
                        
                        local time_remaining = (max_camp_time - floor(player.camp_time % 60))
                        if (time_remaining > 0 and time_remaining <= (max_camp_time/2)) then
                            player.warned = true
                            local char = getChar(time_remaining)
                            cls(i, 25)
                            rprint(i, gsub(gsub(on_camp, "%%seconds%%", time_remaining), "%%s%%", char))
                        elseif (time_remaining <= 0) and (player.warned) then
                            killPlayer(i)
                            cls(i, 25)
                            say(i, on_kill[1])
                            local msg = gsub(on_kill[2], "%%name%%", player.name)
                            broadcast(msg, i)
                        end
                    end
                end
            end
        end
    end
end

function OnPlayerPreSpawn(p)
    players[p].getold = true
    players[p].warned = false
    players[p].camp_time = 0
end

function initPlayer(PlayerIndex, Init)
    if (PlayerIndex) then
        if (Init) then
            players[PlayerIndex] = {
                camp_time = 0,
                new = {}, old = {},
                name = get_var(PlayerIndex, "$name"),
            }
        else
            players[PlayerIndex] = nil
        end
    end
end

function getXYZ(PlayerIndex, PlayerObject)
    local coords, x, y, z = { }
    if player_alive(PlayerIndex) then
        local VehicleID = read_dword(PlayerObject + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            x, y, z = read_vector3d(PlayerObject + 0x5c)
        else
            coords.invehicle = true
            x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
        end
        coords.x, coords.y, coords.z = x, y, z
    end
    return coords
end

function killPlayer(p)
    local player = get_player(p)
    local OldValue = read_word(player + 0xD4)
    write_word(player + 0xD4, 0xFFFF)
    kill(p)
    write_word(player + 0xD4, OldValue)
end

function getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
end

function cls(p, count)
    count = count or 25
    for _ = 1, count do
        rprint(p, " ")
    end
end

function broadcast(message, player)
    for i = 1, 16 do
        if player_present(i) then
            if (i ~= player) then
                say(i, message)
            end
        end
    end
end

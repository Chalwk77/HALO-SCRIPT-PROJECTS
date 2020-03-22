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
-- Players will be warned (time_until_kill/2) seconds after entering (trigger_distance)
local warning_message = "Warning. You will be killed in %seconds% seconds for portal-camping. Move away!"
local on_kill_message = "You were killed for Portal Camping."
local trigger_distance = 3.5 -- world units
local portals = {
    ["beavercreek"] = {
        { 31.526, 13.809, -0.216 },
        { -3.347, 13.679, -0.216 }
    },
    ["bloodgulch"] = {
        { 82.828, -114.527, 0.702 },
        { 43.795, -126.231, 0.241 },
        { 95.584, -155.452, 1.807 },
        { 40.057, -82.916, 1.815 },
    },
    ["boardingaction"] = {
        { -2.576, 8.905, 5.219 },
        { -1.042, -8.182, 5.219 },
        { 1.952, -8.453, -4.778 },
        { 1.904, 9.036, -4.778 },
        { 18.125, 8.433, -4.778 },
        { 18.124, -9.037, -4.778 },
        { 22.608, -8.883, 5.219 },
        { 21.156, 8.195, 5.219 },
    },
    ["carousel"] = {
        { -0.016, 10.579, -0.855 },
        { -0.003, -11.537, -0.856 },
        { 8.031, 7.995, -3.349 },
        { -8.136, -8.111, -3.349 },
    },
    ["chillout"] = {
        { 11.173, 8.019, 0.001 },
        { 1.461, -4.204, 0.001 },
        { -4.811, 7.962, 0.502 },
        { -3.699, -0.415, 2.785 },
        { 7.278, 0.901, 2.382 },
        { 12.152, 2.636, 3.536 },
    },
    ["longest"] = {
        { "COORDINATES" }
    },
    ["dangercanyon"] = {
        { "COORDINATES" }
    },
    ["deathisland"] = {
        { "COORDINATES" }
    },
    ["gephyrophobia"] = {
        { "COORDINATES" }
    },
    ["icefields"] = {
        { "COORDINATES" }
    },
    ["infinity"] = {
        { "COORDINATES" }
    },
    ["sidewinder"] = {
        { "COORDINATES" }
    },
    ["timberland"] = {
        { "COORDINATES" }
    },
    ["hangemhigh"] = {
        { "COORDINATES" }
    },
    ["ratrace"] = {
        { -4.878, -16.255, -2.118 },
        { 8.945, -26.794, -3.611 },
        { 22.394, -5.786, -2.115 },
        { 8.383, -8.004, 0.223 }
    },
    ["damnation"] = {
        { "COORDINATES" }
    },
    ["putput"] = {
        { "COORDINATES" }
    },
    ["prisoner"] = {
        { "COORDINATES" }
    },
    ["wizard"] = {
        { "COORDINATES" }
    },
}
-- Configuration Ends --

-- Do not touch below this point (unless you know what you are doing)
local players, game_over, loc = {}
local delta_time = 1 / 30
local floor, gsub = math.floor, string.gsub

api_version = "1.12.0.0"
function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")

    if get_var(0, "$gt") ~= "n/a" then
        game_over, loc = false, portals[get_var(0, "$map")]
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end

function OnGameStart()
    game_over, loc = false, portals[get_var(0, "$map")]
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
    if (not game_over) and (loc) then
        for i, player in pairs(players) do
            if (i) then
                if player_present(i) and player_alive(i) then

                    local dynamic_player = get_dynamic_player(i)
                    if (dynamic_player ~= 0) then

                        local coords = getXYZ(dynamic_player)
                        if (coords) then
                            local x1, y1, z1 = coords.x, coords.y, coords.z
                            local count = 0
                            for j = 1, #loc do
                                local x2, y2, z2 = loc[j][1], loc[j][2], loc[j][3]
                                if CheckCoordinates(x1, y1, z1, x2, y2, z2) then
                                    count = count + 1
                                    if (player.init) then
                                        player.timer = player.timer + delta_time
                                        if (player.timer >= time_until_kill / 2) and (player.timer < time_until_kill) then
                                            cls(i, 25)
                                            local time_remaining = floor((time_until_kill - player.timer) + 1)
                                            local msg = gsub(warning_message, "%%seconds%%", time_remaining)
                                            rprint(i, msg)
                                        elseif (player.timer > time_until_kill) then
                                            cls(i, 25)
                                            player.init = false
                                            rprint(i, on_kill_message)
                                            execute_command("kill " .. i)
                                        end
                                    end
                                end
                            end
                            if (count == 0) then
                                player.timer = 0
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

function cls(PlayerIndex, count)
    count = count or 25
    for _ = 1, count do
        rprint(PlayerIndex, " ")
    end
end

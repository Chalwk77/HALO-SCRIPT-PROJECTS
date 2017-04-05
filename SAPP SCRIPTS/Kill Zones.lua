--[[
Script Name: Kill Zones, for SAPP - (PC|CE)

Description: When a player enters a kill zone, they have 15 seconds to exit otherwise they are killed.

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
]]--

api_version = "1.11.0.0"
coordiantes = { }
warning_timer = { }
players = { }
kill_timer = { }
kill_init_timer = { }

-- label                =       Kill Zone Label
-- x,y,z radius         =       Kill Zone coordinates. 
-- Warning Delay        =       Amount of time until player is warned after entering kil zone. 0 = warn immediately
-- Seconds until death  =       After entering Kill Zone, they have this many seconds to leave otherwise they are killed

-- Messages:
--      Warning! You have entered Kill Zone 1
--      You will be killed in 15 seconds if you don't leave this area
--      You were killed because you didn't leave Kill Zone 1 in time!

-- Messages will appear in the RCON console and will remain on screen until they leave the area.

--      label                      x,y,z                radius           Warning Dealy      Seconds until death
coordiantes["bloodgulch"] = {
    { "Kill Zone 1",      33.631, -65.569, 0.370,         5,                   0,                  15},
    { "Kill Zone 2",      41.703, -128.663, 0.247,        5,                   0,                  15},
    { "Kill Zone 3",      50.655, -87.787, 0.079,         5,                   0,                  15},
    { "Kill Zone 4",      101.940, -170.440, 0.197,       5,                   0,                  15},
    { "Kill Zone 5",      81.617, -116.049, 0.486,        5,                   0,                  15},
    { "Kill Zone 6",      78.208, -152.914, 0.091,        5,                   0,                  15},
    { "Kill Zone 7",      64.178, -176.802, 3.960,        5,                   0,                  15},
    { "Kill Zone 8",      102.312, -144.626, 0.580,       5,                   0,                  15},
    { "Kill Zone 9",      86.825, -172.542, 0.215,        5,                   0,                  15},
    { "Kill Zone 10",     65.846, -70.301, 1.690,         5,                   0,                  15},
    { "Kill Zone 11",     28.861, -90.757, 0.303,         5,                   0,                  15},
    { "Kill Zone 12",     46.341, -64.700, 1.113,         5,                   0,                  15},
}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    for i = 1,16 do
        if player_present(i) then
            warning_timer[i] = false
            local player_id = get_var(i, "$n")
            players[player_id].kill_timer = 0
            players[player_id].kill_init_timer = 0
        end
    end
end

function OnScriptUnload() end

function OnNewGame()
    mapname = get_var(0, "$map")
    for i = 1,16 do
        if player_present(i) then
            warning_timer[i] = false
            local player_id = get_var(i, "$n")
            players[player_id].kill_timer = 0
            players[player_id].kill_init_timer = 0
        end
    end
end

function OnGameEnd()
    for i = 1,16 do
        if player_present(i) then
            warning_timer[i] = false
            local player_id = get_var(i, "$n")
            players[player_id].kill_timer = 0
            players[player_id].kill_init_timer = 0
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    warning_timer[PlayerIndex] = false
    local player_id = get_var(PlayerIndex, "$n")
    players[player_id] = { }
    players[player_id].kill_timer = 0
    players[player_id].kill_init_timer = 0
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            local player_object = get_dynamic_player(i)
            if (player_object ~= 0) then
                if coordiantes[mapname] ~= nil then
                    for j = 1, #coordiantes[mapname] do
                        if coordiantes[mapname] ~= { } and coordiantes[mapname][j] ~= nil then
                            if inSphere(i, coordiantes[mapname][j][2], coordiantes[mapname][j][3], coordiantes[mapname][j][4], coordiantes[mapname][j][5]) == true then
                                local player_id = get_var(i, "$n")
                                players[player_id].kill_timer = players[player_id].kill_timer + 0.030
                                if players[player_id].kill_timer >= math.floor(coordiantes[mapname][j][6]) then
                                    ClearConsole(i)
                                    local minutes, seconds = secondsToTime(players[player_id].kill_timer, 2)
                                    warning_timer[i] = true
                                    rprint(i, "Warning! You have entered " .. tostring(coordiantes[mapname][j][1]) .. ".")
                                    rprint(i, "You will be killed in " .. coordiantes[mapname][j][7] - math.floor(seconds) .. " seconds if you don't leave this area!")
                                end
                                if (warning_timer[i] == true) then
                                    local player_id = get_var(i, "$n")
                                    players[player_id].kill_init_timer = players[player_id].kill_init_timer + 0.030
                                    if players[player_id].kill_init_timer >= math.floor(coordiantes[mapname][j][7]) then
                                        ClearConsole(i)
                                        warning_timer[i] = false
                                        players[player_id].kill_timer = 0
                                        players[player_id].kill_init_timer = 0
                                        execute_command("kill " ..i)
                                        rprint(i, "You were killed because you didn't leave " .. tostring(coordiantes[mapname][j][1]) .. " in time!")
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

function inSphere(PlayerIndex, x, y, z, radius)
    if PlayerIndex then
        local player_static = get_player(PlayerIndex)
        local obj_x = read_float(player_static + 0xF8)
        local obj_y = read_float(player_static + 0xFC)
        local obj_z = read_float(player_static + 0x100)
        local x_diff = x - obj_x
        local y_diff = y - obj_y
        local z_diff = z - obj_z
        local dist_from_center = math.sqrt(x_diff ^ 2 + y_diff ^ 2 + z_diff ^ 2)
        if dist_from_center <= radius then
            bool = true
        else
            bool = false
        end
    end
    return bool
end

function secondsToTime(seconds, places)
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60
    if places == 2 then
        return minutes, seconds
    end
end

function ClearConsole(PlayerIndex)
    for clear = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

function OnError(Message)
    print(debug.traceback())
end

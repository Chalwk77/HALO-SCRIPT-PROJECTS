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
kill_timer = { }
players = { }
warning_timer = { }
kill_init_timer = { }
-- ===================================================== CONFIGURATION STARTS ===================================================== --
-- label                =       Kill Zone Label
-- x,y,z radius         =       Kill Zone coordinates. 
-- Warning Delay        =       Amount of time until player is warned after entering kil zone. 0 = warn immediately
-- Seconds until death  =       After entering Kill Zone, they have this many seconds to leave otherwise they are killed

-- Messages:
--      Warning! You have entered Kill Zone 1
--      You will be  killed in X seconds if you don't leave this area

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
-- ===================================================== CONFIGURATION ENDS ======================================================= --
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    for i = 1,16 do
        if player_present(i) then
            -- reset timers --
            kill_timer[i] = false
            players[get_var(i, "$n")].warning_timer = 0
            players[get_var(i, "$n")].kill_init_timer = 0
        end
    end
end

function OnScriptUnload() end

function OnNewGame()
    mapname = get_var(0, "$map")
    for i = 1,16 do
        if player_present(i) then
            -- reset timers --
            kill_timer[i] = false
            players[get_var(i, "$n")].warning_timer = 0
            players[get_var(i, "$n")].kill_init_timer = 0
        end
    end
end

function OnGameEnd()
    for i = 1,16 do
        if player_present(i) then
            -- reset timers --
            kill_timer[i] = false
            players[get_var(i, "$n")].warning_timer = 0
            players[get_var(i, "$n")].kill_init_timer = 0
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    -- reset timers --
    kill_timer[PlayerIndex] = false
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].warning_timer = 0
    players[get_var(PlayerIndex, "$n")].kill_init_timer = 0
end

function OnPlayerLeave(PlayerIndex)
    -- reset timers --
    kill_timer[PlayerIndex] = false
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].warning_timer = 0
    players[get_var(PlayerIndex, "$n")].kill_init_timer = 0
end

function OnPlayerSpawn(PlayerIndex)
    -- reset timers --
    kill_timer[PlayerIndex] = false
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].warning_timer = 0
    players[get_var(PlayerIndex, "$n")].kill_init_timer = 0
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    -- reset timers --
    kill_timer[PlayerIndex] = false
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].warning_timer = 0
    players[get_var(PlayerIndex, "$n")].kill_init_timer = 0
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            local player_object = get_dynamic_player(i)
            if (player_object ~= 0) then
                -- validate coordiantes table
                if coordiantes[mapname] ~= nil then
                    if coordiantes[mapname] ~= { } and coordiantes[mapname][j] ~= nil then
                        for j = 1, #coordiantes[mapname] do
                            -- check if player is in kill zone
                            if inSphere(i, coordiantes[mapname][j][2], coordiantes[mapname][j][3], coordiantes[mapname][j][4], coordiantes[mapname][j][5]) == true then
                                -- create new warning timer --
                                players[get_var(i, "$n")].warning_timer = players[get_var(i, "$n")].warning_timer + 0.030
                                -- monitor warning timer until it reaches the value of "Warning Dealy" (coordiantes[mapname][j][6])
                                if players[get_var(i, "$n")].warning_timer >= math.floor(coordiantes[mapname][j][6]) then
                                    -- clear the player's console to prevent duplicate messages (spam)
                                    ClearConsole(i)
                                    local minutes, seconds = secondsToTime(players[get_var(i, "$n")].warning_timer, 2)
                                    -- initiate kill timer
                                    kill_timer[i] = true
                                    -- send player the warning
                                    rprint(i, "Warning! You have entered " .. tostring(coordiantes[mapname][j][1]) .. ".")
                                    rprint(i, "You will be killed in " .. coordiantes[mapname][j][7] - math.floor(seconds) .. " seconds if you don't leave this area!")
                                end
                                if (kill_timer[i] == true) then
                                    -- create new kill timer
                                    players[get_var(i, "$n")].kill_init_timer = players[get_var(i, "$n")].kill_init_timer + 0.030
                                    -- monitor killer timer until it reaches the value of "Seconds until death" (coordiantes[mapname][j][7])
                                    if players[get_var(i, "$n")].kill_init_timer >= math.floor(coordiantes[mapname][j][7]) then
                                        -- clear the player's console to prevent duplicate messages (spam)
                                        ClearConsole(i)
                                        -- reset timers --
                                        kill_timer[i] = false
                                        players[get_var(i, "$n")].warning_timer = 0
                                        players[get_var(i, "$n")].kill_init_timer = 0
                                        -- kill Player
                                        execute_command("kill " ..i)
                                        -- send player the unfateful message
                                        rprint(i, "You were killed because you didn't leave the kill zone")
                                    end
                                end
                            else
                                -- reset timers --
                                kill_timer[i] = false
                                players[get_var(i, "$n")].warning_timer = 0
                                players[get_var(i, "$n")].kill_init_timer = 0
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
            return true
        end
    end
    return false
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

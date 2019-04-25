--[[
--=====================================================================================================--
Script Name: Restart Mapcycle (utility), for SAPP (PC & CE)
Description: This mod will restart the mapcycle if the server has been empty for "duration" seconds.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

-- Configuration [starts]
-- If the server is empty, the mapcycle will be reset after "duration" seconds:
local duration = 300 -- (in seconds) 300 = 5 minutes

-- Command to execute:
local sapp_command = "mapcycle_begin"
-- Configuration [ends]

local script_version = "1.0"
local player_count, countdown, init_timer
local function playerCount()
    if (player_count ~= nil) then
        return tonumber(player_count)
    end
end

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_TICK"], "OnTick")

    player_count, countdown, init_timer = 0, 0

    for i = 1, 16 do
        if player_present(i) then
            player_count = player_count + 1
        end
    end
end

function OnScriptUnload()
    --
end

function OnPlayerConnect(p)
    player_count = player_count + 1
end

function OnPlayerDisconnect(p)
    player_count = player_count - 1
    if (playerCount() <= 0) then

        -- Ensures player count never goes into negatives
        player_count = 0

        -- Initialize Countdown Timer
        init_timer = true
    end
end

local floor = math.floor
local function CountdownLoop()
    countdown = countdown + 0.030

    -- Debugging:
    -- cprint("Time Remaining: " .. duration - floor(countdown))

    if (countdown >= (duration)) then
        countdown = 0
        init_timer = false
        execute_command(sapp_command)
        cprint("RESTARTING MAP...", 2 + 8)
    end
end

function OnTick()
    if (playerCount() <= 0) and (init_timer) then
        CountdownLoop()
    end
end

function report()
    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. script_version, 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)
end

function OnError()
    cprint(debug.traceback(), 4 + 8)
    timer(50, "report")
end

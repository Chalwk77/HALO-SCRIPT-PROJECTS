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
-- If the server is empty, the mapcycle will be restarted after "duration" seconds:
local duration = 90 -- (in seconds) 90 = one-and-a-half minutes

-- Command to execute:
local sapp_command = "mapcycle_begin"
-- Configuration [ends]

local script_version = "1.2"
local player_count, countdown, init_timer
local _debug_ = false

local function playerCount()
    if (player_count ~= nil) then
        return tonumber(player_count)
    end
end

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    register_callback(cb["EVENT_TICK"], "OnTick")
    
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    
    -- These variables are semi-redundant in OnScriptLoad() because they are being declared in OnGameStart().
    -- But necessary if the server is configured such that it doesn't end the current game and reload a new map.
    -- To do: Write a listener function for "/reload" command.
    player_count, countdown, init_timer = 0, 0

    for i = 1, 16 do
        if player_present(i) then
            player_count = player_count + 1
        end
    end
end

function OnGameStart()
    player_count, countdown, init_timer = 0, 0
end

local function stopTimer()
    -- Reset timer variables
    init_timer, countdown = false, 0
end

function OnGameEnd()
    player_count = 0
    if (init_timer) then
        stopTimer()
        
        -- Debugging:
        if (_debug_) then
            cprint("Countdown stopped", 5+8)
        end
    end
end

function OnScriptUnload()
    --
end

function OnPlayerConnect(p)
    player_count = player_count + 1
    if (init_timer) then
        stopTimer()
        
        -- Debugging:
        if (_debug_) then
            cprint("Countdown stopped", 5+8)
        end
    end
end

function OnPlayerDisconnect(p)
    player_count = player_count - 1
    if (playerCount() <= 0) then
    
        -- 1). Ensures player count never goes into negatives.
        -- 2). Initialize Countdown Timer.
        player_count, init_timer = 0, true
    end
end

local floor = math.floor
local function CountdownLoop()
    countdown = countdown + 0.030
    
    -- Debugging:
    if (_debug_) then
        cprint("Restarting Mapcycle in: " .. duration - floor(countdown) .. " seconds", 5+8)
    end
    
    -- 1). Monitors elapsed time.
    -- 2). Stops the 'timer' when 'countdown' is equal-to-or-greater-than the value of 'duration'.
    -- 3). Executes the 'sapp_command'.
    if (countdown >= (duration)) then
        stopTimer()
        execute_command(sapp_command)
        cprint("RESTARTING MAP CYCLE. Please wait...", 2 + 8)
    end
end

function OnTick()
    
    -- 1). Determines whether the server is empty. 
    -- 2). Listens for the 'go-ahead' ("init_timer" [bool]) to initialize the countdown timer.
    if (playerCount() <= 0) and (init_timer) then
        CountdownLoop()
    end
end

-- In the event of an error, the script will trigger these two functions: OnError(), report()
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

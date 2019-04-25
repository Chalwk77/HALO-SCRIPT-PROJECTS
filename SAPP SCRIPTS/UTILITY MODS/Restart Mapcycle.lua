--[[
--=====================================================================================================--
Script Name: Restart Mapcycle (utility), for SAPP (PC & CE)
Description: This mod will restart the mapcycle if the server has been empty for "time_remaining" seconds.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

-- Configuration [starts]
-- If the server is empty, the mapcycle will be restarted after "time_remaining" minutes/seconds has elapsed:
local time_remaining = 1.5 * 60 -- one-and-a-half minutes

-- Command to execute:
local sapp_command = "mapcycle_begin"

-- Message output when "time_remaining" has elapsed
local on_restart = "RESTARTING MAP CYCLE. Please wait..."
-- Configuration [ends]


local script_version = "1.3" -- For error reporting
local player_count, init_timer
local original_time = time_remaining
local _debug_ = true

-- Returns the current player count
local function playerCount()
    if (player_count ~= nil) then
        return tonumber(player_count)
    end
end

function OnScriptLoad()
    
    -- Register needed event callbacks:
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    register_callback(cb["EVENT_TICK"], "OnTick")
    
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    --
    
    
    -- These variables are semi-redundant in OnScriptLoad() because they are being declared in OnGameStart().
    -- But necessary if the server is configured such that it doesn't end the current game and reload a new map.
    -- To do: Write a listener function for "/reload" command.
    player_count, time_remaining, init_timer = 0, original_time
    
    for i = 1, 16 do
        if player_present(i) then
            player_count = player_count + 1
        end
    end
end

function OnGameStart()
    -- Reset timer and player count variables
    player_count, time_remaining, init_timer = 0, original_time
end

local function stopTimer()
    -- Reset timer variables
    init_timer, time_remaining = false, original_time
end

function OnGameEnd()
    -- Reset player count.
    player_count = 0
    
    -- If the countdown timer is already running when the game ends, stop it.
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

local floor, format = math.floor, string.format
local function CountdownLoop()
  
    -- 1). Monitors elapsed time.
    -- 2). Stops the 'timer' when 'time_remaining' has elapsed.
    -- 3). Executes the 'sapp_command'.
	time_remaining = time_remaining - 0.030
	local minutes, seconds = floor( time_remaining / 60 ), time_remaining % 60
	local time = format( "%02d:%02d", minutes, seconds )

    if (time ~= nil) then
        if (time <= "0") then
            stopTimer()
            execute_command(sapp_command)
            cprint(on_restart, 2 + 8)
        elseif (_debug_) then
            -- Debugging:
            cprint("Restarting Mapcycle in: " .. time .. " seconds", 5+8)
        end
    end
end

-- OnTick() | Called every 1/30 seconds. (Similar to Phasor's OnClientUpdate function)
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

-- This function will return a string with a traceback of the stack call.
function OnError()
    cprint(debug.traceback(), 4 + 8)
    
    -- Calls function 'report' after 50 milliseconds
    timer(50, "report")
end

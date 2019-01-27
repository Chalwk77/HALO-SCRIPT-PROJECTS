--[[
--=====================================================================================================--
Script Name: Countdown Timer, for SAPP (PC & CE)
Description: N/A

Call "startTimer()" to initiate the countdown.
Call "stopTimer()" to cancel the countdown and reset the clock to 0.

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts]

time_until_gamestarts = 5 -- In Seconds

-- Configuration [ends] << ----------

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    
    register_callback(cb["EVENT_GAME_START"], "OnNewGame")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
end

function OnNewGame()
    startTimer()
end

function OnGameEnd()
    stopTimer()
end

function OnTick()
    if (init_gamestart == true) then
        countdown = countdown + 0.030
        local seconds = secondsToTime(countdown)
        delay = time_until_gamestarts - math.floor(seconds)
        cprint("Game will begin in " .. delay .. " seconds", 4+8)
        if (time_until_gamestarts - math.floor(seconds) <= 0) then
            cprint("The game has begun!", 2+8)
            stopTimer()
            ----------
            -- DO SOMETHING HERE
            ----------
        end
    end
end

function secondsToTime(seconds)
    seconds = seconds % 60
    return seconds
end

function startTimer()
    countdown = 0
    init_gamestart = true
end

function stopTimer()
    countdown = 0
    init_gamestart = false
    -- if delay ~= nil then
        -- cprint("The countdown was stopped at " .. delay .. " seconds")
    -- end
end

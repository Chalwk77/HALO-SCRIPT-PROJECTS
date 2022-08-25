--[[
--=====================================================================================================--
Script Name: Countdown Timer, for SAPP (PC & CE)
Description: N/A

Call "startTimer()" to initiate the countdown.
Call "stopTimer()" to cancel the countdown and reset the clock to 0.

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts]

local delay = 5 -- In Seconds

-- Configuration [ends] << ----------

local init
local original_delay = delay

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnStart")
    register_callback(cb["EVENT_GAME_END"], "OnEnd")
    OnStart()
end

function OnStart()
    init = false
    if (get_var(0, '$gt') ~= 'n/a') then
        init = true
        timer(1000, 'Counter')
    end
end

function OnEnd()
    init = false
end

local function TimerRemaining(seconds)
    seconds = seconds % 60
    return seconds
end

function Counter()

    if (not init) then
        return false
    end

    delay = delay - 1
    local time = TimerRemaining(delay)
    cprint('Game will begin in ' .. time .. ' seconds', 12)

    if (delay == 0) then
        cprint('The game has begun!', 10)

        delay = original_delay
        ----------
        -- DO SOMETHING HERE
        ----------
        return false
    end

    return (init and delay > 0)
end

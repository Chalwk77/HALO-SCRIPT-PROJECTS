--[[
--=====================================================================================================--
Script Name: Countdown Timer, for SAPP (PC & CE)
Description: This script is intended for use by other developers.

             It provides a simple way to display a countdown timer in the following format:
             "Game will being in: %02d seconds".

             This script is not intended to be used as a standalone script.

Copyright (c) 2016-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local delay = 5
local output = "Game will being in: %02d seconds"

local timer

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

local time = os.time
local function NewTimer()
    return {
        start = time,
        finish = time() + delay
    }
end

function OnStart()
    timer = (get_var(0, '$gt') ~= 'n/a') and NewTimer() or nil
end

function OnEnd()
    timer = nil
end

local format = string.format
local function TimerRemaining(s)
    s = s % 60
    return format(output, s)
end

local function Say(p, m)
    for _ = 1, 25 do
        rprint(p, ' ')
    end
    rprint(p, m)
end

function OnTick()
    if (timer and timer.start() >= timer.finish) then
        timer = nil
        -----------------------
        -- DO SOMETHING HERE --
        -----------------------
    elseif (timer) then
        for i = 1, 16 do
            if player_present(i) then
                Say(i, TimerRemaining(timer.finish - time()))
            end
        end
    end
end
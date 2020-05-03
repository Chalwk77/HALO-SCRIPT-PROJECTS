--[[
--=====================================================================================================--
Script Name: Random Broadcast, for SAPP (PC & CE)
Description: This mod will randomly broadcast a message to the server.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local settings = {

    -- When a new game begins, the initial interval until a message broadcast event occurs
    -- is a randomly chosen number between the min and max times (in seconds).

    -- When a broadcast event occurs, the interval is randomized once again (a time between min/max)
    -- See below:

    min_time = 30,
    max_time = 300,

    messages = {
        "Line 1",
        "Line 2",
        "Line 3",
        -- Repeat the structure to add more message entries!
    }
}

-- Do Not Touch anything below this line!

local gameover

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    if (get_var(0, "$gt") ~= "n/a") then
        ResetTimer(false)
    end
end

function OnGameStart()
    ResetTimer(false)
end

function OnGameEnd()
    ResetTimer(true)
end

function OnTick()
    if (settings.timer and not gameover) and (tonumber(get_var(0, "$pn")) > 0) then
        settings.timer = settings.timer + 1 / 30
        if (math.floor(settings.timer) == settings.interval) then
            say_all(settings.messages[settings.message_index])
            ResetTimer(false)
        end
    end
end

function ResetTimer(GameOver)

    if (GameOver) then
        gameover = true
    end

    math.randomseed(os.clock())

    settings.timer = 0
    settings.interval = math.random(settings.min_time, settings.max_time)
    settings.message_index = math.random(#settings.messages)
end

function OnScriptUnload()

end


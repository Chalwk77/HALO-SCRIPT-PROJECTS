--[[
--=====================================================================================================--
Script Name: Auto Message (utility), for SAPP (PC & CE)
Description: This mod will cycle (in order | first to last) through a list of pre-defined messages and broadcast them every x seconds.

You can broadcast a message on demand with /broadcast [id].
Command Syntax: 
    /broadcast list
        * will output in the following format:
        -------- MESSAGES --------
        [1] line 1
        [2] line 2
        [3] etc...
    /broadcast [id]
    

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts]
prefix = "[Broadcast] "

-- #messages
-- You can specify where the message will be displayed on a per-message basis (rcon or global chat)
-- At the very beginning of each line, either put %rcon% or %chat% (self-explanatory?)
-- If the line doesn't have either of these identifiers then the script will throw a formatting error (by design).
-- When a message is broadcast, the identifiers will not be visible.
announcements = {
    "%rcon% The first announcement",
    "%rcon% The second announcement",
    "%rcon% The third announcement",
    "%chat% The fourth announcement",
    "%chat% The fifth announcement",
    "%chat% The sixth announcement"
    -- Make sure the last entry in the table doesn't have a comma.
    -- Repeat the structure to add more entries.
}

-- How long should rcon-bound messages be displayed on screen for? (in seconds) --
display_duration = 10

-- Message Alignment (for rcon messages):
-- Left = l,    Right = r,    Center = c,    Tab: t
message_alignment = "t"
-- Configuration [ends] -------------------------

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    -- stop timer
end

function OnNewGame()
    -- start timer
end

function OnGameEnd()
    -- stop timer
end

function OnTick()
    -- broadcast logic
    
end

-- Clear 
function cls()
    for i = 1,16 do
        if player_present(i) then
            for _ = 1, 25 do
                rprint(i, " ")
            end
        end
    end
end

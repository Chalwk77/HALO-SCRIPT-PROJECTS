--[[
------------------------------------
Script Name: Taunt OnGameEnd (messages), for SAPP | (PC\CE)
    - Implementing API version: 1.11.0.0

Description: This script will display taunting messages to the player when the game ends.

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]-- 

api_version = "1.11.0.0"

function OnScriptUnload() end

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
end

function OnGameEnd(PlayerIndex)
    local kills = tonumber(get_var(PlayerIndex,"$kills")
    if kills == 0 then
        say(PlayerIndex, "You have no kills... noob alert!")
    elseif kills == 1 then
        say(PlayerIndex, "One kill? You must be new at this...")
    elseif kills == 2 then
        say(PlayerIndex, "Eh, two kills... not bad. But you still suck!")
    elseif kills == 3 then
        say(PlayerIndex, "Relax sonny! 3 kills, and you be like... mad bro?")
    elseif kills == 4 then
        say(PlayerIndex, "Dun dun dun... them 4 kills though!")
    elseif kills > 4 then
        say(PlayerIndex, "Well, you've got more than 4 kills... #AchievingTheImpossible")
    end
end

function OnError(Message)
    print(debug.traceback())
end
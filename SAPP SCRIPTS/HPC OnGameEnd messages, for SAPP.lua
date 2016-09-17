--[[
------------------------------------
Script Name: HPC OnGameEnd messages, for SAPP
    - Implementing API version: 1.10.0.0

Description: This script will display taunting messages to the player when the game ends.

-- To do:

        From a table, have it say any 1 of 100+ (random)
        taunting phrases about the persons play style

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.10.0.0"

function OnScriptUnload()

end

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
end

function OnGameEnd(PlayerIndex)

    local m_player = getplayer(PlayerIndex)
    if m_player then
        local kills = tonumber(read_word(m_player + 0x9C))
        if kills == 0 then
            say(PlayerIndex, "You have no kills... noob alert!")
        end
        if kills == 1 then
            say(PlayerIndex, "One kill? You must be new at this...")
        end
        if kills == 2 then
            say(PlayerIndex, "Eh, two kills... not bad. But you still suck.")
        end
        if kills == 3 then
            say(PlayerIndex, "Relax sonny! 3 kills, and you be like... mad bro?")
        end
        if kills == 4 then
            say(PlayerIndex, "Dun dun dun... them 4 kills though!")
        end
        if kills > 4 then
            say(PlayerIndex, "Well, you've got more than 4 kills... #AchievingTheImpossible")
        end
    end
end

function getplayer(PlayerIndex)
    if tonumber(PlayerIndex) then
        if tonumber(PlayerIndex) ~= 0 then
            local m_player = get_player(PlayerIndex)
            if m_player ~= 0 then return m_player end
        end
    end
    return nil
end

function OnError(Message)
    print(debug.traceback())
end

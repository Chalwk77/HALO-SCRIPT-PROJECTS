--[[
--=====================================================================================================--
Script Name: Dynamic Scoring (utility), for SAPP (PC & CE)
Description: Scorelimit changes automatically, depending on number of players currently online.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

Inspiration taken from a mod made by {OZ}Shadow.

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

-- Configuration [starts] ------------------------
api_version = "1.12.0.0"

local scorelimit = { }
scorelimit[1] = 15 -- 4 Players or less
scorelimit[2] = 25 -- 4-8 players
scorelimit[3] = 35 -- 8-12 players
scorelimit[4] = 50 -- 12-16 players
scorelimit.txt = "Score limit changed to: %scorelimit%"
-- Configuration [ends] ------------------------

local current_players, current_scorelimit = nil, nil

local function Reset()
    current_players, current_scorelimit = 0, 0
end

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    Reset()
    for i = 1, 16 do
        if player_present(i) then
            current_players = current_players + 1
        end
    end
    modifyScore()
end

function OnGameStart()
    setScore(scorelimit[1])
end

function OnGameEnd()
    Reset()
end

function OnScriptUnload()
    -- not used
end

function OnPlayerConnect(PlayerIndex)
    current_players = current_players + 1
    modifyScore()
end

function OnPlayerDisconnect(PlayerIndex)
    current_players = current_players - 1
    modifyScore()
end

function modifyScore()
    if (current_players <= 4 and current_scorelimit ~= scorelimit[1]) then
        setScore(scorelimit[1])
        say_all(string.gsub(scorelimit.txt, "%%scorelimit%%", scorelimit[1]))

    elseif (current_players > 4 and current_players <= 8 and current_scorelimit ~= scorelimit[2]) then
        setScore(scorelimit[2])
        say_all(string.gsub(scorelimit.txt, "%%scorelimit%%", scorelimit[2]))

    elseif (current_players > 9 and current_players <= 12 and current_scorelimit ~= scorelimit[3]) then
        setScore(scorelimit[3])
        say_all(string.gsub(scorelimit.txt, "%%scorelimit%%", scorelimit[3]))

    elseif (current_players > 12 and current_scorelimit ~= scorelimit[4]) then
        setScore(scorelimit[4])
        say_all(string.gsub(scorelimit.txt, "%%scorelimit%%", scorelimit[4]))
    end
end

function setScore(score)
    current_scorelimit = score
    execute_command("scorelimit " .. score)
end

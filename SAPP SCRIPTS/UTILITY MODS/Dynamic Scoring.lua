--[[
--=====================================================================================================--
Script Name: Dynamic Scoring (utility), for SAPP (PC & CE)
Description: Scorelimit changes automatically, depending on number of players currently online.

* Updated 6/09/19
- Scoring is now set on a per-gametype/per-gamemode basis.


Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

Inspiration taken from a mod made by {OZ}Shadow.

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

-- Configuration [starts] ----------------------------------------
api_version = "1.12.0.0"
local scorelimit, scoreTable = { }

-- CAPTURE THE FLAG ----------------------------------------------------
scorelimit.ctf = {
    [1] = 3, -- 4 players or less
    [2] = 5, -- 4-8 players
    [3] = 7, -- 8-12 players
    [4] = 9, -- 12-16 players
    txt = "Score limit changed to: %scorelimit%",
}

-- SLAYER ----------------------------------------------------
scorelimit.slayer = {
    {   -- FFA:
        [1] = 15, -- 4 players or less
        [2] = 25, -- 4-8 players
        [3] = 45, -- 8-12 players
        [4] = 50, -- 12-16 players
        txt = "Score limit changed to: %scorelimit%"
    },
    {   -- TEAM:
        [1] = 25, -- 4 players or less
        [2] = 35, -- 4-8 players
        [3] = 45, -- 8-12 players
        [4] = 50, -- 12-16 players
        txt = "Score limit changed to: %scorelimit%"
    }
}

-- KING OF THE HILL ----------------------------------------------------
scorelimit.king = {
    {   -- FFA
        [1] = 2, -- 4 players or less
        [2] = 3, -- 4-8 players
        [3] = 4, -- 8-12 players
        [4] = 5, -- 12-16 players
        txt = "Score limit changed to: %scorelimit% minute%s%"
    },
    {   -- TEAM
        [1] = 3, -- 4 players or less
        [2] = 4, -- 4-8 players
        [3] = 5, -- 8-12 players
        [4] = 6, -- 12-16 players
        txt = "Score limit changed to: %scorelimit% minute%s%"
    }
}

-- ODDBALL ----------------------------------------------------
scorelimit.oddball = {
    {   -- FFA
        [1] = 2, -- 4 players or less
        [2] = 3, -- 4-8 players
        [3] = 4, -- 8-12 players
        [4] = 5, -- 12-16 players
        txt = "Score limit changed to: %scorelimit% minute%s%"
        
    },
    {   -- TEAM
        [1] = 3, -- 4 players or less
        [2] = 4, -- 4-8 players
        [3] = 5, -- 8-12 players
        [4] = 6, -- 12-16 players
        txt = "Score limit changed to: %scorelimit% minute%s%"
        
    }
}

-- RACE ----------------------------------------------------
scorelimit.race = {
    {   -- FFA
        [1] = 3, -- 4 players or less
        [2] = 4, -- 4-8 players
        [3] = 5, -- 8-12 players
        [4] = 6, -- 12-16 players
        txt = "Score limit changed to: %scorelimit% lap%s%"
    },
    {   -- TEAM
        [1] = 4, -- 4 players or less
        [2] = 5, -- 4-8 players
        [3] = 6, -- 8-12 players
        [4] = 7, -- 12-16 players
        txt = "Score limit changed to: %scorelimit% lap%s%"
    }
}

-- Configuration [ends] ----------------------------------------

local current_players, current_scorelimit = nil, nil

function scorelimit.Reset()
    current_players, current_scorelimit = 0, 0
end

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    scorelimit.Reset()
    
    if (get_var(0, "$gt") ~= "n/a") then
        for i = 1, 16 do
            if player_present(i) then
                current_players = current_players + 1
            end
        end
        
        scorelimit.Modify()
    end
end

function OnGameStart()

    -- Returns the current game type:
    local gametype = get_var(0, "$gt")
    
    -- Returns TRUE if team based gamemode.
    local function isTeamPlay()
        if (get_var(0, "$ffa") == "0") then
            return true
        end
    end
    
    -- Determine what scorelimit table to use:
    if (gametype == "ctf") then   
        scoreTable = scorelimit.ctf
    elseif (gametype == "slayer") then
        if isTeamPlay() then
            scoreTable = scorelimit.slayer[1]
        else
            scoreTable = scorelimit.slayer[2]
        end
    elseif (gametype == "king") then
        if isTeamPlay() then
            scoreTable = scorelimit.king[1]
        else
            scoreTable = scorelimit.king[2]
        end
    elseif (gametype == "oddball") then
        if isTeamPlay() then
            scoreTable = scorelimit.oddball[1]
        else
            scoreTable = scorelimit.oddball[2]
        end
    elseif (gametype == "race") then
        if isTeamPlay() then
            scoreTable = scorelimit.race[1]
        else
            scoreTable = scorelimit.race[2]
        end
    end
    
    -- Set initial scorelimit:
    scorelimit.Set(scoreTable[1])
end

function OnGameEnd()
    scorelimit.Reset()
end

function OnScriptUnload()
    -- not used
end

function OnPlayerConnect(PlayerIndex)
    -- Increment player count by 1
    current_players = current_players + 1
end

function OnPlayerDisconnect(PlayerIndex)
    -- Decrement player count by 1
    current_players = current_players - 1
    scorelimit.Modify()
end

-- Determine whether to pluralize 'lap' or 'minute' input (text) from scoreTable.txt:
local function getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
end

-- Update the current scorelimit (based on current player count)
function scorelimit.Modify()
    local gsub = string.gsub
    if (current_players <= 4 and current_scorelimit ~= scoreTable[1]) then
        scorelimit.Set(scoreTable[1])
        
        local char = getChar(scoreTable[1])
        say_all(gsub(gsub(scoreTable.txt, "%%scorelimit%%", scoreTable[1]), "%%s%%", char))

    elseif (current_players > 4 and current_players <= 8 and current_scorelimit ~= scoreTable[2]) then
        scorelimit.Set(scoreTable[2])
        
        local char = getChar(scoreTable[2])
        say_all(gsub(gsub(scoreTable.txt, "%%scorelimit%%", scoreTable[2]), "%%s%%", char))

    elseif (current_players > 9 and current_players <= 12 and current_scorelimit ~= scoreTable[3]) then
        scorelimit.Set(scoreTable[3])
        
        local char = getChar(scoreTable[3])
        say_all(gsub(gsub(scoreTable.txt, "%%scorelimit%%", scoreTable[3]), "%%s%%", char))

    elseif (current_players > 12 and current_scorelimit ~= scoreTable[4]) then
        scorelimit.Set(scoreTable[4])
        
        local char = getChar(scoreTable[4])
        say_all(gsub(gsub(scoreTable.txt, "%%scorelimit%%", scoreTable[4]), "%%s%%", char))
    end
end

-- Execute SAPP command 'scorelimit' to change the current scorelimit
function scorelimit.Set(score)
    current_scorelimit = score
    execute_command("scorelimit " .. score)
end

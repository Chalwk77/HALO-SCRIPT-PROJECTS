--[[
--=====================================================================================================--
Script Name: Dynamic Scoring (utility), for SAPP (PC & CE)
Description: Scorelimit changes automatically, depending on number of players currently online.

Copyright (c) 2019-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
Inspiration taken from a mod made by {OZ}Shadow.
* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local ScoreLimit = {

    -- Configuration [starts] -----------------------------------

    -- CAPTURE THE FLAG -------------------------------------
    ctf = {
        { 1, 4, 1 }, -- 4 players or less
        { 5, 8, 2 }, -- 4-8 players
        { 9, 12, 3 }, -- 8-12 players
        { 13, 16, 4 }, -- 12-16 players
        txt = "Score limit changed to: %limit%",
    },

    -- SLAYER -----------------------------------------------
    slayer = {
        {   -- FFA:
            [1] = { 1, 4, 15 }, -- 4 players or less
            [2] = { 5, 8, 25 }, -- 4-8 players
            [3] = { 9, 12, 45 }, -- 8-12 players
            [4] = { 13, 16, 50 }, -- 12-16 players
            txt = "Score limit changed to: %limit%"
        },
        {   -- TEAM:
            [1] = { 1, 4, 25 }, -- 4 players or less
            [2] = { 5, 8, 35 }, -- 4-8 players
            [3] = { 9, 12, 45 }, -- 8-12 players
            [4] = { 13, 16, 50 }, -- 12-16 players
            txt = "Score limit changed to: %limit%"
        }
    },

    -- KING OF THE HILL -------------------------------------
    king = {
        {   -- FFA

            [1] = { 1, 4, 2 }, -- 4 players or less
            [2] = { 5, 8, 3 }, -- 4-8 players
            [3] = { 9, 12, 4 }, -- 8-12 players
            [4] = { 13, 16, 5 }, -- 12-16 players
            txt = "Score limit changed to: %limit% minute%s%"
        },
        {   -- TEAM
            [1] = { 1, 4, 3 }, -- 4 players or less
            [2] = { 5, 8, 4 }, -- 4-8 players
            [3] = { 9, 12, 5 }, -- 8-12 players
            [4] = { 13, 16, 6 }, -- 12-16 players
            txt = "Score limit changed to: %limit% minute%s%"
        }
    },

    -- ODDBALL ----------------------------------------------
    oddball = {
        {   -- FFA
            [1] = { 1, 4, 2 }, -- 4 players or less
            [2] = { 5, 8, 3 }, -- 4-8 players
            [3] = { 9, 12, 4 }, -- 8-12 players
            [4] = { 13, 16, 5 }, -- 12-16 players
            txt = "Score limit changed to: %limit% minute%s%"

        },
        {   -- TEAM
            [1] = { 1, 4, 3 }, -- 4 players or less
            [2] = { 5, 8, 4 }, -- 4-8 players
            [3] = { 9, 12, 5 }, -- 8-12 players
            [4] = { 13, 16, 6 }, -- 12-16 players
            txt = "Score limit changed to: %limit% minute%s%"

        }
    },

    -- RACE -------------------------------------------------
    race = {
        {   -- FFA
            [1] = { 1, 4, 4 }, -- 4 players or less
            [2] = { 5, 8, 4 }, -- 4-8 players
            [3] = { 9, 12, 5 }, -- 8-12 players
            [4] = { 13, 16, 6 }, -- 12-16 players
            txt = "Score limit changed to: %limit% lap%s%"
        },
        {   -- TEAM
            [1] = { 1, 4, 4 }, -- 4 players or less
            [2] = { 5, 8, 5 }, -- 4-8 players
            [3] = { 9, 12, 6 }, -- 8-12 players
            [4] = { 13, 16, 7 }, -- 12-16 players
            txt = "Score limit changed to: %limit% lap%s%"
        }
    }
}
-- Configuration [ends] ----------------------------------------

function OnScriptLoad()

    ScoreLimit:Reset()

    if (get_var(0, "$gt") ~= "n/a") then
        for i = 1, 16 do
            if player_present(i) then
                self.players = self.players + 1
            end
        end

        OnGameStart()
    end

    register_callback(cb["EVENT_GAME_END"], "Reset")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
end

function OnScriptUnload()
    -- N/A
end

--
-- Returns true if team based game:
--
local function isTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
    end
end

--
-- Determine whether to pluralize 'lap' or 'minute' input text from ScoreLimit.scoretable.txt:
--
local function getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
end

--
-- Determine what score table to use:
--
function ScoreLimit:SetScoreTable()

    local mode = get_var(0, "$gt")

    if (mode == "ctf") then
        self.scoretable = self.ctf
    elseif (mode == "slayer") then
        if isTeamPlay() then
            self.scoretable = self.slayer[1]
        else
            self.scoretable = self.slayer[2]
        end
    elseif (mode == "king") then
        if isTeamPlay() then
            self.scoretable = self.king[1]
        else
            self.scoretable = self.king[2]
        end
    elseif (mode == "oddball") then
        if isTeamPlay() then
            self.scoretable = self.oddball[1]
        else
            self.scoretable = self.oddball[2]
        end
    elseif (mode == "race") then
        if isTeamPlay() then
            self.scoretable = self.race[1]
        else
            self.scoretable = self.race[2]
        end
    end
end

--
-- Set up score table to use for this game:
--
function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        ScoreLimit:SetScoreTable()
        ScoreLimit:Modify()
    end
end

--
-- Increment player count by 1
--
function OnPlayerConnect(_)
    ScoreLimit.players = ScoreLimit.players + 1
    ScoreLimit:Modify()
end

--
-- Decrement player count by 1
--
function OnPlayerDisconnect(_)
    ScoreLimit.players = ScoreLimit.players - 1
    ScoreLimit:Modify()
end

--
-- Updates the current score limit (based on current player count)
--
local gsub = string.gsub
function ScoreLimit:Modify()
    for _, v in pairs(self.scoretable) do
        if (type(v) == "table") then
            local min, max, limit = v[1], v[2], v[3]
            if (self.players >= min and self.players <= max or self.players == 0) and (limit ~= self.limit) then

                ScoreLimit:Set(limit)

                local txt = self.scoretable.txt
                local str = gsub(gsub(txt, "%%limit%%", limit), "%%s%%", getChar(limit))
                say_all(str)

                cprint("---------------------------", 10)
                cprint(str, 10)
                cprint("---------------------------", 10)

                break
            end
        end
    end
end

--
-- Execute SAPP command 'scorelimit' to change the current scorelimit
--
function ScoreLimit:Set(s)
    self.limit = s
    execute_command("scorelimit " .. s)
end

function ScoreLimit:Reset()
    ScoreLimit.scoretable = { }
    ScoreLimit.players, ScoreLimit.limit = 0, 0
end

function Reset()
    return ScoreLimit:Reset()
end

return ScoreLimit
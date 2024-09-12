--[[
--=====================================================================================================--
Script Name: Dynamic Scoring, for SAPP (PC & CE)
Description: Automatically changes the score limit depending on the number of players currently online.

            Supports custom game mode overrides.
            If your game mode is not configured in the score_limits table,
            the server will use the pre-configured game type table instead.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local score_limits = {
    -- config starts --

    -- The following variables can be used in custom messages:
    -- $limit   = the new score limit
    -- $s       = word pluralization character (s) (applies to minutes and laps)

    -- Format:
    -- { min players, max players, score limit }

    -------------------------------------------------------------
    -- CUSTOM GAME MODE TABLES:
    -------------------------------------------------------------

    ['example_game_mode'] = { -- replace with your own game mode name
        { 1, 4, 25 }, -- 1-4 players
        { 5, 8, 35 }, -- 5-8 players
        { 9, 12, 45 }, -- 9-12 players
        { 13, 16, 50 }, -- 13-16 players
        'Score limit changed to: $limit'
    },

    ['another_example_game_mode'] = {
        { 1, 4, 25 }, -- 1-4 players
        { 5, 8, 35 }, -- 5-8 players
        { 9, 12, 45 }, -- 9-12 players
        { 13, 16, 50 }, -- 13-16 players
        'Score limit changed to: $limit'
    },

    -- repeat the above structure to add more game mode entries.

    -------------------------------------------------------------
    -- DEFAULT GAME TYPE TABLES:
    -------------------------------------------------------------

    ctf = {
        {
            { 1, 4, 1 }, -- 1-4 players
            { 5, 8, 2 }, -- 5-8 players
            { 9, 12, 3 }, -- 9-12 players
            { 13, 16, 4 }, -- 13-16 players
            'Score limit changed to: $limit'
        }
    },

    slayer = {
        {   -- FFA:
            { 1, 4, 15 }, -- 1-4 players
            { 5, 8, 25 }, -- 5-8 players
            { 9, 12, 45 }, -- 9-12 players
            { 13, 16, 50 }, -- 13-16 players
            'Score limit changed to: $limit'
        },
        {   -- TEAM:
            { 1, 4, 25 }, -- 1-4 players
            { 5, 8, 35 }, -- 5-8 players
            { 9, 12, 45 }, -- 9-12 players
            { 13, 16, 50 }, -- 13-16 players
            'Score limit changed to: $limit'
        }
    },

    king = {
        {   -- FFA:
            { 1, 4, 2 }, -- 1-4 players
            { 5, 8, 3 }, -- 5-8 players
            { 9, 12, 4 }, -- 9-12 players
            { 13, 16, 5 }, -- 13-16 players
            'Score limit changed to: $limit minute$s'
        },
        {   -- TEAM:
            { 1, 4, 3 }, -- 1-4 players
            { 5, 8, 4 }, -- 5-8 players
            { 9, 12, 5 }, -- 9-12 players
            { 13, 16, 6 }, -- 13-16 players
            'Score limit changed to: $limit minute$s'
        }
    },

    oddball = {
        {   -- FFA:
            { 1, 4, 2 }, -- 1-4 players
            { 5, 8, 3 }, -- 5-8 players
            { 9, 12, 4 }, -- 9-12 players
            { 13, 16, 5 }, -- 13-16 players
            'Score limit changed to: $limit minute$s'
        },
        {   -- TEAM:
            { 1, 4, 3 }, -- 1-4 players
            { 5, 8, 4 }, -- 5-8 players
            { 9, 12, 5 }, -- 9-12 players
            { 13, 16, 6 }, -- 13-16 players
            'Score limit changed to: $limit minute$s'
        }
    },

    race = {
        {   -- FFA:
            { 1, 4, 4 }, -- 1-4 players
            { 5, 8, 4 }, -- 5-8 players
            { 9, 12, 5 }, -- 9-12 players
            { 13, 16, 6 }, -- 13-16 players
            'Score limit changed to: $limit lap$s'
        },
        {   -- TEAM:
            { 1, 4, 4 }, -- 1-4 players
            { 5, 8, 5 }, -- 5-8 players
            { 9, 12, 6 }, -- 9-12 players
            { 13, 16, 7 }, -- 13-16 players
            'Score limit changed to: $limit lap$s'
        }
    }
}
-- config ends --

local score_table, current_limit

-- Register script events
function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

-- Set the score table based on the game mode or game type
local function SetScoreTable(mode, game_type)
    score_table = score_limits[mode]
    if not score_table then
        local ffa = (get_var(0, '$ffa') == '1')
        score_table = (ffa and score_limits[game_type][1]) or score_limits[game_type][2]
    end
end

-- Get the pluralization character
local function get_char(n)
    return (n > 1 and 's') or ''
end

-- Generate the message to be displayed
local function GenerateMessage(limit)
    local message = score_table[#score_table]
    return message:gsub('$limit', limit):gsub('$s', get_char(limit))
end

-- Modify the score limit based on the number of players
local function Modify(isQuit)
    if score_table then
        for _, v in ipairs(score_table) do
            local min, max, limit = v[1], v[2], v[3]
            local players = tonumber(get_var(0, '$pn'))

            if min and ((isQuit and players - 1 >= min) or players >= min) and players <= max and limit ~= current_limit then
                current_limit = limit
                execute_command('scorelimit ' .. limit)
                local txt = GenerateMessage(limit)
                say_all(txt)
                cprint(txt, 10)
            end
        end
    end
end

-- Handle game start event
function OnStart()
    score_table, current_limit = nil, nil
    local game_type = get_var(0, '$gt')
    local mode = get_var(0, '$mode')

    if game_type ~= 'n/a' then
        SetScoreTable(mode, game_type)
        Modify()
    end
end

-- Handle game end event
function OnEnd()
    score_table = nil
end

-- Handle player join event
function OnJoin()
    Modify()
end

-- Handle player leave event
function OnQuit()
    Modify(true)
end

-- Placeholder function for script unload event
function OnScriptUnload()
    -- N/A
end
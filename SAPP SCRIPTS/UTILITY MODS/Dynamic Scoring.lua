--[[
--=====================================================================================================--
Script Name: Dynamic Scoring, for SAPP (PC & CE)
Description: Automatically changes the score limit depending on the number of players currently online.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local score_limits = {

    -- config starts --

    -- Format:
    -- { min players, max players, score limit }
    --

    -- CAPTURE THE FLAG -------------------------------------
    ctf = {
        {
            { 1, 4, 1 }, -- 1-4 players
            { 5, 8, 2 }, -- 5-8 players
            { 9, 12, 3 }, -- 9-12 players
            { 13, 16, 4 }, -- 13-16 players
            "Score limit changed to: $limit",
        }
    },

    -- SLAYER -----------------------------------------------
    slayer = {
        {   -- FFA:
            { 1, 4, 15 }, -- 1-4 players
            { 5, 8, 25 }, -- 5-8 players
            { 9, 12, 45 }, -- 9-12 players
            { 13, 16, 50 }, -- 13-16 players
            "Score limit changed to: $limit"
        },
        {   -- TEAM:
            { 1, 4, 25 }, -- 1-4 players
            { 5, 8, 35 }, -- 5-8 players
            { 9, 12, 45 }, -- 9-12 players
            { 13, 16, 50 }, -- 13-16 players
            "Score limit changed to: $limit"
        }
    },

    -- KING OF THE HILL -------------------------------------
    king = {
        {   -- FFA
            { 1, 4, 2 }, -- 1-4 players
            { 5, 8, 3 }, -- 5-8 players
            { 9, 12, 4 }, -- 9-12 players
            { 13, 16, 5 }, -- 13-16 players
            "Score limit changed to: $limit minute$s"
        },
        {   -- TEAM
            { 1, 4, 3 }, -- 1-4 players
            { 5, 8, 4 }, -- 5-8 players
            { 9, 12, 5 }, -- 9-12 players
            { 13, 16, 6 }, -- 13-16 players
            "Score limit changed to: $limit minute$s"
        }
    },

    -- ODDBALL ----------------------------------------------
    oddball = {
        {   -- FFA
            { 1, 4, 2 }, -- 1-4 players
            { 5, 8, 3 }, -- 5-8 players
            { 9, 12, 4 }, -- 9-12 players
            { 13, 16, 5 }, -- 13-16 players
            "Score limit changed to: $limit minute$s"

        },
        {   -- TEAM
            { 1, 4, 3 }, -- 1-4 players
            { 5, 8, 4 }, -- 5-8 players
            { 9, 12, 5 }, -- 9-12 players
            { 13, 16, 6 }, -- 13-16 players
            "Score limit changed to: $limit minute$s"
        }
    },

    -- RACE -------------------------------------------------
    race = {
        {   -- FFA
            { 1, 4, 4 }, -- 1-4 players
            { 5, 8, 4 }, -- 5-8 players
            { 9, 12, 5 }, -- 9-12 players
            { 13, 16, 6 }, -- 13-16 players
            "Score limit changed to: $limit lap$s"
        },
        {   -- TEAM
            { 1, 4, 4 }, -- 1-4 players
            { 5, 8, 5 }, -- 5-8 players
            { 9, 12, 6 }, -- 9-12 players
            { 13, 16, 7 }, -- 13-16 players
            "Score limit changed to: $limit lap$s"
        }
    }
}
-- config ends --

local score_table, current_limit

function OnScriptLoad()

    register_callback(cb["EVENT_JOIN"], "OnJoin")
    register_callback(cb["EVENT_LEAVE"], "OnQuit")
    register_callback(cb["EVENT_GAME_END"], "OnEnd")
    register_callback(cb["EVENT_GAME_START"], "OnStart")

    OnStart()
end

local function SetScoreTable(gt)
    local ffa = (get_var(0, "$ffa") == "1")
    score_table = (ffa and score_limits[gt][1]) or score_limits[gt][2]
end

local function getChar(n)
    return (n > 1 and "s") or ""
end

local function Modify(QUIT)

    if (score_table) then

        for _, v in pairs(score_table) do
            local min, max, limit = v[1], v[2], v[3]
            if (min) then

                local n = tonumber(get_var(0, "$pn"))

                -- Technical note:
                -- When a player quits, the $pn variable does not update immediately.
                -- So we have to manually deduct one from the player count.

                -- @Param QUIT is true when a player disconnects from the server.
                -- We use this to determine when to deduct one from n.
                --
                n = (QUIT and n - 1) or n

                if (n >= min and n <= max and limit ~= current_limit) then

                    current_limit = limit
                    execute_command("scorelimit " .. limit)

                    local txt = score_table[#score_table]
                    txt = txt:gsub("$limit", limit):gsub("$s", getChar(limit))

                    say_all(txt)
                    cprint(txt, 10)

                    break
                end
            end
        end
    end
end

function OnStart()
    score_table, current_limit = nil, nil
    local gt = get_var(0, "$gt")
    if (gt ~= "n/a") then
        SetScoreTable(gt)
        Modify()
    end
end

function OnEnd()
    score_table = nil
end

function OnJoin()
    Modify()
end

function OnQuit()
    Modify(true)
end

function OnScriptUnload()
    -- N/A
end
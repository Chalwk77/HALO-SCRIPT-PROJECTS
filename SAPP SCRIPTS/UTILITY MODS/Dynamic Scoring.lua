--[[
--=====================================================================================================--
Script Name: Dynamic Scoring, for SAPP (PC & CE)
Description: The score limit will change automatically depending on number of players currently online.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local ScoreLimit = {

    -- config starts --

    -- Format:
    -- { min players, max players, score limit }
    --

    -- CAPTURE THE FLAG -------------------------------------
    ctf = {
        { 1, 4, 1 }, -- 1-4 players
        { 5, 8, 2 }, -- 5-8 players
        { 9, 12, 3 }, -- 9-12 players
        { 13, 16, 4 }, -- 13-16 players
        "Score limit changed to: $limit",
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

function OnScriptLoad()

    ScoreLimit.limit = nil
    ScoreLimit.scoretable = nil

    register_callback(cb["EVENT_JOIN"], "OnJoin")
    register_callback(cb["EVENT_LEAVE"], "OnQuit")
    register_callback(cb["EVENT_GAME_START"], "OnStart")

    OnStart()
end

function ScoreLimit:SetScoreTable(gt)
    local ffa = (get_var(0, "$ffa") == "1")
    self.scoretable = (not ffa and self[gt][1]) or self[gt][2]
end

function OnStart()
    local mode = get_var(0, "$gt")
    if (mode ~= "n/a") then
        ScoreLimit:SetScoreTable(mode)
        ScoreLimit:Modify()
    end
end

function OnJoin(_)
    ScoreLimit:Modify()
end

function OnQuit(_)
    ScoreLimit:Modify(true)
end

local function getChar(n)
    return (n > 1 and "s") or ""
end

function ScoreLimit:Modify(QUIT)
    for _, v in pairs(self.scoretable) do
        local min, max, limit = v[1], v[2], v[3]
        if (min) then

            local n = tonumber(get_var(0, "$pn"))
            n = (QUIT and n - 1) or n

            if (n >= min and n <= max and limit ~= self.limit) then

                self.limit = limit
                execute_command("scorelimit " .. limit)

                local txt = self.scoretable[5]
                txt = txt:gsub("$limit", limit):gsub("$s", getChar(limit))
                say_all(txt)

                cprint("---------------------------", 10)
                cprint(txt, 10)
                cprint("---------------------------", 10)

                break
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end

-- For a future update:
return ScoreLimit
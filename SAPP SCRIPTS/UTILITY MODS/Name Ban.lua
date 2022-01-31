--[[
--=====================================================================================================--
Script Name: Name Ban, for SAPP (PC & CE)
Description: The most advanced name-ban script that exists.

This script uses a pattern matching algorithm that matches all possible permutations
of letters in a name based on the patterns table (see below).

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

-- This script will kick or ban a player if they use a vulgar name:
-- Valid actions: "kick" or "ban"
--
local action = "k"

-- Ban time (in minutes), requires action to be set to "ban".
--
local time = 10

-- Kick reason:
--
local reason = "Inappropriate name. Please change it!"

local banned_names = {
    "penis",
    "nigger",
    --
    -- repeat the structure to add more names
    --
}

local patterns = {
    ["a"] = { "[aA@]" },
    ["b"] = { "[bB]" },
    ["c"] = { "[cCkK]" },
    ["d"] = { "[dD]" },
    ["e"] = { "[eE3]" },
    ["f"] = { "[fF]" },
    ["g"] = { "[gG6]" },
    ["h"] = { "[hH]" },
    ["i"] = { "[iIl!1]" },
    ["j"] = { "[jJ]" },
    ["k"] = { "[cCkK]" },
    ["l"] = { "[lL1!i]" },
    ["m"] = { "[mM]" },
    ["n"] = { "[nN]" },
    ["o"] = { "[oO0]" },
    ["p"] = { "[pP]" },
    ["q"] = { "[qQ9]" },
    ["r"] = { "[rR]" },
    ["s"] = { "[sS$5]" },
    ["t"] = { "[tT7]" },
    ["u"] = { "[uUvV]" },
    ["v"] = { "[vVuU]" },
    ["w"] = { "[wW]" },
    ["x"] = { "[xX]" },
    ["y"] = { "[yY]" },
    ["z"] = { "[zZ2]" },
}

api_version = "1.12.0.0"

local bad_names = { }

function OnScriptLoad()

    action = (action == "kick" and 'k $n "' .. reason .. '"' or 'ipban $n ' .. time .. ' "' .. reason .. '"')

    for _, name in pairs(banned_names) do

        local word = ""
        local t = string.totable(name)

        for _, char in pairs(t) do
            if (patterns[char]) then
                for k, v in pairs(patterns[char]) do
                    if (patterns[char][k]) then
                        word = word .. v
                    end
                end
            end
        end
        table.insert(bad_names, word)
    end

    register_callback(cb["EVENT_JOIN"], "OnJoin")
end

function string.totable(str)
    local t = {}
    for i = 1, str:len() do
        table.insert(t, str:sub(i, i))
    end
    return t
end

local function NameIsBanned(name)
    for _, v in pairs(bad_names) do
        if name:match(v) then
            return true
        end
    end
    return false
end

function OnJoin(Ply)
    local name = get_var(Ply, "$name")
    if NameIsBanned(name) then
        local cmd = action:gsub("$n", Ply)
        execute_command(cmd)
    end
end

function OnScriptUnload()
    -- N/A
end
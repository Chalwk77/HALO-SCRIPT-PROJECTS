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
local action = "kick"

-- Ban time (in minutes), requires action to be set to "ban".
--
local time = 10

-- Action reason:
--
local reason = "Inappropriate name. Please change it!"

-- List of names to kick/ban:
--
local banned_names = {
    "penis",
    "nigger",
    --
    -- repeat the structure to add more names
    --
}

-- Advanced users only:
--
local patterns = {
    ["a"] = { "[aA@ÀÂÃÄÅ]" },
    ["b"] = { "[bBßḄɃḂ]" },
    ["c"] = { "[cCkKÇ]" },
    ["d"] = { "[dDĐĎɗḏ]" },
    ["e"] = { "[eE3Èé]" },
    ["f"] = { "[fFḟḞƒƑ]" },
    ["g"] = { "[gG6ǵĝĠĞ]" },
    ["h"] = { "[hHĤȞĥĦḪ]" },
    ["i"] = { "[iIl!1Ì]" },
    ["j"] = { "[jJɈɉǰĴĵ]" },
    ["k"] = { "[cCkKǨƙķḲ]" },
    ["l"] = { "[lL1!i£]" },
    ["m"] = { "[mMḿḾṀṃṂ]" },
    ["n"] = { "[nNñÑ]" },
    ["o"] = { "[oO0Ò]" },
    ["p"] = { "[pPþᵽṗṕ]" },
    ["q"] = { "[qQ9Ɋɋ]" },
    ["r"] = { "[rR®ȐŖ]" },
    ["s"] = { "[sS$5ŜṤŞṩ]" },
    ["t"] = { "[tT7ƬṬțṰ]" },
    ["u"] = { "[vVuUÙ]" },
    ["v"] = { "[vVuUÙṼṾṽ]" },
    ["w"] = { "[wWŴẄẆⱳ]" },
    ["x"] = { "[xXẌẍẊẋ]" },
    ["y"] = { "[yYýÿÝ]" },
    ["z"] = { "[zZ2ẑẐȥ]" },
}

-- config ends --

api_version = "1.12.0.0"

local bad_names = { }

function OnScriptLoad()

    action = (action == "kick" and 'k $n' or 'ipban $n ' .. time) .. ' "' .. reason .. '"'

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
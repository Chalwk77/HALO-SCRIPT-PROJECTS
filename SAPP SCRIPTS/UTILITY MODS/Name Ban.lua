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

local function StringToTable(str)
    local t = {}
    for i = 1, str:len() do
        t[#t + 1] = str:sub(i, i)
    end
    return t
end

function OnScriptLoad()

    action = (action == "kick" and 'k $n' or 'ipban $n ' .. time) .. ' "' .. reason .. '"'

    for i = 1, #banned_names do

        local word = ""
        local name = banned_names[i]
        local t = StringToTable(name)

        for j = 1, #t do
            local char = t[j]
            if (patterns[char]) then
                for k, v in pairs(patterns[char]) do
                    if (patterns[char][k]) then
                        word = word .. v
                    end
                end
            end
        end
        bad_names[#bad_names + 1] = word
    end

    register_callback(cb["EVENT_JOIN"], "OnJoin")
end

local function NameIsBanned(Ply)
    local name = get_var(Ply, "$name")
    for i = 1, #bad_names do
        if name:match(bad_names[i]) then
            return true
        end
    end
    return false
end

function OnJoin(Ply)
    if NameIsBanned(Ply) then
        execute_command(action:gsub("$n", Ply))
    end
end

function OnScriptUnload()
    -- N/A
end
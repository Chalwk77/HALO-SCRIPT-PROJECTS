--[[
--=====================================================================================================--
Script Name: Name Ban, for SAPP (PC & CE)
Description: The most advanced name-ban script that exists.

This script uses a pattern matching algorithm that matches all possible permutations
of letters in a name based on the patterns table (see below).

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

-- This script will kick or ban a player if they use a vulgar name:
-- Valid actions: "kick" or "ban"
--
local action = 'kick'

-- Ban time (in minutes), requires action to be set to "ban".
--
local time = 10

-- Action reason:
--
local reason = 'Inappropriate name. Please change it!'

-- List of names to kick/ban:
--
local banned_names = {
    'penis',
    'nigger',
    --
    -- repeat the structure to add more names
    --
}

-- Advanced users only:
-- Patterns to detect variations of names.
--
local patterns = {
    ['a'] = { '[aA@ÀÂÃÄÅ]' },
    ['b'] = { '[bBßḄɃḂ]' },
    ['c'] = { '[cCkKÇ]' },
    ['d'] = { '[dDĐĎɗḏ]' },
    ['e'] = { '[eE3Èé]' },
    ['f'] = { '[fFḟḞƒƑ]' },
    ['g'] = { '[gG6ǵĝĠĞ]' },
    ['h'] = { '[hHĤȞĥĦḪ]' },
    ['i'] = { '[iIl!1Ì]' },
    ['j'] = { '[jJɈɉǰĴĵ]' },
    ['k'] = { '[cCkKǨƙķḲ]' },
    ['l'] = { '[lL1!i£]' },
    ['m'] = { '[mMḿḾṀṃṂ]' },
    ['n'] = { '[nNñÑ]' },
    ['o'] = { '[oO0Ò]' },
    ['p'] = { '[pPþᵽṗṕ]' },
    ['q'] = { '[qQ9Ɋɋ]' },
    ['r'] = { '[rR®ȐŖ]' },
    ['s'] = { '[sS$5ŜṤŞṩ]' },
    ['t'] = { '[tT7ƬṬțṰ]' },
    ['u'] = { '[vVuUÙ]' },
    ['v'] = { '[vVuUÙṼṾṽ]' },
    ['w'] = { '[wWŴẄẆⱳ]' },
    ['x'] = { '[xXẌẍẊẋ]' },
    ['y'] = { '[yYýÿÝ]' },
    ['z'] = { '[zZ2ẑẐȥ]' },
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
        local name = banned_names[i]
        local t = StringToTable(name)
        local pattern = ''
        for j = 1, #t do
            local letter = t[j]
            if (patterns[letter]) then
                pattern = pattern .. patterns[letter][1]
            else
                pattern = pattern .. letter
            end
        end
        bad_names[#bad_names + 1] = pattern
    end

    register_callback(cb["EVENT_JOIN"], "OnJoin")
end

function OnJoin(Ply)
    local cmd = action
    local name = get_var(Ply, '$name')
    for i = 1, #bad_names do
        local pattern = bad_names[i]
        if (name:match(pattern)) then
            execute_command(cmd:gsub('$n', Ply))
            break
        end
    end
end

function OnScriptUnload()
    -- N/A
end
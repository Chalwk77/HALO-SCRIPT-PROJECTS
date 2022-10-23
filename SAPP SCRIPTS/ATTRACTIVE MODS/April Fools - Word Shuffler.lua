--[[
--=====================================================================================================--
Script Name: April Fools - Word Shuffler, for SAPP (PC & CE)
Description: Chat messages will randomly be shuffled.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- 1 in X chance of a message being shuffled:
local chance = 1

-- A message relay function temporarily removes the msg_prefix and
-- will restore it to this when done:
local prefix = '**SAPP**'

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], 'OnChat')
end

local insert = table.insert
local concat = table.concat
local random = math.random

local function shuffle(s)
    math.randomseed(os.time())
    local letters = {}
    for letter in s:gmatch '.[\128-\191]*' do
        insert(letters, { letter = letter, rnd = random() })
    end
    table.sort(letters, function(a, b)
        return a.rnd < b.rnd
    end)

    for i = 1,#letters do
        letters[i] = letters[i].letter
    end

    return concat(letters)
end

function OnChat(Ply, Msg, Type)
    if (rand(1, chance + 1) == 1) then

        local new_message = shuffle(Msg)
        local name = get_var(Ply, '$name')
        execute_command('msg_prefix ""')
        if (Type == 0) then
            say_all(name .. ': ' .. new_message)
        elseif (Type == 1 or Type == 2) then
            say_all('[' .. name .. ']: ' .. new_message)
        end
        execute_command('msg_prefix "' .. prefix .. '"')
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
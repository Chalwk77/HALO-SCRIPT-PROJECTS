--[[
--======================================================================================================--
Script Name: April Fools - Word Shuffler, for SAPP (PC & CE)
Description: Your chat messages will be shuffled...

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

-- Config [starts]--------------------------------
local server_prefix = "** LNZ ** "
-- Config [ends]----------------------------------

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_CHAT"], "OnPlayerChat")
end

function OnScriptUnload()

end

function OnPlayerChat(PlayerIndex, Message, Type)
    if (Type ~= 6) then
        local new_message = shuffle(Message)
        local name = get_var(PlayerIndex, "$name")
        execute_command("msg_prefix \"\"")
        if (Type == 0) then
            say_all(name .. ": " .. new_message)
        elseif (Type == 1 or Type == 2) then
            say_all("[" .. name .. "]: " .. new_message)
        end
        execute_command("msg_prefix \" " .. server_prefix .. "\"")
        return false
    end
end

function shuffle(String)
    math.randomseed(os.time())
    local letters = {}
    for letter in String:gmatch '.[\128-\191]*' do
        table.insert(letters, { letter = letter, rnd = math.random() })
    end
    table.sort(letters, function(a, b)
        return a.rnd < b.rnd
    end)
    for i, v in ipairs(letters) do
        letters[i] = v.letter
    end
    return table.concat(letters)
end
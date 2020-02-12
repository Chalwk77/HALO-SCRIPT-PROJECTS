--[[
--======================================================================================================--
Script Name: April Fools - Chat, for SAPP (PC & CE)
Description: Other players will start speaking for you....

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

api_version = "1.12.0.0"

-- Config [starts]--------------------------------

-- Insert your server prefix here:
local server_prefix = "** LNZ ** "
local trigger_words = { "that", "que" }
-- Config [ends]----------------------------------

local modify_chat
local gmatch = string.gmatch

function OnScriptLoad()
    register_callback(cb["EVENT_CHAT"], "OnPlayerChat")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    if (get_var(0, "$gt") ~= nil) then
        modify_chat = false
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= nil) then
        modify_chat = false
    end
end

function OnScriptUnload()
    -- N/A
end

function OnPlayerChat(PlayerIndex, Message, Type)
    if (Type ~= 6) then
        local Str = stringSplit(Message)

        for i = 1, #Str do
            for j = 1, #trigger_words do
                if (Str[i] == trigger_words[j]) then
                    if (not modify_chat) then
                        modify_chat = true
                    else
                        modify_chat = false
                    end
                end
            end
        end

        if (modify_chat) then
            local new_player = GetPlayers(PlayerIndex)
            if (new_player) then
                local name = get_var(new_player, "$name")
                execute_command("msg_prefix \"\"")
                if (Type == 0) then
                    say_all(name .. ": " .. Message)
                elseif (Type == 1 or Type == 2) then
                    say_all("[" .. name .. "]: " .. Message)
                end
                execute_command("msg_prefix \" " .. server_prefix .. "\"")
                return false
            end
        end
    end
end

function GetPlayers(ExcludeIndex)
    local players = {}
    for i = 1, 16 do
        if player_present(i) then
            if (ExcludeIndex ~= i) then
                players[#players + 1] = i
            end
        end
    end
    return players[rand(1, #players)]
end

function stringSplit(Str)
    local t, i = {}, 1
    for Words in gmatch(Str, "([^%s]+)") do
        t[i] = Words
        i = i + 1
    end
    return t
end
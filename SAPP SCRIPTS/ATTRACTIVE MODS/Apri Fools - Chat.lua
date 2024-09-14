--[[
--======================================================================================================--
Script Name: April Fools - Chat, for SAPP (PC & CE)
Description: Other players will start speaking for you....

Copyright (c) 2020-2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--======================================================================================================--
]]--

api_version = "1.12.0.0"

-- Config [starts]--------------------------------

-- Insert your server prefix here:
local server_prefix = "**SAPP** "
local trigger_words = { "that", "que" }
local permission_level = 1
-- Config [ends]----------------------------------

local modify_chat = false

-- Function to split a string by spaces
local function stringSplit(str)
    local t = {}
    for arg in str:gmatch('([^%s]+)') do
        t[#t + 1] = arg
    end
    return t
end

-- Function to check if a message is a chat command
local function chatCommand(message)
    return message:sub(1, 1) == "/" or message:sub(1, 1) == "\\"
end

-- Function to get a random player ID excluding the given player ID
local function getPlayers(excludeId)
    local players = {}
    for i = 1, 16 do
        if player_present(i) and i ~= excludeId then
            players[#players + 1] = i
        end
    end
    return players[rand(1, #players + 1)]
end

-- Function to check if a player has the required permission level
local function checkChatPermissions(level)
    local hasPermission = level and level >= permission_level
    modify_chat = hasPermission and not modify_chat
    return modify_chat
end

-- Function to modify the chat message
local function modifyChatMessage(playerId, message)
    local newPlayerId = getPlayers(playerId)
    if newPlayerId then
        local newPlayerName = get_var(newPlayerId, "$name")
        execute_command('msg_prefix ""')
        say_all(newPlayerName .. ": " .. message)
        execute_command('msg_prefix "' .. server_prefix .. '"')
        return false
    end
    return true
end

-- Event handler for chat messages
function OnChat(playerId, message, type)
    if type == 6 or chatCommand(message) then
        return true
    end

    local level = tonumber(get_var(playerId, "$lvl"))
    local Str = stringSplit(message)
    for _, word in pairs(Str) do
        for _, trigger_word in pairs(trigger_words) do
            if word == trigger_word then
                if checkChatPermissions(level) then
                    return modifyChatMessage(playerId, message)
                end
            end
        end
    end
    return true
end

-- Event handler for script load
function OnScriptLoad()
    register_callback(cb["EVENT_CHAT"], "OnChat")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    if (get_var(0, "$gt") ~= nil) then
        modify_chat = false
    end
end

-- Event handler for game start
function OnGameStart()
    if (get_var(0, "$gt") ~= nil) then
        modify_chat = false
    end
end

-- Event handler for script unload
function OnScriptUnload()
    -- N/A
end
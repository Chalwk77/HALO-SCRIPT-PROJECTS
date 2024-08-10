--[[
--=====================================================================================================--
Script Name: Chat IDs.lua, for SAPP (PC & CE)
Description: Appends the player id to their message.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local chat = {
    -- global:
    [0] = "$name [$id]: $msg",

    -- team:
    [1] = "[$name] [$id]: $msg",

    -- vehicle:
    [2] = "[$name] [$id]: $msg",

    -- The server prefix is temporarily removed
    -- and will be restored after formatting the chat message:
    server_prefix = "**SAPP**"
}

api_version = "1.12.0.0"

-- Register the callback when the script is loaded
function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], 'ShowChatIDs')
end

-- Check if a message is a chat command
local function isCommand(msg)
    return (msg:sub(1, 1) == '/' or msg:sub(1, 1) == '\\')
end

-- Display chat messages with IDs
function ShowChatIDs(playerId, msg, type)

    -- Check if the message is not a chat command
    if not isCommand(msg) then

        -- Get player variables
        local name = get_var(playerId, '$name')
        local team = get_var(playerId, '$team')

        -- Get the chat message template and replace placeholders
        local formattedMsg = chat[type]
        formattedMsg = formattedMsg:gsub('$name', name):gsub('$msg', msg):gsub('$id', playerId)

        -- Temporarily remove the server prefix
        execute_command('msg_prefix ""')

        -- Send the message to the appropriate recipients
        if type == 0 then
            say_all(formattedMsg)
        elseif type == 1 or type == 2 then
            for i = 1, 16 do
                if player_present(i) and get_var(i, '$team') == team then
                    say(i, formattedMsg)
                end
            end
        end

        -- Restore the server prefix
        execute_command('msg_prefix "' .. chat.server_prefix .. ' "')
        return false
    end
end

-- No additional actions required when the script is unloaded
function OnScriptUnload()
    -- N/A
end


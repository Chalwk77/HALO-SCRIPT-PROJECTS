--[[
--=====================================================================================================--
Script Name: Chat IDs.lua, for SAPP (PC & CE)
Description: Appends the player id to their message.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local Chat = {

    -- global:
    [0] = "$name [$id]: $msg",

    -- team:
    [1] = "[$name] [$id]: $msg",

    -- vehicle:
    [2] = "[$name] [$id]: $msg",


    -- The server prefix is temporarily removed
    -- and will restored to this after formatting the chat message:
    server_prefix = "**SAPP**"
}

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], 'ShowChatIDs')
end

local function IsChatCMD(msg)
    return (msg:sub(1, 1) == '/' or msg:sub(1, 1) == '\\') or false
end

function ShowChatIDs(Ply, Msg, Type)
    if (not IsChatCMD(Msg)) then

        local name = get_var(Ply, '$name')
        local team = get_var(Ply, '$team')

        local msg = Chat[Type]
        msg = msg:gsub('$name', name):gsub('$msg', Msg):gsub('$id', Ply)

        execute_command('msg_prefix ""')
        if (Type == 0) then
            say_all(msg)
        elseif (Type == 1 or Type == 2) then
            for i = 1, 16 do
                if player_present(i) and get_var(i, '$team') == team then
                    say(i, msg)
                end
            end
        end
        execute_command('msg_prefix "' .. Chat.server_prefix .. ' "')
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
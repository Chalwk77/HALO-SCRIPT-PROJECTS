--[[
--=====================================================================================================--
Script Name: Admin Join Messages, for SAPP (PC & CE)
Description: Customize admin join messages on a per-admin-level basis.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--
api_version = "1.11.0.0"

messages = {}

-- output: [prefix] [player name] [message]
messages[1] = {"[ADMIN IN TRAINING] ",       " joined the server like a boss"}
messages[2] = {"[MODERATOR]",               " joined with a vengeance"}
messages[3] = {"[ADMIN]",                   " joined like a pro admin"}
messages[4] = {"[SENIOR ADMIN]",            " joined the server"}


function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
end

function OnScriptUnload()
    
end

function OnPlayerJoin(PlayerIndex)
    local _message
    for k,v in pairs(messages) do
        if (tonumber(get_var(PlayerIndex, "$lvl"))) == 1 then
            _message = messages[1][1] .. get_var(PlayerIndex, "$name") .. messages[1][2]
            
        elseif (tonumber(get_var(PlayerIndex, "$lvl"))) == 2 then
            _message = messages[2][1] .. get_var(PlayerIndex, "$name") .. messages[1][2]
            
        elseif (tonumber(get_var(PlayerIndex, "$lvl"))) == 3 then
            _message = messages[3][1] .. get_var(PlayerIndex, "$name") .. messages[1][2]
            
        elseif (tonumber(get_var(PlayerIndex, "$lvl"))) == 4 then
            _message = messages[4][1] .. get_var(PlayerIndex, "$name") .. messages[4][2]
        else 
            return false
        end
    end
    announceJoin(_message)
end

function announceJoin(_message)
    for i = 1,16 do
        if player_present(i) then
            rprint(i, _message)
        end
    end
end


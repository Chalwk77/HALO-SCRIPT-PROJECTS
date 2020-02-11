--[[
--======================================================================================================--
Script Name: April Fools - Chat, for SAPP (PC & CE)
Description: Other players will say speak for you...

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

api_version = "1.12.0.0"

-- Config: Insert your server prefix here:
local server_prefix = "** LNZ ** "
-- Config Ends

function OnScriptLoad()
    register_callback(cb["EVENT_CHAT"], "OnPlayerChat")
end

function OnScriptUnload()
    -- N/A
end

function OnPlayerChat(PlayerIndex, Message, Type)
    if (Type ~= 6) then
        local new_player = GetPlayers(PlayerIndex)
        print(new_player)
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
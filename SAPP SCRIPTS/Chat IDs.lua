--[[
------------------------------------
Script Name: ChatIDs, for SAPP | (PC\CE)
    - Implementing API version: 1.11.0.0

Description:  This script will modify your players message chat format
              by adding an IndexID in front of their name in square brackets.

Team output: [Chalwk] [1]: This is a test message
Global output: Chalwk [1]: This is a test message

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]--

api_version = "1.11.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    TeamPlay = CheckIfTeamPlay()
end

function OnScriptUnload() end

function OnNewGame()
    TeamPlay = CheckIfTeamPlay()
end

function OnPlayerChat(PlayerIndex, Message, type)
    local response = nil
    local text = tokenizestring(Message)
    if #text == 0 then 
        return nil 
    end
    if string.sub(text[1], 1, 1) == "/" or string.sub(text[1], 1, 1) == "\\" then 
        return true 
    end
    for i = 0, #text do
        if text[i] then
            if TeamPlay then
                if type == 0 or type == 2 then
                    SendToAll(get_var(PlayerIndex, "$name") .. " [" .. get_var(PlayerIndex, "$n") .. "]: " .. tostring(Message), PlayerIndex)
                    response = false
                elseif type == 1 then
                    SendToTeam("[" .. get_var(PlayerIndex, "$name") .. "] [" .. get_var(PlayerIndex, "$n") .. "]: " .. tostring(Message), PlayerIndex)
                    response = false
                end
            else
                SendToAll(get_var(PlayerIndex, "$name") .. " [" .. get_var(PlayerIndex, "$n") .. "]: " .. tostring(Message), PlayerIndex)
                response = false
            end
        end
    end
    return response
end

function SendToTeam(Message, PlayerIndex)
    for i = 1,16 do
        if player_present(i) then
            if (get_var(i,"$team")) == (get_var(PlayerIndex,"$team")) then
                execute_command("msg_prefix \"\"")
                say(i, Message)
                execute_command("msg_prefix \"** SERVER ** \"")
            end
        end
    end
end

function SendToAll(Message, PlayerIndex)
    if player_present(PlayerIndex) then
        execute_command("msg_prefix \"\"")
        say_all(Message)
        execute_command("msg_prefix \"** SERVER ** \"")
    end
end

function CheckIfTeamPlay()
    if get_var(0, "$ffa") == "0" then
        return true
    else
        return false
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function OnError(Message)
    print(debug.traceback())
end

--[[
------------------------------------
Script Name: HPC CommandSpy, for SAPP
    - Implementing API version: 1.11.0.0

Description: Spy on your players commands!

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS
        
Copyright ©2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnChatMessage")
end

function OnChatMessage(PlayerIndex, Message, type)
    if (tonumber(get_var(PlayerIndex,"$lvl"))) == -1 then 
        player = true 
    else 
        player = false
    end
    local t = tokenizestring(Message)
    count = #t
    local Message = tostring(Message)
    iscommand = nil
    if string.sub(t[1], 1, 1) == "/" or string.sub(t[1], 1, 1) == "\\" then 
        iscommand = true
    else 
        iscommand = false
    end
    if player_present(PlayerIndex) ~= nil then
        if iscommand then 
            if player then
                CommandSpy("SPY: " .. name .. ": " .. Message, PlayerIndex)
            end
        end
    end
    return true
end

function CommandSpy(Message, PlayerIndex)
    admin = nil
    if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 0 then 
        admin = true 
    else 
        admin = false 
    end
    for i = 1,16 do
        if i ~= admin then
            rprint(i, Message)
        end
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

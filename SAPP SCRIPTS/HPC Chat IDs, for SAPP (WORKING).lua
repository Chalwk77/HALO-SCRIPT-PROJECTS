--[[
------------------------------------
Script Name: HPC Chat IDs, for SAPP
    - Implementing API version: 1.11.0.0
Description:  This script will modify your players message chat format
              by adding an IndexID in front of their name in square brackets.
    
eg. Chalwk [1]: This is a test message.
    
    Change Log:
       [!] Fixed!!

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]-- 

api_version = "1.11.0.0"

function OnScriptUnload() end

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnChatMessage")
end

function OnChatMessage(PlayerIndex, Message)
    local words = tokenizestring(Message, " ")
    if #words == 0 then
        return nil
    end
    for i = 0, #words do
        if words[i] then
            local id = get_var(PlayerIndex, "$n")
            local name = get_var(PlayerIndex, "$name")
            local ChatFormat = string.format(name .. " [" .. tonumber(id) .. "]: " .. tostring(Message))
            execute_command("msg_prefix \"\"")
            say_all(ChatFormat) 
            execute_command("msg_prefix \"** SERVER ** \"")
        end
    end
    return false
end

function OnError(Message)
    print(debug.traceback())
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

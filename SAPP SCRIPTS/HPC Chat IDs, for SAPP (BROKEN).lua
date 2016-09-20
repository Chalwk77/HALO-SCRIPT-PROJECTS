--[[
------------------------------------
Script Name: HPC Chat IDs, for SAPP
    - Implementing API version: 1.10.0.0


    -- Currently broken!

Description:  This script will modify your players message chat format
              by adding an index id in front of their name in square brackets.

eg. [GLOBAL] Chalwk [1]: This is a test message.

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.10.0.0"

function OnScriptUnload() end

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
end

function OnPlayerChat(PlayerIndex, Message)
    local id = get_var(PlayerIndex, "$n")
    local chatFormat = string.format(" [" .. (tonumber(id)) .. "]: " ..(tostring(Message)))

    if player_present(PlayerIndex) ~= nil then
        return true, chatFormat
    else
        return true, chatFormat
    end
end

function OnError(Message)
    print(debug.traceback())
end

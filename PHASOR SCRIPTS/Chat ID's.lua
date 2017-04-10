--[[
------------------------------------
Script Name: ChatIDs, for PHASOR | (PC\CE)

Description:  This script will modify your players message chat format
              by adding an IndexID in front of their name in square brackets.

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]--

function GetRequiredVersion() return 200 end
function OnScriptLoad(processId, game, persistent) end
function OnServerChat(player, chattype, message)
    local GetChatFormat = string.format(" [" .. resolveplayer(player) .. "] " ..(tostring(message)))
    if player ~= nil then
        return true, GetChatFormat
    else
        return true, GetChatFormat
    end
end

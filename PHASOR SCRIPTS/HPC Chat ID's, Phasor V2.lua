--[[
------------------------------------
Description: HPC Chat ID's, Phasor V2+
Copyright © 2016-2017 Jericho Crosby
* Author: Jericho Crosby
* IGN: Chalwk
* Written and Created by Jericho Crosby

-- SAPP Version:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/SAPP%20SCRIPTS/HPC%20Chat%20IDs%2C%20SAPP%20(BROKEN).lua

-----------------------------------
]]--

function GetRequiredVersion()
    return
    200
end

function OnScriptLoad(processId, game, persistent)

end

function OnServerChat(player, chattype, message)
    
    local GetChatFormat = string.format(" [" .. resolveplayer(player) .. "] " ..(tostring(message)))
    if player ~= nil then
        return true, GetChatFormat
    else
        return true, GetChatFormat
    end
end

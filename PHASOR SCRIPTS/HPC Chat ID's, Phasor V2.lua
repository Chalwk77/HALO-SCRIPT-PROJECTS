--[[
------------------------------------
Description: HPC Chat ID's, Phasor V2+
Copyright © 2016-2017 Jericho Crosby
* Author: Jericho Crosby
* IGN: Chalwk
* Written and Created by Jericho Crosby
-----------------------------------
]]--

function GetRequiredVersion()
    return
    200
end

function OnScriptLoad(processId, game, persistent)

end

function OnServerChat(player, chattype, message)

    local charr = message:sub(1, 1)
    local chatcmd = charr == "\\"
    local pchat = charr == "@"
    local number

    if tonumber(charr) then
        number = tonumber(charr) <= 8
    end

    if not(chatcmd or pchat) then
        if player then
            return true, "[" .. resolveplayer(player) .. "]  " .. message
        else
            return true
        end
    end
end
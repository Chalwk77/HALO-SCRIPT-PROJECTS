--[[
--=====================================================================================================--
Script Name: Kill Counter V2, for SAPP (PC & CE)
Description: This mod will announce who had most kills OnGameEnd()

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Created by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

message = "%name% won the game with %kills% kill%punctuation%"

-- do not touch anything below --
api_version = '1.12.0.0'
players = {}

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_KILL"], "OnPlayerDeath")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerLeave")
    players = { ["data"] = {} }
end

function OnScriptUnload()

end

function OnPlayerJoin(PlayerIndex)
    players["data"][get_var(PlayerIndex, "$hash")] = { ["total_kills"] = 0 }
end

function OnPlayerLeave(PlayerIndex)
    players["data"][get_var(PlayerIndex, "$hash")] = { ["total_kills"] = 0 }
end

function OnPlayerDeath(PlayerIndex)
    for key, _ in pairs(players["data"]) do
        if get_var(PlayerIndex, "$hash") == key then
            players["data"][key].total_kills = players["data"][key].total_kills + 1
            players["data"][key].name = get_var(PlayerIndex, "$name")
        end
    end
end

function OnGameEnd()
    local kills = 0
    local name
    for _, value in pairs(players["data"]) do
        if value.total_kills > kills then
            kills = value.total_kills
            name = value.name
        end
    end
    if (name ~= nil and kills ~= 0) then
        if kills == 1 then
            message = string.gsub(message, "%%punctuation%%", "")
        else
            message = string.gsub(message, "%%punctuation%%", "s")
        end
        message = string.gsub(message, "%%name%%", name)
        message = string.gsub(message, "%%kills%%", kills)
        say_all(message)
    end
end

--[[
--=====================================================================================================--
Script Name: Kill Counter, for SAPP (PC & CE)
Description: This mod was requested by someone called planetX2 on opencarnage.net

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Created by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

api_version = '1.12.0.0'

-- configuration starts --
local message = "Kill Counter: %kills%"
local alignment = "l", -- Left = l, Right = r, Center = c, Tab: t
-- configuration ends --

local players = { }

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
    register_callback(cb['EVENT_JOIN'], 'OnPlayerJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnPlayerLeave')
    for i = 1, 16 do
        if player_present(i) then
            players[i] = { }
            players[i].kills = 0
        end
    end
end

function OnScriptUnload()
    for i = 1, 16 do
        if player_present(i) then
            players[i] = { }
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    players[PlayerIndex] = { }
    players[PlayerIndex].kills = 0
end

function OnPlayerLeave(PlayerIndex)
    players[PlayerIndex] = nil
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    players[KillerIndex].kills = players[KillerIndex].kills + 1
    for i = 1, 20 do rprint(KillerIndex, " ") end
    rprint(KillerIndex, "|" .. alignment .. " " .. string.gsub(message, "%%kills%%", players[KillerIndex].kills))
end

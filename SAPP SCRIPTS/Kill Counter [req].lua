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
message = "Kill Counter: $kills"
-- Left = l,    Right = r,    Centre = c,    Tab: t
message_alignment = "l"
-- configuration ends --

players = { }

function OnScriptLoad()
	register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
	register_callback(cb['EVENT_JOIN'], 'OnPlayerJoin')
	register_callback(cb['EVENT_LEAVE'], 'OnPlayerLeave')
	for i = 1, 16 do
		if player_present(i) then
			players[get_var(i, "$n")] = { }
			players[get_var(i, "$n")].kills = 0
		end
	end
end

function OnScriptUnload()
	for i = 1, 16 do
		if player_present(i) then
			players[get_var(i, "$n")] = { }
		end
	end
end

function OnPlayerJoin(PlayerIndex)
	players[get_var(PlayerIndex, "$n")] = { }
	players[get_var(PlayerIndex, "$n")].kills = 0
end

function OnPlayerLeave(PlayerIndex)
	players[get_var(PlayerIndex, "$n")] = { }
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
	players[get_var(KillerIndex, "$n")].kills = players[get_var(KillerIndex, "$n")].kills + 1
	for i = 1, 20 do rprint(KillerIndex, " ") end
	rprint(KillerIndex, string.gsub(message, "$kills", players[get_var(KillerIndex, "$n")].kills))
end

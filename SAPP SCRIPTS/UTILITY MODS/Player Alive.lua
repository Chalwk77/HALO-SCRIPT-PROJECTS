--[[
--=====================================================================================================--
Script Name: Player Alive (timer), for SAPP (PC & CE)
Description: Some random shit that probably nobody wants.
		     When a player spawns, a timer is initiated and begins to countdown from 60 seconds - 
			 after which, it's stopped and "something happens". 
			 The timer is reset and will begin counting down again when they respawn.
			 It's up to YOU to "code" your "something-event" in the OnTick() function.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

-- Config --
local allocated_time = 60

local players = { }

api_version = "1.12.0.0"
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    for i = 1, 16 do
		if player_present(i) then
			InitPlayer(i, true)
		end
    end
end

function OnGameEnd()
    for i = 1, 16 do
		if player_present(i) then
			InitPlayer(i, true)
		end
    end
end

local function InitPlayer(p, Reset)
	if (not Reset) then
		players[p] = { 
			init = false,
			time_alive = 0,
		}
	else
		players[p] = {}
	end
end

function OnPlayerJoin(p)
	InitPlayer(p, false)
end

function OnPlayerQuit(p)
	InitPlayer(p, true)
end

function OnPlayerSpawn(p)
	players[p].init = true
	players[p].time_alive = 0
end

function OnTick()
	for p,v in pairs(players) do
		if (p) then
			if player_present(p) and player_alive(p) then
				if (v.init) then
					v.timer = v.timer + 1/30
					if (v.timer >= allocated_time) then
						v.init, v.timer = false, 0
						
						-- do something here --

						-----------------------
					end
				end
			end
		end
	end
end

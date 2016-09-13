Consecutive_Kills = {}
KillCount = 1
function OnScriptUnload() end
function GetRequiredVersion() return 200 end
function OnScriptLoad(processId, game, persistent) end
function OnPlayerJoin(player)
	Consecutive_Kills[player] = {0}
end

function OnPlayerKill(killer, victim, mode)
	if mode == 4 then
		Consecutive_Kills[killer][1] = Consecutive_Kills[killer][1] + 1 end
			if killer then if Consecutive_Kills[killer][1] ~= 0 then Consecutive_Kills[killer][1] = 0 
					if Consecutive_Kills[killer][1] == KillCount then GivePowerUp(killer) 
					hprintf("READING: if Consecutive_Kills[killer][1] >1 then GivePowerUp(killer)")
				say("READING: if Consecutive_Kills[killer][1] >1 then GivePowerUp(killer)")
			end
		end
	end
end

function GivePowerUp(id, count)
	say("SUCCESS!")
	say("SUCCESS!")
	say("SUCCESS!")
	say("SUCCESS!")
	say("SUCCESS!")
	hprintf("SUCCESS!")
	hprintf("SUCCESS!")
	hprintf("SUCCESS!")
	hprintf("SUCCESS!")
	hprintf("SUCCESS!")
	hprintf("SUCCESS!")
	hprintf("SUCCESS!")
end
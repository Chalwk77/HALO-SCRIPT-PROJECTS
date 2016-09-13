spawnkill_deaths = 5 -- Defines how many deaths are required before action is taken.
consec_deaths = {}
math.inf = 1 / 0

function OnPlayerJoin(player)
	consec_deaths[player] = {0}
end

function OnScriptUnload() end
function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end

function OnNewGame(map)
	overshield_tag_id = gettagid("eqip", "powerups\\over shield")
	camouflage_tag_id = gettagid("eqip", "powerups\\active camouflage")
end

function OnPlayerKill(killer, victim, mode)
	if mode == 4 then
		consec_deaths[victim][1] = consec_deaths[victim][1] + 1 -- Victim
		if killer then -- Killer
			if consec_deaths[killer][1] ~= 0 then -- Killer
				consec_deaths[killer][1] = 0 -- Killer
			end
		end
	end
end	

function OnPlayerSpawnEnd(player, m_objectId)
	local name = getname(player)
	if player then
		if consec_deaths[player][1] == spawnkill_deaths then
			local m_playerObjId = getplayerobjectid(player)
			if m_playerObjId then
				local m_object = getobject(m_playerObjId)
				if m_object then
					local x,y,z = getobjectcoords(m_playerObjId)
					local os = createobject(overshield_tag_id, 0, 0, false, x, y, z+0.5)
					local os = createobject(camouflage_tag_id, 0, 0, false, x, y, z+0.5)
					privatesay(player, "**SPAWN PROTECTION** You have been given an Over-Shield and CAMO.", false)
				end
			end
			consec_deaths[player][1] = 0
		end
	end
end
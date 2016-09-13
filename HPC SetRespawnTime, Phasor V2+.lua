--[[    
------------------------------------
Description: HPC SetRespawnTime, Phasor V2+
Copyright © 2016-2017 Jericho Crosby
* Author: Jericho Crosby
* IGN: Chalwk
* Written and Created by Jericho Crosby
-----------------------------------
]]-- 

RespawnTime = 1.5
function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end
function OnPlayerKill(killer, victim, mode)
	if victim then 
		if RespawnTime then
			writedword(getplayer(victim) + 0x2c, RespawnTime * 33)
		end
	end
end	
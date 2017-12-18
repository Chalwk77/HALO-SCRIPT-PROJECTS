--[[
------------------------------------
Description: HPC SetRunningSpeed, Phasor V2+
Copyright © 2016-2017 Jericho Crosby
* Author: Jericho Crosby
* IGN: Chalwk
* Written and Created by Jericho Crosby
-----------------------------------
]]-- 

RunningSpeed = 1.08
function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end
function OnPlayerSpawnEnd(player, m_objectId)
    if getplayer(player) then setspeed(player, RunningSpeed) end
end	
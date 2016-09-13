--[[
------------------------------------
Description: HPC AnnounceOnJoin (basic), Phasor V2+
Copyright © 2016-2017 Jericho Crosby
* Author: Jericho Crosby
* IGN: Chalwk
* Written and Created by Jericho Crosby
-----------------------------------
]]--

Timer = 700
AnnounceMessage = "Welcome to Chalwk's Realm (Snipers Dream Team Mod)"

function GetRequiredVersion()
    return
    200
end

function OnScriptLoad(processid, game, persistent)

end

function OnScriptUnload()

end

function OnPlayerJoin(player)

    privatesay(player, AnnounceMessage, false)

end

function OnGameEnd(stage)

    removetimer(Timer)

end
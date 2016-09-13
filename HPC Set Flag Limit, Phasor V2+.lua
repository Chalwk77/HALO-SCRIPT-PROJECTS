--[[    
------------------------------------
Description: HPC Set Flag Limit, Phasor V2+
Copyright © 2016-2017 Jericho Crosby
* Author: Jericho Crosby
* IGN: Chalwk
* Written and Created by Jericho Crosby
-----------------------------------
]]--

function OnScriptUnload() end
function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent)
	writebyte(0x671340, 0x58, 21) -- GameType_Base
end
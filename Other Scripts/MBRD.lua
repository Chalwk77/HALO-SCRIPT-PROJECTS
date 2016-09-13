function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end

OPJM1_Message = "Welcome to « Ö W V » Arms Race!   <|>   Hosted by the O W V Clan"

function OnPlayerJoin(player)
	privatesay(player, OPJM1_Message, false)
end
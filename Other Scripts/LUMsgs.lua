First_Timer = 700
OPJM_Message = ">> Welcome to ÖWV 3 - Level Up!, Hosted by the O. W. V. Clan"
First_Auto_Message = "Ö W V are recruiting! You can apply to join at http://www.OneWorldVirtual.proboards.com"

function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end
function OnPlayerJoin(player)
	privatesay(player, OPJM_Message, false)
end

function OnNewGame(map)
	registertimer(First_Timer*1000,"Auto_Message_One")
end

function Auto_Message_One(id, count)
	say(First_Auto_Message, false)
	return 1
end

function OnGameEnd(stage)
	removetimer(First_Timer)
end
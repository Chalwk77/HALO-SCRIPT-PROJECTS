function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end
OPJM1_Message = "Welcome to «ÖWV» 3, ?ne World Virtual - Snipers Dream Team Mod |  Hosted by the O. W. V. Clan"
function OnPlayerJoin(player)
	privatesay(player, OPJM1_Message, false)
end



First_Timer = 700
Second_Timer = 1
First_Auto_Message = "«ÖWV» are recruiting! You can apply to join at www.oneworldvirtual.proboards.com"
Second_Auto_Message = "One World Virtual boasts an open community forum which provides a platform for focused dialogue on gamers!\n Feel free to check in, perhaps make an account, and interact with us! You're always welcome.\n Visit us at: http://www.OneWorldVirtual.com/"
function OnNewGame(map)
	AutoMessage_Timer = registertimer(First_Timer*1000,"Auto_Message_One")
	AutoMessage_Timer = registertimer(Second_Timer*1000,"Auto_Message_Two")
end

function Auto_Message_One(id, count)
	say(First_Auto_Message, false)
	return 1
end

function Auto_Message_Two(id, count)
	say(Second_Auto_Message, false)
	return 1
end

function OnGameEnd(stage)
	removetimer(AutoMessage_Timer)
end
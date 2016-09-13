function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end 

function KillConfirmed(id,count)
	say(Kill_Confirmed_1)
	say(Kill_Confirmed_2)
	say(Kill_Confirmed_3)
	say(Kill_Confirmed_4)	
	return true
end

function OnNewGame(Mapname)
	main_message = registertimer(1000*60*20,"KillConfirmed")
end

function Delay(id, count, player)
	if getplayer(player) then
		privatesay(player, Kill_Confirmed_1)
		privatesay(player, Kill_Confirmed_2)
		privatesay(player, Kill_Confirmed_3)
		privatesay(player, Kill_Confirmed_4)
	end
	return false
end

function OnPlayerJoin(player)
	registertimer(1000*10,"Delay",player)
end

function OnGameEnd(mode)
	if mode == 1 then
		if main_message then
			removetimer(main_message)
			main_message = nil
		end
	end
end	

Kill_Confirmed_1 = "* * KILL CONFIRMED * * "
Kill_Confirmed_2 = "When you kill someone a 'DogTag' falls near their body, and to 'confirm' your kill, you have to retrieve the tag."
Kill_Confirmed_3 = "To deny a kill, pick up a DogTag dropped by a fallen teammate"
Kill_Confirmed_4 = "When you deny a kill, the opposing team will not be able to collect that dogtag...\n...meaning that they will not be able to score a point."
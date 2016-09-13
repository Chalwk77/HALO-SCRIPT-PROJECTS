Timed_Auto_Message = "**SERVER** GameSpy is shutting down their servers  -  Join the fight:  http://savehalo.tk/" -- Message to output every x seconds.
auto_time = 145 -- In seconds - (seventy seconds - One Minute.)

--------------------------------------------------------------------------------------------------------------------------------------
function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end
--------------------------------------------------------------------------------------------------------------------------------------
function OnNewGame(map)
	automessage_timer = registertimer(auto_time*1000,"auto_message")
	hprintf(tostring(getprofilepath()))
end

function auto_message(id, count)
	say(Timed_Auto_Message, false)
	return 1
end

function OnGameEnd(stage)
	removetimer(automessage_timer)
end
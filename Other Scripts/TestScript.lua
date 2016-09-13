message = "OZ 12 Test" -- message to output every x seconds
auto_time = 500 -- in seconds

function GetRequiredVersion()
	return 200
end

function OnScriptLoad(processid, game, persistent)
end

function OnScriptUnload()
end

function OnNewGame(map)
	automessage_timer = registertimer(auto_time*1000,"auto_message")
	hprintf(tostring(getprofilepath()))
end

function auto_message(id, count)
	say(message)
	return 1
end

function OnGameEnd(stage)
	removetimer(automessage_timer)
end
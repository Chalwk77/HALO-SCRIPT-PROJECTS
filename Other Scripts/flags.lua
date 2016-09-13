function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end

captures = 0

function OnPlayerScore(player, score, gametype)
		captures = captures + 1
		if(captures == 1) then
			say("Flag Captured!")
		elseif(captures == 2) then
			say("Flag Runner!")
		elseif(captures >= 3) then
			say("Flag Champion!")
		end
end

function OnNewGame()
	captures = 0
end
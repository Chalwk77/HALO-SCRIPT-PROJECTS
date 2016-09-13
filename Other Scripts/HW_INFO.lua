function OnScriptUnload() end
function GetRequiredVersion() return 200 end
function OnScriptLoad(processId, game, persistent) end
function OnNewGame(map)
	timer = registertimer(1000, "PrintMessages")
end
 
function PrintMessages(id, count)
        if (count % 120) == 0 then
		say(">>  HOG WARS is still in development. It will be completed by:  03/03/2015", false)
		end
    return true
end
 
function OnGameEnd(mode)
    if mode == 1 then
        if timer then
			timer = nil
        end
    end
end
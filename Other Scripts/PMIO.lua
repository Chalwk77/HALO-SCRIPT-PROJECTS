function OnScriptUnload() end
function GetRequiredVersion() return 200 end
function OnScriptLoad(processId, game, persistent) end
function OnNewGame(map)
	PrintTimer = registertimer(1000, "PrintMessages")
end
 
function PrintMessages(id, count)
        if (count % 600) == 120 then
		say(">>  Fun Fact #1", false)
            hprintf(" Fun Fact #1")
        elseif (count % 600) == (240) then
		say(">>  Fun Fact #2", false)
            hprintf(" Fun Fact #2")
        elseif (count % 600) == (360) then
		say(">>  Fun Fact #3", false)
            hprintf(" Fun Fact #3")
        elseif (count % 600) == (480) then
            	say(">>  Fun Fact #4", false)
            hprintf(" Fun Fact #4")
        elseif (count % 600) == (0) then
            	say(">>  Fun Fact #5", false)
            hprintf(" Fun Fact #5")
	end
    return true
end
 
function OnGameEnd(mode)
    if mode == 1 then
        if PrintTimer then
            removetimer(PrintTimer)
            PrintTimer = nil
        end
    end
end
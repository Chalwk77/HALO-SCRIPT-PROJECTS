function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
player_ping = {}

function OnPlayerJoin(player)
		registertimer(1000, "Timed_Messages", player)
end

function Timed_Messages(count, player)
		local ping = readword(getplayer(i) + 0xDC)
if count == 2 then 
        privatesay(ping)
	        return false -- Ends the loop.
		end
	return true
end

function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end
function OnGameEnd(stage)
	
	if stage == 2 then
		local m_player = getplayer(player)
		local kills = readword(m_player + 0x9C)
		local deaths = readword(m_player + 0xAE)
		local message = string.lower(msg)
		for player = 0, 15 do 
			if getplayer(player) then
				if kills == 0 and deaths == 0 then
					privatesay(player, "You do not have any Kills or Deaths!")
		elseif kills ~= 0 then
			if deaths ~= 0 then
				privatesay(player, "Your K/D Ratio is: " .. math.round(kills/deaths, 2))
				hprintf("PrivateSay 1 SUCCESS")
			else
				privatesay(player, "You do not have any Deaths!")
				hprintf("PrivateSay 2 SUCCESS")
			end
		else
			privatesay(player, "You do not have any Kills!")
			hprintf("PrivateSay 3 SUCCESS")
		end
		return false
	end
	return true
	end
	end
end		
 
function math.round(input, precision)
	return math.floor(input * (10 ^ precision) + 0.5) / (10 ^ precision)
end
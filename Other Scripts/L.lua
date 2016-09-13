stable_pings = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 25, 30,}
player_ping = {}

function GetRequiredVersion() return 200 end
function OnScriptLoad(processId, game, persistent) end

for i = 1,16 do
	player_ping[i] = 0
end

function OnClientUpdate(player)
	local m_player = getplayer(player)
	if m_player ~= nil then
		local ping = readword(m_player, 0xDC)
		if ping <= 1000 then
			player_ping[resolveplayer(player)] = ping
			local min = 999999
			for j = 1,#stable_pings do
				local difference = math.abs(stable_pings[j] - ping)
				if difference < min then
					min = difference
					player_ping[resolveplayer(player)] = stable_pings[j]
				end
			end
			writeword(m_player, 0xDC, player_ping[resolveplayer(player)])
		end
	end
end
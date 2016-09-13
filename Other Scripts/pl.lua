function GetRequiredVersion() return 200 end
function OnScriptLoad() end
function OnScriptUnload() end

function OnServerChat(player, type, message)
	if player then
		allowchat = nil
		local t = tokenizestring(command, " ")
		local count = #t
		if string.sub(t[1], 1, 1) == "\\" then
			allowchat = false
		elseif string.sub(t[1], 1, 1) == "/" then
			allowchat = true
		end
		allowchat = false
		if logged_in_hash[gethash(player)] or logged_in_ip[getip(player)] then
			if t[1] == "/pl" or t[1] == "\\pl" then
				command_players(player)
			end
		end
	end
end

function command_players(player)
	for i = 0,15 do
		local name = {}
		if getplayer(i) then
			name[i] = getname(i)
		else
			name[i] = "--"
		end
		response = resolveplayer(i) .. " - " .. name[i][1] .. resolveplayer(i) .. " - " .. name[i][1] .. resolveplayer(i) .. " - " .. name[i][1]
		privatesay(player, response)
	end
end


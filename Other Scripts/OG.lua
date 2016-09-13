function GetRequiredVersion() return 200 end
function OnScriptUnload() end
function OnScriptLoad(processId, game, persistent) 
	if game == "PC" then
		gametype_base = 0x671340
	elseif game == "CE" then
		gametype_base = 0x5F5498
	end
	main_timer = registertimer(500, "MainTimer")
	gametype = readbyte(gametype_base + 0x30)

end

function MainTimer(id, count)

	for i = 0, 15 do 
		if getplayer(i) then
			local hash = gethash(i)
			if gametype == 1 then
				local grabs = readword(getplayer(i) + 0xC4)
				if grabs ~= true then
					sendconsoletext(i, "Flag Grab")
				end
			end
		end
	end
	return true
end

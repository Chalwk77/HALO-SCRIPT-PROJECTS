--[[
------------------------------------
Description: HPC Private Message (workaround fix), Phasor V2+
Copyright (c) 2016-2018
* Author: Jericho Crosby
* IGN: Chalwk
* Written and Created by Jericho Crosby
Script Version: 2.5
-----------------------------------
]]--
elseif pm_enabled and string.sub(t[1], 1, 1) == "@" 
	and t[1] ~= "@rules" and t[1] ~= "@info" and t[1] ~= "@report" 
	and t[1] ~= "@players" and t[1] ~= "@commands" and t[1] ~= "@suicide" 
	and t[1] ~= "@rank" and t[1] ~= "@weapons" and t[1] ~= "@stats" 
	and t[1] ~= "@medals" and t[1] ~= "@sprees" and t[1] ~= "@vehicles" 
	and t[1] ~= "@zombie" then
		AllowChat = false
		local receiverID = string.sub(t[1], 2, t[1]:len())
		if receiverID == "" then privatesay(player, "Please enter a valid '@' command!", false) end 
		if receiverID == "*" or receiverID == "0" or receiverID == "1" or receiverID == "2" 
		or receiverID == "3" or receiverID == "4" or receiverID == "5" 
		or receiverID == "6" or receiverID == "7" or receiverID == "8" 
		or receiverID == "9" or receiverID == "10" or receiverID == "11" or receiverID == "12"
		or receiverID == "13" or receiverID == "14" or receiverID == "15" 
		or receiverID == "16" or receiverID == "red" or receiverID == "blue"
		or receiverID == "random"
		and IpAdmins[ip] or Admin_Table[hash] then
			local players = getvalidplayers(receiverID, player)
			if players then
				for i = 1,#players do
					local hash = gethash(players[i])
					if No_PMs[hash] == nil then
						if player ~= players[i] then
							local privatemessage = table.concat(t, " ", 2, #t)
							privateSay(player, "PM to: " .. getname(players[i]) .. " (" ..  players[i]+1 .. ") :  " .. privatemessage)
							privateSay(players[i], getname(player) .. " (" .. players[i]+1 .. ") :  " .. privatemessage)
						end
						privatesay(player, "Your Private Message has been sent to " .. getname(players[i]), false)
						respond("PRIVATE MESSAGE: " ..name.. " has sent a Private Message to " .. getname(players[i]))
					else
						privateSay(player, "Sorry, this Player has PM's disabled!")
						respond("SERVER TO: " ..name.. "  -  Sorry, Player has PM's disabled!")
					end
				end
			else
				privateSay(player, "There is no player with an ID of (" .. receiverID .. ")")
				respond("SERVER TO: " ..name.. "  -  There is no player with an ID of (" .. receiverID .. ")")
			end
		else
			privateSay(player, "Sorry, You can only PM one player at a time!")
			respond("SERVER TO: " ..name.. "  -  Sorry You can only PM one player at a time!")
		end
seat = {} 
function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnNewGame(map)
        gamemap = map
end

function OnClientUpdate(player)
	if gamemap == "bloodgulch" then
		if getplayer(player) then
			if inSphere(player, 95.455, -152.498, 0.162, 5.00) == true then
			say("success")
			hprintf("Player has entered a (AREA NAME) - SUCCESS")
			end
		end
	end
end

function inSphere(player, x, y, z, radius)
	if getplayer(player) then
			local obj_x = readfloat(getplayer(player) + 0xF8)
            local obj_y = readfloat(getplayer(player) + 0xFC)
            local obj_z = readfloat(getplayer(player) + 0x100)
			local x_diff = x - obj_x
			local y_diff = y - obj_y
			local z_diff = z - obj_z
			local dist_from_center = math.sqrt(x_diff ^ 2 + y_diff ^ 2 + z_diff ^ 2)
			if dist_from_center <= radius then
					return true
			end
	end
	return false
end
function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end

function OnServerChat(player, chattype, msg)
 	type:
    0 All chat
	1 Team chat
    2 Vehicle chat
    3 Server message
    4 Private server message
	 return true, chattype, msg
end	

	local type = nil
        if chattype == 0 then
                type = "Global Chat"
        elseif chattype == 1 then
                type = "Team Chat"
        elseif chattype == 2 then
                type = "Vehicle Chat"
		elseif chattype == 3 then
                type = "Server message"
		elseif chattype == 4 then
                type = "Private server message"
        end
        if player ~= nil and type ~= nil then
                local name = getname(player)
                local id = resolveplayer(player)
			
                respond("  C   H   A   T  | " ..name ..  " - (" .. id .. ")  [ " .. type .. " ]: " .. msg)
        end
end    

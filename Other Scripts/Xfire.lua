function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end

xfire_message_table = {}
xfire_message_table[1] = "**SERVER**  Below is a list of the OZ CLAN leaders/admins xfire's"

function OnServerChat(player, chattype, message)
		local message = string.lower(message)
		if message == "xfire" then
			for i = 1, #xfire_message_table do 
				if xfire_message_table[i] ~= "ENTER YOUR TEXT HERE" and xfire_message_table[i] ~= nil then
					sendconsoletext(player, xfire_message_table[i])
				end
			end
		end
		return true
	end
end 


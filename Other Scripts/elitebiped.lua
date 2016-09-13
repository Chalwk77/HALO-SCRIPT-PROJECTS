-- config

elitetag_path = "characters\\elite_mp\\elite_mp"
elitetag_team = 0;	--red = 0, blue = 1

-- end of config

elitetag = nil
fixedtag = false

-- called when a game is starting (before any players join)
-- Do not return a value.
function OnNewGame(map)
	elitetag = gettagid("bipd",elitetag_path)
	fixedtag = false
end

-- Called when a player s (after object is created, before players are notified)
-- Do not return a value
function OnPlayerSpawn(player, m_objectId)
	local object = getobject(m_objectId)
	if(getteam(player) % 2 == elitetag_team and elitetag ~= nil) then
		if(fixedtag == false) then
			local oldtagdata = readdword(gettagaddress(readdword(object)) + 0x14)
			local newtagdata = readdword(gettagaddress(elitetag) + 0x14)
			writedword(newtagdata + 0x28 + 0xC, readdword(oldtagdata + 0x28 + 0xC))
			fixedtag = true
		end
		writedword(object,elitetag)
	end
end

function OnScriptLoad(process) end
function OnScriptUnload() end
function GetRequiredVersion() return 200 end
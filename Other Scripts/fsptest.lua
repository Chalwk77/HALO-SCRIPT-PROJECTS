function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end
objects = {}
tags = {}
-- BloodGulch "eqip", "powerups\\full-spectrum vision")
-----------------------> > > 
-- Object Spawn Coordinates:
objects[1] = {"powerups\\full-spectrum vision", 95.455, -152.498, 0.162}
math.inf = 1 / 0

function OnNewGame(map)
	for k,v in pairs(objects) do
		local tag_id = gettagid("eqip", v[1])
		v[1] = tag_id
		v[5] = createobject(tag_id, 0, math.inf, false, v[2],v[3],v[4])
		if getobject(v[5]) == nil then
			hprintf("E R R O R! Object Creation failed. Number: " .. k)
		end
	end
end

function OnObjectInteraction(player, objId, mapId)
	local tagName, tagType = gettaginfo(mapId)
	if tagName == "powerups\\full-spectrum vision" then
		if tags[getobject(objId)] ~= nil then
			local t = tokenizestring(tostring(tags[getobject(objId)]), ":")
			OnTagPickup(player, t[1], t[2], t[3], t[4])
		end
	end
end

function OnTagPickup(player)
	local player = getname(player)
		if getplayer(player) then
			privatesay(player," SUCCESS ")
		end
end	
	
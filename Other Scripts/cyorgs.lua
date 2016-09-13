function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end
objects = {}
math.inf = 1 / 0
objects[1] = {"characters\\cyborg_mp\\cyborg_mp", 19.005, -103.437, 19.202}
objects[2] = {"characters\\cyborg_mp\\cyborg_mp", 39.101, -96.204, 3.570}
objects[3] = {"characters\\cyborg_mp\\cyborg_mp", 40.066, -83.240, 3.000}
objects[5] = {"characters\\cyborg_mp\\cyborg_mp", 43.708, -75.621, 2.990}
objects[6] = {"characters\\cyborg_mp\\cyborg_mp", 97.266, -139.392, 1.363}
objects[7] = {"characters\\cyborg_mp\\cyborg_mp", 80.770, -149.437, 2.480}
objects[8] = {"characters\\cyborg_mp\\cyborg_mp", 85.025, -158.591, 1.115}
objects[9] = {"characters\\cyborg_mp\\cyborg_mp", 95.571, -155.391, 3.000}
objects[10] = {"characters\\cyborg_mp\\cyborg_mp", 99.114, -155.989, 3.004}
objects[11] = {"characters\\cyborg_mp\\cyborg_mp", 91.976, -163.077, 3.005}
function OnNewGame(map)
	for k,v in pairs(objects) do
		local tag_id = gettagid("bipd", v[1])
		v[1] = tag_id
		v[5] = createobject(tag_id, 0, math.inf, false, v[2],v[3],v[4])
		if getobject(v[5]) == nil then
			hprintf("E R R O R! Object Creation failed. Number: " .. k)
		end
	end
end
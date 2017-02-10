api_version = "1.10.0.0"

BrokenCoords = {
        51.9, -76.42, 0.08,
        37.43, -68.11, 0.26,
        105.49, -157.45, 0.2,
        29.6, -76.35, 0.3,
        102.86, -154.92, -0.01,
        92.48, -169.56, 0.13,
        29.31, -81.41, 0.17,
        42.91, -67.76, 0.52,
        36.9, -90.21, 0.07,
        84.9, -161.71, 0.11,
        52.06, -82.22, 0.12
}	

function OnScriptLoad()
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
end

function OnScriptUnload()

end

function OnPlayerSpawn(PlayerIndex) 
    local CurrentCoords = GetPlayerCoords(PlayerIndex)
    if table.match(BrokenCoords, CurrentCoords) then 
        cprint("YES", 2+8) 
    end
end
    
function GetPlayerCoords(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
		local x,y,z = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
		local vehicle_objectid = read_dword(player_object + 0x11C)
		local vehicle_object = get_object_memory(vehicle_objectid)
		if(vehicle_object ~= 0 and vehicle_object ~= nil) then
			local vx,vy,vz = read_vector3d(vehicle_object + 0x5C)
			x = x + vx
			y = y + vy
			z = z + vz
		end
		return math.round(x, 2),math.round(y, 2),math.round(z, 2)
	end
	return nil	
end

function math.round(num, idp)
    return tonumber(string.format("%." ..(idp or 0) .. "f", num))
end

function table.match(table, value)
    for k,v in pairs(table) do
        if v == value then
            return k
        end
    end
end

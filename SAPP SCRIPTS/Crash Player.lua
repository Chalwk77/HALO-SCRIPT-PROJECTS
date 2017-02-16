--[[
    Script Name: Crash Player (utility), for SAPP | (PC\CE)
- Implementing API version: 1.11.0.0

    Description: Crash that player! 
                 Based on Name/Hash comparisons

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
]]

api_version = "1.11.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
	register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
	if halo_type == "PC" then ce = 0x0 else ce = 0x40 end
	network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    LoadTables()
end

function OnScriptUnload()
    NameList = { }
    HashList = { }
end

function LoadTables( )
    NameList = {
    -- Make sure these names match exactly as they do ingame.
        "Example",
        "Example",
        "Example",
        "Example",
        "Example",
        "Example"
    }	
    HashList = {
    -- You can retrieve the players hash by looking it up in the sapp.log file.
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    }
end

function OnPlayerPrejoin(PlayerIndex)
	local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
	local client_network_struct = network_struct + 0x1AA + ce + to_real_index(PlayerIndex) * 0x20
	local Name = read_widestring(client_network_struct, 12)
    local Hash = get_var(PlayerIndex,"$hash")
    local PlayerIP = get_var(PlayerIndex, "$ip")
    if table.match(NameList, Name) and table.match(HashList, Hash) then
        timer(3000, "CrashPlayer", PlayerIndex)
    end
end

function table.match(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function read_widestring(address, length)
	local count = 0
	local byte_table = {}
	for i = 1,length do
		if read_byte(address + count) ~= 0 then
			byte_table[i] = string.char(read_byte(address + count))
		end
		count = count + 2
	end
	return table.concat(byte_table)
end

-- Thanks to H® Shaft for this neat little function!
function CrashPlayer(PlayerIndex)
	if player_present(PlayerIndex) then
		local player_object = get_dynamic_player(PlayerIndex)
        if (player_object ~= 0) then
            local x,y,z = read_vector3d(player_object + 0x5C)
            local vehicleId = spawn_object("vehi", "vehicles\\warthog\\mp_warthog", x, y, z)
            local veh_obj = get_object_memory(vehicleId)
            if (veh_obj ~= 0) then
                for j = 0,20 do
                    enter_vehicle(vehicleId, PlayerIndex, j)
                    exit_vehicle(PlayerIndex)
                end
                destroy_object(vehicleId)
            end
		end
	end
	return false
end

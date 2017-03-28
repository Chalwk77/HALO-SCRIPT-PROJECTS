--[[
------------------------------------
Script Name: Custom Portal System, for SAPP | (PC\CE)

Description: Teleport from 1 Location to Another. 
             All original OZ-4 SDTM (bloodgulch( portals are currently listed
             
             TO DO: Portals on a per-map basis

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"

debug = false

-- FROM X,Y,Z - TO X,Y,Z, Radius
Teleport = {}
Teleport[1] = { 43.125, -78.434, -0.220,        15.713, -102.762, 13.462,       0.5}
Teleport[2] = { 43.112, -80.069, -0.253,        68.123, -92.847, 2.167,         0.5}
Teleport[3] = { 37.105, -80.069, -0.255,        108.005, -109.328, 1.924,       0.5}
Teleport[4] = { 37.080, -78.426, -0.238,        79.924, -64.560, 4.669,         0.5}
Teleport[5] = { 43.456, -77.197, 0.633,         29.528, -52.746, 3.100,         0.5}
Teleport[6] = { 74.304, -77.590, 6.552,         76.001, -77.936, 11.425,        0.5}
Teleport[7] = { 98.559, -158.558, -0.253,       63.338, -169.305, 3.702,        0.5}
Teleport[8] = { 98.541, -160.190, -0.255,       120.801, -182.946, 6.766,       0.5}
Teleport[9] = { 92.550, -158.581, -0.256,       46.934, -151.024, 4.496,        0.5}
Teleport[10] = { 92.538, -160.213, -0.215,      112.550, -127.203, 1.905,       0.5}
Teleport[11] = { 98.935, -157.626, 0.425,       95.725, -91.968, 5.314,         0.5}
Teleport[12] = { 70.499, -62.119, 5.382,        122.615, -123.520, 15.916,      0.5}
Teleport[13] = { 63.693, -177.303, 5.606,       19.030, -103.428, 19.150,       0.5}
Teleport[14] = { 120.616, -185.624, 7.637,      94.815, -114.354, 15.860,       0.5}
Teleport[15] = { 94.351, -97.615, 5.184,        92.792, -93.604, 9.501,         0.5}
Teleport[16] = { 14.852, -99.241, 8.995,        50.409, -155.826, 21.830,       0.5}
Teleport[17] = { 43.258, -45.365, 20.901,       82.065, -68.507, 18.152,        0.5}
Teleport[18] = { 82.459, -73.877, 15.729,       67.970, -86.299, 23.393,        0.5}
Teleport[19] = { 77.289, -89.126, 22.765,       94.772, -114.362, 15.820,       0.5}
Teleport[20] = { 101.224, -117.028, 14.884,     125.026, -135.580, 13.593,      0.5}
Teleport[21] = { 131.785, -169.872, 15.951,     127.812, -184.557, 16.420,      0.5}
Teleport[22] = { 120.665, -188.766, 13.752,     109.956, -188.522, 14.437,      0.5}
Teleport[23] = { 97.476, -188.912, 15.718,      53.653, -157.885, 21.753,       0.5}
Teleport[24] = { 48.046, -153.087, 21.181,      23.112, -59.428, 16.352,        0.5}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
end

function OnScriptUnload() end

function OnTick()
    for i = 1, 16 do
        if (player_alive(i)) then
            for j = 1,#Teleport do 
                if Teleport ~= {} and Teleport[j] ~= nil then
                    local player = read_dword(get_player(i) + 0x34)
                    if inSphere(i, Teleport[j][1], Teleport[j][2], Teleport[j][3], Teleport[j][7]) == true then
                        TeleportPlayer(player, Teleport[j][4], Teleport[j][5], Teleport[j][6])
                        if debug then 
                            cprint("Teleporting FROM: " .. Teleport[j][1] .. Teleport[j][2] .. Teleport[j][3] .. "", 2+8)
                            cprint("Teleporting TO: " .. Teleport[j][4] .. Teleport[j][5] .. Teleport[j][6] .. "", 3+8)
                        end
                    end
                end
            end
        end
    end
end

function TeleportPlayer(player, x, y, z)
    local object = get_object_memory(player)
    if get_object_memory(player) ~= 0 then
        write_vector3d(object + 0x5C, x, y, z + 0.2)
    end
end

function inSphere(PlayerIndex, x, y, z, radius)
    if PlayerIndex then
        local player_static = get_player(PlayerIndex)
        local obj_x = read_float(player_static + 0xF8)
        local obj_y = read_float(player_static + 0xFC)
        local obj_z = read_float(player_static + 0x100)
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

function OnError(Message)
    print(debug.traceback())
end
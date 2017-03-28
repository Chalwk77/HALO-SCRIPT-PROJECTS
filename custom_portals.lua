--[[
------------------------------------
Script Name: Custom Portal System, for SAPP | (PC\CE)

Description: Teleport from 1 location to another on a per map basis.

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

-- Turn Debug mode ON or OFF -  'true' | 'false'
_debug_ = false
Teleport = { }

-- FROM     (X,Y,Z, RADIUS)     TO     (X,Y,Z)
Teleport["bloodgulch"] = {
    { 43.125, - 78.434, - 0.220,        0.5,    15.713, - 102.762, 13.462 },
    { 43.112, - 80.069, - 0.253,        0.5,    68.123, - 92.847, 2.167 },
    { 37.105, - 80.069, - 0.255,        0.5,    108.005, - 109.328, 1.924 },
    { 37.080, - 78.426, - 0.238,        0.5,    79.924, - 64.560, 4.669 },
    { 43.456, - 77.197, 0.633,          0.5,    29.528, - 52.746, 3.100 },
    { 74.304, - 77.590, 6.552,          0.5,    76.001, - 77.936, 11.425 },
    { 98.559, - 158.558, - 0.253,       0.5,    63.338, - 169.305, 3.702 },
    { 98.541, - 160.190, - 0.255,       0.5,    120.801, - 182.946, 6.766 },
    { 92.550, - 158.581, - 0.256,       0.5,    46.934, - 151.024, 4.496 },
    { 92.538, - 160.213, - 0.215,       0.5,    112.550, - 127.203, 1.905 },
    { 98.935, - 157.626, 0.425,         0.5,    95.725, - 91.968, 5.314 },
    { 70.499, - 62.119, 5.382,          0.5,    122.615, - 123.520, 15.916 },
    { 63.693, - 177.303, 5.606,         0.5,    19.030, - 103.428, 19.150 },
    { 120.616, - 185.624, 7.637,        0.5,    94.815, - 114.354, 15.860 },
    { 94.351, - 97.615, 5.184,          0.5,    92.792, - 93.604, 9.501 },
    { 14.852, - 99.241, 8.995,          0.5,    50.409, - 155.826, 21.830 },
    { 43.258, - 45.365, 20.901,         0.5,    82.065, - 68.507, 18.152 },
    { 82.459, - 73.877, 15.729,         0.5,    67.970, - 86.299, 23.393 },
    { 77.289, - 89.126, 22.765,         0.5,    94.772, - 114.362, 15.820 },
    { 101.224, - 117.028, 14.884,       0.5,    125.026, - 135.580, 13.593 },
    { 131.785, - 169.872, 15.951,       0.5,    127.812, - 184.557, 16.420 },
    { 120.665, - 188.766, 13.752,       0.5,    109.956, - 188.522, 14.437 },
    { 97.476, - 188.912, 15.718,        0.5,    53.653, - 157.885, 21.753 },
    { 48.046, - 153.087, 21.181,        0.5,    23.112, - 59.428, 16.352 }
}
Teleport["deathisland"] = {
    { -30.300, 31.499, 16.678,      0.5,    -4.597, -3.947, 21.799 }
}
Teleport["icefields"] = {
    { -26.067, 32.500, 9.008,       0.5,    -44.051, 44.818, 8.661 }
}
Teleport["infinity"] = {
    { -13.961, -61.578, 12.341,     0.5,    -53.296, -115.652, 15.645 }
}
Teleport["sidewinder"] = {
    { 1.800, 54.512, -2.801,        0.5,    4.887, -42.818, -3.841 }
}
Teleport["timberland"] = {
    { 0.936, -1.175, -21.120,       0.5,    27.454, -0.054, -18.329 }
}
Teleport["dangercanyon"] = {
    { -0.059, 34.151, 0.268,        0.5,    -0.043, 45.401, -8.365 }
}
Teleport["beavercreek"] = {
    { 13.633, 13.249, -0.606,       0.5,    16.863, 19.277, 5.110 }
}
Teleport["boardingaction"] = {
    { 18.204, -0.537, 0.600,        0.5,    1.723, 0.478, 0.600 }
}
Teleport["carousel"] = {
    { 0.021, -0.003, -0.855,        0.5,    -0.030, -0.054, -2.755 }
}
Teleport["chillout"] = {
    { -7.563, 5.091, 0.502,         0.5,    7.510, 0.650, 2.382 }
}
Teleport["damnation"] = {
    { -1.998, -4.382, 3.401,        0.5,    -11.598, 5.122, -0.199 }
}
Teleport["gephyrophobia"] = {
    { 26.830, -72.245, -2.808,      0.5,    26.772, -72.189, 11.023 }
}
Teleport["hangemhigh"] = {
    { 19.747, -2.435, -9.251,       0.5,    32.107, -2.634, -5.582 }
}
Teleport["longest"] = {
    { 0.352, -14.834, 2.105,        0.5,    -2.178, -14.272, 2.105 }
}
Teleport["prisoner"] = {
    { 0.854, -0.003, 1.393,         0.5,    9.694, -5.678, 3.193 }
}
Teleport["putput"] = {
    { -3.754, -20.866, 0.904,       0.5,    31.783, -29.286, 1.001 }
}
Teleport["ratrace"] = {
    { 7.594, -11.212, 0.223,        0.5,    -3.340, -12.891, 0.223 }
}
Teleport["wizard"] = {
    { -0.761, 0.761, -2.299,        0.5,    8.641, -8.624, -1.999 }
}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
end

function OnScriptUnload()

end

function OnNewGame()
    mapname = get_var(1, "$map")
end

function OnTick()
    for i = 1, 16 do
        if (player_alive(i)) then
            for j = 1, #Teleport[mapname] do
                if Teleport[mapname] ~= { } and Teleport[mapname][j] ~= nil then
                    local player = read_dword(get_player(i) + 0x34)
                    if inSphere(i, Teleport[mapname][j][1], Teleport[mapname][j][2], Teleport[mapname][j][3], Teleport[mapname][j][4]) == true then
                        TeleportPlayer(player, Teleport[mapname][j][5], Teleport[mapname][j][6], Teleport[mapname][j][7])
                        if _debug_ then
                            cprint("Teleporting FROM: " .. Teleport[mapname][j][1] .. Teleport[mapname][j][2] .. Teleport[mapname][j][3] .. "", 2 + 8)
                            cprint("Teleporting TO: " .. Teleport[mapname][j][4] .. Teleport[mapname][j][5] .. Teleport[mapname][j][6] .. "", 3 + 8)
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
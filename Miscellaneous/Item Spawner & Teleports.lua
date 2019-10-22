--[[
--=====================================================================================================--
Script Name: Item Spawner & Teleports, for SAPP (PC & CE)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local teleports, objects = {}, {}
local mapname = nil

function init()

    -- Configuration STARTS -------------------------------------
    
    teleports = {
        -- Position 1 (x,y,z,radius) | Position 2 (x,y,z)
        ["bloodgulch"] = {
            { 43.125, -78.434, -0.220, 0.5, 15.713, -102.762, 13.462},
            { 43.112, -80.069, -0.253, 0.5, 68.123, -92.847, 2.167},
            { 37.105, -80.069, -0.255, 0.5, 108.005, -109.328, 1.924},
            { 37.080, -78.426, -0.238, 0.5, 79.924, -64.560, 4.669},
            { 43.456, -77.197, 0.633, 0.5, 29.528, -52.746, 3.100},
            { 74.304, -77.590, 6.552, 0.5, 76.001, -77.936, 11.425},
            { 98.559, -158.558, -0.253, 0.5, 63.338, -169.305, 3.702},
            { 98.541, -160.190, -0.255, 0.5, 120.801, -182.946, 6.766},
            { 92.550, -158.581, -0.256, 0.5, 46.934, -151.024, 4.496},
            { 92.538, -160.213, -0.215, 0.5, 112.550, -127.203, 1.905},
            { 98.935, -157.626, 0.425, 0.5, 95.725, -91.968, 5.314},
            { 70.499, -62.119, 5.382, 0.5, 122.615, -123.520, 15.916},
            { 63.693, -177.303, 5.606, 0.5, 19.030, -103.428, 19.150},
            { 120.616, -185.624, 7.637, 0.5, 94.815, -114.354, 15.860},
            { 94.351, -97.615, 5.184, 0.5, 92.792, -93.604, 9.501},
            { 14.852, -99.241, 8.995, 0.5, 50.409, -155.826, 21.830},
            { 43.258, -45.365, 20.901, 0.5, 82.065, -68.507, 18.152},
            { 82.459, -73.877, 15.729, 0.5, 67.970, -86.299, 23.393},
            { 77.289, -89.126, 22.765, 0.5, 94.772, -114.362, 15.820},
            { 101.224, -117.028, 14.884, 0.5, 125.026, -135.580, 13.593},
            { 131.785, -169.872, 15.951, 0.5, 127.812, -184.557, 16.420},
            { 120.665, -188.766, 13.752, 0.5, 109.956, -188.522, 14.437},
            { 97.476, -188.912, 15.718, 0.5, 53.653, -157.885, 21.753},
            { 48.046, -153.087, 21.181, 0.5, 23.112, -59.428, 16.352},
            { 118.263, -120.761, 17.192, 0.5, 40.194, -139.990, 2.733},
        }
    }
    
    objects = {
        ["bloodgulch"] = {
            { "eqip", "powerups\\health pack", 74.391, - 77.651, 5.698},
            { "eqip", "powerups\\health pack", 70.650, - 61.932, 4.095},
            { "eqip", "powerups\\health pack", 63.551, - 177.337, 4.181},
            { "eqip", "powerups\\health pack", 120.247, - 185.103, 6.495},
            { "eqip", "powerups\\health pack", 94.351, - 97.615, 5.184},
            { "eqip", "powerups\\health pack", 12.928, - 103.277, 13.990},
            { "eqip", "powerups\\health pack", 48.060, - 153.092, 21.190},
            { "eqip", "powerups\\health pack", 43.253, - 45.376, 20.920},
            { "eqip", "powerups\\health pack", 43.253, - 45.376, 20.920},
            { "eqip", "powerups\\health pack", 77.279, - 89.107, 22.571},
            { "eqip", "powerups\\health pack", 101.034, - 117.048, 14.795},
            { "eqip", "powerups\\health pack", 118.244, - 120.757, 17.229},
            { "eqip", "powerups\\health pack", 131.737, - 169.891, 15.870},
            { "eqip", "powerups\\health pack", 121.011, - 188.595, 13.771},
            { "eqip", "powerups\\health pack", 97.504, - 188.913, 15.784}
        }
    }
    -- Configuration ENDS -------------------------------------
    
    --# Do Not Touch #--
    execute_command("sv_map_reset")
    mapname = get_var(0, "$map")
    local obj = objects[mapname]
    
    for i = 1, #obj do
        if (obj[i] ~= nil) then
            -- Tag Type, Tag Name, X,Y,Z
            spawn_object(obj[i][1], obj[i][2], obj[i][3], obj[i][4], obj[i][5])
        end
    end
end

local sqrt = math.sqrt

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    if (get_var(0, "$gt") ~= "n/a") then
        init()
    end
end

function OnScriptUnload()
    --
end

function OnNewGame()
    if (get_var(0, "$gt") ~= "n/a") then
        init()
    end
end

function OnTick()

    local tp = teleports[mapname]

    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            for j = 1, #tp do
                if tp[j] ~= nil then
                    local player_object = get_dynamic_player(i)
                    if (player_object ~= 0) then
                        
                        local fromX, fromY, fromZ = tp[j][1], tp[j][2], tp[j][3]
                        local radius = tp[j][4]
                        
                        local coords = GetCoords(i, player_object)
                        local distance = sqrt((coords.x - fromX) ^ 2 + (coords.y - fromY) ^ 2 + (coords.z - fromZ) ^ 2)
                        if (distance <= radius) then
                            local toX, toY, toZ = tp[j][5], tp[j][6], tp[j][7]
                            write_vector3d(player_object + 0x5C, toX, toY, toZ + 0.3)
                        end
                    end
                end
            end
        end
    end
end


function GetCoords(PlayerIndex, PlayerObject)
    local coords, x,y,z = { }
    
    local VehicleID = read_dword(PlayerObject + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        coords.invehicle = false
        x, y, z = read_vector3d(PlayerObject + 0x5c)
    else
        coords.invehicle = true
        x, y, z  = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end
    
    if (coords.invehicle) then
        z = z + 1
    end
    
    coords.x, coords.y, coords.z = x, y, z
    return coords
end

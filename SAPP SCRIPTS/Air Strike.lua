--[[
--=====================================================================================================--
Script Name: Airstrike, for SAPP (PC & CE)

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- airstrike projectile
local projectile = "weapons\\rocket launcher\\rocket"

-- quantity of projectiles spawned
local min_proj = 1
local max_proj = 10

-- interval between airstrikes
local min_interval = 1
local max_interval = 30

-- projectile x,y,z velocity
local proj_x_vel = math.random(-0.5, 0.5)
local proj_y_vel = math.random(-0.5, 0.5)
local proj_z_vel = math.random(-10, -0.5)

-- height the projectile is spawned from the ground
local height = 15


strike_locations = {}
-- projectile x,y,z spawn coordinates
strike_locations["bloodgulch"] = {
    {64, -112.09, 2.21},
    {52.96, -93.79, 0.47},
    {38.64, -91.71, 0.37},
    {81.41, -145.96, 0.6},
    {36.64, -105.38, 1.8},
    {92.14, -141.23, 1.18},
    {79.61, -135.17, 0.99},
    {80.48, -121.13, 0.63},
    {61.68, -129.85, 1.37},
    {46.78, -131.33, 1.28},
    {47.78, -116.02, 0.74},
    {80.01, -107.42, 2.31},
    {81.66, -116.47, 0.78},
    {94.88, -127.31, 1.77},
    {101.5, -143.25, 1.07},
    {82.27, -156.12, 0.19},
    {52.43, -111.84, 0.64},
    {28.06, -19.75, -18.65}
    }
    
-- do not touch anything below this point --
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    strike_timer = 0
end

function OnScriptUnload() end

function OnTick()
    strike_timer = strike_timer + 0.030
    if (strike_timer >= math.random(min_interval, max_interval)) then
        local index = math.random(1, #strike_locations[get_var(0, "$map")])
        if index ~= nil then
            posX = strike_locations[get_var(0, "$map")][index][1]
            posY = strike_locations[get_var(0, "$map")][index][2]
            posZ = strike_locations[get_var(0, "$map")][index][3]
        end
        InitiateStrike(posX, posY, posZ)
        strike_timer = 0
    end
end

function InitiateStrike(x, y, z)
    for i = min_proj,max_proj do
        local payload = spawn_object("proj", projectile, x, y, z + height)
		write_float(get_object_memory(payload) + 0x68, proj_x_vel)
        write_float(get_object_memory(payload) + 0x6C, proj_y_vel)
        write_float(get_object_memory(payload) + 0x70, proj_z_vel)
    end
end

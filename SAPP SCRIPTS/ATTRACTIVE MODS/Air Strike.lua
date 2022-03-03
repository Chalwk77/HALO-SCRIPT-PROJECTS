--[[
--=====================================================================================================--
Script Name: Airstrike, for SAPP (PC & CE)

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local min_proj = 1
local max_proj = 2

local min_interval = 1
local max_interval = 60

local min_height = 5
local max_height = 20

local min_x_vel = -5
local max_x_vel = 5

local min_y_vel = -10
local max_y_vel = 5

local min_z_vel = -10
local max_z_vel = -0.5

local strike_locations = {
    ["bloodgulch"] = {
        { 64, -112.09, 2.21 },
        { 52.96, -93.79, 0.47 },
        { 38.64, -91.71, 0.37 },
        { 81.41, -145.96, 0.6 },
        { 36.64, -105.38, 1.8 },
        { 92.14, -141.23, 1.18 },
        { 79.61, -135.17, 0.99 },
        { 80.48, -121.13, 0.63 },
        { 61.68, -129.85, 1.37 },
        { 46.78, -131.33, 1.28 },
        { 47.78, -116.02, 0.74 },
        { 80.01, -107.42, 2.31 },
        { 81.66, -116.47, 0.78 },
        { 94.88, -127.31, 1.77 },
        { 101.5, -143.25, 1.07 },
        { 82.27, -156.12, 0.19 },
        { 52.43, -111.84, 0.64 },
        { 28.06, -19.75, -18.65 }
    }
}

local rocket
local locations
local start, finish
local time = os.time

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
end

local function NewTimes()
    start = time
    finish = time() + rand(min_interval, max_interval + 1)
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        rocket = GetTag('proj', "weapons\\rocket launcher\\rocket")

        local map = get_var(0, '$map')
        locations = strike_locations[map]

        if (locations and rocket) then
            NewTimes()
            register_callback(cb['EVENT_TICK'], 'OnTick')
        end
        return
    end
    unregister_callback(cb['EVENT_TICK'])
end

function OnScriptUnload()
    -- N/A
end

function OnTick()
    if (start() >= finish) then

        local n = rand(1, #locations + 1)
        local x = locations[n][1]
        local y = locations[n][2]
        local z = locations[n][3]

        for _ = min_proj, max_proj do

            local h = rand(min_height, max_height + 1)
            local payload = spawn_object('', '', x, y, z + h, 0, rocket)
            local object = get_object_memory(payload)

            if (object ~= 0) then
                local x_vel = rand(min_x_vel, max_x_vel + 1)
                local y_vel = rand(min_y_vel, max_y_vel + 1)
                local z_vel = rand(min_z_vel, max_z_vel + 1)
                write_float(object + 0x68, x_vel)
                write_float(object + 0x6C, y_vel)
                write_float(object + 0x70, z_vel)
            end
        end

        NewTimes()
    end
end

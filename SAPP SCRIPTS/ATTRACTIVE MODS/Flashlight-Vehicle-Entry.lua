--[[
--=====================================================================================================--
Script Name: Flashlight-Vehicle-Entry (v1.0), for SAPP (PC & CE)
Description: Aim your crosshair at a vehicle and press your flashlight button to enter it!

             If setting "must_have_driver" is enabled, you can only enter vehicles
             occupied by an ally. However, if this setting is false, you can enter
             any unoccupied vehicle - You will always enter into the Driver Seat first.


Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

~ Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

-- [CONFIG STARTS] --------------------------------------------------------------------------

local vehicles = {
    [1] = { enabled = true, "vehi", "vehicles\\warthog\\mp_warthog" },
    [2] = { enabled = false, "vehi", "vehicles\\ghost\\ghost_mp" },
    [3] = { enabled = true, "vehi", "vehicles\\rwarthog\\rwarthog" },
    [4] = { enabled = false, "vehi", "vehicles\\banshee\\banshee_mp" },
    [5] = { enabled = true, "vehi", "vehicles\\scorpion\\scorpion_mp" },
    [6] = { enabled = false, "vehi", "vehicles\\c gun turret\\c gun turret_mp" }
}

-- If true, the vehicle must have a driver in order to enter it.
local must_have_driver = false

-- Players must be within this many world units to enter a vehicle.
local trigger_distance = 30 -- in world units
-- [CONFIG ENDS] ----------------------------------------------------------------------------

api_version = "1.12.0.0"
local game_over

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_GAME_START"], "OnGameEnd")
end

function OnScriptUnload()

end

function OnGameStart()
    game_over = false
end

function OnGameEnd()
    game_over = true
end

function OnTick()
    if (not game_over) then
        for i = 1, 16 do
            if player_present(i) and player_alive(i) then
                local dynamic_player = get_dynamic_player(i)
                if (dynamic_player ~= 0) then
                    -- Camera Aim + Player Coordinates
                    local CamX, CamY, CamZ = read_float(dynamic_player + 0x230), read_float(dynamic_player + 0x234), read_float(dynamic_player + 0x238)
                    local x, y, z = read_vector3d(dynamic_player + 0x5c)

                    -- Crouch State;
                    local crouching = read_float(dynamic_player + 0x50C)
                    if (crouching == 0) then
                        z = z + 0.65
                    else
                        z = z + (0.35 * crouching)
                    end

                    -- Check if camera intersecting with object:
                    local success, Vx, Vy, Vz, object = intersect(x, y, z, CamX * 1000, CamY * 1000, CamZ * 1000)
                    if (success and object ~= nil) then

                        -- Get the memory address of this object:
                        local VehicleObject = get_object_memory(object)
                        if (VehicleObject ~= 0) then

                            -- Check if the object is a vehicle:
                            local ObjectType = read_byte(VehicleObject + 0xB4)
                            if (ObjectType == 1) then
                                if WithinRange(x, y, z, Vx, Vy, Vz) then

                                    -- Get the vehicle tag address:
                                    local VehicleTag = read_dword(VehicleObject)

                                    for j = 1, #vehicles do
                                        if vehicles[j].enabled then
                                            if VehicleTag == TagInfo(vehicles[j][1], vehicles[j][2]) then
                                                -- Check flashlight button state:
                                                local flashlight = read_bit(dynamic_player + 0x208, 4)
                                                if (flashlight == 1) then
                                                    local v = isOccupied(VehicleObject, i)
                                                    local team = get_var(i, "$team")

                                                    if (team == v.team) then
                                                        local case_scenarios = {
                                                            [1] = { -- HAS DRIVER, NO GUNNER, NO PASSENGER
                                                                case = (v.driver == true and not v.gunner and not v.passenger and must_have_driver),
                                                                func = function()
                                                                    -- Enter Gunner Seat
                                                                    EnterVehicle(object, i, 2)
                                                                end
                                                            },
                                                            [2] = { -- HAS DRIVER, NO GUNNER, HAS PASSENGER
                                                                case = (v.driver == true and not v.gunner and v.passenger == true and must_have_driver),
                                                                func = function()
                                                                    -- Enter Gunner Seat
                                                                    EnterVehicle(object, i, 2)
                                                                end
                                                            },
                                                            [3] = { -- HAS DRIVER, HAS GUNNER, NO PASSENGER
                                                                case = (v.driver == true and v.gunner == true and not v.passenger and must_have_driver),
                                                                func = function()
                                                                    -- Enter Passenger Seat
                                                                    EnterVehicle(object, i, 1)
                                                                end
                                                            },
                                                            [4] = { -- NO DRIVER
                                                                case = (not v.driver and not must_have_driver),
                                                                func = function()
                                                                    -- Enter Driver Seat
                                                                    EnterVehicle(object, i, 0)
                                                                end
                                                            },
                                                            [5] = { -- HAS DRIVER, NO GUNNER, NO PASSENGER
                                                                case = (v.driver == true and not v.gunner and not v.passenger and not must_have_driver),
                                                                func = function()
                                                                    -- Enter Gunner Seat
                                                                    EnterVehicle(object, i, 2)
                                                                end
                                                            },
                                                            [6] = { -- HAS DRIVER, HAS GUNNER, NO PASSENGER
                                                                case = (v.driver == true and v.gunner == true and not v.passenger and not must_have_driver),
                                                                func = function()
                                                                    -- Enter Passenger Seat
                                                                    EnterVehicle(object, i, 1)
                                                                end
                                                            },
                                                            [7] = { -- HAS DRIVER, NO GUNNER, HAS PASSENGER
                                                                case = (v.driver == true and not v.gunner and v.passenger == true and not must_have_driver),
                                                                func = function()
                                                                    -- Enter Gunner Seat
                                                                    EnterVehicle(object, i, 2)
                                                                end
                                                            }
                                                        }
                                                        for index = 1, #case_scenarios do
                                                            if (case_scenarios[index].case) then
                                                                case_scenarios[index].func()
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function isOccupied(TargetObjectMemory, ExcludePlayer)

    local vehicle = { }
    vehicle.team = get_var(ExcludePlayer, "$team")
    vehicle.driver, vehicle.gunner, vehicle.passenger = false, false, false

    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            if (i ~= ExcludePlayer) then
                local dynamic_player = get_dynamic_player(i)
                local Vehicle = read_dword(dynamic_player + 0x11C)
                if (Vehicle ~= 0xFFFFFFFF) then
                    local ObjectMemory = get_object_memory(Vehicle)
                    if (ObjectMemory == TargetObjectMemory) then
                        local seat = read_word(dynamic_player + 0x2F0)
                        vehicle.team = get_var(i, "$team")
                        if (seat == 0) then
                            vehicle.driver = true
                        elseif (seat == 2) then
                            vehicle.gunner = true
                        elseif (seat == 1) then
                            vehicle.passenger = true
                        end
                    end
                end
            end
        end
    end

    return vehicle
end

function WithinRange(X, Y, Z, Vx, Vy, Vz)
    local distance = tonumber(math.sqrt(((X - Vx) * (X - Vx)) + ((Y - Vy) * (Y - Vy)) + ((Z - Vz) * (X - Vz))))
    if (distance <= trigger_distance) then
        return true
    end
end

function EnterVehicle(Vehicle, PlayerIndex, Seat)
    enter_vehicle(Vehicle, PlayerIndex, Seat)
end

function TagInfo(Type, Name)
    local tag_id = lookup_tag(Type, Name)
    return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end

--[[
--======================================================================================================--
Script Name: HLN Vehicle Spawner (v1.4), for SAPP (PC & CE)
Description: This script will force you into a vehicle of your choice by 
             means of a keyword typed in chat.

FEATURES: 
	* Command cooldowns
	* Auto Vehicle Despawn System
	* Limited Command uses (per game basis)
	* Customizable messages

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)

--======================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [Starts] ---------------------------------------------
local settings = {
    path = "sapp\\vehicles.json",
    spawns_per_game = 10, -- Number of vehicles the player can spawn PER GAME.
    despawn_time = 30, -- Unoccupied vehicles will despawn after this amount of time (in seconds)"
    cooldown_duration = 5, -- Command cooldown period.

    -- Custom Messages:
    on_spawn = "Vehicle entry-spawns remaining: %total%",
    please_wait = "Please wait %seconds% seconds to entry-spawn another vehicle",
    already_occupied = "You are already in a vehicle!",
    insufficient_spawns = "You have exceeded your Vehicle Entry-Spawn Limit for this game.",
}
-- Configuration [Ends] ---------------------------------------------

-- Do not touch:
local vehicle_objects, spawns = {}, {}
local map_data = {}
local time_scale, game_started = 0.03333333333333333, nil
local gmatch, gsub, floor = string.gmatch, string.gsub, math.floor

local json = (loadfile "sapp\\json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_CHAT"], "OnPlayerChat")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    if (get_var(0, "$gt") ~= "n/a") then
        CheckFile()
        for i = 1, 16 do
            InitPlayer(i, false)
        end
    end
end

function OnScriptUnload()
    for k, _ in pairs(vehicle_objects) do
        if (vehicle_objects[k] ~= nil) then
            destroy_object(k)
            vehicle_objects[k] = nil
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        CheckFile()
    end
end

function OnGameEnd()
    game_started = false
end

function OnTick()
    if (game_started) then
        for i = 1, 16 do
            if player_present(i) and player_alive(i) then
                DespawnHandler(i)
                local t = spawns[i]
                if (t.cooldown_triggered) then
                    t.cooldown = t.cooldown - time_scale
                    -- print("Cooldown ends in " .. floor(t.cooldown) .. " seconds")
                    if (t.cooldown <= 1) then
                        t.cooldown = settings.cooldown_duration
                        t.cooldown_triggered = false
                    end
                end
            end
        end
    end
end

function DespawnHandler(PlayerIndex)
    for k, v in pairs(vehicle_objects) do
        if (vehicle_objects[k] ~= nil) then
            if (v.vehicle ~= 0) then
                local occupied = false

                local player_object = get_dynamic_player(PlayerIndex)
                local VehicleID = read_dword(player_object + 0x11C)
                if (VehicleID ~= 0xFFFFFFFF) then
                    local current_vehicle = get_object_memory(VehicleID)
                    if (current_vehicle ~= 0) then
                        if (v.vehicle == current_vehicle) then
                            occupied = true
                            v.timer_reset = true
                        end
                    end
                end

                if (not occupied) then

                    if (v.timer_reset) then
                        v.timer_reset = false
                        v.timer = settings.despawn_time
                    end

                    v.timer = v.timer - time_scale
                    -- print("Vehicle [ID "..k.."] despawning in " .. floor(v.timer) .. " seconds")
                    if (vehicle_objects[k].timer <= 0) then
                        destroy_object(k)
                        vehicle_objects[k] = nil
                    end
                end
            end
        end
    end
end

function OnPlayerChat(PlayerIndex, Message, Type)
    local msg = stringSplit(Message)

    if (Type ~= 6) then
        if (#msg == 0) then
            return false
        else
            if player_alive(PlayerIndex) then
				if (#map_data > 0) then
					for command, Vehicle in pairs(map_data) do
						if (msg[1] == command) then

							if GetTag(Vehicle.vehicle) then
								cprint(data)
								local t = spawns[PlayerIndex]
								if (t.uses > 0) then
									if (not t.cooldown_triggered) then

										local player_object = get_dynamic_player(PlayerIndex)
										local coords = getXYZ(PlayerIndex, player_object)

										if not (coords.invehicle) then
											t.cooldown_triggered = true
											t.uses = t.uses - 1

											local vehicle = spawn_object("vehi", Vehicle.vehicle, coords.x, coords.y, coords.z)
											local vehicle_object_memory = get_object_memory(vehicle)

											if (vehicle_object_memory ~= 0) then
												vehicle_objects[vehicle] = {
													timer_reset = false,
													vehicle = vehicle_object_memory,
													timer = settings.despawn_time,
												}
											end

											if (tonumber(Vehicle.seat) == 7) then
												enter_vehicle(vehicle, PlayerIndex, 0)
												enter_vehicle(vehicle, PlayerIndex, 2)
											else
												enter_vehicle(vehicle, PlayerIndex, 0)
											end

											local msg = gsub(settings.on_spawn, "%%total%%", tostring(t.uses))
											rprint(PlayerIndex, msg)
										else
											rprint(PlayerIndex, settings.already_occupied)
										end
									else
										local message = gsub(settings.please_wait, "%%seconds%%", tostring(floor(t.cooldown)))
										rprint(PlayerIndex, message)
									end
								else
									rprint(PlayerIndex, settings.insufficient_spawns)
								end
							else
								rprint(PlayerIndex, "Invalid Vehicle Tag Address")
								rprint(PlayerIndex, "Please Contact an Administrator. Map Name: " .. get_var(0, "$map"))
							end
							return false
						end
                    end
				else
					rprint(PlayerIndex, "Map Error:")
					rprint(PlayerIndex, get_var(0, "$map") .. " is not in the vehicles.json database")
                end
            else
                rprint(PlayerIndex, "Please wait until you respawn!")
            end
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnPlayerDisconnect(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function OnPlayerDeath(PlayerIndex)
    spawns[PlayerIndex].cooldown_triggered = false
    spawns[PlayerIndex].cooldown = settings.cooldown_duration
end

function stringSplit(Command)
    local t, i = {}, 1
    for Args in gmatch(Command, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

function InitPlayer(PlayerIndex, Reset)
    if not (Reset) then
        spawns[PlayerIndex] = {
            cooldown = settings.cooldown_duration,
            cooldown_triggered = false,
            uses = settings.spawns_per_game,
        }
    else
        spawns[PlayerIndex] = {}
    end
end

function getXYZ(PlayerIndex, PlayerObject)
    local coords, x, y, z = { }
    if player_alive(PlayerIndex) then
        local VehicleID = read_dword(PlayerObject + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            coords.invehicle = false
            x, y, z = read_vector3d(PlayerObject + 0x5c)
        else
            coords.invehicle = true
            x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
        end

        if (coords.invehicle) then
            z = z + 1
        end
        coords.x, coords.y, coords.z = x, y, z
    end
    return coords
end

function GetTag(Object)
    local tag = lookup_tag("vehi", Object)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function CheckFile()

    local path = settings.path
    local file = io.open(path, "a")
    if (file ~= nil) then
        io.close(file)
    end

    local info = nil
    local file = io.open(path, "r")
    if (file ~= nil) then
        local data = file:read("*all")
        info = json:decode(data)
        io.close(file)
    end

    if (info == nil) then
        local file = assert(io.open(path, "w"))
        if (file) then
            file:write("{\n}")
            io.close(file)
        end
    end

    local info
    local file = io.open(settings.path, "r")
    if (file ~= nil) then
        local data = file:read("*all")
        info = json:decode(data)
        io.close(file)
    end

	map_data = {}
    local current_map = get_var(0, "$map")
    if (info) then
        for map, v in pairs(info) do
            if (map) and (map == current_map) then
                map_data = v
            end
        end
    end
    game_started = true
end

function report(Error)
	local error_path = "sapp//VSpawnerErrorLog.txt"
    local file = io.open(error_path, "a")
    if (file ~= nil) then
        io.close(file)
    end
	
	local file = assert(io.open(error_path, "a+"))
	if (file) then
		file:write(Error.."\n\n")
		io.close(file)
	end
end

function OnError()
	local Error = debug.traceback()
    cprint(Error, 4 + 8)
    timer(50, "report", Error)
end

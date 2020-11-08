--[[
--=====================================================================================================--
Script Name: Item Spawner, for SAPP (PC & CE)
Description: An advanced item spawner mod.
Give yourself (or others) weapons, vehicles and equipment.

Command Syntax:
/give [item] [opt pid/* or "all"] [opt -amount]
/spawn [item] [opt pid/* or "all"] [opt -amount]
/enter [item] [opt pid/* or "all"] [opt -amount/-seat/-gd]
/enter [seat] [opt pid/* or "all"]
/enter
/clean [pid/* or "all"] [type]

Command Examples:

Command | Description
/give sniper                        Give sniper to yourself.
/give sniper 1                      Give sniper to player 1.
/give sniper 1 -amount 5            Give 5 sniper rifles to player 1.
/spawn tank                         Spawn tank at your location.
/spawn tank 1                       Spawn Tank at player 1's position.
/spawn tank 1 -amount 5             Spawn 5 tanks at player 1's position.
/enter hog                          Enter warthog at your current location.
/enter hog 1                        Enter player 1 into a warthog at their current position.
/enter hog 1 -amount 5              Enter player 1 into 5 warthogs at their current position.
/enter hog 1 -seat 3                Enter player 1 into passengers seat of warthog at their current position.
/enter hog 1 -gd                    Enter player 1 into gunner seat and driver seat of warthog at their current position.
/enter hog 1 -seat 3 -amount 10     Enter player 1 into passengers seat of 10 warthogs at their current position.
/enter hog 1 -gd -amount 10         Enter player 1 into gunner seat and driver seat of 10 warthogs at their current position.
/enter 1 1                          Force player 1 into seat 1 of the vehicle you're looking at.
/enter                              Enter the driver seat of the vehicle you're looking at.
/clean 1 1                          Clean Item Spawn Objects for player 1.
/clean 1 2                          Clean Vehicle Spawn Objects for player 1.
/clean 1 2                          Clean Vehicle Spawn & Item Spawn Objects for player 1.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local Mod = {
    commands = {
        ["give"] = {
            permission = 1,
            permission_other = 4,
            func = function(params)
                return Give(params)
            end
        },
        ["spawn"] = {
            permission = 1,
            permission_other = 4,
            func = function(params)
                return Spawn(params)
            end
        },
        ["enter"] = {
            permission = 1,
            aim_enter = true,
            permission_other = 4,
            func = function(params)
                return Enter(params)
            end
        },
        ["clean"] = {
            permission = 1,
            permission_other = 4,
            destroy = function(Ply, Type, Params)
                return ClearObjects(Ply, Type, Params)
            end
        }
    },

    items = {

        -- {tag type, tag name, item name, {list of commands to trigger}}


        { "bipd", "characters\\cyborg_mp\\cyborg_mp", "Cyborg", { "cyborg" } },

        -- Equipment: (give/spawn)
        { "eqip", "powerups\\health pack", "Health Pack", { "health", "hp", "hpack" } },
        { "eqip", "powerups\\active camouflage", "Camouflage", { "camo", "cam", "camouflage" } },
        { "eqip", "powerups\\over shield", "Over Shield", { "overshield", "os", "oshield", "sh" } },
        { "eqip", "weapons\\frag grenade\\frag grenade", "Frag Grenade", { "frag", "grenade", "fraggrenade", "fnade" } },
        { "eqip", "weapons\\plasma grenade\\plasma grenade", "Plasma Grenade", { "plasma", "plasmagrenade", "psnade" } },

        -- Vehicles: (enter/spawn)
        { "vehi", "vehicles\\ghost\\ghost_mp", "Ghost", { "ghost", "ghost_mp" } },
        { "vehi", "vehicles\\rwarthog\\rwarthog", "R-Hog", { "rhog", "rwarthog" } },
        { "vehi", "vehicles\\banshee\\banshee_mp", "Banshee", { "banshee", "banshee_mp", "bansh" } },
        { "vehi", "vehicles\\c gun turret\\c gun turret_mp", "Turret", { "turret", "cgun" } },
        { "vehi", "vehicles\\warthog\\mp_warthog", "Warthog", { "hog", "mp_warthog", "warthog" } },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", "Tank", { "tank", "scorpion", "scorpion_mp" } },

        -- Weapons: (give/spawn)
        { "weap", "weapons\\flag\\flag", "Flag", { "flag" } },
        { "weap", "weapons\\ball\\ball", "Skull", { "ball", "skull" } },
        { "weap", "weapons\\pistol\\pistol", "Pistol", { "pistol", "pist" } },
        { "weap", "weapons\\shotgun\\shotgun", "Shotgun", { "shotgun", "shotty" } },
        { "weap", "weapons\\needler\\mp_needler", "Needler", { "needler", "need" } },
        { "weap", "weapons\\plasma rifle\\plasma rifle", "Plasma Rifle", { "prifle", "plasmarifle" } },
        { "weap", "weapons\\flamethrower\\flamethrower", "Flamethrower", { "flamethrower", "fthrower" } },
        { "weap", "weapons\\plasma_cannon\\plasma_cannon", "Plasma Cannon", { "pcannon", "plasmacannon" } },
        { "weap", "weapons\\plasma pistol\\plasma pistol", "Plasma Pistol", { "ppistol", "plasmapistol" } },
        { "weap", "weapons\\assault rifle\\assault rifle", "Assault Rifle", { "arifle", "assaultrifle", "rifle" } },
        { "weap", "weapons\\sniper rifle\\sniper rifle", "Sniper Rifle", { "sniper", "snipe", "sniperrifle", "srifle" } },
        { "weap", "weapons\\rocket launcher\\rocket launcher", "Rocket Launcher", { "rocketl", "rocketlauncher", "rlauncher" } },

        -- Projectiles: (spawn)
        { "proj", "weapons\\flamethrower\\flame", "Flames", { "flame", "flameproj" } },
        { "proj", "weapons\\needler\\mp_needle", "Needler Needle", { "needle", "needlerproj" } },
        { "proj", "vehicles\\ghost\\ghost bolt", "Ghost Bolt", { "ghostbolt", "gbolt", "ghostproj" } },
        { "proj", "weapons\\rocket launcher\\rocket", "Rocket", { "rocketproj", "rocket" } },
        { "proj", "vehicles\\c gun turret\\mp gun turret", "Turret Bolt", { "turretbolt", "turretprooj" } },
        { "proj", "weapons\\pistol\\bullet", "Pistol Bullet", { "pistolbullet", "pbullet", "pistolproj" } },
        { "proj", "vehicles\\scorpion\\bullet", "Tank Bullet", { "tankbullet", "tbullet", "tankbulletproj" } },
        { "proj", "vehicles\\scorpion\\tank shell", "Tank Shell", { "tankshell", "tshell", "tankshellproj" } },
        { "proj", "vehicles\\warthog\\bullet", "Warthog Bullet", { "hogbullet", "wbullet", "warthogbullet", "warthogproj" } },
        { "proj", "weapons\\plasma pistol\\bolt", "Plasma Pistol Bolt", { "ppistolbolt", "plasmapistolbolt", "ppistolproj" } },
        { "proj", "weapons\\shotgun\\pellet", "Shotgun Pellet", { "shottyshot", "shotgunpallet", "shotpallet", "shotgunproj" } },
        { "proj", "vehicles\\banshee\\mp_banshee fuel rod", "Banshee Fuel Rod", { "sheerod", "bansheerod", "bansheefuelrodproj" } },
        { "proj", "weapons\\plasma_cannon\\plasma_cannon", "Plasma Cannon Shot", { "fuelrodshot", "frodshot", "fuelrodshotproj" } },
        { "proj", "weapons\\sniper rifle\\sniper bullet", "Sniper Bullet", { "snipershot", "snipeshot", "snipebullet", "sniperproj" } },
        { "proj", "weapons\\plasma rifle\\bolt", "Plasma Rifle Bolt", { "priflebolt", "plasmariflebolt", "prifleproj", "plasmarifleproj" } },
        { "proj", "vehicles\\banshee\\banshee bolt", "Banshee Bolt", { "sheebolt", "bbolt", "bansheebolt", "bansheebullet", "bansheeboltproj" } },
        { "proj", "weapons\\assault rifle\\bullet", "Assault Rifle Bullet", { "riflebullet", "ariflebullet", "assaultriflebullet", "assaultrifleproj", "arifleproj" } },
        { "proj", "weapons\\plasma rifle\\charged bolt", "Plasma Rifle Charged Bolt", { "priflecbolt", "plasmarcharged", "priflecharged", "priflechargedproj", "plasmariflechartedproj" } },
    },

    --
    -- Advanced Users Only:
    --

    -- Objects will spawn this world units in-front of the player:
    distance_from_player = 2.5,
}

local sin = math.sin
local gsub = string.gsub
local gmatch, lower = string.gmatch, string.lower

function Mod:Init()
    if (get_var(0, "$gt") ~= "n/a") then
        self.players = { }
    end
end

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    Mod:Init()
end

function OnGameStart()
    Mod:Init()
end

function OnPlayerDeath(P)
    Mod:ClearObjects(P, "item")
    Mod:ClearObjects(P, "vehicle")
end

function OnPlayerConnect(p)
    Mod.players[p] = { vehicle = { }, item = { }, enter = false, seat = 0, command_executor = p, name = get_var(p, "$name") }
end

function OnPlayerSpawn(p)
    Mod.players[p].seat = 0
    Mod.players[p].enter = false
    Mod.players[p].command_executor = p
end

function OnScriptUnload()
    for i = 1, 16 do
        if player_present(i) then
            Mod:ClearObjects(i, "item")
            Mod:ClearObjects(i, "vehicle")
        end
    end
end

function Mod:DriverSeatOccupied(Ply, Vehicle, Seat)
    local team = get_var(Ply, "$team")
    for i = 1, 16 do
        if (player_present(i) and i ~= Ply) then
            local DyN = get_dynamic_player(i)
            if (DyN ~= 0) then
                local VehicleID = read_dword(DyN + 0x11C)
                local VehicleObject = get_object_memory(VehicleID)
                if (VehicleID ~= 0xFFFFFFFF and VehicleObject == Vehicle) then
                    team = get_var(i, "$team")
                    local seat = tonumber(read_word(DyN + 0x2F0))
                    if (seat == 0) and (Seat == 0) then
                        return true, self:Respond(Ply, "Driver seat is occupied by " .. get_var(i, "$name"))
                    elseif (seat == 1) and (Seat == 1) then
                        return true, self:Respond(Ply, "Passenger seat is occupied by " .. get_var(i, "$name"))
                    elseif (seat == 2) and (Seat == 2) then
                        return true, self:Respond(Ply, "Gunner seat is occupied by " .. get_var(i, "$name"))
                    elseif (seat == 3) and (Seat == 3) then
                        return true, self:Respond(Ply, "Passenger seat is occupied by " .. get_var(i, "$name"))
                    elseif (seat == 4) and (Seat == 4) then
                        return true, self:Respond(Ply, "Passenger seat is occupied by " .. get_var(i, "$name"))
                    end
                end
            end
        end
    end
    return false, team
end

function Mod:OnTick()
    for i, v in pairs(self.players) do
        if (v.enter) then
            local coords = self:GetXYZ(v.command_executor)
            if (coords) then
                local InVehicle = self:GetXYZ(i)
                if (not InVehicle.invehicle) then
                    local x, y, z = read_float(coords.dyn + 0x230), read_float(coords.dyn + 0x234), read_float(coords.dyn + 0x238)
                    local couching = read_float(coords.dyn + 0x50C)
                    local px, py, pz = read_vector3d(coords.dyn + 0x5c)
                    if (couching == 0) then
                        pz = pz + 0.65
                    else
                        pz = pz + (0.35 * couching)
                    end
                    local ignore_player = read_dword(get_player(i) + 0x34)
                    local success, _, _, _, target = intersect(px, py, pz, x * 1000, y * 1000, z * 1000, ignore_player)
                    local VehicleObject = get_object_memory(target)
                    if (VehicleObject ~= 0) and (success == true and target ~= nil) and (v.enter) then
                        local occupied, Team = self:DriverSeatOccupied(i, VehicleObject, v.seat)
                        local team = get_var(v.command_executor, "$team")
                        if (team ~= Team) then
                            self:Respond(v.command_executor, "Vehicle is occupied by someone on the opposite team!")
                        elseif (not occupied) then
                            enter_vehicle(target, i, v.seat)
                            self:Respond(v.command_executor, "Entering Vehicle.....")
                        end
                        v.enter = false
                    elseif (v.enter) then
                        v.enter = false
                        self:Respond(v.command_executor, "You were not looking at a vehicle!")
                    end
                else
                    v.enter = false
                    self:Respond(v.command_executor, v.name .. " is already in a vehicle")
                end
            end
        end
    end
end

function Mod:ClearObjects(Ply, Type, Params)
    if (self.players[Ply]) then
        local count = #self.players[Ply][Type]
        for k, v in pairs(self.players[Ply][Type]) do
            if (k) then
                local object = get_object_memory(v)
                if (object ~= 0) then
                    destroy_object(v)
                    self.players[Ply][Type][k] = nil
                end
            end
        end
        if (Params) then
            if (Ply == Params.eid) then
                self:Respond(Ply, "Cleaning up [" .. count .. "] " .. Type .. " objects")
            else
                self:Respond(Params.eid, "Cleaning up [" .. count .. "] " .. Type .. "] objects for " .. Params.tname, 12)
                self:Respond(Params.tid, "Your " .. Type .. " objects were cleaned up by " .. Params.ename)
            end
        end
    elseif (Ply == Params.eid) then
        self:Respond(Ply, "Nothing to clean up!")
    else
        self:Respond(Params.eid, Params.tname .. " has nothing to clean up!", 12)
    end
end

function OnPlayerDisconnect(p)
    Mod:ClearObjects(p, "item")
    Mod:ClearObjects(p, "vehicle")
    Mod.players[p] = nil
end

function Mod:ValidateItem(Ply, ITEM)
    for _, Tab in pairs(self.items) do
        for _, object in pairs(Tab[4]) do
            if (object == ITEM) then
                return { Tab[1], Tab[2], Tab[3] }
            end
        end
    end
    self:Respond(Ply, 'Computer says no! Invalid object.', 10)
    return {}
end

local function CMDSplit(CMD)
    local Args, index = { }, 1
    CMD = gsub(CMD, '"', "")
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = lower(Params)
        index = index + 1
    end
    return Args
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function Mod:GetXYZ(Ply)
    local coords, x, y, z = { }
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local VehicleID = read_dword(DyN + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            coords.invehicle = false
            x, y, z = read_vector3d(DyN + 0x5c)
        else
            coords.invehicle = true
            x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
        end

        coords.x, coords.y, coords.z, coords.dyn = x, y, z, DyN
    end
    return coords
end

function Mod:OnServerCommand(Executor, C, _, _)
    local Args = CMDSplit(C)
    if (Args == nil) then
        return
    else

        for CMD, Param in pairs(self.commands) do
            if (Args[1] == CMD) then

                local lvl = tonumber(get_var(Executor, "$lvl"))
                if (lvl >= Param.permission or Executor == 0) then

                    if (Args[2] ~= nil) then

                        local params = {}
                        params.eid = Executor
                        params.ename = get_var(Executor, "$name")

                        if (Executor == 0) then
                            params.ename = "SERVER"
                        end

                        if (Param.destroy) then
                            local type = Args[3]:match("^%d+$") or Args[3]:match("^(*)$")
                            if (type) then
                                local pl = self:GetPlayers(Executor, Args, 2)
                                for i = 1, #pl do
                                    local tid = tonumber(pl[i])
                                    local tname = get_var(tid, "$name")
                                    params.tid = tid
                                    params.tname = tname
                                    if (tonumber(type) == 1) then
                                        self:ClearObjects(tid, "vehicle", params)
                                    elseif (tonumber(type) == 2) then
                                        self:ClearObjects(tid, "item", params)
                                    elseif (type == "*") then
                                        self:ClearObjects(tid, "item", params)
                                        self:ClearObjects(tid, "vehicle", params)
                                    else
                                        self:Respond(Executor, "Invalid Command Parameter.", 12)
                                        break
                                    end
                                end
                            else
                                self:Respond(Executor, "-- Invalid Command Syntax --", 12)
                                self:Respond(Executor, "Usage:", 12)
                                self:Respond(Executor, "/" .. CMD .. " [PID/Me/All/*] [1/2/*]", 12)
                                self:Respond(Executor, "1 = Vehicles", 12)
                                self:Respond(Executor, "2 = Items", 12)
                                self:Respond(Executor, "* = Vehicles and Items", 12)
                            end
                        else

                            -- Check if player has specified a seat:
                            local seat = C:match("--seat")
                            if (seat) then
                                seat = gsub(C:match(seat .. "( %d+)"), "%s", "")
                            end
                            params.seat = tonumber(seat) or 0

                            if (not Args[2]:match("^%d+$")) then
                                local item = self:ValidateItem(Executor, Args[2])
                                params.item_name = item[3]
                                params.item = { item[1], item[2] }
                            else
                                params.seat = tonumber(Args[2])
                                params.enter_desired_vehicle = true
                            end

                            params.err = false

                            -- Check if player wants to enter driver seat and gunner seat simultaneously
                            params.gunner_driver = C:match("--gd")

                            -- Check if player has specified an amount of the object to deal with:
                            local amount = C:match("--amount")
                            if (amount) then
                                amount = gsub(C:match(amount .. "( %d+)"), "%s", "")
                            end
                            params.amount = tonumber(amount) or 1

                            local pl = self:GetPlayers(Executor, Args, 3)
                            if (pl) then
                                for i = 1, #pl do
                                    local tid = tonumber(pl[i])
                                    local tname = get_var(tid, "$name")
                                    if player_alive(tid) then
                                        local coords = self:GetXYZ(tid)
                                        if (coords) then
                                            params.tid = tid
                                            params.tname = tname
                                            params.coords = coords
                                            params.command_executor = Executor
                                            Param.func(params)
                                        end
                                    else
                                        self:Respond(Executor, tname .. " is not alive!", 12)
                                    end
                                end
                            end
                        end
                    elseif (Param.aim_enter) then
                        self.players[Executor].enter = true
                    end
                end
                return false
            end
        end
    end
end

function Mod:SpawnItem(params)

    local object = params.item

    if GetTag(object[1], object[2]) then

        local x, y, z = params.coords.x, params.coords.y, params.coords.z

        local function Spawn(Ply, Type, Name)
            if (params.type == "give") then
                assign_weapon(spawn_object(Type, Name, x, y, z), Ply)

            elseif (params.type == "spawn" or params.type == "enter") then

                local x_aim = read_float(params.coords.dyn + 0x230)
                local y_aim = read_float(params.coords.dyn + 0x234)

                if (params.type == "spawn") then
                    local z_aim = read_float(params.coords.dyn + 0x238)
                    x = x + self.distance_from_player * sin(x_aim)
                    y = y + self.distance_from_player * sin(y_aim)
                    z = z + 0.3 * sin(z_aim) + 0.5
                else
                    x = x + x_aim * self.distance_from_player
                    y = y + y_aim * self.distance_from_player
                    z = z + 0.3
                end

                local obj = spawn_object(Type, Name, x, y, z)

                if (params.type == "spawn") then
                    self.players[Ply].item[#self.players[Ply].item + 1] = obj
                elseif (params.type == "enter") then
                    self.players[Ply].vehicle[#self.players[Ply].vehicle + 1] = obj
                end

                if (params.type == "enter") then
                    enter_vehicle(obj, Ply, params.seat)
                    if (params.gunner_driver) then
                        enter_vehicle(obj, Ply, 2)
                    end
                end
            end
        end
        for _ = 1, params.amount do
            Spawn(params.tid, object[1], object[2])
        end
        return true
    else
        params.error_message = "Missing tag address for " .. params.item_name
    end
    return false
end

function Mod:Give(params)
    local eid = params.eid
    local tid = params.tid
    local tname = params.tname
    local ename = params.ename
    local object = params.item
    if (object[1] == "weap") and (not params.error) then
        if (not params.coords.invehicle) then
            params.type = "give"
            local success = self:SpawnItem(params)
            if (success) then
                if (tid == eid) then
                    self:Respond(eid, "You have received [" .. params.amount .. "x] " .. params.item_name, 12)
                else
                    self:Respond(eid, "Giving [" .. params.amount .. "x] " .. params.item_name .. " to " .. tname, 12)
                    self:Respond(tid, "You have received [" .. params.amount .. "x]" .. params.item_name .. " from " .. ename, 12)
                end
            elseif (not params.error) then
                params.error = true
                self:Respond(eid, params.error_message, 12)
            end
        else
            self:Respond(eid, "Unable to give item while " .. params.tname .. " is in a vehicle.", 12)
        end
    elseif (not params.error) then
        params.error = true
        self:Respond(eid, "Invalid Object Type", 12)
    end
end

function Mod:Spawn(params)
    local eid = params.eid
    local tid = params.tid
    local tname = params.tname
    local ename = params.ename
    if (not params.error) then
        params.type = "spawn"
        local success = self:SpawnItem(params)
        if (success) then
            if (tid == eid) then
                self:Respond(eid, "Spawning [" .. params.amount .. "x] " .. params.item_name, 12)
            else
                self:Respond(eid, "Spawning [" .. params.amount .. "x] " .. params.item_name .. " for " .. tname, 12)
                self:Respond(tid, ename .. " spawned [" .. params.amount .. "x]" .. params.item_name .. " from you.", 12)
            end
        elseif (not params.error) then
            params.error = true
            self:Respond(eid, params.error_message, 12)
        end
    end
end

function Mod:Enter(params)
    local eid = params.eid
    local tid = params.tid
    local tname = params.tname
    local ename = params.ename
    local object = params.item
    if (params.enter_desired_vehicle) then
        self.players[tid].enter = true
        self.players[tid].seat = params.seat
        self.players[tid].command_executor = params.command_executor
        return true
    elseif (object[1] == "vehi") and (not params.error) then
        params.type = "enter"
        local success = self:SpawnItem(params)
        if (success) then
            if (tid == eid) then
                self:Respond(eid, "Entered [" .. params.amount .. "x] " .. params.item_name, 12)
            else
                self:Respond(eid, "Entering " .. tname .. " into [" .. params.amount .. "x] " .. params.item_name, 12)
                self:Respond(tid, "Entering [" .. params.amount .. "x]" .. params.item_name .. " from " .. ename, 12)
            end
        elseif (not params.error) then
            params.error = true
            self:Respond(eid, params.error_message, 12)
        end
    else
        params.error = true
        self:Respond(eid, "Invalid Object Type", 12)
    end
end

function Mod:Respond(Ply, Message, Color)
    Color = Color or 10
    if (Ply == 0) then
        cprint(Message, Color)
    else
        rprint(Ply, Message)
    end
end

function Mod:GetPlayers(Executor, Args, Pos)
    local pl = { }
    if (Args[Pos] == nil or Args[Pos] == "me" or Args[Pos] == "-gd" or Args[Pos] == "-seat" or Args[Pos] == "-amount") then
        if (Executor ~= 0) then
            table.insert(pl, Executor)
        else
            self:Respond(Executor, "Please enter a valid player id", 10)
        end
    elseif (Args[Pos] ~= nil) and (Args[Pos]:match("^%d+$")) then
        if player_present(Args[Pos]) then
            table.insert(pl, Args[Pos])
        else
            self:Respond(Executor, "Player #" .. Args[Pos] .. " is not online", 10)
        end
    elseif (Args[Pos] == "all" or Args[Pos] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
        if (#pl == 0) then
            self:Respond(Executor, "There are no players online!", 10)
        end
    else
        self:Respond(Executor, "Invalid Command Syntax. Please try again!", 10)
    end
    return pl
end

function OnTick()
    return Mod:OnTick()
end
function Give(Params)
    return Mod:Give(Params)
end
function Spawn(Params)
    return Mod:Spawn(Params)
end
function Enter(Params)
    return Mod:Enter(Params)
end
function ClearObjects(P, T, PA)
    return Mod:ClearObjects(P, T, PA)
end
function OnServerCommand(P, C, _, _)
    return Mod:OnServerCommand(P, C, _, _)
end

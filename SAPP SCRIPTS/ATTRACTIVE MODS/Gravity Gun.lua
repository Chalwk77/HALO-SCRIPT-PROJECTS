--[[
--=====================================================================================================--
Script Name: Gravity Gun, for SAPP (PC & CE)
Description: A half-life implementation for Halo.

             * Pick up and throw vehicles at each other!
             * Works on all maps (including protected maps).

             * To toggle Gravity Gun mode on or off, type /ggun [1/0 or true/false or on/off].
             * Shoot a vehicle (once) to pick it up.
             * Shoot again to launch it!

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local GravityGun = {

    -- Custom command used to toggle gravity gun on/off:
    -- Command Syntax: /ggun [1/0 or true/false or on/off]
    command = "ggun",
    --

    -- Minimum permission required to execute /command:
    permission = -1,
    --

    -- Distance (in world units) a vehicle will be suspended in front of player:
    -- 1 w/unit = 10 feet or ~3.048 meters
    distance = 4.5,
    --

    -- vehicle velocities --
    --
    -- initial launch velocity --
    launch_velocity = 1.2,

    -- Suspended yaw, pitch & roll velocities:
    yaw = 0.1, pitch = 0.1, roll = 0.1
}
-- config ends --

api_version = "1.12.0.0"

local players = {}

function OnScriptLoad()

    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnJoin")
    register_callback(cb["EVENT_LEAVE"], "OnQuit")
    register_callback(cb["EVENT_SPAWN"], "OnSpawn")
    register_callback(cb["EVENT_COMMAND"], "OnCommand")
    register_callback(cb["EVENT_GAME_START"], "OnStart")

    OnStart()
end

function OnStart()
    if (get_var(0, "$gt") ~= "n/a") then
        players = { }
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function GravityGun:NewPlayer(o)

    setmetatable(o, self)
    self.__index = self

    o.shooting = 0
    o.enabled = false

    return o
end

function GravityGun:Shooting(dyn)
    local shooting = read_float(dyn + 0x490)
    if (shooting ~= self.shooting and shooting == 1) then
        self.shooting = shooting
        return true
    end
    self.shooting = shooting
    return false
end

function GravityGun:Toggle(args)

    local id = self.pid
    local toggled = (self.enabled)

    local state = args[2]
    if (not state) then

        state = self.enabled
        if (state) then
            state = "activated"
        else
            state = "not activated"
        end
        rprint(id, "Gravity Gun is " .. state)
        return

    elseif (state == "on" or state == "1" or state == "true") then
        state = "enabled"
    elseif (state == "off" or state == "0" or state == "false") then
        state = "disabled"
    else
        state = nil
    end

    if (toggled and state == "enabled" or not toggled and state == "disabled") then
        rprint(id, 'Gravity Gun already ' .. state)
    elseif (state) then
        rprint(id, 'Gravity Gun ' .. state)
        self.object = nil
        self.enabled = (state == 'disabled' and false) or (state == 'enabled' and true)
    else
        rprint(id, 'Invalid Command Parameter.')
        rprint(id, 'Usage: "on", "1", "true", "off", "0" or "false"')
    end
end

function GravityGun:Suspend(px, py, pz, cx, cy, cz, shooting)

    -- vehicle will be suspended in front of the player at this distance:
    local distance = self.distance
    local x = px + distance * cx
    local y = py + distance * cy
    local z = pz + distance * cz

    -- update vehicle x,y,z coordinates:
    write_float(self.object + 0x5C, x)
    write_float(self.object + 0x60, y)
    write_float(self.object + 0x64, z)

    -- update velocities:
    write_float(self.object + 0x68, 0) -- x vel
    write_float(self.object + 0x6C, 0) -- y vel
    write_float(self.object + 0x70, 0.01285) -- z vel

    -- update yaw, pitch, roll
    write_float(self.object + 0x90, self.yaw) -- yaw
    write_float(self.object + 0x8C, self.pitch) -- pitch
    write_float(self.object + 0x94, self.roll) -- roll

    -- update vehicle physics:
    write_bit(self.object + 0x10, 0, 0) -- Unset noCollisions bit.
    write_bit(self.object + 0x10, 5, 0) -- Unset ignorePhysics.

    -- launch vehicle:
    if (shooting) then

        local vel = self.launch_velocity

        write_float(self.object + 0x68, vel * cx) -- x vel
        write_float(self.object + 0x6C, vel * cy) -- y vel
        write_float(self.object + 0x70, vel * cz) -- z vel

        self.object = nil
    end
end

local function GetXYZ(dyn)
    local x, y, z
    local crouch = read_float(dyn + 0x50C)
    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)
    if (vehicle == 0xFFFFFFFF) then
        x, y, z = read_vector3d(dyn + 0x5c)
    elseif (object ~= 0) then
        x, y, z = read_vector3d(object + 0x5c)
    end
    return x, y, (crouch == 0 and z + 0.65 or z + 0.35 * crouch)
end

local function GetCamera(dyn)
    local cx = read_float(dyn + 0x230)
    local cy = read_float(dyn + 0x234)
    local cz = read_float(dyn + 0x238)
    return cx, cy, cz
end

local function Intersecting(px, py, pz, cx, cy, cz, Ply)
    local ignore = read_dword(get_player(Ply) + 0x34)
    local success, _, _, _, map_object = intersect(px, py, pz, cx * 1000, cy * 1000, cz * 1000, ignore)
    local object = get_object_memory(map_object)
    if (object ~= 0 and (read_byte(object + 0xB4) == 1)) then
        return (success and object) or nil
    end
    return nil
end

function OnTick()

    for i, v in pairs(players) do
        if (v.enabled) then

            local dyn = get_dynamic_player(i)
            if (player_alive(i) and dyn ~= 0) then

                local shot_fire = v:Shooting(dyn)

                local px, py, pz = GetXYZ(dyn)
                local cx, cy, cz = GetCamera(dyn)

                if (not v.object and shot_fire) then
                    local vehicle = Intersecting(px, py, pz, cx, cy, cz, i)
                    if (vehicle) then
                        v.object = vehicle
                    end
                elseif (v.object) then
                    v:Suspend(px, py, pz, cx, cy, cz, shot_fire)
                end
            end
        end
    end
end

local function HasPermission(Ply)
    local lvl = tonumber(get_var(Ply, "$lvl"))
    return (lvl >= GravityGun.permission) or rprint(Ply, 'Insufficient Permission')
end

local function CmdSplit(cmd)
    local t = { }
    for arg in cmd:gmatch('([^%s]+)') do
        t[#t + 1] = arg:lower()
    end
    return t
end

function OnCommand(Ply, CMD, _, _)
    local t = players[Ply]
    local args = CmdSplit(CMD)
    if (t and #args > 0 and args[1] == t.command and HasPermission(Ply)) then
        t:Toggle(args)
        return false
    end
end

function OnJoin(Ply)
    players[Ply] = GravityGun:NewPlayer({ pid = Ply })
end

function OnSpawn(Ply)
    players[Ply].object = nil
end

function OnQuit(Ply)
    players[Ply] = nil
end

function OnScriptUnload()
    -- N/A
end
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
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

--- Configuration table for the Gravity Gun script.
-- @field command           The command to toggle Gravity Gun mode.
-- @field permission        The required permission level to use the Gravity Gun.
-- @field distance          The distance at which the Gravity Gun can pick up objects.
-- @field launch_velocity   The velocity at which objects are launched.
-- @field yaw               The yaw rotation applied to the object.
-- @field pitch             The pitch rotation applied to the object.
-- @field roll              The roll rotation applied to the object.
local GravityGun = {
    command = "ggun",
    permission = -1,
    distance = 4.5,
    launch_velocity = 1.2,
    yaw = 0.1,
    pitch = 0.1,
    roll = 0.1
}

api_version = "1.12.0.0"

local players = {}

--- Retrieves the XYZ coordinates of a player or their vehicle.
-- @param dyn The dynamic player object.
-- @return number, number, number The X, Y, and Z coordinates.
local function getXYZ(dyn)
    local x, y, z
    local crouch = read_float(dyn + 0x50C)
    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)
    if (vehicle == 0xFFFFFFFF) then
        x, y, z = read_vector3d(dyn + 0x5c)
    elseif (object ~= 0) then
        x, y, z = read_vector3d(object + 0x5c)
    end
    return x, y, (crouch == 0 and z + 0.65) or (z + 0.35 * crouch)
end

--- Retrieves the camera coordinates of a player.
-- @param dyn The dynamic player object.
-- @return number, number, number The camera X, Y, and Z coordinates.
local function getCamera(dyn)
    local cx = read_float(dyn + 0x230)
    local cy = read_float(dyn + 0x234)
    local cz = read_float(dyn + 0x238)
    return cx, cy, cz
end

--- Checks if a line intersects with any map object.
-- @param px The player's X coordinate.
-- @param py The player's Y coordinate.
-- @param pz The player's Z coordinate.
-- @param cx The camera's X coordinate.
-- @param cy The camera's Y coordinate.
-- @param cz The camera's Z coordinate.
-- @param id The player's ID.
-- @return boolean, number True if intersecting, and the object memory address.
local function isIntersecting(px, py, pz, cx, cy, cz, id)
    local ignore = read_dword(get_player(id) + 0x34)
    local success, _, _, _, map_object = intersect(px, py, pz, cx * 1000, cy * 1000, cz * 1000, ignore)
    local object = get_object_memory(map_object)
    if (object ~= 0 and (read_byte(object + 0xB4) == 1)) then
        return (success and object) or nil
    end
    return nil
end

--- Checks if a player has the required permission level.
-- @param id The player's ID.
-- @return boolean True if the player has permission, false otherwise.
local function hasPermission(id)
    local lvl = tonumber(get_var(id, "$lvl"))
    return (lvl >= GravityGun.permission) or rprint(id, 'Insufficient Permission')
end

--- Splits a command string into a table of arguments.
-- @param cmd The command string.
-- @return table The table of command arguments.
local function stringSplit(cmd)
    local t = {}
    for arg in cmd:gmatch('([^%s]+)') do
        t[#t + 1] = arg:lower()
    end
    return t
end

--- Creates a new player object and sets its metatable.
-- @param o The table containing the player's properties.
-- @return table The new player object with the GravityGun metatable.
function GravityGun:newPlayer(o)
    setmetatable(o, self)
    self.__index = self
    o.shooting = 0
    o.enabled = false
    return o
end

--- Checks if the player is currently shooting.
-- @param dyn The dynamic player object.
-- @return boolean True if the player is shooting, false otherwise.
function GravityGun:isShooting(dyn)
    local shooting = read_float(dyn + 0x490)
    if (shooting ~= self.shooting and shooting == 1) then
        self.shooting = shooting
        return true
    end
    self.shooting = shooting
    return false
end

--- Toggles the Gravity Gun mode for the player.
-- @param args The command arguments.
function GravityGun:toggle(args)
    local id = self.pid
    local toggled = self.enabled
    local state = args[2]

    if not state then
        state = self.enabled and "activated" or "not activated"
        rprint(id, "Gravity Gun is " .. state)
        return
    end

    if state == "on" or state == "1" or state == "true" then
        state = "enabled"
    elseif state == "off" or state == "0" or state == "false" then
        state = "disabled"
    else
        state = nil
    end

    if (toggled and state == "enabled") or (not toggled and state == "disabled") then
        rprint(id, 'Gravity Gun already ' .. state)
    elseif state then
        rprint(id, 'Gravity Gun ' .. state)
        self.object = nil
        self.enabled = state == 'enabled'
    else
        rprint(id, 'Invalid Command Parameter.')
        rprint(id, 'Usage: "on", "1", "true", "off", "0" or "false"')
    end
end

--- Sets the velocity of an object.
-- @param object The object memory address.
-- @param cx The camera's X coordinate.
-- @param cy The camera's Y coordinate.
-- @param cz The camera's Z coordinate.
-- @param vel The velocity to set.
local function setVelocity(object, cx, cy, cz, vel)
    write_float(object + 0x68, vel * cx)
    write_float(object + 0x6C, vel * cy)
    write_float(object + 0x70, vel * cz)
end

--- Sets the yaw rotation of an object.
-- @param object The object memory address.
-- @param yaw The yaw rotation to set.
local function setYaw(object, yaw)
    write_float(object + 0x90, yaw)
end

--- Sets the pitch rotation of an object.
-- @param object The object memory address.
-- @param pitch The pitch rotation to set.
local function setPitch(object, pitch)
    write_float(object + 0x8C, pitch)
end

--- Sets the roll rotation of an object.
-- @param object The object memory address.
-- @param roll The roll rotation to set.
local function setRoll(object, roll)
    write_float(object + 0x94, roll)
end

--- Suspends an object in the air and optionally launches it.
-- @param px The player's X coordinate.
-- @param py The player's Y coordinate.
-- @param pz The player's Z coordinate.
-- @param cx The camera's X coordinate.
-- @param cy The camera's Y coordinate.
-- @param cz The camera's Z coordinate.
-- @param shooting Whether the player is shooting.
function GravityGun:suspend(px, py, pz, cx, cy, cz, shooting)
    local distance = self.distance
    local x = px + distance * cx
    local y = py + distance * cy
    local z = pz + distance * cz

    write_float(self.object + 0x5C, x)
    write_float(self.object + 0x60, y)
    write_float(self.object + 0x64, z)

    write_float(self.object + 0x68, 0)
    write_float(self.object + 0x6C, 0)
    write_float(self.object + 0x70, 0.01285)

    setYaw(self.object, self.yaw)
    setPitch(self.object, self.pitch)
    setRoll(self.object, self.roll)

    write_bit(self.object + 0x10, 0, 0)
    write_bit(self.object + 0x10, 5, 0)

    if shooting then
        setVelocity(self.object, cx, cy, cz, self.launch_velocity)
        self.object = nil
    end
end

--- Event handler for script load.
function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnJoin")
    register_callback(cb["EVENT_LEAVE"], "OnQuit")
    register_callback(cb["EVENT_SPAWN"], "OnSpawn")
    register_callback(cb["EVENT_COMMAND"], "OnCommand")
    register_callback(cb["EVENT_GAME_START"], "OnStart")
    OnStart()
end

--- Event handler for game start.
function OnStart()
    if get_var(0, "$gt") ~= "n/a" then
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

--- Event handler for each game tick.
-- This function iterates through the players table and checks if each player has the Gravity Gun enabled.
-- If enabled, it retrieves the player's dynamic object and checks if the player is alive.
-- It then checks if the player is shooting and retrieves the player's and camera's coordinates.
-- If the player is shooting and not holding an object, it checks for intersections with vehicles.
-- If an intersection is found, the vehicle is assigned to the player.
-- If the player is holding an object, it suspends the object in the air or launches it if the player is shooting.
function OnTick()
    for i, v in pairs(players) do
        if v.enabled then
            local dyn = get_dynamic_player(i)
            if player_alive(i) and dyn ~= 0 then
                local shot_fire = v:isShooting(dyn)
                local px, py, pz = getXYZ(dyn)
                local cx, cy, cz = getCamera(dyn)

                if not v.object and shot_fire then
                    local vehicle = isIntersecting(px, py, pz, cx, cy, cz, i)
                    if vehicle then
                        v.object = vehicle
                    end
                elseif v.object then
                    v:suspend(px, py, pz, cx, cy, cz, shot_fire)
                end
            end
        end
    end
end

--- Event handler for player command.
-- @param id The player's ID.
-- @param cmd The command string.
-- @return boolean False to prevent further processing of the command.
function OnCommand(id, cmd)
    local t = players[id]
    local args = stringSplit(cmd)
    if t and #args > 0 and args[1] == t.command and hasPermission(id) then
        t:toggle(args)
        return false
    end
end

--- Event handler for player join.
-- @param id The player's ID.
function OnJoin(id)
    players[id] = GravityGun:newPlayer({ pid = id })
end

--- Event handler for player spawn.
-- @param id The player's ID.
function OnSpawn(id)
    players[id].object = nil
end

--- Event handler for player quit.
-- @param id The player's ID.
function OnQuit(id)
    players[id] = nil
end

--- Event handler for script unload.
function OnScriptUnload()
    -- N/A
end
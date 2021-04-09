--[[
--=====================================================================================================--
Script Name: Gravity Gun, for SAPP (PC & CE)
Description: Does this really need a description?

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local GGun = {

    base_command = "ggun", -- short for gravity gun


    -- Minimum permission required to execute /base_command for yourself
    permission = -1,


    -- Minimum permission required to toggle GGUN on/off for other players:
    permission_other = 4,


    -- Distance (in world units) a vehicle will be suspended in front of player:
    -- 1 w/unit = 10 feet or ~3.048 meters
    distance = 5,
    --


    -- If true, gravity gun will be disabled on death:
    disable_on_death = false,
    --


    -- vehicle velocities --
    --
    -- initial launch velocity --
    launch_velocity = 0.6,

    -- Suspended yaw, pitch & roll velocities:
    yaw = 0.1, pitch = 0.1, roll = 0.1,
}
-- config ends --

api_version = "1.12.0.0"

local sin = math.sin
local gmatch, lower = string.gmatch, string.lower

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        GGun.players = { }
        for i = 1, 16 do
            if player_present(i) then
                GGun:InitPlayer(i, false)
            end
        end
    end
end

local function Respond(Ply, Msg)
    rprint(Ply, Msg)
end

function GGun:ShotFired(DyN, PT)
    local shot_fired = read_float(DyN + 0x490)
    if (shot_fired ~= PT.weapon_state and shot_fired == 1) then
        PT.weapon_state = shot_fired
        return true
    end
    PT.weapon_state = shot_fired
    return false
end

function GGun:OnTick()
    for i, v in pairs(self.players) do
        if (v.enabled) then

            local DyN = get_dynamic_player(i)
            if (DyN ~= 0) then

                -- Player camera x,y,z
                local xAim = read_float(DyN + 0x230)
                local yAim = read_float(DyN + 0x234)
                local zAim = read_float(DyN + 0x238)

                local px, py, pz
                local VehicleID = read_dword(DyN + 0x11C)
                local VehicleObject = get_object_memory(VehicleID)

                if (VehicleID == 0xFFFFFFFF) then
                    px, py, pz = read_vector3d(DyN + 0x5c)
                elseif (VehicleObject ~= 0) then
                    px, py, pz = read_vector3d(VehicleObject + 0x5c)
                end

                -- Update Z-Coordinate change when crouching:
                local couching = read_float(DyN + 0x50C)
                if (couching == 0) then
                    pz = pz + 0.65
                else
                    pz = pz + (0.35 * couching)
                end

                local shot_fired = self:ShotFired(DyN, v)

                if (not v.target_object) then

                    -- test for successful intersect and make sure vehicle is not occupied:
                    local ignore_player = read_dword(get_player(i) + 0x34)
                    local success, _, _, _, target = intersect(px, py, pz, xAim * 1000, yAim * 1000, zAim * 1000, ignore_player)
                    if (success and target ~= 0xFFFFFFFF and shot_fired) then
                        v.target_object = get_object_memory(target)
                    end
                    --

                else

                    local obj = v.target_object

                    -- Distance from player:
                    local distance = self.distance

                    local newX = px + distance * sin(xAim)
                    local newY = py + distance * sin(yAim)
                    local newZ = pz + distance * sin(zAim)

                    -- Write to vehicle x,y,z coordinates:
                    write_float(obj + 0x5C, newX)
                    write_float(obj + 0x60, newY)
                    write_float(obj + 0x64, newZ)

                    -- Update vehicle velocities:
                    write_float(obj + 0x68, 0) -- x vel
                    write_float(obj + 0x6C, 0) -- y vel
                    write_float(obj + 0x70, 0.01285) -- z vel

                    write_float(obj + 0x90, self.yaw) -- yaw
                    write_float(obj + 0x8C, self.pitch) -- pitch
                    write_float(obj + 0x94, self.roll) -- roll

                    -- Update vehicle physics:
                    write_bit(obj + 0x10, 0, 0) -- Unset noCollisions bit.
                    write_bit(obj + 0x10, 5, 0) -- Unset ignorePhysics.

                    -- Launch vehicle:
                    if (shot_fired) then

                        local vel = self.launch_velocity

                        write_float(obj + 0x68, vel * sin(xAim)) -- x vel
                        write_float(obj + 0x6C, vel * sin(yAim)) -- y vel
                        write_float(obj + 0x70, vel * sin(zAim)) -- z vel

                        v.target_object = nil
                    end
                end
            end
        end
    end
end

local function CMDSplit(CMD)
    local Args = { }
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[#Args + 1] = lower(Params)
    end
    return Args
end

function GGun:OnServerCommand(Ply, CMD, _, _)
    local Args = CMDSplit(CMD)
    local case = (Args and Args[1])
    if (case and Args[1] == self.base_command) then

        local lvl = tonumber(get_var(Ply, "$lvl"))
        if (lvl >= self.permission) then

            local pl = GetPlayers(Ply, Args)
            if (pl) then
                for i = 1, #pl do
                    local TargetID = tonumber(pl[i])
                    if (lvl < self.permission_other and TargetID ~= Ply) then
                        Respond(Ply, "Cannot toggle for other players! (no permission)")
                    else
                        self:ToggleGravityGun(Ply, TargetID, Args)
                    end
                end
            end
        else
            Respond(Ply, "You do not have permission to execute that command")
        end
        return false
    end
end

function GGun:ToggleGravityGun(Ply, TargetID, Args)

    local toggled = (self.players[TargetID].enabled)
    local name = self.players[TargetID].name

    local state = Args[2]
    if (not state) then

        state = self.players[TargetID].enabled
        if (state) then
            state = "activated"
        else
            state = "not activated"
        end

        if (Ply == TargetID) then
            Respond(Ply, "Gravity Gun is " .. state)
        else
            Respond(Ply, name .. "'s Gravity Gun is " .. state)
        end
        return

    elseif (state == "on" or state == "1" or state == "true") then
        state = "enabled"
    elseif (state == "off" or state == "0" or state == "false") then
        state = "disabled"
    else
        state = nil
    end

    if (toggled and state == "enabled" or not toggled and state == "disabled") then
        if (Ply == TargetID) then
            Respond(Ply, "Your Gravity Gun is already " .. state)
        else
            Respond(Ply, name .. "'s Gravity Gun is already " .. state)
        end
    elseif (state) then

        if (Ply == TargetID) then
            Respond(Ply, "Gravity Gun " .. state)
        else
            Respond(Ply, "Gravity Gun " .. state .. " for " .. name)
        end

        self.players[TargetID].target_object = nil
        self.players[TargetID].enabled = (state == "disabled" and false) or (state == "enabled" and true)
    else
        Respond(Ply, "Invalid Command Parameter.")
        Respond(Ply, 'Usage: "on", "1", "true", "off", "0" or "false"')
    end
end

function GetPlayers(Ply, Args)

    local players = { }
    local TargetID = Args[3]

    if (TargetID == nil) or (TargetID == "me") then
        table.insert(players, Ply)
    elseif (TargetID == "all" or TargetID == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(players, i)
            end
        end
    elseif (TargetID:match("%d+") and tonumber(TargetID:match("%d+")) > 0) then
        if player_present(TargetID) then
            table.insert(players, tonumber(Args[1]))
        else
            Respond(Ply, "Player #" .. TargetID .. " is not online!")
        end
    else
        Respond(Ply, "Invalid Target ID Parameter")
        Respond(Ply, 'Usage: "me", "all", "*" or [pid between 1-16]')
    end

    return players
end

function OnPlayerDeath(V)
    if (GGun.disable_on_death) then
        if (GGun.players[V].enabled) then
            GGun.players[V].enabled = false
        end
    end
end

function GGun:InitPlayer(Ply, Reset)

    if (not Reset) then
        self.players[Ply] = {

            -- Used to keep track of the gravity gun's "state" (on or off):
            enabled = false,
            --

            weapon_state = nil,
            name = get_var(Ply, "$name"),
        }
        return
    end

    self.players[Ply] = nil
end

function OnPlayerJoin(Ply)
    GGun:InitPlayer(Ply, false)
end

function OnPlayerQuit(Ply)
    GGun:InitPlayer(Ply, true)
end

function OnTick()
    return GGun:OnTick()
end

function OnServerCommand(P, C)
    return GGun:OnServerCommand(P, C)
end
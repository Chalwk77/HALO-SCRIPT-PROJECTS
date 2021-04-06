--[[
--=====================================================================================================--
Script Name: Gravity Gun, for SAPP (PC & CE)
Description: N/A

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local GGun = {

    base_command = "ggun", -- short for gravity gun

    -- Minimum permission required to execute /base_command for yourself
    permission = 1,

    -- Minimum permission required to toggle GGUN on/off for other players:
    permission_other = 4,

    -- Distance (in world units) a vehicle will be suspended in front of player:
    -- 1 w/unit = 10 feet or ~3.048 meters
    distance = 10,
}
-- config ends --

api_version = "1.12.0.0"

local gmatch, lower = string.gmatch, string.lower

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
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

function GGun:OnTick()
    for i, v in pairs(self.players) do
        if (v.enabled) then

            local DyN = get_dynamic_player(i)
            local px, py, pz
            if (DyN ~= 0) then

                local xAim = read_float(DyN + 0x230)
                local yAim = read_float(DyN + 0x234)
                local zAim = read_float(DyN + 0x238)

                local couching = read_float(DyN + 0x50C)
                px, py, pz = read_vector3d(DyN + 0x5c)
                if (couching == 0) then
                    pz = pz + 0.65
                else
                    pz = pz + (0.35 * couching)
                end

                local ignore_player = read_dword(get_player(i) + 0x34)
                local success, _, _, _, target = intersect(px, py, pz, xAim * 1000, yAim * 1000, zAim * 1000, ignore_player)

                -- test for successful intersect and make sure vehicle is not occupied:
                if (success and target ~= 0xFFFFFFFF) then

                    local shot_fired = read_float(DyN + 0x490)
                    if (shot_fired ~= v.weapon_state and shot_fired == 1) then
                        v.target_object = get_object_memory(target)
                    end
                    v.weapon_state = shot_fired
                end

                local vehicle = v.target_object
                if (vehicle) then

                    -- Distance from player:
                    local distance = self.distance
                    --

                    -- Write to vehicle x,y,z coordinates:
                    write_float(vehicle + 0x5C, px + distance * math.sin(xAim))
                    write_float(vehicle + 0x60, py + distance * math.sin(yAim))
                    write_float(vehicle + 0x64, pz + distance * math.sin(zAim))

                    -- Update vehicle velocities:
                    write_float(vehicle + 0x68, 0) -- x vel
                    write_float(vehicle + 0x6C, 0) -- y vel
                    write_float(vehicle + 0x70, 0.01285) -- z vel
                    write_float(vehicle + 0x90, 0.15) -- yaw
                    write_float(vehicle + 0x8C, 0.15) -- pitch
                    write_float(vehicle + 0x94, 0.15) -- roll

                    -- Update vehicle physics:
                    write_bit(vehicle + 0x10, 0, 0) -- Unset noCollisions bit.
                    write_bit(vehicle + 0x10, 5, 0) -- Unset ignorePhysics.
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

local function InvalidSyntax(Ply)
    Respond(Ply, "Invalid Player ID")
    Respond(Ply, "Usage: /" .. GGun.base_command .. " on/off me|all|*|[1-16]")
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
        self.players[TargetID].enabled = (state == "disabled" and false) or (state == "enabled" and true)
    else
        InvalidSyntax(Ply)
    end
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
                    self:ToggleGravityGun(Ply, TargetID, Args)
                end
            end
        else
            Respond(Ply, "You do not have permission to execute that command")
        end
        return false
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
        InvalidSyntax(Ply)
    end

    return players
end

function GGun:InitPlayer(Ply, Reset)

    if (not Reset) then
        self.players[Ply] = {
            enabled = false,
            weapon_state = nil,
            target_object = nil,
            name = get_var(Ply, "$name"),
        }
        return
    end

    self.players[Ply] = nil
end

function OnPlayerJoin(Ply)
    GGun:InitPlayer(Ply, false)
end

function OnPlayerQuitOnPlayerQuit(Ply)
    GGun:InitPlayer(Ply, true)
end

function OnTick()
    return GGun:OnTick()
end

function OnServerCommand(P, C)
    return GGun:OnServerCommand(P, C)
end
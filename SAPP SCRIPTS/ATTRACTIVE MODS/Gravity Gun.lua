--[[
--=====================================================================================================--
Script Name: Gravity Gun, for SAPP (PC & CE)
Description: Does this really need a description? (half-life implementation).
             To toggle Gravity Gun mode on or off, type /ggun on|off

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local GGun = {

    -- This is the custom command used to toggle gravity gun on/off:
    command = "ggun", -- short for gravity gun
    --

    -- Minimum permission required to execute /command for yourself
    permission = -1,
    --

    -- Minimum permission required to toggle GGUN on/off for other players:
    permission_other = 4,


    -- Distance (in world units) a vehicle will be suspended in front of player:
    -- 1 w/unit = 10 feet or ~3.048 meters
    distance = 5,
    --

    -- If true, players must be holding the ggun in order to
    -- pick up vehicles (setting: "use_in_vehicle" must be false)
    must_hold_ggun = false,
    --

    -- If true, you can pickup and launch vehicles
    -- while occupying a vehicle (bypasses must_hold_ggun setting)
    use_in_vehicle = true,
    --

    -- experimental setting:
    death_messages = false,

    -- vehicle velocities --
    --
    -- initial launch velocity --
    launch_velocity = 1.3,

    -- Suspended yaw, pitch & roll velocities:
    yaw = 0.1, pitch = 0.1, roll = 0.1,

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished:
    server_prefix = "**LNZ**",
}
-- config ends --

api_version = "1.12.0.0"

local time_scale = 1 / 30
local script_version = 1.1
local tag_count, tag_address

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_DIE"], "DeathHandler")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "DeathHandler")

    OnGameStart()
end

function OnScriptUnload()
    -- N/A
end

function GGun:OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then

        tag_count = read_dword(0x4044000C)
        tag_address = read_dword(0x40440000)

        self.players = { }
        self.vehicles = { }
        self.vehicle_collision = GetTag("jpt!", "globals\\vehicle_collision")

        for i = 1, 16 do
            if player_present(i) then
                self:InitPlayer(i, false)
            end
        end
    end
end

local function Respond(Ply, Msg, Clear)
    if (Clear) then
        for _ = 1, 25 do
            rprint(Ply, " ")
        end
    end
    rprint(Ply, Msg)
end

function GGun:ShotFired(DyN, Ply)
    local shot_fired = read_float(DyN + 0x490)
    if (shot_fired ~= Ply.weapon_state and shot_fired == 1) then
        Ply.weapon_state = shot_fired
        return true
    end
    Ply.weapon_state = shot_fired
    return false
end

local function HoldingGRifle(DyN)

    local WeaponID = read_dword(DyN + 0x118)
    local WeaponObj = get_object_memory(WeaponID)

    if (WeaponObj ~= 0) then
        local tag = read_string(read_dword(read_word(WeaponObj) * 32 + 0x40440038))
        if (tag == "weapons\\gravity rifle\\gravity rifle") then
            return true
        end
    end
    return false
end

local function IsOccupied(VObject)
    for i = 1, 16 do
        if player_present(i) then
            local DyN = get_dynamic_player(i)
            if (DyN ~= 0 and player_alive(i)) then
                local VehicleID = read_dword(DyN + 0x11C)
                local VObj = get_object_memory(VehicleID)
                if (VObj ~= 0 and VObj == VObject) then
                    return true
                end
            end
        end
    end
    return false
end

local function IsVehicle(TAG)
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if (tag_class == 1986357353 and tag_name == TAG) then
            return true
        end
    end
    return false
end

function GGun:Radius(x1, y1, z1, x2, y2, z2)
    local distance = math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
    return (distance <= 5)
end

function GGun:OnTick()

    if (self.death_messages) then
        for k, v in pairs(self.vehicles) do
            if (v[5] < 7) then
                local x, y, z = read_vector3d(k + 0x5c)
                v[2] = x
                v[3] = y
                v[4] = z
                v[5] = v[5] + time_scale
            else
                self.vehicles[k] = nil
            end
        end
    end

    for i, v in pairs(self.players) do
        if (v.enabled) then

            local DyN = get_dynamic_player(i)
            if (DyN ~= 0 and player_alive(i)) then

                local shot_fired = self:ShotFired(DyN, v)

                if (not self.use_in_vehicle and self.must_hold_ggun) then
                    if (shot_fired and not HoldingGRifle(DyN)) then
                        Respond(i, "You need to be holding the Gravity Rifle!", true)
                        return
                    elseif (v.target_object and not HoldingGRifle(DyN)) then
                        v.target_object = nil
                        return
                    end
                end

                local px, py, pz = self:GetXYZ(i)

                -- Update Z-Coordinate change when crouching:
                local couching = read_float(DyN + 0x50C)
                if (couching == 0) then
                    pz = pz + 0.65
                else
                    pz = pz + (0.35 * couching)
                end
                --

                if (not v.target_object) then

                    local ignore_player = read_dword(get_player(i) + 0x34)
                    local x, y, z = read_float(DyN + 0x230), read_float(DyN + 0x234), read_float(DyN + 0x238)

                    -- test for successful intersect with an object:
                    local success, _, _, _, target = intersect(px, py, pz, x * 1000, y * 1000, z * 1000, ignore_player)
                    if (success and target ~= 0xFFFFFFFF and shot_fired) then

                        local obj = get_object_memory(target)

                        if (obj ~= 0) then
                            --
                            -- Verify object is a vehicle:
                            local tag = read_string(read_dword(read_word(obj) * 32 + 0x40440038))
                            if (tag and IsVehicle(tag)) then

                                -- Check vehicle is not occupied:
                                if not IsOccupied(obj) then
                                    -- {owner name, x,y,z, timer}
                                    self.vehicles[obj] = { v.name, 0, 0, 0, 0 }
                                    v.target_object = (obj ~= 0xFFFFFFFF and obj) or nil
                                end
                            end
                        end
                    end
                    --
                else

                    local obj = v.target_object

                    -- Player camera x,y,z
                    local xAim = math.sin(read_float(DyN + 0x230))
                    local yAim = math.sin(read_float(DyN + 0x234))
                    local zAim = math.sin(read_float(DyN + 0x238))

                    -- Distance from player:
                    local distance = self.distance

                    local newX = px + distance * xAim
                    local newY = py + distance * yAim
                    local newZ = pz + distance * zAim

                    -- Update vehicle x,y,z coordinates:
                    write_float(obj + 0x5C, newX)
                    write_float(obj + 0x60, newY)
                    write_float(obj + 0x64, newZ)

                    -- Update vehicle velocities:
                    write_float(obj + 0x68, 0) -- x vel
                    write_float(obj + 0x6C, 0) -- y vel
                    write_float(obj + 0x70, 0.01285) -- z vel

                    -- Update vehicle yaw, pitch, roll
                    write_float(obj + 0x90, self.yaw) -- yaw
                    write_float(obj + 0x8C, self.pitch) -- pitch
                    write_float(obj + 0x94, self.roll) -- roll

                    -- Update vehicle physics:
                    write_bit(obj + 0x10, 0, 0) -- Unset noCollisions bit.
                    write_bit(obj + 0x10, 5, 0) -- Unset ignorePhysics.

                    -- Launch vehicle:
                    if (shot_fired) then

                        local vel = self.launch_velocity

                        write_float(obj + 0x68, vel * xAim) -- x vel
                        write_float(obj + 0x6C, vel * yAim) -- y vel
                        write_float(obj + 0x70, vel * zAim) -- z vel

                        v.target_object = nil
                    end
                end
            end
        end
    end
end

function GGun:OnServerCommand(Ply, CMD, _, _)

    local Args = { }
    for Params in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end

    if (#Args > 0 and Args[1] == self.command) then

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

function GGun:ToggleGravityGun(Ply, TID, Args)

    local toggled = (self.players[TID].enabled)
    local name = self.players[TID].name

    local state = Args[2]
    if (not state) then

        state = self.players[TID].enabled
        if (state) then
            state = "activated"
        else
            state = "not activated"
        end

        if (Ply == TID) then
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
        if (Ply == TID) then
            Respond(Ply, "Your Gravity Gun is already " .. state)
        else
            Respond(Ply, name .. "'s Gravity Gun is already " .. state)
        end
    elseif (state) then

        if (Ply == TID) then
            Respond(Ply, "Gravity Gun " .. state)
        else
            Respond(Ply, "Gravity Gun " .. state .. " for " .. name)
        end

        self.players[TID].target_object = nil
        self.players[TID].enabled = (state == "disabled" and false) or (state == "enabled" and true)
    else
        Respond(Ply, "Invalid Command Parameter.")
        Respond(Ply, 'Usage: "on", "1", "true", "off", "0" or "false"')
    end
end

function GetPlayers(Ply, Args)

    local players = { }
    local TID = Args[3]

    if (TID == nil or TID == "me") then
        table.insert(players, Ply)
    elseif (TID == "all" or TID == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(players, i)
            end
        end
    elseif (TID:match("%d+") and tonumber(TID:match("%d+")) > 0) then
        if player_present(TID) then
            table.insert(players, TID)
        else
            Respond(Ply, "Player #" .. TID .. " is not online!")
        end
    else
        Respond(Ply, "Invalid Target ID Parameter")
        Respond(Ply, 'Usage: "me", "all", "*" or [pid between 1-16]')
    end

    return players
end

-- event_die, event_damage_application
function GGun:DeathHandler(Victim, Killer, MetaID)
    if (self.death_messages) then
        local player = self.players[Victim]
        if (player) then
            if (MetaID) then
                player.meta_id = MetaID
            elseif (tonumber(Killer) == 0 and player.meta_id == self.vehicle_collision) then
                local x, y, z = self:GetXYZ(Victim)
                for _, v in pairs(self.vehicles) do
                    if self:Radius(x, y, z, v[2], v[3], v[4]) then
                        execute_command('msg_prefix ""')
                        if (v[1] ~= player.name) then
                            say_all(player.name .. " was killed by " .. v[1])
                        end
                        execute_command('msg_prefix "' .. self.server_prefix .. ' "')
                        break
                    end
                end
                return false
            end
        end
    end
end

function GGun:GetXYZ(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then

        local VehicleID = read_dword(DyN + 0x11C)
        local VehicleObject = get_object_memory(VehicleID)

        local x, y, z

        if (VehicleID == 0xFFFFFFFF) then
            x, y, z = read_vector3d(DyN + 0x5c)
        elseif (VehicleObject ~= 0) then
            x, y, z = read_vector3d(VehicleObject + 0x5c)
        end
        return x, y, z
    end
end

function GGun:InitPlayer(Ply, Reset)

    if (not Reset) then
        self.players[Ply] = {

            meta_id = 0,

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

function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return (Tag ~= 0 and read_dword(Tag + 0xC)) or nil
end

function OnPlayerJoin(Ply)
    GGun:InitPlayer(Ply, false)
end

function OnPlayerSpawn(Ply)
    GGun.players[Ply].target_object = nil
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
function DeathHandler(P, C, MID, _, _, _)
    return GGun:DeathHandler(P, C, MID, _, _, _)
end
function OnGameStart()
    return GGun:OnGameStart()
end

local function WriteLog(str)
    local file = io.open("Gravity Gun (errors).log", "a+")
    if (file) then
        file:write(str .. "\n")
        file:close()
    end
end

function OnError(Error)

    local log = {
        { os.date("[%H:%M:%S - %d/%m/%Y]"), true, 12 },
        { Error, false, 12 },
        { debug.traceback(), true, 12 },
        { "--------------------------------------------------------", true, 5 },
        { "Please report this error on github:", true, 7 },
        { "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", true, 7 },
        { "Script Version: " .. script_version, true, 7 },
        { "--------------------------------------------------------", true, 5 }
    }

    for _, v in pairs(log) do
        WriteLog(v[1])
        if (v[2]) then
            cprint(v[1], v[3])
        end
    end

    WriteLog("\n")
end
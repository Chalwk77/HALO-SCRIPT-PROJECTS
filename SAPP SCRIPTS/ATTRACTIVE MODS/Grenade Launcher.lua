--[[
--=====================================================================================================--
Script Name: Grenade Launcher, for SAPP (PC & CE)
Description: Turns any hand-held or vehicle weapon into a grenade launcher

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local GLauncher = {

    -- This is the custom command used to toggle grenade launcher on/off:
    base_command = "gl", -- short for grenade launcher
    --

    -- Minimum permission required to execute /base_command for yourself
    permission = -1,
    --

    -- Minimum permission required to toggle grenade launcher on/off for other players:
    permission_other = 4,


    -- If true, grenade launcher will be disabled on death:
    disable_on_death = false,
    --

    weapons = {

        -- weapon projectiles --
        ["weapons\\flamethrower\\flame"] = true,
        ["weapons\\needler\\mp_needle"] = true,
        ["weapons\\rocket launcher\\rocket"] = true,
        ["weapons\\pistol\\bullet"] = true,
        ["weapons\\plasma pistol\\bolt"] = true,
        ["weapons\\shotgun\\pellet"] = true,
        ["weapons\\plasma_cannon\\plasma_cannon"] = true,
        ["weapons\\sniper rifle\\sniper bullet"] = true,
        ["weapons\\plasma rifle\\bolt"] = true,
        ["weapons\\assault rifle\\bullet"] = true,
        ["weapons\\plasma rifle\\charged bolt"] = true,

        -- vehicle projectiles --
        ["vehicles\\ghost\\ghost bolt"] = true,
        ["vehicles\\scorpion\\bullet"] = true,
        ["vehicles\\c gun turret\\mp gun turret"] = true,
        ["vehicles\\scorpion\\tank shell"] = true,
        ["vehicles\\warthog\\bullet"] = true,
        ["vehicles\\banshee\\mp_banshee fuel rod"] = true,
        ["vehicles\\banshee\\banshee bolt"] = true,
    }
}
-- config ends --

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_OBJECT_SPAWN"], "OnObjectSpawn")
    OnGameStart()
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        GLauncher.players = { }
        for i = 1, 16 do
            if player_present(i) then
                GLauncher:InitPlayer(i, false)
            end
        end
    end
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return (Tag ~= 0 and read_dword(Tag + 0xC)) or nil
end

local function LaunchGrenade(Ply, ParentID)

    local DyN = get_dynamic_player(Ply)
    local parent_object = get_object_memory(ParentID)
    if (DyN ~= 0 and parent_object ~= 0) then

        local px, py, pz
        local VehicleID = read_dword(DyN + 0x11C)
        local VehicleObject = get_object_memory(VehicleID)

        local distance = 0.5
        if (VehicleID == 0xFFFFFFFF) then
            px, py, pz = read_vector3d(DyN + 0x5c)
        elseif (VehicleObject ~= 0) then
            px, py, pz = read_vector3d(VehicleObject + 0x5c)
            distance = 2
        end

        -- Update Z-Coordinate change when crouching:
        local couching = read_float(DyN + 0x50C)
        if (couching == 0) then
            pz = pz + 0.65
        else
            pz = pz + (0.35 * couching)
        end
        --

        local xAim = math.sin(read_float(DyN + 0x230))
        local yAim = math.sin(read_float(DyN + 0x234))
        local zAim = math.sin(read_float(DyN + 0x238))

        local x = px + (distance * xAim)
        local y = py + (distance * yAim)
        local z = pz + (distance * zAim)

        local tag = GetTag("proj", "weapons\\frag grenade\\frag grenade")
        if (tag) then

            local frag = spawn_projectile(tag, Ply, x, y, z)
            local frag_object = get_object_memory(frag)

            if (frag and frag_object ~= 0) then
                local velocity = 0.6
                write_float(frag_object + 0x68, velocity * xAim)
                write_float(frag_object + 0x6C, velocity * yAim)
                write_float(frag_object + 0x70, velocity * zAim)
            end
        end
    end
end

function GLauncher:Launcher(Ply, MapID, ParentID)
    if (Ply > 0 and player_alive(Ply) and self.players[Ply].enabled) then
        for tag, enabled in pairs(self.weapons) do
            if (MapID == GetTag("proj", tag) and enabled) then
                return false, LaunchGrenade(Ply, ParentID)
            end
        end
    end
end

local function CMDSplit(CMD)
    local Args = { }
    for Params in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end
    return Args
end

local function Respond(Ply, Msg, Clear)
    if (Clear) then
        for _ = 1, 25 do
            rprint(Ply, " ")
        end
    end
    rprint(Ply, Msg)
end

function GLauncher:OnServerCommand(Ply, CMD, _, _)
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
                        self:Toggle(Ply, TargetID, Args)
                    end
                end
            end
        else
            Respond(Ply, "You do not have permission to execute that command")
        end
        return false
    end
end

function GLauncher:Toggle(Ply, TargetID, Args)

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
            Respond(Ply, "Grenade Launcher is " .. state)
        else
            Respond(Ply, name .. "'s Grenade Launcher is " .. state)
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
            Respond(Ply, "Grenade Launcher is already " .. state)
        else
            Respond(Ply, name .. "'s Grenade Launcher is already " .. state)
        end
    elseif (state) then

        if (Ply == TargetID) then
            Respond(Ply, "Grenade Launcher " .. state)
        else
            Respond(Ply, "Grenade Launcher " .. state .. " for " .. name)
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

function GLauncher:InitPlayer(Ply, Reset)
    if (not Reset) then
        self.players[Ply] = {
            enabled = false,
            name = get_var(Ply, "$name"),
        }
        return
    end
    self.players[Ply] = nil
end

function OnPlayerJoin(Ply)
    GLauncher:InitPlayer(Ply, false)
end

function OnPlayerQuit(Ply)
    GLauncher:InitPlayer(Ply, true)
end

function OnServerCommand(P, C)
    return GLauncher:OnServerCommand(P, C)
end
function OnObjectSpawn(P, MID, PID)
    return GLauncher:Launcher(P, MID, PID)
end
--[[
--=====================================================================================================--
Script Name: Teleport Manager (rewrite), for SAPP (PC & CE)
Description: Create custom teleports and warp to them on demand.

Command Syntax:
/setwarp [warp name] [opt -o]
> Create a new warp.
> If you specify the '-o' parameter, you can overwrite the existing warp.

/back
> Teleport to your previous location

/warp [warp name]
> Teleport to the defined warp

/delwarp [warp name]
> Delete the specified warp

/warplist
> View a list of all warps linked to the current map.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration Starts -
local TeleportManager = {
    dir = "teleports.json",
    commands = {
        ["warp"] = {
            permission = 1,
            cmd_index = 1,
        },
        ["back"] = {
            permission = 1,
            cmd_index = 2,
        },
        ["setwarp"] = {
            permission = 1,
            cmd_index = 3,
        },
        ["delwarp"] = {
            permission = 1,
            cmd_index = 4,
        },
        ["warplist"] = {
            permission = 1,
            cmd_index = 5,
        }
    },
}
-- Configuration Ends -

local json = (loadfile "json.lua")()
local gmatch, lower, format = string.gmatch, string.lower, string.format

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    TeleportManager:CheckFile(true)
end

function OnScriptUnload()

end

function OnGameStart()
    TeleportManager:CheckFile(true)
end

function InitPlayer(Ply, Reset)
    if (Reset) then
        TeleportManager.players[Ply] = nil
    else
        TeleportManager.players[Ply] = { }
    end
end

function OnPlayerConnect(Ply)
    InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    InitPlayer(Ply, false)
end

local function CMDSplit(CMD)
    local Args, index = { }, 1
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = lower(Params)
        index = index + 1
    end
    return Args
end

function TeleportManager:OnServerCommand(Executor, Command)
    local Args = CMDSplit(Command)
    for cmd, v in pairs(self.commands) do
        if (Args[1] == cmd) then
            local lvl = tonumber(get_var(Executor, "$lvl"))
            if (lvl >= v.permission or Executor == 0) then
                if (v.cmd_index == 1) then
                    self:Warp(Executor, Args)
                elseif (v.cmd_index == 2) then
                    self:Back(Executor)
                elseif (v.cmd_index == 3) then
                    self:SetWarp(Executor, Args)
                elseif (v.cmd_index == 4) then
                    self:DeleteWarp(Executor, Args)
                elseif (v.cmd_index == 5) then
                    self:WarpList(Executor, Args)
                end
            else
                self:Respond(Executor, "Insufficient Permission")
            end
            return false
        end
    end
end

function TeleportManager:Warp(Ply, Args)
    if player_alive(Ply) then
        if (Args[2] ~= nil) then
            local records, map = self:CheckFile(), get_var(0, "$map")
            local w = records[map][Args[2]]
            if (w ~= nil) then
                self:Respond(Ply, "Teleporting to [" .. Args[2] .. "] at X: " .. w.x .. ", Y: " .. w.y .. ", Z: " .. w.z)
                self:Teleport(Ply, w.x, w.y, w.z)
            else
                self:Respond(Ply, "Warp name not found!")
            end
        else
            self:Respond(Ply, "Please enter a warp name")
        end
    else
        self:Respond(Ply, "Please wait until you respawn.")
    end
end

function TeleportManager:Back(Ply)
    if player_alive(Ply) then
        local t = self.players[Ply]
        if (t) then
            local back = self:Teleport(Ply, t[1], t[2], t[3])
            if (back) then
                self:Respond(Ply, "Returning to previous location")
            else
                self:Respond(Ply, "Previous location not saved.")
            end
        else
            self:Respond(Ply, "Unable to return to previous location.")
        end
    else
        self:Respond(Ply, "Please wait until you respawn.")
    end
end

function TeleportManager:SetWarp(Ply, Args)
    if player_alive(Ply) then
        if (Args[2] ~= nil) then

            local records, map = self:CheckFile(), get_var(0, "$map")
            local overwrite = Args[3] ~= nil and Args[3]:match("--o") or nil
            if (records[map][Args[2]] == nil or overwrite) then

                local file = assert(io.open(self.dir, "w"))
                if (file) then

                    local pos = self:GetXYZ(Ply)
                    local x = format("%0.3f", pos.x)
                    local y = format("%0.3f", pos.y)
                    local z = format("%0.3f", pos.z)

                    if (records[map][Args[2]] == nil) then
                        self:Respond(Ply, 'Location Saved: X: ' .. x .. ", Y: " .. y .. ", Z: " .. z)
                    elseif (overwrite) then
                        self:Respond(Ply, 'Location Updated: X: ' .. x .. ", Y: " .. y .. ", Z: " .. z)
                    end

                    records[map][Args[2]] = {
                        x = format("%0.3f", pos.x),
                        y = format("%0.3f", pos.y),
                        z = format("%0.3f", pos.z),
                    }

                    file:write(json:encode_pretty(records))
                    io.close(file)
                end
            else
                self:Respond(Ply, 'A location with that name already exists. Use parameter "-o" to overwrite')
                self:Respond(Ply, 'Example: /' .. Args[1] .. " " .. Args[2] .. " -o")
            end
        else
            self:Respond(Ply, "Please enter a warp name")
        end
    else
        self:Respond(Ply, "Please wait until you respawn.")
    end
end

function TeleportManager:DeleteWarp(Ply, Args)
    if (Args[2] ~= nil) then
        local map = get_var(0, "$map")
        local records = self:CheckFile()
        if (records[map][Args[2]] ~= nil) then
            records[map][Args[2]] = nil
            local file = assert(io.open(self.dir, "w"))
            if (file) then
                file:write(json:encode_pretty(records))
                io.close(file)
                self:Respond(Ply, 'Successfully deleted warp "' .. Args[2] .. '"')
            end
        else
            self:Respond(Ply, "Warp name not found!")
        end
    else
        self:Respond(Ply, "Please enter a warp name")
    end
end

function TeleportManager:WarpList(Ply, Args)
    local map = get_var(0, "$map")
    local records = self:CheckFile()
    if (records[map]) then
        self:Respond(Ply, "---------------- WARPS FOR " .. map .. " ----------------")
        for k, v in pairs(records[map]) do
            self:Respond(Ply, k .. " X: " .. v.x .. ", Y: " .. v.y .. ", Z: " .. v.z)
        end
    else
        self:Respond(Ply, "There are no warps saved for [" .. map .. "]")
    end
end

function TeleportManager:Teleport(Ply, x, y, z)
    if (x) then
        local pos = self:GetXYZ(Ply)
        self.players[Ply] = { pos.x, pos.y, pos.z }
        write_vector3d((pos.obj ~= 0 and pos.obj or pos.dyn) + 0x5C, x, y, (pos.obj ~= 0 and z + 0.5 or z))
        return true
    end
    return false
end

function TeleportManager:GetXYZ(Ply)
    local pos, x, y, z = { }
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local VehicleID = read_dword(DyN + 0x11C)
        local VehicleObj = get_object_memory(VehicleID)
        if (VehicleID == 0xFFFFFFFF) then
            x, y, z = read_vector3d(DyN + 0x5c)
        else
            x, y, z = read_vector3d(VehicleObj + 0x5c)
        end
        pos.x, pos.y, pos.z, pos.dyn, pos.obj = x, y, z, DyN, VehicleObj
    end
    return pos
end

function TeleportManager:CheckFile(init)

    if (init) then
        self.players = { }
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end

    if (get_var(0, "$gt") ~= "n/a") then

        local content = ""
        local file = io.open(self.dir, "r")
        if (file) then
            content = file:read("*all")
            io.close(file)
        end

        local map = get_var(0, "$map")
        local records = json:decode(content)
        if (not records or records[map] == nil) then

            if (records == nil) then
                records = { }
            end

            file = assert(io.open(self.dir, "w"))
            if (file) then
                records[map] = { }
                file:write(json:encode_pretty(records))
                io.close(file)
            end
        end
        return records
    end
end

function TeleportManager:Respond(Ply, Message, Color)
    Color = Color or 10
    if (Ply == 0) then
        cprint(Message, Color)
    else
        rprint(Ply, Message)
    end
end

function OnServerCommand(P, C)
    return TeleportManager:OnServerCommand(P, C)
end
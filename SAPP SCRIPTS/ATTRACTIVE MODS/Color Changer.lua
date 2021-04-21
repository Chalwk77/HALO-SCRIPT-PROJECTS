--[[
--=====================================================================================================--
Script Name: Color Changer (v.1.2), for SAPP (PC & CE)
Description: Change any player's armor color on demand.

Command Syntax:
    * /setcolor [player id | me | */all] [color id]
    "me" can be used in place of your own player id

Copyright (c) 2019-2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

local Mod = {

    -- config start
    list_command = "colors",
    command_aliases = { "color", "setcolor" },
    permission = 1,
    permission_others = 4,
    colors = {
        ["white"] = 0,
        ["black"] = 1,
        ["red"] = 2,
        ["blue"] = 3,
        ["gray"] = 4,
        ["yellow"] = 5,
        ["green"] = 6,
        ["pink"] = 7,
        ["purple"] = 8,
        ["cyan"] = 9,
        ["cobalt"] = 10,
        ["orange"] = 11,
        ["teal"] = 12,
        ["sage"] = 13,
        ["brown"] = 14,
        ["tan"] = 15,
        ["maroon"] = 16,
        ["salmon"] = 17,
    },
    -- config end

    -- Do Not Touch --
    players = { }
}

local ls
local gsub, lower, gmatch = string.gsub, string.lower, string.gmatch

function OnScriptLoad()
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    OverrideTeamColors(true)
end

function OnGameStart()
    OverrideTeamColors(true)
end

function OnScriptUnload()
    OverrideTeamColors(false)
end

function Mod:OnPlayerSpawn(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local t = self.players[Ply]
        if (t) then
            write_vector3d(DyN + 0x5C, t.x, t.y, t.z)
            self.players[Ply] = nil
        end
    end
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

function Mod:InvalidSyntax(Ply)
    self:Respond(Ply, "Invalid Color Parameter.", 10)
    self:Respond(Ply, "Please enter a number between 0-17 or the name of the desired color.", 10)
end

function Mod:OnServerCommand(Executor, CMD)
    local Args = CMDSplit(CMD)
    if (Args == nil) then
        return
    end
    for _, cmd in pairs(self.command_aliases) do
        if (Args[1] == cmd) then
            local lvl = tonumber(get_var(Executor, "$lvl"))
            if (lvl >= self.permission or Executor == 0) then
                if (Args[3] ~= nil) then
                    local pl = self:GetPlayers(Executor, Args)
                    if (pl) then
                        for i = 1, #pl do
                            local TargetID = tonumber(pl[i])
                            if (TargetID ~= Executor and lvl < self.permission_others) then
                                self:Respond(Executor, "You lack permission to execute this command on other players", 10)
                            else
                                self:SetColor(Executor, TargetID, Args[3])
                            end
                        end
                    end
                else
                    self:InvalidSyntax(Executor)
                end
            else
                self:Respond(Executor, "Insufficient Permission", 10)
            end
            return false
        elseif (Args[1] == self.list_command) then
            local lvl = tonumber(get_var(Executor, "$lvl"))
            if (lvl >= self.permission or Executor == 0) then
                for k, v in pairs(self.colors) do
                    self:Respond(Executor, k .. " | " .. v, 10)
                end
            else
                self:Respond(Executor, "Insufficient Permission", 10)
            end
            return false
        end
    end
end

function Mod:SetColor(Executor, TargetID, Color)
    local name = get_var(TargetID, "$name")
    if player_alive(TargetID) then
        local player = get_player(TargetID)
        if (player) then
            for ColorName, ID in pairs(Mod.colors) do

                if (tostring(Color) == ColorName or tonumber(Color) == ID) then
                    write_byte(player + 0x60, ID)
                    local coords = Mod:GetXYZ(TargetID)
                    if (coords) then
                        self.players[TargetID] = { x = coords.x, y = coords.y, z = coords.z }
                        self:Respond(Executor, name .. " has their color changed to " .. ColorName)
                        return destroy_object(read_dword(get_player(TargetID) + 0x34))
                    else
                        return self:Respond(Executor, "Something went wrong! Please try again.")
                    end
                end
            end
            self:InvalidSyntax(Executor)
        end
    else
        return self:Respond(Executor, name .. " is dead. Please wait until they respawn.")
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

function Mod:GetXYZ(Ply)
    local coords, x, y, z = { }
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local VehicleID = read_dword(DyN + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            x, y, z = read_vector3d(DyN + 0x5c)
        else
            x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
        end
    end
    coords.x, coords.y, coords.z = x, y, z
    return coords
end

function Mod:GetPlayers(Executor, Args)
    local pl = { }
    if (Args[2] == nil or Args[2] == "me") then
        if (Executor ~= 0) then
            table.insert(pl, Executor)
        else
            self:Respond(Executor, "Please enter a valid player id", 10)
        end
    elseif (Args[2] ~= nil) and (Args[2]:match("^%d+$")) then
        if player_present(Args[2]) then
            table.insert(pl, Args[2])
        else
            self:Respond(Executor, "Player #" .. Args[2] .. " is not online", 10)
        end
    elseif (Args[2] == "all" or Args[2] == "*") then
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

function LSS(state)
    if (state) then
        ls = sig_scan("741F8B482085C9750C")
        if (ls == 0) then
            ls = sig_scan("EB1F8B482085C9750C")
        end
        safe_write(true)
        write_char(ls, 235)
        safe_write(false)
    else
        if (ls == 0) then
            return
        end
        safe_write(true)
        write_char(ls, 116)
        safe_write(false)
    end
end

function OverrideTeamColors(Override)
    if (get_var(0, "$gt") ~= "n/a") then
        LSS(Override)
    end
end

function OnServerCommand(P, C)
    return Mod:OnServerCommand(P, C)
end
function OnPlayerSpawn(P)
    return Mod:OnPlayerSpawn(P)
end
function OnTick()
    return Mod:OnTick()
end
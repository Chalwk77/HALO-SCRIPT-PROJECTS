--[[
--=====================================================================================================--
Script Name: Client Crasher, for SAPP (PC & CE)
Description: Crash any player's game client on demand.

Command Syntax:
    * /crash [player id | me | */all]
    "me" can be used in place of your own player id


Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)

- This script is included in the Velocity Multi-Mod with many improvements.
--=====================================================================================================--
]] --

-- Configuration [start] -----------------------------
api_version = "1.12.0.0"

local MOD = {
    -- This is the custom command used to crash players
    command = "crash",

    -- Minimum permission level needed to crash a player:
    permission = 1,

    -- Should the command executor be able to crash their own game client?
    crash_self = false,

    --===================================================--
    -- This mod uses a vehicle to crash the client.
    -- If you want this script to work on custom maps that don't have stock tags,
    -- simply enter ONE valid vehicle tag address per custom map in the tags array below.

    -- {tag, loop iterations}
    -- Only change the loop iterations if you know what you're doing.
    tags = {

        -- WARNING: Do not set loop iterations higher than 20 for stock maps.
        -- For custom maps, if you're experiencing a problem where the command executes fine but all it does
        -- is kill the player, try setting the iterations higher.

        { "vehicles\\warthog\\mp_warthog", 20 }, -- this tag is sufficient for all stock maps.
        { "bourrin\\halo reach\\vehicles\\warthog\\rocket warthog", 2000 }, -- this is for bigassv2,104
    }
    --===================================================--
}
-- Configuration [end] -----------------------------

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    MOD:SetCrashVehicle()
end

function OnScriptUnload()
    -- N/A
end

function OnGameStart()
    MOD:SetCrashVehicle()
end

local gsub = string.gsub
local lower, gmatch = string.lower, string.gmatch
local function CMDSplit(CMD)
    local Args, index = { }, 1
    CMD = gsub(CMD, '"', "")
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = lower(Params)
        index = index + 1
    end
    return Args
end

function MOD:OnServerCommand(Executor, CMD)
    local Args = CMDSplit(CMD)
    if (Args ~= nil and Args[1] == self.command) then
        local lvl = tonumber(get_var(Executor, "$lvl"))
        if (lvl >= self.permission or Executor == 0) then
            if (Args[2] ~= nil) then
                if (self.vehicle_tag ~= nil) then
                    local pl = self:GetPlayers(Executor, Args)
                    if (pl) then
                        for i = 1, #pl do
                            local TargetID = tonumber(pl[i])
                            if (Executor == TargetID) then
                                if (not self.crash_self) then
                                    self:Respond(Executor, "You cannot execute this command on yourself", 10)
                                end
                            else
                                self:CrashClient(Executor, TargetID)
                            end
                        end
                    end
                else
                    self:Respond(Executor, "==================================================================", 10)
                    self:Respond(Executor, "Command does not work on this map.", 10)
                    self:Respond(Executor, "Please contact Chalwk (github.com/chalwk77/halo-script-projects)", 10)
                    self:Respond(Executor, "==================================================================", 10)
                end
            else
                self:Respond(Executor, "Invalid Syntax. Usage: /" .. self.command .. " [player id | me | */all]", 10)
            end
        else
            self:Respond(Executor, "Insufficient Permission", 10)
        end
        return false
    end
end

function MOD:GetXYZ(Ply)
    local x, y, z
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local VehicleID = read_dword(DyN + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            x, y, z = read_vector3d(DyN + 0x5c)
        else
            x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
        end
    end
    return x, y, z
end

function MOD:CrashClient(Executor, TargetID)
    local name = get_var(TargetID, "$name")
    if player_alive(TargetID) then
        local x, y, z = self:GetXYZ(TargetID)
        local vehicle = spawn_object("vehi", self.vehicle_tag, x, y, z)
        local object = get_object_memory(vehicle)
        if (object ~= 0) then
            --
            -- Initialize a for-loop starting at 0 (first iteration):
            --
            for seat = 0, self.iterations do
                --
                -- Enter player into the seat number of the current loop iteration.
                --
                enter_vehicle(vehicle, TargetID, seat)
                --
                -- Force player out of vehicle.
                --
                exit_vehicle(TargetID)
            end
            --
            -- Approx 50 milliseconds later:
            -- Destroy vehicle after for-loop has finished executing
            --
            destroy_object(vehicle)
        end
        self:Respond(Executor, "Crashed " .. name .. "'s game client", 10)
    else
        return self:Respond(Executor, name .. " is dead. Please wait until they respawn.")
    end
end

function MOD:Respond(Ply, Message, Color)
    Color = Color or 10
    if (Ply == 0) then
        cprint(Message, Color)
    else
        rprint(Ply, Message)
    end
end

function MOD:GetPlayers(Executor, Args)
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

function MOD:GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function MOD:SetCrashVehicle()
    self.vehicle_tag = nil
    self.iterations = nil
    if (get_var(0, "$gt") ~= "n/a") then
        for _, v in pairs(self.tags) do
            if self:GetTag("vehi", v[1]) then
                self.vehicle_tag = v[1]
                self.iterations = v[2]
                break
            end
        end
    end
end

function OnServerCommand(P, C)
    return MOD:OnServerCommand(P, C)
end
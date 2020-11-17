--[[
--=====================================================================================================--
Script Name: Vote Kick, for SAPP (PC & CE)
Description: Vote to kick a disruptive player from the server.

Command Syntax: /votekick [pid]
Typing /votekick by itself will show you a list of player names and their Index ID's (PID)

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
-- Configuration Starts -------------------------------------------
local VoteKick = {

    -- Custom command used to cast a vote or view player list:
    command = "votekick",

    -- Minimum players required to be online in order to vote:
    minimum_player_count = 3,

    -- Percentage of online players needed to kick a player:
    vote_percentage = 60,

    --
    -- Periodic Announcer:
    --
    -- This script will periodically broadcast a message every 120 seconds
    -- informing players about vote kick and the current votes needed to kick a player.
    -- This feature is only enabled while there are equal to or greater than minimum_player_count players online.
    -- The required votes is a calculation of the vote_percentage * player count / 100
    announcement_period = 180,

    -- If a player disconnects and returns within this amount of time (in seconds), votes against them will remain.
    cooldown_period = 30,

    --
    -- Advanced users only:
    --
    --
    -- The array index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for ip-only indexing.
    ClientIndexType = 2,
}
-- Configuration Ends ---------------------------------------------

local time_scale, gmatch = 1 / 30, string.gmatch
function VoteKick:Init()
    if (get_var(0, "$gt") ~= "n/a") then
        self.timer = 0
        self.votes = { }
        self.game_started = true
        for i = 1, 16 do
            if player_present(i) then
                self:InitPlayer(i, false)
            end
        end
    end
end

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    VoteKick:Init()
end

function VoteKick:OnTick()
    if (self.game_started) then
        for ip, v in pairs(self.votes) do
            if (not player_present(v.id) and v.cooldown) then
                v.cooldown = v.cooldown + time_scale
                if (v.cooldown >= self.cooldown_period) then
                    self.votes[ip] = nil
                end
            end
        end
        self.timer = self.timer + time_scale
        if (self.timer >= self.announcement_period) then
            self.timer = 0
            self:PeriodicAnnouncement()
        end
    end
end

function OnGameStart()
    VoteKick:Init()
end

function OnGameEnd()
    VoteKick.game_started = false
end

function OnPlayerConnect(Ply)
    VoteKick:InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    VoteKick:InitPlayer(Ply, true)
end

function VoteKick:InitPlayer(Ply, Reset)
    local IP = self:GetIP(Ply)
    if (not Reset) then
        self.votes[IP] = self.votes[IP] or {
            ip = IP,
            votes = 0,
        }
        self.votes[IP].id = Ply
        self.votes[IP].cooldown = nil
        self.votes[IP].name = get_var(Ply, "$name")
    else
        self.votes[IP].cooldown = 0
    end
end

function VoteKick:PeriodicAnnouncement()
    local player_count = self:GetPlayerCount()
    if (player_count >= self.minimum_player_count) then
        local votes_required = math.floor((self.vote_percentage * player_count / 100))
        local vote = "vote"
        if (votes_required > 1) then
            vote = vote .. "s"
        end
        self:Respond(_, "Vote Kick Enabled.")
        self:Respond(_, "[" .. votes_required .. " " .. vote .. " to kick] at " .. self.vote_percentage .. "% of the current server population")
    end
end

function VoteKick:Check(Ply, IP, PlayerCount)
    local votes_required = math.floor((self.vote_percentage * PlayerCount / 100))
    if (self.votes[IP].votes >= votes_required) then
        self:Respond(_, "Vote passed to kick " .. self.votes[IP].name .. " [Kicking]", 12)
        return true, self:Kick(Ply)
    end
    return false
end

local function CMDSplit(CMD)
    local Args, index = { }, 1
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = Params
        index = index + 1
    end
    return Args
end

function VoteKick:OnServerCommand(Executor, Command)
    local Args = CMDSplit(Command)
    if (Args[1] == self.command) then
        if (self.game_started) then
            if (Args[2] ~= nil) then

                local player_count = self:GetPlayerCount()
                if (player_count < self.minimum_player_count) then
                    return false, self:Respond(Executor, "There aren't enough players online for vote-kick to work.", 12)
                end

                local TargetID = Args[2]:match("^%d+$")
                TargetID = tonumber(Args[2])

                if (TargetID and TargetID > 0 and TargetID < 17) then
                    if player_present(TargetID) then

                        if (TargetID == Executor) then
                            return false, self:Respond(Executor, "You cannot vote to kick yourself", 12)
                        elseif self:IsAdmin(TargetID) then
                            return false, self:Respond(Executor, "You cannot vote to kick a server admin!", 12)
                        else

                            local TIP = self:GetIP(TargetID)
                            local EIP = self:GetIP(Executor)
                            if (self.votes[TIP][EIP]) then
                                return false, self:Respond(Executor, "You have already voted for this player to be kicked", 12)
                            end

                            self.votes[TIP][EIP] = true
                            self.votes[TIP].votes = self.votes[TIP].votes + 1

                            local kicked = self:Check(TargetID, TIP, player_count)
                            if (not kicked) then

                                local vote_percentage_calculated = self:VotesRequired(player_count, self.votes[TIP].votes)
                                local votes_required = math.floor(self.vote_percentage / vote_percentage_calculated)

                                local ename = get_var(Executor, "$name")
                                local tname = get_var(TargetID, "$name")

                                if (Executor == 0) then
                                    ename = "[SERVER]"
                                end

                                self:Respond(_, ename .. " voted to kick " .. tname .. " [Votes " .. self.votes[TIP].votes .. " of " .. votes_required .. " required]", 10)
                            end
                        end
                    else
                        self:Respond(Executor, "Player #" .. TargetID .. " is not online.", 12)
                    end
                else
                    self:Respond(Executor, "Invalid Player ID. Usage: /" .. self.command .. " [pid]")
                    self:Respond(Executor, "Type [/" .. self.command .. "] by itself to view all player ids")
                end
            else
                self:ShowPlayerList(Executor)
            end
        else
            self:Respond(Executor, "Please wait until the next game to vote kick a player.")
        end
        return false
    end
end

function VoteKick:ShowPlayerList(Executor)
    local player_count = self:GetPlayerCount()
    if (player_count > 0) then
        self:Respond(Executor, "[ ID.    -    Name.    -    Immune]", 13)
        for i = 1, 16 do
            if player_present(i) then
                local name = get_var(i, "$name")
                local admin = tostring(VoteKick:IsAdmin(i))
                self:Respond(Executor, "[" .. i .. "]   [" .. name .. "]   [" .. admin .. "]", 13)
            end
        end
        self:Respond(Executor, " ")
        self:Respond(Executor, "Command Usage: /" .. self.command .. " [pid]")
    else
        self:Respond(Executor, "There are no players online", 13)
    end
end

function VoteKick:GetPlayerCount()
    return tonumber(get_var(0, "$pn"))
end

function VoteKick:IsAdmin(Ply)
    return (tonumber(get_var(Ply, "$lvl")) >= 1)
end

function VoteKick:VotesRequired(PlayerCount, Votes)
    return math.floor(Votes / PlayerCount * 100)
end

function VoteKick:Respond(Ply, Message, Color)
    Color = Color or 10
    if (Ply == 0) then
        cprint(Message, Color)
    elseif (Ply) then
        rprint(Ply, Message)
    else
        cprint(Message)
        for i = 1, 16 do
            if player_present(i) then
                rprint(i, Message)
            end
        end
    end
end

function VoteKick:Kick(Ply)
    for _ = 1, 99999 do
        rprint(Ply, "  ")
    end
end

function VoteKick:GetIP(Ply)
    local IP = get_var(Ply, "$ip")
    if (Ply == 0) then
        IP = "127.0.0.1"
    end
    if (self.ClientIndexType == 1) then
        IP = IP:match("%d+.%d+.%d+.%d+")
    end
    if (not player_present(Ply)) then
        IP = self.votes[IP].ip
    end
    return IP
end

function OnServerCommand(P, C)
    return VoteKick:OnServerCommand(P, C)
end

function OnTick()
    return VoteKick:OnTick()
end

function OnScriptUnload()

end
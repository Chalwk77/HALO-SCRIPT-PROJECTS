--[[
--=====================================================================================================--
Script Name: Vote Kick, for SAPP (PC & CE)
Description: Vote to kick a disruptive player from the server.

    Command Syntax: /votekick [pid]
    Typing /votekick by itself will show you a list of player names and their Index ID's (pid)

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
-- Configuration Starts -------------------------------------------
local VoteKick = {

    -- Custom Command used to cast a vote or view player list:
    command = "votekick",

    -- Minimum players required to be online in order to vote.
    minimum_player_count = 3,

    -- percentage of online players needed to pass a vote.
    vote_percentage = 60,
}
-- Configuration Ends ---------------------------------------------

local gmatch, format = string.gmatch, string.format
function VoteKick:Init()
    if (get_var(0, "$gt") ~= "n/a") then
        self.votes = { }
        for i = 1, 16 do
            if player_present(i) then
                self:InitPlayer(i, false)
            end
        end
    end
end

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    VoteKick:Init()
end

function OnGameStart()
    VoteKick:Init()
end

function OnPlayerConnect(Ply)
    VoteKick:InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    VoteKick:InitPlayer(Ply, true)
end

function VoteKick:InitPlayer(Ply, Reset)
    if (not Reset) then
        self.votes[Ply] = { votes = 0, name = get_var(Ply, "$name") }
    else
        self.votes[Ply] = nil
    end
end

local function CMDSplit(CMD)
    local Args, index = { }, 1
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = Params
        index = index + 1
    end
    return Args
end

function VoteKick:Check(Ply, PlayerCount)
    local vote_percentage = self:VotesRequired(PlayerCount, self.votes[Ply].votes)
    if (vote_percentage >= self.vote_percentage) then
        local msg = format("Vote passed to kick %s", self.votes[Ply].name) .. " [Kicking]"
        self:Respond(_, msg, 12)
        return true, self:Kick(Ply)
    end
    return false
end

function VoteKick:OnServerCommand(Executor, Command)
    local Args = CMDSplit(Command)
    if (Args[1] == self.command) then

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

                        local ip = get_var(Executor, "$ip")
                        if (self.votes[TargetID][ip]) then
                            return false, self:Respond(Executor, "You have already voted for this player to be kicked", 12)
                        end

                        self.votes[TargetID][ip] = true
                        self.votes[TargetID].votes = self.votes[TargetID].votes + 1

                        local ename = get_var(Executor, "$name")
                        local tname = get_var(TargetID, "$name")
                        local vote_percentage_calculated = self:VotesRequired(player_count, self.votes[TargetID].votes)
                        local votes_required = math.floor(self.vote_percentage / vote_percentage_calculated)
                        if (Executor == 0) then
                            ename = "[SERVER]"
                        end
                        local kicked = self:Check(TargetID, player_count)
                        if (not kicked) then
                            self:Respond(_, ename .. " voted to kick " .. tname .. " [Votes " .. self.votes[TargetID].votes .. " of " .. votes_required .. " required]", 10)
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
        return false
    end
end

function VoteKick:ShowPlayerList(Executor)
    local player_count = self:GetPlayerCount()
    if (player_count > 0) then
        self:Respond(Executor, "[ ID.    -    Name. ]", 13)
        for i = 1, 16 do
            if player_present(i) then
                self:Respond(Executor, "[" .. i .. "]: " .. get_var(i, "$name") .. "          IMMUNE: " .. tostring(VoteKick:IsAdmin(i)), 13)
            end
        end
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

function OnServerCommand(P, C)
    return VoteKick:OnServerCommand(P, C)
end

function VoteKick:Kick(Ply)
    for _ = 1, 9999 do
        rprint(Ply, " ")
    end
end

function OnScriptUnload()

end
--[[
--=====================================================================================================--
Script Name: Vote Kick, for SAPP (PC & CE)
Description: Players can vote to kick disruptive players from the server.
             Votes are kept anonymous, and the player with the most votes is kicked.

             Vote command syntax: /votekick (player id)
             Vote list command syntax: /votelist

Copyright (c) 2020-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local VoteKick = {

    -- Command used to initiate a vote kick:
    --
    vote_command = 'votekick',

    -- Command used to view a list of players who can be voted out:
    --
    vote_list_command = 'votelist',

    -- Minimum number of players required to initiate a vote kick:
    --
    minimum_players = 2,

    -- Percentage of online players needed to vote yes to kick a player:
    --
    vote_percentage = 60,

    -- A players votes will be reset if they're not voted out within this time (in seconds):
    --
    vote_grace_period = 30,

    -- If a player quits and returns to the server within this time (in seconds),
    -- their vote will remain in vote kick tally:
    --
    quit_grace_period = 30
}

local players = {}
local ips = {}

local clock = os.clock

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

local function GetIP(ply)

    --
    -- SAPP cannot get the IP of a player who has quit (if retail version).
    -- So we'll use the IP from the player's last join (ips[] table)
    --

    ips[ply] = ips[ply] or get_var(ply, '$ip')
    return ips[ply]
end

function VoteKick:NewPlayer(o)
    setmetatable(o, { __index = self })
    self.__index = self
    return o
end

function VoteKick:IsAdmin()
    return (tonumber(get_var(self.id, '$lvl')) >= 1)
end

function VoteKick:Send(msg)
    rprint(self.id, msg)
end

function VoteKick:VoteList()
    local t = {}
    for _, v in pairs(players) do
        if (self.id ~= v.id and not v:IsAdmin()) then
            t[#t + 1] = { name = v.name, id = v.id }
        end
    end
    if (#t > 0) then
        self:Send('Players who can be voted out:')
        for i = 1, #t do
            self:Send('[' .. t[i].id .. '] ' .. t[i].name)
        end
    else
        self:Send('No players can be voted out.')
    end
end

function VoteKick:Initiate(args)

    local total_players = tonumber(get_var(0, '$pn'))
    local success, player = pcall(function()
        return players[GetIP(tonumber(args[2]))]
    end)

    if (not success or not player) then
        self:Send('Invalid player.')
    elseif (player.id ~= self.id) then
        if (player:IsAdmin()) then
            self:Send('You cannot vote to kick an admin.')
        elseif (player.votes[self.ip]) then
            self:Send('You have already voted to kick ' .. player.name)
        elseif (total_players < self.minimum_players) then
            self:Send('Not enough players to initiate a vote kick.')
        else
            player.grace = clock() + VoteKick.vote_grace_period
            player.votes[self.ip] = true
            player.votes.total = player.votes.total + 1
            player:CheckVotes(self, total_players)
        end
    else
        self:Send('You cannot vote to kick yourself.')
    end
end

function VoteKick:CheckVotes(voter, total_players)
    local votes = self.votes.total
    local votes_remaining = math.ceil((self.vote_percentage / 100) * total_players) - votes
    if (votes_remaining == 0) then
        self:Kick()
    else
        execute_command('msg_prefix ""')
        say_all(voter.name .. ' voted to kick ' .. self.name .. ' (' .. votes_remaining .. ' votes needed)')
        execute_command('msg_prefix "' .. self.prefix .. '"')
    end
end

function VoteKick:Kick()
    self:Send('Vote kick passed.')
    self:Send('You have been kicked from the server.')
    execute_command('k ' .. self.id)
end

function VoteKick:Reset()
    self.votes = {}
    self.grace = nil
    self:Send('Votes against you have been reset.')
end

local function CMDSplit(s)
    local args = {}
    for arg in s:gmatch('([^%s]+)') do
        args[#args + 1] = arg:lower()
    end
    return args
end

function OnCommand(Ply, CMD)
    local args = CMDSplit(CMD)
    if (Ply > 0) then
        if (args[1] == VoteKick.vote_command) then
            players[GetIP(Ply)]:Initiate(args)
            return false
        elseif (args[1] == VoteKick.vote_list_command) then
            players[GetIP(Ply)]:VoteList()
            return false
        end
    end
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnTick()
    for ip, v in pairs(players) do
        if (v.quit and v.quit - clock() <= 0) then
            players[ip] = nil
        elseif (v.grace and v.grace - clock() <= 0) then
            v:Reset()
        end
    end
end

function OnJoin(ply)

    local ip = GetIP(ply)

    players[ip] = players[ip] or VoteKick:NewPlayer({
        ip = ip,
        id = ply,
        votes = { total = 0 }
    })

    -- update name in case they come back with a new one.
    players[ip].name = get_var(ply, '$name')

    -- just in case they come back after quitting.
    players[ip].quit = nil
end

function OnQuit(ply)
    local ip = GetIP(ply)
    ips[ip] = nil
    players[ip].quit = clock() + VoteKick.quit_grace_period
end

function OnScriptUnload()
    -- N/A
end
--=====================================================================================================--
-- Script Name: Vote Kick, for SAPP (PC & CE)
-- Description: Vote to kick disruptive players from the server.
--              Vote command syntax: /votekick (player id)
--              Vote list command syntax: /votelist
--
-- Copyright (c) 2020-2022, Jericho Crosby <jericho.crosby227@gmail.com>
-- Notice: You can use this script subject to the following conditions:
--         https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--

-- Configuration table for the Vote Kick script
local VoteKick = {
    -- Command to initiate a vote kick
    vote_command = 'votekick',

    -- Command to list players who can be voted out
    vote_list_command = 'votelist',

    -- Minimum number of players required to initiate a vote kick
    minimum_players = 2,

    -- Percentage of votes required to kick a player
    vote_percentage = 60,

    -- Grace period (in seconds) after a vote kick is initiated
    vote_grace_period = 30,

    -- Grace period (in seconds) after a player quits
    quit_grace_period = 30,

    -- Whether votes are anonymous
    anonymous_votes = false,

    -- Whether to announce when a vote kick is initiated
    announce_on_initiate = true,

    -- Whether to periodically announce the usage of the vote kick command
    announce_usage = true,

    -- Interval (in seconds) for announcing the usage of the vote kick command
    announce_interval = 120,

    -- Whether admins are immune to vote kicks
    admin_immunity = true,

    -- Prefix for server messages
    prefix = '**SAPP**'
}

local players, ips = {}, {}
local clock = os.clock
api_version = '1.12.0.0'

-- Utility Functions
local function GetIP(ply)
    return get_var(ply, "$ip"):match("(%d+.%d+.%d+.%d+)")
end

local function CMDSplit(s)
    local args = {}
    for arg in s:gmatch('([^%s]+)') do
        table.insert(args, arg)
    end
    return args
end

function announce_usage()
    say_all("Use /" .. VoteKick.vote_command .. " [player id] to initiate a vote kick.")
end

local function InitAnnouncements()

    if VoteKick.announce_usage then
        timer(VoteKick.announce_interval * 1000, "announce_usage")
    end
end

-- Player Class
local Player = {}
Player.__index = Player

function Player:new(id)
    local self = setmetatable({}, Player)
    self.id = id
    self.name = get_var(id, "$name")
    self.votes = { total = 0 }
    self.grace = nil
    return self
end

function Player:IsAdmin()
    local lvl = tonumber(get_var(self.id, "$lvl"))
    return (VoteKick.admin_immunity and lvl >= 0) or false
end

function Player:Send(msg)
    rprint(self.id, "|c" .. msg)
end

function Player:ResetVotes()
    self.votes = { total = 0 }
    self.grace = nil
    self:Send('Votes against you have been reset.')
end

function Player:AnnounceSession()
    execute_command('msg_prefix ""')
    say_all('Vote Kick has been initiated on ' .. self.name .. '.')
    say_all('Use command /' .. VoteKick.vote_list_command .. ' to view a list of players who can be voted out.')
    say_all('Use command /' .. VoteKick.vote_command .. ' (id) to vote to kick a player.')
    execute_command('msg_prefix "' .. VoteKick.prefix .. '"')
end

function Player:CheckVotes(voter, total_players)
    local votes = self.votes.total
    if VoteKick.announce_on_initiate and votes == 1 then
        self:AnnounceSession()
    end

    local votes_needed = math.ceil((VoteKick.vote_percentage / 100) * total_players) - votes
    if votes_needed == 0 then
        self:Kick(voter)
    elseif not VoteKick.anonymous_votes then
        say_all(voter.name .. ' voted to kick ' .. self.name .. ' - (' .. votes_needed .. ' votes needed)')
    end
end

function Player:Kick(voter)
    self:Send('Vote kick passed.')
    self:Send('You have been kicked from the server.')
    execute_command('k ' .. self.id .. ' "[Vote-Kick ' .. self.votes.total .. ' votes]"')
    if not VoteKick.anonymous_votes then
        say_all(voter.name .. ' voted to kick ' .. self.name)
    end
end

-- Event Handlers
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
    InitAnnouncements()
end

function OnStart()
    if get_var(0, '$gt') ~= 'n/a' then
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnJoin(ply)
    local ip = GetIP(ply)
    players[ip] = players[ip] or Player:new(ply)
    players[ip].name = get_var(ply, '$name')
    players[ip].quit = nil
end

function OnQuit(ply)
    local ip = GetIP(ply)
    ips[ip] = nil
    players[ip].quit = clock() + VoteKick.quit_grace_period
end

function OnTick()
    for _, player in pairs(players) do
        if player.quit and clock() > player.quit then
            player:ResetVotes()
        end
    end
end

function OnCommand(Ply, CMD)
    local args = CMDSplit(CMD)
    if Ply > 0 then
        local command = args[1]
        if command == VoteKick.vote_command then
            local target_id = tonumber(args[2])
            if target_id and player_present(target_id) then
                local target_ip = GetIP(target_id)
                local target = players[target_ip]
                if target and not target:IsAdmin() then
                    target.votes.total = target.votes.total + 1
                    target:CheckVotes(players[GetIP(Ply)], tonumber(get_var(0, '$pn')))
                end
            end
        elseif command == VoteKick.vote_list_command then
            for _, player in pairs(players) do
                if player_present(player.id) and not player:IsAdmin() then
                    rprint(Ply, player.id .. " - " .. player.name)
                end
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end
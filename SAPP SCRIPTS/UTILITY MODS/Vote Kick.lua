--[[
--=====================================================================================================--
Script Name: Vote Kick, for SAPP (PC & CE)
Description: Vote to kick disruptive players from the server.

             Vote command syntax: /votekick (player id)
             Vote list command syntax: /votelist

Copyright (c) 2020-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

local VoteKick = {

    -- Command used to initiate a vote kick:
    --
    vote_command = 'votekick',

    -- Command used to view a list of players who can be voted out:
    --
    vote_list_command = 'votelist',

    -- Minimum number of players required to initiate a vote kick:
    -- Default: 2 players
    --
    minimum_players = 2,

    -- Percentage of online players needed to vote yes to kick a player:
    -- Default: 60%
    --
    vote_percentage = 60,

    -- A players votes will be reset if they're not voted out within this time (in seconds):
    -- Default: 30s
    --
    vote_grace_period = 30,

    -- If a player quits and returns to the server within this time (in seconds),
    -- their vote will remain in vote kick tally:
    -- Default: 30s
    --
    quit_grace_period = 30,

    -- If true, players will be able to vote anonymously:
    -- Default: false
    --
    anonymous_votes = false,

    -- If true, a message will be displayed when a new vote kick has been initiated:
    -- Default: true
    --
    announce_on_initiate = true,

    -- If true, a message announcing command usage will be displayed after a certain time, recurrently
    -- Default: true
    announce_usage = true,

    -- Interval in which announcement messages will be displayed (in seconds)
    -- Default: 120s
    announce_interval = 120,

    -- If true, admins will be immune:
    -- Default: true
    --
    admin_immunity = true,

    -- A message relay function temporarily removes the msg_prefix and restores
    -- it to this when done:
    -- Default: **SAPP**
    --
    prefix = '**SAPP**'
}
-- config ends --

local clock = os.clock
local players, ips = {}, {}

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
    InitAnnouncements()
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
    local lvl = tonumber(get_var(self.id, "$lvl"))
    return (self.admin_immunity and lvl >= 0) or false
end

function VoteKick:Send(msg)
    rprint(self.id, "|c" .. msg)
end

function VoteKick:VoteList()
    local t = {}
    for _, v in pairs(players) do
        if (self.id ~= v.id and not v:IsAdmin()) then
            local votes = v.votes
            v.votes = (not votes.total and 0) or votes.total
            t[#t + 1] = { name = v.name, id = v.id, votes = votes }
        end
    end
    if (#t > 0) then
        self:Send('Players who can be voted out:')
        for i = 1, #t do
            self:Send('[' .. t[i].id .. '] ' .. t[i].name .. ' - (' .. t[i].votes .. ') votes')
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

function VoteKick:SayAll(voter, votes_remaining)
    execute_command('msg_prefix ""')
    say_all(voter.name .. ' voted to kick ' .. self.name .. ' - (' .. votes_remaining .. ' votes needed)')
    execute_command('msg_prefix "' .. self.prefix .. '"')
end

function VoteKick:AnnounceSession()
    execute_command('msg_prefix ""')
    say_all('Vote Kick has been initiated on ' .. self.name .. '.')
    say_all('Use command /' .. self.vote_list_command .. ' to view a list of players who can be voted out.')
    say_all('Use command /' .. self.vote_command .. ' (id) to vote to kick a player.')
    execute_command('msg_prefix "' .. self.prefix .. '"')
end

function VoteKick:CheckVotes(voter, total_players)

    local votes = self.votes.total
    if (self.announce_on_initiate and votes == 1) then
        self:AnnounceSession()
    end

    local votes_remaining = math.ceil((self.vote_percentage / 100) * total_players) - votes
    if (votes_remaining == 0) then
        self:Kick(voter, votes_remaining)
    elseif (not self.anonymous_votes) then
        self:SayAll(voter, votes_remaining)
    else
        voter:Send('Vote cast against ' .. self.name .. ' - (' .. votes_remaining .. ' votes needed)')
    end
end

function VoteKick:Kick(voter, votes_remaining)
    self:Send('Vote kick passed.')
    self:Send('You have been kicked from the server.')
    execute_command('k ' .. self.id .. ' "[Vote-Kick ' .. self.votes.total .. ' votes]"')
    if (not self.anonymous_votes) then
        self:SayAll(voter, votes_remaining)
    end
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
        
        elseif (args[1] == "usage" and #args > 1) then
            if( args[2] == VoteKick.vote_command ) then
                players[GetIP(Ply)]:Send( 
                    "Usage: " .. VoteKick.vote_command .. " <ID> (Retrieve ID from /" .. VoteKick.vote_list_command .. ")" 
                )
                players[GetIP(Ply)]:Send(
                    "Description: Vote for kick a player from the server (Do it responsibly)"
                )   
                return false
            elseif ( args[2] == VoteKick.vote_list_command ) then
                players[GetIP(Ply)]:Send(
                    "Usage: " .. VoteKick.vote_list_command
                )
                players[GetIP(Ply)]:Send(
                    "Description: Get a list of players that can be kicked from the server"
                )
                return false
	        end
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

function InitAnnouncements()
   function announce_usage ()
       message = "Vote kick is enabled, type /usage " .. VoteKick.vote_list_command .. 
	        " and /usage " .. VoteKick.vote_command  
       
        for ip, v in pairs(players) do
            if ( not v.quit ) then
	            v:Send( message )
	        end
        end
        return true
   end

   if ( VoteKick.announce_usage ) then
       timer( VoteKick.announce_interval * 1000, "announce_usage" )
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
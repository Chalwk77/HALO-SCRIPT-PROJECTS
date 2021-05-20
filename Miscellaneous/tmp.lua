--[[
--=====================================================================================================--
Script Name: Discord Bot, for SAPP (PC & CE)
Description: A Discord bot framework built using the Discordia API and Luvit runtime environment.

- features -

1). Easily connect one (or more) Halo servers to a Discord server.
	See ./Discord Bot/settings.lua for help with this.

2). The bot will relay a message to your Discord server when the following events are fired:
	Event                 Announcement Description
	-----                 ------------------------
	* event_join	      Player connected to the server.
	* event_quit	      Player disconnected from the server.
	* event_game_start    A new game starts (shows map & mode).
	* event_game_end      The current game ends (and shows who won).
	* event_chat	      Chat messages sent to defined global-channel.
	* event_score	      Message sent when player scores.
	* event_command	      Command logs sent to defined command-log channel.
	* event_death	      killed by server, squashed by vehicle,
						  run over, betrayal, pVP, suicide,
						  zombie-infect, first blood, guardians,
						  killed from grave, unknown.

	[note] The bot will ignore commands containing sensitive information (namely passwords).
	See ./Discord Bot/settings.lua for help with this.


3). Two-way chat integration:
	Send messages directly to the specified Halo server from Discord (and visa versa)

	Discord to halo example, as seen in-game:
	[Discord] Chalwk: Hi

	Halo to Discord example:
	[CHAT] Chalwk: Hi (halo to Discord)


4). The bot will feedback the name of the winning player (or team) on Discord after each game:

	Please refer to these image examples:
	https://imgur.com/a/KyDJoqR and https://imgur.com/a/Z5YE1nK


5). The server will attempt to send status messages to a defined Discord channel.
    These status messages include the current map, mode, game type and player count.
	See "./Discord Bot/settings.lua" for help with this.
    Please refer to this image example: https://imgur.com/a/EIw3YBL

=============================================================================
FOR INSTALLATION INSTRUCTIONS AND UPDATES:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/releases/tag/v1.0.10-Discord-Bot
=============================================================================

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

------------- [ CONFIGURATION STARTS ] -------------
-- Specify the name of the Bot Folder:
local bot_folder_name = "Discord Bot"

-- Set the server id here (see ./Discord Bot/settings.lua for help with this)
local server_id = 4
------------- [ CONFIGURATION ENDS ] -------------

local Discord = {
    version = "1.0.10",
    events = { status = { "N/A", "N/A", "N/A", "N/A" }, outbound = { }, inbound = { } },
    dir = bot_folder_name .. "/SV " .. server_id .. " Game Events.json"
}

-- One-time load of the json routines and settings array:
local json_path = bot_folder_name .. "/deps/Discordia/libs/utils/Json.lua"
local json = (loadfile(json_path))()

local settings = require(bot_folder_name .. "/settings")

-- global_channel[1] = (int) numerical channel id
-- global_channel[2] = (boolean) channel enabled or disabled (true/false)
local global_channel = settings.servers[server_id].global
--

-- delta time scale
local time_scale = 1 / 30

-- Temporary variables for storing team scores:
local r_combined_score = 0
local b_combined_score = 0

-- Used to store the server name:
local server_name
--

local fall_damage_metaid
local distance_damage_metaid

local human_team = settings.zombies.human_team
local zombie_team = settings.zombies.zombie_team

function OnScriptLoad()
    --
    -- register needed event callbacks:
    --
    register_callback(cb["EVENT_TICK"], "OnTick")

    register_callback(cb["EVENT_DIE"], "DeathHandler")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "DeathHandler")

    register_callback(cb["EVENT_CHAT"], "OnPlayerChat")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")

    register_callback(cb["EVENT_SCORE"], "OnPlayerScore")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_TEAM_SWITCH"], "TeamChange")

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    Discord:Init(false)
end

function OnScriptUnload()
    --
end

-- This function returns the memory address [int] of a tag in the map using
-- the tag’s class and path.
local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function Discord:Init(GAME_START)
    local gt = get_var(0, "$gt")
    if (gt ~= "n/a") then

        -- Get and bind the server name to variable "server_name" (accessed in OnError())
        local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
        server_name = read_widestring(ns + 0x8, 0x42)
        --

        self.team_play = (get_var(0, "$ffa") == "0")

        -- init players array (see self:InitPlayer() for details)
        self.players = { }

        r_combined_score = 0
        b_combined_score = 0

        fall_damage_metaid = GetTag("jpt!", "globals\\falling")
        distance_damage_metaid = GetTag("jpt!", "globals\\distance")

        -- Status Checker Timer --
        timer(settings.status_check_frequency * 1000, "StatusChecker")

        -- Inbound Messages Timer --
        timer(settings.inbound_check_frequency * 1000, "CheckForInbound")

        self.stats = {
            gt = gt,
            red = 0,
            blue = 0,
            map = get_var(0, "$map"),
            mode = get_var(0, "$mode")
        }

        for i = 1, 16 do
            if player_present(i) then
                self:InitPlayer(i, false)
            end
        end

        -- Execute this block only when a new game starts:
        if (GAME_START) then

            -- Instruct server to monitor for first blood:
            self.first_blood = true
            local map, mode = get_var(0, "$map"), get_var(0, "$mode")

            local str = settings.messages["event_game_start"]

            -- Do "replace" operation on title and description (just in case)
            local title = str[1]:gsub("%%map%%", map):gsub("%%mode%%", mode)
            local description = str[2]:gsub("%%map%%", map):gsub("%%mode%%", mode)

            self:AddMessage(title, description, global_channel)
        end
    end
end

function OnGameStart()
    Discord:Init(true)
end

function OnGameEnd()
    Discord:WhoWon()
end

-- Add messages to outbound array (sent to Discord)
--
function Discord:AddMessage(Title, Description, ChannelID)

    local channel_id = ChannelID[1]
    local channel_enabled = ChannelID[2]

    if (channel_enabled) then
        table.insert(self.events.outbound, {
            Title,
            Description,
            channel_id
        })
    end
end

-- Open "Game Events.json" in write mode:
--
function Discord:UpdateJSON(Events)
    local file = assert(io.open(self.dir, "w"))
    if (file) then
        file:write(json:encode_pretty(Events))
        file:close()
    end
end

-- Decodes JSON array into Lua array and returns it:
local function GetEvents()

    local events
    local file = io.open(Discord.dir, "r")
    if (file) then
        local contents = file:read("*all")
        events = (contents and json:decode(contents)) or nil
        file:close()
    end

    return events
end

-- Called every "settings.inbound_check_frequency" seconds:
--
function CheckForInbound()
    local events = GetEvents()
    if (events and events.inbound) then
        Discord.events.inbound = events.inbound
    end
    return true
end

function Discord:StatusChecker()

    if (not settings.servers[server_id].status_channel[2]) then
        return false
    end

    local events = GetEvents()
    if (events) then

        local prefix = (self.team_play and " (team)" or "")
        if (self.stats.gt == "ctf") then
            prefix = ""
        end

        self:UpdateJSON({
            status = {
                self.stats.map,
                self.stats.mode,
                self.stats.gt .. prefix,
                tonumber(get_var(0, "$pn"))
            },

            inbound = table.merge(events.inbound, self.events.inbound),
            outbound = table.merge(events.outbound, self.events.outbound)
        })
    end

    return true
end

function table.merge(t1, t2)

    for _, v in ipairs(t2) do
        table.insert(t1, v) -- insert values from t2
    end

    -- Remove duplicate table elements in t1
    local hash, res = {}, {}
    for _, v in ipairs(t1) do
        if (not hash[v]) then
            res[#res + 1] = v
            hash[v] = true
        end
    end

    return res
end

local function HasObjective(Ply)
    --
    -- This function will return true if holding flag/oddball
    --
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        for i = 0, 3 do

            -- The weapon will return 0xFFFFFFFFF if the slot is unused:
            local weapon = read_dword(DyN + 0x2F8 + 4 * i)
            if (weapon ~= 0xFFFFFFFFF) then
                local WeaponObject = get_object_memory(weapon)
                if (WeaponObject ~= 0) then
                    local tag_address = read_word(WeaponObject)
                    local tag_data = read_dword(read_dword(0x40440000) + tag_address * 0x20 + 0x14)
                    if (read_bit(tag_data + 0x308, 3) == 1) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Called every 1/30th second:
function Discord:GameUpdate()

    -- Messages sent to Discord:
    -- Check if there are any locally stored outbound messages:
    if (#self.events.outbound > 0) then

        -- Prepare outbound messages for sending:
        local events = GetEvents()
        if (events) then
            self:UpdateJSON({
                status = events.status,
                inbound = table.merge(events.inbound, self.events.inbound),
                outbound = table.merge(events.outbound, self.events.outbound)
            })
            self.events.outbound = { }
        end
        --

        -- Check for inbound messages (from Discord):
    elseif (#self.events.inbound > 0) then

        execute_command('msg_prefix ""')
        for msg, v in pairs(self.events.inbound) do
            if (msg) then
                say_all(v)
            end
        end
        execute_command('msg_prefix "' .. settings.servers[server_id].server_prefix .. ' "')

        self.events.inbound = { }
        local events = GetEvents()
        if (events) then
            self:UpdateJSON({
                status = events.status,
                inbound = {},
                outbound = table.merge(events.outbound, self.events.outbound)
            })
        end
    end

    for i = 1, 16 do
        if player_present(i) and player_alive(i) then

            -- Update race scores (used to display end-game results)
            if (self.stats.gt == "race") then
                local laps = tonumber(read_word(get_player(i) + 0xC6))
                if (self.team_play) then
                    local team = get_var(i, "$team")
                    if (team == "red") then
                        if (r_combined_score > self.stats.red) then
                            self.stats.red = r_combined_score
                        end
                        r_combined_score = laps
                    elseif (team == "blue") then
                        if (b_combined_score > self.stats.blue) then
                            self.stats.blue = b_combined_score
                        end
                        b_combined_score = laps
                    end
                end

                -- Update hill time scores (used to display end-game results)
            elseif (self.stats.gt == "king") then
                local hill_time = tonumber(read_word(get_player(i) + 0xC4)) / 30
                if (self.team_play) then
                    local team = get_var(i, "$team")
                    if (team == "red") then
                        if (r_combined_score > self.stats.red) then
                            self.stats.red = r_combined_score
                        end
                        r_combined_score = hill_time
                    elseif (team == "blue") then
                        if (b_combined_score > self.stats.blue) then
                            self.stats.blue = b_combined_score
                        end
                        b_combined_score = hill_time
                    end
                else
                    self.players[i].hill_time = hill_time
                end

                -- Update oddball hold time scores (used to display end-game results)
            elseif (self.stats.gt == "oddball" and HasObjective(i)) then
                self.players[i].oddball = self.players[i].oddball + time_scale
            end
        end
    end
end

function Discord:WhoWon()

    local str = 'No Winner'
    local gt = self.stats.gt

    local game_over = settings.messages["event_game_end"]

    if (gt == "ctf" or gt == "slayer") then
        if (self.team_play) then
            --
            -- Check team with most kills or highest score
            local r_score = get_var(0, "$redscore")
            local b_score = get_var(0, "$bluescore")
            --
            if (r_score > b_score) then
                str = game_over[3][1]
            elseif (b_score > r_score) then
                str = game_over[3][2]
            elseif (b_score == r_score) then
                str = game_over[3][3]
            end
            --
        else
            --
            -- Slayer FFA: Check who has most kills:
            local count, winner = 0
            for i, v in pairs(self.players) do
                if player_present(i) then
                    local kills = tonumber(get_var(i, "$kills"))
                    if (kills > count) then
                        count = kills
                        winner = v
                    end
                end
            end
            if (winner) then
                str = game_over[3][3]:gsub("%%winner%%", winner.name):gsub("%%kills%%", count)
            end
        end


    elseif (gt == "race") then
        if (self.team_play) then
            --
            -- RACE: Check who has the most laps (team total):
            if (self.stats.red > self.stats.blue) then
                str = game_over[3][1]
            elseif (self.stats.blue > self.stats.red) then
                str = game_over[3][2]
            elseif (self.stats.blue == self.stats.red) then
                str = game_over[3][3]
            end
            --
        else
            --
            -- RACE: Check who has the most laps (online players only):
            local laps, winner = 0
            for i, v in pairs(self.players) do
                if player_present(i) then
                    if (v.laps > laps) then
                        laps = v.laps
                        winner = v
                    end
                end
            end
            if (winner) then
                str = game_over[3][5]:gsub("%%winner%%", winner.name):gsub("%%laps%%", winner.laps)
            end
        end


    elseif (gt == "king") then
        --
        -- KING: Check who has the most hill time (team total):
        if (self.team_play) then
            --
            if (self.stats.red > self.stats.blue) then
                str = game_over[3][1]
            elseif (self.stats.blue > self.stats.red) then
                str = game_over[3][2]
            elseif (self.stats.blue == self.stats.red) then
                str = game_over[3][3]
            end
            --
        else
            --
            -- KING: Check who has the most hill time (online players only):
            local hill_time, winner = 0
            for i, v in pairs(self.players) do
                if player_present(i) then
                    if (v.hill_time > hill_time) then
                        hill_time = v.hill_time
                        winner = v
                    end
                end
            end
            if (winner) then
                str = game_over[3][6]:gsub("%%winner%%", winner.name)
            end
        end


    elseif (gt == "oddball") then
        --
        -- ODDBALL: Check which team has the most oddball time (team total):
        if (self.team_play) then
            local r_time, b_time = 0, 0
            for i, v in pairs(self.players) do
                if player_present(i) then
                    local team = get_var(i, "$team")
                    if (team == "red") then
                        r_time = r_time + v.oddball
                    else
                        b_time = b_time + v.oddball
                    end
                end
            end
            --
            if (r_time > b_time) then
                str = game_over[3][1]
            elseif (b_time > r_time) then
                str = game_over[3][2]
            elseif (b_time == r_time) then
                str = game_over[3][3]
            end
            --
        else
            --
            -- ODDBALL: Check who held the ball for the longest time (online players only):
            local _time, winner = 0
            for i, v in pairs(self.players) do
                if player_present(i) then
                    if (v.oddball > _time) then
                        _time = v.oddball
                        winner = v
                    end
                end
            end
            if (winner) then
                str = game_over[3][7]:gsub("%%winner%%", winner.name)
            end
        end
    end

    self.first_blood = false

    -- 1st end-game embedded message:
    self:AddMessage(game_over[1][1], game_over[1][2], global_channel)

    -- 2nd end-game embedded message:
    -- Do "replace" operation on title and description (just in case)
    local title = game_over[2][1]:gsub("%%results%%", str)
    local description = game_over[2][2]:gsub("%%results%%", str)

    self:AddMessage(title, description, global_channel)
end

-- We do not want to send chat-commands (these are handled by OnServerCommand())
local function isChatCommand(str)

    local a = settings.command_prefix[1]
    local b = settings.command_prefix[2]

    return (str:sub(1, 1) == a or str:sub(1, 1) == b) or false
end

function Discord:OnPlayerChat(P, M, T)

    -- Check if chat type is "global" before sending message to Discord.
    if (T == 0 and not isChatCommand(M)) then

        -- Prevent players from @mentioning
        --
        if (not settings.allow_mentions) then
            local mention = M:match("(@[%g]+)")
            if (mention) then
                M = mention:gsub("@", "")
            end
        end

        -- Format message for output and send to Discord:
        local channel = settings.servers[server_id].on_chat
        local name = self.players[P].name
        local str = channel[1]:gsub("%%name%%", name):gsub("%%msg%%", M)

        self:AddMessage(nil, str, { channel[2], channel[3] })
    end
end

--
-- This function checks if the command contains any blacklisted keywords:
--
local function BlackListed(Str)
    for _, word in pairs(settings.command_blacklist) do
        if Str:lower():find(word) then
            return true
        end
    end
    return false
end

function Discord:OnServerCommand(Ply, CMD, Environment, _)
    if (Ply ~= 0) then

        -- Make sure sensitive information isn't sent:
        if (not BlackListed(CMD)) then

            -- Appropriate string output based on command environment (chat/rcon)
            local channel = settings.servers[server_id].on_command[Environment]

            -- Format message for output and send to Discord:
            local name = self.players[Ply].name
            local str = channel[1]:gsub("%%name%%", name):gsub("%%cmd%%", CMD)

            self:AddMessage("-", str, { channel[2], channel[3] })
        end
    end
end

function Discord:InitPlayer(Ply, Disconnected)
    if (not Disconnected) then

        local name = get_var(Ply, "$name")

        -- Initialise a new array for this player:
        self.players[Ply] = {

            -- Store copy of this player's name:
            name = name,

            -- Used to track applied damage tag ids (meta id)
            -- to distinguish fall damage from distance damage
            meta_id = 0,

            -- Used to track current player lap count (updated regularly)
            laps = 0,

            -- Used to track current hill time (updated regularly)
            hill_time = 0,

            -- Used to track time holding oddball (updated regularly)
            oddball = 0,

            team_change = false,
            team = get_var(Ply, "$team")
        }

        local msg = settings.messages["event_join"]

        -- Do "replace" operation on title and description (just in case)
        local title = msg[1]:gsub("%%name%%", name)
        local description = msg[2]:gsub("%%name%%", name)

        self:AddMessage(title, description, global_channel)
        --
        --
        --
    elseif (self.players[Ply]) then

        local msg = settings.messages["event_quit"]
        local name = self.players[Ply].name

        -- Do "replace" operation on title and description (just in case)
        local title = msg[1]:gsub("%%name%%", name)
        local description = msg[2]:gsub("%%name%%", name)

        self:AddMessage(title, description, global_channel)
        self.players[Ply] = nil
    end
end

function OnPlayerSpawn(Ply)
    local player = Discord.players[Ply]
    if (player) then
        player.meta_id = 0
    end
end

function OnPlayerConnect(Ply)
    Discord:InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    Discord:InitPlayer(Ply, true)
end

function TeamChange(Ply)
    if (Discord.players[Ply]) then
        Discord.players[Ply].team_change = true
        Discord.players[Ply].team = get_var(Ply, "$team")
    end
end

local function Falling(MetaID)
    if (MetaID == fall_damage_metaid) then
        return "fall_damage"
    elseif (MetaID == distance_damage_metaid) then
        return "distance_damage"
    end
    return nil
end

local function InVehicle(Ply)

    -- Get memory address of this player:
    -- Returns 0 if player is not currently alive.
    local DyN = get_dynamic_player(Ply)

    if (DyN ~= 0) then

        -- Get memory address of player vehicle.
        -- Returns 0 if invalid or dos not exist.
        local VehicleID = read_dword(DyN + 0x11C)
        local VehicleObject = get_object_memory(VehicleID)

        if (VehicleObject ~= 0) then
            return true
        end
    end
    return false
end

function Discord:ReportDeath(victim, killer, Type)

    local str = settings.messages["event_die"][Type]

    if (victim) then
        str = str:gsub("%%team%%", victim.team)
        str = str:gsub("%%victim%%", victim.name)
    end

    if (killer) then
        str = str:gsub("%%killer%%", killer.name)
    end

    self:AddMessage(nil, str, global_channel)
end

-- This function processes player death events:
function Discord:DeathHandler(Victim, Killer, MetaID)

    local victim = tonumber(Victim)
    local killer = tonumber(Killer)

    local v = self.players[victim]
    local k = self.players[killer]

    if (v) then

        -- event_damage_application:
        if (MetaID) then
            v.meta_id = MetaID
            return
        end

        -- event_die:
        local server = (killer == -1)
        local squashed = (killer == 0)
        local guardians = (killer == nil)
        local suicide = (killer == victim)
        local pvp = (killer > 0 and killer ~= victim)
        local falling = Falling(v.meta_id)
        local team_change = (server and v.team_change and not falling)
        local betrayal = ((k and self.team_play) and (v.team == k.team) and (killer ~= victim))

        v.team_change = false

        if (pvp and not betrayal) then

            -- Check for first blood:
            if (self.first_blood) then
                self:FirstBlood(killer)
            end
            --

            -- Killed from Grave:
            if (not player_alive(killer)) then
                return self:ReportDeath(v, k, "killed_from_grave")
            end

            -- Check if killer is in Vehicle:
            if InVehicle(killer) then
                return self:ReportDeath(v, k, "run_over")
            end

            -- Zombie Support: (infect message)
            if (settings.zombies.enabled and k.team == zombie_team and v.team == human_team) then
                return self:ReportDeath(v, k, "zombie_infect")
            end

            self:ReportDeath(v, k, "pvp")
        elseif (team_change) then
            self:ReportDeath(v, nil, "team_change")
        elseif (server and not falling) then
            self:ReportDeath(v, nil, "server")
        elseif (guardians) then
            self:ReportDeath(v, nil, "guardians")
        elseif (suicide) then
            self:ReportDeath(v, nil, "suicide")
        elseif (betrayal) then
            self:ReportDeath(v, k, "betrayal")
        elseif (squashed) then
            self:ReportDeath(v, nil, "squashed")
        elseif (falling ~= nil) then
            self:ReportDeath(v, nil, falling)
        else
            self:ReportDeath(v, nil, "died/unknown")
        end
    end
end

-- This function monitors the server for FIRST BLOOD.
function Discord:FirstBlood(Ply)
    local kills = tonumber(get_var(Ply, "$kills"))
    if (kills == 1) then
        self.first_blood = false
        self:ReportDeath(nil, self.players[Ply], "first_blood")
    end
end

local function Plural(s)
    return (tonumber(s) > 1 and "s") or ""
end

function Discord:OnPlayerScore(Ply)

    local player = self.players[Ply]

    if (player) then
        if (self.stats.gt == "race" and not self.team_play) then
            player.laps = tonumber(read_word(get_player(Ply) + 0xC6))
        else

            local s = get_var(Ply, "$score")
            local n = player.name

            local t = settings.messages["event_score"]
            local str = t:gsub("%%name%%", n):gsub("%%count%%", s):gsub("%%s%%", Plural(s))
            self:AddMessage(nil, str, global_channel)
        end
    end
end

function OnPlayerScore(P)
    return Discord:OnPlayerScore(P)
end
function OnServerCommand(P, C, E, _)
    return Discord:OnServerCommand(P, C, E, _)
end
function DeathHandler(V, K, MID)
    return Discord:DeathHandler(V, K, MID)
end
function OnPlayerChat(P, M, T)
    return Discord:OnPlayerChat(P, M, T)
end
function OnTick()
    return Discord:GameUpdate()
end
function StatusChecker()
    return Discord:StatusChecker()
end

function OnScriptUnload()
    -- N/A
end

local function WriteLog(str)
    local file = io.open(settings.error_log, "a+")
    if (file) then
        file:write(str .. "\n")
        file:close()
    end
end

function OnError(Error)

    local log = {
        { os.date("[%H:%M:%S - %d/%m/%Y] | " .. server_name), true, 12 },
        { Error, false, 12 },
        { debug.traceback(), true, 12 },
        { "--------------------------------------------------------", true, 5 },
        { "Please report this error on github:", true, 7 },
        { "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", true, 7 },
        { "Script Version: " .. Discord.version, true, 7 },
        { "--------------------------------------------------------", true, 5 }
    }

    for _, v in pairs(log) do
        WriteLog(v[1])
        if (v[2]) then
            cprint(v[1], v[3])
        end
    end

    WriteLog("\n")
end

function read_widestring(address, length)
    local count = 0
    local byte_table = {}
    for i = 1, length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return table.concat(byte_table)
end

return Discord
--[[
--=====================================================================================================--
Script Name: Divide & Conquer, for SAPP (PC & CE)
Description: When you kill someone on the opposing team, the victim is switched to your team.
             The main objective is to dominate the opposing team.
             When the opposing team has no players left the game is over.

Copyright (c) 2023, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

--- config starts --
local delay = 5
local required_players = 3
local prefix = '**SAPP**'
--- config ends --

local game
local winner
local clock = os.clock
local floor = math.floor
local players, timer = {}, {}
local death_message_address
local original_death_message_address

function timer:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function timer:start()
    self.start_time = clock()
    self.paused_time = 0
    self.paused = false
end

function timer:stop()
    self.start_time = nil
    self.paused_time = 0
    self.paused = false
end

function timer:get()
    if (self.start_time) then
        if (self.paused) then
            return self.paused_time - self.start_time
        else
            return clock() - self.start_time
        end
    end
    return 0
end

function OnScriptLoad()

    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDeath')

    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnTeamSwitch')

    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')

    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    OnStart()

    death_message_address = sig_scan("8B42348A8C28D500000084C9") + 3
    original_death_message_address = read_dword(death_message_address)
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        players = {}
        winner, game = nil, nil

        execute_command('sv_tk_ban 0')
        execute_command('sv_friendly_fire 0')

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

local function cls(id)
    for _ = 1, 25 do
        rprint(id, ' ')
    end
end

local function say(message, tick)

    if (tick) then
        for i, _ in pairs(players) do
            cls(i)
            rprint(i, message)
        end
        return
    end

    execute_command('msg_prefix ""')
    say_all(message)
    execute_command('msg_prefix "' .. prefix .. '"')
end

function OnEnd()

    if (winner) then
        say('Game Over! Winner: ' .. winner .. ' team')
    end

    winner, game = nil, nil
end

local function timeRemaining()
    return floor(delay - game:get())
end

local function disableDeathMessages()
    safe_write(true)
    write_dword(death_message_address, 0x03EB01B1)
    safe_write(false)
end

local function enableDeathMessages()
    safe_write(true)
    write_dword(death_message_address, original_death_message_address)
    safe_write(false)
end

function OnTick()

    if (not game or game.started) then
        return
    end

    if (game:get() >= delay) then

        game:stop()
        game.started = true

        disableDeathMessages()
        execute_command('sv_map_reset')
        enableDeathMessages()

        say('Game Start!', true)

    else
        say('Game will start in ' .. timeRemaining() .. ' seconds!', true)
    end
end

local function getTeamCounts()

    local reds, blues = 0, 0

    for _, v in pairs(players) do
        reds = (v.team == 'red') and reds + 1 or reds
        blues = (v.team == 'blue') and blues + 1 or blues
    end

    return reds, blues
end

local function endGame()

    local reds, blues = getTeamCounts()
    if (reds == 0 or blues == 0) then

        winner = (reds == 0) and 'Blue' or 'Red'
        execute_command('sv_map_next')
    end
end

local function gameCheck(quit)

    local count = tonumber(get_var(0, '$pn'))
    count = (quit and count - 1) or count

    if (count >= required_players) then
        if (not game) then
            game = timer:new()
            game:start()
        end
    elseif (game and game.started) then
        endGame()
    else
        game = nil
    end
end

function OnJoin(id)
    players[id] = {
        id = id,
        team = get_var(id, '$team')
    }
    gameCheck()
end

function OnQuit(id)
    players[id] = nil
    gameCheck(true)
end

local function blueScore()
    return tonumber(get_var(0, '$bluescore'))
end

local function redScore()
    return tonumber(get_var(0, '$redscore'))
end

local function switchTeam(player, team)
    execute_command('st ' .. player.id .. ' ' .. team)
    execute_command('team_score ' .. team .. ' ' .. (team == 'red' and redScore() - 1 or blueScore() - 1))
end

function OnDeath(victim, killer, meta_id)

    if (not game or not game.started) then
        return
    end

    victim = tonumber(victim)
    killer = tonumber(killer)

    if (killer == 0 or killer == -1 or killer == nil) then
        return
    end

    killer = players[killer]
    victim = players[victim]

    if (meta_id and killer.team == victim.team) then
        return false
    end

    if (killer.team == 'red') then
        switchTeam(victim, 'red')
    elseif (killer.team == 'blue') then
        switchTeam(victim, 'blue')
    end

    endGame()
end

function OnTeamSwitch(id)
    players[id].team = get_var(id, '$team')
end

function OnScriptUnload()
    -- N/A
end
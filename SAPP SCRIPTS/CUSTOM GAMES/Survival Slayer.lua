--[[
--=====================================================================================================--
Script Name: Survival Slayer, for SAPP (PC & CE)
Description: All players spawn with a limited life cycle.
             Each kill rewards 10 bonus seconds towards your life.
             First player to 15 kills wins.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local SurvivalSlayer = {

    ------------------------
    -- config starts:
    ------------------------

    -- Players will have this much time to live (in seconds):
    -- Default: 45
    --
    life_time = 45,

    -- Seconds to add when you kill someone:
    -- Default: 10
    --
    death_bonus = 10,

    -- Number of kills someone needs to win:
    -- Default 15
    --
    kills_to_win = 15

    ------------------------
    -- config ends:
    ------------------------
}

local players = {}
local game_started
local time_scale = 1 / 30

local floor = math.floor
local format = string.format

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], 'onDeath')
    register_callback(cb['EVENT_TICK'], 'onTick')
    register_callback(cb['EVENT_JOIN'], 'onJoin')
    register_callback(cb['EVENT_LEAVE'], 'onQuit')
    register_callback(cb['EVENT_SPAWN'], 'onSpawn')
    register_callback(cb['EVENT_GAME_END'], 'onEnd')
    register_callback(cb['EVENT_GAME_START'], 'onStart')
    onStart()
end

function SurvivalSlayer:newPlayer(o)
    setmetatable(o, { __index = self })
    self.__index = self
    return o
end

function onStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        players = {}
        game_started = true
        execute_command('scorelimit ' .. SurvivalSlayer.kills_to_win)
        for i = 1, 16 do
            if player_present(i) then
                onJoin(i)
            end
        end
    end
end

function onEnd()
    game_started = false
end

function onJoin(Ply)
    players[Ply] = SurvivalSlayer:newPlayer({
        name = get_var(Ply, '$name')
    })
end

function onQuit(Ply)
    players[Ply] = nil
end

function onSpawn(Ply)
    local p = players[Ply]
    if (p) then
        p.life = p.life_time
    end
end

local function say(Ply, Msg)
    for _ = 1, 25 do
        rprint(Ply, ' ')
    end
    rprint(Ply, Msg)
end

function onTick()

    if (not game_started) then
        return
    end

    for i, v in pairs(players) do
        if (player_alive(i) and v.life) then
            v.life = v.life - time_scale
            if (v.life <= 0) then
                v.life = nil
                execute_command('kill ' .. i)
            else
                say(i, format('%s: %s', v.name, floor(v.life)))
            end
        end
    end
end

function onDeath(Victim, Killer)
    local killer = tonumber(Killer)
    local victim = tonumber(Victim)

    local k = players[killer]
    local v = players[victim]

    local pvp = (killer > 0 and killer ~= victim and k and v)
    if (pvp) then
        k.life = k.life + k.death_bonus
    end
end

function OnScriptUnload()
    -- N/A
end
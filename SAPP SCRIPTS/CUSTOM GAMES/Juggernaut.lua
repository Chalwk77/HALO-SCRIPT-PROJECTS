--[[
--=====================================================================================================--
Script Name: Juggernaut, for SAPP (PC & CE)
Description: Juggernauts are very powerful players that have special attributes.

             Attributes:
             - Health boost
             - Speed boost
             - Shield boost
             - Damage boost
             - Regenerating health

             At the beginning of the game, a random player will be selected as the Juggernaut.
             When the Juggernaut dies, the next player in the queue will be selected as the Juggernaut.

             They have a set amount of time to kill as many players as possible.
             When the timer runs out, a random player in the queue will be selected as the Juggernaut.

             * Compatible with all game types.

Copyright (c) 2019-2023, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

--- config starts --
local Juggernaut = {

    -- Minimum number of players required to start the game:
    -- (default: 2)
    --
    required_players = 2,

    -- Time (in seconds) before the game starts:
    -- (default: 5)
    --
    delay = 5,

    -- Juggernaut turn time (in seconds):
    -- (default: 120)
    --
    turn_time = 10,

    -- A message relay function temporarily removes the 'msg_prefix'.
    -- This is the prefix that will be restored after the message is sent:
    --
    prefix = '**SAPP**',

    -- Special attributes for the Juggernaut:
    --
    attributes = {

        -----------------------------
        -- Health boost:
        health_boost = true,

        -- (default: 10)
        -- 1 = 100% health
        health_percentage = 10,
        -----------------------------


        -----------------------------
        -- Speed boost:
        speed = true,

        -- (default: 1.5)
        -- 1 = 100% speed
        speed_percentage = 1.5,
        -----------------------------


        -----------------------------
        -- Shield boost:
        shield = true,

        -- (default: 10)
        -- 1 = 100% shields
        shield_percentage = 10,
        -----------------------------


        -----------------------------
        -- Damage boost:
        damage = true,

        -- (default: 10)
        -- 1 = 100% damage
        damage_percentage = 10,
        -----------------------------


        -----------------------------
        -- Regenerating health:
        health_regen = true,

        -- (default: 0.0005)
        -- 0.0005 = 0.05% health per 30 ticks (1 second)
        health_increment = 0.0005,
    }
}
--- config ends --

api_version = '1.12.0.0'

local game
local clock = os.clock
local floor = math.floor
local players, timer = {}, {}

local death_message_address
local post_game_carnage_report
local original_death_message_address

function OnScriptLoad()

    death_message_address = sig_scan("8B42348A8C28D500000084C9") + 3
    original_death_message_address = read_dword(death_message_address)

    register_callback(cb['EVENT_DIE'], 'onDeath')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'onDeath')

    register_callback(cb['EVENT_TICK'], 'onTick')

    register_callback(cb['EVENT_JOIN'], 'onJoin')
    register_callback(cb['EVENT_LEAVE'], 'onQuit')

    register_callback(cb['EVENT_GAME_END'], 'onEnd')
    register_callback(cb['EVENT_GAME_START'], 'onStart')

    register_callback(cb['EVENT_SPAWN'], 'onSpawn')

    onStart()
end

function timer:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function timer:start()
    self.start_time = clock()
end

function timer:stop()
    self.start_time = nil
end

function timer:get()
    return (self.start_time and clock() - self.start_time) or 0
end

function Juggernaut:newPlayer(o)

    setmetatable(o, self)
    self.__index = self

    self:gameCheck()

    return o
end

-- These attributes are set every tick:
function Juggernaut:setDynamicAttributes(dyn)

    local attributes = self.attributes

    if (attributes.health_regen) then
        self:regenHealth(dyn)
    end
    if (attributes.speed) then
        execute_command('s ' .. self.id .. ' ' .. attributes.speed_percentage)
    end
end

-- These attributes are set once per game:
function Juggernaut:setStaticAttributes()

    local attributes = self.attributes

    if (attributes.shield) then
        execute_command('sh ' .. self.id .. ' ' .. attributes.shield_percentage)
    end
    if (attributes.health_boost) then
        execute_command('hp ' .. self.id .. ' ' .. attributes.health_percentage)
    end
end

function Juggernaut:regenHealth(dyn)
    local attributes = self.attributes
    local health = read_float(dyn + 0xE0)
    if (health < 1) then
        write_float(dyn + 0xE0, health + attributes.health_increment)
    end
end

function Juggernaut:multiplyDamage(damage)
    local attributes = self.attributes
    if (not self.juggernaut or not attributes.damage) then
        return true, damage
    end
    return true, damage * attributes.damage_percentage
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
    execute_command('msg_prefix "' .. Juggernaut.prefix .. '"')
end

local function setRandomJuggernaut()

    local index = math.random(1, #players)
    local player = players[index]

    if (player) then
        player:setJuggernaut()
    end
end

function Juggernaut:setJuggernaut()
    self.juggernaut = timer:new()
    self.juggernaut:start()
    self:setStaticAttributes()
    say(self.name .. ' is the Juggernaut!')
end

function Juggernaut:gameCheck(quit)

    if (post_game_carnage_report) then
        return
    end

    local count = tonumber(get_var(0, '$pn'))
    count = (quit and count - 1) or count

    if (count >= self.required_players and not game) then
        game = timer:new()
        game:start()
    elseif (game and not game.started) then
        game = nil
    end
end

function onStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        game = nil
        post_game_carnage_report = false

        for i = 1, 16 do
            if player_present(i) then
                onJoin(i)
            end
        end
    end
end

function onEnd()
    game = nil
    post_game_carnage_report = true
end

local function timeRemaining(delay)
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

local function silentKill(id)
    disableDeathMessages()
    execute_command('kill ' .. id)
    enableDeathMessages()

    local deaths = tonumber(get_var(0, '$deaths'))
    deaths = (deaths - 1 == 0 and 0 or deaths - 1)

    execute_command('deaths ' .. id .. ' ' .. deaths)
end

function onTick()

    math.randomseed(os.time())
    if (not game or game.started) then
        for i, v in pairs(players) do
            local dyn = get_dynamic_player(i)
            if (v.juggernaut and dyn ~= 0) then
                v:setDynamicAttributes(dyn)

                local turn_time = v.turn_time
                if (v.juggernaut:get() >= turn_time) then
                    v.juggernaut = nil
                    setRandomJuggernaut()
                    say(v.name .. ' is no longer the Juggernaut!')
                    silentKill(i)
                end
            end
        end
        return
    end

    if (game:get() >= Juggernaut.delay) then
        game:stop()
        game.started = true

        disableDeathMessages()
        execute_command('sv_map_reset')
        enableDeathMessages()

        setRandomJuggernaut()
    else
        local delay = Juggernaut.delay
        say('Game will start in ' .. timeRemaining(delay) .. ' seconds!', true)
    end
end

function onJoin(id)
    players[id] = Juggernaut:newPlayer({
        id = id,
        name = get_var(id, '$name')
    })
end

function onQuit(id)
    players[id] = nil
    Juggernaut:gameCheck(true)
end

function onSpawn(id)
    execute_command('s ' .. id .. ' 1') -- reset speed
end

function onDeath(victim, killer, meta_id, damage)

    if (not game or not game.started) then
        goto next
    end

    victim = tonumber(victim)
    killer = tonumber(killer)

    if (killer == 0 or killer == -1 or killer == nil) then
        goto next
    end

    victim = players[victim]
    killer = players[killer]

    if (meta_id) then


        return killer:multiplyDamage(damage)
    end

    local pvp = (killer.id ~= victim.id)

    -- suicide:
    if (not pvp) then

        killer.juggernaut = nil
        setRandomJuggernaut()

        -- player killed the juggernaut
    elseif (pvp and victim.juggernaut) then
        victim.juggernaut = nil
        killer:setJuggernaut()
    end

    :: next ::
end

function OnScriptUnload()
    -- N/A
end
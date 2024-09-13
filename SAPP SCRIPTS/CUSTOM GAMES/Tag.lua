--[[
--=====================================================================================================--
Script Name: Tag, for SAPP (PC & CE)
Description: Tag, you're it!

This is a game involving two or more players.
An initial game of tag is started by whacking a player.
This player will become 'it' (the tagger).
Their turn ends when they tag their first victim or their turn time is up;
If the turn time lapses before they tag someone, a new random player will be chosen to be the new tagger.

** FEATURES **

- All runners have plasma rifles and the taggers have an oddball.
  The plasma rifle was a design choice, not a random decision, as it slows down the tagger when shot at.

- You will accumulate 5 points every 10 seconds as a runner.
- The score limit is 10,000.
- Taggers get a 1.5x speed boost, runners have normal speed.
- Tagging someone earns you 500 points.
- Runners cannot earn points for killing.

- This game mode is best played on medium & small maps:
  timberland      bloodgulch      damnation   longest
  chillout        carousel        ratrace     putput
  prisoner        wizard          beavercreek hangemhigh

Copyright (c) 2022-2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Configuration table for the Tag game mode
local Tag = {
    score_limit = 10000,
    points_on_tag = 500,
    runner_points = 5,
    points_interval = 10,
    turn_time = 60,
    players_required = 2,
    speed = { tagger = 1.5, runner = 1 },
    on_tag = {
        "Tag, you're it! ($name got you)",
        '$name was tagged by $tagger'
    },
    random_tagger = '$name is now the tagger!',
    new_tagger_on_quit = true,
    new_tagger_on_death = false,
    server_prefix = '**SAPP**'
}

local players = {}
local game_over = false
local tagger = nil
local tagger_weapon_meta_id
local runner_weapon_meta_id
local tagger_weapon
local runner_weapon

local objects = {
    'weapons\\frag grenade\\frag grenade',
    'weapons\\plasma grenade\\plasma grenade',
    'vehicles\\ghost\\ghost_mp',
    'vehicles\\rwarthog\\rwarthog',
    'vehicles\\banshee\\banshee_mp',
    'vehicles\\warthog\\mp_warthog',
    'vehicles\\scorpion\\scorpion_mp',
    'vehicles\\c gun turret\\c gun turret_mp',
    'weapons\\ball\\ball',
    'weapons\\flag\\flag',
    'weapons\\pistol\\pistol',
    'weapons\\shotgun\\shotgun',
    'weapons\\needler\\mp_needler',
    'weapons\\flamethrower\\flamethrower',
    'weapons\\plasma rifle\\plasma rifle',
    'weapons\\sniper rifle\\sniper rifle',
    'weapons\\plasma pistol\\plasma pistol',
    'weapons\\plasma_cannon\\plasma_cannon',
    'weapons\\assault rifle\\assault rifle',
    'weapons\\rocket launcher\\rocket launcher'
}

local function getTag(class, name)
    local tag = lookup_tag(class, name)
    return (tag ~= 0 and read_dword(tag + 0xC)) or nil
end

local function broadcast(msg, pm)
    execute_command('msg_prefix ""')
    if not pm then
        say_all(msg)
    else
        say(pm, msg)
    end
    execute_command('msg_prefix "' .. Tag.server_prefix .. '"')
end

local function disableObjects(state)
    state = (state and 'enable_object') or 'disable_object'
    for _, object in ipairs(objects) do
        execute_command(state .. ' "' .. object .. '" 0')
    end
end

local function enoughPlayers(quit)
    local n = tonumber(get_var(0, '$pn'))
    n = (quit and n - 1 or n)
    return (n >= Tag.players_required)
end

local function pickRandomPlayer(quit)

    if not enoughPlayers(quit) then
        tagger = nil
        broadcast('Game of tag has ended. Not enough players.')
        return
    end

    local candidates = {}
    for i in pairs(players) do
        if player_present(i) and i ~= tagger then
            candidates[#candidates + 1] = i
        end
    end

    if #candidates > 0 then
        local new_tagger = candidates[math.random(#candidates)]
        players[new_tagger]:setTagger()
    end
end

local Player = {}
Player.__index = Player

function Player:new(id)
    local self = setmetatable({}, Player)
    self.id = id
    self.name = get_var(id, '$name')
    self.assign = true
    self.drone = ''
    self.killer = 0
    self.periodic_scoring = false
    return self
end

function Player:isTagger()
    return self.id == tagger
end

function Player:setSpeed()
    execute_command('s ' .. self.id .. ' ' .. Tag.speed.tagger)
    for i, _ in pairs(players) do
        if i ~= self.id then
            execute_command('s ' .. i .. ' ' .. Tag.speed.runner)
        end
    end
end

function Player:setTagger()

    tagger = self.id
    self.assign = true
    self.periodic_scoring = false
    self.turn_start = os.time()
    self.turn_finish = self.turn_start + Tag.turn_time
    self:setSpeed()

    local tag_message = Tag.on_tag[1]:gsub('$name', self.name)
    local runner_message = Tag.on_tag[2]:gsub('$name', self.name):gsub('$tagger', self.name)

    for i, player in pairs(players) do
        player:broadcast(i == tagger and tag_message or runner_message, true)
    end
end

function Player:broadcast(msg, pm)
    broadcast(msg, pm and self.id or nil)
end

function Player:assignWeapons()
    if self.assign then
        self.assign = false
        execute_command_sequence('nades ' .. self.id .. ' 0; wdel ' .. self.id)
        local weapon = self:isTagger() and tagger_weapon or runner_weapon
        self.drone = spawn_object('', '', 0, 0, -9999, 0, weapon)
        assign_weapon(self.drone, self.id)
    end
end

function Player:updateScore(deduct, runner_points)
    local score = tonumber(get_var(self.id, '$score'))
    if deduct then
        score = math.max(0, score - 1)
    else
        score = score + (runner_points and Tag.runner_points or Tag.points_on_tag)
    end
    execute_command('score ' .. self.id .. ' ' .. score)
end

function Player:deleteDrone(assign)
    destroy_object(self.drone)
    self.assign = assign
end

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_DIE'], 'OnDamage')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_WEAPON_DROP'], 'OnDrop')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDamage')
    OnStart()
end

function OnScriptUnload()
    disableObjects(true)
end

function OnStart()
    if get_var(0, '$gt') ~= 'n/a' then

        tagger_weapon_meta_id = getTag('jpt!', 'weapons\\ball\\melee')
        runner_weapon_meta_id = getTag('jpt!', 'weapons\\plasma rifle\\melee')
        tagger_weapon = getTag('weap', 'weapons\\ball\\ball')
        runner_weapon = getTag('weap', 'weapons\\plasma rifle\\plasma rifle')

        game_over = false
        players = {}
        tagger = nil
        disableObjects(false)

        execute_command('scorelimit ' .. Tag.score_limit)
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnEnd()
    game_over = true
end

function OnTick()

    for i, player in pairs(players) do
        if game_over or not player_present(i) or not player_alive(i) then
            goto continue
        end

        player:assignWeapons()
        execute_command('battery ' .. i .. ' 100')

        if player:isTagger() and os.time() >= player.turn_finish then
            pickRandomPlayer()
        elseif player.periodic_scoring and os.time() >= player.runner_finish then
            player.runner_start = os.time()
            player.runner_finish = player.runner_start + Tag.points_interval
            player:updateScore(false, true)
        end

        :: continue ::
    end
end

function OnJoin(id)
    players[id] = Player:new(id)
end

function OnSpawn(id)
    local player = players[id]
    player.assign = true
    player.killer = 0

    if player:isTagger() then
        player:setSpeed()
    elseif tagger then
        player.periodic_scoring = true
        player.runner_start = os.time()
        player.runner_finish = player.runner_start + Tag.points_interval
    end
end

function OnQuit(id)
    local player = players[id]
    if not game_over and Tag.new_tagger_on_quit and player:isTagger() then
        pickRandomPlayer(true)
    end
    player:deleteDrone()
    players[id] = nil
end

function OnDamage(victim, killer, meta_id)

    killer, victim = tonumber(killer), tonumber(victim)
    local k, v = players[killer], players[victim]

    if not game_over and killer > 0 and k and v and enoughPlayers() then
        if meta_id then
            if tagger and not (k:isTagger() or v:isTagger()) then
                return false
            end
            local case1 = not tagger and meta_id == runner_weapon_meta_id or k:isTagger()
            local case2 = tagger and meta_id == tagger_weapon_meta_id
            if killer ~= victim and (case1 or case2) then
                k.assign = true
                v.killer = killer
                k:updateScore()
                v:setTagger(k.name)
            end
            return
        end
        v:deleteDrone()
        k:updateScore(true)
        if Tag.new_tagger_on_death and v:isTagger() and v.killer ~= killer then
            pickRandomPlayer()
        end
    end
end

function OnDrop(id)
    players[id]:deleteDrone(true)
end

api_version = '1.12.0.0'
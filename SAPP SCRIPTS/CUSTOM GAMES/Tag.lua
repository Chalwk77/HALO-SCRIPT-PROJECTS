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

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts:
local Tag = {

    -- Game score limit:
    -- Default: 10000
    score_limit = 10000,


    -- Points awarded for tagging someone:
    -- Default: 500
    points_on_tag = 500,


    -- Runners will accumulate 5 points every 10 seconds while a game of tag is in play:
    -- Defaults: 5 & 10
    runner_points = 5,
    points_interval = 10,


    -- Tag turn timer (in seconds):
    -- Default: 60
    turn_time = 60,


    -- Min players required to start a game of tag:
    -- Default: 2
    players_required = 2,


    -- Running speed (tagger & runner):
    -- Defaults: 1.5, & 1
    speed = { 1.5, 1 },


    -- Messages sent when someone is tagged:
    on_tag = {
        "Tag, you're it! ($name got you)", -- tagger sees this message.
        '$name was tagged by $tagger' -- everyone else will see this message.
    },


    -- Message sent when someone's turn is up and we select a new random tagger:
    -- Same message appears if the tagger quits and
    -- 'new_tagger_on_quit' or 'new_tagger_on_death' is set to true.
    random_tagger = '$name is now the tagger!',


    -- When a tagger quits, should we select a new random tagger?
    -- Default: true
    new_tagger_on_quit = true,


    -- Should we pick a new tagger if the current tagger dies?
    -- Default: false
    new_tagger_on_death = false,


    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished:
    server_prefix = '**SAPP**'
}
-- config ends

local players = {}
local time = os.time
local tagger, game_over
local tagger_weapon_meta_id
local runner_weapon_meta_id
local tagger_weapon, runner_weapon

-- Object interaction with these tags will be disabled:
local objects = {

    -- allow interaction with these objects:
    --'powerups\\health pack',
    --'powerups\\over shield',
    --'powerups\\active camouflage',

    -- block interaction with these objects:
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

-- New Player has joined:
-- * Creates a new player table; Inherits the Tag parent object.
-- @Param o (player table [table])
-- @Return o (player table [table])
function Tag:newPlayer(o)

    setmetatable(o, self) -- inherit the .__index of Tag.
    self.__index = self

    -- Variable for weapon assignments:
    o.assign = true

    -- Holds the object id of the players weapon:
    o.drone = ''

    -- Stores the id of the person who just killed you:
    o.killer = 0

    return o
end

-- Returns true if this player is the tagger:
function Tag:isTagger()
    return (self.pid == tagger)
end

-- Sets running speed of all players:
-- @Param last_man (id of the last person online):
function Tag:setSpeed(last_man)
    execute_command('s ' .. self.pid .. ' ' .. self.speed[1])
    for i, v in pairs(players) do
        if (i ~= self.pid or i == last_man) then
            execute_command('s ' .. i .. ' ' .. v.speed[2])
        end
    end
end

local function setPeriodicTimers()
    for i, v in pairs(players) do
        if (i == tagger) then
            v.periodic_scoring = false

            -- only do this if it's not already set:
        elseif (not v.periodic_scoring) then
            v:newRunnerTime()
        end
    end
end

-- Sets the tagger:
-- @Param name (string) name of the tagger to set.
function Tag:setTagger(name)

    tagger = self.pid
    self.assign = true
    self.periodic_scoring = false

    self:newTurnTime()
    self:setSpeed()

    setPeriodicTimers()

    if (name) then

        local t_msg = self.on_tag[1]
        local to_tagger = t_msg:gsub('$name', name)

        local r_msg = self.on_tag[2]
        local to_runner = r_msg:gsub('$name', self.name):gsub('$tagger', name)

        for i, v in pairs(players) do
            if (i == tagger) then
                v:broadcast(to_tagger, true)
            else
                v:broadcast(to_runner, true)
            end
        end
        return
    end

    local msg = self.random_tagger
    msg = msg:gsub('$name', self.name)
    self:broadcast(msg)
end

-- Resets turn timer variables:
function Tag:newTurnTime()
    self.turn_start = time
    self.turn_finish = time() + self.turn_time
end

-- Timer variables used to periodically update runner score:
function Tag:newRunnerTime()
    self.periodic_scoring = true
    self.runner_start = time
    self.runner_finish = time() + self.points_interval
end

-- Function responsible for handling scoring:
function Tag:updateScore(Deduct, RunnerPoints)
    local score = tonumber(get_var(self.pid, '$score'))

    -- prevent player from scoring from last kill:
    if (Deduct) then
        score = (score - 1 < 0 and 0 or score - 1)
    elseif (not RunnerPoints) then
        score = score + self.points_on_tag -- update tagger points
    else
        score = score + self.runner_points -- update runner points
    end

    execute_command('score ' .. self.pid .. ' ' .. score)
end

-- Binds nav marker to tagger:
function Tag:setNav()
    local player = get_player(self.pid)
    if (tagger and self.pid ~= tagger) then
        write_word(player + 0x88, to_real_index(tagger))
    else
        write_word(player + 0x88, to_real_index(self.pid))
    end
end

-- Returns the MetaID of the tag address:
-- @Param Type (tag class)
-- @Param Name (tag path)
-- @Return tag address [number]
local function getTag(class, name)
    local tag = lookup_tag(class, name)
    return (tag ~= 0 and read_dword(tag + 0xC)) or nil
end

-- Sends a server-wide message:
-- * Temporarily removes the server prefix.
-- @Params msg (message string)
function Tag:broadcast(msg, pm)
    execute_command('msg_prefix ""')
    if (not pm) then
        say_all(msg)
    else
        say(self.pid, msg)
    end
    execute_command('msg_prefix  "' .. self.server_prefix .. '"')
end

-- Destroy the players weapon:
-- @Param Assign [boolean], true if we need to trigger weapon a assignment.
function Tag:deleteDrone(assign)
    destroy_object(self.drone)
    self.assign = assign
end

-- Weapon assignment logic:
function Tag:assignWeapons()

    -- Assign appropriate weapons:
    if (self.assign) then
        self.assign = false

        execute_command_sequence('nades ' .. self.pid .. ' 0; wdel ' .. self.pid)

        local weapon = (tagger == self.pid and tagger_weapon or runner_weapon)

        self.drone = spawn_object('', '', 0, 0, -9999, 0, weapon)
        assign_weapon(self.drone, self.pid)
    end
end

-- Determines if enough players are online for a game of tag:
-- @Param quit [boolean], true if we need to deduct 1 from n:
-- SAPP var $pn does not update immediately after a player quits,
-- so we have to deduct one manually.
function Tag:enoughPlayers(quit)
    local n = tonumber(get_var(0, '$pn'))
    n = (quit and n - 1 or n)
    return (n >= self.players_required)
end

-- Picks a random player to become the tagger.
-- Excludes the previous tagger.
-- @Param quit (boolean), true if we need to deduct 1 from n in enoughPlayers().
function Tag:pickRandomPlayer(quit)

    if not self:enoughPlayers(quit) then
        tagger = nil
        self:setSpeed(self.pid)
        self:broadcast('Game of tag has ended. Not enough players.')
        return
    end

    -- Trigger weapon assignment for previous tagger:
    self.assign = true

    -- set candidates:
    local t = {}
    for i,_ in pairs(players) do
        if (player_present(i) and i ~= tagger) then
            t[#t + 1] = i
        end
    end

    -- Pick and set new tagger from t{}:
    if (#t > 0) then
        players[t[rand(1, #t + 1)]]:setTagger()
    end
end

-- Disables interaction with game objects (on start).
-- Enables interaction when OnScriptUnload() is called.
local function GameObjects(state)
    state = (state and 'enable_object') or 'disable_object'
    for i = 1, #objects do
        execute_command(state .. ' "' .. objects[i] .. '" 0')
    end
end

-- Called when a new game has started:
function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        tagger_weapon_meta_id = getTag('jpt!', 'weapons\\ball\\melee')
        runner_weapon_meta_id = getTag('jpt!', 'weapons\\plasma rifle\\melee')

        tagger_weapon = getTag('weap', 'weapons\\ball\\ball')
        runner_weapon = getTag('weap', 'weapons\\plasma rifle\\plasma rifle')

        -- set up game tables:
        game_over = false
        players, tagger = {}, nil

        -- disable game objects:
        GameObjects(false)

        -- Set the score limit:
        execute_command('scorelimit ' .. Tag.score_limit)

        -- Init player tables (happens if the script is loaded during a match):
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

-- Called when the game has ended:
function OnEnd()
    game_over = true
end

-- Called every 1/30th second:
function OnTick()
    for i, v in pairs(players) do

        if (not game_over and player_present(i) and player_alive(i)) then

            v:setNav()
            v:assignWeapons()

            execute_command('battery ' .. i .. ' 100')

            if (v:isTagger() and v.turn_start() >= v.turn_finish) then
                v:pickRandomPlayer()

                -- Update runner score periodically:
            elseif (v.periodic_scoring and v.runner_start() >= v.runner_finish) then
                v:newRunnerTime()
                v:updateScore(false, true) -- update runner points
            end
        end
    end
end

-- Called when a player receives damage or is killed:
-- @Param Victim (victim id) [number]
-- @Param Causer (killer id) [number]
-- @Param MetaID (DamageTagID) [number]
function OnDamage(Victim, Causer, MetaID)

    local killer = tonumber(Causer)
    local victim = tonumber(Victim)

    local k = players[killer]
    local v = players[victim]

    if (not game_over and killer > 0 and k and v and k:enoughPlayers()) then

        --
        -- event_damage_application:
        --
        if (MetaID) then

            -- Prevent runners from attacking each other:
            if (tagger and not k:isTagger() and not v:isTagger()) then
                return false
            end

            local case1 = (not tagger and MetaID == runner_weapon_meta_id or k:isTagger())
            local case2 = (tagger and MetaID == tagger_weapon_meta_id)

            if (killer ~= victim) and (case1 or case2) then

                k.assign = true -- trigger weapon assignment
                v.killer = killer -- keep track of the player who just killed you

                k:updateScore() -- update current tagger score
                k:newRunnerTime() -- reset periodic scoring for this player
                v:setTagger(k.name) -- make victim the tagger
            end
            return
        end

        --
        -- event_die:
        --

        v:deleteDrone() -- prevent weapon drop
        k:updateScore(true) -- prevent this kill from being counted towards score

        if (v.new_tagger_on_death and v:isTagger() and v.killer ~= killer) then
            v:pickRandomPlayer()
        end
    end
end

-- Called when a player has finished connecting:
-- @Param P (player id) [number]
function OnJoin(Ply)
    players[Ply] = Tag:newPlayer({
        pid = Ply,
        name = get_var(Ply, '$name')
    })
end

-- Called when a player has quit:
-- * Nullifies the table for this player.
-- @Param P (player id) [number]
function OnQuit(Ply)

    local t = players[Ply]

    -- Pick a random player to be the tagger:
    if (not game_over and t.new_tagger_on_quit and t:isTagger()) then
        t:pickRandomPlayer(true)
    end

    t:deleteDrone() -- delete their dropped weapon

    players[Ply] = nil
end

-- Called when a player has finished respawning:
-- @Param P (player id) [number]
-- Triggers weapon assignment
function OnSpawn(Ply)

    local t = players[Ply]
    t.assign = true
    t.killer = 0

    if (t:isTagger()) then
        t:setSpeed() -- just in case
    elseif (tagger) then
        t:newRunnerTime() -- only do this if a game of tag is in play:
    end
end

-- Called when a player drops a weapon.
-- Makes a call  to destroy their weapon.
function OnDrop(Ply)
    players[Ply]:deleteDrone(true)
end

-- Registers needed event callbacks for SAPP:
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
    GameObjects(true)
end

api_version = '1.12.0.0'
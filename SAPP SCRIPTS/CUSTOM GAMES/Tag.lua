--[[
--=====================================================================================================--
Script Name: Tag, for SAPP (PC & CE)
Description: Tag, you're it!

------------------
**** FEATURES ****
------------------
1). This is a game involving two or more players.
    A game of tag is initiated by whacking a player. This player will become 'it' (the tagger).

2). You will accumulate 5 points every 10 seconds as a runner.
    The score limit is 10,000 & taggers get a 1.5x speed boost.

3). Tagging someone earns you 100 points.
    Runners cannot earn points for killing.

4). Taggers will take turns being 'it', for a maximum of 60 seconds each.

5). Taggers can only use an oddball (skull).
    Runners can only use a plasma pistol.


    This game mode is best played on medium & small maps:
    timberland  bloodgulch  damnation  longest
    chillout  carousel  ratrace  putput  prisoner
    wizard  beavercreek  hangemhigh

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts:
local Tag = {

    -- Points awarded for tagging someone:
    -- Default: 100
    points_on_tag = 100,


    -- Tag turn timer (in seconds):
    -- Default: 60
    turn_time = 60,


    -- Min players required to start a game of tag:
    -- Default: 2
    players_required = 2,


    -- Messages sent when someone is tagged:
    on_tag = '$name was tagged by $tagger and is IT.',


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


    -- Game score limit:
    -- Default: 10000
    score_limit = 10000,


    -- Runners will accumulate 5 points every 10 seconds while a game of tag is in play:
    -- Defaults: 5 & 10
    runner_points = 5,
    runner_time = 10,


    -- Weapon assignments [tagger/runners]
    weapons = {
        'weapons\\ball\\ball', -- tagger weapon
        'weapons\\plasma rifle\\plasma rifle' -- runner weapon
    },


    -- Players can be tagged by any of these weapons:
    -- Set to 'false' to disable.
    melee_tags = {
        ['weapons\\flag\\melee'] = true,
        ['weapons\\ball\\melee'] = true,
        ['weapons\\pistol\\melee'] = true,
        ['weapons\\needler\\melee'] = true,
        ['weapons\\shotgun\\melee'] = true,
        ['weapons\\flamethrower\\melee'] = true,
        ['weapons\\sniper rifle\\melee'] = true,
        ['weapons\\plasma rifle\\melee'] = true,
        ['weapons\\plasma pistol\\melee'] = true,
        ['weapons\\assault rifle\\melee'] = true,
        ['weapons\\rocket launcher\\melee'] = true,
        ['weapons\\plasma_cannon\\effects\\plasma_cannon_melee'] = true
    },


    -- Running speed (tagger & runner):
    -- Defaults: 1.5, & 1
    speed = { 1.5, 1 },


    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished:
    server_prefix = '**SAPP**',


    -- Disable object interaction:
    -- Set to false to allow interaction.
    -- Note: Do not disable the runner object.
    --
    objects = {

        -- equipment:
        ['powerups\\health pack'] = false,
        ['powerups\\over shield'] = false,
        ['powerups\\active camouflage'] = false,
        ['weapons\\frag grenade\\frag grenade'] = true,
        ['weapons\\plasma grenade\\plasma grenade'] = true,

        -- vehicles:
        ['vehicles\\ghost\\ghost_mp'] = true,
        ['vehicles\\rwarthog\\rwarthog'] = true,
        ['vehicles\\banshee\\banshee_mp'] = true,
        ['vehicles\\warthog\\mp_warthog'] = true,
        ['vehicles\\scorpion\\scorpion_mp'] = true,
        ['vehicles\\c gun turret\\c gun turret_mp'] = true,

        -- weapons:
        ['weapons\\ball\\ball'] = true,
        ['weapons\\flag\\flag'] = true,
        ['weapons\\pistol\\pistol'] = true,
        ['weapons\\shotgun\\shotgun'] = true,
        ['weapons\\needler\\mp_needler'] = true,
        ['weapons\\flamethrower\\flamethrower'] = true,
        ['weapons\\plasma rifle\\plasma rifle'] = false, -- runner object
        ['weapons\\sniper rifle\\sniper rifle'] = true,
        ['weapons\\plasma pistol\\plasma pistol'] = true,
        ['weapons\\plasma_cannon\\plasma_cannon'] = true,
        ['weapons\\assault rifle\\assault rifle'] = true,
        ['weapons\\rocket launcher\\rocket launcher'] = true
    }
}
-- config ends

local tagger
local game_over
local players = {}
local time = os.time

-- New Player has joined:
-- * Creates a new player table; Inherits the Tag parent object.
-- @Param o (player table [table])
-- @Return o (player table [table])
function Tag:NewPlayer(o)

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
function Tag:IsTagger()
    return (self.pid == tagger)
end

-- Returns true of the player's last damage meta matches a melee tag address:
function Tag:MeleeAttack(MetaID)
    return self.tags[MetaID]
end

-- Sets running speed of all players:
-- @Param last_man (id of the last person online):
function Tag:SetSpeed(last_man)
    execute_command('s ' .. self.pid .. ' ' .. self.speed[1])
    for i, v in pairs(players) do
        if (i ~= self.pid or i == last_man) then
            execute_command('s ' .. i .. ' ' .. v.speed[2])
        end
    end
end

-- Sets the tagger:
-- @Param TaggerName (name of the person who just tagged someone) [string]
function Tag:SetTagger(TaggerName)

    self.assign, tagger = true, self.pid

    self:NewTurnTime()
    self:SetSpeed()

    local msg = self.on_tag
    if (TaggerName) then
        msg = msg:gsub('$tagger', TaggerName)
    else
        msg = self.random_tagger
    end
    msg = msg:gsub('$name', self.name)

    self:Broadcast(msg)
end

function Tag:NewTurnTime()
    self.turn_start = time
    self.turn_finish = time() + self.turn_time
end

function Tag:NewRunnerTime()
    self.runner_start = time
    self.runner_finish = time() + self.runner_time
end

-- Function responsible for handling scoring:
function Tag:UpdateScore(Deduct, RunnerPoints)
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
function Tag:SetNav()
    local player = get_player(self.pid)
    if (player and player_alive(self.pid)) then
        if (tagger and self.pid ~= tagger) then
            write_word(player + 0x88, to_real_index(tagger))
        else
            write_word(player + 0x88, to_real_index(self.pid))
        end
    end
end

-- Returns the MetaID of the tag address:
-- @Param Type (tag class)
-- @Param Name (tag path)
-- @Return tag address [number]
local function GetTag(Type, Name)
    local ObjTag = lookup_tag(Type, Name)
    return (ObjTag ~= 0 and read_dword(ObjTag + 0xC)) or nil
end

-- Converts the tag class/name to their respective tag address ids:
-- Makes it easier to check if a players last damage meta id matches
-- the tag address id from the melee_tags table.
function Tag:TagsToID()
    local t = {}
    for tag, enabled in pairs(self.melee_tags) do
        if (enabled) then
            local id = GetTag('jpt!', tag) -- get tag address id
            t[id] = true
        end
    end
    self.tags = t
end

-- Sends a server-wide message:
-- * Temporarily removes the server prefix.
function Tag:Broadcast(msg)
    execute_command('msg_prefix ""')
    say_all(msg)
    execute_command('msg_prefix  "' .. self.server_prefix .. '"')
end

-- Destroys the players weapon:
function Tag:DeleteDrone(Assign)
    destroy_object(self.drone)
    self.assign = Assign
end

function Tag:AssignWeapons()
    if (self.assign) then
        self.assign = false
        execute_command_sequence('nades ' .. self.pid .. ' 0; wdel ' .. self.pid)
        local weapon = (tagger == self.pid and self.weapons[1]) or self.weapons[2]
        self.drone = spawn_object('weap', weapon, 0, 0, -9999)
        assign_weapon(self.drone, self.pid)
    end
end

function Tag:EnoughPlayers(quit)
    local n = tonumber(get_var(0, "$pn"))
    n = (quit and n - 1 or n)
    return (n >= self.players_required)
end

function Tag:PickRandomTagger(quit)

    if not self:EnoughPlayers(quit) then
        tagger = nil
        self:SetSpeed(self.pid)
        self:Broadcast('Game of tag has ended. Not enough players.')
        return
    end

    -- set candidates:
    local t = {}
    for i = 1, #players do
        if (player_present(i) and i ~= tagger) then
            t[#t + 1] = i
        end
    end

    if (#t > 0) then
        players[t[rand(1, #t + 1)]]:SetTagger()
    end
end

-- Disables interaction with game objects (on start).
-- Enables interaction when OnScriptUnload() is called.
local function GameObjects(state)
    state = (state and 'enable_object') or 'disable_object'
    for k, v in pairs(Tag.objects) do
        if (v) then
            execute_command(state .. ' "' .. k .. '" 0')
        end
    end
end

-- Called when a new game has started:
function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        Tag:TagsToID()
        game_over = false
        players, tagger = {}, nil

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

function OnEnd()
    game_over = true
end

-- Called every 1/30th second:
function OnTick()
    for i, v in pairs(players) do

        if (not game_over and player_alive(i)) then

            v:AssignWeapons()
            v:SetNav()

            if (v:IsTagger() and v.turn_start() >= v.turn_finish) then
                v:PickRandomTagger()
                v.assign = true

                -- Update runner score periodically:
            elseif (tagger and v.runner_start and v.runner_start() >= v.runner_finish) then
                v:NewRunnerTime()
                v:UpdateScore(false, true) -- update runner points
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

    if (not game_over and killer > 0 and k and v and Tag:EnoughPlayers()) then

        --
        -- event_damage_application:
        --
        if (MetaID) then

            if (killer ~= victim) and (not tagger or k:IsTagger()) and k:MeleeAttack(MetaID) then

                k.assign = true -- trigger weapon assignment
                k:UpdateScore() -- update current tagger score
                k:NewRunnerTime() -- reset runner timer
                v:SetTagger(k.name) -- make victim the tagger

                v.killer = killer -- keep track of the player who just killed you
            end
            return
        end

        --
        -- event_die:
        --

        v.runner_start = nil -- just in case
        v:DeleteDrone() -- prevent weapon drop
        k:UpdateScore(true) -- prevent this kill from being counted towards score

        if (v.new_tagger_on_death and v:IsTagger() and v.killer ~= killer) then
            v:PickRandomTagger()
        end
    end
end

-- Called when a player has finished connecting:
-- @Param P (player id) [number]
function OnJoin(Ply)
    players[Ply] = Tag:NewPlayer({
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
    if (not game_over) then
        if (t.new_tagger_on_quit and t:IsTagger()) then
            t:PickRandomTagger(true)
        end
    end

    t:DeleteDrone() -- delete their dropped weapon

    players[Ply] = nil
end

-- Called when a player has finished respawning:
-- @Param P (player id) [number]
-- Triggers weapon assignment
function OnSpawn(Ply)

    local t = players[Ply]
    t.assign = true
    t.killer = 0

    if (t:IsTagger()) then
        t:SetSpeed() -- just in case
    elseif (tagger) then
        t:NewRunnerTime() -- only do this if a game of tag is in play:
    end
end

-- Called when a player drops a weapon.
-- Makes a call  to destroy their weapon.
function OnDrop(Ply)
    players[Ply]:DeleteDrone(true)
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
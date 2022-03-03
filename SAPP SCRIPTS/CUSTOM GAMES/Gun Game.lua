--[[
--=====================================================================================================--
Script Name: Gun Game (v1.2), for SAPP (PC & CE)
Description: A simple progression based game inspired by COD's Gun Game.
             Every kill rewards the player with a new weapon.
             The first player to reach the last weapon with 10 kills wins.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

local GunGame = {

    -- Game messages:
    messages = {

        -- On level up:
        [1] = 'You are now level $level of 10',

        -- Announced to the whole server when player reaches max level:
        [2] = '$name is now max level',

        -- When someone wins:
        [3] = '$name won the game!'
    },

    -- Starting level:
    -- Default: 1
    --
    starting_level = 1,

    -- Should players have infinite ammo?
    -- Default: true
    --
    infinite_ammo = true,

    levels = {
        [1] = 'weapons\\rocket launcher\\rocket launcher',
        [2] = 'weapons\\plasma_cannon\\plasma_cannon',
        [3] = 'weapons\\sniper rifle\\sniper rifle',
        [4] = 'weapons\\shotgun\\shotgun',
        [5] = 'weapons\\pistol\\pistol',
        [6] = 'weapons\\assault rifle\\assault rifle',
        [7] = 'weapons\\flamethrower\\flamethrower',
        [8] = 'weapons\\needler\\mp_needler',
        [9] = 'weapons\\plasma rifle\\plasma rifle',
        [10] = 'weapons\\plasma pistol\\plasma pistol',
    },

    --
    ------------------------------------------------------------
    -- [!] Do not touch unless you know what you're doing [!] --
    ------------------------------------------------------------
    -- To prevent a player from picking up specific weapons or
    -- entering specific vehicles, enter the tag address of that object here:
    --
    --
    objects = {

        'weapons\\assault rifle\\assault rifle',
        'weapons\\flamethrower\\flamethrower',
        'weapons\\needler\\mp_needler',
        'weapons\\pistol\\pistol',
        'weapons\\plasma pistol\\plasma pistol',
        'weapons\\plasma rifle\\plasma rifle',
        'weapons\\plasma_cannon\\plasma_cannon',
        'weapons\\rocket launcher\\rocket launcher',
        'weapons\\shotgun\\shotgun',
        'weapons\\sniper rifle\\sniper rifle',

        'weapons\\frag grenade\\frag grenade',
        'weapons\\plasma grenade\\plasma grenade',

        'vehicles\\ghost\\ghost_mp',
        'vehicles\\rwarthog\\rwarthog',
        'vehicles\\banshee\\banshee_mp',
        'vehicles\\warthog\\mp_warthog',
        'vehicles\\scorpion\\scorpion_mp',
        'vehicles\\c gun turret\\c gun turret_mp',

        --
        -- repeat the structure to add more entries
        --
    }
}

-- config ends --

api_version = "1.12.0.0"

local game_over
local players = {}

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

function GunGame:NewPlayer(t)
    setmetatable(t, self)
    t.__index = self
    t.level = self.starting_level
    return t
end

function GunGame:LevelUP()
    if (not game_over) then

        self.level = self.level + 1

        if (self.level == #self.levels) then
            say_all(self.messages[2]:gsub('$name', self.name))
        elseif (self.level > #self.levels) then
            execute_command('map_next')
            say_all(self.messages[3]:gsub('$name', self.name))
            return
        else
            say(self.pid, self.messages[1]:gsub('$level', self.level))
        end

        self.assign = true
    end
end

function GunGame:AssignWeapon()

    self.assign = false

    execute_command('wdel ' .. self.pid)
    execute_command('nades ' .. self.pid .. ' 0')

    local weapon_id = self.levels[self.level]
    local object = spawn_object('', '', 0, 0, 0, 0, weapon_id)

    assign_weapon(object, self.pid)
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

local function EnableDisableWeapons(state)
    state = (state and 'enable_object') or 'disable_object'
    for _, v in pairs(GunGame.objects) do
        execute_command(state .. " '" .. v .. "'")
    end
end

function OnStart()
    if (get_var(9, '$gt') ~= 'n/a') then

        -- # Prevent the game from ending too quickly:
        execute_command("scorelimit 9999")
        EnableDisableWeapons()

        players = {}
        game_over = false

        for i = 1, #GunGame.levels do
            GunGame.levels[i] = GetTag('weap', GunGame.levels[i])
        end

        for i = 1, #players do
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
    for i, v in pairs(players) do
        if (i and player_alive(i) and not game_over) then
            if (v.assign) then
                v:AssignWeapon()
            elseif (v.infinite_ammo) then
                execute_command_sequence('ammo ' .. i .. ' 999; battery ' .. i .. ' 100')
            end
        end
    end
end

function OnJoin(Ply)
    players[Ply] = GunGame:NewPlayer({
        pid = Ply,
        name = get_var(Ply, "$name")
    })
end

function OnQuit(Ply)
    players[Ply] = nil
end

function OnSpawn(Ply)
    if (players[Ply]) then
        players[Ply].assign = true
    end
end

function OnDeath(Victim, Killer)
    if (not game_over) then
        local victim = tonumber(Victim)
        local killer = tonumber(Killer)
        local k = players[killer]
        if (k and killer > 0 and killer ~= victim) then
            k:LevelUP()
        end
    end
end

function OnScriptUnload()
    EnableDisableWeapons(true)
end
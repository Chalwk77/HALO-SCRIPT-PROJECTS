--[[
--=====================================================================================================--
Script Name: Gun Game (v1.4), for SAPP (PC & CE)
Description: A simple progression based game inspired by Call of Duty's Gun Game mode.
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
        [1] = 'Level: $lvl/10 [$label]',

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


    -- Format:
    -- [level id] = {['WEAPON LABEL'] = {'weapon tag', nades, plasmas } },

    levels = {
        [1] = { ['Rocket Launcher'] = { 'weapons\\rocket launcher\\rocket launcher', 1, 1 } },
        [2] = { ['Plasma Cannon'] = { 'weapons\\plasma_cannon\\plasma_cannon', 1, 1 } },
        [3] = { ['Sniper Rifle'] = { 'weapons\\sniper rifle\\sniper rifle', 1, 1 } },
        [4] = { ['Shotgun'] = { 'weapons\\shotgun\\shotgun', 1, 0 } },
        [5] = { ['Pistol'] = { 'weapons\\pistol\\pistol', 1, 0 } },
        [6] = { ['Assault Rifle'] = { 'weapons\\assault rifle\\assault rifle', 1, 0 } },
        [7] = { ['Flamethrower'] = { 'weapons\\flamethrower\\flamethrower', 0, 1 } },
        [8] = { ['Needler'] = { 'weapons\\needler\\mp_needler', 0, 1 } },
        [9] = { ['Plasma Rifle'] = { 'weapons\\plasma rifle\\plasma rifle', 0, 1 } },
        [10] = { ['Plasma Pistol'] = { 'weapons\\plasma pistol\\plasma pistol', 0, 0 } },
    },


    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    server_prefix = "**SAPP**",
    --

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
    self.__index = self

    t.level = self.starting_level
    return t
end

function GunGame:LevelUP()
    if (not game_over) then

        self.level = self.level + 1

        execute_command("msg_prefix \"\"")
        if (self.level == #self.levels) then
            say_all(self.messages[2]:gsub('$name', self.name))
        elseif (self.level > #self.levels) then
            execute_command('map_next')
            say_all(self.messages[3]:gsub('$name', self.name))
            return
        end
        execute_command("msg_prefix \" " .. self.server_prefix .. "\"")
        self.assign = true
    end
end

function GunGame:AssignWeapon()

    self.assign = false

    execute_command('wdel ' .. self.pid)
    execute_command('nades ' .. self.pid .. ' 0')

    local weapon = self.levels[self.level]
    for Label, t in pairs(weapon) do

        if (t[2] > 0) then
            execute_command('nades ' .. self.pid .. ' ' .. t[2] .. ' 1')
        end
        if (t[3] > 0) then
            execute_command('nades ' .. self.pid .. ' ' .. t[3] .. ' 2')
        end

        local object = spawn_object('', '', 0, 0, 0, 0, t[1])
        assign_weapon(object, self.pid)

        local msg = self.messages[1]
        msg = msg:gsub('$lvl', self.level):gsub('$label', Label)

        execute_command("msg_prefix \"\"")
        say(self.pid, msg)
        execute_command("msg_prefix \" " .. self.server_prefix .. "\"")
    end
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
            for k, v in pairs(GunGame.levels[i]) do
                GunGame.levels[i][k][1] = GetTag('weap', v[1])
            end
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
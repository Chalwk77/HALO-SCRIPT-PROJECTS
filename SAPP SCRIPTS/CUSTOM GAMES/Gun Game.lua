--[[
--=====================================================================================================--
Script Name: Gun Game (v1.0), for SAPP (PC & CE)
Description: A simple progression based game inspired by COD's Gun Game.
             Every kill rewards the player with a new weapon.
             The first player to reach the last weapon with 10 kills wins.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local GunGame = {

    messages = {
        [1] = 'You are now level $level of 10',
        [2] = '$name is now max level',
        [3] = '$name won the game!'
    },

    starting_level = 1,

    levels = {
        [1] = 'weapons\\rocket launcher\\rocket launcher',
        [2] = 'weapons\\plasma_cannon\\plasma_cannon',
        [3] = 'weapons\\sniper rifle\\sniper rifle',
        [4] = 'weapons\\shotgun\\shotgun',
        [5] = 'weapons\\pistol\\pistol',
        [6] = 'weapons\\assault rifle\\assault rifle',
        [7] = 'weapons\\flamethrower\\flamethrower',
        [8] = 'weapons\\plasma rifle\\plasma rifle',
        [9] = 'weapons\\needler\\mp_needler',
        [10] = 'weapons\\plasma pistol\\plasma pistol',
    }
}

api_version = "1.12.0.0"

local players = {}

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

function GunGame:NewPlayer(t)
    setmetatable(t, self)
    self.__index = self
    self.level = self.starting_level
    return t
end

function GunGame:LevelUP()

    self.level = self.level + 1
    local name = self.name

    if (self.level == #self.levels) then
        say_all(self.messages[2]:gsub('$name', name))
    elseif (self.level > #self.levels) then
        execute_command('map_next')
        say_all(self.messages[3]:gsub('$name', name))
        return
    else
        say(self.pid, self.messages[1]:gsub('$level', self.level))
    end

    self.assign = true
end

function GunGame:AssignWeapon()
    self.assign = false
    execute_command('wdel ' .. self.pid)
    execute_command('nades ' .. self.pid .. ' 0')
    assign_weapon(spawn_object('', '', 0, 0, 0, 0, self.levels[self.level]), self.pid)
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function OnStart()
    if (get_var(9, '$gt') ~= 'n/a') then

        -- # Prevent the game from ending too quickly:
        execute_command("scorelimit 9999")

        -- # Disable interaction with vehicles:
        execute_command("disable_all_vehicles 0 1")

        -- # Disable interaction with weapons:
        execute_command("disable_object 'weapons\\assault rifle\\assault rifle'")
        execute_command("disable_object 'weapons\\flamethrower\\flamethrower'")
        execute_command("disable_object 'weapons\\needler\\mp_needler'")
        execute_command("disable_object 'weapons\\pistol\\pistol'")
        execute_command("disable_object 'weapons\\plasma pistol\\plasma pistol'")
        execute_command("disable_object 'weapons\\plasma rifle\\plasma rifle'")
        execute_command("disable_object 'weapons\\plasma_cannon\\plasma_cannon'")
        execute_command("disable_object 'weapons\\rocket launcher\\rocket launcher'")
        execute_command("disable_object 'weapons\\shotgun\\shotgun'")
        execute_command("disable_object 'weapons\\sniper rifle\\sniper rifle'")

        -- # Disable interaction with grenades:
        execute_command("disable_object 'weapons\\frag grenade\\frag grenade'")
        execute_command("disable_object 'weapons\\plasma grenade\\plasma grenade'")

        players = {}

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

function OnTick()
    for i, v in pairs(players) do
        if (i and player_alive(i) and v.assign) then
            v:AssignWeapon()
        end
    end
end

function OnJoin(Ply)
    players[Ply] = GunGame:NewPlayer({
        pid = Ply,
        name = get_var(Ply, "$name")
    })
end

function OnSpawn(Ply)
    if (players[Ply]) then
        players[Ply].assign = true
    end
end

function OnDeath(Victim, Killer)
    local victim = tonumber(Victim)
    local killer = tonumber(Killer)
    local k = players[killer]
    if (k and killer > 0 and killer ~= victim) then
        k:LevelUP()
    end
end

function OnScriptUnload()
    -- N/A
end
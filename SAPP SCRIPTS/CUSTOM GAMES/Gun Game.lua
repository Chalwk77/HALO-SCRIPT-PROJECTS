--[[
--=====================================================================================================--
Script Name: Simple Gun Game (v1.0), for SAPP (PC & CE)
Description: A simple progression based game similar to COD's Gun Game.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local GunGame = {

    level_up_message = 'You are now level $level of 10',

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

    if (self.level == #self.levels) then
        say_all(self.name .. ' is now max level')
    elseif (self.level > #self.levels) then
        execute_command('map_next')
        say_all(self.name .. ' won the game!')
        return
    else
        say(self.pid, self.level_up_message:gsub('$level', self.level))
    end

    self.assign = true
end

function GunGame:AssignWeapon()
    self.assign = false
    execute_command('wdel ' .. self.pid)
    local weapon = self.levels[self.level]
    assign_weapon(spawn_object('', '', 0, 0, 0, 0, weapon), self.pid)
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function OnStart()
    if (get_var(9, '$gt') ~= 'n/a') then

        players = {}

        for i = 1, #players do
            if player_present(i) then
                OnJoin(i)
            end
        end

        for i = 1, #GunGame.levels do
            GunGame.levels[i] = GetTag('weap', GunGame.levels[i])
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
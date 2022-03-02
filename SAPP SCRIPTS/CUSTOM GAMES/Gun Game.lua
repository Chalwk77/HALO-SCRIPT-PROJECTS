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

    starting_level = 1,

    levels = {
        [1] = {
            weapon = "weapons\\pistol\\pistol",
        },
        [2] = {
            weapon = "weapons\\assault rifle\\assault rifle",
        },
        [3] = {
            weapon = "weapons\\shotgun\\shotgun",
        },
        [4] = {
            weapon = "weapons\\sniper rifle\\sniper rifle",
        },
        [5] = {
            weapon = "weapons\\rocket launcher\\rocket launcher",
        },
        [6] = {
            weapon = "weapons\\plasma_cannon\\plasma_cannon",
        }
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
    if (self.level > #self.levels) then
        execute_command('map_next')
        say_all(self.name .. ' won the game!')
        return
    end
    self.assign = true
end

function GunGame:AssignWeapon()
    self.assign = false
    local lvl = self.level
    local weapon = self.levels[lvl].weapon
    assign_weapon(spawn_object('', '', 0, 0, 0, 0, weapon), self.pid)
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function OnStart()
    if (get_var(9, '$gt') ~= 'n/a') then
        for i = 1, #GunGame.levels do
            GunGame.levels[i].weapon = GetTag('weap', GunGame.levels[i].weapon)
        end
    end
end

function OnTick()
    for i, v in pairs(players) do
        if (i and player_alive(i) and v.assign) then
            execute_command('wdel ' .. i)
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
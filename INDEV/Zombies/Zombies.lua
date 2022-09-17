-- Zombies [Entry Point File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Zombies = {

    dependencies = {
        ['./Zombies/'] = { 'settings' },
        ['./Zombies/Dependencies/Commands/'] = {
            'Zombie',
            'Human'
        },
        ['./Zombies/Dependencies/Events/'] = {
            'Damage',
            'Death',
            'GameTick',
            'Join',
            'Quit'
        },
        ['./Zombies/Dependencies/Utils/'] = {
            'Game Phase',
            'Game Start',
            'Misc',
            'Random Zombie Picker',
            'Set Attributes',
            'Shuffle',
        }
    }
}

local function HasPermission(Ply, Lvl, Msg)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    return (Ply == 0 or lvl >= Lvl) or rprint(Ply, Msg) and false
end

-- Loads file dependencies:
-- All files inherit the parent Zombies object.
local cmds = {}
function Zombies:LoadDependencies()

    local s = self
    for path, t in pairs(self.dependencies) do
        for _, file in pairs(t) do
            local f = loadfile(path .. file .. '.lua')()
            local cmd = f.command_name
            if (cmd) then
                cmds[cmd] = f -- command file
                cmds[cmd].permission = HasPermission
                setmetatable(cmds[cmd], { __index = self })
            else
                setmetatable(s, { __index = f })
                s = f
            end
        end
    end
end

-- Returns the MetaID of a tag address:
-- @Param Type (tag class)
-- @Param Name (tag path)
-- @Return tag address [number]
local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

-- Called when a new game has started.
-- Loads dependency functions and sets up game tables.
function Zombies:OnStart()

    self.players = {}
    self.last_man = nil
    self.game_started = false
    self.block_death_messages = true

    self.fall_damage = GetTag('jpt!', 'globals\\falling')
    self.distance_damage = GetTag('jpt!', 'globals\\distance')

    -- Enable game objects:
    self:GameObjects(false)

    -- Pre game timer tables:
    self.timers = { ['NotEnoughPlayers'] = {}, ['PreGame'] = {}, ['NoZombies'] = {} }
end

------------------------------------------------------------
--- [ SAPP FUNCTIONS ] ---
------------------------------------------------------------

-- Called when a new game has started:
function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        Zombies:OnStart()
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

-- Called when the game has ended:
function OnEnd()
    Zombies.game_started = false
    Zombies:StartStopTimer()
end

-- Called when a player has finished connecting:
-- Creates a new player table for this player.
-- @Param P (player id) [number]
function OnJoin(P)

    local name = get_var(P, '$name')
    local team = get_var(P, '$team')
    local defaults = { id = P, team = team, name = name }

    Zombies.players[P] = Zombies:NewPlayer(defaults)
end

-- Called when a player has quit:
-- * Nullifies the table for this player.
-- @Param P (player id) [number]
function OnQuit(P)
    Zombies.players[P]:OnQuit()
end

-- Called when a player has died:
-- @Param V (victim id) [number]
-- @Param K (killer id) [number]
function OnDeath(V, K)
    Zombies:OnDeath(V, K)
end

-- Called when a player has switched teams:
-- @Param P (player id) [number]
function OnSwitch(P)
    local t = Zombies.players[P]
    if (t) then
        t.switching = true
        t.team = get_var(P, '$team')
    end
end

-- Called when a player has finished respawning:
-- * Sets player attributes.
-- @Param P (player id) [number]
function OnSpawn(P)
    local t = Zombies.players[P]
    if (t) then
        t.meta_id = 0
        if (t.game_started) then
            t.assign = true
            t:SetAttributes()
        end
    end
end

-- Called every 1/30th second:
function OnTick()
    Zombies:GameTick()
    Zombies:Timers()
end

-- Called when a player drops a weapon:
-- * Destroys the weapon object.
-- @Param P (player id) [number]
function OnDrop(P)
    local t = Zombies.players[P]
    if (t) then
        t:CleanUpDrones(true)
    end
end

-- Called when a player picks up a weapon:
-- * Removes its ammo.
-- @Param P (player id) [number]
function OnPickup(P)
    local t = Zombies.players[P]
    if (t) then
        t:RemoveAmmo(true)
    end
end

-- Called when a player receives damage:
-- * Prevents friendly fire and multipliers damage dealt.
-- @Param V (victim id) [number]
-- @Param K (killer id) [number]
-- @Param M (DamageTagID) [number]
-- @Param D (Damage Multiplier) [number]
function OnDamage(V, K, M, D)
    return Zombies:OnDamage(V, K, M, D)
end

local function StrSplit(str)
    local t = { }
    for arg in str:gmatch('([^%s]+)') do
        t[#t + 1] = arg
    end
    return t
end

-- Called when a player has executed a command:
-- * Executes custom command (/human, /zombie).
-- @Param P (player id) [number]
-- @Param CMD (command) [string]
function OnCommand(P, CMD)
    local args = StrSplit(CMD)
    return (cmds[args[1]] and cmds[args[1]]:Run(P, args))
end

local death_messages
local death_messages_patched

-- Enables Halo's default death messages:
local function EnableDeathMessages()
    safe_write(true)
    write_dword(death_messages_patched, death_messages)
    safe_write(false)
end

-- Disables Halo's default death messages:
local function DisableDeathMessages()
    death_messages_patched = sig_scan("8B42348A8C28D500000084C9") + 3
    death_messages = read_dword(death_messages_patched)
    safe_write(true)
    write_dword(death_messages_patched, 0x03EB01B1)
    safe_write(false)
end

-- Called when the script is loaded:
-- * Loads file dependencies and registers needed event callbacks.
function OnScriptLoad()

    Zombies:LoadDependencies()
    DisableDeathMessages()

    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_WEAPON_DROP'], 'OnDrop')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
    register_callback(cb['EVENT_WEAPON_PICKUP'], 'OnPickup')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDamage')

    OnStart()
end

-- Called when the script is unloaded.
-- * Resets the map and enables Halo's default death messages.
function OnScriptUnload()

    if (get_var(0, '$gt') ~= 'n/a') then
        execute_command('sv_map_reset')
    end

    EnableDeathMessages()
end

api_version = '1.12.0.0'
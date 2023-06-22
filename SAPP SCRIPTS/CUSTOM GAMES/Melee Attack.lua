--[[
--=====================================================================================================--
Script Name: Melee Attack, for SAPP (PC & CE)
Description: Players are limited to melee-only combat.
             Striking your opponent with the skull will kill them instantly.

Copyright (c) 2021-2023, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

--- config starts:

-- Game score limit:
-- Default (50)
local score_limit = 50

-- Respawn time (in seconds):
-- Default (0)
local respawn_time = 0

--- config ends

local oddball
local players, objects = {}, {}
local game_objects = {

    -- equipment:
    { 'eqip', 'powerups\\health pack' },
    { 'eqip', 'powerups\\over shield' },
    { 'eqip', 'powerups\\active camouflage' },
    { 'eqip', 'weapons\\frag grenade\\frag grenade' },
    { 'eqip', 'weapons\\plasma grenade\\plasma grenade' },

    -- vehicles:
    { 'vehi', 'vehicles\\ghost\\ghost_mp' },
    { 'vehi', 'vehicles\\rwarthog\\rwarthog' },
    { 'vehi', 'vehicles\\banshee\\banshee_mp' },
    { 'vehi', 'vehicles\\warthog\\mp_warthog' },
    { 'vehi', 'vehicles\\scorpion\\scorpion_mp' },
    { 'vehi', 'vehicles\\c gun turret\\c gun turret_mp' },

    -- weapons:
    { 'weap', 'weapons\\flag\\flag' },
    { 'weap', 'weapons\\pistol\\pistol' },
    { 'weap', 'weapons\\shotgun\\shotgun' },
    { 'weap', 'weapons\\needler\\mp_needler' },
    { 'weap', 'weapons\\flamethrower\\flamethrower' },
    { 'weap', 'weapons\\plasma rifle\\plasma rifle' },
    { 'weap', 'weapons\\sniper rifle\\sniper rifle' },
    { 'weap', 'weapons\\plasma pistol\\plasma pistol' },
    { 'weap', 'weapons\\plasma_cannon\\plasma_cannon' },
    { 'weap', 'weapons\\assault rifle\\assault rifle' },
    { 'weap', 'weapons\\rocket launcher\\rocket launcher' }
}

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'onTick')
    register_callback(cb['EVENT_JOIN'], 'onJoin')
    register_callback(cb['EVENT_LEAVE'], 'onQuit')
    register_callback(cb['EVENT_SPAWN'], 'onSpawn')
    register_callback(cb['EVENT_GAME_START'], 'onStart')
    register_callback(cb['EVENT_WEAPON_DROP'], 'onWeaponDrop')
    register_callback(cb['EVENT_OBJECT_SPAWN'], 'onObjectSpawn')
    onStart()
end

local function getTag(class, name)
    local tag = lookup_tag(class, name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

local function tagsToID()

    local t = {}
    for i = 1, #game_objects do
        local class, name = game_objects[i][1], game_objects[i][2]
        local tag = getTag(class, name)
        if (tag) then
            t[tag] = i
        end
    end

    return t
end

function onStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        execute_command('scorelimit ' .. score_limit)

        oddball = getTag('weap', 'weapons\\ball\\ball')
        objects = tagsToID()

        for i = 1, 16 do
            if player_present(i) then
                onJoin(i)
            end
        end
    end
end

local function deleteDrones(id)
    local player = players[id]
    if (player) then
        for i = 1, #player.drones do
            destroy_object(player.drones[i])
        end
        player.drones = {}
    end
end

function onJoin(id)
    players[id] = {
        assign = false,
        drones = {}
    }
end

function onQuit(id)
    deleteDrones(id)
    players[id] = nil
end

function onSpawn(id)
    players[id].assign = true
end

function onTick()
    for i, v in pairs(players) do
        if (v.assign) then
            local dyn = get_dynamic_player(i)
            if (dyn ~= 0 and player_alive(i)) then
                v.assign = false

                execute_command('wdel ' .. i)

                local weapon = spawn_object('', '', 0, 0, -9999, 0, oddball)
                v.drones[#v.drones + 1] = weapon

                assign_weapon(weapon, i)
            end
        end
    end
end

function onWeaponDrop(id)
    deleteDrones(id)
    players[id].assign = true
end

function onDeath(victim, killer)

    victim = tonumber(victim)

    if (killer == 0 or killer == -1 or killer == nil) then
        return
    end

    deleteDrones(victim)

    local player = get_player(victim)
    if (player ~= 0) then
        write_dword(player + 0x2C, respawn_time * 33)
    end
end

function onObjectSpawn(_, map_id)
    if (objects[map_id]) then
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
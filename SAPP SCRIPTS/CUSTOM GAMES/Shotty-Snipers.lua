--[[
--=====================================================================================================--
Script Name: Shotty-Snipes, for SAPP (PC & CE)
Description: Players spawn with a shotgun & sniper.
             Other weapons & vehicles do not spawn.
             You can use equipment (i.e, grenades & powerups).

             This script is plug-and-play. No configuration!

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

local objects = {

    --{'weap', 'weapons\\shotgun\\shotgun'},
    --{'weap', 'weapons\\sniper rifle\\sniper rifle'},

    { 'weap', 'weapons\\pistol\\pistol' },
    { 'weap', 'weapons\\needler\\mp_needler' },
    { 'weap', 'weapons\\flamethrower\\flamethrower' },
    { 'weap', 'weapons\\plasma rifle\\plasma rifle' },
    { 'weap', 'weapons\\plasma_cannon\\plasma_cannon' },
    { 'weap', 'weapons\\assault rifle\\assault rifle' },
    { 'weap', 'weapons\\plasma pistol\\plasma pistol' },
    { 'weap', 'weapons\\rocket launcher\\rocket launcher' },

    --{ 'eqip', 'powerups\\health pack' },
    --{ 'eqip', 'powerups\\over shield' },
    --{ 'eqip', 'powerups\\active camouflage' },
    --{ 'eqip', 'weapons\\frag grenade\\frag grenade' },
    --{ 'eqip', 'weapons\\plasma grenade\\plasma grenade' },

    { 'vehi', 'vehicles\\ghost\\ghost_mp' },
    { 'vehi', 'vehicles\\rwarthog\\rwarthog' },
    { 'vehi', 'vehicles\\banshee\\banshee_mp' },
    { 'vehi', 'vehicles\\warthog\\mp_warthog' },
    { 'vehi', 'vehicles\\scorpion\\scorpion_mp' },
    { 'vehi', 'vehicles\\c gun turret\\c gun turret_mp' }
}

local players = {}
local shotgun, sniper

function OnScriptLoad()

    register_callback(cb['EVENT_ALIVE'], 'Alive')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_OBJECT_SPAWN'], 'OnObjectSpawn')

    OnStart()
end

local function GetTag(Class, Name)
    local Tag = lookup_tag(Class, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        shotgun = GetTag('weap', 'weapons\\shotgun\\shotgun')
        sniper = GetTag('weap', 'weapons\\sniper rifle\\sniper rifle')
    end
end

function Alive(p)
    execute_command_sequence('ammo ' .. p .. ' 999 5; mag ' .. p .. ' 999 5')
end

function OnTick()
    for i, v in pairs(players) do
        if (player_alive(i) and v.assign and shotgun and sniper) then
            v.assign = false

            execute_command('wdel ' .. i)
            assign_weapon(spawn_object('', '', 0, 0, 0, 0, sniper), i)
            assign_weapon(spawn_object('', '', 0, 0, 0, 0, shotgun), i)

            -- Force ammo to update immediately:
            -- Redundancy here is necessary.
            execute_command_sequence('ammo ' .. i .. ' 999 5; mag ' .. i .. ' 999 5')
        end
    end
end

function OnJoin(p)
    players[p] = { assign = false }
end

function OnQuit(p)
    players[p] = nil
end

function OnSpawn(p)
    if (players[p]) then
        players[p].assign = true
    end
end

function OnObjectSpawn(Ply, MID)
    if (Ply == 0) then
        for _, v in pairs(objects) do
            if (MID == GetTag(v[1], v[2])) then
                return false
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end
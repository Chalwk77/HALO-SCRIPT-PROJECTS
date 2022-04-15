--[[
--=====================================================================================================--
Script Name: Shotty-Snipes, for SAPP (PC & CE)
Description: Players spawn with a shotgun & sniper
             Other weapons & vehicles do not spawn.
             You can use equipment (i.e, grenades & powerups).

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

-- Objects set to false will not spawn.

local map_objects = {

    ['weap'] = {

        ['weapons\\shotgun\\shotgun'] = true,
        ['weapons\\sniper rifle\\sniper rifle'] = true,

        ['weapons\\flag\\flag'] = true,
        ['weapons\\ball\\ball'] = true,

        ['weapons\\pistol\\pistol'] = false,
        ['weapons\\needler\\mp_needler'] = false,
        ['weapons\\flamethrower\\flamethrower'] = false,
        ['weapons\\plasma rifle\\plasma rifle'] = false,
        ['weapons\\plasma_cannon\\plasma_cannon'] = false,
        ['weapons\\assault rifle\\assault rifle'] = false,
        ['weapons\\plasma pistol\\plasma pistol'] = false,
        ['weapons\\rocket launcher\\rocket launcher'] = false
    },

    ['eqip'] = {
        ['powerups\\health pack'] = true,
        ['powerups\\over shield'] = true,
        ['powerups\\active camouflage'] = true,
        ['weapons\\frag grenade\\frag grenade'] = true,
        ['weapons\\plasma grenade\\plasma grenade'] = true
    },

    ['vehi'] = {
        ['vehicles\\ghost\\ghost_mp'] = false,
        ['vehicles\\rwarthog\\rwarthog'] = false,
        ['vehicles\\banshee\\banshee_mp'] = false,
        ['vehicles\\warthog\\mp_warthog'] = false,
        ['vehicles\\scorpion\\scorpion_mp'] = false,
        ['vehicles\\c gun turret\\c gun turret_mp'] = false
    }
}

local shotgun, sniper
local players, objects = {}, {}

function OnScriptLoad()

    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_TICK'], 'OnTick')
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

        shotgun, sniper = nil, nil

        local t = {}
        for Class, v in pairs(map_objects) do
            for Name, Enabled in pairs(v) do
                local Tag = GetTag(Class, Name)
                if (Tag) then
                    t[Tag] = Enabled
                    shotgun = (Name == 'weapons\\shotgun\\shotgun' and Tag or shotgun)
                    sniper = (Name == 'weapons\\sniper rifle\\sniper rifle' and Tag or sniper)
                end
            end
        end

        objects = t
    end
end

function OnTick()
    for i, v in pairs(players) do
        if player_alive(i) then
            execute_command_sequence('ammo ' .. i .. ' 999; mag ' .. i .. ' 999')
            if (v.assign and shotgun and sniper) then
                v.assign = false
                execute_command('wdel ' .. i)
                assign_weapon(spawn_object('', '', 0, 0, 0, 0, sniper), i)
                assign_weapon(spawn_object('', '', 0, 0, 0, 0, shotgun), i)
            end
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

function OnObjectSpawn(_, MID, _, _)
    return objects[MID]
end

function OnScriptUnload()
    -- N/A
end
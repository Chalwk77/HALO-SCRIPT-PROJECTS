--[[
--=====================================================================================================--
Script Name: Shotty-Snipes, for SAPP (PC & CE)
Description: Players spawn with a shotgun and sniper.

             Other weapons & vehicles do not spawn.
             You can use equipment (i.e, grenades & powerups).

             This script is plug-and-play. No configuration!

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

local tags = {

    -------------------
    -- config starts --
    -------------------

    -----------------------------------------------------------------------------
    -- E Q U I P M E N T:

    -- Equipment objects are enabled by default and will spawn.
    -- Remove the double hyphen on the relevant line to prevent it from spawning.
    --
    --{ 'eqip', 'powerups\\health pack' },
    --{ 'eqip', 'powerups\\over shield' },
    --{ 'eqip', 'powerups\\active camouflage' },
    --{ 'eqip', 'weapons\\frag grenade\\frag grenade' },
    --{ 'eqip', 'weapons\\plasma grenade\\plasma grenade' },
    -----------------------------------------------------------------------------


    -----------------------------------------------------------------------------
    -- W E A P O N S:

    -- Weapon objects are blocked by default and will not spawn.
    -- Prefix the relevant line with a double hyphen to allow spawning.
    --

    -- Do not remove the double hyphen from these two lines,
    -- as they are the weapons you will spawn with:
    --{ 'weap', 'weapons\\shotgun\\shotgun' },
    --{ 'weap', 'weapons\\sniper rifle\\sniper rifle' },
    --
    { 'weap', 'weapons\\pistol\\pistol' },
    { 'weap', 'weapons\\needler\\mp_needler' },
    { 'weap', 'weapons\\flamethrower\\flamethrower' },
    { 'weap', 'weapons\\plasma rifle\\plasma rifle' },
    { 'weap', 'weapons\\plasma_cannon\\plasma_cannon' },
    { 'weap', 'weapons\\assault rifle\\assault rifle' },
    { 'weap', 'weapons\\plasma pistol\\plasma pistol' },
    { 'weap', 'weapons\\rocket launcher\\rocket launcher' },

    -----------------------------------------------------------------------------
    -- V E H I C L E S:

    -- Vehicle objects are blocked by default and will not spawn.
    -- Prefix the relevant line with a double hyphen to allow spawning.
    --
    { 'vehi', 'vehicles\\ghost\\ghost_mp' },
    { 'vehi', 'vehicles\\rwarthog\\rwarthog' },
    { 'vehi', 'vehicles\\banshee\\banshee_mp' },
    { 'vehi', 'vehicles\\warthog\\mp_warthog' },
    { 'vehi', 'vehicles\\scorpion\\scorpion_mp' },
    { 'vehi', 'vehicles\\c gun turret\\c gun turret_mp' }

    -----------------
    -- config ends --
    -----------------
}

-- Do not touch anything below this point, unless you know what you're doing!

local objects = {}
local players = {}
local shotgun, sniper

function OnScriptLoad()

    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_ALIVE'], 'UpdateAmmo')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_OBJECT_SPAWN'], 'OnObjectSpawn')

    OnStart()
end

local function GetTag(Class, Name)
    local Tag = lookup_tag(Class, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

local function TagsToID()

    local t = {}
    for i = 1, #tags do
        local class, name = tags[i][1], tags[i][2]
        local meta_id = GetTag(class, name)
        t[meta_id] = (meta_id and true) or nil
    end

    objects = t
end

function OnStart()

    if (get_var(0, '$gt') ~= 'n/a') then

        objects, players = {}, {}
        TagsToID()

        sniper = GetTag('weap', 'weapons\\sniper rifle\\sniper rifle')
        shotgun = GetTag('weap', 'weapons\\shotgun\\shotgun')

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnTick()
    for i = 1, #players do
        local assign = players[i]
        if (player_alive(i) and assign and shotgun and sniper) then

            players[i] = false
            execute_command('wdel ' .. i)

            assign_weapon(spawn_object('', '', 0, 0, 0, 0, sniper), i)
            assign_weapon(spawn_object('', '', 0, 0, 0, 0, shotgun), i)

            UpdateAmmo(i)
        end
    end
end

function OnJoin(p)
    players[p] = false
end

function OnSpawn(p)
    players[p] = true
end

function OnQuit(p)
    players[p] = nil
end

function UpdateAmmo(p)
    execute_command_sequence('ammo ' .. p .. ' 999 5; mag ' .. p .. ' 999 5')
end

function OnObjectSpawn(Ply, MID)
    if (Ply == 0 and objects[MID]) then
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
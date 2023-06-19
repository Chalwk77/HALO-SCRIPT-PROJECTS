--[[
--=====================================================================================================--
Script Name: Shotty-Snipes, for SAPP (PC & CE)
Description: Players are limited to the use of shotguns & snipers.

             * Other weapons & vehicles do not spawn.
             * You can use equipment (i.e, grenades & powerups).
             * Optional infinite ammo and bottomless clip

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

    -- Set to false to disable infinite ammo:
    --
    infinite_ammo = true,

    -- Set to false to disable bottomless clip:
    --
    bottomless_clip = true,

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

    register_callback(cb['EVENT_JOIN'], 'onJoin')
    register_callback(cb['EVENT_TICK'], 'onTick')
    register_callback(cb['EVENT_LEAVE'], 'onQuit')
    register_callback(cb['EVENT_SPAWN'], 'onSpawn')
    register_callback(cb['EVENT_ALIVE'], 'updateAmmo')
    register_callback(cb['EVENT_GAME_START'], 'onStart')
    register_callback(cb['EVENT_OBJECT_SPAWN'], 'onObjectSpawn')

    onStart()
end

local function getTag(class, name)
    local tag = lookup_tag(class, name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

local function tagsToID()

    local t = {}
    for i = 1, #tags do
        local class, name = tags[i][1], tags[i][2]
        local meta_id = getTag(class, name)
        t[meta_id] = (meta_id and true) or nil
    end

    objects = t
end

function onStart()

    if (get_var(0, '$gt') ~= 'n/a') then

        objects, players = {}, {}
        tagsToID()

        sniper = getTag('weap', 'weapons\\sniper rifle\\sniper rifle')
        shotgun = getTag('weap', 'weapons\\shotgun\\shotgun')

        for i = 1, 16 do
            if player_present(i) then
                onJoin(i)
            end
        end
    end
end

function onTick()
    for i,assign in pairs(players) do
        if (player_alive(i) and assign and shotgun and sniper) then

            players[i] = false
            execute_command('wdel ' .. i)

            assign_weapon(spawn_object('', '', 0, 0, 0, 0, sniper), i)
            assign_weapon(spawn_object('', '', 0, 0, 0, 0, shotgun), i)

            updateAmmo(i)
        end
    end
end

function onJoin(id)
    players[id] = false
end

function onSpawn(id)
    players[id] = true
end

function onQuit(id)
    players[id] = nil
end

function updateAmmo(id)
    if (tags.infinite_ammo) then
        execute_command('ammo ' .. id .. ' 999 5')
    end
    if (tags.bottomless_clip) then
        execute_command('mag ' .. id .. ' 999 5')
    end
end

function onObjectSpawn(id, meta_id)
    if (id == 0 and objects[meta_id]) then
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
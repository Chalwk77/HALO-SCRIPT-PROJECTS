--[[
--=====================================================================================================--
Script Name: One In The Chamber, for SAPP (PC & CE)
Description: Each player is given a pistol - and only a pistol - with one bullet.
             Use it wisely. Every shot kills.
             If you miss, you're limited to Melee-Combat.
             Every time you kill a player, you get a bullet.
             Success requires a combination of precision and reflexes. Know when to go for the shot or close in for the kill.

Copyright (c) 2023, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

--====================================== --
-- Configuration [STARTS]
--====================================== --

local OITC = {

    -- Loaded Ammo (clip):
    starting_primary_ammo = 1,

    -- Unloaded Ammo: (Mag):
    starting_secondary_ammo = 0,

    -- Bullets given per kill:
    ammo_per_kill = 1,

    -- Starting Grenades:
    starting_frags = 0,
    starting_plasmas = 0,

    -- Primary Weapon:
    weapon = 'weapons\\pistol\\pistol',

    -- Miscellaneous Settings:
    disable_vehicles = true,
    disable_weapon_pickups = true,
    disable_grenade_pickups = true,
    --===========================================--

    -- DAMAGE MULTIPLIERS | STOCK TAGS --
    -- {tag name, multiplier }
    -- 1 = normal damage

    multipliers = {

        -- melee damage:
        ['weapons\\assault rifle\\melee'] = 1.50,
        ['weapons\\ball\\melee'] = 1.50,
        ['weapons\\flag\\melee'] = 1.50,
        ['weapons\\flamethrower\\melee'] = 1.50,
        ['weapons\\needler\\melee'] = 1.50,
        ['weapons\\pistol\\melee'] = 1.50,
        ['weapons\\plasma pistol\\melee'] = 1.50,
        ['weapons\\plasma rifle\\melee'] = 1.50,
        ['weapons\\rocket launcher\\melee'] = 1.50,
        ['weapons\\shotgun\\melee'] = 1.50,
        ['weapons\\sniper rifle\\melee'] = 1.50,
        ['weapons\\plasma_cannon\\effects\\plasma_cannon_melee'] = 1.50,

        -- grenade damage:
        ['weapons\\frag grenade\\explosion'] = 1.00,
        ['weapons\\plasma grenade\\explosion'] = 1.50,
        ['weapons\\plasma grenade\\attached'] = 10.0,

        -- vehicle damage:
        ['vehicles\\ghost\\ghost bolt'] = 1.015,
        ['vehicles\\scorpion\\bullet'] = 1.020,
        ['vehicles\\warthog\\bullet'] = 1.025,
        ['vehicles\\c gun turret\\mp bolt'] = 1.030,
        ['vehicles\\banshee\\banshee bolt'] = 1.035,
        ['vehicles\\scorpion\\shell explosion'] = 1.00,
        ['vehicles\\banshee\\mp_fuel rod explosion'] = 1.00,

        -- projectile damage:
        ['weapons\\pistol\\bullet'] = 10.0,
        ['weapons\\plasma rifle\\bolt'] = 10.0,
        ['weapons\\shotgun\\pellet'] = 10.0,
        ['weapons\\plasma pistol\\bolt'] = 10.0,
        ['weapons\\needler\\explosion'] = 10.0,
        ['weapons\\assault rifle\\bullet'] = 10.0,
        ['weapons\\needler\\impact damage'] = 10.0,
        ['weapons\\flamethrower\\explosion'] = 10.0,
        ['weapons\\sniper rifle\\sniper bullet'] = 10.0,
        ['weapons\\rocket launcher\\explosion'] = 10.0,
        ['weapons\\needler\\detonation damage'] = 10.0,
        ['weapons\\plasma rifle\\charged bolt'] = 10.0,
        ['weapons\\plasma_cannon\\effects\\plasma_cannon_melee'] = 10.0,
        ['weapons\\plasma_cannon\\effects\\plasma_cannon_explosion'] = 10.0,

        -- vehicle collision damage:
        ['globals\\vehicle_collision'] = 1.00,

        -- fall damage:
        ['globals\\falling'] = 1.00,
        ['globals\\distance'] = 1.00,
    }
}
--====================================== --
-- Configuration [ENDS]
--====================================== --

local multipliers = {}

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return (Tag ~= 0 and read_dword(Tag + 0xC)) or nil
end

local function TagsToID()

    local t = {}
    for tag, multiplier in pairs(OITC.multipliers) do
        t[GetTag('jpt!', tag)] = multiplier
    end

    multipliers = t
end

function OnStart()
    if (get_var(0, "$gt") ~= "n/a") then

        TagsToID()
        OITC.players = { }
        OITC.game_over = false
        OITC.weap = GetTag('weap', OITC.weapon)

        if (OITC.weap) then

            for i = 1, 16 do
                if player_present(i) then
                    OITC.players[i] = false
                end
            end

            -- Disable all vehicles
            if (OITC.disable_vehicles) then
                execute_command("disable_all_vehicles 0 1")
            end

            -- Disable weapon pick ups:
            if (OITC.disable_weapon_pickups) then
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
            end

            -- Disable grenade pick ups:
            if (OITC.disable_grenade_pickups) then
                execute_command("disable_object 'weapons\\frag grenade\\frag grenade'")
                execute_command("disable_object 'weapons\\plasma grenade\\plasma grenade'")
            end

            register_callback(cb['EVENT_DIE'], "OnKill")
            register_callback(cb["EVENT_TICK"], "OnTick")
            register_callback(cb["EVENT_LEAVE"], "OnQuit")
            register_callback(cb["EVENT_SPAWN"], "OnSpawn")
            register_callback(cb["EVENT_GAME_END"], "OnEnd")
            register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamage")
            return
        end

        unregister_callback(cb['EVENT_DIE'])
        unregister_callback(cb["EVENT_TICK"])
        unregister_callback(cb["EVENT_SPAWN"])
        unregister_callback(cb["EVENT_LEAVE"])
        unregister_callback(cb["EVENT_GAME_END"])
        unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])
    end
end

function OnEnd()
    OITC.game_over = true
end

local function setAmmo(Ply, Type, Amount)
    for i = 1, 4 do
        if (Type == 'unloaded') then
            execute_command('ammo ' .. Ply .. ' ' .. Amount .. ' ' .. i)
        elseif (Type == "loaded") then
            execute_command('mag ' .. Ply .. ' ' .. Amount .. ' ' .. i)
        end
    end
end

function OnTick()
    if (not OITC.game_over) then
        for i, assign in pairs(OITC.players) do
            if player_alive(i) and (assign) then

                OITC.players[i] = false
                execute_command('wdel ' .. i)
                assign_weapon(spawn_object('', '', 0, 0, 0, 0, OITC.weap), i)

                setAmmo(i, 'loaded', OITC.starting_primary_ammo)
                setAmmo(i, 'unloaded', OITC.starting_secondary_ammo)
            end
        end
    end
end

function OnKill(Victim, Killer)
    if (not OITC.game_over) then
        local k, v = tonumber(Killer), tonumber(Victim)
        if (k > 0 and k ~= v) then
            setAmmo(k, 'loaded', OITC.ammo_per_kill)
        end
    end
end

function OnSpawn(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        OITC.players[Ply] = true
        execute_command('nades ' .. Ply .. ' ' .. OITC.starting_frags .. ' 1')
        execute_command('nades ' .. Ply .. ' ' .. OITC.starting_plasmas .. ' 2')
    end
end

function OnDamage(V, C, MetaID, Damage, _, _)
    if (C > 0 and V ~= C and multipliers[MetaID]) then
        return true, Damage * multipliers[MetaID]
    end
end

function OnQuit(Ply)
    OITC.players[Ply] = nil
end

function OnScriptUnload()
    -- N/A
end

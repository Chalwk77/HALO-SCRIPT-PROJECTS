--[[
--=====================================================================================================--
Script Name: Killer Reward, for SAPP (PC & CE)
Description: This script will drop 1 of 20 (configurable) random items at your victims death location.

                MODES:
                Kills Not Required:
                    Your victim will drop 1 random "weapon" or "equipment" item (indefinitely), by default.

                Kills Required:
                    Your victim will drop 1 random "weapon" or "equipment" item when you reach a specific kill threashold.
                    For every 5 (non-consecutive) kills, your victim will drop an item.

Copyright (c) 2016-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local MOD = {

    -- ITEM SPAWN SETTINGS --
    -- note: only one option can be enabled!

    -- If true, a combination of weapons and equipment will spawn:
    ["WeaponsAndEquipment"] = true,

    -- If true, only equipment will spawn:
    ["JustEquipment"] = false,

    -- If true, only weapons will spawn:
    ["JustWeapons"] = false,


    --==============================================--
    -- MODES --
    -- note: only one mode can be enabled!

    -- No kills required (victim will drop item indefinitely):
    --
    ["mode 1"] = true,

    -- Kills required (an item will drop every N consecutive kills):
    --
    ["mode 2"] = false,
    consecutive_kills = 5,
    --==============================================--


    -- stock tags --
    -- To disable a specific item, change the 'true' value to "false".
    weapons = {
        { "weap", "weapons\\pistol\\pistol", true },
        { "weap", "weapons\\shotgun\\shotgun", true },
        { "weap", "weapons\\needler\\mp_needler", true },
        { "weap", "weapons\\flamethrower\\flamethrower", true },
        { "weap", "weapons\\plasma rifle\\plasma rifle", true },
        { "weap", "weapons\\sniper rifle\\sniper rifle", true },
        { "weap", "weapons\\assault rifle\\assault rifle", true },
        { "weap", "weapons\\plasma pistol\\plasma pistol", true },
        { "weap", "weapons\\plasma_cannon\\plasma_cannon", true },
        { "weap", "weapons\\rocket launcher\\rocket launcher", true },
    },

    equipment = {
        { "eqip", "powerups\\health pack", true },
        { "eqip", "powerups\\over shield", true },
        { "eqip", "powerups\\active camouflage", true },
        { "eqip", "powerups\\pistol ammo\\pistol ammo", true },
        { "eqip", "powerups\\shotgun ammo\\shotgun ammo", true },
        { "eqip", "powerups\\needler ammo\\needler ammo", true },
        { "eqip", "powerups\\flamethrower ammo\\flamethrower ammo", true },
        { "eqip", "powerups\\sniper rifle ammo\\sniper rifle ammo", true },
        { "eqip", "powerups\\assault rifle ammo\\assault rifle ammo", true },
        { "eqip", "powerups\\rocket launcher ammo\\rocket launcher ammo", true },
    }
}
-- config ends --

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], "OnDeath")
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

local function GetPos(DyN)

    local x, y, z

    local VehicleID = read_dword(DyN + 0x11C)
    local Object = get_object_memory(VehicleID)

    if (VehicleID == 0xFFFFFFFF) then
        x, y, z = read_vector3d(DyN + 0x5c)
    elseif (Object ~= 0) then
        x, y, z = read_vector3d(Object + 0x5c)
    end

    return x, y, z
end

function MOD:SpawnItem(x, y, z)

    local name, type

    if (MOD["WeaponsAndEquipment"]) then

        local n = rand(0, 2)
        if (n == 1) then
            n = MOD.weapons[rand(1, #MOD.weapons + 1)]
        else
            n = MOD.weapons[rand(1, #MOD.equipment + 1)]
        end
        type, name = n[1], n[2]

    elseif (MOD["JustEquipment"]) then
        local n = MOD.weapons[rand(1, #MOD.equipment + 1)]
        type, name = n[1], n[2]
    elseif (MOD["JustWeapons"]) then
        local n = MOD.weapons[rand(1, #MOD.weapons + 1)]
        type, name = n[1], n[2]
    end

    if (GetTag(type, name)) then
        spawn_object(type, name, x, y, z + 0.5)
    end
end

function OnDeath(Victim, Killer)
    local victim = tonumber(Victim)
    local killer = tonumber(Killer)

    if (killer > 0 and player_present(killer)) then

        local DyN = get_dynamic_player(victim)
        if (DyN ~= 0) then

            local x, y, z = GetPos(DyN)

            if (MOD["mode 1"]) then
                MOD:SpawnItem(x, y, z)

            elseif (MOD["mode 2"]) then
                local kills = tonumber(get_var(killer, "$kills"))
                if (kills % MOD.consecutive_kills) then
                    MOD:SpawnItem(x, y, z)
                end
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end
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
    ["mode 1"] = false,

    -- Kills required (an item will drop every N consecutive kills):
    --
    ["mode 2"] = true,
    consecutive_kills = 5,
    --==============================================--

    -- stock weapon tags --
    weapons = {
        { "weap", "weapons\\pistol\\pistol" },
        { "weap", "weapons\\shotgun\\shotgun" },
        { "weap", "weapons\\needler\\mp_needler" },
        { "weap", "weapons\\flamethrower\\flamethrower" },
        { "weap", "weapons\\plasma rifle\\plasma rifle" },
        { "weap", "weapons\\sniper rifle\\sniper rifle" },
        { "weap", "weapons\\assault rifle\\assault rifle" },
        { "weap", "weapons\\plasma pistol\\plasma pistol" },
        { "weap", "weapons\\plasma_cannon\\plasma_cannon" },
        { "weap", "weapons\\rocket launcher\\rocket launcher" },
    },

    -- stock equipment tags --
    equipment = {
        { "eqip", "powerups\\health pack" },
        { "eqip", "powerups\\over shield" },
        { "eqip", "powerups\\active camouflage" },
        { "eqip", "powerups\\pistol ammo\\pistol ammo" },
        { "eqip", "powerups\\shotgun ammo\\shotgun ammo" },
        { "eqip", "powerups\\needler ammo\\needler ammo" },
        { "eqip", "powerups\\flamethrower ammo\\flamethrower ammo" },
        { "eqip", "powerups\\sniper rifle ammo\\sniper rifle ammo" },
        { "eqip", "powerups\\assault rifle ammo\\assault rifle ammo" },
        { "eqip", "powerups\\rocket launcher ammo\\rocket launcher ammo" },
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

    local n, type, name

    if (MOD["WeaponsAndEquipment"]) then
        n = rand(0, 2)
        if (n == 0) then
            n = MOD.weapons[rand(1, #MOD.weapons + 1)]
        else
            n = MOD.equipment[rand(1, #MOD.equipment + 1)]
        end

    elseif (MOD["JustEquipment"]) then
        n = MOD.equipment[rand(1, #MOD.equipment + 1)]

    elseif (MOD["JustWeapons"]) then
        n = MOD.weapons[rand(1, #MOD.weapons + 1)]
    end

    type, name = n[1], n[2]
    if (GetTag(type, name)) then

        -- Technical Note --
        -- Objects are not anchored to the ground.
        -- We need to delay the spawn logic otherwise they might
        -- fly away if the victim is blown up.

        timer(500, "SpawnObject", type, name, x, y, z)
    end
end

function SpawnObject(type, name, x, y, z)
    spawn_object(type, name, x, y, z + 0.5)
end

function OnDeath(Victim, Killer)

    local victim = tonumber(Victim)
    local killer = tonumber(Killer)

    if (killer > 0 and player_present(killer)) then

        local DyN = get_dynamic_player(victim)
        if (DyN ~= 0) then

            local x, y, z = GetPos(DyN)
            local consecutive = (tonumber(get_var(killer, "$kills")) % MOD.consecutive_kills == 0)

            if (MOD["mode 1"] or MOD["mode 2"] and consecutive) then
                MOD:SpawnItem(x, y, z)
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end
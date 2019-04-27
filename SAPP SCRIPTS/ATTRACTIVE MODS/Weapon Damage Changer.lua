--[[
--=====================================================================================================--
Script Name: Weapon Damage Changer, for SAPP (PC & CE)
Description: This mod is a fully-involved damage multiplier changer - 
             that enables you to change the default damage for any desired weapon.
             
             Individual weapons can be enabled or disabled - if a weapon is disabled, it will revert to the maps default damage.
             
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

-- Configuration [starts]
local weapons = {
	
    -- WEAPON TAG ID | MULTIPLIER | ENABLE/DISABLE (true = enabled, false = disabled)
    -- Normal damage = 1

    -- Stock Weapons
    [1] = { "weapons\\pistol\\pistol", 1, true },
    [2] = { "weapons\\sniper rifle\\sniper rifle", 1, true },
    [3] = { "weapons\\plasma_cannon\\plasma_cannon", 1, true },
    [4] = { "weapons\\rocket launcher\\rocket launcher", 1, true },
    [5] = { "weapons\\plasma pistol\\plasma pistol", 1, true },
    [6] = { "weapons\\plasma rifle\\plasma rifle", 1, true },
    [7] = { "weapons\\assault rifle\\assault rifle", 1, true },
    [8] = { "weapons\\flamethrower\\flamethrower", 1, true },
    [9] = { "weapons\\needler\\mp_needler", 1, true },
    [10] = { "weapons\\shotgun\\shotgun", 1, true },

    -- Custom Weapons
    [11] = { "halo3\\weapons\\battle rifle\\tactical battle rifle", 1, true },
    [12] = { "reach\\objects\\weapons\\pistol\\magnum\\magnum", 1, true },
    [13] = { "halo3\\weapons\\odst pistol\\odst pistol", 1, true },
    [14] = { "bourrin\\weapons\\assault rifle", 1, true },
    [15] = { "altis\\weapons\\br\\br", 1, true },
    [16] = { "cmt\\weapons\\human\\shotgun\\shotgun", 1, true },
    [17] = { "bourrin\\weapons\\dmr\\dmr", 1, true },
    [18] = { "altis\\weapons\\br_spec_ops\\br_spec_ops", 1, true },
    [19] = { "cmt\\weapons\\evolved\\human\\sniper_rifle\\sniper_rifle", 1, true },
    [20] = { "halo reach\\objects\\weapons\\support_high\\spartan_laser\\spartan laser", 1, true },
    [21] = { "bourrin\\weapons\\badass rocket launcher\\bourrinrl", 1, true },
    [22] = { "reach\\objects\\weapons\\pistol\\magnum\\gold magnum", 1, true },
}
-- Configuration [end]

local weapons_table = { }
local gmatch, match = string.gmatch, string.match

local function TagInfo(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

local function populate()

    weapons_table = weapons_table or { }
    weapons_table = { }

    for k, _ in pairs(weapons) do
        local tag_name = weapons[k][1]
        local multiplier = weapons[k][2]
        local enabled = weapons[k][3]
        if TagInfo("weap", tag_name) and (enabled) then
            weapons_table[#weapons_table + 1] = tag_name .. ", " .. multiplier
        end
    end
end

function OnScriptLoad()
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    populate()
end

function OnScriptUnload()
    --
end

function OnGameStart()
    populate()
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        local weapon_object = get_object_memory(read_dword(get_dynamic_player(CauserIndex) + 0x118))
        if (weapon_object ~= 0) then
            local tag_name = read_string(read_dword(read_word(weapon_object) * 32 + 0x40440038))
            local multiplier = getMultiplier(tag_name)
            if (multiplier) then
                return true, Damage * tonumber(multiplier[2])
            end
        end
    end
end

function stringSplit(inp, sep)
    if (sep == nil) then
        sep = "%s"
    end
    local t, i = {}, 1
    for str in gmatch(inp, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function getMultiplier(tag_id)
    local content, data

    for _, v in pairs(weapons_table) do
        content = v:find(tag_id)
        if (content) then
            data = stringSplit(v, ",")
        end
    end

    if (data) then
        local result, i = { }, 1
        for j = 1, 2 do
            if (data[j] ~= nil) then
                result[i] = data[j]
                i = i + 1
            end
        end
        if (result ~= nil) then
            return result
        end
    end
end

--[[
--=====================================================================================================--
Script Name: Damage Multiplier (changer), for SAPP (PC & CE)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local multipliers = {
    -- TAG NAME | MULTIPLIER (0-9999) - 1 = normal damage
    -- STOCK TAGS --
    melee = {
        { "weapons\\assault rifle\\melee", 4 },
        { "weapons\\ball\\melee", 4 },
        { "weapons\\flag\\melee", 4 },
        { "weapons\\flamethrower\\melee", 4 },
        { "weapons\\needler\\melee", 4 },
        { "weapons\\pistol\\melee", 1 },
        { "weapons\\plasma pistol\\melee", 4 },
        { "weapons\\plasma rifle\\melee", 3 },
        { "weapons\\rocket launcher\\melee", 1 },
        { "weapons\\shotgun\\melee", 2 },
        { "weapons\\sniper rifle\\melee", 2 },
        { "weapons\\plasma_cannon\\effects\\plasma_cannon_melee", 2 },
    },

    grenades = {
        { "weapons\\frag grenade\\explosion", 2 },
        { "weapons\\plasma grenade\\explosion", 2 },
        { "weapons\\plasma grenade\\attached", 10 },
    },

    vehicles = {
        { "vehicles\\ghost\\ghost bolt", 1.015 },
        { "vehicles\\scorpion\\bullet", 1.020 },
        { "vehicles\\warthog\\bullet", 1.025 },
        { "vehicles\\c gun turret\\mp bolt", 1.030 },
        { "vehicles\\banshee\\banshee bolt", 1.035 },
        { "vehicles\\scorpion\\shell explosion", 1.040 },
        { "vehicles\\banshee\\mp_fuel rod explosion", 1.045 },
    },

    projectiles = {
        { "weapons\\pistol\\bullet", 1.00 },
        { "weapons\\plasma rifle\\bolt", 1.50 },
        { "weapons\\shotgun\\pellet", 1.20 },
        { "weapons\\plasma pistol\\bolt", 1.50 },
        { "weapons\\needler\\explosion", 2.00 },
        { "weapons\\assault rifle\\bullet", 2.00 },
        { "weapons\\needler\\impact damage", 1.10 },
        { "weapons\\flamethrower\\explosion", 2.00 },
        { "weapons\\sniper rifle\\sniper bullet", 4.00 },
        { "weapons\\rocket launcher\\explosion", 5.00 },
        { "weapons\\needler\\detonation damage", 2.00 },
        { "weapons\\plasma rifle\\charged bolt", 3.00 },
        { "weapons\\plasma_cannon\\effects\\plasma_cannon_melee", 2.50 },
        { "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion", 2.50 },
    },

    vehicle_collision = {
        { "globals\\vehicle_collision", 1 },
    },

    fall_damage = {
        { "globals\\falling", 1 },
        { "globals\\distance", 1 },
    },
}

function OnScriptLoad()
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")

end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        for Table, _ in pairs(multipliers) do
            for _, Tag in pairs(multipliers[Table]) do
                if Tag[1] then
                    if (MetaID == GetTag("jpt!", Tag[1])) then
                        return true, Damage * Tag[2]
                    end
                end
            end
        end
    end
end

function GetTag(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

--[[
--=====================================================================================================--
Script Name: Replace Weapon Projectile (v1.1), for SAPP (PC & CE)
Description: This script will allow you to swap weapon projectiles for substitute projectiles

NOTE: The replacement projectile will still appear as the original projectile (but function properly).

Changes in v1.1:
- Added grenades and damage multipliers to the projectile table.
- Updated Tag lookup function.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local projectiles = {}

-- Configuration [starts] ------------------------------------------------------
projectiles = {
    --      ORIGINAL TAG                                    REPLACEMENT TAG                             DAMAGE MULTIPLIER
    [1] = { "vehicles\\banshee\\banshee bolt",              "vehicles\\banshee\\banshee bolt",          10},
    [2] = { "vehicles\\banshee\\mp_banshee fuel rod",       "vehicles\\banshee\\mp_banshee fuel rod",   10},
    [3] = { "vehicles\\c gun turret\\mp gun turret",        "vehicles\\c gun turret\\mp gun turret",    10},
    [4] = { "vehicles\\ghost\\ghost bolt",                  "vehicles\\ghost\\ghost bolt",              10},
    [5] = { "vehicles\\scorpion\\bullet",                   "vehicles\\scorpion\\bullet",               10},
    [6] = { "vehicles\\scorpion\\tank shell",               "vehicles\\scorpion\\tank shell",           10},
    [7] = { "vehicles\\warthog\\bullet",                    "vehicles\\warthog\\bullet",                10},

    [8] = { "weapons\\assault rifle\\bullet",               "weapons\\assault rifle\\bullet",           10},
    [9] = { "weapons\\flamethrower\\flame",                 "weapons\\flamethrower\\flame",             10},
    [10] = { "weapons\\needler\\mp_needle",                 "weapons\\needler\\mp_needle",              10},
    [11] = { "weapons\\pistol\\bullet",                     "weapons\\pistol\\bullet",                  10},
    [12] = { "weapons\\plasma pistol\\bolt",                "weapons\\plasma pistol\\bolt",             10},
    [13] = { "weapons\\plasma rifle\\bolt",                 "weapons\\plasma rifle\\bolt",              10},
    [14] = { "weapons\\plasma rifle\\charged bolt",         "weapons\\plasma rifle\\charged bolt",      10},
    [15] = { "weapons\\rocket launcher\\rocket",            "weapons\\rocket launcher\\rocket",         10},
    [16] = { "weapons\\shotgun\\pellet",                    "weapons\\shotgun\\pellet",                 10},
    [17] = { "weapons\\sniper rifle\\sniper bullet",        "weapons\\sniper rifle\\sniper bullet",     10},
    [18] = { "weapons\\plasma_cannon\\plasma_cannon",       "weapons\\plasma_cannon\\plasma_cannon",    10},
    
    -- grenades --
    [19] = { "weapons\\frag grenade\\frag grenade",         "weapons\\frag grenade\\frag grenade",      10},
    [20] = { "weapons\\plasma grenade\\plasma grenade",     "weapons\\plasma grenade\\plasma grenade",  10},
    [21] = { "weapons\\frag grenade\\explosion",            "weapons\\frag grenade\\explosion",         10},
    [22] = { "weapons\\plasma grenade\\attached",           "weapons\\plasma grenade\\attached",        10},
    [23] = { "weapons\\plasma grenade\\explosion",          "weapons\\plasma grenade\\explosion",       10},
   
    -- See example below to lean how to swap the "sniper bullet" for "tank shell":

    ------- Change the following -------
    -- from:  [17] = { "weapons\\sniper rifle\\sniper bullet",        "weapons\\sniper rifle\\sniper bullet"},
    -- to:    [17] = { "weapons\\sniper rifle\\sniper bullet",        "vehicles\\scorpion\\tank shell"},


}
-- Configuration [ends] --------------------------------------------------------

function OnScriptLoad()
    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
end

local function getTag(a, b)
    local tag = lookup_tag(a, b)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    if (PlayerIndex) then        
        for i = 1, #projectiles do

            local original = projectiles[i][1]
            local replacement = projectiles[i][2]

            if (MapID == getTag("proj", original)) then
                return true, getTag("proj", replacement)
            end
        end
    end
end

function OnDamageApplication(ReceiverIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if tonumber(CauserIndex) > 0 then
        for i = 1, #projectiles do
            local repl, mul = projectiles[i][2], projectiles[i][3]
            if (MetaID == getTag("jpt!", repl)) then
                return true, Damage * mul
            end
        end
    end
end

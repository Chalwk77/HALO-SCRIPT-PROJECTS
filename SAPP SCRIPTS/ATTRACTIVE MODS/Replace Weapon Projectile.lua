--[[
--=====================================================================================================--
Script Name: Replace Weapon Projectile (v1.0), for SAPP (PC & CE)
Description: This script will allow you to swap weapon projectiles for substitute projectiles

NOTE: The replacement projectile will still appear as the original projectile (but function properly).

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
    --      ORIGINAL TAG                                    REPLACEMENT TAG
    [1] = { "vehicles\\banshee\\banshee bolt",              "vehicles\\banshee\\banshee bolt" },
    [2] = { "vehicles\\banshee\\mp_banshee fuel rod",       "vehicles\\banshee\\mp_banshee fuel rod" },
    [3] = { "vehicles\\c gun turret\\mp gun turret",        "vehicles\\c gun turret\\mp gun turret" },
    [4] = { "vehicles\\ghost\\ghost bolt",                  "vehicles\\ghost\\ghost bolt" },
    [5] = { "vehicles\\scorpion\\bullet",                   "vehicles\\scorpion\\bullet" },
    [6] = { "vehicles\\scorpion\\tank shell",               "vehicles\\scorpion\\tank shell" },
    [7] = { "vehicles\\warthog\\bullet",                    "vehicles\\warthog\\bullet" },

    [8] = { "weapons\\assault rifle\\bullet",               "weapons\\assault rifle\\bullet" },
    [9] = { "weapons\\flamethrower\\flame",                 "weapons\\flamethrower\\flame" },
    [10] = { "weapons\\needler\\mp_needle",                 "weapons\\needler\\mp_needle" },
    [11] = { "weapons\\pistol\\bullet",                     "weapons\\pistol\\bullet" },
    [12] = { "weapons\\plasma pistol\\bolt",                "weapons\\plasma pistol\\bolt" },
    [13] = { "weapons\\plasma rifle\\bolt",                 "weapons\\plasma rifle\\bolt" },
    [14] = { "weapons\\plasma rifle\\charged bolt",         "weapons\\plasma rifle\\charged bolt" },
    [15] = { "weapons\\rocket launcher\\rocket",            "weapons\\rocket launcher\\rocket" },
    [16] = { "weapons\\shotgun\\pellet",                    "weapons\\shotgun\\pellet" },
    [17] = { "weapons\\sniper rifle\\sniper bullet",        "weapons\\sniper rifle\\sniper bullet" },
    [18] = { "weapons\\plasma_cannon\\plasma_cannon",       "weapons\\plasma_cannon\\plasma_cannon" },

    -- See example below to lean how to swap the "sniper bullet" for "tank shell":

    ------- Change the following -------
    -- from:  [17] = { "weapons\\sniper rifle\\sniper bullet",        "weapons\\sniper rifle\\sniper bullet"},
    -- to:    [17] = { "weapons\\sniper rifle\\sniper bullet",        "vehicles\\scorpion\\tank shell"},


}
-- Configuration [ends] --------------------------------------------------------

function OnScriptLoad()
    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
end

local function getTag(a, b)
    return read_dword(lookup_tag(a, b) + 12) or nil
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

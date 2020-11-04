--[[
--=====================================================================================================--
Script Name: Disable Fall Damage, for SAPP (PC & CE)
Description: This mod will allow you to disable fall damage on a per-map basis.

Copyright (c) 2019-2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local FallDamage = { }
function FallDamage:Init()
    if (get_var(0, "$gt") ~= "n/a") then

        -- Configuration [starts] -----------------------------------------------------
        FallDamage.maps = {

            -- (true = fall damage enabled, false = fall damage disabled):

            ["putput"] = false,
            ["wizard"] = false,
            ["longest"] = false,
            ["ratrace"] = false,
            ["carousel"] = false,
            ["infinity"] = false,
            ["chillout"] = false,
            ["prisoner"] = false,
            ["damnation"] = true,
            ["icefields"] = false,
            ["bloodgulch"] = false,
            ["hangemhigh"] = false,
            ["sidewinder"] = false,
            ["timberland"] = false,
            ["beavercreek"] = false,
            ["deathisland"] = false,
            ["dangercanyon"] = false,
            ["gephyrophobia"] = false,
            ["boardingaction"] = false,
        }
        -- Configuration [ends] -----------------------------------------------------

        self.map = get_var(0, "$map")
        self.falling = GetTag("jpt!", "globals\\falling")
        self.distance = GetTag("jpt!", "globals\\distance")
    end
end

function OnScriptLoad()
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    FallDamage:Init()
end

function OnGameStart()
    FallDamage:Init()
end

function OnDamageApplication(_, _, MetaID, _, _, _)
    if (MetaID == FallDamage.falling or MetaID == FallDamage.distance) then
        if (not FallDamage.maps[FallDamage.map]) then
            return false
        end
    end
end

function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function OnScriptUnload()
    -- N/A
end
--[[
--=====================================================================================================--
Script Name: Bigass Golden Gun (strength changer), for SAPP (PC & CE)
Description: This script enables you to easily change the base damage for the Golden Gun on Bigass Final.
			
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

-- Configuration [starts]
local multiplier = 10 -- (strength amount) 1 = normal
local weapon_tag_name = "reach\\objects\\weapons\\pistol\\magnum\\gold magnum"
-- Configuration [end]

local proceed
function OnScriptLoad()
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
end

function OnScriptUnload()
    --
end

local function TagInfo(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function OnGameStart()
    proceed = false
    if TagInfo("weap", weapon_tag_name) then
        proceed = true
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) and (proceed) then
        local weapon_object = get_object_memory(read_dword(get_dynamic_player(CauserIndex) + 0x118))
        if (weapon_object ~= 0) then
            local tag_name = read_string(read_dword(read_word(weapon_object) * 32 + 0x40440038))
            if (tag_name == weapon_tag_name) then
                return true, Damage * tonumber(multiplier)
            end
        end
    end
end

--[[
    --=====================================================================================================--
Script Name: Block Team Damage, for SAPP (PC & CE)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--


api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
end

function OnScriptUnload()
    --
end

local function getTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        local vTeam = get_var(PlayerIndex, "$team")
        local kTeam = get_var(CauserIndex, "$team")
        if (getTeamPlay() and vTeam == kTeam) then
            return false
        end
    end
end

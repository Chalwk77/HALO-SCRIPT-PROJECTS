--[[
--=====================================================================================================--
Script Name: Swat, for SAPP (PC & CE)
Description: An extremely simple adaptation of "swat" from Halo Reach.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")
end

function OnDamageApplication(PlayerIndex, CauserIndex, _, Damage, HitString, _)
    if (CauserIndex > 0 and PlayerIndex ~= CauserIndex) then
        if (HitString == "head") then
            return true, Damage * 1000
        else
            return false
        end
    end
end
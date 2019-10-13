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
    register_callback(cb['EVENT_NEW_GAME'], "OnGameStart")
    Register()
end

function OnGameStart()
    Register()
end

function OnScriptUnload()
    --
end

function OnDamageApplication(PlayerIndex, CauserIndex)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        local vTeam = get_var(PlayerIndex, "$team")
        local kTeam = get_var(CauserIndex, "$team")
        if (vTeam == kTeam) then
            return false
        end
    end
end

function Register()
    if (get_var(0, "$gt") ~= "n/a") and (get_var(0, "$ffa") == "0") then
        register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    end
end

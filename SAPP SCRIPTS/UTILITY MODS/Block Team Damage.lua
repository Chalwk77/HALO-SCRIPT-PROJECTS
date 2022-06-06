--[[
    --=====================================================================================================--
Script Name: Block Team Damage, for SAPP (PC & CE)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_NEW_GAME'], 'OnStart')
    OnStart()
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a' and get_var(0, '$ffa') == '0') then
        register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'BlockDamage')
        return
    end
    unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])
end

function BlockDamage(Victim, Killer)
    local killer, victim = tonumber(Killer), tonumber(Victim)
    if (killer > 0 and victim ~= killer and get_var(killer, '$team') == get_var(victim, '$team')) then
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
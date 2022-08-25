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

    local gt = get_var(0, '$gt')
    local team_play = (get_var(0, '$ffa') == '0')

    if (gt ~= 'n/a' and team_play) then
        register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'BlockDamage')
        return
    end
    unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])
end

function BlockDamage(Victim, Killer)

    local k = tonumber(Killer)
    local v = tonumber(Victim)

    local k_team = get_var(k, '$team')
    local v_team = get_var(v, '$team')

    local suicide = (k == v)

    if (k > 0 and (not suicide) and k_team == v_team) then
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
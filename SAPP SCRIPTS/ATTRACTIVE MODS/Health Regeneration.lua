--[[
--=====================================================================================================--
Script Name: Health Regeneration, for SAPP (PC & CE)
Description: Continuously regenerate your health.
    
Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local increment = 0.1116

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnJoin")
end

function OnJoin(Ply)
    timer(1000, "Regen", Ply)
end

function Regen(Ply)

    local dyn = get_dynamic_player(Ply)
    if (dyn ~= 0 and player_alive(Ply)) then
        local health = read_float(dyn + 0xE0)
        if (health < 1) then
            write_float(dyn + 0xE0, health + increment)
        end
    end

    return true
end

function OnScriptUnload()
    -- N/A
end
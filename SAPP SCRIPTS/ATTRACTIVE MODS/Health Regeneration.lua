--[[
--=====================================================================================================--
Script Name: Health Regeneration, for SAPP (PC & CE)
Description: Continuously regenerate your health.
    
    Credits to H® Shaft for the original "Continuous Health Regeneration" script.
    Converted to SAPP by Jericho Crosby (Chalwk).
    
Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- config starts --
-- Time (in seconds) between each incremental increase in health:
--
local interval = 10

-- Amount of health regenerated. (1 is full health)
--
local increment = 0.1116
-- config ends --

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "JOIN")
end

function JOIN(Ply)
    timer(interval * 1000, "Regenerate", Ply)
end

function Regenerate(Ply)
    for _ = 1, 16 do
        local DyN = get_dynamic_player(Ply)
        if (DyN ~= 0 and player_alive(Ply)) then
            if (read_float(DyN + 0xE0) < 1 )then
                write_float(DyN + 0xE0, read_float(DyN + 0xE0) + increment)
            end
        end
    end
    return true
end

function OnScriptUnload()
    -- N/A
end
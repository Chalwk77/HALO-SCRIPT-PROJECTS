--[[
--=====================================================================================================--
Script Name: Health Regeneration, for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description: Continuously regenerate your health.
    
    Credits to H® Shaft for the original "Continuous Health Regeneration" script.
    Converted to SAPP by Jericho Crosby (Chalwk).
    
Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

Time = 10 -- time (in seconds) between each incremental increase in health
increment = 0.1116 -- amount of health regenerated. (1 is full health)

function OnScriptLoad( )
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
end

function OnScriptUnload( ) end

function OnPlayerJoin(PlayerIndex)
    timer(Time * 1000, "Regenerate", PlayerIndex)
end

function Regenerate(PlayerIndex)
	for i = 1,16 do
        local player_object = get_dynamic_player(PlayerIndex)
        if (player_object ~= 0) then
            if (player_alive(PlayerIndex)) then
                if read_float(player_object + 0xE0) < 1 then 
                    write_float(player_object + 0xE0, read_float(player_object + 0xE0) + increment)
                end
            end
        end
    end
	return true	
end

function OnError(Message)
    print(debug.traceback())
end

--[[
--=====================================================================================================--
Script Name: Is Player Invisible [function], for SAPP (PC & CE)
Implementing API version: 1.11.0.0

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
end

function OnScriptUnload() end	

function OnPlayerJoin(PlayerIndex)
    for i = 1, 16 do
        if PlayerIndex then 
            CheckPlayer(PlayerIndex)
        end
    end
end

function CheckPlayer(PlayerIndex)
    local player_object = get_dynamic_player(index)
    if (player_object ~= 0) then
        local invis = read_float(player_object + 0x37C)
        if invis == 0 then
            -- Not invisible
            cprint("Player is not invisible", 4+8)
            return false
        else
            -- Completely invisible
            cprint("Player is invisible", 2+8)
            return true
        end
    end
end

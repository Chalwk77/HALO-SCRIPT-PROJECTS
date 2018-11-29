--[[
--=====================================================================================================--
Script Name: Is Player Invisible [function], for SAPP (PC & CE)
Implementing API version: 1.11.0.0

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

function OnScriptLoad()

end

function OnScriptUnload()
end

function check_if_invisible(PlayerIndex)
    local bool
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local invisibility = read_float(player_object + 0x37C)
        if invisibility == 0 then
            --cprint("Player is not invisible", 4 + 8)
            bool = false
        else
            --cprint("Player is invisible", 2 + 8)
            bool = true
        end
    end
    return bool
end

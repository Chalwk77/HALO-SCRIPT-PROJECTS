--[[
--=====================================================================================================--
Script Name: Status Timer, for SAPP (PC & CE)
Implementing API version: 1.11.0.0

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local interval = 3000

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnStart")
    OnStart()
end

function StatusTimer()
    local min = tonumber(get_var(0, '$pn'))
    local max = read_word(0x4029CE88 + 0x28)
    cprint("There are currently: (" .. min .. " / " .. max .. " players online)", 10)
    return true
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        timer(interval, "StatusTimer")
    end
end

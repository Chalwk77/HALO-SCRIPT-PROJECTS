--[[
--=====================================================================================================--
Script Name: Status Timer, for SAPP (PC & CE)
Description: Prints the number of players currently online.

Copyright (c) 2016-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Print the number of players currently online every this many seconds:
local interval = 3

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnStart")
    OnStart()
end

local format = string.format
function StatusTimer()
    local min = tonumber(get_var(0, '$pn'))
    local max = read_word(0x4029CE88 + 0x28)
    cprint(format('Players: %d/%d', min, max), 10)
    return true
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        timer(interval * 1000, 'StatusTimer')
    end
end
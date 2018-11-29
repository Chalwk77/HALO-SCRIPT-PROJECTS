--[[
--=====================================================================================================--
Script Name: Status Timer, for SAPP (PC & CE)
Implementing API version: 1.11.0.0

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
delay = 3000

function OnScriptLoad()
    timer(delay, "StatusTimer")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
end

function StatusTimer()
    if players == nil then
        players = 0
    end
    cprint("There are currently: (" .. players .. " / " .. read_word(0x4029CE88 + 0x28) .. " players online)", 2 + 8)
    return true
end

function OnPlayerJoin(PlayerIndex)
    if players == nil then
        players = 1
    else
        players = players + 1
    end
end

function OnPlayerLeave(PlayerIndex)
    players = players - 1
end

function OnNewGame()
    players = 0
end

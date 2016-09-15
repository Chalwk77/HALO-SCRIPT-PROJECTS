--[[    
------------------------------------
Script Name: HPC OnGameEnd messages, SAPP (BROKEN)
    - Implementing API version: 1.10.0.0
    
Description: This script will display taunting messages to the player on game end

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.10.0.0"

function OnScriptUnload( ) 
    
end

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    safe_read(true)
end

function OnGameEnd(PlayerIndex)
    
    local player = get_player(PlayerIndex)
    local kills = read_word(player + 0x9C)
        if kills == 0 then
        print("What a noob! You have 0 kills!")
    end
end

function OnError(Message)
    print(debug.traceback())
end
--[[    
------------------------------------
Script Name: HPC OnGameEnd messages, SAPP
    - Implementing API version: 1.10.0.0
    
Description: This script will display taunting messages  to the player on game end

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
end

function OnGameEnd()
    local player = get_player(player_index)
    
    for i=1,16 do
        if player_present(PlayerIndex) then
            if read_bit(player(i) + 0x9C) == 0 then
                say(PlayerIndex, "You have no kills... noob alert!")
            end
            if read_bit(player(i) + 0x9C) == 1 then
                say(PlayerIndex, "One kill? You must be new at this...")
            end
            if read_bit(player(i) + 0x9C) == 2 then
                say(PlayerIndex, "Eh, two kills... not bad. But you still suck.")
            end
            if read_bit(player(i) + 0x9C) == 3 then
                say(PlayerIndex, "Relax sonny! 3 kills, and you be like... mad bro?")
            end
            if read_bit(player(i) + 0x9C) == 4 then
                say(PlayerIndex, "Duhn Duhn Duhn... them 4 kills though!")
            end
            if read_bit(player(i) + 0x9C) > 4 then
                say(PlayerIndex, "Well, you've got more than 4 kills... #AchievingTheImpossible")
            end
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end
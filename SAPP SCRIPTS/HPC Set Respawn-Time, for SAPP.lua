--[[    
------------------------------------
Script Name: HPC Set Respawn-Time, SAPP
    - Implementing API version: 1.11.0.0
    
Description: This script will allow you to set player respawn time (in seconds)
    
Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN (in game name): Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.11.0.0"
RespawnTime = 2.5 -- 1.5 seconds

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'],"OnPlayerKill")
end

function OnScriptUnload( ) 
    
end

function OnPlayerKill(player_index)
    local player = get_player(player_index)
    write_dword(player + 0x2C, RespawnTime * 33)
end	

function OnError(Message)
    print(debug.traceback())
end
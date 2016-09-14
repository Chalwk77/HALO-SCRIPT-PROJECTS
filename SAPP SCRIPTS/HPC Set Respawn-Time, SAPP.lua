--[[    
------------------------------------
Description: HPC Set Respawn-Time, SAPP
    - Implementing API version: 1.10.0.0
    
Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.10.0.0"
RespawnTime = 1.5

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

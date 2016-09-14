--[[    
------------------------------------
Description: HPC Set Respawn-Time, SAPP, Inplementing API version 1.10.0.0
Copyright © 2016-2017 Jericho Crosby
* Author: Jericho Crosby
* IGN: Chalwk
* Written and Created by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.10.0.0"
RespawnTime = 1.5

function OnScriptUnload( ) 
    
end

function OnPlayerKill(player_index)
    local player = get_player(player_index)
    write_dword(player + 0x2C, RespawnTime * 33)
end	

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'],"OnPlayerKill")
end

function OnError(Message)
    print(debug.traceback())
end
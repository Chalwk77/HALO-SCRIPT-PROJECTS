--[[    
    ------------------------------------
Script Name: HPC Get Server Name, for SAPP
    - Implementing API version: 1.11.0.0

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.11.0.0"

function OnScriptLoad() 
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
end

function OnScriptUnload() end

function OnNewGame(map)
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    servername = read_widestring(network_struct + 0x8, 0x42)
    -- Do something here. 
    -- I'm just going to output the name of the server to console on game start.
    cprint(servername)
end

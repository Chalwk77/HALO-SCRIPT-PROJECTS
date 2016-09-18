--[[    
------------------------------------
Script Name: HPC vm351 - Game Settings
    - Implementing API version: 1.10.0.0
    
    Only on github for safe keeping
    
Description: 

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.10.0.0"

function OnScriptLoad()

    logo = timer(50, "consoleLogo")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
end

function OnScriptUnload()
    logo = nil
end

function OnNewGame()
    logo = nil
end

function OnGameEnd()
    logo = nil
end

function OnPlayerPrejoin(PlayerIndex)
    
    local timestamp = os.date("%A %d %B %Y - %X")
    local hash = get_var(PlayerIndex, "$hash")
    local ip = get_var(PlayerIndex, "$ip")
    
    cprint("---------------------------------------------------------------------------------------------------")
    cprint("            - - |   P L A Y E R   A T T E M P T I N G   T O   J O I N   | - -")
    cprint("                 - - - - - - - - - - - - - - - - - - - - - - - - - - - -                    ")
    cprint("CD Hash: <" ..hash.. ">")
    cprint("Join Time: " ..timestamp)
    cprint("IP Address: " ..ip)
end

function OnPlayerJoin(PlayerIndex)
    
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local ip = get_var(PlayerIndex, "$ip")
    local id = get_var(PlayerIndex, "$n")
    
    cprint("Player: " ..name.. " - connected successfully.")
    cprint("IndexID: [" ..id.. "]")
    cprint("---------------------------------------------------------------------------------------------------")
end

function OnPlayerLeave(PlayerIndex)

    local ip = get_var(PlayerIndex, "$ip")
    local id = get_var(PlayerIndex, "$n")
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local ping = get_var(PlayerIndex, "$ping")
    local timestamp = os.date("%A %d %B %Y - %X")

    cprint("---------------------------------------------------------------------------------------------------")
    cprint(name.. " quit the game! - IndexID [" ..id.. "]")
    cprint("Time: " ..timestamp)
    cprint("IP Address: [" ..ip.. "]")
    cprint("Player Ping: [" ..ping.. "]")
    cprint("CD Hash: <" ..hash.. ">")
    cprint("---------------------------------------------------------------------------------------------------")
    cprint("")
end

function consoleLogo()
    
    local timestamp = os.date("%A, %d %B %Y - %X")
    cprint("===================================================================================================")
	cprint(timestamp)
	cprint("")
    cprint("                  '||'                  ||     ..|'''.|                   .'|.   .")
    cprint("                   ||    ....  ... ..  ...   .|'     '  ... ..   ....   .||.   .||.")
    cprint("                   ||  .|...||  ||' ''  ||   ||          ||' '' '' .||   ||     ||")
    cprint("                   ||  ||       ||      ||   '|.      .  ||     .|' ||   ||     ||")
    cprint("               || .|'   '|...' .||.    .||.   ''|....'  .||.    '|..'|' .||.    '|.'")
    cprint("                '''")
    cprint("                      ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    cprint("                                         Chalwk's Realm")
	cprint("                                 vm153 - Pro Snipers + (no lag)")
	cprint("                      ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
	cprint("")
    cprint("===================================================================================================")
end
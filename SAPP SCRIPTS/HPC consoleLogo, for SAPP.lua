--[[
------------------------------------
Script Name: HPC consoleLogo, for SAPP
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
    timer(50, "consoleLogo")
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
   
function OnScriptUnload()
    timer(consoleLogo)
end

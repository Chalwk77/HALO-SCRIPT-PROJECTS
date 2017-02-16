--[[
Script Name: Anti-Impersonator (utility), for SAPP | (PC\CE)
- Implementing API version: 1.11.0.0

    Description: Prevent others from impersonating fig community members.
                 This works by comparing the impersonators name to a table of official FIG member hash's.
                 Assuming your members all have legit copies of Halo and are not using a shared hash.

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
]]

api_version = "1.11.0.0"

-- Configuration --
response = {
    ["kick"] = true,
    ["ban"] = false
}
-- Configuration Ends


function OnScriptLoad( )
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    LoadTables( )
    if (response["ban"] == true) and (response["kick"] == true) then 
        cprint("Script Error: Anti-Impersonator.lua", 4+8)
        cprint("Only one option should be enabled! [punishment configuration] - (line 24/25)", 4+8)
    end
end

function OnScriptUnload() 
   NameList = { } 
   HashList = { } 
end

function LoadTables( )
    NameList = {
    -- Make sure these names match exactly as they do ingame.
        "FIG-Alex",
        "FIG-Amajig",
        "FIG-Arooooo",
        "FIG-brent",
        "FIG-Chuy",
        "FIG-Mental",
        "FIG-Mihir®",
        "FIG-Noob001",
        "FIG-Razor",
        "FIG-shiNe!",
        "FIG-SxyLady",
        "FIG-Traxx",
    }	
    HashList = {
    -- You can retrieve the players hash by looking it up in the sapp.log file.
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    }
end

function table.match(table, value)
    for k,v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    local Name = get_var(PlayerIndex,"$name")
    local Hash = get_var(PlayerIndex,"$hash")
    local Index = get_var(PlayerIndex, "$n")
    -- Name matches, but hash does not; respond with punishment accordingly.
    if (table.match(NameList, Name)) and (table.match(HashList, Hash) == nil) then
        if (response["kick"] == true) and (response["ban"] == false) then 
            execute_command_sequence("w8 5; k " .. Index .. " Impersonating!")
        end
        if (response["ban"] == true) and (response["kick"] == false) then  
            execute_command_sequence("w8 5; b " .. Index .. " Impersonating!")
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end

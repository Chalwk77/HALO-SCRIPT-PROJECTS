--[[
Script Name: Anti-Impersonator (utility), for SAPP | (PC\CE)
- Implementing API version: 1.11.0.0

    Description: Prevent others from impersonating fig community members.
                 You need to list your members IGN's and and corresponding hash on lines 43/50

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

kick_reason = "impersonating a player!"
ban_reason = "impersonating a player!"
-- Configuration Ends


function OnScriptLoad( )
    register_callback(cb['EVENT_JOIN'], "AntiImpersonator")
    LoadTables( )
end

function OnScriptUnload() 
   NameList = { } 
   HashList = { } 
end

function LoadTables( )
    NameList = {
        "Player1",
        "Player2",
        "Player3",
        "Player4",
        "Player5",
    }	
    HashList = {
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

function AntiImpersonator(PlayerIndex)
    
    local Name = get_var(PlayerIndex,"$name")
    local Hash = get_var(PlayerIndex,"$hash")
    if (table.match(NameList, Name) == true) and (table.match(HashList, Hash) == true) then
        -- do nothing
        return true
    else
        if (table.match(NameList, Name) ~= true) and (table.match(HashList, Hash) ~= true) then
            if (response["kick"] == true) and (response["ban"] == false) then 
                execute_command("k " .. PlayerIndex .. kick_reason)
            end
            if (response["ban"] == true) and (response["kick"] == false) then  
                execute_command("b " .. PlayerIndex .. ban_reason)
            end
            if (response["ban"] == true) and (response["kick"] == true) then 
                cprint("Script Error: AntiImpersonator.lua - Only one option should be enabled! (line 22/23)", 4+8)
            end
        end
    end
end

function table.match(table, value)
    for k,v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end

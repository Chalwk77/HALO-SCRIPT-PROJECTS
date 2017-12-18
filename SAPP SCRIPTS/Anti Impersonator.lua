--[[
Script Name: AntiImpersonator, for SAPP | (PC\CE)
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

-- In Minutes
BANTIME = 10 -- (In Minutes) -- Set to zero to ban permanently
REASON = "Impersonating"
-- Configuration Ends --

function OnScriptLoad( )
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    LoadTables( )
    if (response["ban"] == true) and (response["kick"] == true) then
        cprint("Script Error: AntiImpersonator.lua", 4+8)
        cprint("Only one option should be enabled! [punishment configuration] - (line 24/25)", 4+8)
        unregister_callback(cb['OnPlayerJoin'])
        unregister_callback(cb['OnGameEnd'])
    end
end

function OnGameEnd()
    NameList = { }
    HashList = { }
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
        "Chalwk" -- Make sure the last entry in the table doesn't have a comma
    }	
    HashList = {
    -- You can retrieve the players hash by looking it up in the sapp.log file.
        "6c8f0bc306e0108b4904812110185edd", -- Chalwk
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" -- Make sure the last entry in the table doesn't have a comma
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
    if (table.match(NameList, Name)) and not (table.match(HashList, Hash)) then
        -- Kick
        if (response["kick"] == true) and (response["ban"] == false) then 
            execute_command("k" .. " " .. Index .. " \"" .. REASON .. "\"")
        end
        -- Ban X Amount of time.
        if (response["ban"] == true) and (response["kick"] == false) and (BANTIME >= 1) then  
            execute_command("b" .. " " .. Index .. " " .. BANTIME .. " \"" .. REASON .. "\"")
        -- Ban permanently
        elseif (BANTIME == 0) then
            execute_command("b" .. " " .. Index .. " \"" .. REASON .. "\"")
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end

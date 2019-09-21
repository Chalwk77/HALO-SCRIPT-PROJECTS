--[[
--=====================================================================================================--
Script Name: AntiImpersonator, for SAPP (PC & CE)
Description: Prevent other players from impersonating your community members.

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)

- This script is included in the Velocity Multi-Mod with many improvements.
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration --
local settings = {
    action = "kick", -- Valid actions are 'kick' & 'ban'
    bantime = 10, -- (In Minutes) -- Set to zero to ban permanently
    reason = "Impersonating",

    -- You can enter multiple ip address/hash entries for each user
    users = {
        -- In this example, we have added a player by the name of "example_name". 
        -- They use Halo on multiple computers at different houses. Each computer has a unique public ip address. 
        -- We add each ip entry and hash to the respective table for that user. 
        -- If someone joins with the name 'example_name' and their ip address (or hash) does not match any of the ip addrees for that name entry, action will be taken.
        { ["example_name"] = {"127.0.0.1", "128.0.0.2", "129.0.0.3", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"}},
        
        
        -- repeat the structure to add more entries
        { ["name_here"] = { "ip 1", "ip 2", "hash1", "hash2", "hash3", "etc..." } },
        
        -- You do not need both ip and hash but it adds a bit more security.
    }
}
-- Configuration Ends --

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
end

function OnScriptUnload()
    --
end

local function takeAction(id, name)
    local action, reason, bantime = settings.action, settings.reason, settings.bantime
    if (action == "kick") then
        execute_command("k" .. " " .. id .. " \"" .. reason .. "\"")
        cprint(name .. " was kicked for " .. reason, 4 + 8)
    elseif (action == "ban") then
        execute_command("b" .. " " .. id .. " " .. bantime .. " \"" .. reason .. "\"")
        cprint(name .. " was banned for " .. bantime .. " minutes for " .. reason, 4 + 8)
    else
        error("Action not properly defined. Valid Actions: 'kick' or 'ban'")
    end
end

function OnPlayerConnect(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local index = get_var(PlayerIndex, "$n")
    
    -- Port will change automatically if player is using Multi Client, so we only match the physical ip address itself.  
    local ip = get_var(PlayerIndex, "$ip"):match("(%d+.%d+.%d+.%d+)")

    local found
    for key, _ in ipairs(settings.users) do
        local userdata = settings.users[key][name]
        if (userdata ~= nil) then
            for i = 1, #userdata do
                if (userdata[i] == hash) or (userdata[i] == ip) then
                    found = true
                    break
                end
            end
            if not (found) then
                takeAction(index, name)
                break
            end
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end

--[[
--=====================================================================================================--
Script Name: Remove Duplicate IPs (beta), for SAPP (PC & CE)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

-- Config Starts --
local action = "kick" -- Valid actions are 'kick' & 'ban'
local bantime = 999 -- (In Minutes) -- Set to zero to ban permanently
local reason = "Duplicate IP"

-- If TRUE, all players currently online with the same IP will be removed.
-- If FALSE, only newly joined players with the same IP will be removed. The first player will stay.
local remove_all = true

-- Enter the IP Addresses that will be excluded from the dupe-ip-check.
local exclusion_list = {
    "127.0.0.1", --localhost
    "000.000.000.000",
    "000.000.000.000",
    "000.000.000.000",
    -- Repeat the structure to add more entries
}
-- Config Ends --

function OnScriptLoad()
    register_callback(cb['EVENT_PREJOIN'], "OnPreJoin")
end

function OnPreJoin(PlayerIndex)
    local IP1 = get_var(PlayerIndex, "$ip"):match("(%d+.%d+.%d+.%d+)")
    CheckIPs(PlayerIndex, IP1) -- Validate IP
end

function CheckIPs(Player, IP1)
    local ips = { }

    -- Loop through all players and check for duplicate IP address:
    for i = 1,16 do
        if player_present(i) then
            if (Player ~= i) then
                local IP2 = get_var(i, "$ip"):match("(%d+.%d+.%d+.%d+)")
                if (IP1 == IP2 and not isExcluded(IP1)) then
                   ips[#ips+1] = i
                end
            end
        end
    end
    
    if (#ips > 0) then
        if (not remove_all) then
            takeAction(Player) -- Remove the player who just joined
        else -- Remove all players with the same IP
            ips[#ips+1] = Player
            for i = 1,#ips do 
                takeAction(ips[i])
            end
        end
    end
end

function isExcluded(IP)
    -- Check if IP is in the exclusion list.
    for i = 1,#exclusion_list do
        if (exclusion_list[i]) then
            if (IP == exclusion_list[i]) then
                return true
            end
        end
    end
    return false
end

function takeAction(Player)
    -- Remove the player (kick/ban)
    local name = get_var(Player, "$name")
    if (action == "kick") then
        execute_command("k" .. " " .. Player .. " \"" .. reason .. "\"")
        cprint(name .. " was kicked for " .. reason, 4 + 8)
    elseif (action == "ban") then
        execute_command("b" .. " " .. Player .. " " .. bantime .. " \"" .. reason .. "\"")
        cprint(name .. " was banned for " .. bantime .. " minutes for " .. reason, 4 + 8)
    end
end

function OnScriptUnload()
    --
end

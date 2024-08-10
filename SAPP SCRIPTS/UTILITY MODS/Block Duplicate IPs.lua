--[[
--=====================================================================================================--
Script Name: Block Duplicate IPs (beta), for SAPP (PC & CE)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]
api_version = "1.12.0.0"

-- Config Starts --
local action = "kick" -- Valid actions are 'kick' & 'ban'
local banTime = 999 -- (In Minutes) -- Set to zero to ban permanently
local reason = "Duplicate IP"
-- If TRUE, all players currently online with the same IP will be removed.
-- If FALSE, only newly joined players with the same IP will be removed. The first player will stay.
local removeAll = true

-- Enter the IP Addresses that will be excluded from the dupe-ip-check.
local exclusionList = {
    "127.0.0.1", --localhost
    "000.000.000.000",
    "000.000.000.000",
    "000.000.000.000",
    -- Repeat the structure to add more entries
}
-- Config Ends --

function OnScriptLoad()
    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
end

local function isExcluded(ip)
    -- Check if IP is in the exclusion list.
    for _, excluded_ip in ipairs(exclusionList) do
        if ip == excluded_ip then
            return true
        end
    end
    return false
end

local function takeAction(player)
    -- Remove the player (kick/ban)
    local name = get_var(player, "$name")
    if action == "kick" then
        execute_command("k " .. player .. " \"" .. reason .. "\"")
        cprint(name .. " was kicked for " .. reason, 4 + 8)
    elseif action == "ban" then
        execute_command("b " .. player .. " " .. banTime .. " \"" .. reason .. "\"")
        cprint(name .. " was banned for " .. banTime .. " minutes for " .. reason, 4 + 8)
    end
end

local function CheckIPs(player, ip1)
    local ips = {}

    -- Loop through all players and check for duplicate IP address:
    for i = 1, 16 do
        if player_present(i) then
            if player ~= i then
                local ip2 = get_var(i, "$ip"):match("(%d+.%d+.%d+.%d+)")
                if ip1 == ip2 and not isExcluded(ip1) then
                    table.insert(ips, i)
                end
            end
        end
    end
    if #ips > 0 then
        if not removeAll then
            takeAction(player) -- Remove the player who just joined
        else
            -- Remove all players with the same IP
            table.insert(ips, player)
            for _, ip in ipairs(ips) do
                takeAction(ip)
            end
        end
    end
end

function OnPreJoin(player_index)
    local ip = get_var(player_index, "$ip"):match("(%d+.%d+.%d+.%d+)")
    CheckIPs(player_index, ip) -- Validate IP
end

function OnScriptUnload()
    --
end
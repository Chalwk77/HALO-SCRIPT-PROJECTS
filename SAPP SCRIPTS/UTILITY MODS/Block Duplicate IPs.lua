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
local action = "kick" -- Action to take: "kick" or "ban"
local banTime = 999 -- Ban duration in minutes (if action is "ban")
local reason = "Duplicate IP" -- Reason for the action
local removeAll = true -- Whether to remove all players with the same IP or just the new player

-- List of IPs to exclude from the check
local exclusionList = {
    "127.0.0.1",
    "000.000.000.000",
    "000.000.000.000",
    "000.000.000.000",
}
-- Config Ends --

function OnScriptLoad()
    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
end

local function isExcluded(ip)
    for _, excluded_ip in ipairs(exclusionList) do
        if ip == excluded_ip then
            return true
        end
    end
    return false
end

local function takeAction(player)
    local name = get_var(player, "$name")
    if action == "kick" then
        execute_command("k " .. player .. " \"" .. reason .. "\"")
        cprint(name .. " was kicked for " .. reason, 12)
    elseif action == "ban" then
        execute_command("b " .. player .. " " .. banTime .. " \"" .. reason .. "\"")
        cprint(name .. " was banned for " .. banTime .. " minutes for " .. reason, 12)
    end
end

local function CheckIPs(player, ip1)
    local duplicateIPs = {}

    -- Iterate through all players to find duplicates
    for i = 1, 16 do
        if player_present(i) and player ~= i then
            local ip2 = get_var(i, "$ip"):match("(%d+.%d+.%d+.%d+)")
            if ip1 == ip2 and not isExcluded(ip1) then
                table.insert(duplicateIPs, i)
            end
        end
    end

    -- Take action if duplicates are found
    if #duplicateIPs > 0 then
        if not removeAll then
            takeAction(player)
        else
            table.insert(duplicateIPs, player)
            for _, duplicatePlayer in ipairs(duplicateIPs) do
                takeAction(duplicatePlayer)
            end
        end
    end
end


function OnPreJoin(player_index)
    local ip = get_var(player_index, "$ip"):match("(%d+.%d+.%d+.%d+)")
    CheckIPs(player_index, ip)
end

function OnScriptUnload()
    -- No actions needed on script unload
end
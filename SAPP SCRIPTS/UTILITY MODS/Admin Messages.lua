--[[
--=====================================================================================================--
Script Name: Admin Join Messages, for SAPP (PC & CE)
Description: Customizable admin-join messages on a per-level basis.

Copyright (c) 2019-2020, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE

~ Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"
local join_message = {} -- do not touch!

-- Configuration [starts]  ---------------------------------------------------------
-- output:          [prefix]        [message] (note: player name is automatically inserted between [prefix] and [message])
join_message[1] = { "[TRIAL-MOD] ", " joined the server. Everybody hide!" }
join_message[2] = { "[MODERATOR] ", " just showed up. Hold my beer!" }
join_message[3] = { "[ADMIN] ", " just joined. Hide your bananas!" }
join_message[4] = { "[SENIOR-ADMIN] ", " joined the server." }
join_message.clan_leaders = {
    ["127.0.0.1"] = { "[CLAN LEADER] ", " joined the server." },
    ["192.168.1.1"] = { "[CLAN LEADER] ", " joined the server." },
    -- repeat structure to add more entries...,
}

local environment = 'chat' -- valid environments: "chat", "rcon"

local alignment = "|l" -- Left = l, Right = r, Center = c, Tab: t
-- Configuration [ends] ------------------------------------------------------------

local SAPPFunc
function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    if (environment == "chat") then
        SAPPFunc = say
    elseif (environment == "rprint") then
        SAPPFunc = rprint
    end
end

local function IsClanLeader(IP)
    for ip, v in pairs(join_message.clan_leaders) do
        if (IP == ip) then
            return v
        end
    end
    return false
end

function OnPlayerConnect(p)
    local name, lvl = get_var(p, "$name"), tonumber(get_var(p, "$lvl"))
    if (lvl >= 1) then

        local msg = ""
        local ip = get_var(p, '$ip'):match("%d+.%d+.%d+.%d+")
        local leader = IsClanLeader(ip)

        if (not leader) then
            msg = "|" .. alignment .. " " .. join_message[lvl][1] .. name .. join_message[lvl][2]
        else
            msg = "|" .. alignment .. " " .. leader[1] .. name .. leader[2]
        end

        for i = 1, 16 do
            if (i ~= p and player_present(i)) then
                SAPPFunc(i, msg)
            end
        end
    end
end

function OnScriptUnload()

end
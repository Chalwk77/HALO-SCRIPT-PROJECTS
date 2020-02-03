--[[
--=====================================================================================================--
Script Name: Admin Join Messages, for SAPP (PC & CE)
Description: Customize admin join messages on a per-admin-level basis.

-- Change Log: 16/07/2019
   1). Added new option 'alignment' - specify where messages are displayed on screen.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Written by Jericho Crosby (Chalwk)

- This script is included in the Velocity Multi-Mod with many improvements.
--=====================================================================================================--
]]--
api_version = "1.11.0.0"
local join_message = {} -- do not touch!

-- Configuration [starts]
-- output:            [prefix]              [message] (note: player name is automatically inserted between [prefix] and [message])
join_message[1] = { "[TRIAL-MOD] ", " joined the server. Everybody hide!" }
join_message[2] = { "[MODERATOR] ", " just showed up. Hold my beer!" }
join_message[3] = { "[ADMIN] ", " just joined. Hide your bananas!" }
join_message[4] = { "[SENIOR-ADMIN] ", " joined the server." }

local alignment = "|l" -- Left = l, Right = r, Center = c, Tab: t
-- Configuration [ends]


-- do not touch below this point unless you know what you're doing
function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
end

function OnScriptUnload()

end

function OnPlayerJoin(p)
    local name, lvl = get_var(p, "$name"), tonumber(get_var(p, "$lvl"))
    if (lvl >= 1) then
        local msg = "|" .. alignment .. " " .. join_message[lvl][1] .. name .. join_message[lvl][2]
        announceJoin(msg)
    else
        return false
    end
end

function announceJoin(msg)
    for i = 1, 16 do
        if player_present(i) then
            rprint(i, msg)
        end
    end
end

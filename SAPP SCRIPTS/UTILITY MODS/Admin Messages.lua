--[[
--=====================================================================================================--
Script Name: Admin Join Messages, for SAPP (PC & CE)
Description: Customize admin join messages on a per-admin-level basis.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--
api_version = "1.11.0.0"
custom_messages = {} -- do not touch

-- Configuration [starts]
-- output:            [prefix]              [message] (note: player name is automatically inserted between [prefix] and [message])
custom_messages[1] = {"[TRIAL-MOD] ",       " joined the server. Everybody hide!"}
custom_messages[2] = {"[MODERATOR] ",       " just showed up. Hold my beer!"}
custom_messages[3] = {"[ADMIN] ",           " just joined. Hide your bananas!"}
custom_messages[4] = {"[SENIOR-ADMIN] ",    " joined the server."}
-- Configuration [ends]

-- do not touch below this point unless you know what you're doing
function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
end

function OnScriptUnload()

end

function OnPlayerJoin(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local admin_level = tonumber(get_var(PlayerIndex, "$lvl"))
    local join_message = custom_messages[admin_level][1] .. name .. custom_messages[admin_level][2]
    if (admin_level < 1) then
        return false
    end
    announceJoin(join_message)
end

function announceJoin(join_message)
    for i = 1,16 do
        if player_present(i) then
            rprint(i, join_message)
        end
    end
end


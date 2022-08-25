--[[
--=====================================================================================================--
Script Name: AntiImpersonator, for SAPP (PC & CE)
Description: Prevent other players from impersonating your community members.

Copyright (c) 2016-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration --
local settings = {

    -- Default action to take against people who are caught impersonating:
    --
    action = "kick", -- Valid actions are 'kick' & 'ban'

    -- Default ban time against impersonators:
    --
    ban_time = 10, -- (In Minutes) -- Set to zero to ban permanently

    -- Punish reason:
    --
    reason = "Impersonating",

    users = {

        ["Chalwk"] = {
            ["127.0.0.1"] = true,
            ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"] = true
        },

        -- repeat the structure to add more entries
        ["name_here"] = {
            ["ip 1"] = true,
            ["ip 2"] = true,
            ["hash1"] = true,
            ["hash2"] = true,
            ["hash3"] = true,
            ["etc..."] = true,
        }
    }
}
-- Configuration Ends --

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnJoin")
end

function OnJoin(Ply)

    local name = get_var(Ply, '$name')
    local hash = get_var(Ply, '$hash')
    local ip = get_var(Ply, "$ip"):match('%d+.%d+.%d+.%d+')

    local data = settings.users[name]
    if (data) then

        if (data[hash] or data[ip]) then
            return
        end

        local action = settings.action
        local reason = settings.reason
        local ban_time = settings.ban_time

        if (action == 'kick') then
            execute_command('k ' .. Ply .. ' "' .. reason .. '"')
            cprint(name .. ' was kicked for ' .. reason, 12)
        elseif (action == 'ban') then
            execute_command("b " .. Ply .. ' ' .. ban_time .. ' "' .. reason .. '"')
            cprint(name .. ' was banned for ' .. ban_time .. ' minutes for ' .. reason, 12)
        end
    end
end

function OnScriptUnload()
    -- N/A
end

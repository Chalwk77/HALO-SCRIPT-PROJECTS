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

local settings = {

    -------------------
    -- config starts --
    -------------------

    -- Default action to take against people who are caught impersonating:
    -- Valid actions are 'kick' & 'ban'
    --
    action = 'kick',

    -- Default ban time against impersonators:
    --
    ban_time = 10, -- (In Minutes) -- Set to zero to ban permanently

    -- Punish reason:
    --
    reason = 'Impersonating',

    --
    -- Add your community members here:
    --

    users = {

        -- Example:
        -- If a player joins the server with the name "ExampleGamerTag" and they are not on this list,
        -- they will be kicked or banned (depending on the action you set above).
        -- They must also join with the same IP address or hash as the one you have listed here.
        -- Each entry can have multiple IP addresses or hashes.

        ['ExampleGamerTag'] = {
            ['127.0.0.1'] = true,
            ['127.0.0.2'] = true,
            ['xxxxxxxxxxxxxxxxxxxxxxxxxxxx01'] = true,
            ['xxxxxxxxxxxxxxxxxxxxxxxxxxxx02'] = true,
        },

        -- repeat the structure to add more entries
        ['name_here'] = {
            ['ip 1'] = true,
            ['ip 2'] = true,
            ['hash1'] = true,
            ['hash2'] = true,
            ['hash3'] = true,
            ['etc...'] = true,
        }
    }
}
-- Configuration Ends --

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
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
            execute_command('b ' .. Ply .. ' ' .. ban_time .. ' "' .. reason .. '"')
            cprint(name .. ' was banned for ' .. ban_time .. ' minutes for ' .. reason, 12)
        end
    end
end

function OnScriptUnload()
    -- N/A
end
--[[
--=====================================================================================================--
Script Name: AntiImpersonator for SAPP (PC & CE)
Description: Prevent other players from impersonating your community members.

Copyright (c) 2019-2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Configuration -----------------------------------------------------------------
api_version = "1.12.0.0"
local config = {

    -- Default action against people caught impersonating
    -- Valid actions: 'kick' or 'ban'
    action = 'kick',

    -- Default ban time for impersonators (in minutes)
    -- Set to zero to ban permanently
    banTime = 10,

    -- Reason for punishment
    punishmentReason = 'Impersonating',

    -- List your community members below:
    members = {
        -- Example:
        ['ExampleGamerTag'] = {
            ['127.0.0.1'] = true,
            ['127.0.0.2'] = true,
            ['xxxxxxxxxxxxxxxxxxxxxxxxxxxx01'] = true,
            ['xxxxxxxxxxxxxxxxxxxxxxxxxxxx02'] = true,
        },

        -- Add more entries with the same structure:
        ['name_here'] = {
            ['ip1'] = true,
            ['ip2'] = true,
            ['hash1'] = true,
            ['hash2'] = true,
            ['hash3'] = true,
            ['etc...'] = true,
        }
    }
}
-- End of configuration ------------------------------------------------------------

function OnScriptLoad()
    -- Register event callback:
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
end

-- Handle player join event:
function OnJoin(id)
    
    local name = get_var(id, '$name')
    local hash = get_var(id, '$hash')
    local IP = get_var(id, "$ip"):match('%d+.%d+.%d+.%d+')

    local memberData = config.members[name]
    if (memberData) then

        if (memberData[hash] or memberData[IP]) then
            -- Player's identity matches, no further action required
            return
        end

        local action = config.action
        local reason = config.punishmentReason
        local banTime = config.banTime

        if (action == 'kick') then
            -- Kick the impersonator:
            execute_command('k ' .. id .. ' "' .. reason .. '"')
            -- Print a message in the console
            cprint(name .. ' was kicked for ' .. reason, 12)
        elseif (action == 'ban') then
            -- Ban the impersonator:
            execute_command('b ' .. id .. ' ' .. banTime .. ' "' .. reason .. '"')
            -- Print a message in the console
            cprint(name .. ' was banned for ' .. banTime .. ' minutes for ' .. reason, 12)
        end
    end
end

function OnScriptUnload()
    -- Nothing to do here
end
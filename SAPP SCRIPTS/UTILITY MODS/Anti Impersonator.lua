--[[
--=====================================================================================================--
Script Name: AntiImpersonator for SAPP (PC & CE)
Description: Prevent other players from impersonating your community members.

Copyright (c) 2019-2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]

-- Configuration -----------------------------------------------------------------
api_version = "1.12.0.0"

local config = {
    -- Default action against impersonators (valid actions: 'kick' or 'ban'):
    action = 'kick',

    -- Default ban duration for impersonators (in minutes). Set to 0 for permanent ban:
    ban_duration = 10,

    -- Reason for punishment:
    punishment_reason = 'Impersonating',

    -- Community members list with their corresponding IPs and hashes:
    members = {
        -- Example:
        ['ExampleGamerTag'] = {
            ['127.0.0.1'] = true,
            ['127.0.0.2'] = true,
            ['xxxxxxxxxxxxxxxxxxxxxxxxxxxx01'] = true,
            ['xxxxxxxxxxxxxxxxxxxxxxxxxxxx02'] = true,
        },

        -- Add more members with this structure:
        ['name_here'] = {
            ['ip1'] = true,
            ['ip2'] = true,
            ['hash1'] = true,
            ['hash2'] = true,
            ['hash3'] = true,
        }
    }
}
-- End of configuration ------------------------------------------------------------

-- Called when the script loads
function OnScriptLoad()
    -- Register the join event callback:
    register_callback(cb['EVENT_JOIN'], 'OnPlayerJoin')
end

-- Helper function to handle kicking or banning a player:
local function perform_action(player_id, action, reason, ban_duration)
    if action == 'kick' then
        -- Kick the player:
        execute_command('k ' .. player_id .. ' "' .. reason .. '"')
        cprint('Player ID: ' .. player_id .. ' was kicked for ' .. reason, 12)
    elseif action == 'ban' then
        -- Ban the player:
        execute_command('b ' .. player_id .. ' ' .. ban_duration .. ' "' .. reason .. '"')
        cprint('Player ID: ' .. player_id .. ' was banned for ' .. ban_duration .. ' minutes for ' .. reason, 12)
    end
end

-- Helper function to extract the player's IP address:
local function extract_ip(ip_address)
    return ip_address:match('%d+%.%d+%.%d+%.%d+')
end

-- Called when a player joins the server:
function OnPlayerJoin(player_id)
    local player_name = get_var(player_id, '$name')
    local player_hash = get_var(player_id, '$hash')
    local player_ip = extract_ip(get_var(player_id, "$ip"))

    -- Check if the player's name matches a registered community member:
    local member_data = config.members[player_name]
    if member_data then
        -- Check if the IP or hash matches the registered member's data:
        if member_data[player_hash] or member_data[player_ip] then
            -- Player's identity is valid, no action required:
            return
        end

        -- If we reach this point, the player is impersonating a registered member.
        perform_action(player_id, config.action, config.punishment_reason, config.ban_duration)
    end
end

function OnScriptUnload()
    -- N/A
end
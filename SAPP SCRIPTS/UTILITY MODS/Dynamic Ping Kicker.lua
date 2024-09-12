--[[
--=====================================================================================================--
Script Name: Dynamic Ping Kicker, for SAPP (PC & CE)
Description: An advanced ping kicker with limits based on player count.
             See config section for more details.

Copyright (c) 2020-2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

-- Configuration section:
local PingKicker = {
    check_interval = 5, -- How often to check player pings (in seconds)
    warnings = 5, -- Number of warnings before kicking
    grace_period = 20, -- Grace period to reset warnings (in seconds)
    default_limit = 1000, -- Default ping limit
    admin_immunity = true, -- Exclude admins from ping kicking
    admin_level = 1, -- Admin level for immunity
    limits = { -- Dynamic ping limits based on player count
        { 1, 4, 750 },
        { 5, 8, 450 },
        { 9, 12, 375 },
        { 13, 16, 200 }
    },
    kick_message = 'Ping is too high! Limit: $limit (ms), Your Ping: $ping (ms).',
    grace_period_expired = 'Grace period expired. Ping warnings reset.',
    warning_message = {
        '--- [ HIGH PING WARNING ] ---',
        'Ping is too high! Limit: $limit (ms), Your Ping: $ping (ms).',
        'Please try to lower it if possible.',
        'Warnings Left: $strikes/$max_warnings'
    }
}

local limit
local game_running
local players = {}
local clock = os.clock

-- Register script events
function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_TICK'], 'CheckPings')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

-- Initialize a new player
function PingKicker:NewPlayer(o)
    setmetatable(o, { __index = self })
    self.__index = self
    o.strikes = self.warnings
    o.check = clock() + self.check_interval
    return o
end

-- Get the current ping limit based on player count
function PingKicker:GetLimit()
    for _, limit_data in ipairs(self.limits) do
        local min, max, this_limit = table.unpack(limit_data)
        if #players >= min and #players <= max then
            return this_limit
        end
    end
    return self.default_limit
end

-- Get the player's ping
function PingKicker:GetPing()
    return tonumber(get_var(self.id, '$ping'))
end

-- Check if the player is immune to ping kicking
function PingKicker:Immune()
    local lvl = tonumber(get_var(self.id, '$lvl'))
    return self.admin_immunity and lvl >= self.admin_level
end

-- Handle game start event
function OnStart()
    game_running = false
    if get_var(0, '$gt') ~= 'n/a' then
        game_running = true
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
        timer(1000 * PingKicker.check_interval, 'CheckPings')
    end
end

-- Handle game end event
function OnEnd()
    game_running = false
end

-- Send a warning message to the player
function PingKicker:SendWarning(ping)
    for _, msg in ipairs(self.warning_message) do
        local formatted_msg = msg:gsub('$ping', ping)
                                 :gsub('$limit', limit)
                                 :gsub('$strikes', self.strikes)
                                 :gsub('$max_warnings', self.warnings)
        rprint(self.id, formatted_msg)
    end
end

-- Kick the player for high ping
function PingKicker:Kick(ping)
    local msg = self.kick_message:gsub('$ping', ping):gsub('$limit', limit)
    execute_command('k ' .. self.id .. ' "' .. msg .. '"')
end

-- Notify the player that the grace period has expired
function PingKicker:NotifyGracePeriodExpired()
    rprint(self.id, self.grace_period_expired)
end

-- Check player pings and take appropriate actions
function CheckPings()
    if game_running then
        for _, player in pairs(players) do
            if not player:Immune() then
                if clock() >= player.check then
                    player.check = clock() + player.check_interval
                    local ping = player:GetPing()
                    if ping > limit then
                        if player.strikes == 0 then
                            player:Kick(ping)
                        else
                            player.grace = clock() + player.grace_period
                            player.strikes = player.strikes - 1
                            player:SendWarning(ping)
                        end
                    end
                elseif player.grace and clock() >= player.grace then
                    player.strikes = player.warnings
                    player.grace = nil
                    player:NotifyGracePeriodExpired()
                end
            end
        end
    end
end

-- Handle player join event
function OnJoin(playerIndex)
    players[playerIndex] = PingKicker:NewPlayer({
        id = playerIndex,
        name = get_var(playerIndex, '$name'),
        grace = clock() + PingKicker.grace_period
    })
    limit = PingKicker:GetLimit()
end

-- Handle player leave event
function OnQuit(playerIndex)
    players[playerIndex] = nil
    limit = PingKicker:GetLimit()
end

-- Placeholder function for script unload event
function OnScriptUnload()
    -- N/A
end
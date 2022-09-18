--[[
--=====================================================================================================--
Script Name: Dynamic Ping Kicker, for SAPP (PC & CE)
Description: An advanced ping kicker.

            Ping limits based on player count.
            See config section for more details.

Copyright (c) 2020-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

-- config starts --
local PingKicker = {

    -- How often to check player pings (in seconds):
    -- Default: 5s
    --
    check_interval = 5,

    -- Players will be warned this many times before being kicked:
    -- Default: 5
    --
    warnings = 5,

    -- Reset a player's warnings if their ping has been below the current limit for this many seconds:
    -- Default: 20s
    --
    grace_period = 20,

    -- Default ping limit:
    -- Default: 1000
    --
    default_limit = 1000,

    -- Exclude admins from ping kicking?
    -- Default: true
    --
    admin_immunity = true,

    -- Admins with a level >= this level will be excluded from ping kicking.
    -- Default: 1
    --
    admin_level = 1,

    -- Dynamic ping limit based on player count:
    -- Min Players, Max Players, Ping Limit:
    --
    limits = {
        { 1, 4, 750 }, -- 1 to 4 players (if 750+ ping)

        { 5, 8, 450 }, -- 5 to 8 players (if 450+ ping)

        { 9, 12, 375 }, -- 9 to 12 players (if 375+ ping)

        { 13, 16, 200 }     -- 13 to 16 players (if 200+ ping)
    },

    -- This message will be sent to the player when kicked:
    --
    kick_message = 'Ping is too high! Limit: $limit (ms), Your Ping: $ping (ms).',

    -- This message will be sent to the player if their ping has been
    -- below the current limit for the grace period:
    --
    grace_period_expired = 'Grace period expired. Ping warnings reset.',

    -- Send this multi-line message to the player when they're warned:
    --
    warning_message = {
        '--- [ HIGH PING WARNING ] ---',
        'Ping is too high! Limit: $limit (ms), Your Ping: $ping (ms).',
        'Please try to lower it if possible.',
        'Warnings Left: $strikes/$max_warnings'
    }
}
-- config ends --

local limit
local game_running
local players = { }
local clock = os.clock

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_TICK'], 'CheckPings')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

function PingKicker:NewPlayer(o)

    setmetatable(o, { __index = self })
    self.__index = self

    o.strikes = self.warnings
    o.check = clock() + self.check_interval

    return o
end

function PingKicker:GetLimit()

    for i = 1, #self.limits do

        local min = self.limits[i][1]
        local max = self.limits[i][2]
        local this_limit = self.limits[i][3]

        if (#players >= min and #players <= max) then
            return this_limit
        end
    end

    -- default ping limit:
    return self.default_limit
end

function PingKicker:GetPing()
    return tonumber(get_var(self.id, '$ping'))
end

function PingKicker:Immune()
    local lvl = tonumber(get_var(self.id, '$lvl'))
    return (self.admin_immunity and lvl >= self.admin_level) or false
end

function OnStart()
    game_running = false
    if (get_var(0, '$gt') ~= 'n/a') then

        game_running, players = true, {}

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end

        timer(1000 * PingKicker.check_interval, 'CheckPings')
    end
end

function OnEnd()
    game_running = false
end

function PingKicker:SendWarning(ping)

    -- Warning message: [table of strings]
    local msg = self.warning_message

    for i = 1, #msg do

        local str = msg[i]            :

        gsub('$ping', ping)           :
        gsub('$limit', limit)         :
        gsub('$strikes', self.strikes):
        gsub('$max_warnings', self.warnings)

        rprint(self.id, str)
    end
end

function PingKicker:Kick(ping)
    local msg = self.kick_message:gsub('$ping', ping):gsub('$limit', limit)
    execute_command('k ' .. self.id .. ' "' .. msg .. '"')
end

function PingKicker:Say(str)
    rprint(self.id, str)
end

function CheckPings()
    if (game_running) then
        for _, v in ipairs(players) do
            if (not v:Immune()) then
                if (clock() >= v.check) then
                    v.check = clock() + v.check_interval
                    local ping = v:GetPing()
                    if (ping > limit) then
                        if (v.strikes == 0) then
                            v:Kick(ping)
                        else
                            v.grace = clock() + v.grace_period
                            v.strikes = v.strikes - 1
                            v:SendWarning(ping)
                        end
                    end
                elseif (v.grace and clock() >= v.grace) then
                    v.strikes = v.warnings
                    v.grace = nil
                    v:Say(v.grace_period_expired)
                end
            end
        end
    end
end

function OnJoin(Ply)

    players[Ply] = PingKicker:NewPlayer({
        id = Ply,
        name = get_var(Ply, '$name'),
        grace = clock() + PingKicker.grace_period
    })

    -- update limit:
    limit = PingKicker:GetLimit()
end

function OnQuit(Ply)

    players[Ply] = nil

    -- update limit:
    limit = PingKicker:GetLimit()
end

function OnScriptUnload()
    -- N/A
end
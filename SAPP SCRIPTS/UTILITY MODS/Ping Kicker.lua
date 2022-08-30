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

local PingKicker = {

    -- Players will be warned this many times before being kicked:
    -- Default: 5
    warnings = 5,

    -- How often to check player pings:
    -- Default: 5
    --
    check_interval = 5,

    -- This is the games default ping limit:
    -- Default: 1000
    --
    default_limit = 1000,

    -- Exclude admins from ping kicking?
    -- Default: true
    --
    ignore_admins = true,

    -- Admins with a level >= this level will be excluded from ping kicking.
    -- Default: 1
    --
    admin_level = 1,

    -- Dynamic ping limit based on player count:
    -- Min Players, Max Players, Ping Limit:
    --
    limits = {

        { 1, 4,750 }, -- 1 to 4 players (if 750+ ping)

        { 5, 8, 450 }, -- 5 to 8 players (if 450+ ping)

        { 9, 12, 375 }, -- 9 to 12 players (if 375+ ping)

        { 13, 16, 200 }     -- 13 to 16 players (if 200+ ping)
    },

    -- Multi line message to omit when we need to warn a player for high ping:
    warning_message = {
        "--- [ HIGH PING WARNING ] ---",
        "Ping is too high! Limit: $limit (ms), Your Ping: $ping (ms).",
        "Please try to lower it if possible.",
        "Warnings Left: $strikes/$max_warnings"
    }
}

local limit
local players = { }
local time = os.time

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
end

function PingKicker:NewPlayer(o)

    setmetatable(o, { __index = self })
    self.__index = self

    o.strikes = self.warnings

    o:NewTimer()

    return o
end

function PingKicker:NewTimer()
    self.start = time
    self.finish = time() + self.check_interval
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

function PingKicker:OnJoin(Ply)

    players[Ply] = self:NewPlayer({
        id = Ply,
        name = get_var(Ply, '$name')
    })

    -- Update limit:
    limit = self:GetLimit()
end

function PingKicker:Ignore()
    local lvl = tonumber(get_var(self.id, '$lvl'))
    return (lvl >= self.admin_level)
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
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

function OnTick()
    for i, v in ipairs(players) do
        if (not v:Ignore() and v.start() > v.finish) then
            v:NewTimer()

            local ping = v:GetPing()
            if (ping > limit) then

                if (v.strikes == 0) then
                    execute_command('k ' .. i .. ' "' .. v.name .. ' was kicked for high ping"')
                else
                    v.strikes = v.strikes - 1
                    v:SendWarning(ping)
                end
            end
        end
    end
end

function OnJoin(Ply)
    PingKicker:OnJoin(Ply)
end

function OnQuit(Ply)
    players[Ply] = nil

    -- update limit:
    PingKicker:GetLimit()
end

function OnScriptUnload()
    -- N/A
end
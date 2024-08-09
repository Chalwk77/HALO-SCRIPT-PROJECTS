--[[
--=====================================================================================================--
Script Name: Suicide Punisher, for SAPP (PC & CE)
Description: If a player excessively commits suicide this script will kick or ban them (see config).

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]] --

-- config start --
local Suicide = {

    -- A player will be kicked or banned if they commit suicide this many times
    -- within 30 seconds:
    threshold = 5,

    -- Suicide grace period:
    grace = 30, -- In Seconds

    -- Action to take on players who excessively suicide:
    action = 'kick', -- Valid actions are 'kick' & 'ban'

    -- Ban time (in minutes), set to zero to ban permanently, requires action to be set to ban.
    ban_time = 10,

    -- Kick/Ban reason:
    reason = 'Excessive Suicide'
}
-- config ends --

api_version = '1.12.0.0'

local players
local time = os.time

function Suicide:NewPlayer(o)

    setmetatable(o, self)
    self.__index = self

    o.suicides = 0

    return o
end

function Suicide:TakeAction()
    if (self.action == 'kick') then
        execute_command('k ' .. self.pid .. ' "' .. self.reason .. '"')
        cprint(self.name .. ' was kicked for ' .. self.reason, 12)
    elseif (self.action == 'ban') then
        execute_command('b ' .. self.pid .. ' ' .. self.bantime .. ' "' .. self.reason .. '"')
        cprint(self.name .. ' was banned for ' .. self.reason, 12)
    end
end

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
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

function OnJoin(P)
    players[P] = Suicide:NewPlayer({ pid = P, name = get_var(P, '$name') })
end

function OnQuit(P)
    players[P] = nil
end

function OnDeath(Victim, Killer)

    local killer = tonumber(Killer)
    local victim = tonumber(Victim)
    local v = players[victim]

    if (v and killer == victim) then
        v.suicides = v.suicides + 1
        if (v.suicides >= v.threshold) then
            v:TakeAction()
        else
            v.start = time
            v.finish = time() + v.grace
        end
    end
end

function OnTick()
    for i, v in pairs(players) do
        if (i and player_present(i) and v.start and v.start() >= v.finish) then
            v.start, v.finish, v.suicides = nil, nil, 0
        end
    end
end

function OnScriptUnload()
    -- N/A
end

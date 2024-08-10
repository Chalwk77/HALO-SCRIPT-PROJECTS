--=====================================================================================================--
-- Script Name: Suicide Punisher for SAPP (PC & CE)
-- Description: If a player excessively commits suicide, this script will kick or ban them (see config).
--
-- Copyright (c) 2022-2024, Jericho Crosby <jericho.crosby227@gmail.com>
-- Notice: You can use this script subject to the following conditions:
--         https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
-- Configure the script behavior
local Suicide = {
    threshold = 5, -- Number of suicides within the grace period to trigger the action
    grace = 30, -- Grace period in seconds
    action = 'kick', -- Valid actions are 'kick' and 'ban'
    ban_time = 10, -- Ban time in minutes. Set to zero for permanent ban.
    reason = 'Excessive Suicide'
}

api_version = "1.12.0.0"
-- Local variables and functions
local players
local os = _G.os
local time = os.time
local Suicide_mt = {
    __index = Suicide,
    newPlayer = function(self, o)
        setmetatable(o, self)
        o.suicides = 0
        return o
    end,
    takeAction = function(self)
        if self.action == 'kick' then
            execute_command('k ' .. self.id .. ' "' .. self.reason .. '"')
            cprint(self.name .. ' was kicked for ' .. self.reason, 12)
        elseif self.action == 'ban' then
            execute_command('b ' .. self.id .. ' ' .. self.ban_time .. ' "' .. self.reason .. '"')
            cprint(self.name .. ' was banned for ' .. self.reason, 12)
        end
    end
}

-- Event handlers
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

function OnStart()
    players = {}
    if get_var(0, "$gt") ~= "n/a" then
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnJoin(playerIndex)
    players[playerIndex] = Suicide_mt.newPlayer({ id = playerIndex, name = get_var(playerIndex, "$name") })
end

function OnQuit(playerIndex)
    players[playerIndex] = nil
end

function OnDeath(victimIndex, killerIndex)
    local killer = tonumber(killerIndex)
    local victim = tonumber(victimIndex)
    local victimPlayer = players[victim]

    if victimPlayer and killer == victim then
        victimPlayer.suicides = victimPlayer.suicides + 1

        if victimPlayer.suicides >= victimPlayer.threshold then
            victimPlayer:takeAction()
        else
            victimPlayer.start = time()
            victimPlayer.finish = time() + victimPlayer.grace
        end
    end
end

function OnTick()
    for playerIndex, playerData in pairs(players) do
        if player_present(playerIndex) and playerData.start and time() >= playerData.finish then
            playerData.start, playerData.finish, playerData.suicides = nil, nil, 0
        end
    end
end

-- No action is required when the script is unloaded
function OnScriptUnload()
    -- N/A
end

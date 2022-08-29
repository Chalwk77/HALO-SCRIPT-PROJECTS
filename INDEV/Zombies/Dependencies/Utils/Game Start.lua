-- Zombies [Game Start Checker File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Game = {}
local time = os.time

function Game:GameStartCheck(quit)

    local pn = tonumber(get_var(0, '$pn'))
    pn = (quit and pn - 1) or pn

    local req = (pn >= self.required_players)
    local pre_game = (req and not self.game_started)

    if (not req and self.show_not_enough_players_message) then
        self:StartStopTimer('NotEnoughPlayers')

    elseif (pre_game and not self.timers['PreGame'].run) then
        self:StartStopTimer('PreGame', self.game_start_delay)

    elseif (self.game_started) then

        if (self.team ~= self.zombie_team) then
            self:SwitchTeam(self.zombie_team)
        end

        self:StartStopTimer()
    end
end

local function ClearConsole(p)
    for _ = 1, 25 do
        rprint(p, ' ')
    end
end

local function ConsolePrintAll(msg)
    for i = 1, 16 do
        if player_present(i) then
            ClearConsole(i)
            rprint(i, msg)
        end
    end
end

function Game:Timers()
    for type, v in pairs(self.timers) do
        if (v.run) then
            if (type == 'NotEnoughPlayers') then
                local pn = #self.players
                local req = self.required_players
                local msg = self.messages.not_enough_players
                ConsolePrintAll(msg:gsub('$current', pn):gsub('$required', req))
            elseif (type == 'PreGame') then
                if (v.start() < v.finish) then
                    local msg = self.messages.pre_game_message
                    local _time = v.finish - time()
                    ConsolePrintAll(msg:gsub('$time', _time):gsub('$s', self:Plural(_time)))
                else
                    v.run = false
                    self:ShuffleTeams()
                end
            elseif (type == 'NoZombies') then
                if (v.start() < v.finish) then
                    local msg = self.messages.no_zombies
                    local _time = v.finish - time()
                    ConsolePrintAll(msg:gsub('$time', _time):gsub('$s', self:Plural(_time)))
                else
                    v.run = false
                    self:RandomZombie()
                end
            end
        end
    end
end

function Game:StartStopTimer(t, Interval)
    for k, v in pairs(self.timers) do
        v.run = (k == t)
        v.start = time or 0
        v.finish = time() + (Interval or 0)
    end
end

return Game
-- Zombies [Game Phase Checker File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Game = {}

-- .Checks if we need to end the game.
-- .Sets the last man alive.
-- .Switches random human to zombie team when there are no zombies.

function Game:PhaseCheck()

    -- Returns the number of humans & zombies:
    local humans, zombies = self:GetTeamCounts()

    local team = (self.id and self.team) or ''
    if (team == self.human_team) then
        humans = humans - 1
    elseif (team == self.zombie_team) then
        zombies = zombies - 1
    end

    -- Check for and set last man alive:
    if (humans == 1 and zombies > 0) then
        local msg = self.messages.on_last_man

        for i = 1, 16 do
            local t = self.players[i]
            if (player_present(i) and t and t.team == self.human_team and not self.last_man) then
                self.last_man = i
                self:SayAll(msg:gsub('$name', t.name))
                t:SetAttributes(i)
            end
        end

        -- Announce zombie team won:
    elseif (humans == 0 and zombies >= 1) then
        self:EndTheGame('Zombie')

        -- One player remains | end the game:
    elseif (tonumber(get_var(0, '$pn')) == 1 and self.id) then

        for i = 1, 16 do
            local t = self.players[i]
            if (t and i ~= self.id and player_present(i)) then
                self:EndTheGame(t:GetTeamType())
            end
        end

        -- No zombies left | Select random player to become zombie:
    elseif (zombies <= 0 and humans >= 1) then
        self:StartStopTimer('NoZombies', self.no_zombies_delay)
    end
end

return Game
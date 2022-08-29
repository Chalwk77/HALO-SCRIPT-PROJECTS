-- Zombies [Random Zombie Picker File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Game = {}

function Game:RandomZombie()

    -- Save all players on the human team to the humans array:

    local humans = {}
    for i = 1, 16 do
        local t = self.players[i]
        if (player_present(i) and (t) and t.team == self.human_team) then
            humans[#humans + 1] = t.id
        end
    end

    --Pick a random human (from humans array) to become the zombie:
    local new_zombie = humans[rand(1, #humans + 1)]
    local t = self.players[new_zombie]

    -- Announce:
    --
    local msg = self.messages.no_zombies_switch
    self:SayAll(msg:gsub("$name", t.name))

    -- Set zombie type to Alpha-Zombie:
    t.alpha = true

    -- Switch them:
    t:SwitchTeam(self.zombie_team)

    -- Check game phase:
    self:PhaseCheck()
end

return Game
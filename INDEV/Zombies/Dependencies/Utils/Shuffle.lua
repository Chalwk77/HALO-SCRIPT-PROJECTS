-- Zombies [Shuffle File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Game = {}

local function shuffle(t)
    for i = #t, 2, -1 do
        local j = rand(i) + 1
        t[i], t[j] = t[j], t[i]
    end
    return t
end

local function ClearConsole(p)
    for _ = 1, 25 do
        rprint(p, ' ')
    end
end

function Game:ShuffleTeams()

    local players = { }
    for i = 1, 16 do
        if player_present(i) and self.players[i] then
            players[#players + 1] = i
        end
    end
    players = shuffle(players)

    local zombies = 1
    for _, v in pairs(self.zombie_count) do
        local min, max, count = v[1], v[2], v[3]
        if (#players >= min and #players <= max) then
            zombies = count
        end
    end

    execute_command('sv_map_reset')

    for i, id in pairs(players) do

        ClearConsole(id)
        local t = self.players[id]

        if (i > zombies) then

            -- Set player to human team:
            t:SwitchTeam(self.human_team)

            -- Tell player what team they are on:
            t:PrivateSay(self.messages.on_game_begin[1])
        else
            -- Set zombie type to Alpha-Zombie:
            t.alpha = true

            -- Set player to zombie team:
            t:SwitchTeam(self.zombie_team)

            -- Tell player what team they are on:
            t:PrivateSay(self.messages.on_game_begin[2])
        end
    end

    self.block_death_messages = false
    self.game_started = true
    self:GameObjects(true)
    self:PhaseCheck()
end

return Game
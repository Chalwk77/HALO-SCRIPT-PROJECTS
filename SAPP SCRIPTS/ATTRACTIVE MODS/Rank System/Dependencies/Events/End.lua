-- Rank System [End File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

local function SortTable(t)
    table.sort(t, function(a, b)
        print(a.score, b.score)
        return a.score > b.score
    end)
    return t
end

function Event:OnEnd()

    self.game_over = true
    local t = self.credits.on_end
    local r = tonumber(get_var(0, "$redscore"))
    local b = tonumber(get_var(0, "$bluescore"))

    local res = {}
    for i = 1, 16 do
        if player_present(i) then
            local v = self:GetPlayer(i)
            if (v.logged_in) then
                if (self.ffa) then
                    local kills = tonumber(get_var(i, '$kills'))
                    local score = tonumber(get_var(i, '$score'))
                    local deaths = tonumber(get_var(i, '$deaths'))
                    local assists = tonumber(get_var(i, '$assists'))
                    res[i] = { score = score + kills + assists / deaths, id = i }
                elseif (r > b and v.team == 'red') then
                    v:UpdateCR({ t.team.winner[1], t.team.winner[2] })
                elseif (b > r and v.team == 'blue') then
                    v:UpdateCR({ t.team.loser[1], t.team.loser[2] })
                end
            end
        end
    end

    if (#res > 0) then
        res = SortTable(res)
        local player = self:GetPlayer(res[1].id)
        player:UpdateCR({ t.ffa[1], t.ffa[2] })
    end

    if (self.update_file_database['OnEnd']) then
        self:Update()
    end
end

return Event
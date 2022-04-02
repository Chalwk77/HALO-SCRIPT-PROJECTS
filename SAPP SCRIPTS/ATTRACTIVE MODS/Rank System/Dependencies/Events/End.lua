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
    for _, v in pairs(self.players) do
        if (v.pid and v.logged_in) then
            if (self.ffa) then
                local kills = tonumber(get_var(v.pid, '$kills'))
                local score = tonumber(get_var(v.pid, '$score'))
                local deaths = tonumber(get_var(v.pid, '$deaths'))
                local assists = tonumber(get_var(v.pid, '$assists'))
                res[#res + 1] = { score = score + kills + assists / deaths, player = v }
            elseif (r > b and v.team == 'red') then
                v:UpdateCR({ t.team.winner[1], t.team.winner[2] })
            elseif (b > r and v.team == 'blue') then
                v:UpdateCR({ t.team.loser[1], t.team.loser[2] })
            end
        end
    end

    if (#res > 0) then
        res = SortTable(res)
        res[1].player:UpdateCR({ t.ffa[1], t.ffa[2] })
    end

    if (self.update_file_database['OnEnd']) then
        self:Update()
    end
end

return Event
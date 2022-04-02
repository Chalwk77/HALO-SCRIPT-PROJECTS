-- Rank System [End File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

local function SortResults(t)
    table.sort(t, function(a, b)
        return a.score > b.score
    end)
end

function Event:OnEnd()

    self.game_over = true
    local t = self.credits.on_end

    if (self.ffa) then

        local res = {}
        for _, v in pairs(self.players) do
            if (player_present(v.pid) and v.logged_in) then
                local kills = tonumber(get_var(v.pid, '$kills'))
                local score = tonumber(get_var(v.pid, '$score'))
                local deaths = tonumber(get_var(v.pid, '$deaths'))
                local assists = tonumber(get_var(v.pid, '$assists'))
                res[#res + 1] = { score = kills + score + assists / deaths, id = v.pid }
            end
        end

        local results = SortResults(res)
        if (#results >= 1) then
            local player = self:GetPlayer(results[1].id)
            player:UpdateCR({ t.ffa[1], t.ffa[2] })
        end

    else

        local r = tonumber(get_var(0, "$redscore"))
        local b = tonumber(get_var(0, "$bluescore"))

        for _, v in pairs(self.players) do
            if (player_present(v.pid) and v.logged_in) then
                if (r > b and v.team == 'red') then
                    v:UpdateCR({ t.team.winner[1], t.team.winner[2] })
                elseif (b > r and v.team == 'blue') then
                    v:UpdateCR({ t.team.loser[1], t.team.loser[2] })
                end
            end
        end
    end

    if (self.update_file_database['OnEnd']) then
        self:Update()
    end
end

return Event
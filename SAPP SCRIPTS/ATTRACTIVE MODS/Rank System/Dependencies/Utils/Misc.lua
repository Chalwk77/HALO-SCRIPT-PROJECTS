-- Rank System [Miscellaneous Functions File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Misc = {}

function Misc:SortRanks()
    local results = { }
    for ip, v in pairs(self.database) do
        results[#results + 1] = {
            ip = ip,
            name = v.name,
            rank = v.rank,
            grade = v.grade,
            credits = v.credits
        }
    end
    table.sort(results, function(a, b)
        return a.credits > b.credits
    end)
    return results
end

function Misc:Format(s, nR, nG, rq, pos, tot)
    for k, v in pairs({
        ["$name"] = self.name, --                  Player name       [string]
        ["$rank"] = self.stats.rank, --            Rank (name)       [string]
        ["$grade"] = self.stats.grade, --          Grade (id)        [number]
        ["$credits"] = self.stats.credits, --      Credits (total)   [number]
        ["$prestige"] = self.stats.prestige, --    Prestige (number) [number]
        ["$next_rank"] = nR or nil, --             Next rank (name)  [string]
        ["$next_grade"] = nG or nil, --            Next grade (id)   [number]
        ["$req"] = rq or nil, --                   Credits required to rank up      [number]
        ["$pos"] = pos or nil, --                  Placement (out of total players) [number]
        ["$total"] = tot or nil --                 Total number of player accounts in the json database [number]
    }) do
        s = s:gsub(k, v)
    end
    return s
end

function Misc:ShowExtRankInfo(ip)
    local results = self:SortRanks()
    for j = 1, #results do
        local v = results[j]
        if (v.ip == ip) then

            local pos = j
            local total = #results

            local id = self:GetRankID(v.rank)
            local rank_table = self.ranks[id]
            local grade_table = rank_table.grade

            local msg = self.messages[6]
            local next_grade = v.grade + 1
            local next_rank = self.ranks[id + 1]

            if (grade_table[next_grade]) then
                local req = grade_table[next_grade] - v.credits
                for i = 1, #msg do
                    local m = msg[i]
                    self:Send(self:Format(m, v.rank, next_grade, req, pos, total))
                end
            elseif (next_rank) then
                local req = next_rank.grade[1] - v.credits
                for i = 1, #msg do
                    local m = msg[i]
                    self:Send(self:Format(m, next_rank.rank, 1, req, pos, total))
                end
            else
                self:Send('COMPLETED ALL RANKS. Prestige available!')
            end
            break
        end
    end
end

function Misc:Welcome()

    local msg = self.messages[1]
    self:Send(self:Format(msg[1]))

    if (not self.delay_welcome) then
        self:Send(self:Format(msg[2]), true)
    end
end

function Misc:GetRankID(rank)
    for k, v in pairs(self.ranks) do
        if (v.rank == rank) then
            return k
        end
    end
end

function Misc:GetStartingCredits()

    local ranks = self.ranks
    local sR = self.starting_rank
    local sG = self.starting_grade
    local start = self.starting_credits

    for i = 1, #ranks do
        for k = 1, #ranks[i].grade do
            if (ranks[i].rank == sR and k == sG) then

                local req = ranks[i].grade[k]
                local precede = ranks[i].grade[k - 1] -- before
                local supersede = ranks[i].grade[k + 1] -- after
                local next_rank = ranks[i + 1]

                if (next_rank and start >= next_rank.grade[1]) or
                        (not precede and start < req) or
                        (precede and start < precede) or
                        (supersede and start > supersede) or
                        (not supersede and start >= next_rank.grade[1]) or
                        (start == precede or start == supersede) then
                    return req
                end
            end
        end
    end

    return start
end

function Misc:Send(msg, Global)

    if (Global) then
        for i = 1, #self.players do
            if (i ~= self.pid) then
                rprint(i, msg)
            end
        end
        return
    end

    rprint(self.pid, msg)

end

return Misc
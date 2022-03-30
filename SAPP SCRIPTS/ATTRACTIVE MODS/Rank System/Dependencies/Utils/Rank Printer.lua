local Ranks = {}

function Ranks:SortRanks()
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

function Ranks:ShowRankSorted(ip)
    local results = self:SortRanks()
    for k, v in pairs(results) do
        if (v.ip == ip) then

            local pos = k
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
                    self:Send(self:Format(m, next_grade, req, pos, total))
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

function Ranks:Welcome()

    local msg = self.messages[1]
    self:Send(self:Format(msg[1]))

    if (not self.delay_welcome) then
        self:Send(self:Format(msg[2]), true)
    end
end

function Ranks:GetRankID(rank)
    for k, v in pairs(self.ranks) do
        if (v.rank == rank) then
            return k
        end
    end
end

return Ranks
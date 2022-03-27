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

-- @Param s (message [string])
-- @Param n (name [string])
-- @Param r (rank [string])
-- @Param g (grade [number])
-- @Param c (credits [number])
-- @Param nR (next rank [number])
-- @Param nG (next grade [number])
-- @Param rq (credits required [number])
-- @Param pos (position [number])
-- @Param tot (total [number])
-- @Return (formatted message [string])

function Ranks:STRFormat(s, nR, nG, rq, pos, tot)
    for k, v in pairs({
        ["$name"] = self.name,
        ["$rank"] = self.stats.rank or nil,
        ["$grade"] = self.stats.grade or nil,
        ["$credits"] = self.stats.credits or nil,
        ["$next_rank"] = nR or nil,
        ["$next_grade"] = nG or nil,
        ["$req"] = rq or nil,
        ["$pos"] = pos or nil,
        ["$total"] = tot or nil,
        ["$prestige"] = self.stats.prestige or nil,
    }) do
        s = s:gsub(k, v)
    end
    return s
end

function Ranks:ShowRank(ip, OnJoin)

    local results = self:SortRanks()
    for k, v in pairs(results) do
        if (v.ip == ip) then

            local pos = k
            local total = #results

            if (not OnJoin) then

                --------------------------
                -- /rank command feedback:
                --------------------------

                local id = self:GetRankID(v.rank)
                local rank_table = self.ranks[id]
                local grade_table = rank_table.grade

                local next_grade = v.grade + 1
                local next_rank = self.ranks[id + 1]
                local msg = self.messages[6]

                if (grade_table[next_grade]) then
                    local req = grade_table[next_grade] - v.credits
                    for _, s in pairs(msg) do
                        local str = self:STRFormat(s, next_grade, req, pos, total)
                        self:Send(str) -- private
                    end
                elseif (next_rank) then
                    local req = next_rank.grade[1] - v.credits
                    for _, s in pairs(msg) do
                        local str = self:STRFormat(s, next_rank.rank, 1, req, pos, total)
                        self:Send(str) -- private
                    end
                else
                    self:Send('COMPLETED ALL RANKS. Prestige available!', true)
                end
                break
            else

                -----------------
                -- join message:
                -----------------

                local msg = self.messages[1] -- join message
                local str = self:STRFormat(msg[1])
                self:Send(str) -- private

                str = self:STRFormat(msg[2])
                self:Send(str, true) -- global
                break
            end
        end
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
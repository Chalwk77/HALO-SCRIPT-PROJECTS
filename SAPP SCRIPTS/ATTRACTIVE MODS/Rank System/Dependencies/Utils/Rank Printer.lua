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

function Ranks:STRFormat(s, n, r, g, c, nR, nG, rq, pos, tot)
    for k, v in pairs({
        ["$name"] = n or nil,
        ["$rank"] = r or nil,
        ["$grade"] = g or nil,
        ["$credits"] = c or nil,
        ["$next_rank"] = nR or nil,
        ["$next_grade"] = nG or nil,
        ["$req"] = rq or nil,
        ["$pos"] = pos or nil,
        ["$total"] = tot or nil
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
            local name = self.name
            local rank = v.rank
            local grade = v.grade
            local total = #results
            local credits = v.credits

            if (not OnJoin) then

                --------------------------
                -- /rank command feedback:
                --------------------------

                local id = self:GetRankID(rank)
                local rank_table = self.ranks[id]
                local grade_table = rank_table.grade

                local next_grade = grade + 1
                local next_rank = self.ranks[id + 1]
                local msg = self.messages[6]

                if (grade_table[next_grade]) then
                    local req = grade_table[next_grade] - credits
                    for _, s in pairs(msg) do
                        local str = self:STRFormat(s, name, rank, grade, credits, rank, next_grade, req, pos, total)
                        self:Send(str) -- private
                    end
                elseif (next_rank) then
                    local req = next_rank.grade[1] - credits
                    for _, s in pairs(msg) do
                        local str = self:STRFormat(s, name, rank, grade, credits, next_rank.rank, 1, req, pos, total)
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
                local str = self:STRFormat(msg[1], name, rank, grade, credits)
                self:Send(str) -- private

                str = self:STRFormat(msg[2], name, rank, grade, credits)
                self:Send(str, true) -- global
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
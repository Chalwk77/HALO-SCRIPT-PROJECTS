-- Rank System [Update Rank File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Rank = {}

function Rank:UpdateCR(t)

    local amount = t[1]
    local msg = t[2]

    local stats = self.stats

    stats.credits = stats.credits + amount
    stats.credits = (stats.credits < 0 and 0 or stats.credits)
    self.database[self.ip] = stats

    msg = msg:gsub('$currency_symbol', self.currency_symbol)
    self:Send(msg)

    self:UpdateRank()
end

local function Format(Str, Name, GradeID, RankName)
    local words = { ['$name'] = Name, ['$grade'] = GradeID, ['$rank'] = RankName, }
    for k, v in pairs(words) do
        Str = Str:gsub(k, v)
    end
    return Str
end

function Rank:NewGrade(ply)
    if (ply.next_grade and ply.cR >= ply.req and ply.cR < ply.next_grade) then
        --print('do nothing (1)')
        return false
    elseif (ply.next_grade) then
        for k, v in pairs(ply.cGT) do
            local nG = ply.cGT[k + 1]
            if (k > ply.cG) and (ply.cR >= v and nG and ply.cR < nG) or (not nG and ply.cR >= v) then
                self.stats.grade = k
                self.stats.done[ply.id][k] = true
                --print('level up', ply.rank, 'G'..k)
                return true
            end
        end
        --print('do nothing (2)')
    else
        --print('do nothing (3)')
    end
    return false
end

function Rank:NewRank(ply)

    local next_rank_id = ply.id + 1
    for i = 1, #self.ranks do
        if (i > ply.id and self.ranks[next_rank_id]) then
            local gT = self.ranks[i].grade
            for k, v in pairs(gT) do

                local nG = gT[k + 1]
                local case1 = i >= next_rank_id and ply.cR >= v and nG and ply.cR < nG
                local case2 = i >= next_rank_id and ply.cR >= v and not nG

                if (i == next_rank_id and k == 1 and ply.cR < v) then
                    --print('no rank up')
                    return false
                elseif (case1 or case2) then
                    self.stats.grade = k
                    self.stats.rank = self.ranks[i].rank
                    self.stats.done[i][k] = true
                    --print('rank up', self.ranks[i].rank, 'G' .. k)
                    return true
                end
            end
        end
    end
    return false
end

function Rank:Completed(ply)

    local rid = #self.ranks
    local last_grade = self.ranks[#self.ranks].grade
    local gid = #last_grade
    local req = last_grade[#last_grade]
    if (ply.cR > req and not self.stats.done[rid][gid]) then
        --print('player has completed everything')
        return true
    end

    return false
end

function Rank:UpdateRank()

    local stats = self:GetRankInfo()

    local str
    if (self:NewGrade(stats)) then
        str = self.messages[2]
    elseif (self:NewRank(stats)) then
        str = self.messages[3]
    elseif (self:Completed(stats)) then
        str = self.messages[4]
    end

    if (str) then
        local name = self.name
        local rank = self.stats.rank
        local grade = self.stats.grade
        self:Send(Format(str[1], name, grade, rank))
        self:Send(Format(str[2], name, grade, rank), true)
    end

    --local previous_rank = self.ranks[i - 1]
    --local previous_grade = grade_table[k - 1]
    --
    --if (cR > 0 and cR < req) then
    --
    --    if (previous_grade) then
    --        self.stats.rank, self.stats.grade = stats.rank, k - 1
    --    elseif (previous_rank) then
    --        self.stats.rank, self.stats.grade = previous_rank.rank, #previous_rank.grade
    --    end
    --    self.stats.done[i][k] = false
    --
    --    local str = self.messages[5] -- downgrade message
    --    self:Send(Format(str[1], name, self.stats.grade, self.stats.rank))
    --    self:Send(Format(str[2], name, self.stats.grade, self.stats.rank), true)
    --    goto done
    --end
end

function Rank:GetRankInfo()

    local ranks = self.ranks
    local cR = self.stats.credits --   current credits  (amount [number])
    local cG = self.stats.grade --     current grade    (id     [number])
    local rank = self.stats.rank --    current rank     (name   [string])
    local id = self:GetRankID(rank) -- rank id          (name   [number])

    --[[debugging:
    id = 13  --          rank id             General, G3 > General G4
    cG = 4  --          grade id
    cR = 50001  --      credits
    rank = ranks[id].rank
    --]]

    local cRT = ranks[id] --           current rank table
    local cGT = cRT.grade --           current grade table
    local next_rank = ranks[id + 1] -- next rank table

    local req = cGT[cG]             -- req for current grade
    local next_grade = cGT[cG + 1]  -- req for next grade (if applicable)
    local prev_grade = cGT[cG - 1]  -- req for previous grade (if applicable)

    return {
        id = id,
        cR = cR,
        cG = cG,
        cRT = cRT,
        cGT = cGT,
        req = req,
        rank = rank,
        next_rank = next_rank,
        next_grade = next_grade,
        prev_grade = prev_grade
    }
end

function Rank:SetRankOverride(RankName, RankID, GradeID)

    for i = 1, #self.stats.done do
        local grade_table = self.stats.done[i]
        for k = 1, #grade_table do
            if (i == RankID and k == GradeID) then
                self.stats.done[i][k] = true
                self.stats.credits = self.ranks[i].grade[k]
            elseif (i == RankID and k < GradeID) then
                self.stats.done[i][k] = true
            elseif (i == RankID and k > GradeID or i > RankID) then
                self.stats.done[i][k] = false
            else
                self.stats.done[i][k] = true
            end
        end
    end

    self.stats.rank = RankName
    self.stats.grade = GradeID
    self.database[self.ip] = self.stats
end

return Rank
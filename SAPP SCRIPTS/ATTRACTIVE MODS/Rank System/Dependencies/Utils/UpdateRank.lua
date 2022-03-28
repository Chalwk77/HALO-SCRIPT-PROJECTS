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
                --print('level up', ply.rank, 'grade', k)
                return true
            end
        end
    elseif (ply.next_rank and ply.cR < ply.next_rank.grade[1]) then
        --print('do nothing (2)')
        return false
    end
    return false
end

function Rank:NewRank(ply)

    local next_rank_id = ply.id + 1

    for i = 1, #self.ranks do
        if (i > ply.id) then
            local gT = self.ranks[i].grade
            for k, v in pairs(gT) do
                if (i == next_rank_id and k == 1 and ply.cR < v) then
                    print('not enough credits for next rank | grade 1')
                    break

                end
            end
        end
    end
end

function Rank:UpdateRank()

    local stats = self:GetRankInfo()

    if (self:NewGrade(stats)) then
        local str = self.messages[2]
        self:Send(Format(str[1], self.name, self.stats.grade, self.stats.rank))
        self:Send(Format(str[2], self.name, self.stats.grade, self.stats.rank), true)
    elseif (self:NewRank(stats)) then
        --    local str = self.messages[3]
        --    self:Send(Format(str[1], self.name, self.stats.grade, self.stats.rank))
        --    self:Send(Format(str[2], self.name, self.stats.grade, self.stats.rank), true)
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
    local cRT = ranks[id] --           current rank table
    local cGT = cRT.grade --           current grade table
    local next_rank = ranks[id + 1] -- next rank table

    local req = cGT[cG]             -- req for current grade
    local next_grade = cGT[cG + 1]  -- req for next grade (if applicable)
    local prev_grade = cGT[cG - 1]  -- req for previous grade (if applicable)

    cR = 2999
    cG = 1

    return {
        cR = cR,
        cG = cG,
        id = id,
        cRT = cRT,
        cGT = cGT,
        rank = rank,
        next_rank = next_rank,
        req = req,
        next_grade = next_grade,
        prev_grade = prev_grade,
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
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
    for k, v in pairs(ply.cGT) do
        local nG = ply.cGT[k + 1]
        if (k > ply.cG) and ((ply.cR >= v and nG and ply.cR < nG) or (not nG and ply.cR >= v)) then
            self.stats.grade = k
            --print('level up', ply.rank, 'G'..k)
            return true
        end
    end
    return false
end

function Rank:NewRank(ply)

    local next_rank_id = ply.id + 1
    local ranks = self.ranks
    for i = 1, #ranks do
        if (i > ply.id and ranks[next_rank_id]) then
            local gT = ranks[i].grade
            for k = 1, #gT do

                local v = gT[k]
                local nG = gT[k + 1]
                local case1 = (i >= next_rank_id and ply.cR >= v and nG and ply.cR < nG)
                local case2 = (i >= next_rank_id and ply.cR >= v and not nG)

                if (i == next_rank_id and k == 1 and ply.cR < v) then
                    --print('no rank up')
                    return false
                elseif (case1 or case2) then
                    self.stats.grade = k
                    self.stats.rank = ranks[i].rank
                    --print('rank up', self.ranks[i].rank, 'G' .. k)
                    return true
                end
            end
        end
    end
    return false
end

function Rank:Downgrade(ply)

    -- loop backwards from current rank id:

    local less_than_req = (ply.cR < ply.req)
    if (less_than_req) then
        local ranks = self.ranks
        for i = ply.id, 1, -1 do
            for k = 1, #ranks[i].grade do
                local v = ranks[i].grade[k]
                if (ply.cR >= v and ply.cR < ply.req) then
                    self.stats.rank = ranks[i].rank
                    self.stats.grade = k
                    --print('downgrade: ' .. ranks[i].rank, 'G' .. k)
                    return true
                end
            end
        end
    end
    return false
end

function Rank:Completed(ply)

    local ranks = self.ranks
    local last_grade = ranks[#ranks].grade
    local req = last_grade[#last_grade]
    if (ply.cR > req and not self.done) then
        self.done = true
        --print('player has completed everything')
        return true
    end

    return false
end

function Rank:UpdateRank()

    local str
    local stats = self:GetRankInfo()

    if (self:NewGrade(stats)) then
        str = self.messages[2]
    elseif (self:NewRank(stats)) then
        str = self.messages[3]
    elseif (self:Completed(stats)) then
        str = self.messages[4]
    elseif (self:Downgrade(stats)) then
        str = self.messages[5]
    end

    if (str) then
        local name = self.name
        local rank = self.stats.rank
        local grade = self.stats.grade
        self:Send(Format(str[1], name, grade, rank))
        self:Send(Format(str[2], name, grade, rank), true)
    end
end

function Rank:GetRankInfo()

    local ranks = self.ranks
    local cR = self.stats.credits --   current credits  (amount [number])
    local cG = self.stats.grade --     current grade    (id     [number])
    local rank = self.stats.rank --    current rank     (name   [string])
    local id = self:GetRankID(rank) -- rank id          (name   [number])

    --[[debugging:
    id = 3  --         rank id        Private G2 < Apprentice G1
    cG = 2  --         grade id
    cR = 3500  --         credits
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

return Rank
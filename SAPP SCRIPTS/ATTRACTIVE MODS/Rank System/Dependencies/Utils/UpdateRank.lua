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

function Rank:UpdateRank()

    local name = self.name
    local cr = self.stats.credits

    for i = 1, #self.ranks do

        local stats = self.ranks[i]
        for k = 1, #stats.grade do

            -- credits required:
            local req = stats.grade[k]

            -- rank/grade combo not completed yet:
            if (not self.stats.done[i][k]) then

                local next_rank = self.ranks[i + 1]
                --local next_grade = (stats.grade[k + 1])
                local last_grade = stats.grade[#stats.grade]

                -- all ranks completed:
                local ranks_complete = (cr > last_grade and not next_rank)

                -- rank complete:
                local rank_up = (cr >= req and stats.rank ~= self.stats.rank)
                if (ranks_complete) then

                    self.stats.rank, self.stats.grade = stats.rank, #stats.grade
                    self.stats.done[i][#stats.grade] = true

                    local str = self.messages[4]
                    self:Send(Format(str[1], name, k, stats.rank))
                    self:Send(Format(str[2], name, k, stats.rank), true)
                    goto done

                elseif (rank_up) then

                    self.stats.rank, self.stats.grade = stats.rank, k
                    self.stats.done[i][k] = true

                    local str = self.messages[3]

                    self:Send(Format(str[1], name, k, stats.rank))
                    self:Send(Format(str[2], name, k, stats.rank), true)
                    goto done
                else

                    self.stats.rank, self.stats.grade = stats.rank, k
                    self.stats.done[i][k] = true

                    local str = self.messages[2]

                    self:Send(Format(str[1], name, k, stats.rank))
                    self:Send(Format(str[2], name, k, stats.rank), true)
                    goto done
                end

                -- downgrade rank:
            elseif (stats.rank == self.stats.rank and k == self.stats.grade) then

                local previous_rank = self.ranks[i - 1]
                local previous_grade = stats.grade[k - 1]

                if (cr > 0 and cr < req) then

                    if (previous_grade) then
                        self.stats.rank, self.stats.grade = stats.rank, k - 1
                    elseif (previous_rank) then
                        self.stats.rank, self.stats.grade = previous_rank.rank, #previous_rank.grade
                    end
                    self.stats.done[i][k] = false

                    local str = self.messages[5] -- downgrade message
                    self:Send(Format(str[1], name, self.stats.grade, self.stats.rank))
                    self:Send(Format(str[2], name, self.stats.grade, self.stats.rank), true)
                    goto done
                end
            end
        end
    end

    :: done ::
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
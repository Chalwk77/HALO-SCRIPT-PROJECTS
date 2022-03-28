-- Rank System [Format Placeholders File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local STR = {}

function STR:Format(s, nR, nG, rq, pos, tot)
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

return STR
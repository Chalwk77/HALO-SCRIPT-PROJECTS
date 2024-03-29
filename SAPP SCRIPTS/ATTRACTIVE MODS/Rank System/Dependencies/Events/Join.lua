-- Rank System [Join Event File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

function Event:Join(Ply)

    local ip = self:GetIP(Ply)
    local name = get_var(Ply, '$name')
    local team = get_var(Ply, '$team')
    local defaults = { pid = Ply, avenge = {}, team = team, name = name }

    if (not self.players[ip]) then
        self.players[ip] = self:NewPlayer(defaults)
    else
        self.players[ip]:UpdateCachedSession(defaults)
    end

    -- for debugging rank-up logic:
    --RankSystem:GetPlayer(P):UpdateCR({ 10, '' })
end

function Event:NewPlayer(o)

    setmetatable(o, self)
    self.__index = self

    o.meta_id = 0
    o.headshot = false
    o.logged_in = false

    o.stats = {
        prestige = 0,
        rank = self.starting_rank,
        grade = self.starting_grade,
        credits = self.starting_credits
    }

    return o
end

return Event
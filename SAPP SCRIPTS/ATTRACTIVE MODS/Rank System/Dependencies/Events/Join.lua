-- Rank System [Join Event File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

function Event:NewPlayer(o)

    setmetatable(o, self)
    self.__index = self

    local stats = self.database
    if (not stats[o.ip]) then
        stats[o.ip] = {
            prestige = 0,
            name = o.name,
            rank = self.starting_rank,
            grade = self.starting_grade,
            credits = self.starting_credits
        }
    end
    self.database = stats -- update database

    o.meta_id = 0
    o.stats = stats[o.ip]
    o:Welcome()

    if (self.update_file_database['OnJoin']) then
        self:Update()
    end

    return o
end

return Event
-- Rank System [On Score File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

function Event:OnScore()
    local t = self.credits.event_score[self.gt]
    self:UpdateCR({ t[1], t[2] })
end

return Event
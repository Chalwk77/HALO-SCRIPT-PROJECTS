-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Time = {}

function Time:getBestTime()
    local data = self.database[self.ip].times[self.map]
    return data[1] and data[1] or "N/A"
end

return Time
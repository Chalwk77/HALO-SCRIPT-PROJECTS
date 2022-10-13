-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Helper = {}
local format = string.format

-- Returns a formatted time string:
function Helper:getTimeFormat()
    return format("%.3f", self.timer:get())
end

return Helper
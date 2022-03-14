-- Word Buster Grace file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Grace = { }

local time = os.time
local diff = os.difftime
local floor = math.floor

function Grace:Check()

    for id, v in pairs(self.infractions) do
        if (id) then
            local reference = time { day = v.last_infraction.day, month = v.last_infraction.month, year = v.last_infraction.year }
            local days_from = diff(time(), reference) / (24 * 60 * 60)
            if (floor(days_from) >= self.settings.grace_period) then
                self.infractions[id] = nil
                self.write(self.infractions)
            end
        end
    end

    timer(1000, 'RecurseCheck')
end

function RecurseCheck()
    Grace:Check()
    return true
end

return Grace
-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = { }

-- Called when a player spawns:
function Event:OnSpawn()

    if (self.timer.paused) then
        self.timer:resume()
    end

    execute_command('s ' .. self.id .. ' ' .. self.running_speed)
end

-- Register the event:
register_callback(cb['EVENT_SPAWN'], 'OnSpawn')

return Event
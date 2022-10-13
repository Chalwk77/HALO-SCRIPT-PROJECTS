-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = { }

-- Called when a player dies.
-- Stops the timer and prints the time to the player's rcon:
-- @arg: [number] (id) - Player ID
function Event:OnDeath(id)
    local player = self.players[id]
    if (player) then
        rprint(id, 'Parkour Time: ' .. self.getTimeFormat() .. ' seconds')
        self.timer:stop()
    end
end

-- Register the event:
register_callback(cb['EVENT_DIE'], 'OnDeath')

return Event
-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = { }

-- Called when a quits the server.
-- Clears the player object entry.
-- @arg: [number] (id) - Player ID
function Event:OnQuit(id)
    self.players[id] = nil
end

-- Register the event:
register_callback(cb['EVENT_LEAVE'], 'OnQuit')

return Event
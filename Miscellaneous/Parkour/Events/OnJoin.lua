-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = { }

-- Constructor function for this player:
function Event:NewPlayer(o)

    setmetatable(o, { __index = self })
    self.__index = self

    o.deaths = 0
    o.ip = o:NewIP()
    o.timer = self.timer:new()
    o:setPlayerCheckPoints()

    self.database[o.ip] = self.database[o.ip] or {
        name = o.name,
        times = { [self.map] = {} }
    }

    return o
end

-- Called when a joins.
-- Creates a new player object:
-- @arg: [number] (id) - Player ID
function Event:OnJoin(id)
    self.players[id] = self:NewPlayer({
        id = id,
        name = get_var(id, '$name')
    })
end

-- Register the event:
register_callback(cb['EVENT_JOIN'], 'OnJoin')

return Event
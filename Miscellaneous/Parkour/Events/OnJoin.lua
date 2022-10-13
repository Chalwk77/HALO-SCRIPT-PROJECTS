-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = { }

function Event:setPlayerCheckPoints()

    self.checkpoint = 0 -- set the checkpoint index
    self.checkpoints = {}

    for i = 1, #self.map_checkpoints do

        local checkpoint = self.map_checkpoints[i]
        local x = checkpoint[1]
        local y = checkpoint[2]
        local z = checkpoint[3]

        -- Add the checkpoint coordinates to the player's checkpoint table:
        --
        -- The 4th value is set to false by default.
        -- This is used to determine if the player has reached the checkpoint.

        --
        self.checkpoints[i] = { x, y, z, false }
    end
end

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
        times = {}
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
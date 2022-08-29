-- Zombies [Join Event File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = {}

-- New Player has joined:
-- * Creates a new player table; Inherits the Zombies parent object.
-- @Param o (player table [table])
-- @Return o (player table [table])
function Event:NewPlayer(o)

    setmetatable(o, self)
    self.__index = self

    o.meta_id = 0 -- last damage meta id

    o.drones = {} -- stores memory object of player inventory

    o.alpha = false -- alpha zombie status

    o.assign = false -- weapon assignment bool

    o:GameStartCheck()

    return o
end

return Event
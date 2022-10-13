-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Helper = {}

function Helper:setPlayerCheckPoints()

    self.checkpoint = 0 -- set the checkpoint index
    self.checkpoints = {} -- create a new checkpoints table

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

function Helper:Reset()
    self.timer:stop() -- ensure he timer has stopped
    self.hud = nil -- remove the HUD
    self.deaths = 0 -- reset death count
    self.x, self.y, self.z = nil, nil, nil -- reset player spawn position
    self:setPlayerCheckPoints()
end

return Helper
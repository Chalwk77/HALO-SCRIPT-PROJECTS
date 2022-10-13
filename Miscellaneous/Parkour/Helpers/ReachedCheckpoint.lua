-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Checkpoints = {}

function Checkpoints:reachedCheckpoint(x, y, z)

    if (not self.timer.start_time) then
        return
    end

    -- Loop through all checkpoints
    for i = 1, #self.checkpoints do
        local checkpoint = self.checkpoints[i]
        if (checkpoint) then

            -- Get the checkpoint's coordinates
            local cx, cy, cz = checkpoint[1], checkpoint[2], checkpoint[3]
            local reached = checkpoint[4]
            local distance = self:GetDistance(x, y, z, cx, cy, cz)

            -- Check if the player is within 1 unit of the checkpoint (cx, cy, cz).
            if (distance <= 1 and not reached and self.checkpoint < i) then
                self.x, self.y, self.z = cx, cy, cz -- set the players next spawn point coordinates
                self.checkpoint = i -- set the current checkpoint index
                self.checkpoints[i][4] = true -- mark as reached
                return true
            end
        end
    end

    return false
end

return Checkpoints
-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Event = { }

-- Called when a player dies.
-- Stops the timer and prints the time to the player's rcon:
-- @arg: [number] (id) - Player ID
function Event:OnDeath()

    self.deaths = self.deaths + 1

    if (self.deaths >= self.restart_after) then
        self.x, self.y, self.z = nil, nil, nil
        self.deaths = 0
        self:setPlayerCheckPoints()
        self.timer:stop()
        self.hud = nil
        rprint(self.id, "You have died too many times. Restarting...")
        goto continue
    end

    for i = #self.checkpoints, 1, -1 do
        local checkpoint = self.checkpoints[i]
        local reached = checkpoint[4]
        if (reached) then
            self.timer:pause()
            rprint(self.id, "Respawning at last checkpoint (" .. i .. ")")
            break
        end
    end

    if (not self.timer.paused) then
        self.timer:stop()
        self.hud = nil
    end

    :: continue ::
    write_dword(get_player(self.id) + 0x2C, self.respawn_time * 33)
end

-- Register the event:
register_callback(cb['EVENT_DIE'], 'OnDeath')

return Event
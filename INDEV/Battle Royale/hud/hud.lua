local hud = {}
local floor = math.floor
local format = string.format

function hud:showHUD(HUD, distance)

    -- Show the primary HUD
    if (HUD == 'primary') then

        distance = floor(distance)
        local size = self.safe_zone_size
        local timer = self.safe_zone_timer

        local time = timer:get()
        time = self.duration - time

        local time_remaining = self.total_time - timer:get()
        local h, m, s = self:secondsToTime(time_remaining)

        self:say(format('Safe Zone: %s/%s | Zone Shrink: %.2f | Time Remaining: %s:%s:%s', distance, size, time, h, m, s))
        return
    end

    -- Show the warning HUD
    if (HUD == "warning") then
        self:say("You are outside the safe zone!")
        return
    end
end

return hud
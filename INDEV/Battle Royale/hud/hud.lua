local hud = {}
local time = os.time
local floor = math.floor
local format = string.format

function hud:getPrimaryHUD(distance)

    distance = floor(distance)
    local size = self.safe_zone_size
    local timer = self.safe_zone_timer

    local time_elapsed = timer:get()
    time_elapsed = self.duration - time_elapsed

    local time_remaining = self.total_time - timer:get()
    local h, m, s = self:secondsToTime(time_remaining)

    return format('Safe Zone: %s/%s | Zone Shrink: %.2f | Time Remaining: %s:%s:%s',
            distance,
            size,
            time_elapsed, h, m, s
    )
end

function hud:setHUD(HUD, distance)

    -- Show the primary HUD
    if (HUD == 'primary') then
        self.messages.primary = self:getPrimaryHUD(distance)
        return
    end

    -- Show the warning HUD
    if (HUD == "warning") then
        self.messages.primary = 'You are outside the safe zone!'
        return
    end
end

function hud:newMessage(content, duration)
    duration = duration or 5
    self.messages[#self.messages + 1] = {
        content = content,
        finish = time() + duration,
        stdout = function(message)
            rprint(self.id, message.content)
        end
    }
end

function hud:displaySecondaryHUD()

    if (not self.pre_game_timer or not self.pre_game_timer.started) then
        return
    end

    self:cls()
    self:say(self.messages.primary)

    for i, v in pairs(self.messages) do
        if (v and v.finish) then
            if (time() >= v.finish) then
                self.messages[i] = nil
            else
                v:stdout()
            end
        end
    end
end

return hud
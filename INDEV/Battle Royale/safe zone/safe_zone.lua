local SafeZone = {}
local format = string.format
local floor = math.floor

function SafeZone:shrinkSafeZone()

    local timer = self.safe_zone_timer
    local reductions = self.reductions

    if (not timer) then
        return
    end

    --- TOTAL TIME REMAINING:
    local time_remaining = self.total_time - timer:get()
    local h, m, s = self:secondsToTime(time_remaining)
    --cprint(format("This game will end in %s hours, %s minutes and %s seconds", h, m, s), 10)

    local time = timer:get()

    --
    --- SAFE ZONE SHRINKING:
    -- The safe zone will shrink every 'x' seconds (default 60).
    --
    if (not timer.crunch_time) then
        local time_until_shrink = self.duration - time
        --cprint('Safe Zone will shrink in ' .. time_until_shrink .. ' seconds')
        if (time_until_shrink <= 0 and reductions > 0 and self.safe_zone_size > self.safe_zone.min) then
            self:shrink()
        end
        return
    end


    --
    --- CRUNCH TIME:
    -- There is an additional 'x' minutes (default 2) of game play after the safe zone has shrunk to its minimum size.
    -- This is to allow players to fight it out in a small area.
    -- After this time has elapsed, the game will end.
    --
    local time_until_end = (self.end_after * 60) - time

    if (time_until_end <= 0) then
        execute_command('sv_end_game')
        return
    end
end

-- This function is not currently being used:
-- Spawns a visible barrier around the safe zone.
function SafeZone:spawnBarrier()

    self.barrier = {}

    local total_flags = 30
    local height = 2
    local radius = 3 --self.safe_zone_size

    local x, y, z = self.safe_zone.x, self.safe_zone.y, self.safe_zone.z

    local iterations = 0
    for i = 0, 360 do
        if (i > iterations) then
            iterations = iterations + 360 / total_flags
            local angle = i * math.pi / 180
            local x1 = x + radius * math.cos(angle)
            local y1 = y + radius * math.sin(angle)
            local z1 = z + height
            local object = spawn_object('weap', 'weapons\\flag\\flag', x1, y1, z1)
            self.barrier[object] = { x = x1, y = y1, z = z1 }
        end
    end
end

function SafeZone:outsideSafeZone()

    if (not self.pre_game_timer or not self.pre_game_timer.started) then
        return
    end

    local bX, bY, bZ = self.safe_zone.x, self.safe_zone.y, self.safe_zone.z

    for i, v in pairs(self.players) do

        local dyn = get_dynamic_player(i)
        if (dyn ~= 0 and player_alive(i)) then

            local px, py, pz = self:getXYZ(dyn)
            local distance = self:getDistance(px, py, pz, bX, bY, bZ)
            if (distance > self.safe_zone_size) then
                self:hurt(v)
            else
                v.kill_timer = nil
                v:setHUD('primary', distance)
            end
        end
    end
end

function SafeZone:setSafeZone()

    local min_size, max_size = self.safe_zone.min, self.safe_zone.max
    local reduction_rate, reduction_amount = self.duration, self.shrink_amount

    local total_time = (max_size - min_size) / reduction_amount * reduction_rate

    self.reductions = floor((total_time / reduction_rate))
    self.safe_zone_size = max_size

    return total_time
end

function SafeZone:shrink()

    local min, max = self.safe_zone.min, self.safe_zone.max

    self.reductions = self.reductions - 1
    self.safe_zone_size = self.safe_zone_size - self.shrink_amount

    self.safe_zone_timer:restart()

    if (self.safe_zone_size <= min) then
        cprint('The Safe Zone has reached its minimum size')

        self.safe_zone_size = min
        self.safe_zone_timer.crunch_time = true

        return
    end

    cprint('[ SAFE ZONE SHRUNK ] Radius now (' .. self.safe_zone_size .. '/' .. max .. ') world units')
end

return SafeZone
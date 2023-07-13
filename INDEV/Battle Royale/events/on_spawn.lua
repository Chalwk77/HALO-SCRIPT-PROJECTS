local event = {}

function event:onSpawn(id)

    local player = self.players[id]
    if (not player) then
        return
    elseif (self.pre_game_timer and self.pre_game_timer.started and player.god) then
        execute_command('god ' .. id)
    end

    execute_command('hp ' .. id .. ' ' .. self.health)
    execute_command('wdel ' .. id)
    execute_command('s ' .. id .. ' ' .. self.default_running_speed)

    --
    -- Prevents players from spawning outside the safe zone:
    -- Only in effect during game play.
    --

    if (player.god) then
        return
    end

    -- Gets all sky-spawn points:
    local spawns = self:getSpawns()

    -- Safe zone X, Y, Z and radius:
    local radius = self.safe_zone_size
    local bX, bY, bZ = self.safe_zone.x, self.safe_zone.y, self.safe_zone.z

    -- Saves all points inside the circle:
    local candidates = {}
    for i = 1, #spawns do
        local point = spawns[i]

        local x = point[1]
        local y = point[2]
        local z = point[3]

        local distance = self:getDistance(x, y, z, bX, bY, bZ)
        if (distance <= radius) then
            candidates[#candidates + 1] = point
        end
    end

    -- If there are no points inside the circle, then we'll pick the closest one to the centre of the circle:
    if (#candidates == 0) then

        local closest
        local closest_distance
        for i = 1, #spawns do

            local point = spawns[i]
            local x = point[1]
            local y = point[2]
            local z = point[3]

            local distance = self:getDistance(x, y, z, bX, bY, bZ)
            if (not closest or distance < closest_distance) then
                closest = point
                closest_distance = distance
            end
        end
        player.spawn = closest
    else
        player.spawn = candidates[rand(1, #candidates + 1)]
    end

    player:teleport(false, false)
end

register_callback(cb['EVENT_SPAWN'], 'OnSpawn')

return event
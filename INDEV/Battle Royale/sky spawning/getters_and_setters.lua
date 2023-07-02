local spawns = {}

function spawns:getSpawns()

    local points = {}
    local locations = self.sky_spawn_coordinates

    for i = 1, #locations do
        points[#points + 1] = locations[i]
    end

    return points
end

local function getRandomPoint(t)
    local index = rand(1, #t + 1)
    return t[index]
end

function spawns:setSpawns()

    local locations = self:getSpawns()
    if (#locations == 0 or #locations < 16) then
        error("Not enough sky-spawn points configured! (16+ required)")
        return
    end

    for _, v in pairs(self.players) do
        local point = getRandomPoint(locations)
        while (point.used) do
            point = getRandomPoint(locations)
        end
        point.used = true
        v.spawn = point
    end
end

return spawns
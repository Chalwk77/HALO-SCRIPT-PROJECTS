local spawns = {}

function spawns:getSpawns()

    local points = {}
    local total = #self.players
    local locations = self.sky_spawn_coordinates

    for _ = 1, total do
        math.randomseed(os.clock())
        local index = math.random(#locations)
        local point = locations[index]
        points[#points + 1] = point
    end

    return points
end

function spawns:setSpawns()

    local locations = self:getSpawns()

    for _, v in pairs(self.players) do

        math.randomseed(os.clock())
        local index = math.random(#locations)
        local point = locations[index]

        v.spawn = point

        locations[index] = nil
    end
end

return spawns
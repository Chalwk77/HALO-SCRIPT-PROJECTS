local intersect = {}

local sqrt, pow = math.sqrt, math.pow

function intersect:hasCrossedStartLine(dyn)
    local start = self.start_line
    local pointA = { start[1], start[2], start[3] }
    local pointB = { start[4], start[5], start[6] }
    return intersect:hasIntersected(pointA, pointB, dyn)
end

function intersect:hasCrossedFinishLine(dyn)
    local finish = self.finish_line
    local pointA = { finish[1], finish[2], finish[3] }
    local pointB = { finish[4], finish[5], finish[6] }
    return intersect:hasIntersected(pointA, pointB, dyn)
end

function intersect:hasIntersected(pointA, pointB, dyn)

    local distanceThreshold = 0

    local playerPosition = self:getPlayerPosition(dyn)
    local x1, y1, z1 = pointA[1], pointA[2], pointA[3]
    local x2, y2, z2 = pointB[1], pointB[2], pointB[3]
    local px, py, pz = playerPosition.x, playerPosition.y, playerPosition.z

    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1

    local distanceAlongLine = (px - x1) * dx + (py - y1) * dy + (pz - z1) * dz
    local lineLength = sqrt(pow(dx, 2) + pow(dy, 2) + pow(dz, 2))

    return distanceThreshold <= distanceAlongLine <= lineLength
end

return intersect
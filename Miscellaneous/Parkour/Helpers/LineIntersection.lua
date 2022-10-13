-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Helper = {}
local sqrt = math.sqrt

-- Returns the distance between two points using the Pythagorean theorem:
-- @arg [number] (x1) - x coordinate of point 1
-- @arg [number] (y1) - y coordinate of point 1
-- @arg [number] (z1) - z coordinate of point 1
-- @arg [number] (x2) - x coordinate of point 2
-- @arg [number] (y2) - y coordinate of point 2
-- @arg [number] (z2) - z coordinate of point 2
local function GetDistance(pX, pY, pZ, cX, cY, cZ)
    return sqrt((pX - cX) ^ 2 + (pY - cY) ^ 2 + (pZ - cZ) ^ 2)
end

-- Checks if a player is within a certain distance between two points:
-- @arg [number] (px) - x coordinate of player
-- @arg [number] (py) - y coordinate of player
-- @arg [number] (pz) - z coordinate of player
-- @arg [table] (coords) - line coordinates
-- @return [boolean] (true/false) if distance is within range (1 world/unit)
function Helper:lineIntersect(px, py, pz, coords)

    if (not coords) then
        return
    end

    local pointA = coords[1]
    local pointB = coords[2]

    local pointAX = pointA.x
    local pointAY = pointA.y
    local pointAZ = pointA.z

    local pointBX = pointB.x
    local pointBY = pointB.y
    local pointBZ = pointB.z

    local midpointX = (pointAX + pointBX) / 2
    local midpointY = (pointAY + pointBY) / 2
    local midpointZ = (pointAZ + pointBZ) / 2

    local distance = GetDistance(px, py, pz, midpointX, midpointY, midpointZ)

    return distance < 1
end

return Helper
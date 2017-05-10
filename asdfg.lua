level = { }
level[1] = { "level 1", { 1, 2, 0.005 }, 30, "1"}
level[2] = { "level 2", { 1, 2, 0.010 }, 60, "2"}
level[3] = { "level 3", { 1, 2, 0.015 }, 90, "3"}
level[4] = { "level 4", { 1, 2, 0.025 }, 120, "4"}
level[5] = { "level 5", { 1, 2, 0.035 }, 150, "5"}
level[6] = { "level 6", { 1, 2, 0.045 }, 180, "6"}
level[7] = { "level 7", { 1, 2, 0.055 }, 210, "7"}
level[8] = { "level 8", { 1, 2, 0.065 }, 240, "8"}
level[9] = { "level 9", { 1, 2, 0.075 }, 270, "9"}
level[10] = { "level 10", { 1, 2, 0.085 }, 300, "10"}

function randomSpeed( )
    if (speedMin ~= nil) or (speedMax ~= nil) then
        return math.random(speedMin, speedMax) / 10 * speedFactor + offset
    else
        return math.random(1, 2) / 10 * speedFactor
    end
end

if gameHasStarted then
    if not settings["showPreviousScore"] then
        if levelNum ~= #level + 1 then
            speed_tbl = level[levelNum][2]
            if speed_tbl then
                speedMin = tonumber(speed_tbl[1])
                speedMax = tonumber(speed_tbl[2])
                offset = tonumber(speed_tbl[3])
            end
        end
    else
        speedMin = 1
        speedMax = 2
        offset = 0
    end
end

local sign = {1, -1}
if 1 == math.random( 1, 2 ) then
    xVelocity = randomSpeed() * sign[math.random(1, 2)]
else
    yVelocity = randomSpeed() * sign[math.random(1, 2)]
end

local xVelocity = 0
local yVelocity = 0
if object.xVelocity < 0 then
    xVelocity = - randomSpeed()
elseif object.xVelocity > 0 then
    xVelocity = randomSpeed()
end
if object.yVelocity < 0 then
    yVelocity = - randomSpeed()
elseif object.yVelocity > 0 then
    yVelocity = randomSpeed()
end

local closure = function() return spawn(item, xVelocity, yVelocity) end
    chances = timer.performWithDelay ( math.random(6, 12) * settings["rewardChances"], closure, 1 )
end

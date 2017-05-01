Old Speed Values:
level 1 = SpeedMin = 1/10 * 1 + 0.025 or SpeedMax = 2/10 * 1 + 0.025
level 2 = SpeedMin = 1/10 * 1 + 0.045 or SpeedMax = 2/10 * 1 + 0.045
level 3 = SpeedMin = 1/10 * 1 + 0.065 or SpeedMax = 2/10 * 1 + 0.065
level 4 = SpeedMin = 1/10 * 1 + 0.085 or SpeedMax = 2/10 * 1 + 0.085
level 5 = SpeedMin = 1/10 * 1 + 0.10 or SpeedMax = 2/10 * 1 + 0.10
level 6 = SpeedMin = 1/10 * 1 + 0.11 or SpeedMax = 2/10 * 1 + 0.11
level 7 = SpeedMin = 1/10 * 1 + 0.12 or SpeedMax = 2/10 * 1 + 0.12
level 8 = SpeedMin = 1/10 * 1 + 0.13 or SpeedMax = 2/10 * 1 + 0.13
level 9 = SpeedMin = 1/10 * 1 + 0.14 or SpeedMax = 2/10 * 1 + 0.14
level 10 = SpeedMin = 1/10 * 1 + 0.15 or SpeedMax = 2/10 * 1 + 0.15

New Speed Values:
level 1 = SpeedMin = 1/10 * 1 + 0.0125 or SpeedMax = 2/10 * 1 + 0.0125
level 2 = SpeedMin = 1/10 * 1 + 0.0225 or SpeedMax = 2/10 * 1 + 0.0225
level 3 = SpeedMin = 1/10 * 1 + 0.0325 or SpeedMax = 2/10 * 1 + 0.0325
level 4 = SpeedMin = 1/10 * 1 + 0.0425 or SpeedMax = 2/10 * 1 + 0.0425
level 5 = SpeedMin = 1/10 * 1 + 0.05 or SpeedMax = 2/10 * 1 + 0.05
level 6 = SpeedMin = 1/10 * 1 + 0.055 or SpeedMax = 2/10 * 1 + 0.055
level 7 = SpeedMin = 1/10 * 1 + 0.06 or SpeedMax = 2/10 * 1 + 0.06
level 8 = SpeedMin = 1/10 * 1 + 0.065 or SpeedMax = 2/10 * 1 + 0.065
level 9 = SpeedMin = 1/10 * 1 + 0.07 or SpeedMax = 2/10 * 1 + 0.07
level 10 = SpeedMin = 1/10 * 1 + 0.075 or SpeedMax = 2/10 * 1 + 0.075

speedFactor = 1

level = { }
level[1] = { "level 1", { 1, 2, 0.0125 }, 30, "1"}
level[2] = { "level 2", { 1, 2, 0.0225 }, 60, "2"}
level[3] = { "level 3", { 1, 2, 0.0325 }, 90, "3"}
level[4] = { "level 4", { 1, 2, 0.0425 }, 120, "4"}
level[5] = { "level 5", { 1, 2, 0.05 }, 150, "5"}
level[6] = { "level 6", { 1, 2, 0.055 }, 180, "6"}
level[7] = { "level 7", { 1, 2, 0.06 }, 210, "7"}
level[8] = { "level 8", { 1, 2, 0.065 }, 240, "8"}
level[9] = { "level 9", { 1, 2, 0.07 }, 270, "9"}
level[10] = { "level 10", { 1, 2, 0.075 }, 300, "10"}

    for i = 1,#level do
        if score == 0 then 
            currentlevel = 1 
        elseif tonumber(score) == tonumber(level[i][3]) then
            currentlevel = tonumber(level[i][4]) + 1
        end
    end

    -- on tick [
    local cur = currentlevel
    if cur == #level + 1 then 
        -- game over
    else
        speed_tbl = level[currentlevel][2]
        if speed_tbl then
            speedMin = tonumber(speed_tbl[1])
            speedMax = tonumber(speed_tbl[2])
            offset = tonumber(speed_tbl[3])
        end
    end

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
    --]
    
getRandomSpeed = function( )
    if gameHasStarted then 
        return math.random(speedMin, speedMax) / 10 * speedFactor + offset
    else
        return math.random(1, 2) / 10 * speedFactor
    end
end

current_players = 0

function OnNewGame()
    for i = 1, 16 do
        if player_present(i) then
            current_players = current_players + 1
        end
    end
end

function OnPlayerLeave(PlayerIndex)
    current_players = current_players - 1
end

function OnPlayerJoin(PlayerIndex)
    current_players = current_players + 1
end

function math.round(number, place)
    return math.floor(number *(10 ^(place or 0)) + 0.5) /(10 ^(place or 0))
end

function CalculatePlayers(PlayerIndex)
    -- between 1-5
    if current_players >= 1 and current_players <= 5 then
        local mapname = get_var(1, "$map")
        local PlayerSpeed = player_speed[players[PlayerIndex][1]][mapname]
        execute_command("s " .. PlayerIndex .. " :" .. tonumber(PlayerSpeed))
    -- between 5-10
    elseif current_players >= 5 and current_players <= 10 then
        local mapname = get_var(1, "$map")
        local PlayerSpeed = player_speed[players[PlayerIndex][1]][mapname] + math.floor(math.round(0.5))
        execute_command("s " .. PlayerIndex .. " :" .. tonumber(PlayerSpeed))
    -- between 10-16
    elseif current_players >= 10 and current_players <= 16 then
        local mapname = get_var(1, "$map")
        local PlayerSpeed = player_speed[players[PlayerIndex][1]][mapname] + math.floor(math.round(0.10))
        execute_command("s " .. PlayerIndex .. " :" .. tonumber(PlayerSpeed))
    end
end

function OnGameEnd()
    current_players = 0
end

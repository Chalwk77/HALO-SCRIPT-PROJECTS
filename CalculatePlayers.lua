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

function CalculatePlayers(PlayerIndex)

end

function OnGameEnd()
    current_players = 0
end

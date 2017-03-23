function Command_AFK(executor, command, PlayerIndex, count)
    if count == 1 then
        if executor ~= nil then
            local player = tonumber(executor)
            if player ~= -1 and player >= 1 and player < 16 then
                local id = resolveplayer(executor)
                local PLAYER_ID = get_var(executor, "$n")
                players_alive[PLAYER_ID].AFK = executor
                sendresponse("You are now afk", command, executor)
            else
                cprint("Server cannot be afk", 4+8)
                return false
            end
        else
            sendresponse("Invalid Player", command, executor)
        end
    elseif count == 2 then
        local players = getvalidplayers(PlayerIndex, executor)
        if players then
            for i = 1, #players do
                if player_present(players[i]) then
                    local id = get_var(players[i], "$n")
                    local PLAYER_ID = get_var(id, "$n")
                    players_alive[PLAYER_ID].AFK = id
                    sendresponse(getname(players[i]) .. " is now afk", command, executor)
                else
                    sendresponse("Invalid Player", command, executor)
                end
            end
        else
            sendresponse("Invalid Player", command, executor)
        end
    else
        sendresponse("Invalid Syntax: " .. command .. " {player}", command, executor)
    end
end

function getvalidplayers(expression, PlayerIndex)
    if cur_players ~= 0 then
        local players = { }
        if expression == "*" then
            for i = 1, 16 do
                if get_player(i) then
                    table.insert(players, i)
                end
            end
        elseif expression == "me" then
            if PlayerIndex ~= nil and PlayerIndex ~= -1 and PlayerIndex then
                table.insert(players, PlayerIndex)
            end
        elseif string.sub(expression, 1, 3) == "red" then
            for i = 1, 16 do
                if get_player(i) and getteam(i) == "red" then
                    table.insert(players, i)
                end
            end
        elseif string.sub(expression, 1, 4) == "blue" then
            for i = 1, 16 do
                if get_player(i) and getteam(i) == "blue" then
                    table.insert(players, i)
                end
            end
        elseif (tonumber(expression) or 0) >= 1 and (tonumber(expression) or 0) <= 16 then
            local expression = tonumber(expression)
            if resolveplayer(expression) then
                table.insert(players, resolveplayer(expression))
            end
        elseif expression == "random" or expression == "rand" then
            if cur_players == 1 and PlayerIndex ~= nil then
                table.insert(players, PlayerIndex)
                return players
            end
            local bool = false
            while not bool do
                num = math.random(1, 16)
                if get_player(num) and num ~= PlayerIndex then
                    bool = true
                end
            end
            table.insert(players, num)
        else
            for i = 1, 16 do
                if get_player(i) then
                    if string.wild(getname(i), expression) == true then
                        table.insert(players, i)
                    end
                end
            end
        end
        if players[1] then
            return players
        end
    end
    return false
end

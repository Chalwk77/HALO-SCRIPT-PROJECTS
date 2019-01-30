--[[
--=====================================================================================================--
Script Name: Divide & Conquer, for SAPP (PC & CE)
Description: N/A

             
Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

-- Configuration [starts]

-- #Countdown delay (in seconds)
-- This is a pre-game-start countdown initiated at the beginning of each game.
delay = 7

-- #Pre Game message
pre_game_message = "Game will begin in %time_remaining% seconds"

-- #End of Game message (%team% will be replaced with the winning team)
end_of_game = "The %team% team won!"

-- #Server Prefix
server_prefix = "»L§R« "

-- #Numbers of players required to set the game in motion.
required_players = 3

-- #Respawn time
-- When enabled, players who are killed by the opposing team will respawn immediately.
respawn_override = true
respawn_time = 0 -- In seconds (0 = immediate)


-- Continuous message emitted when there aren't enough players.
not_enough_players = "The game will begin when %required_players% or more players are online."
-- Configuration [ends] << ----------


-- tables --
player_count = {}

-- Booleans
gamestarted = nil
red_count = 0
blue_count = 0

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    
    register_callback(cb["EVENT_GAME_START"], "OnNewGame")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")

    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerLeave")
    
    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
end

function OnScriptUnload()

end

function OnTick()
    
    -- # Continuous message emitted when ther aren't enough players to start the game.
    for i = 1, 16 do
        if (player_present(i) and not gamestarted) then 
            if (getPlayerCount() ~= nil) and (getPlayerCount() < required_players) then
                cls(i)
                local notEnoughPlayers = string.gsub(not_enough_players, "%%required_players%%", tonumber(required_players))
                rprint(i, notEnoughPlayers)
            end
        end
    end
    
    if (init_countdown == true) then
        countdown = countdown + 0.030
        
        local seconds = secondsToTime(countdown)
        timeRemaining = delay - math.floor(seconds)

        -- Pre-Game message.
        for i = 1, 16 do
            if (player_present(i) and not gamestarted) then
                cls(i)
                local preGameMessage = string.gsub(pre_game_message, "%%time_remaining%%", tonumber(timeRemaining))
                rprint(i, preGameMessage)
            end
        end
        
        if (timeRemaining <= 0) then
            gamestarted = true
            stopTimer()
            for j = 1, 16 do
                if player_present(j) then
                    killPlayer(tonumber(j))
                    if (get_var(j, "$team") == "red") then
                        red_count = red_count + 1
                    elseif (get_var(j, "$team") == "blue") then
                        blue_count = blue_count + 1
                    end
                    rprint(j, "The game has begun")
                end
            end
        end
    end
end

function OnNewGame()
    resetAllParameters()
end

function OnGameEnd()
    resetAllParameters()
end

function resetAllParameters()
    gamestarted = false
    for i = 1,16 do
        table.remove(player_count, i)
    end
    red_count = 0
    blue_count = 0
    stopTimer()
end

function OnPlayerJoin(PlayerIndex)
    addPlayer(PlayerIndex)
    
    if (getPlayerCount() >= required_players) then startTimer() end
    
    -- Only sort player into new team if the game has already started...
    if (gamestarted) then
        -- Red team has less players (join this team)
        if (red_count < blue_count) then
            SwitchTeam(PlayerIndex, "red")
            red_count = red_count + 1
            
            -- Blue team has less players (join this team)
        elseif (blue_count < red_count) then
            SwitchTeam(PlayerIndex, "blue")
            blue_count = blue_count + 1
            
            -- Teams are even
        elseif (blue_count == red_count) then
            local function pickRandomTeam()
                math.randomseed(os.time())
                math.random();
                local num = math.random(1, 2)
                local team
                if (num == 1) then
                    team = "red"
                else
                    team = "blue"
                end
                return team
            end
            local new_team = pickRandomTeam()
            if (new_team == "red") then
                red_count = red_count + 1
                SwitchTeam(PlayerIndex, "red")
            elseif (new_team == "blue") then
                blue_count = blue_count + 1
                SwitchTeam(PlayerIndex, "blue")
            end
        end
    end
end

function OnPlayerLeave(PlayerIndex)
    local team = get_var(PlayerIndex, "$team")
    if (team == "red") then
        red_count = red_count - 1
    elseif (team == "blue") then
        blue_count = blue_count - 1
    end
    removePlayer(tonumber(PlayerIndex))
    
    if (gamestarted) then
        if ((getPlayerCount() == nil) or (getPlayerCount() <= 0)) then
            resetAllParameters()
        elseif ((getPlayerCount() ~= nil) and (getPlayerCount() == 1)) then
            gameOver(nil, true)
        end
    end
    
    if not (gamestarted) and (init_countdown == true) then
        if ((getPlayerCount() ~= nil) and (getPlayerCount() < required_players)) then
            init_countdown = false
            countdown = 0
        end
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)

    if (gamestarted) then
        local victim = tonumber(PlayerIndex)
        local killer = tonumber(KillerIndex)
        
        local kteam = get_var(killer, "$team")
        local vteam = get_var(victim, "$team")
        
        if (killer ~= -1) and (killer ~= 0) and (killer ~= nil) and (killer > 0) and (victim ~= killer) then
        
            if kteam == "red" then
                SwitchTeam(victim, "red")
                red_count = red_count + 1
                blue_count = blue_count - 1
                
            elseif kteam == "blue" then
                SwitchTeam(victim, "blue")
                blue_count = blue_count + 1
                red_count = red_count - 1
            end

            -- No one left on RED team. | BLUE Team Wins
            if (red_count == 0 and blue_count >= 1) then
                gameOver(string.gsub(end_of_game, "%%team%%", "blue"), false)
                
                -- No one left on BLUE team. | RED Team Wins
            elseif (blue_count == 0 and red_count >= 1) then
                gameOver(string.gsub(end_of_game, "%%team%%", "red"), false)
                
                -- Game is in play | switch player
            elseif (blue_count ~= 0 and red_count ~= 0) then
                SwitchTeam(victim, tostring(kteam))
                execute_command("msg_prefix \"\"")
                say_all(get_var(victim, "$name") .. " is now on " .. kteam .. " team.")
                execute_command("msg_prefix \" " .. server_prefix .. "\"")
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex then
        if (get_var(CauserIndex, "$team") == get_var(PlayerIndex, "$team")) then
            return false
        end
    end
end

function killPlayer(PlayerIndex)
    local PlayerObject = read_dword(get_player(PlayerIndex) + 0x34)
    if PlayerObject ~= nil then
        destroy_object(PlayerObject)
    end
end

function SwitchTeam(PlayerIndex, team)
    kill_message_addresss = sig_scan("8B42348A8C28D500000084C9") + 3
    original = read_dword(kill_message_addresss)
    safe_write(true)
    write_dword(kill_message_addresss, 0x03EB01B1)
    safe_write(false)
    
    execute_command("st " .. tonumber(PlayerIndex) .. " " .. tostring(team))
    
    safe_write(true)
    write_dword(kill_message_addresss, original)
    safe_write(false)
    
    if (respawn_override == true) then
        write_dword(get_player(PlayerIndex) + 0x2C, respawn_time)  
    end
end

function gameOver(message, bool)
    if not (bool) and (message) then
        gamestarted = false
        execute_command("msg_prefix \"\"")
        say_all(message)
        execute_command("msg_prefix \" " .. server_prefix .. "\"")
        execute_command("sv_map_next")
    else
        timer(1000 * 1, "delayEndGame")
    end
end

function delayEndGame()
    for i = 1,16 do
        if player_present(i) then
            gameOver(string.gsub(end_of_game, "%%team%%", get_var(i, "$team")), false)
        end
    end
end

function secondsToTime(seconds)
    seconds = seconds % 60
    return seconds
end

function startTimer()
    countdown = 0
    init_countdown = true
end

function stopTimer()
    countdown = 0
    init_countdown = false
    for i = 1, 16 do
        if player_present(i) then
            cls(i)
        end
    end
end

function cls(PlayerIndex)
    for _ = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

-- Player Counts
function addPlayer(PlayerIndex)
    table.insert(player_count, tonumber(PlayerIndex))
end

function removePlayer(PlayerIndex)
    for i, v in ipairs(player_count) do 
        if string.match(v, tonumber(PlayerIndex)) then
            table.remove(player_count, i)
        end
    end
end

function getPlayerCount()
    local count
    for k, v in ipairs(player_count) do
        if (k == 0 or nil) then count = 0 end
        if (count ~= 0 or count ~= nil) then
            count = tonumber(k)
        end
    end
    return count
end

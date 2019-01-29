--[[
--=====================================================================================================--
Script Name: Team Conquer (REVISION 2), for SAPP (PC & CE)
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
server_prefix = "SERVER "

-- #Numbers of players required to set the game in motion.
required_players = 3

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
    removePlayer(PlayerIndex)
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
                gameOver(string.gsub(end_of_game, "%%team%%", "blue"))
                
                -- No one left on BLUE team. | RED Team Wins
            elseif (blue_count == 0 and red_count >= 1) then
                gameOver(string.gsub(end_of_game, "%%team%%", "red"))
                
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
    if not gamestarted then
        return false
    else
        if tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex then
            if (get_var(CauserIndex, "$team") == get_var(PlayerIndex, "$team")) then
                return false
            end
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
    execute_command("st " .. tonumber(PlayerIndex) .. " " .. tostring(team))
end

function gameOver(message)
    gamestarted = false
    execute_command("msg_prefix \"\"")
    say_all(message)
    execute_command("msg_prefix \" " .. server_prefix .. "\"")
    execute_command("sv_map_next")
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
            break
        end
    end
end

function getPlayerCount()
    for k, v in ipairs(player_count) do 
        count = tonumber(k)
    end
    return count
end

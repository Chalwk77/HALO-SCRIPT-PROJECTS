--[[
--=====================================================================================================--
Script Name: Divide & Conquer (V2), for SAPP (PC & CE)
#Description: This version of Divide & Conquer is exactly the same as Divide & Conquer V1,
              however, it relies on Halo's built in team-management system and SAPP's auto team balance. 
              It is compatible with all Team-Based games: CTF, Team-Slayer, Team-Race, Team-KOTH and Team-OddBall, etc.
              
              The game mechanics are as follows:
              When you kill someone on the opposing team, the victim is switched to your team. 
              The main objective is to dominate the opposing team.
              When the aforementioned opposing team has no players left the game is over.

[!] WARNING: This game is in BETA and may have bugs.
    Please report all problems on gighub.
    https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues/new?template=bug_report.md
             
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

-- Continuous message emitted when there aren't enough players.
not_enough_players = "The game will begin when %required_players% or more players are online."

-- #Respawn time (override)
-- When enabled, players who are killed by the opposing team will respawn immediately.
respawn_override = true
respawn_time = 0 -- In seconds (0 = immediate)

-- Configuration [ends] << ----------


-- tables --
player_count = {}
-- Booleans
gamestarted = nil
-- Counts
red_count = 0
blue_count = 0
script_name = "Divide & Conquer V2"

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnNewGame")
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")

    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerLeave")

    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
end

function OnScriptUnload()
    --
end

function OnTick()

    -- # Continuous message emitted when there aren't enough players to start the game.
    for i = 1, 16 do
        if (player_present(i) and (print_nep == true) and not (gamestarted)) then
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

        -- Stop the countdown and begin the game...
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
    if not isTeamPlay() then
        local error = string.format('[' .. script_name .. '] does not support FFA.\n\nSupported gamemodes are:\nCTF, Team-Slayer, Team-Race, Team-KOTH and Team-OddBall, etc.')
        execute_command("log_note \"" .. error .. "\"")
        cprint(error, 4 + 8)
        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb['EVENT_GAME_END'])
        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_LEAVE'])
        unregister_callback(cb['EVENT_DIE'])
        unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])
    else
        -- resetAllParameters() | Ensures all parameters are set to their default values.
        resetAllParameters()
    end
end

function OnGameEnd()
    -- resetAllParameters() | Ensures all parameters are set to their default values.
    resetAllParameters()
end

-- #This function all parameters are set to their default values.
function resetAllParameters()
    gamestarted = false
    print_nep = false
    red_count = 0
    blue_count = 0
    stopTimer()
    for i = 1, 16 do
        table.remove(player_count, i)
    end
end

function OnPlayerJoin(PlayerIndex)
    addPlayer(PlayerIndex)

    if (getPlayerCount() >= required_players) then
        startTimer()
    end

    if (getPlayerCount() >= 1 and getPlayerCount() < required_players) then
        print_nep = true
    end

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

            -- Teams are even | Choose random team.
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

    -- Deduct player from 'player_count' table.
    removePlayer(tonumber(PlayerIndex))

    if (gamestarted) then
        if ((getPlayerCount() == nil) or (getPlayerCount() <= 0)) then
            -- Ensures all parameters are set to their default values.
            resetAllParameters()
            -- One player remains | ends the game.
        elseif ((getPlayerCount() ~= nil) and (getPlayerCount() == 1)) then
            for i = 1, 16 do
                if (tonumber(i) ~= tonumber(PlayerIndex)) then
                    if player_present(i) then
                        local team = get_var(i, "$team")
                        gameOver(string.gsub(end_of_game, "%%team%%", team))
                        break
                    end
                end
            end
            -- Checks if the remaining players are both on the same team | ends the game.
        elseif ((getPlayerCount() ~= nil) and (getPlayerCount() == 2)) then
            for i = 1, 16 do
                if (tonumber(i) ~= tonumber(PlayerIndex)) then
                    if player_present(i) then
                        local team = get_var(i, "$team")
                        if (team == "red") and (team ~= "blue") or (team == "blue") and (team ~= "red") then
                            gameOver(string.gsub(end_of_game, "%%team%%", team))
                            break
                        end
                    end
                end
            end
        end
    end

    -- Pre-Game countdown was initiated but someone left before the game began.
    -- Stop the timer, reset the count and display the continuous 
    -- message emitted when there aren't enough players to start the game.
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
    -- Temporarily disables default death messages (to prevent "Player Died" message).
    kill_message_addresss = sig_scan("8B42348A8C28D500000084C9") + 3
    original = read_dword(kill_message_addresss)
    safe_write(true)
    write_dword(kill_message_addresss, 0x03EB01B1)
    safe_write(false)

    -- Switch player to relevant team
    execute_command("st " .. tonumber(PlayerIndex) .. " " .. tostring(team))

    -- Re enables default death messages
    safe_write(true)
    write_dword(kill_message_addresss, original)
    safe_write(false)

    if (respawn_override == true) then
        write_dword(get_player(PlayerIndex) + 0x2C, respawn_time)
    end
end

function gameOver(message)
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

function isTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
    else
        return false
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
        if (k == 0 or nil) then
            count = 0
        end
        if (count ~= 0 or count ~= nil) then
            count = tonumber(k)
        end
    end
    return count
end

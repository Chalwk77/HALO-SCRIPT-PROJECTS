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
delay = 5

-- #Pre Game message (%timeRemaining% will be replaced with the time remaining)
pre_game_message = "Game will begin in %time_remaining% seconds"

-- #End of Game message (%team% will be replaced with the winning team)
end_of_game = "The %team% team won!"

-- #Server Prefix
server_prefix = "SERVER "

-- #Numbers of players required to set the game in motion.
required_players = 6

-- Continuous message emitted when there aren't enough players.
not_enough_players = "%current_players%/%required_players% players needed to start the game"

-- #Respawn time (override)
-- When enabled, players who are killed by the opposing team will respawn immediately. 
-- Does not affect suicides or other deaths (PvP only by design).
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
-- Strings
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
                local function formatMessage(String)
                    String = string.gsub(String, "%%current_players%%", tonumber(getPlayerCount()))
                    String = string.gsub(String, "%%required_players%%", tonumber(required_players))
                    return String
                end
                local message = formatMessage(not_enough_players)
                rprint(i, message)
            end
        end
    end

    if (init_countdown == true) then
        --cprint("OnTick() | init_countdown = true", 4+8)
    
        countdown = countdown + 0.030

        local seconds = secondsToTime(countdown)
        timeRemaining = delay - math.floor(seconds)

        -- Pre-Game message.
        for j = 1, 16 do
            if (player_present(j) and not gamestarted) then
                cls(j)
                local preGameMessage = string.gsub(pre_game_message, "%%time_remaining%%", tonumber(timeRemaining))
                --cprint(preGameMessage, 2+8)
                rprint(j, preGameMessage)
            end
        end

        -- Stop the countdown and begin the game...
        if (timeRemaining <= 0) then
            --cprint("Time remaining: ".. tonumber(timeRemaining))
            gamestarted = true
            stopTimer()
            for k = 1, 16 do
                if player_present(k) then
                    sortPlayers(k)
                    rprint(k, "The game has begun")
                end
            end
        end
    end
end

function OnNewGame()
    if not isTeamPlay() then
        local error = 'does not support FFA.\n\nSupported gamemodes are:\nCTF, Team-Slayer, Team-Race, Team-KOTH and Team-OddBall, etc.'
        unregisterSAPPEvents(error)
    else
        if tonumber(required_players) < 3 then
            local error = 'variable "required_players" cannot be less than 3!'
            unregisterSAPPEvents(error)
        else
            resetAllParameters()
            local function oddOrEven(Min, Max)
                math.randomseed(os.time())
                math.random();
                local num = math.random(Min, Max)
                if (num) then
                    return num
                end
            end
            if (oddOrEven(1, 2) % 2 == 0) then
                -- Number is even
                useEvenNumbers = true
            else
                -- Number is odd
                useEvenNumbers = false
            end
        end
    end
end

function OnGameEnd()
    -- resetAllParameters() | Ensures all parameters are set to their default values.
    resetAllParameters()
end

-- #This function ensures all parameters are set to their default values.
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

    if (getPlayerCount() >= required_players) and (init_countdown == false) and not (gamestarted) then
        startTimer()
    end

    -- If there is less than "required_players" then print the continuous message emitted when there aren't enough players to start the game. 
    if (getPlayerCount() >= 1 and getPlayerCount() < required_players) then
        print_nep = true
    end
    
    if (getPlayerCount() >= required_players) and (print_nep == true) then
        print_nep = false
    end
    
    -- Only sort player into new team if the game has already started...
    if (gamestarted) then
        -- Red team has less players (join this team)
        if (red_count < blue_count) then
            SwitchTeam(PlayerIndex, "red", true)
            red_count = red_count + 1

            -- Blue team has less players (join this team)
        elseif (blue_count < red_count) then
            SwitchTeam(PlayerIndex, "blue", true)
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
                SwitchTeam(PlayerIndex, "red", true)
            elseif (new_team == "blue") then
                blue_count = blue_count + 1
                SwitchTeam(PlayerIndex, "blue", true)
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
                        if (team == "red" and team ~= "blue") or (team == "blue" and team ~= "red") then
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
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex and gamestarted) then

        local cTeam = get_var(CauserIndex, "$team")
        local vTeam = get_var(PlayerIndex, "$team")

        if (cTeam == vTeam) then
            -- Removed comments to use
            -- rprint(CauserIndex, "|l " .. get_var(CauserIndex, "$name") .. ", please don't team shoot!")
            return false -- Return false to prevent team damage
        end
    end
end

function killPlayer(PlayerIndex)
    local PlayerObject = read_dword(get_player(PlayerIndex) + 0x34)
    if PlayerObject ~= nil then
        destroy_object(PlayerObject)
    end
end

function SwitchTeam(PlayerIndex, team, bool)
    if not (bool) then
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
    else
        execute_command("st " .. tonumber(PlayerIndex) .. " " .. tostring(team))
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
    --cprint("stopTimer() | called", 2+8)
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
            break
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
    return tonumber(count)
end

function sortPlayers(PlayerIndex)
    if (gamestarted) then
        if (useEvenNumbers == true) then
            if (tonumber(PlayerIndex) % 2 == 0) then
                setTeam(PlayerIndex, "blue")
            else
                setTeam(PlayerIndex, "red")
            end
        else
            if (tonumber(PlayerIndex) % 2 == 0) then
                setTeam(PlayerIndex, "red")
            else
                setTeam(PlayerIndex, "blue")
            end
        end
    end
end

function setTeam(PlayerIndex, team)
    
    deleteWeapons(PlayerIndex)
    local PlayerObject = get_dynamic_player(PlayerIndex)
    if (PlayerObject ~= 0) then
        write_word(PlayerObject + 0x31E, 0)
        write_word(PlayerObject + 0x31F, 0)
    end
    
    killPlayer(PlayerIndex)
    SwitchTeam(tonumber(PlayerIndex), tostring(team))
    
    if team == "red" then
        red_count = red_count + 1
    elseif team == "blue" then
        blue_count = blue_count + 1
    end
    
    execute_command("score " .. PlayerIndex .. " 0")
    execute_command("kills " .. PlayerIndex .. " 0")
    execute_command("deaths " .. PlayerIndex .. " 0")
    execute_command("assists " .. PlayerIndex .. " 0")
end

function deleteWeapons(PlayerIndex)
    local PlayerObject = get_dynamic_player(PlayerIndex)
    if (PlayerObject ~= 0) then
        local WeaponID = read_dword(PlayerObject + 0x118)
        if WeaponID ~= 0 then
            for j = 0, 3 do
                local ObjectID = read_dword(PlayerObject + 0x2F8 + j * 4)
                destroy_object(ObjectID)
            end
        end
    end
end

function unregisterSAPPEvents(error)
    unregister_callback(cb['EVENT_TICK'])
    unregister_callback(cb['EVENT_GAME_END'])
    unregister_callback(cb['EVENT_JOIN'])
    unregister_callback(cb['EVENT_LEAVE'])
    unregister_callback(cb['EVENT_DIE'])
    unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])

    execute_command("log_note \"" .. string.format('[' .. script_name .. '] ' .. error) .. "\"")
    cprint(string.format('[' .. script_name .. '] ' .. error), 4 + 8)
end

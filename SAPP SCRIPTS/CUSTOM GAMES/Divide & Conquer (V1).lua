--[[
--=====================================================================================================--
Script Name: Divide & Conquer (V1), for SAPP (PC & CE)
#Description: This version of Divide & Conquer incorporates CUSTOM TEAMS for FFA games: Slayer, King-Slayer, Race-Slayer and OddBall-Slayer, etc.
              The game mechanics are as follows:
              When you kill someone on the opposing team, the victim is switched to your team. 
              The main objective is to dominate the opposing team.
              When the aforementioned opposing team has no players left the game is over.
             
#Bonus Features:
    - Editable custom team colors (see lines 90 & 91)
    - /list command (list all players and their respective teams)
    - /sort command (Reset all game parameters and initializes the pre-game countdown)

[!] WARNING: This game is in BETA and may have bugs.
    Please report all problems on gighub.
    https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues/new?template=bug_report.md
             
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
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

-- #End of Game message (%team% will be replaced with the winning team)
end_of_game = "The %team% team won!"

-- #Pre Game message
pre_game_message = "Game will begin in %time_remaining% seconds"

-- # Continuous player count message
playerCountMessage = "REDS: %red_count%, BLUES: %blue_count% | You are on %team% team."

-- Server Prefix
server_prefix = "SERVER "

-- Minimum privilege level require to use "/sort" command
min_privilege_level = 1

-- #Commands
-- Resets all game parameters, sort players into teams of two and initiates the game-start countdown
sort_command = "sort"

-- Lists all players and their team. (global override)
list_command = "list"

-- Left = l,    Right = r,    Centre = c,    Tab: t
message_alignment = "l"

-- Numbers of players required to set the game in motion.
required_players = 6

-- Continuous message emitted when there aren't enough players.
not_enough_players = "%current_players%/%required_players% players needed to start the game"

-- #Team Colors
--[[
    Color IDs
    0       =   white
    1       =   black
    2       =   red
    3       =   blue
    4       =   gray
    5       =   yellow
    6       =   green
    7       =   pink
    8       =   purple
    9       =   cyan
    10      =   cobalt
    11      =   orange
    12      =   teal
    13      =   sage
    14      =   brown
    15      =   tan
    16      =   maroon
    17      =   salmon
]]--
red_team_color = 2
blue_team_color = 3

-- Configuration [ends] << ----------



-- tables --
spawns = { }
players = { }
team = { }
print_countdown = {}

player_count = {}

-- Tables for /list command
stored_data = {}

-- Booleans
gamestarted = nil
print_counts = {}
red_count = 0
blue_count = 0

first_start = nil
script_name = "Divide & Conquer V1"

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb["EVENT_GAME_START"], "OnNewGame")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")

    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerLeave")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb['EVENT_SPAWN'], 'OnPlayerSpawn')
    register_callback(cb['EVENT_PRESPAWN'], 'OnPlayerPrespawn')

    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
end

function OnScriptUnload()

end

function OnNewGame()
    if isTeamPlay() then
        local error = 'does not support Team Play.\n\nSupported gamemodes are:\nSlayer, King-Slayer, Race-Slayer and OddBall-Slayer, etc.'
        unregisterSAPPEvents(error)
    else
        if tonumber(required_players) < 3 then
            local error = 'variable "required_players" cannot be less than 3!'
            unregisterSAPPEvents(error)
        else
            local function oddOrEven(Min, Max)
                math.randomseed(os.time())
                math.random();
                local num = math.random(Min, Max)
                if (num) then
                    return num
                end
            end
            if (oddOrEven(1, 1000) % 2 == 0) then
                -- Number is even
                useEvenNumbers = true
            else
                -- Number is odd
                useEvenNumbers = false
            end
            first_start = true
        end
    end
end

function OnGameEnd()
    stopTimer()
    local function resetGameParamaters()
        for i = 1, 16 do
            if player_present(i) then
                players[get_var(i, "$name")].team = nil
                hidePreGameCountdown(i)
                clearPlayerList(tonumber(i))
                removePlayer(i)
            end
        end
        blue_count = 0
        red_count = 0
        print_nep = false
        gamestarted = false
    end
    resetGameParamaters()
end

function gameOver(message)
    for i = 1, 16 do
        if player_present(i) then
            cls(i)
            rprint(i, "|c ======================================")
            rprint(i, "|c " .. message)
            rprint(i, "|c ======================================")
            for _ = 1, 10 do
                rprint(i, " ")
            end
        end
    end
    execute_command("sv_map_next")
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
        countdown = countdown + 0.030

        local seconds = secondsToTime(countdown)
        timeRemaining = delay - math.floor(seconds)

        -- Pre-Game message.
        for i = 1, 16 do
            if (player_present(i) and not gamestarted) then
                if (print_countdown[tonumber(i)] == true) then
                    cls(i)
                    local preGameMessage = string.gsub(pre_game_message, "%%time_remaining%%", tonumber(timeRemaining))
                    rprint(i, preGameMessage)
                end
            end
        end

        --cprint("Game will begin in " .. timeRemaining .. " seconds", 4 + 8)

        if (timeRemaining <= 0) then
            for j = 1, 16 do
                if (player_present(j)) then
                    cls(j)
                    hidePreGameCountdown(j)
                    execute_command("score " .. j .. " 0")
                    execute_command("kills " .. j .. " 0")
                    execute_command("deaths " .. j .. " 0")
                    execute_command("assists " .. j .. " 0")
                end
            end
            --cprint("The game has begun!", 2 + 8)
            gamestarted = true
            sortPlayers()
            stopTimer()
        end
    end
    if (gamestarted == true) then
        for k = 1, 16 do
            if player_present(k) then
                if (print_counts[tonumber(k)] == true) then
                    cls(k)
                    local function formatMessage(message)
                        message = string.gsub(message, "%%red_count%%", tonumber(red_count))
                        message = string.gsub(message, "%%blue_count%%", tonumber(blue_count))
                        message = string.gsub(message, "%%team%%", players[get_var(k, "$name")].team)
                        return message
                    end
                    local message = formatMessage(playerCountMessage)
                    rprint(k, "|" .. message_alignment .. " " .. message)
                end
            end
        end
    end
end

function secondsToTime(seconds)
    seconds = seconds % 60
    return seconds
end

function startTimer()
    countdown = 0
    for i = 1, 16 do
        if player_present(i) then
            showPreGameCountdown(i)
        end
    end
    init_countdown = true
end

function stopTimer()
    countdown = 0
    init_countdown = false
    if timeRemaining ~= nil then
        --cprint("The countdown was stopped at " .. timeRemaining .. " seconds")
    end
    for i = 1, 16 do
        if player_present(i) then
            hidePreGameCountdown(i)
        end
    end
end

-- Sorts players into teams of two
function sortPlayers()
    if (gamestarted) then
        for i = 1, 16 do
            if player_present(i) then
                if (useEvenNumbers == true) then
                    if (tonumber(i) % 2 == 0) then
                        determineTeam(i, "blue")
                    else
                        determineTeam(i, "red")
                    end
                else
                    if (tonumber(i) % 2 == 0) then
                        determineTeam(i, "red")
                    else
                        determineTeam(i, "blue")
                    end
                end
            end
        end
    end
end

function determineTeam(PlayerIndex, team)
    saveTable(get_var(PlayerIndex, "$name"), team)
    players[get_var(PlayerIndex, "$name")].team = tostring(team)

    --cprint(get_var(PlayerIndex, "$name") .. "'s team is " .. team)
    if team == "red" then
        red_count = red_count + 1
    elseif team == "blue" then
        blue_count = blue_count + 1
    end
    killPlayer(PlayerIndex, players[get_var(PlayerIndex, "$name")].team)
end

function OnPlayerJoin(PlayerIndex)

    addPlayer(PlayerIndex)
    -- Pre-game countdown has already begun (required players are online). Show the countdown to the joining player.
    if (getPlayerCount() >= required_players) and not (gamestarted) and (init_countdown == true) then
        -- Show pre-game countdown to this player
        showPreGameCountdown(PlayerIndex)
    end

    if (first_start == true) and (getPlayerCount() >= required_players) then
        first_start = false
        startTimer()
    end

    if (getPlayerCount() >= 1 and getPlayerCount() < required_players) then
        print_nep = true
    end

    players[get_var(PlayerIndex, "$name")] = { }
    players[get_var(PlayerIndex, "$name")].team = nil

    -- Only sort player into new team if the game has already started...
    if (gamestarted == true) then
        -- Red team has less players (join this team)
        if (red_count < blue_count) then
            players[get_var(PlayerIndex, "$name")].team = "red"
            red_count = red_count + 1
            saveTable(get_var(PlayerIndex, "$name"), players[get_var(PlayerIndex, "$name")].team)
            setColor(tonumber(PlayerIndex), players[get_var(PlayerIndex, "$name")].team)
            -- Blue team has less players (join this team)
        elseif (blue_count < red_count) then
            players[get_var(PlayerIndex, "$name")].team = "blue"
            blue_count = blue_count + 1
            saveTable(get_var(PlayerIndex, "$name"), players[get_var(PlayerIndex, "$name")].team)
            setColor(tonumber(PlayerIndex), players[get_var(PlayerIndex, "$name")].team)
            -- Teams are even | Choose random team.
        elseif (blue_count == red_count) then
            local new_team = pickRandomTeam()
            players[get_var(PlayerIndex, "$name")].team = new_team
            setColor(tonumber(PlayerIndex), players[get_var(PlayerIndex, "$name")].team)
            saveTable(get_var(PlayerIndex, "$name"), new_team)
            if (new_team == "red") then
                red_count = red_count + 1
            elseif (new_team == "blue") then
                blue_count = blue_count + 1
            end
        end
        -- If the game has already started call showTeamCounts()
        showTeamCounts(PlayerIndex)
    end
end

function OnPlayerLeave(PlayerIndex)
    local team = players[get_var(PlayerIndex, "$name")].team

    if (team == "red") then
        red_count = red_count - 1
    elseif (team == "blue") then
        blue_count = blue_count - 1
    end
    clearPlayerList(PlayerIndex)

    -- Deduct player from 'player_count' table.
    removePlayer(PlayerIndex)

    if (gamestarted) then
        if ((getPlayerCount() == nil) or (getPlayerCount() <= 0)) then
            local function resetGameParamaters()
                for i = 1, 16 do
                    players[get_var(i, "$name")].team = nil
                    print_countdown[i] = false
                end
                blue_count = 0
                red_count = 0
                gamestarted = false
            end
            -- Ensures all parameters are set to their default values.
            resetGameParamaters()
            -- One player remains | ends the game.
        elseif ((getPlayerCount() ~= nil) and (getPlayerCount() == 1)) then
            for i = 1, 16 do
                if (tonumber(i) ~= tonumber(PlayerIndex)) then
                    if player_present(i) then
                        local team = players[get_var(i, "$name")].team
                        gameOver(string.gsub(end_of_game, "%%team%%", team))
                        break
                    end
                end
            end
            -- Checks if the remaining players are on the same team | ends the game.
        elseif (getPlayerCount() ~= nil) then 
            if (blue_count <= 0 and red_count >= 1) then
                gameOver(string.gsub(end_of_game, "%%team%%", "red"))
            elseif (red_count <= 0 and blue_count >= 1) then
                gameOver(string.gsub(end_of_game, "%%team%%", "blue"))
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
            first_start = true
        end
    end
end

function clearPlayerList(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    for i, v in ipairs(stored_data) do
        if string.match(v, name) then
            table.remove(stored_data, i)
            break
        end
    end
end

function pickRandomTeam()
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

function isTeamPlay()
    if get_var(0, "$ffa") == "0" then
        return true
    else
        return false
    end
end

function OnPlayerPrespawn(PlayerIndex)
    if (gamestarted == true) then
        local team = players[get_var(PlayerIndex, "$name")].team
        spawnPlayer(PlayerIndex, team)
        rprint(PlayerIndex, "You are on " .. team .. " team")
        --cprint(get_var(PlayerIndex, "$name") .. " is now on " .. team .. " team.")
    end
end

function OnPlayerSpawn(PlayerIndex)
    --
end

function spawnPlayer(PlayerIndex, Team)
    local player = get_dynamic_player(PlayerIndex)
    if (player ~= 0) then
        local map = get_var(0, "$map")
        local x, y, z
        if (Team == "blue") then
            local id = chooseRandomSpawn("blue", map)
            x = spawns[map].blue[id][1]
            y = spawns[map].blue[id][2]
            z = spawns[map].blue[id][3]
        elseif (Team == "red") then
            local id = chooseRandomSpawn("red", map)
            x = spawns[map].red[id][1]
            y = spawns[map].red[id][2]
            z = spawns[map].red[id][3]
        end
        --cprint(get_var(PlayerIndex, "$name") .. " spawned at " .. x .. ", " .. y .. ", " .. z)
        write_vector3d(player + 0x5C, x, y, z + 0.3)
    end
end

function chooseRandomSpawn(team, map)
    local coordIndex = 0
    local function pickRandomCoord(Min, Max)
        return rand(Min, Max)
    end
    if (team == "blue") then
        local num = pickRandomCoord(1, tonumber(#spawns[map].blue))
        coordIndex = num
        --cprint("Blue number chosen: " .. num)
    elseif (team == "red") then
        local num = pickRandomCoord(1, tonumber(#spawns[map].red))
        coordIndex = num
        --cprint("Red number chosen: " .. num)
    end
    return coordIndex
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    if (string.lower(Command) == tostring(sort_command)) then
        if hasPermission(PlayerIndex) then
            if (getPlayerCount() >= required_players) then
                local function resetGameParamaters()
                    for i = 1, 16 do
                        if player_present(i) then
                            players[get_var(i, "$name")].team = nil
                            hidePreGameCountdown(i)
                            clearPlayerList(tonumber(i))
                        end
                    end
                    blue_count = 0
                    red_count = 0
                    gamestarted = false
                end
                resetGameParamaters()
                startTimer()
                rprint(PlayerIndex, "Resetting game parameters...")
            else
                rprint(PlayerIndex, "Not enough players!")
            end
        else
            rprint(PlayerIndex, "Insufficient Permission")
        end
        return false
    elseif (string.lower(Command) == tostring(list_command)) then
        if (gamestarted) and (print_counts[tonumber(PlayerIndex)] == true) then
            hideTeamCounts(PlayerIndex)
            concatValues(PlayerIndex, 1, 2)
            -- concatValues(PlayerIndex, 5,8)
            -- concatValues(PlayerIndex, 9,12)
            -- concatValues(PlayerIndex, 13,16)
            timer(1000 * 3, "showTeamCounts", PlayerIndex)
        elseif not (gamestarted) then
            hidePreGameCountdown(PlayerIndex)
            cls(PlayerIndex)
            rprint(PlayerIndex, "Game is still starting...")
            timer(1000 * 2, "showPreGameCountdown", PlayerIndex)
        end
        return false
    end
end

------------------------------------------------------------------
function showTeamCounts(PlayerIndex)
    print_counts[tonumber(PlayerIndex)] = true
end

function hideTeamCounts(PlayerIndex)
    print_counts[tonumber(PlayerIndex)] = false
end

function showPreGameCountdown(PlayerIndex)
    print_countdown[tonumber(PlayerIndex)] = true
end

function hidePreGameCountdown(PlayerIndex)
    print_countdown[tonumber(PlayerIndex)] = false
end
------------------------------------------------------------------

function OnPlayerDeath(PlayerIndex, KillerIndex)

    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)

    if (killer ~= -1) and (killer ~= 0) and (killer ~= nil) and (killer > 0) and (victim ~= killer) then
        local kTeam = players[get_var(killer, "$name")].team

        if players[get_var(killer, "$name")].team == "red" then
            SwitchTeam(victim, "red")
            saveTable(get_var(victim, "$name"), "red", true)
            blue_count = blue_count - 1
            red_count = red_count + 1

        elseif players[get_var(killer, "$name")].team == "blue" then
            SwitchTeam(victim, "blue")
            saveTable(get_var(victim, "$name"), "blue", true)
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
            players[get_var(victim, "$name")].team = kTeam
        end

        if (gamestarted) then

            execute_command("msg_prefix \"\"")
            say_all(get_var(victim, "$name") .. " is now on " .. kTeam .. " team.")
            execute_command("msg_prefix \" " .. server_prefix .. "\"")

            setColor(tonumber(victim), kTeam)
            --cprint(get_var(victim, "$name") .. " is now on " .. team .. " team.")
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex and gamestarted) then

        local cTeam = players[get_var(CauserIndex, "$name")].team
        local vTeam = players[get_var(PlayerIndex, "$name")].team

        if (cTeam == vTeam) then

            -- Removed comments to use
            -- hideTeamCounts(CauserIndex)
            -- rprint(CauserIndex, "|l " .. get_var(CauserIndex, "$name") .. ", please don't team shoot!")
            -- timer(1000 * 2, "showTeamCounts", CauserIndex)

            return false -- Return false to prevent team damage
        end
    end
end

function SwitchTeam(PlayerIndex, Team)
    players[get_var(PlayerIndex, "$name")].team = nil
    players[get_var(PlayerIndex, "$name")].team = tostring(Team)
end

function killPlayer(PlayerIndex, team)
    local PlayerObject = read_dword(get_player(PlayerIndex) + 0x34)
    setColor(tonumber(PlayerIndex), team)
    if PlayerObject ~= nil then
        destroy_object(PlayerObject)
    end
    showTeamCounts(PlayerIndex)
end

function cls(PlayerIndex)
    for _ = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

function hasPermission(PlayerIndex)
    if (tonumber(get_var(PlayerIndex, "$lvl"))) >= min_privilege_level then
        return true
    else
        return false
    end
end

function setColor(PlayerIndex, team)
    local color
    if (team == "red") then
        color = red_team_color
    else
        color = blue_team_color
    end
    local player = get_player(PlayerIndex)
    write_byte(player + 0x60, tonumber(color))
end

function sendToAll(PlayerIndex, Message)


end

-- Player Counts...
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
    return count
end

function saveTable(name, team, update)
    if (update == true) then
        for i, v in ipairs(stored_data) do
            if string.match(v, name) then
                table.remove(stored_data, i)
                break
            end
        end
    end
    local input = name .. " | " .. team
    table.insert(stored_data, input)
end

function concatValues(PlayerIndex, start_index, end_index)
    local word_table = {}
    local row
    for k, v in pairs(stored_data) do
        local words = tokenizestring(v, ",")
        for i = tonumber(start_index), tonumber(end_index) do
            if words[i] ~= nil then
                table.insert(word_table, words[i])
                row = table.concat(word_table, ",   ")
            end
        end
    end
    if row ~= nil then
        rprint(PlayerIndex, row)
    end
    for _ in pairs(word_table) do
        word_table[_] = nil
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { };
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- To add a map, simply follow the following format and repeat the structure as needed for each map.
spawns["mapnamehere"] = {
    red = {
        -- x,   y,    z
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 } -- Make sure the last entry in the table doesn't have a comma at the end.

    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }

    },
}

spawns["bloodgulch"] = {
    red = {
        { 92.335815429688, -160.96267700195, 1.7034857273102 },
        { 98.49340057373, -157.63900756836, 1.7034857273102 },
        { 94.421661376953, -156.70387268066, 1.7034857273102 },
        { 99.34334564209, -161.35060119629, 1.7034857273102 },
        { 97.290061950684, -163.53598022461, 1.7034857273102 },
        { 93.965179443359, -161.08256530762, 1.7034857273102 },
        { 86.749755859375, -157.65640258789, 0.048994019627571 },
        { 96.821678161621, -156.98571777344, 1.7034857273102 },
        { 91.893623352051, -157.78077697754, 1.7034857273102 },
        { 82.679779052734, -161.43428039551, 0.10210217535496 },
        { 89.481048583984, -153.50212097168, 0.29154032468796 },
        { 93.737098693848, -163.3981628418, 1.7034857273102 },
        { 84.152633666992, -160.48426818848, 0.054357394576073 }
    },
    blue = {
        { 32.070510864258, -88.901565551758, 0.09855629503727 },
        { 36.771701812744, -76.885299682617, 1.7034857273102 },
        { 38.242469787598, -74.925712585449, 1.7034857273102 },
        { 44.146770477295, -77.477615356445, 1.7034857273102 },
        { 41.87818145752, -81.025238037109, 1.7034857273102 },
        { 50.479667663574, -86.173034667969, 0.11015506088734 },
        { 38.590934753418, -76.47093963623, 1.7034857273102 },
        { 43.914459228516, -80.678703308105, 1.7034857273102 },
        { 41.994873046875, -77.401725769043, 1.7034857273102 },
        { 38.902805328369, -81.087158203125, 1.7034857273102 },
        { 38.125888824463, -82.836540222168, 1.7034857273102 },
        { 42.062110900879, -75.990867614746, 1.7034857273102 },
        { 42.136421203613, -75.054779052734, 1.7034857273102 },
        { 39.589454650879, -89.477188110352, 0.084063664078712 },
        { 30.553886413574, -89.435180664063, 0.12797956168652 },
        { 36.68635559082, -80.840293884277, 1.7034857273102 }
    }
}
spawns["deathisland"] = {
    red = {
        { -18.538986206055, -8.5001859664917, 9.6765661239624 },
        { -38.448387145996, -2.9931254386902, 5.7522735595703 },
        { -33.29126739502, -3.4957482814789, 9.4155035018921 },
        { -29.176237106323, -7.0299596786499, 9.5431461334229 },
        { -23.633543014526, -5.4300365447998, 9.6765661239624 },
        { -37.45280456543, -11.723978996277, 5.0560870170593 },
        { -18.509931564331, -5.4772553443909, 9.6765661239624 },
        { -23.576934814453, -8.6588821411133, 9.6765661239624 },
        { -26.352931976318, -13.972735404968, 9.4155035018921 },
        { -28.856315612793, 1.1647542715073, 9.4150333404541 },
        { -33.08366394043, -10.343729972839, 9.4155035018921 }
    },
    blue = {
        { 28.958292007446, 9.2130508422852, 8.0485229492188 },
        { 40.246520996094, 20.334480285645, 4.5005683898926 },
        { 37.229133605957, 12.687339782715, 8.0485229492188 },
        { 40.267654418945, 11.339718818665, 4.6043677330017 },
        { 32.152969360352, 24.810054779053, 8.0475730895996 },
        { 21.696300506592, 14.397915840149, 8.2942876815796 },
        { 37.433185577393, 18.928413391113, 8.0485229492188 },
        { 32.392066955566, 15.989958763123, 8.1750631332397 },
        { 26.893747329712, 17.75199508667, 8.2942876815796 }
    }
}
spawns["icefields"] = {
    red = {
        { 12.349956512451, -21.638484954834, 0.84209197759628 },
        { 36.725170135498, -24.237199783325, 0.74805599451065 },
        { 36.428340911865, -26.406589508057, 0.85234326124191 },
        { 12.209296226501, -19.920680999756, 0.95626193284988 },
        { 33.715755462646, -30.291788101196, 0.81404954195023 },
        { 32.947002410889, -12.14167881012, 0.83322793245316 },
        { 18.527048110962, -33.558696746826, 0.92365497350693 },
        { 31.383907318115, -11.04976940155, 0.81129199266434 },
        { 15.036896705627, -29.788257598877, 0.98148256540298 },
        { 36.168296813965, -18.909324645996, 0.96128541231155 }
    },
    blue = {
        { -86.459716796875, 78.437927246094, 0.59992152452469 },
        { -84.98934173584, 75.808876037598, 0.76766896247864 },
        { -65.36213684082, 85.164077758789, 0.75932174921036 },
        { -71.703575134277, 97.77613067627, 0.87879353761673 },
        { -87.248260498047, 91.701347351074, 0.7284654378891 },
        { -89.750289916992, 86.372695922852, 0.97714310884476 },
        { -89.60799407959, 89.307273864746, 0.80424469709396 },
        { -65.772941589355, 86.602676391602, 0.78702139854431 },
        { -67.642189025879, 91.365821838379, 0.78669267892838 },
        { -68.54810333252, 94.612495422363, 0.84556406736374 }
    }
}
spawns["infinity"] = {
    red = {
        { 0.66793447732925, -169.32646179199, 12.927472114563 },
        { -18.661291122437, -148.98847961426, 13.536150932312 },
        { 0.67083704471588, -124.41680145264, 11.727275848389 },
        { 17.710308074951, -148.59934997559, 12.942746162415 },
        { 5.7096247673035, -168.78758239746, 12.533758163452 },
        { 15.390788078308, -165.97067260742, 12.992780685425 },
        { 3.3058676719666, -134.48400878906, 15.970171928406 },
        { -2.2425718307495, -135.00886535645, 15.970171928406 },
        { -6.8978986740112, -168.87452697754, 12.907674789429 },
        { 4.787525177002, -148.88661193848, 15.970171928406 },
        { -2.7240271568298, -145.75926208496, 15.970171928406 }
    },
    blue = {
        { 7.9745297431946, 7.6485033035278, 10.071369171143 },
        { -1.8167527914047, 16.871765136719, 14.086401939392 },
        { 1.1913630962372, 17.336032867432, 14.086401939392 },
        { -5.1978807449341, 17.847864151001, 14.086401939392 },
        { 20.818552017212, 43.314849853516, 9.9502305984497 },
        { 16.002014160156, 32.883506774902, 9.8716163635254 },
        { 1.8312684297562, 29.850065231323, 14.086401939392 },
        { -1.8341739177704, 52.418235778809, 10.056991577148 },
        { -7.0864315032959, 7.2791934013367, 10.160329818726 },
        { -5.2888140678406, 27.752103805542, 14.086401939392 }
    }
}
spawns["sidewinder"] = {
    red = {
        { -31.258619308472, -43.976661682129, -3.8419578075409 },
        { -33.037658691406, -32.997089385986, -3.8419578075409 },
        { -32.569843292236, -37.06022644043, -3.8419578075409 },
        { -30.923910140991, -28.509281158447, -3.8419578075409 },
        { -32.911678314209, -44.087635040283, -3.8419578075409 },
        { -32.853881835938, -38.795761108398, -3.8419578075409 },
        { -28.122875213623, -31.554048538208, -3.8419578075409 },
        { -28.43493270874, -29.41407585144, -3.8419578075409 },
        { -32.521022796631, -35.424938201904, -3.8419578075409 },
        { -37.145084381104, -30.514505386353, -3.7960402965546 },
        { -29.851600646973, -28.036405563354, -3.8419578075409 },
        { -31.263982772827, -38.972988128662, -3.8419578075409 }
    },
    blue = {
        { 29.698610305786, -45.090045928955, -3.8419578075409 },
        { 31.02855682373, -39.486019134521, -3.8419578075409 },
        { 27.602350234985, -32.158550262451, -3.7762582302094 },
        { 29.75350189209, -39.501522064209, -3.8419578075409 },
        { 33.678600311279, -36.111186981201, -3.8419578075409 },
        { 29.643436431885, -42.967548370361, -3.8419578075409 },
        { 30.820363998413, -32.454116821289, -3.8236918449402 },
        { 33.46337890625, -33.007621765137, -3.8419578075409 },
        { 30.984680175781, -41.121726989746, -3.8419578075409 },
        { 29.63595199585, -41.267040252686, -3.8419578075409 },
        { 31.035552978516, -42.95240020752, -3.8419578075409 },
        { 33.877208709717, -34.439239501953, -3.8419578075409 },
        { 31.069696426392, -47.785095214844, -3.8419578075409 },
        { 30.243196487427, -36.75874710083, 0.55805969238281 }
    }
}
spawns["timberland"] = {
    red = {
        { 24.899293899536, -49.353713989258, -17.23837852478 },
        { 15.931830406189, -62.23815536499, -17.752391815186 },
        { 18.234189987183, -63.120403289795, -17.752391815186 },
        { 20.482709884644, -48.143100738525, -17.735666275024 },
        { 13.913864135742, -48.064262390137, -17.710592269897 },
        { 23.911102294922, -45.945335388184, -17.514602661133 },
        { 15.908537864685, -62.275199890137, -13.352390289307 },
        { 10.800495147705, -44.862014770508, -17.66937828064 },
        { 16.405574798584, -63.097316741943, -17.752391815186 },
        { 15.356611251831, -45.678749084473, -17.950883865356 },
        { 7.8610053062439, -46.838832855225, -16.916284561157 },
        { 18.64838218689, -62.339916229248, -17.752391815186 },
        { 16.314317703247, -62.985164642334, -13.352390289307 }
    },
    blue = {
        { -17.365644454956, 63.138744354248, -17.752391815186 },
        { -10.444387435913, 45.696666717529, -17.631881713867 },
        { -13.179409980774, 48.047534942627, -17.71332359314 },
        { -23.842981338501, 50.048477172852, -17.220743179321 },
        { -15.037413597107, 62.283344268799, -13.352390289307 },
        { -15.458015441895, 63.018238067627, -13.352390289307 },
        { -7.9673452377319, 47.483375549316, -17.08081817627 },
        { -17.434274673462, 63.034526824951, -13.352390289307 },
        { -17.821243286133, 62.268184661865, -13.352390289307 },
        { -15.282235145569, 63.168159484863, -17.752391815186 },
        { -15.761499404907, 64.233680725098, -13.352390289307 },
        { -19.737129211426, 48.241325378418, -17.692188262939 },
        { -15.200108528137, 46.522144317627, -17.887096405029 }
    }
}
spawns["dangercanyon"] = {
    red = {
        { -4.3616456985474, -1.4469473361969, -4.0277991294861 },
        { -4.6325550079346, -4.9164910316467, -4.023636341095 },
        { -3.8159327507019, -6.2884621620178, -4.0235781669617 },
        { -3.4514932632446, -0.65246486663818, -4.0298867225647 },
        { -3.9750578403473, -1.0678622722626, -4.0287656784058 },
        { -23.029567718506, 1.9649690389633, -4.0074954032898 },
        { -4.6393790245056, -2.1145560741425, -4.0272722244263 },
        { -4.741868019104, -13.965376853943, -4.1875720024109 },
        { -3.1951389312744, -6.5662884712219, -4.0230536460876 },
        { -20.79656791687, 1.9564373493195, -4.0343279838562 },
        { -26.023094177246, 1.9345624446869, -3.675952911377 },
        { -26.52124786377, -10.399559020996, -3.3744485378265 }
    },
    blue = {
        { 21.861297607422, 2.0833029747009, -4.0348057746887 },
        { 27.726266860962, -9.7855548858643, -3.0125367641449 },
        { 6.2013483047485, -14.564002037048, -4.2066764831543 },
        { 24.353893280029, -11.410313606262, -3.9447219371796 },
        { 4.531192779541, -2.4122931957245, -4.0271606445313 },
        { 2.7145702838898, -12.02255821228, -4.1104803085327 },
        { 19.852655410767, 2.0225722789764, -4.0345087051392 },
        { 3.1804950237274, -0.63578718900681, -4.0300216674805 },
        { 4.9512724876404, -14.052338600159, -4.1903471946716 },
        { 31.10838508606, -8.8067760467529, -2.0275902748108 },
        { 4.2721419334412, -5.5999097824097, -4.0237712860107 },
        { 2.1426219940186, -10.843505859375, -4.0635967254639 }
    }
}
spawns["beavercreek"] = {
    red = {
        { 30.04444694519, 15.422694206238, -0.21670201420784 },
        { 22.504194259644, 13.706153869629, -0.21670201420784 },
        { 24.970621109009, 16.996942520142, -0.21670201420784 },
        { 25.544454574585, 8.1933794021606, -0.21670201420784 },
        { 27.890260696411, 16.957122802734, -0.21670201420784 },
        { 27.851728439331, 15.174530029297, -0.21670201420784 },
        { 21.476913452148, 17.11570930481, -0.21670201420784 },
        { 22.410709381104, 12.095768928528, -0.21670201420784 },
        { 30.032762527466, 12.173666954041, -0.21670201420784 },
        { 28.939155578613, 16.990682601929, -0.21670201420784 },
        { 24.506622314453, 10.438158035278, -1.3557163476944 },
        { 26.280954360962, 16.967021942139, -0.21670201420784 },
        { 27.83571434021, 10.558755874634, -0.21670201420784 },
        { 30.05682182312, 13.633389472961, -0.21670201420784 },
        { 27.763431549072, 13.470419883728, -0.21670201420784 }
    },
    blue = {
        { 5.6826076507568, 11.994840621948, -0.18189066648483 },
        { 4.3431868553162, 13.770686149597, -1.3557163476944 },
        { 1.7286434173584, 16.963109970093, -0.15480306744576 },
        { 7.7941837310791, 11.151169776917, -1.3557163476944 },
        { 2.3467900753021, 19.377599716187, -0.21670201420784 },
        { 6.7001428604126, 15.425190925598, -0.21670201420784 },
        { 3.0429553985596, 17.071189880371, -0.15480306744576 },
        { 3.480161190033, 17.379688262939, -1.3557163476944 },
        { 0.29620450735092, 12.354642868042, -0.15480306744576 },
        { 0.2988206744194, 15.968877792358, -0.15480306744576 },
        { 7.1852068901062, 10.459509849548, -0.21670201420784 },
        { 5.7395868301392, 10.531374931335, -0.15480306744576 },
        { -2.1050710678101, 10.439389228821, -0.15480306744576 },
        { 0.15301039814949, 10.563059806824, -0.15480306744576 },
        { 5.5290536880493, 13.789867401123, -0.17312896251678 }
    }
}
spawns["boardingaction"] = {
    red = {
        { -0.50980299711227, 5.9485607147217, 0.21994565427303 },
        { -0.47266405820847, 12.488017082214, 0.21994565427303 },
        { -0.99109959602356, 1.7652922868729, 0.21994565427303 },
        { 2.9928863048553, -3.6211798191071, 0.21994565427303 },
        { -0.89608758687973, -3.1955454349518, 0.21994565427303 },
        { 1.2871744632721, -10.724523544312, 0.21994565427303 },
        { -0.71490186452866, -11.638904571533, 2.7201879024506 },
        { 1.5835245847702, 4.2032608985901, 0.21994565427303 },
        { -0.35287210345268, 4.2209982872009, 0.21994565427303 },
        { 0.13645935058594, 20.984214782715, -2.2814738750458 },
        { 1.4681249856949, 2.8964080810547, 0.21994565427303 },
        { 3.9189093112946, 4.3902235031128, 0.21994565427303 },
        { -0.3987672328949, -4.345787525177, 0.21994565427303 },
        { 0.89085787534714, -6.3677654266357, 0.21994565427303 }
    },
    blue = {
        { 20.472343444824, -5.2985067367554, 0.21994565427303 },
        { 18.315965652466, 1.8376449346542, 0.21994565427303 },
        { 20.831701278687, 5.926420211792, 0.21994565427303 },
        { 18.311502456665, 3.2092146873474, 0.21994565427303 },
        { 18.010763168335, -3.1864588260651, 0.21994565427303 },
        { 20.523475646973, -12.669053077698, 0.21994565427303 },
        { 16.5169506073, 4.232617855072, 0.21994565427303 },
        { 20.463478088379, -6.5649285316467, 0.21994565427303 },
        { 20.405895233154, -8.0520248413086, 0.21994565427303 },
        { 16.992330551147, 1.8440707921982, 0.21994565427303 },
        { 17.918611526489, 6.2962083816528, 0.21994565427303 },
        { 20.395132064819, -0.39143571257591, 0.21994565427303 },
        { 19.718532562256, 7.4226751327515, 0.21994565427303 }
    }
}
spawns["carousel"] = {
    red = {
        { -1.9612928628922, -15.310041427612, -3.3578703403473 },
        { -4.7733659744263, -11.63485622406, -3.3578703403473 },
        { -0.18311108648777, -15.432957649231, -3.3578703403473 },
        { 10.690472602844, -11.068964958191, -3.3578703403473 },
        { 8.7844247817993, -9.1612176895142, -3.3578703403473 },
        { 8.6989660263062, -6.5577206611633, -0.85620224475861 },
        { 12.271952629089, -9.4782581329346, -3.3578703403473 },
        { 10.482060432434, -7.593807220459, -3.3578703403473 },
        { 1.9500740766525, -12.590942382813, -3.3578703403473 },
        { 1.88683116436, -15.314645767212, -3.3578703403473 },
        { -2.8558790683746, -10.640837669373, -0.85620224475861 },
        { 2.88126039505, -10.667360305786, -0.85620224475861 }
    },
    blue = {
        { -8.7360982894897, 8.9201946258545, -3.3578703403473 },
        { -10.372524261475, 7.7806286811829, -3.3578703403473 },
        { -7.7407026290894, 7.8396654129028, -3.3578703403473 },
        { -8.8138113021851, 6.2619471549988, -0.85620224475861 },
        { -1.9727636575699, 15.424068450928, -3.3578703403473 },
        { 2.9733974933624, 10.70557975769, -0.85620224475861 },
        { -10.872181892395, 11.159718513489, -3.3578703403473 },
        { -7.3630046844482, 10.50950050354, -3.3578703403473 },
        { 0.082598321139812, 12.463063240051, -3.3578703403473 },
        { 1.9495141506195, 15.243146896362, -3.3578703403473 },
        { 2.0604071617126, 12.687197685242, -3.3578703403473 }
    }
}
spawns["chillout"] = {
    red = {
        { 8.5678510665894, -3.4043335914612, 2.3814647197723 },
        { 10.078147888184, 0.23211160302162, 3.5348043441772 },
        { 7.6897640228271, -3.5377032756805, 2.3814647197723 },
        { 7.4297199249268, -0.9514799118042, 2.3814647197723 },
        { 6.5440855026245, -0.40433984994888, 2.3814647197723 },
        { 8.7469968795776, -1.5038994550705, 2.3814647197723 },
        { 6.7391095161438, -3.5425124168396, 2.3814647197723 },
        { 8.0357131958008, -2.0722267627716, 2.3814647197723 },
        { 6.2653517723083, -1.4532603025436, 2.3814647197723 },
        { 7.3581805229187, 0.13985796272755, 2.3814647197723 },
        { 10.565207481384, -3.8186051845551, 2.3814647197723 },
        { 7.0781021118164, -1.7849407196045, 2.3814647197723 }
    },
    blue = {
        { -8.7426242828369, 3.2310693264008, -6.8545341491699e-07 },
        { -6.0013566017151, 7.2255659103394, -6.8545341491699e-07 },
        { -3.1629779338837, 7.3952589035034, -6.8545341491699e-07 },
        { -8.6824922561646, 7.0075631141663, -6.8545341491699e-07 },
        { -8.9358501434326, 9.3254423141479, -6.8545341491699e-07 },
        { -6.2787280082703, 3.1099035739899, -6.8545341491699e-07 },
        { -6.7224349975586, 10.471884727478, -6.8545341491699e-07 },
        { -5.6014060974121, 9.3150081634521, -6.8545341491699e-07 },
        { -5.6330456733704, 6.2381453514099, -6.8545341491699e-07 },
        { -7.1813354492188, 7.1144022941589, -6.8545341491699e-07 },
        { -4.4675331115723, 9.8943710327148, -6.8545341491699e-07 },
        { -6.2001299858093, 8.433048248291, -6.8545341491699e-07 },
        { -3.234424829483, 8.416784286499, -6.8545341491699e-07 },
        { -9.0408210754395, 5.4250421524048, -6.8545341491699e-07 }
    }
}
spawns["damnation"] = {
    red = {
        { 7.4272933006287, -10.493174552917, 4.4997987747192 },
        { 9.6709489822388, -14.308075904846, 6.6999959945679 },
        { 10.944760322571, -12.26330280304, 6.6999959945679 },
        { 8.3357515335083, -5.8201489448547, 6.6999959945679 },
        { 4.9933772087097, -13.150937080383, 6.6999959945679 },
        { 7.1934690475464, -12.35390663147, 6.6999959945679 },
        { 3.725035905838, -12.533526420593, 6.6999959945679 },
        { 6.3332843780518, -10.47481918335, 4.4997987747192 },
        { 10.869058609009, -14.535705566406, 6.6999959945679 },
        { 3.8362946510315, -10.948040962219, 6.6999959945679 },
        { 3.6279838085175, -14.448362350464, 6.6999959945679 },
        { 8.6952295303345, -10.588641166687, 4.4997987747192 }
    },
    blue = {
        { -9.4853172302246, 13.566076278687, -0.39999997615814 },
        { -8.6792869567871, 10.68030166626, -0.39999997615814 },
        { 1.4872996807098, 13.516567230225, 1.199999332428 },
        { -10.791236877441, 9.8186092376709, -0.39999997615814 },
        { -10.86501789093, 13.422028541565, -0.39999997615814 },
        { -10.968146324158, 11.130529403687, -0.39999997615814 },
        { -12.447099685669, 9.6874198913574, -0.39999997615814 },
        { -10.925065040588, 12.391967773438, -0.39999997615814 },
        { 1.658237695694, 10.116777420044, 1.199999332428 },
        { -9.8199939727783, 9.9409236907959, -0.39999997615814 },
        { -12.314685821533, 12.218167304993, -0.39999997615814 },
        { -9.520489692688, 12.206961631775, -0.39999997615814 }
    }
}
spawns["gephyrophobia"] = {
    red = {
        { 30.670433044434, -126.63115692139, -15.627353668213 },
        { 25.561824798584, -125.41511535645, -15.625276565552 },
        { 30.713617324829, -121.14672851563, -18.325878143311 },
        { 23.051668167114, -121.27952575684, -18.325878143311 },
        { 21.893026351929, -123.52760314941, -15.633249282837 },
        { 25.102703094482, -142.83770751953, -17.733655929565 },
        { 31.706920623779, -123.40888214111, -15.633249282837 },
        { 28.09061050415, -125.38777160645, -15.625374794006 },
        { 28.504581451416, -142.8762512207, -17.733655929565 },
        { 23.063507080078, -126.66011810303, -15.627138137817 }
    },
    blue = {
        { 20.621385574341, -14.839776992798, -15.631712913513 },
        { 28.520044326782, -1.7324783802032, -17.733655929565 },
        { 23.072366714478, -23.737138748169, -18.325878143311 },
        { 25.545986175537, -18.771165847778, -15.625000953674 },
        { 30.620584487915, -23.768720626831, -18.325878143311 },
        { 25.577293395996, -20.088380813599, -18.325878143311 },
        { 23.084852218628, -17.468942642212, -15.627038955688 },
        { 25.060344696045, -1.7802549600601, -17.733655929565 },
        { 30.707805633545, -17.435459136963, -15.62735080719 }
    }
}
spawns["hangemhigh"] = {
    red = {
        { 16.892503738403, 11.041754722595, -4.3722739219666 },
        { 15.021856307983, 10.970652580261, -4.3817272186279 },
        { 16.113409042358, 11.013108253479, -4.3776831626892 },
        { 13.921890258789, 10.975045204163, -3.3629770278931 },
        { 13.200522422791, 12.990186691284, -6.4351902008057 },
        { 14.544616699219, 9.3582181930542, -3.3585000038147 },
        { 12.016085624695, 8.0572519302368, -5.7570786476135 },
        { 13.217492103577, 12.047595977783, -6.4351902008057 },
        { 12.823941230774, 7.1622262001038, -7.9501552581787 },
        { 11.019072532654, 7.2381939888, -6.4351902008057 },
        { 16.047494888306, 8.0758419036865, -3.362765789032 },
        { 13.071090698242, 10.229535102844, -6.4351902008057 },
        { 15.065064430237, 8.1251173019409, -4.8996820449829 },
        { 12.038636207581, 10.353602409363, -6.4351902008057 }
    },
    blue = {
        { 29.802261352539, -17.147300720215, -2.7927505970001 },
        { 31.097608566284, -17.126626968384, -2.7927505970001 },
        { 28.534753799438, -14.103565216064, -2.7927505970001 },
        { 26.315790176392, -16.294290542603, -3.908944606781 },
        { 32.246086120605, -13.990737915039, -1.8736279010773 },
        { 32.038024902344, -18.25749206543, -3.908944606781 },
        { 26.670574188232, -14.726491928101, -3.908944606781 },
        { 31.296976089478, -15.605163574219, -1.8736279010773 },
        { 26.527442932129, -17.461158752441, -3.908944606781 },
        { 28.731863021851, -17.060634613037, -2.7927505970001 },
        { 30.624994277954, -11.869297027588, -3.908944606781 },
        { 29.034006118774, -18.316291809082, -3.908944606781 },
        { 27.866386413574, -15.564130783081, -2.7927505970001 },
        { 32.489028930664, -12.96555519104, -3.908944606781 }
    }
}
spawns["longest"] = {
    red = {
        { -15.494320869446, -13.243384361267, -5.9008598327637e-06 },
        { -15.05996131897, -11.754866600037, -5.9008598327637e-06 },
        { -13.911919593811, -21.746643066406, -0.59999996423721 },
        { -8.1929082870483, -10.014311790466, 2.055890083313 },
        { -10.639325141907, -21.569036483765, -0.59999996423721 },
        { -12.081712722778, -16.926475524902, -5.9008598327637e-06 },
        { -14.839384078979, -15.364152908325, -5.9008598327637e-06 },
        { -13.572240829468, -16.952070236206, -5.9008598327637e-06 },
        { -10.942308425903, -16.924680709839, -5.9008598327637e-06 },
        { -17.10352897644, -12.61687374115, -5.9008598327637e-06 },
        { -14.956757545471, -18.830839157104, -0.59999996423721 },
        { -14.738379478455, -14.42776966095, -5.9008598327637e-06 }
    },
    blue = {
        { 10.411105155945, -12.404468536377, -5.9008598327637e-06 },
        { 12.583301544189, -13.670561790466, -5.9008598327637e-06 },
        { 6.4852156639099, -19.048547744751, 2.055890083313 },
        { 13.031784057617, -9.6216869354248, -0.59999996423721 },
        { 13.375617027283, -19.705715179443, -5.9008598327637e-06 },
        { 9.5686845779419, -9.3095407485962, -0.59999996423721 },
        { 12.869836807251, -12.270518302917, -5.9008598327637e-06 },
        { 12.626441955566, -14.890015602112, -5.9008598327637e-06 },
        { 12.518643379211, -8.2809791564941, -0.59999996423721 },
        { 9.6522264480591, -7.1273612976074, -0.59999996423721 },
        { 15.388852119446, -16.681806564331, -5.9008598327637e-06 },
        { 13.640830993652, -8.2041034698486, -0.59999996423721 },
        { 12.192328453064, -10.432541847229, -0.59999996423721 },
        { 10.172885894775, -8.1608867645264, -0.59999996423721 },
        { 9.2537593841553, -12.430336952209, -5.9008598327637e-06 }
    }
}
spawns["prisoner"] = {
    red = {
        { -8.2971677780151, -6.1891212463379, 3.192498922348 },
        { -5.503981590271, -6.2193198204041, 3.192498922348 },
        { -7.574604511261, -6.2971477508545, 1.392499089241 },
        { -7.2046356201172, -6.1516447067261, 5.5924792289734 },
        { -7.3238015174866, -1.3691195249557, 1.392499089241 },
        { -7.2627468109131, -6.108519077301, -0.40750074386597 },
        { -7.1904988288879, -4.9663982391357, 5.5924792289734 },
        { -6.3323006629944, -6.2009539604187, 3.192498922348 },
        { -7.3154788017273, -6.2133984565735, 3.192498922348 },
        { -6.2027497291565, -6.3212018013, 1.392499089241 }
    },
    blue = {
        { 9.5879125595093, 5.3244457244873, 5.5924792289734 },
        { 7.272216796875, 4.8178143501282, 3.192498922348 },
        { 7.2366561889648, 5.6448526382446, 5.5924792289734 },
        { 8.4643936157227, 6.2979941368103, 3.192498922348 },
        { 7.3711671829224, 4.2591962814331, 1.392499089241 },
        { 7.2633266448975, 1.4201191663742, 3.192498922348 },
        { 7.1652579307556, 4.2567667961121, 5.5924792289734 },
        { 7.2606372833252, 3.6661965847015, -0.40750074386597 },
        { 9.4785757064819, 5.1086173057556, 5.5924792289734 },
        { 7.315185546875, 3.1627607345581, 3.192498922348 },
        { 7.318030834198, 6.3248400688171, 5.5924792289734 },
        { 7.2266335487366, 4.9872803688049, 5.5924792289734 }
    }
}
spawns["putput"] = {
    red = {
        { -19.195474624634, -19.51815032959, 2.3022508621216 },
        { -18.334794998169, -20.788114547729, 2.3022508621216 },
        { -18.631101608276, -17.702938079834, 0.90232092142105 },
        { -17.470279693604, -21.946489334106, 2.3022508621216 },
        { -19.205366134644, -20.692743301392, 2.3022508621216 },
        { -16.191732406616, -18.263025283813, 2.3022508621216 },
        { -16.230821609497, -22.102115631104, 2.3022508621216 },
        { -16.818687438965, -20.972015380859, 2.3022508621216 },
        { -18.672073364258, -19.071649551392, 0.90232092142105 },
        { -16.729982376099, -19.20189666748, 0.90232092142105 },
        { -18.082273483276, -19.55376625061, 2.3022508621216 },
        { -18.636219024658, -21.039241790771, 0.90232092142105 },
        { -17.214651107788, -18.288097381592, 2.3022508621216 }
    },
    blue = {
        { 31.782913208008, -29.285978317261, 0.99994605779648 },
        { 31.686697006226, -24.712524414063, 0.99994605779648 },
        { 33.095001220703, -29.284278869629, -9.4622373580933e-06 },
        { 31.709014892578, -30.480623245239, 0.99994605779648 },
        { 30.686941146851, -27.027898788452, -9.4622373580933e-06 },
        { 30.880420684814, -28.19570350647, 0.99994605779648 },
        { 34.728820800781, -27.525884628296, -9.4622373580933e-06 },
        { 31.757585525513, -26.762041091919, 0.99994605779648 },
        { 30.695957183838, -29.176454544067, -9.4622373580933e-06 },
        { 29.15648651123, -28.208623886108, -9.4622373580933e-06 }
    }
}
spawns["ratrace"] = {
    red = {
        { 3.0154409408569, -4.1553363800049, -0.59107613563538 },
        { 1.8824696540833, 2.2126643657684, -0.59107613563538 },
        { 6.5424671173096, 0.68342006206512, -0.59107613563538 },
        { 5.1508321762085, -1.031324505806, -0.59107613563538 },
        { 0.2416558265686, 2.2755477428436, -0.59107613563538 },
        { -2.3760707378387, -4.1238741874695, -0.59107613563538 },
        { -6.2185029983521, 0.015614903531969, -0.59107613563538 },
        { -4.5445857048035, -4.1342144012451, -0.59107613563538 },
        { -4.9310464859009, 1.693318605423, -0.59107613563538 },
        { 7.3044319152832, -1.4827326536179, -0.59107613563538 },
        { 6.0051679611206, -3.6309859752655, -0.59107613563538 }
    },
    blue = {
        { 18.679357528687, -18.579433441162, -3.6122889518738 },
        { 18.685607910156, -20.32900428772, -3.6122889518738 },
        { 19.778047561646, -22.6539478302, -3.6122889518738 },
        { 21.847246170044, -24.348648071289, -3.6122889518738 },
        { 17.760570526123, -20.354469299316, -3.6122889518738 },
        { 17.334501266479, -24.498899459839, -3.6122889518738 },
        { 13.483751296997, -25.423290252686, -3.6122889518738 },
        { 19.808826446533, -20.372648239136, -3.6122889518738 },
        { 13.658970832825, -21.734451293945, -3.6122889518738 },
        { 16.120100021362, -21.677221298218, -3.6122889518738 },
        { 19.887952804565, -24.452486038208, -3.6122889518738 },
        { 10.834230422974, -10.744016647339, -2.8972747325897 }
    }
}
spawns["wizard"] = {
    red = {
        { -8.6417484283447, 7.4547395706177, -2.7504394054413 },
        { -6.7984209060669, 5.6883778572083, -2.7504394054413 },
        { -7.4692182540894, 11.140436172485, -2.7504394054413 },
        { -4.9098114967346, 3.5015225410461, -2.7504394054413 },
        { -9.8780527114868, 6.466112613678, -2.7504394054413 },
        { -3.839408159256, 4.8188724517822, -2.7504394054413 },
        { -12.050953865051, 3.4291882514954, -2.7504394054413 },
        { -6.4061532020569, 9.7303867340088, -2.7504394054413 },
        { -4.6679744720459, 8.85973072052, -4.5 },
        { -9.3099660873413, 2.0872540473938, -4.5 },
        { -7.525514125824, 8.6600284576416, -2.7504394054413 }
    },
    blue = {
        { 6.8866844177246, -5.5778636932373, -2.7504394054413 },
        { 3.4943203926086, -4.5830969810486, -2.7504394054413 },
        { 7.340024471283, -11.117883682251, -2.7504394054413 },
        { 7.4666090011597, -8.5619277954102, -2.7504394054413 },
        { 4.6170544624329, -3.3262963294983, -2.7504394054413 },
        { 9.97314453125, -6.3483080863953, -2.7504394054413 },
        { 11.089935302734, -7.3853874206543, -2.7504394054413 },
        { 10.448672294617, -3.3598237037659, -2.7504394054413 },
        { 5.4892315864563, -7.0626072883606, -2.7504394054413 },
        { 12.030035018921, -3.381739616394, -2.7504394054413 },
        { 8.9616222381592, -5.1861329078674, -4.5 },
        { 6.3624663352966, -9.9048795700073, -2.7504394054413 }
    }
}

function unregisterSAPPEvents(error)
    unregister_callback(cb['EVENT_TICK'])
    unregister_callback(cb['EVENT_GAME_END'])
    unregister_callback(cb['EVENT_JOIN'])
    unregister_callback(cb['EVENT_LEAVE'])
    unregister_callback(cb['EVENT_COMMAND'])
    unregister_callback(cb['EVENT_SPAWN'])
    unregister_callback(cb['EVENT_PRESPAWN'])
    unregister_callback(cb['EVENT_DIE'])
    unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])
    execute_command("log_note \"" .. string.format('[' .. script_name .. '] ' .. error) .. "\"")
    cprint(string.format('[' .. script_name .. '] ' .. error), 4 + 8)
end

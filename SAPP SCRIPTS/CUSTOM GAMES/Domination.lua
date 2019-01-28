--[[
--=====================================================================================================--
Script Name: Domination, for SAPP (PC & CE)
Description: This game incorporates custom teams for FFA games.
             The game mechanics are as follows:
             When you kill someone on the opposing team, the victim is switched to your team. 
             The main objective is to dominate the opposing team.
             When the aforementioned opposing team has no players left the game is over.
             
             * Bonus Features:
             - Custom team colours
             - /list command
             - /sort command

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts]

-- #Countdown delay (in seconds)
-- This is a game-start countdown initiated at the beginning of each game.
delay = 5

-- #End of Game message (%team% will be replaced with the winning team)
end_of_game = "The %team% team won!"

-- #Pre Game message
pre_game_message = "Game will begin in %time_remaining% seconds"

-- # Continuous player count message
playerCountMessage = "REDS: %red_count%, BLUES: %blue_count%"

-- Server Prefix
server_prefix = "**SERVER** "

-- Minimum privilege level require to use "/sort" command
min_privilege_level = 1

-- #Commands
-- Resets all game parameters, sort players into teams of two and initiates the game-start countdown
sort_command = "sort"

-- Lists all players and their team. (global override)
list_command = "list"

-- Left = l,    Right = r,    Centre = c,    Tab: t
message_alignment = "l"

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

-- Tables for /list command
stored_data = {}

-- Booleans
gamestarted = nil
print_counts = {}
red_count = 0
blue_count = 0

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

function OnNewGame()
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
    startTimer()
end

function OnGameEnd()
    stopTimer()
    gamestarted = false
    for i = 1,16 do
        if player_present(i) then
            print_countdown[tonumber(i)] = false
        end
    end
end

function OnTick()
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
                    print_countdown[tonumber(j)] = false
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
                        return message
                    end
                    local message = formatMessage(playerCountMessage)
                    rprint(k, "|" .. message_alignment .. " " ..message)
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
    for i = 1,16 do
        print_counts[tonumber(i)] = true
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
            cls(i)
        end
    end
end

-- Sorts players into teams of two
function sortPlayers()
    if (isTeamPlay() == false) and (gamestarted) then
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
    else
        -- do nothing [for now]
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
    if not isTeamPlay() then
        print_countdown[tonumber(PlayerIndex)] = true
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
                -- Teams are even
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
        end
    end
end

function OnPlayerLeave(PlayerIndex)
    clearListEntry(PlayerIndex)
end

function clearListEntry(PlayerIndex)
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
    if not isTeamPlay() then
        if (gamestarted == true) then
            local team = players[get_var(PlayerIndex, "$name")].team
            spawnPlayer(PlayerIndex, team)

            execute_command("msg_prefix \"\"")
            say(PlayerIndex, "You are on " .. team .. " team")
            execute_command("msg_prefix \" **" .. server_prefix .. "**\"")
            --cprint(get_var(PlayerIndex, "$name") .. " is now on " .. team .. " team.")
        end
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
            local function resetGameParamaters()
                for i = 1, 16 do
                    if player_present(i) then
                        players[get_var(i, "$name")].team = nil
                        print_countdown[tonumber(i)] = true
                        clearListEntry(tonumber(i))
                    end
                end
                blue_count = 0
                red_count = 0
                gamestarted = false
            end
            resetGameParamaters()
            startTimer()
        end
        rprint(PlayerIndex, "Sorting Players...")
        return false
    elseif (string.lower(Command) == tostring(list_command)) then
        -- counts showing | player list not showing | show player list | hide counts
        if (gamestarted) and (print_counts[tonumber(PlayerIndex)] == true) then
            print_counts[tonumber(PlayerIndex)] = false
            cls(PlayerIndex)
            for i = 1, 16 do
                if player_present(i) then
                    concatValues(i, 1, 16)
                end
            end
            timer(1000 * 3, "initPrintCounts", PlayerIndex)
        -- counts showing | player list not showing | show player list | hide counts
        elseif not (gamestarted) then
            cls(PlayerIndex)
            rprint(PlayerIndex, "Game is still starting...")
            timer(1000 * 3, "PrintCountdown", PlayerIndex)
        end
        return false
    end
end

function initPrintCounts(PlayerIndex)
    cls(PlayerIndex)
    print_counts[tonumber(PlayerIndex)] = true
end

function PrintCountdown(PlayerIndex)
    cls(PlayerIndex)
    print_countdown[tonumber(PlayerIndex)] = true
end

function OnPlayerDeath(PlayerIndex, KillerIndex)

    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    
    if (killer ~= -1) then

        local killer_team = players[get_var(killer, "$name")].team

        if tonumber(PlayerIndex) ~= tonumber(KillerIndex) then
        
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
                local message = string.gsub(end_of_game, "%%team%%", "blue")
                gameOver(message)
                -- No one left on BLUE team. | RED Team Wins
            elseif (blue_count == 0 and red_count >= 1) then
                local message = string.gsub(end_of_game, "%%team%%", "red")
                gameOver(message)
                -- Game is in play | switch player
            elseif (blue_count ~= 0 and red_count ~= 0) then
                players[get_var(victim, "$name")].team = killer_team
            end
            if (gamestarted) then
                local team = players[get_var(victim, "$name")].team
                execute_command("msg_prefix \"\"")
                say_all(get_var(victim, "$name") .. " is now on " .. team .. " team.")
                execute_command("msg_prefix \" **" .. server_prefix .. "**\"")
                setColor(tonumber(victim), team)
                --cprint(get_var(victim, "$name") .. " is now on " .. team .. " team.")
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex then

        local causer_team = players[get_var(CauserIndex, "$name")].team
        local victim_team = players[get_var(PlayerIndex, "$name")].team
        
        if (causer_team == victim_team) then
            execute_command("msg_prefix \"\"")
            say(CauserIndex, get_var(CauserIndex, "$name") .. ", please don't team shoot!")
            execute_command("msg_prefix \" **" .. server_prefix .. "**\"")
            return false
        end
        
    end
end

function SwitchTeam(PlayerIndex, team)
    players[get_var(PlayerIndex, "$name")].team = nil
    players[get_var(PlayerIndex, "$name")].team = tostring(team)
end

function gameOver(message)
    gamestarted = false
    execute_command("msg_prefix \"\"")
    say_all(message)
    execute_command("msg_prefix \" **" .. server_prefix .. "**\"")
    execute_command("sv_map_next")
end

function killPlayer(PlayerIndex, team)
    local PlayerObject = read_dword(get_player(PlayerIndex) + 0x34)
    setColor(tonumber(PlayerIndex), team)
    if PlayerObject ~= nil then
        destroy_object(PlayerObject)
    end
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
    for k, v in ipairs(stored_data) do
        local words = tokenizestring(v, ",")
        local word_table = {}
        local row
        for i = tonumber(start_index), tonumber(end_index) do
            if words[i] ~= nil then
                table.insert(word_table, words[i])
                row = table.concat(word_table, ", ")
            end
        end
        if row ~= nil then
            rprint(PlayerIndex, row)
        end
        for _ in pairs(word_table) do
            word_table[_] = nil
        end
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
        { 0.66793447732925, -169.32646179199, 12.927472114563},
        { -18.661291122437, -148.98847961426, 13.536150932312},
        { 0.67083704471588, -124.41680145264, 11.727275848389},
        { 17.710308074951, -148.59934997559, 12.942746162415},
        { 5.7096247673035, -168.78758239746, 12.533758163452},
        { 15.390788078308, -165.97067260742, 12.992780685425},
        { 3.3058676719666, -134.48400878906, 15.970171928406},
        { -2.2425718307495, -135.00886535645, 15.970171928406},
        { -6.8978986740112, -168.87452697754, 12.907674789429},
        { 4.787525177002, -148.88661193848, 15.970171928406},
        { -2.7240271568298, -145.75926208496, 15.970171928406}
    },
    blue = {
        { 7.9745297431946, 7.6485033035278, 10.071369171143},
        { -1.8167527914047, 16.871765136719, 14.086401939392},
        { 1.1913630962372, 17.336032867432, 14.086401939392},
        { -5.1978807449341, 17.847864151001, 14.086401939392},
        { 20.818552017212, 43.314849853516, 9.9502305984497},
        { 16.002014160156, 32.883506774902, 9.8716163635254},
        { 1.8312684297562, 29.850065231323, 14.086401939392},
        { -1.8341739177704, 52.418235778809, 10.056991577148},
        { -7.0864315032959, 7.2791934013367, 10.160329818726},
        { -5.2888140678406, 27.752103805542, 14.086401939392}
    }
}
spawns["sidewinder"] = {
    red = {
        { -31.258619308472, -43.976661682129, -3.8419578075409},
        { -33.037658691406, -32.997089385986, -3.8419578075409},
        { -32.569843292236, -37.06022644043, -3.8419578075409},
        { -30.923910140991, -28.509281158447, -3.8419578075409},
        { -32.911678314209, -44.087635040283, -3.8419578075409},
        { -32.853881835938, -38.795761108398, -3.8419578075409},
        { -28.122875213623, -31.554048538208, -3.8419578075409},
        { -28.43493270874, -29.41407585144, -3.8419578075409},
        { -32.521022796631, -35.424938201904, -3.8419578075409},
        { -37.145084381104, -30.514505386353, -3.7960402965546},
        { -29.851600646973, -28.036405563354, -3.8419578075409},
        { -31.263982772827, -38.972988128662, -3.8419578075409}
    },
    blue = {
        { 29.698610305786, -45.090045928955, -3.8419578075409},
        { 31.02855682373, -39.486019134521, -3.8419578075409},
        { 27.602350234985, -32.158550262451, -3.7762582302094},
        { 29.75350189209, -39.501522064209, -3.8419578075409},
        { 33.678600311279, -36.111186981201, -3.8419578075409},
        { 29.643436431885, -42.967548370361, -3.8419578075409},
        { 30.820363998413, -32.454116821289, -3.8236918449402},
        { 33.46337890625, -33.007621765137, -3.8419578075409},
        { 30.984680175781, -41.121726989746, -3.8419578075409},
        { 29.63595199585, -41.267040252686, -3.8419578075409},
        { 31.035552978516, -42.95240020752, -3.8419578075409},
        { 33.877208709717, -34.439239501953, -3.8419578075409},
        { 31.069696426392, -47.785095214844, -3.8419578075409},
        { 30.243196487427, -36.75874710083, 0.55805969238281}
    }
}
spawns["timberland"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["dangercanyon"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["beavercreek"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["boardingaction"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["carousel"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["chillout"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["damnation"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["gephyrophobia"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["hangemhigh"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["longest"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["prisoner"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["putput"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["ratrace"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}
spawns["wizard"] = {
    red = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    },
    blue = {
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 },
        { 00000, 00000, 00000 }
    }
}

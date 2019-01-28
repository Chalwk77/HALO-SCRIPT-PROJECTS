--[[
--=====================================================================================================--
Script Name: Domination, for SAPP (PC & CE)
Description: This game incorporates custom teams for FFA games.
             The game mechanics are as follows:
             When you kill someone on the opposing team, the victim is switched to your team. 
             The main objective is to dominate the opposing team.
             When the aforementioned opposing team has no players left the game is over.

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts]

-- Game Start Countdown Timer
delay = 0 -- In Seconds

-- Message emmited when the game is over.
end_of_game = "The %team% team won!"
server_prefix = "**SERVER** "

sort_command = "sort"
list_command = "list"

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

        for i = 1, 16 do
            if (player_present(i) and not gamestarted) then
                if (print_countdown[tonumber(i)] == true) then
                    cls(i)
                    rprint(i, "Game will begin in " .. timeRemaining .. " seconds")
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
                    rprint(k, "REDS: " .. red_count .. ", BLUES: " .. blue_count)
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
    killPlayer(PlayerIndex)
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
                -- Blue team has less players (join this team)
            elseif (blue_count < red_count) then
                players[get_var(PlayerIndex, "$name")].team = "blue"
                blue_count = blue_count + 1
                saveTable(get_var(PlayerIndex, "$name"), players[get_var(PlayerIndex, "$name")].team)
                -- Teams are even
            elseif (blue_count == red_count) then
                local new_team = pickRandomTeam()
                players[get_var(PlayerIndex, "$name")].team = new_team
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
            init_countdown = true
            gamestarted = false
            for i = 1, 16 do
                if player_present(i) then
                    players[get_var(i, "$name")].team = nil
                end
            end
            rprint(PlayerIndex, "Sorting Players...")
            return false
        end
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

function killPlayer(PlayerIndex)
    local PlayerObject = read_dword(get_player(PlayerIndex) + 0x34)
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
spawns["icefields"] = {
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
spawns["infinity"] = {
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
spawns["sidewinder"] = {
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

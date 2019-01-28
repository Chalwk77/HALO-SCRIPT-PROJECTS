--[[
--=====================================================================================================--
Script Name: Domination, for SAPP (PC & CE)
Description: N/A

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts]

-- Game Start Countdown Timer
delay = 25 -- In Seconds

-- Message emmited when the game is over.
end_of_game = "The %team% team won!"
server_prefix = "**SERVER** "

-- Configuration [ends] << ----------

-- tables --
spawns = { }
players = { }
team = { }

-- Booleans
gamestarted = nil
red_count = 0
blue_count = 0

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb["EVENT_GAME_START"], "OnNewGame")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")

    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_COMMAND"], "DebugCommand")
    register_callback(cb['EVENT_PRESPAWN'], 'OnPlayerPrespawn')
    
    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
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
    if (oddOrEven(1,1000) % 2 == 0) then
        useEvenNumbers = true
    else
        useEvenNumbers = false
    end
    startTimer()
end

function OnGameEnd()
    stopTimer()
    gamestarted = false
end

function OnTick()
    if (init_countdown == true) then
        countdown = countdown + 0.030

        local seconds = secondsToTime(countdown)
        timeRemaining = delay - math.floor(seconds)

        for i = 1,16 do
            if player_present(i) then
                cls(i)
                rprint(i, "Game will begin in " .. timeRemaining .. " seconds")
            end
        end
        
        cprint("Game will begin in " .. timeRemaining .. " seconds", 4 + 8)

        if (timeRemaining <= 0) then
            cprint("The game has begun!", 2 + 8)
            gamestarted = true
            sortPlayers()
            stopTimer()
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
    if timeRemaining ~= nil then
        cprint("The countdown was stopped at " .. timeRemaining .. " seconds")
    end
end

-- Sorts players into teams of two
function sortPlayers()
    
    local t = {}

    if (isTeamPlay() == false) and (gamestarted) then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(t, i)
                if (#t == 1) then 
                    local new_team = pickRandomTeam()
                    players[get_var(i, "$name")].team = new_team
                    if (new_team == "red") then
                        red_count = red_count + 1
                    elseif (new_team == "blue") then
                        blue_count = blue_count + 1
                    end
                    killPlayer(i)
                else
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
    else
        -- do nothing [for now]
    end
end

function determineTeam(PlayerIndex, team)
    players[get_var(PlayerIndex, "$name")].team = tostring(team)
    if team == "red" then
        red_count = red_count + 1
    elseif team == "blue" then
        blue_count = blue_count + 1
    end
    killPlayer(PlayerIndex)
end

function OnPlayerJoin(PlayerIndex)
    if not isTeamPlay() then
        players[get_var(PlayerIndex, "$name")] = { }
        players[get_var(PlayerIndex, "$name")].team = nil
        
        -- Only sort player into new team if the game has already started...
        if (gamestarted == true) then
                -- Red team has less players (join this team)
            if (red_count < blue_count) then
                players[get_var(PlayerIndex, "$name")].team = "red"
                red_count = red_count + 1
                -- Blue team has less players (join this team)
            elseif (blue_count < red_count) then
                players[get_var(PlayerIndex, "$name")].team = "blue"
                blue_count = blue_count + 1
                -- Teams are even
            elseif (blue_count == red_count) then
                local new_team = pickRandomTeam()
                players[get_var(PlayerIndex, "$name")].team = new_team
                if (new_team == "red") then
                    red_count = red_count + 1
                elseif (new_team == "blue") then
                    blue_count = blue_count + 1
                end
            end
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

function pickRandomCoord(Min, Max)
    math.randomseed(os.time())
    math.random();
    local num = math.random(Min, Max)
    if (num) then
        return num
    end
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
            say(PlayerIndex, "You are on " .. team .. " team")
            cprint(get_var(PlayerIndex, "$name") .. " is now on " .. team .. " team.")
        end
    end
end

function spawnPlayer(PlayerIndex, Team)
    local player = get_dynamic_player(PlayerIndex)
    if (player ~= 0) then
        local map = get_var(0, "$map")
        local x,y,z
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
        write_vector3d(player + 0x5C, x, y, z + 0.3)
    end
end

function chooseRandomSpawn(team, map)
    local coordIndex
    if (team =="blue") then
        coordIndex = pickRandomCoord(1, #spawns[map].blue)
    elseif (team =="red") then
        coordIndex = pickRandomCoord(1, #spawns[map].red)
    end
    return coordIndex
end

function DebugCommand(PlayerIndex, Command, Environment, Password)
    if (string.lower(Command) == "sort") then
        sortPlayers()
        rprint(PlayerIndex, "Sorting Players...")
        return false
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)

    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    if (killer ~= -1) then

        local killer_team = players[get_var(killer, "$name")].team
        local killer_team = players[get_var(victim, "$name")].team
        
        if tonumber(PlayerIndex) ~= tonumber(KillerIndex) then
            if players[get_var(killer, "$name")].team == "red" then
                blue_count = blue_count - 1
                red_count = red_count + 1
            elseif players[get_var(killer, "$name")].team == "blue" then
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
            if (gamestarted == true) then
                local team = players[get_var(victim, "$name")].team
                say_all(get_var(victim, "$name") .. " is now on " .. team .. " team.")
                cprint(get_var(victim, "$name") .. " is now on " .. team .. " team.")
            end
        end
    end
end

function gameOver(message)
    execute_command("msg_prefix \"\"")
    say_all(message)
    execute_command("msg_prefix \" **" .. server_prefix .. "**\"")
    gamestarted = false
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

spawns["bloodgulch"] = {
    red = {
        { 92.335815429688, -160.96267700195, 1.7034857273102},
        { 98.49340057373, -157.63900756836, 1.7034857273102},
        { 94.421661376953, -156.70387268066, 1.7034857273102},
        { 99.34334564209, -161.35060119629, 1.7034857273102},
        { 97.290061950684, -163.53598022461, 1.7034857273102},
        { 93.965179443359, -161.08256530762, 1.7034857273102},
        { 86.749755859375, -157.65640258789, 0.048994019627571},
        { 96.821678161621, -156.98571777344, 1.7034857273102},
        { 91.893623352051, -157.78077697754, 1.7034857273102},
        { 82.679779052734, -161.43428039551, 0.10210217535496},
        { 89.481048583984, -153.50212097168, 0.29154032468796},
        { 93.737098693848, -163.3981628418, 1.7034857273102},
        { 84.152633666992, -160.48426818848, 0.054357394576073}
    },
    blue = {
        { 32.070510864258, -88.901565551758, 0.09855629503727},
        { 36.771701812744, -76.885299682617, 1.7034857273102},
        { 38.242469787598, -74.925712585449, 1.7034857273102},
        { 44.146770477295, -77.477615356445, 1.7034857273102},
        { 41.87818145752, -81.025238037109, 1.7034857273102},
        { 50.479667663574, -86.173034667969, 0.11015506088734},
        { 38.590934753418, -76.47093963623, 1.7034857273102},
        { 43.914459228516, -80.678703308105, 1.7034857273102},
        { 41.994873046875, -77.401725769043, 1.7034857273102},
        { 38.902805328369, -81.087158203125, 1.7034857273102},
        { 38.125888824463, -82.836540222168, 1.7034857273102},
        { 42.062110900879, -75.990867614746, 1.7034857273102},
        { 42.136421203613, -75.054779052734, 1.7034857273102},
        { 39.589454650879, -89.477188110352, 0.084063664078712},
        { 30.553886413574, -89.435180664063, 0.12797956168652},
        { 36.68635559082, -80.840293884277, 1.7034857273102}
    }
}
spawns["deathisland"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["icefields"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["infinity"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["sidewinder"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["timberland"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["dangercanyon"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["beavercreek"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["boardingaction"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["carousel"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["chillout"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["damnation"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["gephyrophobia"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["hangemhigh"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["longest"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["prisoner"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["putput"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["ratrace"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}
spawns["wizard"] = {
    red = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    },
    blue = {
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 },
        { 00000,00000,00000 }
    }
}

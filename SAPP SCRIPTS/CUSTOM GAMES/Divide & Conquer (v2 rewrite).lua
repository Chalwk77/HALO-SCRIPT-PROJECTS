--[[
--=====================================================================================================--
Script Name: Divide & Conquer (v2 rewrite), for SAPP (PC & CE)
Description: When you kill someone on the opposing team, the victim is switched to your team. 
              The main objective is to dominate the opposing team.
              When the opposing team has no players left the game is over.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

local mod = {}
function mod:init()
    mod.settings = {

        -- #Numbers of players required to set the game in motion (cannot be less than 3)
        required_players = 3,

        -- Continuous message emitted when there aren't enough players.
        not_enough_players = "%current%/%required% players needed to start the game.",

        -- #Countdown delay (in seconds)
        -- This is a pre-game-start countdown initiated at the beginning of each game.
        delay = 10,

        -- #Pre Game message (%timeRemaining% will be replaced with the time remaining)
        pre_game_message = "Game will begin in %time_remaining% second%s%",

        -- #End of Game message (%team% will be replaced with the winning team)
        end_of_game = "The %team% team won!",

        -- #Respawn time (override)
        -- When enabled, players who are killed by the opposing team will respawn immediately. 
        -- Does not affect suicides or other deaths (PvP only by design).
        respawn_override = true,
        respawn_time = 0, -- In seconds (0 = immediate)

        -- Some functions temporarily remove the server prefix while broadcasting a message.
        -- This prefix will be restored to 'server_prefix' when the message relay is done.
        -- Enter your servers default prefix here:
        server_prefix = "** SERVER **",
    }
end

-- Variables for String Library:
local format = string.format
local sub, gsub = string.sub, string.gsub
local lower, upper = string.lower, string.upper
local match, gmatch = string.match, string.gmatch

-- Variables for Math Library:
local floor, sqrt = math.floor, math.sqrt

-- Game Variables:
local gamestarted
local countdown, init_countdown, print_nep
local slayer_globals = nil

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")

    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    if (get_var(0, '$gt') ~= "n/a") then
        mod:init()
        slayer_globals = read_dword(sig_scan("5733C0B910000000BFE8E05B00F3ABB910000000") + 19)
    end
end

function OnScriptUnload()
    --
end

function OnTick()

    local set = mod.settings
    local player_count = mod:GetPlayerCount()

    local countdown_begun = (init_countdown == true)

    -- # Continuous message emitted when there aren't enough players to start the game:
    for i = 1, 16 do
        if player_present(i) then
            if (print_nep) and (not gamestarted) and (player_count < set.required_players) then
                mod:cls(i, 25)
                local msg = gsub(gsub(set.not_enough_players,
                        "%%current%%", player_count),
                        "%%required%%", set.required_players)
                rprint(i, msg)
            elseif (countdown_begun) and (not gamestarted) and (set.pregame) then
                mod:cls(i, 25)
                rprint(i, set.pregame)
            end
        end
    end

    if (countdown_begun) then
        countdown = countdown + 0.03333333333333333

        local seconds = mod:secondsToTime(countdown)
        local timeRemaining = set.delay - math.floor(seconds)
        local char = mod:getChar(timeRemaining)

        set.pregame = set.pregame or ""
        set.pregame = gsub(gsub(set.pre_game_message, "%%time_remaining%%", timeRemaining), "%%s%%", char)

        if (timeRemaining <= 0) then
            gamestarted = true
            mod:StopTimer()
            for i = 1, 16 do
                if player_present(i) then
                    mod:sortPlayers(i)
                    rprint(i, "The game has begun")
                end
            end
        end
    end
end

function OnGameStart()

    if (get_var(0, '$gt') ~= "n/a") then
        mod:init()
    end

    local set = mod.settings

    if not mod:isTeamPlay() then
        mod:unregisterSAPPEvents(' Only supports team play!')
    elseif (set.required_players < 3) then
        mod:unregisterSAPPEvents('Setting "required_players" cannot be less than 3!')
    else
        mod:StopTimer()
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

function OnGameEnd()
    mod:StopTimer()
end

function OnPlayerConnect(PlayerIndex)

    local set = mod.settings
    local player_count = mod:GetPlayerCount()
    local required = set.required_players

    local team_count = mod:getTeamCount() -- blues[1], reds[2]

    if (player_count >= required) and (not init_countdown) and (not gamestarted) then
        mod:StartTimer()
    elseif (player_count >= required) and (print_nep) then
        print_nep = false
    elseif (player_count > 0 and player_count < required) then
        print_nep = true
    end

    -- Only sort player into new team if the game has already started...
    if (gamestarted) then

        -- Red team has less players (join this team)
        if (team_count[2] < team_count[1]) then
            SwitchTeam(PlayerIndex, "red", true)

            -- Blue team has less players (join this team)
        elseif (team_count[1] < team_count[2]) then
            SwitchTeam(PlayerIndex, "blue", true)

            -- Teams are even | Choose random team.
        elseif (team_count[1] == team_count[2]) then

            local new_team = mod:PickRandomTeam()
            SwitchTeam(PlayerIndex, new_team, true)
        end
    end
end

function OnPlayerDisconnect(PlayerIndex)

    local set = mod.settings
    local player_count = mod:GetPlayerCount()
    player_count = player_count - 1

    local team_count = mod:getTeamCount() -- blues[1], reds[2]
    local team = get_var(PlayerIndex, "$team")

    if (team == "blue") then
        team_count[1] = team_count[1] - 1
    else
        team_count[2] = team_count[2] - 1
    end

    if (gamestarted) then
        -- Ensures all parameters are set to their default values.
        if (player_count <= 0) then
            mod:StopTimer()

            -- One player remains | ends the game.
        elseif (player_count == 1) then
            for i = 1, 16 do
                if (tonumber(i) ~= tonumber(PlayerIndex)) then
                    if player_present(i) then
                        local team = get_var(i, "$team")
                        mod:gameOver(gsub(set.end_of_game, "%%team%%", team))
                        break
                    end
                end
            end

            -- Checks if the remaining players are on the same team | ends the game.
        elseif (team_count[1] <= 0 and team_count[2] >= 1) then
            mod:gameOver(gsub(set.end_of_game, "%%team%%", "red"))
        elseif (team_count[2] <= 0 and team_count[1] >= 1) then
            mod:gameOver(gsub(set.end_of_game, "%%team%%", "blue"))
        end


        -- Pre-Game countdown was initiated but someone left before the game began.
        -- Stop the timer, reset the count and display the continuous
        -- message emitted when there aren't enough players to start the game.
    elseif (not gamestarted) and (init_countdown and player_count < set.required_players) then
        print_nep = true
        countdown, init_countdown = 0, false
    end

end

function OnPlayerDeath(PlayerIndex, KillerIndex)

    if (gamestarted) then

        local killer = tonumber(KillerIndex)
        local victim = tonumber(PlayerIndex)

        local kteam = get_var(killer, "$team")
        local vteam = get_var(victim, "$team")
        local set = mod.settings

        if (killer > 0 and killer ~= victim) then

            local bluescore, redscore = get_var(0, "$bluescore"), get_var(0, "$redscore")

            if kteam == "red" then
                execute_command("slayer_score_team blue " .. bluescore - 1)
                SwitchTeam(victim, "red")
            elseif kteam == "blue" then
                SwitchTeam(victim, "blue")
                execute_command("slayer_score_team red " .. redscore - 1)
            end

            local team_count = mod:getTeamCount() -- blues[1], reds[2]

            if (team_count[2] == 0 and team_count[1] >= 1) then
                gameOver(gsub(set.end_of_game, "%%team%%", "blue"))

                -- No one left on BLUE team. | RED Team Wins
            elseif (team_count[1] == 0 and team_count[2] >= 1) then
                gameOver(gsub(set.end_of_game, "%%team%%", "red"))

                -- Game is in play | switch player
            elseif (team_count[1] ~= 0 and team_count[2] ~= 0) then
                SwitchTeam(victim, kteam)

                execute_command("msg_prefix \"\"")
                say_all(get_var(victim, "$name") .. " is now on " .. kteam .. " team.")
                execute_command("msg_prefix \" " .. set.server_prefix .. "\"")
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex and gamestarted) then

        local cTeam = get_var(CauserIndex, "$team")
        local vTeam = get_var(PlayerIndex, "$team")

        if (cTeam == vTeam) then
            return false
        end
    end
end

function mod:killPlayer(PlayerIndex)
    local PlayerObject = read_dword(get_player(PlayerIndex) + 0x34)
    if PlayerObject ~= nil then
        destroy_object(PlayerObject)
    end
end

function SwitchTeam(PlayerIndex, team, bool)
    if not (bool) then

        local set = mod.settings

        -- Temporarily disables default death messages (to prevent "Player Died" message).
        local kma = sig_scan("8B42348A8C28D500000084C9") + 3
        original = read_dword(kma)
        safe_write(true)
        write_dword(kma, 0x03EB01B1)
        safe_write(false)

        -- Switch player to relevant team
        execute_command("st " .. tonumber(PlayerIndex) .. " " .. tostring(team))

        -- Re enables default death messages
        safe_write(true)
        write_dword(kma, original)
        safe_write(false)

        if (set.respawn_override == true) then
            write_dword(get_player(PlayerIndex) + 0x2C, set.respawn_time * 33)
        end
    else
        execute_command("st " .. tonumber(PlayerIndex) .. " " .. tostring(team))
    end
end

function mod:gameOver(message)
    execute_command("msg_prefix \"\"")
    say_all(message)
    execute_command("msg_prefix \" " .. mod.settings.server_prefix .. "\"")
    execute_command("sv_map_next")
end

function mod:secondsToTime(seconds)
    seconds = seconds % 60
    return seconds
end

function mod:StartTimer()
    countdown, init_countdown = 0, true
end

function mod:StopTimer()
    countdown, init_countdown = 0, false
    print_nep = false
    for i = 1, 16 do
        if player_present(i) then
            mod:cls(i, 25)
        end
    end
end

function mod:cls(PlayerIndex, count)
    local count = count or 25
    for _ = 1, count do
        rprint(PlayerIndex, " ")
    end
end

function mod:isTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
    else
        return false
    end
end

function mod:sortPlayers(PlayerIndex)
    if (gamestarted) then
        if (useEvenNumbers) then
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

    mod:deleteWeapons(PlayerIndex)
    local PlayerObject = get_dynamic_player(PlayerIndex)
    if (PlayerObject ~= 0) then
        write_word(PlayerObject + 0x31E, 0)
        write_word(PlayerObject + 0x31F, 0)
    end

    mod:killPlayer(PlayerIndex)
    SwitchTeam(tonumber(PlayerIndex), team)
    mod:ResetScore(PlayerIndex)
end

function mod:deleteWeapons(PlayerIndex)
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

function mod:unregisterSAPPEvents(error)
    unregister_callback(cb['EVENT_TICK'])
    unregister_callback(cb['EVENT_GAME_END'])
    unregister_callback(cb['EVENT_JOIN'])
    unregister_callback(cb['EVENT_LEAVE'])
    unregister_callback(cb['EVENT_DIE'])
    unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])
    execute_command("log_note \"" .. string.format('[Divide & Conquer] ' .. error) .. "\"")
    cprint(string.format('[Divide & Conquer] ' .. error), 4 + 8)
end

function mod:GetPlayerCount()
    return tonumber(get_var(0, "$pn"))
end

function mod:getTeamCount()
    local blues = get_var(0, "$blues")
    local reds = get_var(0, "$reds")
    return { tonumber(blues), tonumber(reds) }
end

function mod:getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
end

function mod:PickRandomTeam()
    math.randomseed(os.time())
    math.random();
    math.random();
    math.random();
    local team, num = 0, math.random(1, 2)
    if (num == 1) then
        team = "red"
    else
        team = "blue"
    end
    return team
end

function mod:ResetScore(PlayerIndex)
    execute_command("score " .. PlayerIndex .. " 0")
    execute_command("kills " .. PlayerIndex .. " 0")
    execute_command("deaths " .. PlayerIndex .. " 0")
    execute_command("assists " .. PlayerIndex .. " 0")
    execute_command_sequence("team_score 0 0")
end

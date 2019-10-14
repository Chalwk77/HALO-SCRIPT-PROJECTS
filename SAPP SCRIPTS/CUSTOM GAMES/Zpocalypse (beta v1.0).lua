--[[
--=====================================================================================================--
Script Name: Zpocalypse (beta v1.0), for SAPP (PC & CE)
Description: Custom Zombie Game.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

local zombies = {}
local parameters = nil

function zombies:init()
    zombies.settings = {
    
        -- #Numbers of players required to set the game in motion (cannot be less than 2)
        required_players = 3,

        -- Continuous message emitted when there aren't enough players.
        not_enough_players = "%current%/%required% players needed to start the game.",

        -- #Countdown delay (in seconds)
        -- This is a pre-game-start countdown initiated at the beginning of each game.
        delay = 10,

        -- #Pre Game message (%timeRemaining% will be replaced with the time remaining)
        pre_game_message = "Zpocalypse will begin in %time_remaining% second%s%",

        -- #End of Game message (%team% will be replaced with the winning team)
        end_of_game = "The %team% team won!",
        
        on_game_begin = "The game has begun: You are on the %team% team",

        -- Zombies vs Human:
        on_zombify = "%victim% was zombified by %killer%",
        
        -- Normal Suicide
        on_suicide = "%victim% committed suicide",
        
        -- Human vs Zombie:
        on_kill = "%victim% was killed by %killer%",

        on_last_man = {
            -- Zombie vs second-to-last human:
            normal = "%victim% was killed by %killer%. %lastman% is the last human standing!",
            -- Second-to-last Human committed suicide:
            suicide = "%victim% committed suicide. %lastman% is the last last human standing!",
        },

        -- If this is true, the teams will be evenly balanced at the beginning of the game
        balance_teams = false,

        -- #Respawn time (override)
        -- When enabled, players who are killed by the opposing team will respawn immediately.
        -- Does not affect suicides or other deaths (PvP only by design).
        respawn_override = true,
        respawn_time = 0, -- In seconds (0 = immediate)

        -- Message emitted when someone becomes a human again:
        on_cure = "%killer% killed %victim% and was cured!",
        -- Get this many consecutive kills per life and become human again!
        cure_threshold = 5,

        attributes = {
            ["Humans"] = {
                -- Set to 0 to disable (normal speed is 1)
                running_speed = 1,
                -- Zombie Health: (0 to 99999) (Normal = 1)
                health = 1,
                damage_multiplier = 1, -- (0 to 10) (Normal = 1)
            },
            ["Zombies"] = {
                -- Set to 0 to disable (normal speed is 1)
                running_speed = 1.2,
                -- Zombie Health: (0 to 99999) (Normal = 1)
                health = 1.3,
                damage_multiplier = 10, -- (0 to 10) (Normal = 1)
                -- Set to 'false' to disable:
                invisibility_on_crouch = true,
            },
            ["Last Man Standing"] = {
                -- Set to 0 to disable (normal speed is 1)
                running_speed = 1.2,
                -- Zombie Health: (0 to 99999) (Normal = 1)
                health = 1.5,
                -- Set to 'false' to disable temporary overshield:
                overshield = true,
                -- Set to 'false' to disable this feature:
                invisibility_on_crouch = true,
                -- If true, the last man standing will have regenerating health:
                regenerating_health = true,
                -- Health will regenerate in chunks of this percent every 30 ticks until they gain maximum health.
                increment = 0.0005,
                -- Last Man damage multiplier
                damage_multiplier = 2.00, -- (0 to 9999) (Normal = 1)

                -- A NAV marker will appear above the last man standing if your set the "kill in order" gametype flag to "yes". 
                -- This only works on FFA and Team Slayer gametypes.
                use_nav_marker = true
            }
        },

        -- Some functions temporarily remove the server prefix while broadcasting a message.
        -- This prefix will be restored to 'server_prefix' when the message relay is done.
        -- Enter your servers default prefix here:
        server_prefix = "** SERVER **",
    }
    
    --# Do Not Touch #--
    zombies.players = {}
    parameters = zombies.settings
end

-- Variables for String Library:
local format = string.format
local gsub = string.gsub

-- Variables for Math Library:
local floor = math.floor

-- Game Variables:
local gamestarted
local countdown, init_countdown, print_nep
local kill_message_addresss, originl_kill_message

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_WEAPON_DROP'], "OnWeaponDrop")

    kill_message_addresss = sig_scan("8B42348A8C28D500000084C9") + 3
    originl_kill_message = read_dword(kill_message_addresss)

    if (get_var(0, '$gt') ~= "n/a") then
        zombies:init()
        for i = 1, 16 do
            if player_present(i) then
                zombies:gameStartCheck(i)
            end
        end
    end
end

function OnScriptUnload()
    zombies:enableKillMessages()
end

function zombies:enableKillMessages()
    safe_write(true)
    write_dword(kill_message_addresss, originl_kill_message)
    safe_write(false)
end

function zombies:disableKillMessages()
    safe_write(true)
    write_dword(kill_message_addresss, 0x03EB01B1)
    safe_write(false)
end

function OnTick()

    local count = zombies:GetPlayerCount()
    local countdown_begun = (init_countdown == true)

    for _, player in pairs(zombies.players) do
        if (player) and player_present(player.id) then

            if (print_nep) and (not gamestarted) and (count < parameters.required_players) then
                zombies:cls(player.id, 25)
                local msg = gsub(gsub(parameters.not_enough_players, 
                "%%current%%", count), 
                "%%required%%", parameters.required_players)
                rprint(player.id, msg)

            elseif (countdown_begun) and (not gamestarted) and (zombies.pregame) then
                zombies:cls(player.id, 25)
                rprint(player.id, zombies.pregame)

                -- Weapon Assignment and Attribute Logic:
            elseif (gamestarted) and player_alive(player.id) then

                local player_object = get_dynamic_player(player.id)
                if (player_object ~= 0) then

                    if (player.assign) then
                        local coords = zombies:getXYZ(player.id, player_object)
                        if (not coords.invehicle) then
                            player.assign = false
                            execute_command("wdel " .. player.id)
                            local oddball = spawn_object("weap", player.weapon, coords.x, coords.y, coords.z)
                            assign_weapon(oddball, player.id)
                            player.drone = oddball
                        end
                    end

                    for index, attribute in pairs(parameters.attributes) do
                        if (index == "Humans") and (player.team == "red") then
                            if (attribute.running_speed > 0) then
                                execute_command("s " .. player.id .. " " .. tonumber(attribute.running_speed))
                            end
                        elseif (index == "Zombies") and (player.team == "blue") then
                            if (attribute.running_speed > 0) then
                                execute_command("s " .. player.id .. " " .. tonumber(attribute.running_speed))
                            end
                            zombies:CamoOnCrouch(player.id)
                        elseif (index == "Last Man Standing") and (player.team == "red") then
                            if (player.last_man ~= nil) then

                                if (attribute.use_nav_marker) then
                                    zombies:SetNav(player.id)
                                end

                                if (attribute.running_speed > 0) then
                                    execute_command("s " .. player.id .. " " .. tonumber(attribute.running_speed))
                                end
                                zombies:CamoOnCrouch(player.id)

                                if (attribute.regenerating_health) then
                                    if (player_object ~= 0) then
                                        if read_float(player_object + 0xE0) < 1 then
                                            write_float(player_object + 0xE0, read_float(player_object + 0xE0) + attribute.increment)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if (countdown_begun) then
        countdown = countdown + 0.03333333333333333

        local timeRemaining = parameters.delay - floor(countdown % 60)
        local char = zombies:getChar(timeRemaining)

        zombies.pregame = zombies.pregame or ""
        zombies.pregame = gsub(gsub(parameters.pre_game_message, 
        "%%time_remaining%%", timeRemaining), 
        "%%s%%", char)

        if (timeRemaining <= 0) then
        
            zombies:disableKillMessages()            
            gamestarted = true
            zombies:StopTimer()

            if (parameters.balance_teams) then
                for i = 1, 16 do
                    if player_present(i) then
                        zombies:sortPlayers(i, true)
                        local team = zombies:GetTeamType(i)
                        local msg = gsub(parameters.on_game_begin, "%%team%%", team)
                        rprint(i, msg)
                    end
                end
            else
                zombies:sortPlayers(nil, false)
            end
            zombies:SetLastMan()
            execute_command("sv_map_reset")
        end
    end
end

function OnGameStart()
    if (get_var(0, '$gt') ~= "n/a") then
        zombies:init()

        if not zombies:isTeamPlay() then
            zombies:unregisterSAPPEvents('Only supports team play!')
        elseif (parameters.required_players < 2) then
            zombies:unregisterSAPPEvents('Setting "required_players" cannot be less than 2!')
        else
            zombies:StopTimer()
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
                parameters.useEvenNumbers = true
            else
                -- Number is odd
                parameters.useEvenNumbers = false
            end
        end
    end
end

function OnGameEnd()
    zombies:StopTimer()
    gamestarted = false
end

function zombies:gameStartCheck(p)

    zombies:initPlayer(p, get_var(p, "$team"), true)

    local player_count = zombies:GetPlayerCount()
    local required = parameters.required_players

    if (player_count >= required) and (not init_countdown) and (not gamestarted) then
        zombies:StartTimer()
    elseif (player_count >= required) and (print_nep) then
        print_nep = false
    elseif (player_count > 0 and player_count < required) then
        print_nep = true
    end

    -- Game has already begun. Set player to zombie team:
    if (gamestarted) and (p) then
        if (get_var(p, "$team") == "red") then
            zombies:SwitchTeam(p, "blue", true)
        end
    end
end

function OnPlayerConnect(p)
    zombies:gameStartCheck(p)
end

function OnPlayerDisconnect(PlayerIndex)

    local p = tonumber(PlayerIndex)
    local player = zombies:PlayerTable(p)

    local player_count = zombies:GetPlayerCount()
    player_count = player_count - 1

    local team_count = zombies:getTeamCount() -- blues[1], reds[2]
    local Zombies, Humans = team_count[1], team_count[2]

    if (player.team == "blue") then
        zombies:CleanUpDrones(player.id, false)
        Zombies = Zombies - 1
    else
        Humans = Humans - 1
    end

    zombies:initPlayer(p, nil, false)

    if (gamestarted) then
        if (player_count <= 0) then

            -- Ensure all timer parameters are set to their default values.
            zombies:StopTimer()

            -- One player remains | ends the game.
        elseif (player_count == 1) then
            for i = 1, 16 do
                if (tonumber(i) ~= tonumber(p)) then
                    if player_present(i) then
                        -- Send game over message to the last remaining player:
                        local team = zombies:GetTeamType(i)
                        zombies:broadcast(gsub(parameters.end_of_game, "%%team%%", team), true)
                        break
                    end
                end
            end

            -- Checks if the remaining players are on the same team | ends the game.
        elseif (Zombies <= 0 and Humans >= 1) then
            zombies:broadcast(gsub(parameters.end_of_game, "%%team%%", "human"), true)
        elseif (Humans <= 0 and Zombies >= 1) then
            zombies:broadcast(gsub(parameters.end_of_game, "%%team%%", "zombie"), true)
        end

        -- Pre-Game countdown was initiated but someone left before the game began.
        -- Stop the timer, reset the countdown and display the continuous
        -- message emitted when there aren't enough players to start the game.
    elseif (not gamestarted) and (init_countdown and player_count < parameters.required_players) then
        print_nep = true
        countdown, init_countdown = 0, false
    end
end

function OnPlayerSpawn(PlayerIndex)
    local PlayerObject = get_dynamic_player(PlayerIndex)
    if (PlayerObject ~= 0 and gamestarted) then
        if player_alive(PlayerIndex) then
            local team = get_var(PlayerIndex, "$team")

            if (team == "blue") then

                -- Set grenades to 0 for zombies:
                write_word(PlayerObject + 0x31E, 0)
                write_word(PlayerObject + 0x31F, 0)

                local player = zombies:PlayerTable(PlayerIndex)
                -- Set weapon assignment flag to true:
                player.assign = true
                -- Set zombie kill count to zero:
                player.kills = 0
            end
        end
    end
end

function OnWeaponDrop(PlayerIndex)
    zombies:CleanUpDrones(PlayerIndex, true)
end

function OnPlayerDeath(PlayerIndex, KillerIndex)

    if (gamestarted) then

        local killer = tonumber(KillerIndex)
        local victim = tonumber(PlayerIndex)

        local kteam = get_var(killer, "$team")
        local vteam = get_var(victim, "$team")

        local kname = get_var(killer, "$name")
        local vname = get_var(victim, "$name")

        if (killer > 0) then

            -- Check for suicide:
            local params = {}
            params.kname = kname
            params.vname = vname
            
            if (killer == victim) then
                params.suicide = true
                zombies:SwitchTeam(victim, "blue")
            end

            -- PvP:
            if (killer ~= victim) then
                
                -- Zombie killed Human:
                if (kteam == "blue") and (vteam == "red") then        
                    params.zombified = true
                    -- Switch victim to Zombie team:
                    zombies:SwitchTeam(victim, "blue")

                    -- If zombie has "cure_threshold" kills, set them to human team:
                    local player = zombies:PlayerTable(killer)
                    player.kills = player.kills + 1

                    if (player.kills == zombies.cure_threshold) then
                        params.cured = true
                        zombies:SwitchTeam(killer, "red")
                    end

                -- Human killed Zombie:
                elseif (kteam == "red") and (vteam == "blue") then
                    params.pvp = true
                    zombies:CleanUpDrones(victim, false)
                end
            end

            zombies:endGameCheck()
            zombies:SetLastMan(params)
            
        elseif (killer == nil) or (killer == 0) then
            execute_command("msg_prefix \"\"")
            zombies:broadcast(vname .. " died", false)
            execute_command("msg_prefix \" " .. parameters.server_prefix .. "\"")
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex and gamestarted) then

        local cTeam = get_var(CauserIndex, "$team")
        local vTeam = get_var(PlayerIndex, "$team")

        if (cTeam == vTeam) then
            return false
        else
            for index, attribute in pairs(parameters.attributes) do
                if (index == "Humans") and (cTeam == "red") then
                    return true, Damage * attribute.damage_multiplier
                elseif (index == "Zombies") and (cTeam == "blue") then
                    return true, Damage * attribute.damage_multiplier
                elseif (index == "Last Man Standing") and (cTeam == "red") then
                    local player = zombies:PlayerTable(PlayerIndex)
                    if (player.last_man ~= nil) then
                        return true, Damage * attribute.damage_multiplier
                    end
                end
            end
        end
    end
end

function zombies:killPlayer(PlayerIndex)
    local player = get_player(PlayerIndex)
    if (player ~= 0) then
        local PlayerObject = read_dword(player + 0x34)
        if (PlayerObject ~= nil) then
            destroy_object(PlayerObject)
        end
    end
end

function zombies:SwitchTeam(PlayerIndex, team, bool)
    local player = zombies:PlayerTable(PlayerIndex)
    player.team = team
    
    if not (bool) then

        -- Set the player's team:
        local Team = get_var(PlayerIndex, "$team")
        if (Team ~= team) then
            execute_command("st " .. tonumber(PlayerIndex) .. " " .. tostring(team))
        end

        -- Override respawn time:
        if (zombies.respawn_override == true) then
            local player = get_player(PlayerIndex)
            if (player ~= 0) then
                write_dword(player + 0x2C, parameters.respawn_time * 33)
            end
        end

        -- Set their health:
        local health = zombies:setHealth(PlayerIndex, team)
        execute_command_sequence("w8 " .. (parameters.respawn_time + 1) .. ";hp " .. PlayerIndex .. " " .. health)
    else
        -- Set the player's team:
        execute_command("st " .. tonumber(PlayerIndex) .. " " .. tostring(team))
        local health = zombies:setHealth(PlayerIndex, team)
        execute_command_sequence("w8 2;hp " .. PlayerIndex .. " " .. health)
    end
end

function zombies:broadcast(message, endgame, exclude, player)
    execute_command("msg_prefix \"\"")
    if (not exclude) then
        say_all(message)
    else
        for i = 1, 16 do
            if player_present(i) then
                if (i ~= player) then
                    say(i, message)
                end
            end
        end
    end
    execute_command("msg_prefix \" " .. parameters.server_prefix .. "\"")
    -- End the game if variable "GameOver" is true.
    if (endgame) then
        execute_command("sv_map_next")
    end
end

function zombies:StartTimer()
    countdown, init_countdown = 0, true
end

function zombies:StopTimer()
    countdown, init_countdown = 0, false
    print_nep = false

    for i = 1, 16 do
        if player_present(i) then
            zombies:cls(i, 25)
        end
    end

    --
    if (gamestarted) then

        -- Only disable object interaction when the game begins:
        -- This will allow players to engage in PvP normally until enough players are present to start the game.
        --=======================================================================================================--

        -- Disable vehicles for both teams:
        execute_command("disable_all_vehicles 0 1")

        -- Disable weapon pick ups for zombies:
        execute_command("disable_object 'weapons\\assault rifle\\assault rifle' 2")
        execute_command("disable_object 'weapons\\flamethrower\\flamethrower' 2")
        execute_command("disable_object 'weapons\\needler\\mp_needler' 2")
        execute_command("disable_object 'weapons\\pistol\\pistol' 2")
        execute_command("disable_object 'weapons\\plasma pistol\\plasma pistol' 2")
        execute_command("disable_object 'weapons\\plasma rifle\\plasma rifle' 2")
        execute_command("disable_object 'weapons\\plasma_cannon\\plasma_cannon' 2")
        execute_command("disable_object 'weapons\\rocket launcher\\rocket launcher' 2")
        execute_command("disable_object 'weapons\\shotgun\\shotgun' 2")
        execute_command("disable_object 'weapons\\sniper rifle\\sniper rifle' 2")

        -- Disable Grenades for Zombies:
        execute_command("disable_object 'weapons\\frag grenade\\frag grenade' 2")
        execute_command("disable_object 'weapons\\plasma grenade\\plasma grenade' 2")
    end
end

function zombies:endGameCheck()
    local team_count = zombies:getTeamCount() -- blues[1], reds[2]
    local Zombies, Humans = team_count[1], team_count[2]

    -- No humans left -> zombies win
    if (Humans == 0 and Zombies >= 1) then
        zombies:broadcast(gsub(parameters.end_of_game, "%%team%%", "Zombies"), true)
    end
end

-- This function deletes stray oddballs:
function zombies:CleanUpDrones(PlayerIndex, Assign)
    local player = zombies:PlayerTable(PlayerIndex)
    if (player.drone) then
        destroy_object(player.drone)
        player.drone = nil
    end
    if (Assign) then
        player.assign = true
    end
end

function zombies:cls(PlayerIndex, count)
    local count = count or 25
    for _ = 1, count do
        rprint(PlayerIndex, " ")
    end
end

function zombies:isTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
    end
end

function zombies:sortPlayers(PlayerIndex, BalanceTeams)
    if (gamestarted) then

        if (BalanceTeams) then
            if (parameters.useEvenNumbers) then
                if (tonumber(PlayerIndex) % 2 == 0) then
                    zombies:setTeam(PlayerIndex, "blue")
                else
                    zombies:setTeam(PlayerIndex, "red")
                end
            else
                if (tonumber(PlayerIndex) % 2 == 0) then
                    zombies:setTeam(PlayerIndex, "red")
                else
                    zombies:setTeam(PlayerIndex, "blue")
                end
            end
        else

            local players = { }
            for i = 1, 16 do
                if player_present(i) then
                    players[#players + 1] = i
                end
            end

            if (#players > 0) then

                math.randomseed(os.time())
                math.random();
                math.random();
                math.random();

                -- Choose random player to become Zombie (blue team):
                local player = players[math.random(1, #players)]
                zombies:setTeam(player, "blue")
                local team = zombies:GetTeamType(player)
                local msg = gsub(parameters.on_game_begin, "%%team%%", team)
                rprint(player, msg)

                -- Set every other player as a human (red team):
                for i = 1, 16 do
                    if (player_present(i) and i ~= player) then
                        zombies:setTeam(i, "red")
                        local team = zombies:GetTeamType(i)
                        local msg = gsub(parameters.on_game_begin, "%%team%%", team)
                        rprint(i, msg)
                    end
                end
            end
        end
    end
end

function zombies:setHealth(PlayerIndex, Team)
    for index, attribute in pairs(parameters.attributes) do
        if (index == "Humans") and (Team == "red") then
            return tonumber(attribute.health)
        elseif (index == "Zombies") and (Team == "blue") then
            return tonumber(attribute.health)
        elseif (index == "Last Man Standing") and (Team == "red") then
            local player = zombies:PlayerTable(PlayerIndex)
            if (player.last_man ~= nil) then
                return tonumber(attribute.health)
            end
        end
    end
end

function zombies:GetTeamType(p)
    local team = get_var(p, "$team")
    if (team == "red") then
        return "human"
    else
        return "zombie"
    end
end

function zombies:setTeam(PlayerIndex, team)

    local PlayerObject = get_dynamic_player(PlayerIndex)
    zombies:deleteWeapons(PlayerIndex, PlayerObject)

    if (PlayerObject ~= 0) then
        write_word(PlayerObject + 0x31E, 0)
        write_word(PlayerObject + 0x31F, 0)
    end

    zombies:killPlayer(PlayerIndex)
    zombies:SwitchTeam(PlayerIndex, team)
    zombies:ResetScore(PlayerIndex)
end

function zombies:deleteWeapons(PlayerIndex, PlayerObject)
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

function zombies:SetLastMan(params)

    local team_count = zombies:getTeamCount() -- blues[1], reds[2]
    local Zombies, Humans = team_count[1], team_count[2]

    local msg = nil
    local params = params or {}

    if (Humans == 1 and Zombies >= 1) then
        for _, player in pairs(zombies.players) do
            if (player) then
                if (player.team == "red") then
                    if (player.last_man == nil) then
                        player.last_man, params.last_man = true, player.name
                        for index, attribute in pairs(parameters.attributes) do
                            if (index == "Last Man Standing") then
                                local player_object = get_dynamic_player(player.id)
                                if (player_object ~= 0) then
                                    if (attribute.overshield) then
                                        zombies:ApplyOvershield(player.id)
                                    end
                                    write_float(player_object + 0xE0, floor(tonumber(attribute.health)))
                                end
                            end
                        end
                        break
                    end
                end
            end
        end
    end

    if (params.last_man) then
        if (params.suicide) then
            msg = gsub(gsub(parameters.on_last_man.suicide, "%%victim%%", params.vname), "%%lastman%%", params.last_man)  
        else
            msg = gsub(gsub(gsub(parameters.on_last_man.normal, 
            "%%victim%%", params.vname), 
            "%%killer%%", params.kname),
            "%%lastman%%", params.last_man)
        end
    elseif (not params.last_man) then
    
        -- Suicide:
        if (params.suicide) then
            msg = gsub(parameters.on_suicide, "%%victim%%", params.vname)
        
        -- Zombie kills Human (not cured)
        elseif (params.zombified and not params.cured) then
            msg = gsub(gsub(parameters.on_zombify, "%%victim%%", params.vname), "%%killer%%", params.kname)
            
        -- Zombie kills Human (cured)
        elseif (params.zombified and params.cured) then
            msg = gsub(gsub(parameters.on_cure, "%%victim%%", params.vname), "%%killer%%", params.kname)
            
        -- Human kills Zombie:
        elseif (params.pvp) then
            msg = gsub(gsub(parameters.on_kill, "%%victim%%", params.vname), "%%killer%%", params.kname)
        end
    end
    
    if (msg ~= nil) then
        zombies:broadcast(msg, false)
    end
end

function zombies:ApplyOvershield(PlayerIndex)
    if (player_present(PlayerIndex) and player_alive(PlayerIndex)) then
        local ObjectID = spawn_object("eqip", "powerups\\over shield")
        powerup_interact(ObjectID, PlayerIndex)
    end
end

function zombies:CamoOnCrouch(PlayerIndex)
    local team = get_var(PlayerIndex, "$team")

    for index, attribute in pairs(parameters.attributes) do
        if (index == "Zombies" and team == "blue") or (index == "Last Man Standing" and team == "red") then
            if (attribute.invisibility_on_crouch) then
                local player_object = get_dynamic_player(PlayerIndex)
                if (player_object ~= 0) then
                    local couching = read_float(player_object + 0x50C)
                    if (couching == 1) then
                        execute_command("camo " .. PlayerIndex .. " 2")
                    end
                end
            end
        end
    end
end

function zombies:unregisterSAPPEvents(error)
    unregister_callback(cb['EVENT_TICK'])
    unregister_callback(cb['EVENT_GAME_END'])
    unregister_callback(cb['EVENT_JOIN'])
    unregister_callback(cb['EVENT_LEAVE'])
    unregister_callback(cb['EVENT_DIE'])
    unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])
    execute_command("log_note \"" .. format('[Zpocalypse] ' .. error) .. "\"")
    cprint(format('[Zpocalypse] ' .. error), 4 + 8)
end

function zombies:GetPlayerCount()
    return tonumber(get_var(0, "$pn"))
end

function zombies:getTeamCount()
    local blues = get_var(0, "$blues")
    local reds = get_var(0, "$reds")
    return { tonumber(blues), tonumber(reds) }
end

function zombies:SetNav(LastMan)
    for i = 1, 16 do
        if player_present(i) then
            local PlayerSM = get_player(i)
            local PTableIndex = to_real_index(i)
            if (PlayerSM ~= 0) then
                if (LastMan ~= nil) then
                    write_word(PlayerSM + 0x88, to_real_index(LastMan))
                else
                    write_word(PlayerSM + 0x88, PTableIndex)
                end
            end
        end
    end
end

function zombies:getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
end

function zombies:PickRandomTeam()
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

function zombies:ResetScore(PlayerIndex)
    execute_command("score " .. PlayerIndex .. " 0")
    execute_command_sequence("team_score 0 0")
end

function zombies:initPlayer(PlayerIndex, Team, Init)
    if (PlayerIndex) then
        local players = zombies.players
        if (Init) then
            players[#players + 1] = {
                kills = 0,
                team = Team,
                drone = nil,
                assign = false,
                last_man = nil,
                id = PlayerIndex,
                weapon = "weapons\\ball\\ball",
                name = get_var(PlayerIndex, "$name"),
            }
        else
            for index, player in pairs(players) do
                if (player.id == PlayerIndex) then
                    players[index] = nil
                end
            end
        end
    end
end

function zombies:PlayerTable(PlayerIndex)
    local players = zombies.players
    for _, player in pairs(players) do
        if (player) then
            if (player.id == PlayerIndex) then
                return player
            end
        end
    end
    return nil
end

function zombies:getXYZ(PlayerIndex, PlayerObject)
    local coords, x, y, z = { }
    if player_alive(PlayerIndex) then
        local VehicleID = read_dword(PlayerObject + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            coords.invehicle = false
            x, y, z = read_vector3d(PlayerObject + 0x5c)
        else
            coords.invehicle = true
            x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
        end

        coords.x, coords.y, coords.z = x, y, z + 1
    end
    return coords
end

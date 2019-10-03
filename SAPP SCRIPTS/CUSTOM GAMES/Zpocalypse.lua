--[[
--=====================================================================================================--
Script Name: Zpocalypse, for SAPP (PC & CE)
Description: Custom Zombie Game.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

local zombies = {}
function zombies:init()
    zombies.settings = {
        
        -- #Numbers of players required to set the game in motion (cannot be less than 2)
        required_players = 2,
                
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
        
        -- Message emitted when a human is killed by a zombie:
        on_zombify = "%name% has been zombified!",
        
        on_last_man = "%name% is the last human standing!",
        
        -- #Respawn time (override)
        -- When enabled, players who are killed by the opposing team will respawn immediately. 
        -- Does not affect suicides or other deaths (PvP only by design).
        respawn_override = true,
        respawn_time = 0, -- In seconds (0 = immediate)
        
        attributes = {
            ["Humans"] = {
                -- Set to 0 to disable (normal speed is 1)
                running_speed = 1,
            },
            ["Zombies"] = {
                -- Set to 0 to disable (normal speed is 1)
                running_speed = 1.2,
                health = 100,
                damage_multiplier = 2,
                -- Set to 'false' to disable:
                invisibility_on_crouch = true,
            },
            ["Last Man Standing"] = {
                -- Set to 0 to disable (normal speed is 1)
                running_speed = 1.2,
                -- Set to 'false' to disable temporary overshield:
                overshield = true,
                -- Set to 'false' to disable temporary camouflage:
                camouflage = true,
                -- If true, the last man standing will have regenerating health:
                regenerating_health = true,
                -- Health will regenerate in chunks of this percent every 30 ticks until they gain maximum health.
                increment = 0.0005,
            },
        },
        
        -- Some functions temporarily remove the server prefix while broadcasting a message.
        -- This prefix will be restored to 'server_prefix' when the message relay is done.
        -- Enter your servers default prefix here:
        server_prefix = "** SERVER **",
        
        
        --# Do Not Touch #--
        drones = { },
        assign = { },
        last_man = nil,
        --
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
    
    
    if (get_var(0, '$gt') ~= "n/a") then
        zombies:init()
    end
end

function OnScriptUnload()
    --
end

function OnTick()

    local set = zombies.settings
    local player_count = zombies:GetPlayerCount()
    
    local countdown_begun = (init_countdown == true)
    
    -- # Continuous message emitted when there aren't enough players to start the game:
    for i = 1, 16 do
        if player_present(i) then
            if (print_nep) and (not gamestarted) and (player_count < set.required_players) then
                zombies:cls(i, 25)
                local msg = gsub(gsub(set.not_enough_players, 
                "%%current%%", player_count), 
                "%%required%%", set.required_players)
                rprint(i, msg)
            elseif (countdown_begun) and (not gamestarted) and (set.pregame) then
                zombies:cls(i, 25)
                rprint(i, set.pregame)
            end

            -- Assign "skull" to zombies:
            local player_object = get_dynamic_player(i)
            if player_alive(i) and set.assign[i] then
                execute_command("wdel " .. i)
                local x, y, z = read_vector3d(player_object + 0x5C)
                
                local oddball = spawn_object("weap", "weapons\\ball\\ball", x, y, z)
                local object_spawned = assign_weapon(oddball, i)
    
                local drone = get_object_memory(oddball)
                set.drones[#set.drones + 1] = {pid = i, drone = oddball}
                
                set.assign[i] = false
            end
            
            if (gamestarted) and player_alive(i) then
                local attributes = zombies.settings.attributes
                local team = get_var(i, "$team")
                for k,v in pairs(attributes) do
                    if (k == "Humans") and (team == "red") then                    
                        execute_command("s " .. i .. " " .. tonumber(v.running_speed))
                    elseif (k == "Zombies") and (team == "blue") then
                        execute_command("s " .. i .. " " .. tonumber(v.running_speed))
                    elseif (k == "Last Man Standing") and (team == "red") then
                        if (set.last_man ~= nil) and (set.last_man == i) then                    
                            execute_command("s " .. i .. " " .. tonumber(v.running_speed))
                            if (v.regenerating_health) then
                                if (player_object ~= 0) then
                                    if read_float(player_object + 0xE0) < 1 then
                                        write_float(player_object + 0xE0, read_float(player_object + 0xE0) + v.increment)
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

        local seconds = zombies:secondsToTime(countdown)
        local timeRemaining = set.delay - math.floor(seconds)
        local char = zombies:getChar(timeRemaining)
        
        set.pregame = set.pregame or ""
        set.pregame = gsub(gsub(set.pre_game_message, "%%time_remaining%%", timeRemaining), "%%s%%", char)
                
        if (timeRemaining <= 0) then
            gamestarted = true
            zombies:StopTimer()
            local done = nil
            for i = 1, 16 do
                if player_present(i) then
                    done = zombies:sortPlayers(i)
                    local team = zombies:GetTeamType(i)
                    local msg = gsub(set.on_game_begin, "%%team%%", team)
                    rprint(i, msg)
                end
            end
            if (done) then 
                zombies:SetLastMan()
            end
        end
    end
end

function OnGameStart()

    if (get_var(0, '$gt') ~= "n/a") then
        zombies:init()
    end
    
    local set = zombies.settings

    if not zombies:isTeamPlay() then
        zombies:unregisterSAPPEvents(' Only supports team play!')
    elseif (set.required_players < 2) then
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
            useEvenNumbers = true
        else
            -- Number is odd
            useEvenNumbers = false
        end
    end
end

function OnGameEnd()
    zombies:StopTimer()
end

function OnPlayerConnect(p)
    
    local set = zombies.settings
    local player_count = zombies:GetPlayerCount()
    local required = set.required_players
        
    local team_count = zombies:getTeamCount() -- blues[1], reds[2]
    
    if (player_count >= required) and (not init_countdown) and (not gamestarted) then
        zombies:StartTimer()
    elseif (player_count >= required) and (print_nep) then
        print_nep = false
    elseif (player_count > 0 and player_count < required) then
        print_nep = true
    end
    
    -- Game has already begun. Set player to zombie team:
    if (gamestarted) and (get_var(p, "$team") == "red") then
        SwitchTeam(p, "blue", true)
    end
end

function OnPlayerDisconnect(PlayerIndex)

    local set = zombies.settings
    local player_count = zombies:GetPlayerCount()
    player_count = player_count - 1
    
    local team_count = zombies:getTeamCount() -- blues[1], reds[2]
    local Zombies,Humans = team_count[1], team_count[2]
    
    local team = get_var(PlayerIndex, "$team")
    
    if (team == "blue") then
        zombies:CleanUpDrones(PlayerIndex)
        Zombies = Zombies - 1
    else
        Humans = Humans - 1
    end

    if (gamestarted) then
        -- Ensures all parameters are set to their default values.
        if (player_count <= 0) then
            zombies:StopTimer()
            
            -- One player remains | ends the game.
        elseif (player_count == 1) then
            for i = 1, 16 do
                if (tonumber(i) ~= tonumber(PlayerIndex)) then
                    if player_present(i) then
                        -- Send game over message to the last remaining player:
                        local team = zombies:GetTeamType(i)
                        zombies:gameOver(gsub(set.end_of_game, "%%team%%", team))
                        break
                    end
                end
            end
            
        -- Checks if the remaining players are on the same team | ends the game.
        elseif (Zombies <= 0 and Humans >= 1) then
            zombies:gameOver(gsub(set.end_of_game, "%%team%%", "human"))
        elseif (Humans <= 0 and Zombies >= 1) then
            zombies:gameOver(gsub(set.end_of_game, "%%team%%", "zombie"))
        end
        
    -- Pre-Game countdown was initiated but someone left before the game began.
    -- Stop the timer, reset the count and display the continuous 
    -- message emitted when there aren't enough players to start the game.
    elseif (not gamestarted) and (init_countdown and player_count < set.required_players) then
        print_nep = true
        countdown, init_countdown = 0, false
    end
end

function OnPlayerSpawn(PlayerIndex)
    -- Set grenades to 0 for zombies:
    local PlayerObject = get_dynamic_player(PlayerIndex)
    if (PlayerObject ~= 0 and gamestarted) then
        local team = get_var(PlayerIndex, "$team")
        if (team == "blue") then
            write_word(PlayerObject + 0x31E, 0)
            write_word(PlayerObject + 0x31F, 0)
            
            zombies.settings.assign[PlayerIndex] = true
        end
    end
end

function OnWeaponDrop(PlayerIndex)
    if player_alive(PlayerIndex) then
        local team = get_var(PlayerIndex, "$team")
        if (team == "blue") then
            zombies:CleanUpDrones(PlayerIndex)
            zombies.settings.assign[PlayerIndex] = true
        end
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)

    if (gamestarted) then
    
        local killer = tonumber(KillerIndex)
        local victim = tonumber(PlayerIndex)

        local kteam = get_var(killer, "$team")
        local vteam = get_var(victim, "$team")
        
        local set = zombies.settings

        if (killer > 0) then
        
            -- Check for suicide:
            if (killer == victim) then
                SwitchTeam(victim, "blue")
                local message = gsub(set.on_zombify, "%%name%%", get_var(victim, "$name"))
                zombies:announceZombify(message)
            end

            if (killer ~= victim) then
                
                local bluescore,redscore = get_var(0, "$bluescore"), get_var(0, "$redscore")

                if (kteam == "blue") and (vteam == "red") then
                    SwitchTeam(victim, "blue")
                    local message = gsub(set.on_zombify, "%%name%%", get_var(victim, "$name"))
                    zombies:announceZombify(message)
                elseif (kteam == "red") and (vteam == "blue") then
                    zombies:CleanUpDrones(victim)
                end
                
                local team_count = zombies:getTeamCount() -- blues[1], reds[2]
                local Zombies,Humans = team_count[1], team_count[2]

                -- No humans left -> zombies win
                if (Humans == 0 and Zombies >= 1) then
                    zombies:gameOver(gsub(set.end_of_game, "%%team%%", "Zombies"))
                end
                
                -- Check for last man:
                zombies:SetLastMan()
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

function zombies:killPlayer(PlayerIndex)
    local PlayerObject = read_dword(get_player(PlayerIndex) + 0x34)
    if PlayerObject ~= nil then
        destroy_object(PlayerObject)
    end
end

function SwitchTeam(PlayerIndex, team, bool)
    if not (bool) then
    
        local set = zombies.settings
    
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

function zombies:gameOver(message)
    execute_command("msg_prefix \"\"")
    say_all(message)
    execute_command("msg_prefix \" " .. zombies.settings.server_prefix .. "\"")
    execute_command("sv_map_next")
end

function zombies:announceZombify(message)
    execute_command("msg_prefix \"\"")
    say_all(message)
    execute_command("msg_prefix \" " .. zombies.settings.server_prefix .. "\"")
end

function zombies:announceLastMan(message)
    execute_command("msg_prefix \"\"")
    say_all(message)
    execute_command("msg_prefix \" " .. zombies.settings.server_prefix .. "\"")
end

function zombies:secondsToTime(seconds)
    seconds = seconds % 60
    return seconds
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

function zombies:CleanUpDrones(PlayerIndex)
    local tab = zombies.settings.drones
    for k,v in pairs(tab) do
        if (k) then
            if (v.pid == PlayerIndex) then
                destroy_object(v.drone)
                tab[k] = nil
            end
        end
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
    else
        return false
    end
end

function zombies:sortPlayers(PlayerIndex)
    if (gamestarted) then
        if (useEvenNumbers) then
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
        return true
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
    
    zombies:deleteWeapons(PlayerIndex)
    local PlayerObject = get_dynamic_player(PlayerIndex)
    
    if (PlayerObject ~= 0) then
        write_word(PlayerObject + 0x31E, 0)
        write_word(PlayerObject + 0x31F, 0)
    end
    
    zombies:killPlayer(PlayerIndex)
    SwitchTeam(tonumber(PlayerIndex), team)
    zombies:ResetScore(PlayerIndex)
end

function zombies:deleteWeapons(PlayerIndex)
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

function zombies:SetLastMan()

    local set = zombies.settings
    
    local team_count = zombies:getTeamCount() -- blues[1], reds[2]
    local Zombies,Humans = team_count[1], team_count[2]
    
    if (Humans == 1 and Zombies >= 1) then
        for i = 1,16 do
        
            local team = get_var(i, "$team")
            if (team == "red") then
                set.last_man = i
                
                for k,v in pairs(set.attributes) do
                    if (k == "Last Man Standing") then
                        if (v.overshield) then
                            zombies:ApplyOvershield(i)
                        end
                        if (v.camouflage) then
                            zombies:ApplyCamo(i)
                        end
                    end
                end
                
                local name = get_var(i, "$name")
                local msg = gsub(set.on_last_man, "%%name%%", name)
                zombies:announceLastMan(msg)
                break
            end
        end
    end
end

function zombies:ApplyOvershield(PlayerIndex)
    if (player_present(PlayerIndex) and player_alive(PlayerIndex)) then
        local ObjectID = spawn_object("eqip", "powerups\\over shield")
        powerup_interact(ObjectID, PlayerIndex)
    else
        return false
    end
end

function zombies:ApplyCamo(PlayerIndex)
    if (player_present(PlayerIndex) and player_alive(PlayerIndex)) then
        local ObjectID = spawn_object("eqip", "powerups\\active camouflage")
        powerup_interact(ObjectID, PlayerIndex)
    else
        return false
    end
end

function zombies:unregisterSAPPEvents(error)
    unregister_callback(cb['EVENT_TICK'])
    unregister_callback(cb['EVENT_GAME_END'])
    unregister_callback(cb['EVENT_JOIN'])
    unregister_callback(cb['EVENT_LEAVE'])
    unregister_callback(cb['EVENT_DIE'])
    unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])
    execute_command("log_note \"" .. string.format('[Zpocalypse] ' .. error) .. "\"")
    cprint(string.format('[Zpocalypse] ' .. error), 4 + 8)
end

function zombies:GetPlayerCount()
    return tonumber(get_var(0, "$pn"))
end

function zombies:getTeamCount()
    local blues = get_var(0, "$blues")
    local reds = get_var(0, "$reds")
    return {tonumber(blues), tonumber(reds)}
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
    math.random();math.random();math.random();
    local team, num = 0, math.random(1, 2)
    if (num == 1) then team = "red" else team = "blue" end
    return team
end

function zombies:ResetScore(PlayerIndex)
    execute_command("score " .. PlayerIndex .. " 0")
    execute_command("kills " .. PlayerIndex .. " 0")
    execute_command("deaths " .. PlayerIndex .. " 0")
    execute_command("assists " .. PlayerIndex .. " 0")
    execute_command_sequence("team_score 0 0")
end

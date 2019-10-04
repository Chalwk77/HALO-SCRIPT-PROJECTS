--[[
--=====================================================================================================--
Script Name: Maniac (beta v1.0), for SAPP (PC & CE)
Description: This game is a variation of Juggernaut and Hide and Seek.

IN DEVELOPMENT

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

local maniac = {}
function maniac:init()
    maniac.settings = {

        -- #Numbers of players required to set the game in motion (cannot be less than 2)
        required_players = 2,

        -- Continuous message emitted when there aren't enough players.
        not_enough_players = "%current%/%required% players needed to start the game.",

        -- #Countdown delay (in seconds)
        -- This is a pre-game-start countdown initiated at the beginning of each game.
        delay = 5,
        
        turn_timer = 60, -- (in seconds)

        -- # This message is the pre-game broadcast:
        pre_game_message = "Maniac (beta) will begin in %time_remaining% second%s%",
        
        -- # This message is broadcast when the game begins:
        on_game_begin = "The game has begun",
        
        -- # This message is broadcast when the game is over:
        end_of_game = "%name% won the game!",

        -- #This message is broadcast when someone becomes the maniac:
        new_maniac = "%name% is now the maniac!",

        -- #Respawn time (override)
        -- When enabled, players who are killed by the opposing team will respawn immediately.
        -- Does not affect suicides or other deaths (PvP only by design).
        respawn_override = true,
        respawn_time = 0, -- In seconds (0 = immediate)

        attributes = {
            -- Tag Type | Tag Name | Primary Ammo | Secondary Ammo
            ["weapons"] = {
                [1] = { "weap", "weapons\\sniper rifle\\sniper rifle", 100,100},
                [2] = { "weap", "weapons\\pistol\\pistol", 100,100},
                [3] = { "weap", "weapons\\rocket launcher\\rocket launcher", 100,100},
                [4] = { "weap", "weapons\\shotgun\\shotgun", 100,100},
            },
            ["maniac"] = {
                -- Maniac Health: 0 to 99999 (Normal = 1)
                health = 999999,
                -- Set to 0 to disable (normal speed is 1)
                running_speed = 1.3,
                damage_multiplier = 10, -- (0 to 10) (Normal = 1)
                -- Set to 'false' to disable:
                invisibility_on_crouch = true,
            },
        },

        -- Some functions temporarily remove the server prefix while broadcasting a message.
        -- This prefix will be restored to 'server_prefix' when the message relay is done.
        -- Enter your servers default prefix here:
        server_prefix = "** SERVER **",


        --# Do Not Touch #--
        assign = { },
        active_shooter = { },
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

    if (get_var(0, '$gt') ~= "n/a") then
        maniac:init()
        for i = 1,16 do
            if player_present(i) then
                maniac:gameStartCheck(i)
            end
        end
    end
end

function OnScriptUnload()
    --
end

function OnTick()

    local set = maniac.settings
    local active_shooter = set.active_shooter
    local attributes = maniac.settings.attributes
    local player_count = maniac:GetPlayerCount()
    local countdown_begun = (init_countdown == true)

    for i = 1, 16 do
        if player_present(i) then
        
            -- # Continuous message emitted when there aren't enough players to start the game:
            if (print_nep) and (not gamestarted) and (player_count < set.required_players) then
                maniac:cls(i, 25)
                local msg = gsub(gsub(set.not_enough_players,
                "%%current%%", player_count),
                "%%required%%", set.required_players)
                rprint(i, msg)
            elseif (countdown_begun) and (not gamestarted) and (set.pregame) then
                maniac:cls(i, 25)
                rprint(i, set.pregame)
            end

            if (gamestarted and player_alive(i)) then 
                local player_object = get_dynamic_player(i)
                
                -- Weapon Assignments:
                if (set.assign[i]) then

                    local x, y, z = read_vector3d(player_object + 0x5C)
                    execute_command("wdel " .. i)

                    for type, v in pairs(attributes) do
                        if (type == "weapons") then
                            for K,V in pairs(v) do
                                local tag_type, tag_name = V[1], V[2]
                                local primary_ammo,secondary_ammo = V[3],V[4]
                                local weapon = spawn_object(tag_type, tag_name, x, y, z)
                                assign_weapon(weapon, i)
                            end
                            set.assign[i] = false
                        end
                    end
                    
                else
                    
                    for _, shooter in pairs(active_shooter) do
                        if (shooter) then
                            if (shooter.id == i and shooter.active) and (not shooter.expired) then
                                maniac:CamoOnCrouch(i)
                                shooter.timer = shooter.timer + 0.03333333333333333
                                
                                local seconds = maniac:secondsToTime(shooter.timer)
                                local timeRemaining = shooter.duration - math.floor(seconds)
                                local char = maniac:getChar(timeRemaining)
                                if (timeRemaining <= 0) then
                                    shooter.active, shooter.expired = false, true
                                    execute_command("ungod " .. i)
                                    maniac:SelectManiac()
                                    -- restore this maniac to normal player status:
                                    -- logic:
                                elseif (player_object ~= 0) then
                                    for j = 0, 3 do
                                        local weapon = get_object_memory(read_dword(player_object + 0x2F8 + j * 4))
                                        if (weapon ~= 0) then
                                            write_word(weapon + 0x2B6, 9999)
                                        end
                                    end
                                    for type, attribute in pairs(attributes) do
                                        if (type == "maniac") then
                                            if (attribute.running_speed > 0) then
                                                execute_command("s " .. i .. " " .. tonumber(attribute.running_speed))
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
    end

    if (countdown_begun) then
        countdown = countdown + 0.03333333333333333
        local seconds = maniac:secondsToTime(countdown)
        local timeRemaining = set.delay - math.floor(seconds)
        local char = maniac:getChar(timeRemaining)

        set.pregame = set.pregame or ""
        set.pregame = gsub(gsub(set.pre_game_message, "%%time_remaining%%", timeRemaining), "%%s%%", char)

        if (timeRemaining <= 0) then
            gamestarted = true
            maniac:StopTimer()
            
            for i = 1, 16 do
                if player_present(i) then
                    active_shooter[#active_shooter + 1] = {
                        id = i, 
                        timer = 0, 
                        duration = set.turn_timer,
                        active = false, turn_over = false, 
                        func = function(PlayerIndex)
                            execute_command("god " .. PlayerIndex)
                            local player_object = get_dynamic_player(PlayerIndex)
                            write_word(player_object + 0x31E, 0x7F7F)
                        end
                    }
                end
            end
             
            if (#active_shooter > 0) then

                -- Remove default death messages (temporarily)
                local kma = sig_scan("8B42348A8C28D500000084C9") + 3
                original = read_dword(kma)
                safe_write(true)
                write_dword(kma, 0x03EB01B1)
                safe_write(false)

                execute_command("sv_map_reset")

                -- Re enables default death messages
                safe_write(true)
                write_dword(kma, original)
                safe_write(false)
                
                maniac:SelectManiac()
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, '$gt') ~= "n/a") then
        maniac:init()
    end
end

function OnGameEnd()
    maniac:StopTimer()
    gamestarted = false
end

function maniac:gameStartCheck(p)
    
    local set = maniac.settings
    local player_count = maniac:GetPlayerCount()
    local required = set.required_players

    if (player_count >= required) and (not init_countdown) and (not gamestarted) then
        maniac:StartTimer()
    elseif (player_count >= required) and (print_nep) then
        print_nep = false
    elseif (player_count > 0 and player_count < required) then
        print_nep = true
    elseif (game_started) then
        active_shooter[#active_shooter + 1] = {
            id = p, 
            timer = 0, 
            duration = set.turn_timer,
            active = false, turn_over = false, 
            func = function(PlayerIndex)
                execute_command("god " .. PlayerIndex)
                local player_object = get_dynamic_player(PlayerIndex)
                write_word(player_object + 0x31E, 0x7F7F)
            end
        }
    end
end

function OnPlayerConnect(p)
    maniac:gameStartCheck(p)
end

function OnPlayerDisconnect(PlayerIndex)

    local p = tonumber(PlayerIndex)

    local set = maniac.settings
    local player_count = maniac:GetPlayerCount()
    player_count = player_count - 1

    if (gamestarted) then
    
        local active_shooter = maniac.active_shooter
        for k,v in pairs(active_shooter) do
            if (v.id == p) then
                active_shooter[k] = nil
            end
        end
    
        if (player_count <= 0) then
            
            -- Ensure all timer parameters are set to their default values.
            maniac:StopTimer()

            -- One player remains | ends the game.
        elseif (player_count == 1) then
            for i = 1, 16 do
                if (tonumber(i) ~= tonumber(p)) then
                    if player_present(i) then
                        -- Send game over message to the last remaining player:
                        maniac:broadcast(gsub(set.end_of_game, "%%team%%", team), true)
                        break
                    end
                end
            end
        end

        -- Pre-Game countdown was initiated but someone left before the game began.
        -- Stop the timer, reset the countdown and display the continuous
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
        local set = maniac.settings

        if (killer > 0) then            
            
            -- PvP:
            if (killer ~= victim) then
                -- logic:
            else
                -- SUICIDE (select new maniac)
                -- logic:
            end

            maniac:endGameCheck()
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex and gamestarted) then
        local isManiac = maniac:isManiac(CauserIndex)
        if (isManiac) then
            local attributes = maniac.settings.attributes
            for type, attribute in pairs(attributes) do
                if (type == "maniac") then
                    return true, Damage * attribute.damage_multiplier
                end
            end
        end
    end
end

function maniac:killPlayer(PlayerIndex)
    local PlayerObject = read_dword(get_player(PlayerIndex) + 0x34)
    if (PlayerObject ~= nil) then
        destroy_object(PlayerObject)
    end
end

function maniac:isManiac(PlayerIndex)
    for _, shooter in pairs(maniac.settings.active_shooter) do
        if (shooter) then
            if (shooter.id == PlayerIndex and shooter.active) and (not shooter.expired) then
                return true
            end
        end
    end
end

function maniac:broadcast(message, gameover)
    execute_command("msg_prefix \"\"")
    say_all(message)
    execute_command("msg_prefix \" " .. maniac.settings.server_prefix .. "\"")
    if (gameover) then
        execute_command("sv_map_next")    
    end
end

function maniac:secondsToTime(seconds)
    seconds = seconds % 60
    return seconds
end

function maniac:StartTimer()
    countdown, init_countdown = 0, true
end

function maniac:StopTimer()
    countdown, init_countdown = 0, false
    print_nep = false
    
    for i = 1, 16 do
        if player_present(i) then
            maniac:cls(i, 25)
        end
    end
end

function maniac:endGameCheck()
    -- logic:
end

function maniac:cls(PlayerIndex, count)
    local count = count or 25
    for _ = 1, count do
        rprint(PlayerIndex, " ")
    end
end

function maniac:SelectManiac()
    local set = maniac.settings
    local active_shooter = set.active_shooter

    local players = { }
    for i = 1,16 do
        if player_present(i) then
            for k,v in pairs(active_shooter) do
                if (k) then
                    if (v.id == i) and (not v.active) and (not v.expired) then
                        players[#players + 1] = i
                    end
                end
            end
        end
    end
    
    if (#players > 0) then
            
        math.randomseed(os.time())
        math.random();math.random();math.random();
        local random_player = players[math.random(#players)]
        
        for k,v in pairs(active_shooter) do        
            if (v.id == random_player) then
                v.active, set.assign[v.id] = true, true
                SetGodMode = function()
                    v.func(random_player)
                end
                maniac:broadcast(gsub(set.new_maniac, "%%name%%", get_var(v.id, "$name")), false)
            end
        end
        timer(2000, "SetGodMode") 
        
    else
        local tally = {}
        for i = 1,16 do
            if player_present(i) then
                local kills = get_var(i, "$kills")
                tally[i] = kills
            end
        end
        
        if (#tally > 0) then
        
            maniac:broadcast(set.end_of_game, true)
        end
    end
end

function maniac:deleteWeapons(PlayerIndex)
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

function maniac:CamoOnCrouch(PlayerIndex)
    local attributes = maniac.settings.attributes
    for type, attribute in pairs(attributes) do
        if (type == "maniac") then
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

function maniac:SetNav(LastMan)
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

function maniac:getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
end

function maniac:GetPlayerCount()
    return tonumber(get_var(0, "$pn"))
end

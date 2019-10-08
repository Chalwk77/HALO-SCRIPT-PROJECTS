--[[
--=====================================================================================================--
Script Name: Level Up (v1.2), for SAPP (PC & CE)
Description: 

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

local game = {}
function game:init()
    game.settings = {

        -- # Number of players required to set the game in motion (cannot be less than 2)
        required_players = 2,

        -- # Continuous message emitted when there aren't enough players.
        not_enough_players = "%current%/%required% players needed to start the game.",

        -- # Countdown delay (in seconds)
        -- This is a pre-game-start countdown initiated at the beginning of each game.
        delay = 10,

        -- # This message is the pre-game broadcast:
        pre_game_message = "Level Up (v1.2) will begin in %minutes%:%seconds%",

        -- # This message is broadcast when the game begins:
        on_game_begin = "The game has begun",
        
        current_level = "|lLevel: %level% (%weapon%) |rNext Level: %next_level% (%next_weapon% - Kills: %cur_kills%/%req_kills%)",
        on_levelup = "(+) %name% is now Level %level%",
        on_suicide = "(-) %name% committed suicide and is now Level %level%",
        on_melee = "(-) %name% was melee'd by %killer% and is now Level %level%",

        levels = {
            -- Starting Level:
            start = 1,
            
            -- Weapon | Name | Instructions | Kills Required | Frags/Plasmas | Ammo Multiplier
            [1] = { "weapons\\shotgun\\shotgun", "Shotgun", 1, { 6, 6 }, 0 },
            [2] = { "weapons\\assault rifle\\assault rifle", "Assualt Rifle", 2, { 2, 2 }, 240 },
            [3] = { "weapons\\pistol\\pistol", "Pistol", 3, { 2, 1 }, 36 },
            [4] = { "weapons\\sniper rifle\\sniper rifle", "Sniper Rifle", 4, { 3, 2 }, 12 },
            [5] = { "weapons\\rocket launcher\\rocket launcher", "Rocket Launcher", 5, { 1, 1 }, 6 },
            [6] = { "weapons\\plasma_cannon\\plasma_cannon", "Fuel Rod", 6, { 3, 1 }, 0 },
            
            [7] = { "vehicles\\ghost\\ghost_mp", "weapons\\shotgun\\shotgun", "Ghost", 7, { 0, 0 }, 0 },
            [8] = { "vehicles\\rwarthog\\rwarthog", "weapons\\shotgun\\shotgun", "Rocket Hog", 8, { 0, 0 }, 0 },
            [9] = { "vehicles\\scorpion\\scorpion_mp", "weapons\\shotgun\\shotgun", "Tank", 9, { 0, 0 }, 0 },
            [10] = { "vehicles\\banshee\\banshee_mp", "weapons\\shotgun\\shotgun", "Banshee", 10, { 0, 0 }, 0 }
        },

        -- Some functions temporarily remove the server prefix while broadcasting a message.
        -- This prefix will be restored to 'server_prefix' when the message relay is done.
        -- Enter your servers default prefix here:
        server_prefix = "** SERVER **",

        damage_multipliers = {
        
            melee = {
                {"weapons\\assault rifle\\melee", 4},
                {"weapons\\ball\\melee", 4},
                {"weapons\\flag\\melee", 4},
                {"weapons\\flamethrower\\melee", 4},
                {"weapons\\needler\\melee", 4},
                {"weapons\\pistol\\melee", 1},
                {"weapons\\plasma pistol\\melee", 4},
                {"weapons\\plasma rifle\\melee", 3},
                {"weapons\\rocket launcher\\melee", 1},
                {"weapons\\shotgun\\melee", 2},
                {"weapons\\sniper rifle\\melee", 2},
                {"weapons\\plasma_cannon\\effects\\plasma_cannon_melee", 2},
                
            },
            
            grenades = {
                {"weapons\\frag grenade\\explosion", 2},
                {"weapons\\plasma grenade\\explosion", 2},
                {"weapons\\plasma grenade\\attached", 10},
            },
            
            vehicles = { 
                {"vehicles\\ghost\\ghost bolt", 1.015},
                {"vehicles\\scorpion\\bullet", 1.020},
                {"vehicles\\warthog\\bullet", 1.025},
                {"vehicles\\c gun turret\\mp bolt", 1.030},
                {"vehicles\\banshee\\banshee bolt", 1.035},
                {"vehicles\\scorpion\\shell explosion", 1.040},
                {"vehicles\\banshee\\mp_fuel rod explosion", 1.045},
            },
            
            projectiles = {
                {"weapons\\pistol\\bullet", 1.00},
                {"weapons\\plasma rifle\\bolt", 1.50},
                {"weapons\\shotgun\\pellet", 1.20},
                {"weapons\\plasma pistol\\bolt", 1.50},
                {"weapons\\needler\\explosion", 2.00},
                {"weapons\\assault rifle\\bullet", 2.00},
                {"weapons\\needler\\impact damage", 1.10},
                {"weapons\\flamethrower\\explosion", 2.00},
                {"weapons\\sniper rifle\\sniper bullet", 4.00},
                {"weapons\\rocket launcher\\explosion", 5.00},
                {"weapons\\needler\\detonation damage", 2.00},
                {"weapons\\plasma rifle\\charged bolt", 3.00},
                {"weapons\\plasma_cannon\\effects\\plasma_cannon_melee", 2.50},
                {"weapons\\plasma_cannon\\effects\\plasma_cannon_explosion", 2.50},
            },
            
            vehicle_collision = {
                {"globals\\vehicle_collision", 10},
            },
            
            fall_damage = {
                {"globals\\falling", 1},
                {"globals\\distance", 1},
            },
            
        },
        --# Do Not Touch #--
        players = { }
        --------------------------------------------------------------
    }
end

-- Variables for String Library:
local format = string.format
local gsub = string.gsub

-- Variables for Math Library:
local floor = math.floor

-- Game Variables:
local gamestarted
local countdown, init_countdown, print_nep

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_VEHICLE_EXIT'], "OnVehicleExit")

    register_callback(cb['EVENT_DIE'], 'OnPlayerKill')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    
    if (get_var(0, '$gt') ~= "n/a") then
        
        game:init()
        
        for i = 1, 16 do
            if player_present(i) then
                game:StartCheck(i)
            end
        end
    end
end

function OnScriptUnload()
    --
end

function OnTick()

    local set = game.settings
    local players = set.players
    local player_count = game:GetPlayerCount()
    local countdown_begun = (init_countdown == true)

    -- # Continuous message emitted when there aren't enough players to start the game:
    if (print_nep) and (not gamestarted) and (player_count < set.required_players) then
        local msg = gsub(gsub(set.not_enough_players, "%%current%%", player_count), "%%required%%", set.required_players)
        game:rprintAll(msg)
    elseif (countdown_begun) and (not gamestarted) and (set.pregame) then
        game:rprintAll(set.pregame)
    end
    
    if (gamestarted) then
    
    
        for _, player in pairs(players) do
            if (player and player.id) then
                if player_alive(player.id) then
                
                    local req_kills = game:GetKillThreshold(player.id)  
                    local current_weapon = game:GetNextWeapon(player.id, "current")
                    local next_weapon = game:GetNextWeapon(player.id, "next")
                    
                    local msg = gsub(gsub(gsub(gsub(gsub(gsub(set.current_level, 
                    "%%level%%", player.level),
                    "%%weapon%%", current_weapon),
                    "%%next_level%%", function()
                        if (player.level == #set.levels) then
                            return "NONE"
                        else
                            return player.level + 1
                        end
                    end),
                    
                    "%%next_weapon%%", next_weapon),
                    "%%cur_kills%%", player.kills),
                    "%%req_kills%%", req_kills)

                    game:cls(player.id, 25)
                    rprint(player.id, msg)
                    
                    local player_object = get_dynamic_player(player.id)
                    if (player_object ~= 0 and player.assign) then
                        
                        local coords = game:getXYZ(player.id, player_object)
                        if (not coords.invehicle) then
                            player.assign = false
                            execute_command("wdel " .. player.id)
                            assign_weapon(spawn_object("weap", player.weapon, coords.x, coords.y, coords.z), player.id)
                        end
                    end
                end
            end
        end
    elseif (countdown_begun) then
        countdown = countdown + 0.03333333333333333

        local delta_time = ((set.delay) - (countdown))
        local minutes, seconds = select(1, game:secondsToTime(delta_time)), select(2, game:secondsToTime(delta_time))

        set.pregame = set.pregame or ""
        set.pregame = gsub(gsub(set.pre_game_message, "%%minutes%%", minutes), "%%seconds%%", seconds)

        if (tonumber(minutes) <= 0) and (tonumber(seconds) <= 0) then

            gamestarted = true
            game:StopTimer()

            for i = 1, 16 do
                if player_present(i) then
                    game:InitPlayer(i)
                end
            end
            
            -- # Disable Vehicles:
            execute_command("disable_all_vehicles 0 1")
            
            -- # Disable Weapon Pick Ups
            execute_command("disable_object 'weapons\\assault rifle\\assault rifle'")
            execute_command("disable_object 'weapons\\flamethrower\\flamethrower'")
            execute_command("disable_object 'weapons\\needler\\mp_needler'")
            execute_command("disable_object 'weapons\\pistol\\pistol'")
            execute_command("disable_object 'weapons\\plasma pistol\\plasma pistol'")
            execute_command("disable_object 'weapons\\plasma rifle\\plasma rifle'")
            execute_command("disable_object 'weapons\\plasma_cannon\\plasma_cannon'")
            execute_command("disable_object 'weapons\\rocket launcher\\rocket launcher'")
            execute_command("disable_object 'weapons\\shotgun\\shotgun'")
            execute_command("disable_object 'weapons\\sniper rifle\\sniper rifle'")
            
            -- # Disable Grenade Pick Ups
            execute_command("disable_object 'weapons\\frag grenade\\frag grenade'")
            execute_command("disable_object 'weapons\\plasma grenade\\plasma grenade'")
            
            local scorelimit = game:GetScoreLimit()
            execute_command("scorelimit " .. scorelimit)
            
            if (#players > 0) then

                -- Remove default death messages (temporarily)
                local kma = sig_scan("8B42348A8C28D500000084C9") + 3
                local original = read_dword(kma)
                safe_write(true)
                write_dword(kma, 0x03EB01B1)
                safe_write(false)

                execute_command("sv_map_reset")

                -- Re enables default death messages
                safe_write(true)
                write_dword(kma, original)
                safe_write(false)
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, '$gt') ~= "n/a") then
        game:init()
    end
end

function OnGameEnd()
    game:StopTimer()
    gamestarted = false
end

function game:StartCheck(p)

    local set = game.settings
    local player_count = game:GetPlayerCount()
    local required = set.required_players

    -- Game hasn't started yet and there ARE enough players to init the pre-game countdown.
    -- Start the timer:
    if (player_count >= required) and (not init_countdown) and (not gamestarted) then
        game:StartTimer()
    
    elseif (player_count >= required) and (print_nep) then
        print_nep = false
    
    -- Not enough players to start the game. Set the "not enough players (print_nep)" flag to true.
    -- This will invoke a continuous message that is broadcast server wide 
    elseif (player_count > 0 and player_count < required) then
        print_nep = true
        
    -- Init table values for this player:
    elseif (gamestarted) then
        game:InitPlayer(p)
    end
end

function OnPlayerConnect(p)
    game:StartCheck(p)
end

function OnPlayerDisconnect(PlayerIndex)

    local p = tonumber(PlayerIndex)

    local set = game.settings
    local player_count = game:GetPlayerCount()
    player_count = player_count - 1

    if (gamestarted) then

        local players = set.players

        for index, player in pairs(players) do
            if (player.id == p) then
                players[index] = nil
            end
        end
        
        if (player_count <= 0) then
            -- Ensure all timer parameters are set to their default values.
            game:StopTimer()

            -- One player remains | ends the game.
        elseif (player_count == 1) then
            game:broadcast("You win!", true)
        end

        -- Pre-Game countdown was initiated but someone left before the game began.
        -- Stop the timer, reset the countdown and display the continuous
        -- message emitted when there aren't enough players to start the game.
    elseif (not gamestarted) and (init_countdown and player_count < set.required_players) then
        print_nep = true
        countdown, init_countdown = 0, false
    end
end

function OnPlayerKill(PlayerIndex, KillerIndex)
    if (gamestarted) then

        local killer = tonumber(KillerIndex)
        local victim = tonumber(PlayerIndex)

        if (killer > 0) then
        
            local params = { }
            
            if (killer ~= victim) then
                
                local set = game.settings
                local players = set.players

                -- MELEE | LEVEL DOWN (victim)
                for _,player in pairs(players) do
                    if (player.id == killer) then
                        player.kills = player.kills + 1
                    
                        if (player.damage_applied ~= nil) then
                            local multipliers = set.damage_multipliers
                            for Tab,v in pairs(multipliers) do
                                if (Tab == "melee") then
                                    for _,Tag in pairs(multipliers[Tab]) do
                                        if (player.damage_applied == GetTag("jpt!", Tag[1])) then
                                            params.melee = true
                                            params.killer = player.name
                                            game:resetScore(victim)
                                            game:CycleLevel(victim, params)
                                            player.damage_applied = nil                        
                                        end
                                    end
                                end
                            end
                        end
                        
                        local kill_threshold = game:GetKillThreshold(player.id)
                        
                        -- PvP | LEVEL UP (killer)
                        if (player.kills >= kill_threshold) then
                            params.levelup = true
                            game:CycleLevel(player.id, params)
                        end
                    end
                end
            else
            
                -- SUICIDE | LEVEL DOWN (victim)
                params.suicide = true
                game:CycleLevel(killer, params)
                game:resetScore(killer)
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex and gamestarted) then
        local players = game.settings.players
        players[CauserIndex].damage_applied = MetaID
        
        local set = game.settings
        local multipliers = set.damage_multipliers
        for Tab,v in pairs(multipliers) do
            if (Tab) then
                for _,Tag in pairs(multipliers[Tab]) do
                    if (MetaID == GetTag("jpt!", Tag[1])) then
                        return true, Damage * Tag[2]
                    end
                end
            end
        end
    end
end

function OnPlayerSpawn(PlayerIndex)
    if (gamestarted) then
        for _,player in pairs(game.settings.players) do
            if (player.id == PlayerIndex) then
                player.kills = 0                        
                player.damage_applied = nil
                game:resetScore(player.id)
            end
        end
    end
end

function game:resetScore(PlayerIndex)
    execute_command("score " .. PlayerIndex .. " 0")
    execute_command("kills " .. PlayerIndex .. " 0")
    execute_command("assists " .. PlayerIndex .. " 0")
end

function game:killPlayer(PlayerIndex)
    local player = get_player(PlayerIndex)
    if (player ~= 0) then
        local PlayerObject = read_dword(player + 0x34)
        if (PlayerObject ~= nil) then
            destroy_object(PlayerObject)
        end
    end
end

function game:broadcast(message, endgame, exclude, player)

    execute_command("msg_prefix \"\"")
    if (not exclude) then
        say_all(message)
    else
        for i = 1,16 do
            if player_present(i) then
                if (i ~= player) then
                    say(i, message)
                end
            end
        end
    end
    execute_command("msg_prefix \" " .. game.settings.server_prefix .. "\"")
        
    if (endgame) then
        execute_command("sv_map_next")
    end
end

function game:secondsToTime(seconds, bool)
    local seconds = tonumber(seconds)
    if (seconds <= 0) and (bool) then
        return "00", "00";
    else
        local hours, mins, secs = format("%02.f", floor(seconds / 3600));
        mins = format("%02.f", floor(seconds / 60 - (hours * 60)));
        secs = format("%02.f", floor(seconds - hours * 3600 - mins * 60));
        return mins, secs
    end
end

function game:StartTimer()
    countdown, init_countdown = 0, true
end

function game:StopTimer()
    countdown, init_countdown = 0, false
    print_nep = false

    for i = 1, 16 do
        if player_present(i) then
            game:cls(i, 25)
        end
    end
end

function game:rprintAll(msg)
    for i = 1, 16 do
        if player_present(i) then
            game:cls(i, 25)
            rprint(i, msg)
        end
    end
end

function game:cls(PlayerIndex, count)
    local count = count or 25
    for _ = 1, count do
        rprint(PlayerIndex, " ")
    end
end

function game:GetWeapon(PlayerIndex, VehicleLevel, CurrentWeapon)
    if (PlayerIndex) then
        local levels = game.settings.levels
        local current_level = game:GetLevel(PlayerIndex)
        for level,weapon in pairs(levels) do
            if (level == current_level) then
                if (not VehicleLevel) then
                    return weapon[1]
                else
                    return weapon[2]
                end
            end
        end
    end
end

function game:GetVehicle(PlayerIndex)
    if (PlayerIndex) then
        local levels = game.settings.levels
        local current_level = game:GetLevel(PlayerIndex)
        for level,vehicle in pairs(levels) do
            if (level == current_level) then
                return vehicle[1]
            end
        end
    end
end

function game:GetLevel(PlayerIndex)
    local set = game.settings
    local players = set.players
    return(tonumber(players[PlayerIndex].level))
end

function game:GetKillThreshold(PlayerIndex)
    if (PlayerIndex) then
        local levels = game.settings.levels
        local current_level = game:GetLevel(PlayerIndex)
        for level,kills in pairs(levels) do
            if (level < 7 and level == current_level) then
                return tonumber(kills[3])
            elseif (level > 6 and level == current_level) then
                return tonumber(kills[4])
            end
        end
    end
end

function game:GetNextWeapon(PlayerIndex, Type)
    if (PlayerIndex) then
        local levels = game.settings.levels
        local current_level = game:GetLevel(PlayerIndex)
        
        local table
        
        if (Type == "next") then
            table = levels[current_level + 1]
        elseif (Type == "current") then
            table = levels[current_level]
        end
        
        if (current_level < #levels) then
            if (current_level < 7) then
                return table[2]
            elseif (current_level > 6) then
                return table[3]
            end
        else
            return "NONE"
        end
    end
end

function game:InitPlayer(PlayerIndex)
    if (PlayerIndex) then
    
        local set = game.settings
        local starting_level = set.levels.start
        
        local players = set.players
        players[#players + 1] = {
            name = get_var(tonumber(PlayerIndex), "$name"),
            id = tonumber(PlayerIndex),
            level = starting_level,
            assign = true,
            kills = 0,
            damage_applied = nil
        }
        players[PlayerIndex].weapon = game:GetWeapon(PlayerIndex)
        players[PlayerIndex].vehicle = game:GetVehicle(PlayerIndex)
    end
end

function game:CycleLevel(PlayerIndex, State)

    local set = game.settings
    local players = set.players
    
    for _,player in pairs(players) do
        if (player.id == PlayerIndex) then
                      
            if (State.levelup) then
                player.level = player.level + 1
            else
                player.level = player.level - 1
            end
            
            if (player.level <= 0) then
                player.level = set.levels.start
            end
            
            local max = #game.settings.levels
            if (player.level <= max) then
            
            
                if (player.level <= 6) then
                    player.weapon = game:GetWeapon(PlayerIndex)
                    player.assign = true
                else
                    
                    player.weapon = game:GetWeapon(PlayerIndex, true)
                    player.vehicle = game:GetVehicle(PlayerIndex)
                    
                    local player_object = get_dynamic_player(player.id)
                    local x, y, z = read_vector3d(player_object + 0x5c)
                    local Vehicle = spawn_object("vehi", player.vehicle, x, y, z + 0.5)
                    enter_vehicle(Vehicle, player.id, 0)
                end
            
                if (State.levelup) then
                    local msg = gsub(gsub(set.on_levelup, "%%name%%", player.name), "%%level%%", player.level)
                    game:broadcast(msg, false)
                elseif (State.suicide) then
                    local msg = gsub(gsub(set.on_suicide, "%%name%%", player.name), "%%level%%", player.level)
                    game:broadcast(msg, false)
                elseif (State.melee) then
                    local msg = gsub(gsub(gsub(set.on_melee, "%%name%%", player.name), "%%level%%", player.level), "%%killer%%", State.killer)
                    game:broadcast(msg, false, false, player.id)
                end
                
            elseif (player.level > max) then
                -- game over
                execute_command("sv_map_next")
            end
        end
    end
end

function game:GetPlayerCount()
    return tonumber(get_var(0, "$pn"))
end

function game:GetScoreLimit()
    return (game.settings.levels[#game.settings.levels][4])
end

function game:getXYZ(PlayerIndex, PlayerObject)
    local coords, x,y,z = { }
    
    local VehicleID = read_dword(PlayerObject + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        coords.invehicle = false
        x, y, z = read_vector3d(PlayerObject + 0x5c)
    else
        coords.invehicle = true
        x, y, z  = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end
    
    coords.x, coords.y, coords.z = x, y, z + 1
    return coords
end

function OnVehicleExit(PlayerIndex)
    local players = game.settings.players
    local current_level = game:GetLevel(PlayerIndex)

    for _,player in pairs(players) do
        if (player.id == PlayerIndex) then
            if (current_level > 6) then
                player.assign = true
            end
        end
    end
end 

-- Credits to Kavawuvi (002) for this function:
function GetTag(tagclass, tagname)
    local tagarray = read_dword(0x40440000)
    for i = 0, read_word(0x4044000C) - 1 do
        local tag = tagarray + i * 0x20
        local class = string.reverse(string.sub(read_string(tag), 1, 4))
        if (class == tagclass) then
            if (read_string(read_dword(tag + 0x10)) == tagname) then
                return read_dword(tag + 0xC)
            end
        end
    end
    return nil
end

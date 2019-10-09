--[[
--=====================================================================================================--
Script Name: Level Up (v1.2), for SAPP (PC & CE)
Description: Level up is a progression based game

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
        pre_game_message = "Game will begin in %minutes%:%seconds%",

        -- # This message is broadcast when the game begins:
        on_game_begin = "The game has begun!",

        current_level = "|lLevel: %level% (%weapon%) |rNext Level: %next_level% (%next_weapon% - Kills: %cur_kills%/%req_kills%)",
        on_levelup = "(+) %name% is now Level %level%",
        on_suicide = "(-) %name% committed suicide and is now Level %level%",
        on_melee = "(-) %name% was melee'd by %killer% and is now Level %level%",

        levels = {
            -- Starting Level:
            start = 1,
            [1] = {
                weapon = "weapons\\shotgun\\shotgun",
                vehicle = nil,
                title = "Shotgun",
                kills_required = 1, -- Number of kils required to level up
                grenades = { 6, 6 }, -- Frags|Plasmas
                ammo = { 0, 0 } -- Weapon (Primary Ammo, Secondary Ammo)
            },
            [2] = {
                weapon = "weapons\\assault rifle\\assault rifle",
                vehicle = nil,
                title = "Assault Rifle",
                kills_required = 2,
                grenades = { 2, 2 },
                ammo = { 240, 100 }
            },
            [3] = {
                weapon = "weapons\\pistol\\pistol",
                vehicle = nil,
                title = "Pistol",
                kills_required = 3,
                grenades = { 2, 1 },
                ammo = { 36, 18 }
            },
            [4] = {
                weapon = "weapons\\sniper rifle\\sniper rifle",
                vehicle = nil,
                title = "Sniper Rifle",
                kills_required = 4,
                grenades = { 3, 2 },
                ammo = { 24, 12 }
            },
            [5] = {
                weapon = "weapons\\rocket launcher\\rocket launcher",
                vehicle = nil,
                title = "Rocket Launcher",
                kills_required = 5,
                grenades = { 1, 1 },
                ammo = { 12, 6 }
            },
            [6] = {
                weapon = "weapons\\plasma_cannon\\plasma_cannon",
                vehicle = nil,
                title = "Fuel Rod",
                kills_required = 6,
                grenades = { 3, 1 },
                ammo = { 100, 0 }
            },

            [7] = {
                vehicle = "vehicles\\ghost\\ghost_mp",
                weapon = "weapons\\shotgun\\shotgun",
                title = "Ghost",
                kills_required = 7,
                grenades = { 0, 0 },
                ammo = { 0, 0 }
            },
            [8] = {
                vehicle = "vehicles\\rwarthog\\rwarthog",
                weapon = "weapons\\shotgun\\shotgun",
                title = "Rocket Hog",
                kills_required = 8,
                grenades = { 0, 0 },
                ammo = { 0, 0 },
            },
            [9] = {
                vehicle = "vehicles\\scorpion\\scorpion_mp",
                weapon = "weapons\\shotgun\\shotgun",
                title = "Tank",
                kills_required = 9,
                grenades = { 0, 0 },
                ammo = { 0, 0 },
            },
            [10] = {
                vehicle = "vehicles\\banshee\\banshee_mp",
                weapon = "weapons\\shotgun\\shotgun",
                title = "Banshee",
                kills_required = 10,
                grenades = { 0, 0 },
                ammo = { 0, 0 },
            }
        },

        -- Some functions temporarily remove the server prefix while broadcasting a message.
        -- This prefix will be restored to 'server_prefix' when the message relay is done.
        -- Enter your servers default prefix here:
        server_prefix = "** SERVER **",

        damage_multipliers = {

            melee = {
                { "weapons\\assault rifle\\melee", 4 },
                { "weapons\\ball\\melee", 4 },
                { "weapons\\flag\\melee", 4 },
                { "weapons\\flamethrower\\melee", 4 },
                { "weapons\\needler\\melee", 4 },
                { "weapons\\pistol\\melee", 1 },
                { "weapons\\plasma pistol\\melee", 4 },
                { "weapons\\plasma rifle\\melee", 3 },
                { "weapons\\rocket launcher\\melee", 1 },
                { "weapons\\shotgun\\melee", 2 },
                { "weapons\\sniper rifle\\melee", 2 },
                { "weapons\\plasma_cannon\\effects\\plasma_cannon_melee", 2 },

            },

            grenades = {
                { "weapons\\frag grenade\\explosion", 2 },
                { "weapons\\plasma grenade\\explosion", 2 },
                { "weapons\\plasma grenade\\attached", 10 },
            },

            vehicles = {
                { "vehicles\\ghost\\ghost bolt", 1.015 },
                { "vehicles\\scorpion\\bullet", 1.020 },
                { "vehicles\\warthog\\bullet", 1.025 },
                { "vehicles\\c gun turret\\mp bolt", 1.030 },
                { "vehicles\\banshee\\banshee bolt", 1.035 },
                { "vehicles\\scorpion\\shell explosion", 1.040 },
                { "vehicles\\banshee\\mp_fuel rod explosion", 1.045 },
            },

            projectiles = {
                { "weapons\\pistol\\bullet", 1.00 },
                { "weapons\\plasma rifle\\bolt", 1.50 },
                { "weapons\\shotgun\\pellet", 1.20 },
                { "weapons\\plasma pistol\\bolt", 1.50 },
                { "weapons\\needler\\explosion", 2.00 },
                { "weapons\\assault rifle\\bullet", 2.00 },
                { "weapons\\needler\\impact damage", 1.10 },
                { "weapons\\flamethrower\\explosion", 2.00 },
                { "weapons\\sniper rifle\\sniper bullet", 4.00 },
                { "weapons\\rocket launcher\\explosion", 5.00 },
                { "weapons\\needler\\detonation damage", 2.00 },
                { "weapons\\plasma rifle\\charged bolt", 3.00 },
                { "weapons\\plasma_cannon\\effects\\plasma_cannon_melee", 2.50 },
                { "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion", 2.50 },
            },

            vehicle_collision = {
                { "globals\\vehicle_collision", 10 },
            },

            fall_damage = {
                { "globals\\falling", 1 },
                { "globals\\distance", 1 },
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
    local countdown_begun = (init_countdown == true)
    local player_count = game:GetPlayerCount()

    -- # Continuous message emitted when there aren't enough players to start the game:
    if (print_nep) and (not gamestarted) and (player_count < set.required_players) then
        local msg = gsub(gsub(set.not_enough_players,
                "%%current%%", player_count),
                "%%required%%", set.required_players)
        game:rprintAll(msg)
    elseif (countdown_begun) and (not gamestarted) and (set.pregame) then
        game:rprintAll(set.pregame)
    end

    if (gamestarted) then

        for _, player in pairs(players) do
            if (player and player.id) then
                if player_alive(player.id) then

                    local msg = gsub(gsub(gsub(gsub(gsub(gsub(set.current_level,
                            "%%level%%", player.level),
                            "%%weapon%%", player.title),
                            "%%next_level%%", function()
                                if (player.level == #set.levels) then
                                    return "NONE"
                                else
                                    return player.level + 1
                                end
                            end),

                            "%%next_weapon%%", player.next_item),
                            "%%cur_kills%%", player.kills),
                            "%%req_kills%%", player.kills_required)

                    game:cls(player.id, 25)
                    rprint(player.id, msg)

                    local player_object = get_dynamic_player(player.id)
                    if (player_object ~= 0 and player.assign) then

                        local coords = game:getXYZ(player.id, player_object)
                        if (not coords.invehicle) then
                            player.assign = false
                            execute_command("wdel " .. player.id)
                            assign_weapon(spawn_object("weap", player.weapon, coords.x, coords.y, coords.z), player.id)
                            
                            -- Set player Grenades:
                            write_word(player_object + 0x31E, player.grenades[1])
                            write_word(player_object + 0x31F, player.grenades[2])
                            
                            execute_command_sequence("w8 1;ammo " .. player.id .. " " .. tonumber(player.ammo[1]))
                            execute_command_sequence("w8 1;mag " .. player.id .. " " .. tonumber(player.ammo[2]))
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
                if (player.vehicle_object ~= nil) then                    
                    destroy_object(player.vehicle_object)
                end
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

                for _, player in pairs(players) do
                    if (player.id == killer) then
                        player.kills = player.kills + 1

                        -- MELEE | LEVEL DOWN (victim)
                        if (player.damage_applied ~= nil) then
                            local multipliers = set.damage_multipliers
                            for Tab, _ in pairs(multipliers) do
                                if (Tab == "melee") then
                                    for _, Tag in pairs(multipliers[Tab]) do
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

                        -- PvP | LEVEL UP (killer)
                        if (player.kills >= player.kills_required) then
                            params.levelup = true
                            game:CycleLevel(player.id, params)
                        end
                        
                        game:DestroyVehicle(victim, false)
                    end
                end
            else

                -- SUICIDE | LEVEL DOWN (victim)
                params.suicide = true
                game:CycleLevel(killer, params)
                game:resetScore(killer)
                game:DestroyVehicle(killer, false)
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
        for Tab, _ in pairs(multipliers) do
            if (Tab) then
                for _, Tag in pairs(multipliers[Tab]) do
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
        for _, player in pairs(game.settings.players) do
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
        for i = 1, 16 do
            if player_present(i) then
                if (i ~= player) then
                    say(i, message)
                end
            end
        end
    end
    execute_command("msg_prefix \" " .. game.settings.server_prefix .. "\"")

    -- End the game if variable "GameOver" is true.
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

function game:cls(PlayerIndex, Lines)
    local Lines = Lines or 25
    for _ = 1, Lines do
        rprint(PlayerIndex, " ")
    end
end

function game:GetLevelInfo(CurrentLevel)
    local table = game.settings.levels
    for Level, Data in pairs(table) do
        if (CurrentLevel == Level) then
            return Data
        end
    end
end

function game:GetNext(CurrentLevel)

    local max = #game.settings.levels

    if (CurrentLevel < max) then
        return game:GetLevelInfo(CurrentLevel + 1)
    elseif (CurrentLevel == max) then
        return nil
    end
end

function game:InitPlayer(PlayerIndex)
    if (PlayerIndex) then

        local set = game.settings
        local StartLevel = set.levels.start
        local Level = game:GetLevelInfo(StartLevel)

        local NextItem = game:GetNext(StartLevel)
        if (NextItem ~= nil) then
            _next_ = NextItem.title
        else
            _next_ = "FINISHED"
        end

        local players = set.players
        players[#players + 1] = {
            name = get_var(tonumber(PlayerIndex), "$name"),
            id = tonumber(PlayerIndex),
            level = StartLevel,
            assign = true,
            kills = 0,
            weapon = Level.weapon,
            vehicle = Level.vehicle,
            vehicle_object = nil,
            grenades = Level.grenades,
            ammo = Level.ammo,
            title = Level.title,
            next_item = _next_,
            kills_required = Level.kills_required,
            damage_applied = nil
        }
    end
end

function game:CycleLevel(PlayerIndex, State)

    local set = game.settings
    local players = set.players

    for _, player in pairs(players) do
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

                local Level = game:GetLevelInfo(player.level)

                player.weapon = Level.weapon
                player.title = Level.title
                player.kills_required = Level.kills_required
                player.vehicle = Level.vehicle
                player.grenades = Level.grenades
                player.ammo = Level.ammo

                local NextItem = game:GetNext(player.level)
                if (NextItem ~= nil) then
                    player.next_item = NextItem.title
                else
                    player.next_item = "FINISHED"
                end

                if (player.vehicle == nil) then
                    player.assign = true
                else
                    -- Enter player into relevant vehicle:
                    local player_object = get_dynamic_player(player.id)
                    local x, y, z = read_vector3d(player_object + 0x5c)
                    local Vehicle = spawn_object("vehi", player.vehicle, x, y, z + 0.5)
                    player.vehicle_object = Vehicle
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
    local table = game.settings.levels
    return (table[#table].kills_required)
end

function game:getXYZ(PlayerIndex, PlayerObject)
    local coords, x, y, z = { }

    local VehicleID = read_dword(PlayerObject + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        coords.invehicle = false
        x, y, z = read_vector3d(PlayerObject + 0x5c)
    else
        coords.invehicle = true
        x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end

    coords.x, coords.y, coords.z = x, y, z + 1
    return coords
end

function OnVehicleExit(PlayerIndex)
    local players = game.settings.players
    for _, player in pairs(players) do
        if (player.id == PlayerIndex) then
            if (player.vehicle ~= nil) then
                player.assign = true
                game:DestroyVehicle(player.id, true)
            end
        end
    end
end

function game:DestroyVehicle(PlayerIndex, Delay)
    local players = game.settings.players
    for _, player in pairs(players) do
        if (player.id == PlayerIndex) then
            if (player.vehicle_object ~= nil) then

                if (not Delay) then
                    destroy_object(player.vehicle_object)
                else                
                    local delta_time = 1000 -- 1 second (in ms)
                    timer(delta_time * 2, "DelayDestroy", player.vehicle_object, player.id)
                end
                
                break
            end
        end
    end
end

function DelayDestroy(Object, PlayerIndex)
    if (Object) then
        destroy_object(Object)
        local players = game.settings.players
        for _,player in pairs(players) do
            if (player.id == PlayerIndex) then
                player.vehicle_object = nil
                break
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

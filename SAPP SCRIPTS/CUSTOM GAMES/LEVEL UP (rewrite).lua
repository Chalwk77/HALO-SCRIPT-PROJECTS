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
        delay = 3,

        -- # This message is the pre-game broadcast:
        pre_game_message = "Game will begin in %minutes%:%seconds%",

        -- # This message is broadcast when the game begins:
        on_game_begin = "The game has begun!",

        current_level = "|lLevel: %level% (%weapon%) |rNext Level: %next_level% (%next_weapon% - Kills: %cur_kills%/%req_kills%)",
        on_levelup = "%killer% killed %victim% and is now level %level%",
        on_suicide = "(-) %victim% committed suicide and is now Level %level%",
        on_melee = "(-) %victim% was meleed by %killer% and is now Level %level%",

        -- Custom Command (Use this command to level up/down players):
        -- Command Syntax: /levelup [player id] [level]
        command = "setlevel",
        -- Minimum permission needed to execute the custom command:
        permission = 1,
        -- Minimum permission needed to execute the custom command on others players:
        permission_extra = 4,

        levels = {
            -- Starting Level:
            start = 1,
            [1] = {
                weapon = "weapons\\shotgun\\shotgun",
                vehicle = nil,
                title = "Shotgun",
                kills_required = 1, -- Number of kills required to level up
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
        
        -- If true, this script will simulate CTF game play on Slayer game types:
        ctf_mode = true,
        
        flag = {
                
            on_capture = "%name% captured a flag!",
            on_respawn_trigger = "The flag was dropped and will respawn in %time% seconds",
            on_respawn = "The flag respawned!",
            item = "weapons\\flag\\flag",
            
            ["bloodgulch"] = {
                -- Blue Base X,Y,Z:
                { 95.687797546387, -159.44900512695, -0.10000000149012 },
                -- Red Base X,Y,Z:
                { 40.240600585938, -79.123199462891, -0.10000000149012 },
                -- Flag X,Y,Z:
                { 65.749893188477, -120.40949249268, 0.11860413849354 },
                -- Flag runner speed:
                { 1.5 }
            },
            ["deathisland"] = {
                { -26.576030731201, -6.9761986732483, 9.6631727218628 },
                { 29.843469619751, 15.971487045288, 8.2952880859375 },
                { -30.282138824463, 31.312761306763, 16.601940155029 },
                { 1.5 }
            },
            ["icefields"] = {
                { 24.85000038147, -22.110000610352, 2.1110000610352 },
                { -77.860000610352, 86.550003051758, 2.1110000610352 },
                { -26.032163619995, 32.365093231201, 9.0070295333862 },
                { 1.5 }
            },
            ["infinity"] = {
                { 0.67973816394806, -164.56719970703, 15.039022445679 },
                { -1.8581243753433, 47.779975891113, 11.791272163391 },
                { 9.6316251754761, -64.030670166016, 7.7762198448181 },
                { 1.5 }
            },
            ["sidewinder"] = {
                { -32.038200378418, -42.066699981689, -3.7000000476837 },
                { 30.351499557495, -46.108001708984, -3.7000000476837 },
                { 2.0510597229004, 55.220195770264, -2.8019363880157 },
                { 1.5 }
            },
            ["timberland"] = {
                { 17.322099685669, -52.365001678467, -17.751399993896 },
                { -16.329900741577, 52.360000610352, -17.741399765015 },
                { 1.2504668235779, -1.4873152971268, -21.264007568359 },
                { 1.5 }
            },
            ["dangercanyon"] = {
                { -12.104507446289, -3.4351840019226, -2.2419033050537 },
                { 12.007399559021, -3.4513700008392, -2.2418999671936 },
                { -0.47723594307899, 55.331966400146, 0.23940123617649 },
                { 1.5 }
            },
            ["beavercreek"] = {
                { 29.055599212646, 13.732000350952, -0.10000000149012 },
                { -0.86037802696228, 13.764800071716, -0.0099999997764826 },
                { 14.01514339447, 14.238339424133, -0.91193699836731 },
                { 1.5 }
            },
            ["boardingaction"] = {
                { 1.723109960556, 0.4781160056591, 0.60000002384186 },
                { 18.204000473022, -0.53684097528458, 0.60000002384186 },
                { 4.3749675750732, -12.832932472229, 7.2201852798462 },
                { 1.5 }
            },
            ["carousel"] = {
                { 5.6063799858093, -13.548299789429, -3.2000000476837 },
                { -5.7499198913574, 13.886699676514, -3.2000000476837 },
                { 0.033261407166719, 0.0034416019916534, -0.85620224475861 },
                { 1.5 }
            },
            ["chillout"] = {
                { 7.4876899719238, -4.49059009552, 2.5 },
                { -7.5086002349854, 9.750340461731, 0.10000000149012 },
                { 1.392117857933, 4.7001452445984, 3.108856678009 },
                { 1.5 }
            },
            ["damnation"] = {
                { 9.6933002471924, -13.340399742126, 6.8000001907349 },
                { -12.17884349823, 14.982703208923, -0.20000000298023 },
                { -2.0021493434906, -4.3015551567078, 3.3999974727631 },
                { 1.5 }
            },
            ["gephyrophobia"] = {
                { 26.884338378906, -144.71551513672, -16.049139022827 },
                { 26.727857589722, 0.16621616482735, -16.048349380493 },
                { 63.513668060303, -74.088592529297, -1.0624552965164 },
                { 1.5 }
            },
            ["hangemhigh"] = {
                { 13.047902107239, 9.0331249237061, -3.3619771003723 },
                { 32.655700683594, -16.497299194336, -1.7000000476837 },
                { 21.020147323608, -4.6323413848877, -4.2290902137756 },
                { 1.5 }
            },
            ["longest"] = {
                { -12.791899681091, -21.6422996521, -0.40000000596046 },
                { 11.034700393677, -7.5875601768494, -0.40000000596046 },
                { -0.84, -14.54, 2.41 },
                { 1.5 }
            },
            ["prisoner"] = {
                { -9.3684597015381, -4.9481601715088, 5.6999998092651 },
                { 9.3676500320435, 5.1193399429321, 5.6999998092651 },
                { 0.90271377563477, 0.088873945176601, 1.392499089241 },
                { 1.5 }
            },
            ["putput"] = {
                { -18.89049911499, -20.186100006104, 1.1000000238419 },
                { 34.865299224854, -28.194700241089, 0.10000000149012 },
                { -2.3500289916992, -21.121452331543, 0.90232092142105 },
                { 1.5 }
            },
            ["ratrace"] = {
                { -4.2277698516846, -0.85564690828323, -0.40000000596046 },
                { 18.613000869751, -22.652599334717, -3.4000000953674 },
                { 8.6629104614258, -11.159770965576, 0.2217468470335 },
                { 1.5 }
            },
            ["wizard"] = {
                { -9.2459697723389, 9.3335800170898, -2.5999999046326 },
                { 9.1828498840332, -9.1805400848389, -2.5999999046326 },
                { -5.035900592804, -5.0643291473389, -2.7504394054413 },
                { 1.5 }
            },
            
            
            ["FLAG"] = {},
        },
        --# Do Not Touch #--
        players = { },
        --------------------------------------------------------------
    }
end

-- Variables for String Library:
local format = string.format
local sub, gsub = string.sub, string.gsub
local lower, upper = string.lower, string.upper
local match = string.match

-- Variables for Math Library:
local floor = math.floor
local sqrt = math.sqrt

-- Game Variables:
local gamestarted
local countdown, init_countdown, print_nep
local delta_time = 0.03333333333333333

-- Game Tables:
local cmd_error = { }

-- ======== from Giraffe's auto-vehicle-flip script ======== --
local rider_ejection = nil
--------------------------------------------------------------

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    kill_message_addresss = sig_scan("8B42348A8C28D500000084C9") + 3
    originl_kill_message = read_dword(kill_message_addresss)
    
    if (get_var(0, '$gt') ~= "n/a") then

        game:init()
        
        if (game.settings.ctf_mode) then            
            game:SpawnFlag(true)
        end

        for i = 1, 16 do
            if player_present(i) then
                game:StartCheck(i)
            end
        end
        game:disableKillMessages()
    end
    -- ======== from Giraffe's auto-vehicle-flip script ======== --
    if(halo_type == "CE") then
        rider_ejection = read_byte(0x59A34C)
        write_byte(0x59A34C, 0)
    else
        rider_ejection = read_byte(0x6163EC)
        write_byte(0x6163EC, 0)
    end
    -- ==============================================================
end

function OnScriptUnload()
    game:enableKillMessages()
    
    -- ======== from Giraffe's auto-vehicle-flip script ======== --
    if(halo_type == "CE") then
        write_byte(0x59A34C, rider_ejection)
    else
        write_byte(0x6163EC, rider_ejection)
    end
    -- ============================================================== --
end

function game:enableKillMessages()
    safe_write(true)
    write_dword(kill_message_addresss, originl_kill_message)
    safe_write(false)
end

function game:disableKillMessages()
    safe_write(true)
    write_dword(kill_message_addresss, 0x03EB01B1)
    safe_write(false)
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

        local flag_table = game.settings.flag["FLAG"]
        for _,flag in pairs(flag_table) do
            if (flag.object) and (not flag.held) then
                if (flag.respawn_trigger) then
                    flag.timer = flag.timer + delta_time
                   
                    local time = ((flag.respawn_time) - (flag.timer))
                    local seconds = select(2, game:secondsToTime(time))
                    
                    if (tonumber(seconds) == floor(flag.respawn_time/2)) then
                        if (flag.warnbool) then
                            flag.warnbool = false                            
                            local msg = gsub(set.flag.on_respawn_trigger, "%%time%%", flag.respawn_time/2)
                            game:broadcast(msg, false)
                        end
                    elseif (tonumber(seconds) <= 0) then
                        game:broadcast(set.flag.on_respawn, false)
                        game:SpawnFlag(true)
                    end
                end
            end
        end

        for _, player in pairs(players) do
            if (player and player.id) then
                if player_alive(player.id) then
                    local player_object = get_dynamic_player(player.id)
                
                    -- ======== from Giraffe's auto-vehicle-flip script ======== --
                    local VehicleID = read_dword(player_object + 0x11C)
                    if(VehicleID ~= 0xFFFFFFFF) then
                        local vehicle = get_object_memory(VehicleID)
                        flip_vehicle(vehicle)
                    end
                    -- ============================================================== --
                
                    if (set.ctf_mode) then
                        game:MonitorFlag(player)
                    end

                    if not (player.hud_paused) then
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
                    else
                        player.hud_timer = player.hud_timer + delta_time
                        if (player.hud_timer >= player.hud_pause_duration) then
                            player.hud_timer = 0
                            player.hud_paused = false
                        end
                    end

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
        countdown = countdown + delta_time

        local delta_time = ((set.delay) - (countdown))
        local minutes, seconds = select(1, game:secondsToTime(delta_time)), select(2, game:secondsToTime(delta_time))

        set.pregame = set.pregame or ""
        set.pregame = gsub(gsub(set.pre_game_message, "%%minutes%%", minutes), "%%seconds%%", seconds)

        if (tonumber(minutes) <= 0) and (tonumber(seconds) <= 0) then

            register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
            register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
            register_callback(cb['EVENT_VEHICLE_EXIT'], "OnVehicleExit")
            register_callback(cb['EVENT_WEAPON_DROP'], "OnWeaponDrop")
            register_callback(cb['EVENT_DIE'], 'OnPlayerKill')
            register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
            register_callback(cb["EVENT_COMMAND"], "OnServerCommand")

            gamestarted = true
            game:StopTimer()
            
            if (set.ctf_mode) then            
                game:SpawnFlag(true)
            end

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

            game:disableKillMessages()
            
            if (#players > 0) then
                execute_command("sv_map_reset")
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, '$gt') ~= "n/a") then
        game:init()
        game:enableKillMessages()
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
        local set = game.settings

        if (killer > 0) then

            local params = { }
                        
            if (killer ~= victim) then
            
                params.kname = get_var(killer, "$name")
                params.vname = get_var(victim, "$name")
                
                if game:holdingFlag(killer) then
                    drop_weapon(killer)
                end
                
                for _, player in pairs(set.players) do
                    if (player.id == killer) then
                        player.kills = player.kills + 1

                        -- MELEE | LEVEL DOWN (victim)
                        if (player.damage_applied ~= nil) then
                            local multipliers = set.damage_multipliers
                            for Tab, _ in pairs(multipliers) do
                                if (Tab == "melee") then
                                    for _, Tag in pairs(multipliers[Tab]) do
                                        if (player.damage_applied == GetTag("jpt!", Tag[1])) then
                                            player.damage_applied = nil
                                            params.target, params.melee = victim, true
                                            game:resetScore(victim)
                                            game:CycleLevel(params)
                                        end
                                    end
                                end
                            end
                        end

                        -- PvP | LEVEL UP (killer)
                        if (player.kills >= player.kills_required) then
                            params.target, params.levelup = killer, true
                            game:CycleLevel(params)
                        end
                        
                        game:DestroyVehicle(victim, false)
                    end
                end
            else
                -- SUICIDE | LEVEL DOWN (victim)
                params.target, params.suicide = victim, true
                game:CycleLevel(params)
                game:resetScore(victim)
                game:DestroyVehicle(victim, false)
            end
        elseif (killer == -1) or (killer == nil) or (killer == 0) then
            execute_command("msg_prefix \"\"")
            game:broadcast(get_var(victim, "$name") .. " died", false)
            execute_command("msg_prefix \" " .. set.server_prefix .. "\"")
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex and gamestarted) then
        local players = game.settings.players
        players[CauserIndex].damage_applied = MetaID

        local multipliers = game.settings.damage_multipliers
        for Table, _ in pairs(multipliers) do
            for _, Tag in pairs(multipliers[Table]) do
                if Tag[1] then
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
            damage_applied = nil,
            
            hud_timer = 0,
            hud_paused = false,
            hud_pause_duration = 5,
        }
    end
end

function game:CycleLevel(params)

    local set = game.settings
    local players = set.players
    for _, player in pairs(players) do
        if (player.id == params.target) then
                    
            if (params.cmd) then
                player.level = tonumber(params.level)
            elseif (params.levelup) then
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
                
                player.hud_pause_duration = 5
                player.hud_timer = 0
                player.hud_paused = false

                local NextItem = game:GetNext(player.level)
                if (NextItem ~= nil) then
                    player.next_item = NextItem.title
                else
                    player.next_item = "FINISHED"
                end

                if (player.vehicle == nil) then
                    player.assign = true
                else
                    
                    local old_vehicle = player.vehicle_object
                    
                    -- Enter player into relevant vehicle:
                    local player_object = get_dynamic_player(player.id)
                    local coords = game:getXYZ(player.id, player_object)
                    
                    local Vehicle = spawn_object("vehi", player.vehicle, coords.x, coords.y, coords.z + 0.5)
                    player.vehicle_object = Vehicle
                    
                    enter_vehicle(Vehicle, player.id, 0)
                    if (player.level == 8) then
                        timer(0, "DelayGunnerSeat", player.id, Vehicle)
                    end
                    
                    if (old_vehicle) then
                        destroy_object(old_vehicle)
                    end
                end

                if (params.levelup) then
                    if (params.cmd) then
                        game:broadcast(player.name .. " now level " .. player.level, false)
                        
                    elseif (not params.flagcap) then
                        local msg = gsub(gsub(gsub(set.on_levelup, 
                        "%%killer%%", player.name), "%%victim%%", params.vname), 
                        "%%level%%", player.level)
                        game:broadcast(msg, false)
                    else
                        local msg = gsub(game.settings.flag.on_capture, "%%name%%", player.name)
                        game:broadcast(msg, false)
                    end
                elseif (params.suicide) then
                    if (player.level > 1) then
                        local msg = gsub(gsub(set.on_suicide, "%%victim%%", player.name), "%%level%%", player.level)
                        game:broadcast(msg, false)
                    else
                        game:broadcast(player.name .. " committed suicide", false)
                    end
                elseif (params.meleee) then
                    if (player.level > 1) then
                        local msg = gsub(gsub(gsub(set.on_melee, 
                        "%%victim%%", player.name), "%%killer%%", params.kname)
                        "%%level%%", player.level), 
                        game:broadcast(msg, false, false, player.id)
                    else
                        game:broadcast(player.name .. " was killed by " .. params.kname, false)
                    end
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

function game:PauseHUD(Player, Pause, time)
    local players = game.settings.players
    
    time = time or 5
        
    for _, player in pairs(players) do
        if (player.id == Player) then
            if (Pause) then
                player.hud_paused = true
                player.hud_pause_duration = time
            else
                player.hud_paused = false
            end
            player.hud_timer = 0
            break
        end
    end
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

function game:holdingFlag(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    for i = 0, 3 do
        local weapon_id = read_dword(player_object + 0x2F8 + 0x4 * i)
        if (weapon_id ~= 0xFFFFFFFF) then
            local weap_object = get_object_memory(weapon_id)
            if (weap_object ~= 0) then
                local tag_address = read_word(weap_object)
                local tagdata = read_dword(read_dword(0x40440000) + tag_address * 0x20 + 0x14)
                if (read_bit(tagdata + 0x308, 3) == 1) then
                    return true
                end
            end
        end
    end
    return false
end

function game:SpawnFlag(DestroyOldFlag)

    local set = game.settings
    local map = get_var(0, "$map")
    local flag = game.settings.flag
    local coords = flag[map]

    if (coords ~= nil) then
    
        local flag_table = flag["FLAG"]
        
        if (DestroyOldFlag) then
            for i,f in pairs(flag_table) do
                if (i) then
                    destroy_object(f.object)
                    flag_table[i] = nil
                end
            end
        end
        
        local object = spawn_object("weap", flag.item, coords[3][1], coords[3][2], coords[3][3])
        local FlagObject = get_object_memory(object)
        
        flag_table[FlagObject] = {
            held_by = nil,
            object = object,
            timer = 0,
            respawn_time = 15,
            broadcast = true,
            respawn_trigger = false,
            running_speed = coords[4][1],
            bx = coords[1][1], by = coords[1][2], bz = coords[1][3],
            rx = coords[2][1], ry = coords[2][2], rz = coords[2][3],
        }
    end
end

function game:MonitorFlag(player)
    
    local flag_table = game.settings.flag["FLAG"]
    for _,flag in pairs(flag_table) do
        
        if game:holdingFlag(player.id) then
            flag.held_by = player.id
            
            if (flag.broadcast) then
                flag.broadcast = false
                
                local msg_table = {
                    "|cReturn the flag to a base to gain a level",
                    "|c- " .. tostring(flag.running_speed) .. "x speed",
                    " ",
                    " ",
                    " ",
                }
                
                game:PauseHUD(player.id, true, 5)
                for i = 1,#msg_table do
                    rprint(player.id, msg_table[i])
                end
                game:broadcast(player.name .. " has the flag!", false, true, player.id)
            end
            
            if (flag.respawn_trigger) then
                flag.respawn_trigger = false
                flag.timer = 0
            end

            local player_object = get_dynamic_player(player.id)
            if (player_object ~= 0) then
            
                execute_command("s " .. player.id .. " " .. flag.running_speed)
                
                local coords = game:getXYZ(player.id, player_object)
                if (coords) then
                             
                    local CapReds = (game:GetDistance(coords.x, coords.y, coords.z, flag.bx, flag.by, flag.bz) <= 1.1)
                    local CapBlue = (game:GetDistance(coords.x, coords.y, coords.z, flag.rx, flag.ry, flag.rz) <= 1.1)
                    
                    if (CapReds or CapBlue) then
                        
                        flag.held_by = nil
                        
                        local params = { }
                        params.levelup, params.flagcap = true, true
                        params.target = player.id
                        
                        execute_command("s " .. player.id .. " 1")
                        
                        game:CycleLevel(params)
                        game:SpawnFlag(true)
                        break
                    end
                end
            end
        end
    end
end

function game:GetDistance(pX, pY, pZ, X, Y, Z)
    return sqrt((pX - X) ^ 2 + (pY - Y) ^ 2 + (pZ - Z) ^ 2)
end

function OnWeaponDrop(PlayerIndex)
    local set = game.settings
    if (gamestarted and set.ctf_mode) then
        local flag_table = set.flag["FLAG"]
        for _,flag in pairs(flag_table) do
            if (flag.object and flag.held_by == PlayerIndex) then
                flag.held_by, flag.timer = nil, 0
                flag.warnbool, flag.respawn_trigger = true, true
                flag.broadcast = true
                execute_command("s " .. PlayerIndex .. " 1")
                break
            end
        end
    end
end

function OnVehicleExit(Player)
    local players = game.settings.players
    for _, player in pairs(players) do
        if (player.id == Player and player.vehicle ~= nil) then
            player.assign = true
            game:DestroyVehicle(player.id, true)
            break
        end
    end
end

function game:DestroyVehicle(Player, Delay)
    local players = game.settings.players
    for _, player in pairs(players) do
        if (player.id == Player and player.vehicle_object ~= nil) then
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

function DelayDestroy(Object, PlayerIndex)
    destroy_object(Object)
    local players = game.settings.players
    for _,player in pairs(players) do
        if (player.id == PlayerIndex) then
            player.vehicle_object = nil
            break
        end
    end
end

function DelayGunnerSeat(PlayerIndex, VehicleID)
    enter_vehicle(VehicleID, PlayerIndex, 2)
end

function game:ObjectTagID(object)
    if (object ~= nil and object ~= 0) then
        return read_string(read_dword(read_word(object) * 32 + 0x40440038))
    else
        return ""
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = game:StringSplit(Command)
    local executor = tonumber(PlayerIndex)
    
    if (command == nil) then
        return
    end
    command = lower(command) or upper(command)
    
    if (command) then
        game:PauseHUD(PlayerIndex, true, 5)
    end
    
    local set = game.settings
    local cmd = set.command

    if (command == cmd) then
        if not game:isGameOver(executor) then
            if game:checkAccess(executor) then
                if (args[1] ~= nil and args[2] ~= nil) then
                
                    local params = game:ValidateCommand(executor, args)
                    
                    if (params ~= nil) and (not params.target_all) and (not params.is_error) then
                        local Target = tonumber(args[1]) or tonumber(executor)
                        if game:isOnline(Target, executor) then
                            game:ExecuteCore(params)
                        end
                    end
                else
                    local msg = gsub("Invalid Syntax: Usage: /%cmd% on|off [me | id | */all]","%%cmd%%", cmd)
                    game:Respond(PlayerIndex, msg, 4+8)
                end
            end
        end
        return false
    end
end

function game:ExecuteCore(params)
    local params = params or nil
    if (params ~= nil) then
                    
        -- Target Parameters:
        local tid = params.tid
        local eid = params.eid
        -- 
        
        local set = game.settings
        local is_console = game:isConsole(eid)
        if is_console then
            en = "SERVER"
        end

        local is_self = (eid == tid)
        local admin_level = tonumber(get_var(eid, '$lvl'))
                
        local proceed = game:executeOnOthers(eid, is_self, is_console, admin_level)
        local valid_state
        
        if (proceed) then
            
            local level = params.level
            
            if level:match('%d+') then
                local players = set.players

                for _,player in pairs(players) do
                    if (player.id == tid) then 
                        
                        if game:holdingFlag(tid) then drop_weapon(tid) end
                        
                        if (player.level == tonumber(level))then
                            if (not is_self) then
                                game:Respond(eid, get_var(tid, "$name") .. " is already level " .. level)
                            else
                                game:Respond(eid, "You are already level " .. level)
                            end
                        else
                            local p = { }
                            p.target, p.levelup, p.cmd = tid, true, true    
                            p.level = level
                            game:CycleLevel(p)
                        end
                    end
                end
                
            else
                game:Respond(eid, "Invalid Level! Please choose a number between 1-" .. #set.levels, 4+8)
            end
        end
    end
end

function game:ValidateCommand(executor, args)
    local params = { }
                
    local function getplayers(arg)
        local players = { }
        
        if (arg == nil) or (arg == 'me') then
            table.insert(players, executor)
        elseif (arg:match('%d+')) then
            table.insert(players, tonumber(arg))
        elseif (arg == '*' or arg == 'all') then
            params.target_all = true
            for i = 1, 16 do
                if player_present(i) then
                    table.insert(players, i)
                end
            end
        elseif (arg == 'rand' or arg == 'random') then
            local temp = { }
            for i = 1,16 do
                if player_present(i) then
                    temp[#temp + 1] = i
                end
            end
            table.insert(players, temp[math.random(#temp)])
        else
            game:Respond(executor, "Invalid player id. Usage: [number: 1-16] | */all | me", 4 + 8)
            params.is_error = true
            return false
        end

        for i = 1, #players do
            if (executor ~= tonumber(players[i])) then
                cmd_error[executor] = true
            end
        end
        
        if players[1] then return players end
        return false
    end
    
    local pl = getplayers(args[1])
    if (pl) then
        for i = 1, #pl do
        
            if (pl[i] == nil) then
                break
            end

            params.level = args[2]
            params.eid, params.tid = executor, tonumber(pl[i])

            if (params.target_all) then
                game:ExecuteCore(params)
            end
        end
    end
    return params
end

function game:isOnline(target, executor)
    if (target > 0 and target < 17) then
        if player_present(target) then
            return true
        else
            game:Respond(executor, "Command Failed. Player not online!", 4 + 8)
            return false
        end
    else
        game:Respond(executor, "Invalid Player ID. Please enter a number between 1-16", 4 + 8)
    end
end

function game:isAdmin(p)
    local set = game.settings
    if (tonumber(get_var(p, "$lvl"))) >= set.permission then
        return true
    end
end

function game:checkAccess(p)
    if not game:isConsole(p) then
        if game:isAdmin(p) then
            return true
        else
            game:Respond(p, "Command Failed. Insufficient permission!", 4 + 8)
            return true
        end
    else
        return true
    end
    return false
end

function game:executeOnOthers(e, self, is_console, level)
    local set = game.settings
    if (not self) and (not is_console) then
        if tonumber(level) >= set.permission_extra then
            return true
        elseif (cmd_error[e]) then
            cmd_error[e] = nil
            game:Respond(e, "You are not allowed to execute this command on other players.", 4 + 8)
            return false
        end
    else
        return true
    end
end

function game:isConsole(e)
    if (e) then
        if (e ~= -1 and e >= 1 and e < 16) then
            return false
        else
            return true
        end
    end
end

function game:isGameOver(p)
    if (not gamestarted) then
        game:Respond(p, "Please wait until the next game has started.", 4+8)
        return true
    end
end

function game:Respond(p, msg, color)
    local color = color or 4 + 8
    if not game:isConsole(p) then
        rprint(p, msg)
    else
        cprint(msg, color)
    end
end

function game:StringSplit(str, bool)
    local subs = {}
    local sub = ""
    local ignore_quote, inquote, endquote
    for i = 1, string.len(str) do
        local bool
        local char = string.sub(str, i, i)
        if char == " " then
            if (inquote and endquote) or (not inquote and not endquote) then
                bool = true
            end
        elseif char == "\\" then
            ignore_quote = true
        elseif char == "\"" then
            if not ignore_quote then
                if not inquote then
                    inquote = true
                else
                    endquote = true
                end
            end
        end

        if char ~= "\\" then
            ignore_quote = false
        end

        if bool then
            if inquote and endquote then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end

            if sub ~= "" then
                table.insert(subs, sub)
            end
            sub = ""
            inquote = false
            endquote = false
        else
            sub = sub .. char
        end

        if i == string.len(str) then
            if string.sub(sub, 1, 1) == "\"" and string.sub(sub, string.len(sub), string.len(sub)) == "\"" then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end
            table.insert(subs, sub)
        end
    end

    local cmd, args = subs[1], subs
    table.remove(args, 1)

    return cmd, args
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

-- ======== from Giraffe's auto-vehicle-flip script ======== --
function flip_vehicle(Object)
    if(read_bit(Object + 0x8B, 7) == 1) then
        if(read_bit(Object + 0x10, 1) == 0) then
            return
        end
        write_vector3d(Object + 0x80, 0, 0, 1)
    end
end
-- ============================================================== --

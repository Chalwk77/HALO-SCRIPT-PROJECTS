--[[
--=====================================================================================================--
Script Name: Base Game Settings, for SAPP (PC & CE)
Description: An all-in-one package that combines many of my scripts into one place. 
             
             Nearly every aspect of the combined scripts have been heavily refined and improved in this version, 
             with the addition of many new features not found in the standalone versions. This mod is heavy on said features and highly customizable, but also user friendly. 
             I am aiming to start documenting soon (with Lua Comments) so people know what certain configuration options do (coming in a later update).

             [!] IN DEVELOPMENT. 98% COMPLETE.
             
Combined Scripts:
    - Admin Chat            Chat IDs            Message Board
    - Chat Logging          Command Spy         Custom Weapons
    - Anti Impersonator     Console Logo        List Players
    - Alias System          Respawn Time        Teleport Manager
    - Get Coords            Spawn From Sky      Admin Join Messages
    - Color Reservation
             
             
    BGS Commands:
    /plugins
    /enable [id]
    /disable [id]
    /mute [id] <time dif>
    /unmute [id]

    "/plugins" shows you a list of all mods and tells you which ones are enabled/disabled.
    You can enable or disable any mod in game at any time with /enable [id], /disable [id].
    
    This script requires this plugin to check for updates: https://opencarnage.net/index.php?/topic/5998-sapp-http-client/
    Credits to Kavawuvi (002) for HTTP client functionality.
             
Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local function GameSettings()
    -- CONFIGURAITON [begins] >> ------------------------------------------------------------
    settings = {
        mod = {
            ["Admin Chat"] = {
                enabled = true,
                base_command = "achat",
                permission_level = 1,
                prefix = "[ADMIN CHAT]",
                restore_previous_state = true,
                environment = "rcon",
                message_format = { "%prefix% %sender_name% [%index%] %message%" }
            },
            ["Chat IDs"] = {
                enabled = true,
                global_format = { "%sender_name% [%index%]: %message%" },
                team_format = { "[%sender_name%] [%index%]: %message%" },
                use_admin_prefixes = true,
                trial_moderator = {
                    "[T-MOD] %sender_name% [%index%]: %message%", -- global 
                    "[T-MOD] [%sender_name%] [%index%]: %message%" -- team
                },
                moderator = {
                    "[MOD] %sender_name% [%index%]: %message%", -- global 
                    "[MOD] [%sender_name%] [%index%]: %message%" -- team 
                },
                admin = {
                    "[ADMIN] %sender_name% [%index%]: %message%", -- global 
                    "[ADMIN] [%sender_name%] [%index%]: %message%" -- team 
                },
                senior_admin = {
                    "[S-ADMIN] %sender_name% [%index%]: %message%", -- global 
                    "[S-ADMIN] [%sender_name%] [%index%]: %message%" -- team 
                },
                ignore_list = {
                    "skip",
                    "rtv"
                }
            },
            ["Admin Join Messages"] = {
                enabled = true,
                messages = {
                    -- [prefix] [message] (note: player name is automatically inserted between [prefix] and [message])
                    [1] = { "[TRIAL-MOD] ", " joined the server. Everybody hide!" },
                    [2] = { "[MODERATOR] ", " just showed up. Hold my beer!" },
                    [3] = { "[ADMIN] ", " just joined. Hide your bananas!" },
                    [4] = { "[SENIOR-ADMIN] ", " joined the server." }
                }
            },
            ["Message Board"] = {
                enabled = false,
                duration = 100, -- How long should the message be displayed on screen for? (in seconds)
                alignment = "l", -- Left = l, Right = r, Center = c, Tab: t
                messages = {
                    "Welcome to $SERVER_NAME",
                    "Bug reports and suggestions:",
                    "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS",
                    "This is a development & test server only!"
                }
            },
            ["Color Reservation"] = {
                enabled = false,
                color_table = {
                    [1] = { "6c8f0bc306e0108b4904812110185edd" }, -- white
                    [2] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- black
                    [3] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- red
                    [4] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- blue
                    [5] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- gray
                    [6] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- yellow
                    [7] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- green
                    [8] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- pink
                    [9] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- purple
                    [10] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- cyan
                    [11] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- cobalt
                    [12] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- orange
                    [13] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- teal
                    [14] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- sage
                    [15] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- brown
                    [16] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- tan
                    [17] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- maroon
                    [18] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }    -- salmon
                }
            },
            -- Logs chat, commands and quit-join events.
            ["Chat Logging"] = {
                enabled = true,
                dir = "sapp\\Server Chat.txt"
            },
            ["Command Spy"] = {
                enabled = true,
                permission_level = 1,
                prefix = "[SPY]",
                hide_commands = false,
                commands_to_hide = {
                    "/afk",
                    "/lead",
                    "/stfu",
                    "/unstfu",
                    "/skip"
                }
            },
            ["Custom Weapons"] = {
                enabled = false,
                assign_weapons = true,
                assign_custom_frags = true,
                assign_custom_plasmas = true,
                weapons = {
                    -- Weap 1,Weap 2,Weap 3,Weap 4, frags, plasmas
                    ["beavercreek"] = { sniper, pistol, rocket_launcher, shotgun, 4, 2 },
                    ["bloodgulch"] = { sniper, pistol, nil, nil, 2, 2 },
                    ["boardingaction"] = { plasma_cannon, rocket_launcher, flamethrower, nil, 1, 3 },
                    ["carousel"] = { nil, nil, pistol, needler, 3, 3 },
                    ["dangercanyon"] = { nil, plasma_rifle, nil, pistol, 4, 4 },
                    ["deathisland"] = { assault_rifle, nil, plasma_cannon, sniper, 1, 1 },
                    ["gephyrophobia"] = { nil, nil, nil, shotgun, 3, 3 },
                    ["icefields"] = { plasma_rifle, nil, plasma_rifle, nil, 2, 3 },
                    ["infinity"] = { assault_rifle, nil, nil, nil, 2, 4 },
                    ["sidewinder"] = { nil, rocket_launcher, nil, assault_rifle, 3, 2 },
                    ["timberland"] = { nil, nil, nil, pistol, 2, 4 },
                    ["hangemhigh"] = { flamethrower, nil, flamethrower, nil, 3, 3 },
                    ["ratrace"] = { nil, nil, nil, nil, 3, 2 },
                    ["damnation"] = { plasma_rifle, nil, nil, plasma_rifle, 1, 3 },
                    ["putput"] = { nil, rocket_launcher, assault_rifle, pistol, 4, 1 },
                    ["prisoner"] = { nil, nil, pistol, plasma_rifle, 2, 1 },
                    ["wizard"] = { rocket_launcher, nil, shotgun, nil, 1, 2 }

                }
            },
            ["Anti Impersonator"] = {
                enabled = true,
                action = "kick", -- Valid actions, "kick", "ban"
                reason = "impersonating",
                bantime = 10, -- (In Minutes) -- Set to zero to ban permanently
                namelist = { -- Make sure these names match exactly as they do in game.
                    "Chalwk",
                    "Ro@dhog",
                    "member4",
                    "member5" -- Make sure the last entry in the table doesn't have a comma
                },
                hashlist = { -- You can retrieve the players hash by looking it up in the sapp.log file or Server Chat.txt
                    "6c8f0bc306e0108b4904812110185edd", -- Chalwk's hash
                    "0ca756f62f9ecb677dc94238dcbc6c75", -- Ro@dhog's hash
                    "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                    "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
                }
            },
            ["Console Logo"] = {
                enabled = true
            },
            -- An alternative player list mod. Overrides SAPP's built in /pl command.
            ["List Players"] = {
                enabled = true,
                permission_level = 1,
                alignment = "l", -- Left = l, Right = r, Center = c, Tab: t
                command_aliases = {
                    "pl",
                    "players",
                    "playerlist",
                    "playerslist"
                }
            },
            -- Query a player's hash to check what aliases have been used with it.
            ["Alias System"] = {
                enabled = true,
                base_command = "alias",
                dir = "sapp\\alias.lua",
                permission_level = 1, -- minimum admin level required to use /alias command
                alignment = "l", -- Left = l, Right = r, Center = c, Tab: t
                duration = 10 -- How long should the alias results be displayed for? (in seconds)
            },
            ["Respawn Time"] = {
                enabled = false,
                maps = {
                    -- CTF, SLAYER, TEAM-S, KOTH, TEAM-KOTH, ODDBALL, TEAM-ODDBALL, RACE, TEAM-RACE
                    ["beavercreek"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["bloodgulch"] = { 0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["boardingaction"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["carousel"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["dangercanyon"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["deathisland"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["gephyrophobia"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["icefields"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["infinity"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["sidewinder"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["timberland"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["hangemhigh"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["ratrace"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["damnation"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["putput"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["prisoner"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["wizard"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["longest"] = { 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 }
                }
            },
            ["Teleport Manager"] = {
                enabled = false,
                dir = "sapp\\teleports.txt",
                permission_level = {
                    setwarp = 1,
                    warp = -1,
                    back = -1,
                    warplist = -1,
                    warplistall = -1,
                    delwarp = 1
                },
                commands = {
                    "setwarp", -- set command
                    "warp", -- go to command
                    "back", -- go back command
                    "warplist", --list command
                    "warplistall", -- list all command
                    "delwarp" -- delete command
                }
            },
            ["Get Coords"] = {
                enabled = false,
                base_command = "coords",
                permission_level = 1,
                environment = "console"
            },
            ["Spawn From Sky"] = {
                enabled = false,
                maps = {
                    ["bloodgulch"] = {
                        height = 35,
                        invulnerability = 9,
                        { 95.687797546387, -159.44900512695, -0.10000000149012 },
                        { 40.240600585938, -79.123199462891, -0.10000000149012 }
                    },
                    ["deathisland"] = {
                        height = 35,
                        invulnerability = 9,
                        { -26.576030731201, -6.9761986732483, 9.6631727218628 },
                        { 29.843469619751, 15.971487045288, 8.2952880859375 }
                    },
                    ["icefields"] = {
                        height = 35,
                        invulnerability = 9,
                        { 24.85000038147, -22.110000610352, 2.1110000610352 },
                        { -77.860000610352, 86.550003051758, 2.1110000610352 }
                    },
                    ["infinity"] = {
                        height = 35,
                        invulnerability = 9,
                        { 0.67973816394806, -164.56719970703, 15.039022445679 },
                        { -1.8581243753433, 47.779975891113, 11.791272163391 }
                    },
                    ["sidewinder"] = {
                        height = 35,
                        invulnerability = 9,
                        { -32.038200378418, -42.066699981689, -3.7000000476837 },
                        { 30.351499557495, -46.108001708984, -3.7000000476837 }
                    },
                    ["timberland"] = {
                        height = 25,
                        invulnerability = 5,
                        { 17.322099685669, -52.365001678467, -17.751399993896 },
                        { -16.329900741577, 52.360000610352, -17.741399765015 }
                    },
                    ["dangercanyon"] = {
                        height = 25,
                        invulnerability = 5,
                        { -12.104507446289, -3.4351840019226, -2.2419033050537 },
                        { 12.007399559021, -3.4513700008392, -2.2418999671936 }
                    },
                    ["beavercreek"] = {
                        height = 25,
                        invulnerability = 5,
                        { 29.055599212646, 13.732000350952, -0.10000000149012 },
                        { -0.86037802696228, 13.764800071716, -0.0099999997764826 }
                    },
                    ["boardingaction"] = {
                        height = 4,
                        invulnerability = 3,
                        { 1.723109960556, 0.4781160056591, 0.60000002384186 },
                        { 18.204000473022, -0.53684097528458, 0.60000002384186 }
                    },
                    ["carousel"] = {
                        height = 3,
                        invulnerability = 2,
                        { 5.6063799858093, -13.548299789429, -3.2000000476837 },
                        { -5.7499198913574, 13.886699676514, -3.2000000476837 }
                    },
                    ["chillout"] = {
                        height = 2,
                        invulnerability = 1,
                        { 7.4876899719238, -4.49059009552, 2.5 },
                        { -7.5086002349854, 9.750340461731, 0.10000000149012 }
                    },
                    ["damnation"] = {
                        height = 3,
                        invulnerability = 2,
                        { 9.6933002471924, -13.340399742126, 6.8000001907349 },
                        { -12.17884349823, 14.982703208923, -0.20000000298023 }
                    },
                    ["gephyrophobia"] = {
                        height = 5,
                        invulnerability = 4,
                        { 26.884338378906, -144.71551513672, -16.049139022827 },
                        { 26.727857589722, 0.16621616482735, -16.048349380493 }
                    },
                    ["hangemhigh"] = {
                        height = 5,
                        invulnerability = 4,
                        { 13.047902107239, 9.0331249237061, -3.3619771003723 },
                        { 32.655700683594, -16.497299194336, -1.7000000476837 }
                    },
                    ["longest"] = {
                        height = 2,
                        invulnerability = 1,
                        { -12.791899681091, -21.6422996521, -0.40000000596046 },
                        { 11.034700393677, -7.5875601768494, -0.40000000596046 }
                    },
                    ["prisoner"] = {
                        height = 2,
                        invulnerability = 1,
                        { -9.3684597015381, -4.9481601715088, 5.6999998092651 },
                        { 9.3676500320435, 5.1193399429321, 5.6999998092651 }
                    },
                    ["putput"] = {
                        height = 3,
                        invulnerability = 2,
                        { -18.89049911499, -20.186100006104, 1.1000000238419 },
                        { 34.865299224854, -28.194700241089, 0.10000000149012 }
                    },
                    ["ratrace"] = {
                        height = 3,
                        invulnerability = 2,
                        { -4.2277698516846, -0.85564690828323, -0.40000000596046 },
                        { 18.613000869751, -22.652599334717, -3.4000000953674 }
                    },
                    ["wizard"] = {
                        height = 3,
                        invulnerability = 2,
                        { -9.2459697723389, 9.3335800170898, -2.5999999046326 },
                        { 9.1828498840332, -9.1805400848389, -2.5999999046326 }
                    }
                }
            }
        },
        -- GLOBAL SETTINGS
        global = {
            server_prefix = "**SERVER**",
            handlemutes = true,
            mute_dir = "sapp\\mutes.txt",
            default_mute_time = 525600,
            can_mute_admins = false, -- True = yes, false = no
            beepOnLoad = false,
            beepOnJoin = true,
            script_version = 1.2,
            plugin_commands = { enable = "enable", disable = "disable", list = "plugins", mute = "mute", unmute = "unmute" },
            permission_level = {
                trial_moderator = 1,
                moderator = 2,
                admin = 3,
                senior_admin = 4
            },
            player_data = {
                "Player: %name%",
                "CD Hash: %hash%",
                "IP Address: %ip_address%",
                "Index ID: %index_id%",
            },
        }
    }
    -- CONFIGURAITON [ends] << ------------------------------------------------------------
end

-- Tables used Globally
local players = { }
local player_data = { }
local quit_data = { }
local ip_table = {}
local mapname = ""

-- Mute Handler
local mute_duration = { }
local time_diff = { }
local muted = { }
local mute_timer = { }
local init_mute_timer = {}

-- #Message Board
local welcome_timer = { }
local message_board_timer = { }

-- #Admin Chat
local data = { }
local adminchat = { }
local stored_data = { }
local boolean = { }
local game_over = nil

-- #Custom Weapons
local weapon = { }
local frags = { }
local plasmas = { }

-- #Alias System
local trigger = { }
local alias_timer = { }
local index = nil
local alias_bool = {}

-- #Teleport Manager
local canset = { }
local wait_for_response = { }
local previous_location = { }
for i = 1, 16 do
    previous_location[i] = { }
end

-- #Spawn From Sky
local init_timer = {}
local first_join = {}

-- #Color Reservation
local colorres_bool = {}

function OnScriptLoad()
    loadWeaponTags()
    GameSettings()
    printEnabled()
    getCurrentVersion(true)
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")

    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")

    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPrespawn")

    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")

    register_callback(cb['EVENT_DIE'], "OnPlayerKill")

    for i = 1, 16 do
        if player_present(i) then

            local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")

            -- #Message Board
            if (settings.mod["Message Board"].enabled == true) then
                players[p_table].message_board_timer = 0
            end

            -- #Alias System
            if (settings.mod["Alias System"].enabled == true) then
                players[p_table].alias_timer = 0
            end

            -- #Admin Chat
            if (settings.mod["Admin Chat"].enabled == true) then
                if not (game_over) then
                    if tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                        players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].adminchat = nil
                        players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].boolean = nil
                    end
                end
            end
        end
    end

    -- Used OnPlayerJoin()
    if halo_type == "PC" then
        ce = 0x0
    else
        ce = 0x40
    end

    -- #Custom Weapons
    if (settings.mod["Custom Weapons"].enabled == true) then
        if not (game_over) then
            if get_var(0, "$gt") ~= "n/a" then
                mapname = get_var(0, "$map")
            end
        end
    end
    if (settings.global.beepOnLoad == true) then
        execute_command_sequence("beep 1200 200; beep 1200 200; beep 1200 200")
    end
    -- #Console Logo
    if (settings.mod["Console Logo"].enabled == true) then
        function consoleLogo()
            local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
            local servername = read_widestring(network_struct + 0x8, 0x42)
            -- Logo: ascii: 'kban'
            cprint("================================================================================", 2 + 8)
            cprint(os.date("%A, %d %B %Y - %X"), 6)
            cprint("")
            cprint("          ..|'''.| '||'  '||'     |     '||'      '|| '||'  '|' '||'  |'    ", 4 + 8)
            cprint("          .|'     '   ||    ||     |||     ||        '|. '|.  .'   || .'    ", 4 + 8)
            cprint("          ||          ||''''||    |  ||    ||         ||  ||  |    ||'|.    ", 4 + 8)
            cprint("          '|.      .  ||    ||   .''''|.   ||          ||| |||     ||  ||   ", 4 + 8)
            cprint("          ''|....'  .||.  .||. .|.  .||. .||.....|     |   |     .||.  ||.  ", 4 + 8)
            cprint("                  ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
            cprint("                         " .. servername)
            cprint("                  ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
            cprint("")
            cprint("================================================================================", 2 + 8)
        end
        timer(50, "consoleLogo")
    end
end

function OnScriptUnload()
    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        for i = 1, 16 do
            if player_present(i) then
                if tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                    local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                    players[p_table].adminchat = false
                    players[p_table].boolean = false
                end
            end
        end
    end
end

function OnNewGame()

    -- Used Globally
    game_over = false
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    servername = read_widestring(network_struct + 0x8, 0x42)
    mapname = get_var(0, "$map")

    for i = 1, 16 do
        if player_present(i) then
            local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")

            -- #Message Board
            if (settings.mod["Message Board"].enabled == true) then
                players[p_table].message_board_timer = 0
            end

            -- #Alias System
            if (settings.mod["Alias System"].enabled == true) then
                alias_bool[i] = false
                trigger[i] = false
                players[p_table].alias_timer = 0
            end

            -- #Admin Chat
            if (settings.mod["Admin Chat"].enabled == true) then
                if tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                    players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].adminchat = false
                    players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].boolean = false
                end
            end
        end
    end

    -- #Color Reservation
    if (settings.mod["Color Reservation"].enabled == true) then
        if (GetTeamPlay() == true) then
            cprint("[!] Warning: Color Reservation doesn't support Team Play!", 4 + 8)
        end
    end

    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled == true) then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local map = get_var(0, "$map")
            local gt = get_var(0, "$mode")
            local n1 = "\n"
            local t1 = os.date("[%A %d %B %Y] - %X - A new game has started on " .. tostring(map) .. ", Mode: " .. tostring(gt))
            local n2 = "\n---------------------------------------------------------------------------------------------\n"
            file:write(n1, t1, n2)
            file:close()
        end
    end

    -- #Teleport Manager
    if (settings.mod["Teleport Manager"].enabled == true) then
        check_file_status(PlayerIndex)
    end
end

function OnGameEnd()
    -- Used Globally
    game_over = true

    for i = 1, 16 do
        if player_present(i) then
            local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
            -- #Weapon Settings
            if (settings.mod["Custom Weapons"].enabled == true and settings.mod["Custom Weapons"].assign_weapons == true) then
                weapon[i] = false
            end

            -- #Alias System
            if (settings.mod["Alias System"].enabled == true) then
                alias_bool[i] = false
                trigger[i] = false
                players[p_table].alias_timer = 0
            end

            -- #Message Board
            if (settings.mod["Message Board"].enabled == true) then
                welcome_timer[i] = false
                players[p_table].message_board_timer = 0
            end

            -- #Admin Chat
            if (settings.mod["Admin Chat"].enabled == true) then
                if tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                    if (Restore_Previous_State == true) then
                        local bool
                        if players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].adminchat == true then
                            bool = "true"
                        else
                            bool = "false"
                        end
                        data[i] = get_var(i, "$name") .. ":" .. bool
                        stored_data[data] = stored_data[data] or { }
                        table.insert(stored_data[data], tostring(data[i]))
                    else
                        players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].adminchat = false
                        players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].boolean = false
                    end
                end
            end
            
            -- SAPP | Mute Handler
            if (settings.global.handlemutes == true) then
                if (muted[tonumber(i)] == true) then
                    local name, hash, id = get_var(i, "$name"), get_var(i, "$hash"), get_var(i, "$n")
                    local ip = getIP(name, hash, id)
                    local file_name = settings.global.mute_dir
                    checkFile(file_name)
                    local file = io.open(file_name, "r")
                    local data = file:read("*a")
                    file:close()
                    local lines = lines_from(file_name)
                    for k, v in pairs(lines) do
                        if k ~= nil then
                            if string.match(v, ip) and string.match(v, hash) then
                                local updated_entry = ip .. ", " .. hash .. ", ;" .. time_diff[tonumber(i)]
                                local f = io.open(file_name, "r")
                                local content = f:read("*all")
                                f:close()
                                content = string.gsub(content, v, updated_entry)
                                local f = io.open(file_name, "w")
                                f:write(content)
                                f:close()
                            end
                        end
                    end
                end
            end
        end
    end
    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled == true) then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local data = os.date("[%A %d %B %Y] - %X - The game is ending - ")
            file:write(data)
            file:close()
        end
    end
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")

            -- SAPP | Mute Handler
            if (settings.global.handlemutes == true) then
                if init_mute_timer[tonumber(i)] == true then
                
                    local name, hash, id = get_var(i, "$name"), get_var(i, "$hash"), get_var(i, "$n")
                    local ip = getIP(name, hash, id)
                    local entry = ip .. ", " .. hash

                    mute_timer[entry].timer = mute_timer[entry].timer + 0.030
                
                    local days, hours, minutes, seconds = secondsToTime(mute_timer[entry].timer, 4)
                    local mute_time = (mute_duration[tonumber(i)]) - math.floor(minutes)
                    time_diff[tonumber(i)] = mute_time
                    
                    if (mute_time <= 0) then
                        time_diff[tonumber(i)] = 0
                        muted[tonumber(i)] = false
                        init_mute_timer[tonumber(i)] = false
                        removeEntry(ip, hash, i)
                        rprint(i, "Your mute time has expired.")
                    end
                end
            end

            -- #Message Board
            if (settings.mod["Message Board"].enabled == true) then
                if (welcome_timer[i] == true) then
                    players[p_table].message_board_timer = players[p_table].message_board_timer + 0.030
                    cls(i)
                    local message_board = settings.mod["Message Board"].messages
                    for k, v in pairs(message_board) do
                        for j = 1, #message_board do
                            if string.find(message_board[j], "$SERVER_NAME") then
                                message_board[j] = string.gsub(message_board[j], "$SERVER_NAME", servername)
                            elseif string.find(message_board[j], "$PLAYER_NAME") then
                                message_board[j] = string.gsub(message_board[j], "$PLAYER_NAME", get_var(i, "$name"))
                            end
                        end
                        rprint(i, "|" .. settings.mod["Message Board"].alignment .. " " .. v)
                    end
                    if players[p_table].message_board_timer >= math.floor(settings.mod["Message Board"].duration) then
                        welcome_timer[i] = false
                        players[p_table].message_board_timer = 0
                    end
                end
            end

            -- #Custom Weapons
            if (settings.mod["Custom Weapons"].enabled == true and settings.mod["Custom Weapons"].assign_weapons == true) then
                if (player_alive(i)) then
                    if (weapon[i] == true) then
                        execute_command("wdel " .. i)
                        local player = get_dynamic_player(i)
                        local x, y, z = read_vector3d(player + 0x5C)
                        if settings.mod["Custom Weapons"].weapons[mapname] ~= nil then
                            local primary, secondary, tertiary, quaternary, Slot = select(1, determineWeapon())

                            if (primary) then
                                assign_weapon(spawn_object("weap", primary, x, y, z), i)
                            end

                            if (secondary) then
                                assign_weapon(spawn_object("weap", secondary, x, y, z), i)
                            end

                            if (Slot == 3 or Slot == 4) then
                                timer(100, "delayAssign", player, x, y, z)
                            end

                            function delayAssign()
                                if (quaternary) then
                                    assign_weapon(spawn_object("weap", quaternary, x, y, z), i)
                                end

                                if (tertiary) then
                                    assign_weapon(spawn_object("weap", tertiary, x, y, z), i)
                                end
                            end

                        end
                        weapon[i] = false
                    end
                end
            end

            -- #Alias System
            if (settings.mod["Alias System"].enabled == true) then
                if (trigger[i] == true) then
                    players[p_table].alias_timer = players[p_table].alias_timer + 0.030
                    cls(i)
                    concatValues(i, 1, 6)
                    concatValues(i, 7, 12)
                    concatValues(i, 13, 18)
                    concatValues(i, 19, 24)
                    concatValues(i, 25, 30)
                    concatValues(i, 31, 36)
                    concatValues(i, 37, 42)
                    concatValues(i, 43, 48)
                    concatValues(i, 49, 55)
                    concatValues(i, 56, 61)
                    concatValues(i, 62, 67)
                    concatValues(i, 68, 73)
                    concatValues(i, 74, 79)
                    concatValues(i, 80, 85)
                    concatValues(i, 86, 91)
                    concatValues(i, 92, 97)
                    concatValues(i, 98, 100)
                    if (alias_bool[i] == true) then
                        local alignment = settings.mod["Alias System"].alignment
                        rprint(i, "|" .. alignment .. " " .. 'Showing aliases for: "' .. target_hash .. '"')
                    end
                    local duration = settings.mod["Alias System"].duration
                    if players[p_table].alias_timer >= math.floor(duration) then
                        trigger[i] = false
                        alias_bool[i] = false
                        players[p_table].alias_timer = 0
                    end
                end
            end
            -- #Spawn From Sky
            if (settings.mod["Spawn From Sky"].enabled == true) then
                if (init_timer[i] == true) then
                    timeUntilRestore(i)
                end
            end
        end
    end
end

function determineWeapon()
    local primary, secondary, tertiary, quaternary, Slot
    for i = 1, 4 do
        local weapon = settings.mod["Custom Weapons"].weapons[mapname][i]
        if (weapon ~= nil) then
            if (i == 1 and settings.mod["Custom Weapons"].weapons[mapname][1] ~= nil) then
                primary = settings.mod["Custom Weapons"].weapons[mapname][1]
                Slot = 1
            end
            if (i == 2 and settings.mod["Custom Weapons"].weapons[mapname][2] ~= nil) then
                secondary = settings.mod["Custom Weapons"].weapons[mapname][2]
                Slot = 2
            end
            if (i == 3 and settings.mod["Custom Weapons"].weapons[mapname][3] ~= nil) then
                tertiary = settings.mod["Custom Weapons"].weapons[mapname][3]
                Slot = 3
            end
            if (i == 4 and settings.mod["Custom Weapons"].weapons[mapname][4] ~= nil) then
                quaternary = settings.mod["Custom Weapons"].weapons[mapname][4]
                Slot = 4
            end
        end
    end
    return primary, secondary, tertiary, quaternary, Slot
end

function OnPlayerPrejoin(PlayerIndex)
    if (settings.global.beepOnJoin == true) then
        os.execute("echo \7")
    end
    -- #CONSOLE OUTPUT
    local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local cns = ns + 0x1AA + ce + to_real_index(PlayerIndex) * 0x20
    local name, hash, ip, id = read_widestring(cns, 12), get_var(PlayerIndex, "$hash"), get_var(PlayerIndex, "$ip"), get_var(PlayerIndex, "$n")
    savePlayerData(name, hash, ip, id)
    for k, v in ipairs(player_data) do
        if (string.match(v, name) and string.match(v, hash) and string.match(v, id)) then
            cprint("--------------------------------------------------------------------------------")
            cprint("Player attempting to connect to the server...", 5 + 8)
            cprint(v, 2 + 8)
            break
        end
    end
    table.insert(ip_table, name .. ", " .. hash .. ", " .. id .. ", &" .. ip)
end

function OnPlayerJoin(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ip = get_var(PlayerIndex, "$ip")

    -- #CONSOLE OUTPUT
    for k, v in ipairs(player_data) do
        if (v:match(name) and v:match(hash) and v:match(id)) then
            cprint("Join Time: " .. os.date("%A %d %B %Y - %X"), 2 + 8)
            cprint("Status: " .. name .. " connected successfully.", 5 + 8)
            cprint("--------------------------------------------------------------------------------")
        end
    end
    
    if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel(nil, nil, "senior_admin") then
        if (getCurrentVersion(false) ~= settings.global.script_version) then
            rprint(PlayerIndex, "============================================================================")
            rprint(PlayerIndex, "[BGS] Version "  .. getCurrentVersion(false) .. " is available for download.")
            rprint(PlayerIndex, "Current version: v" .. settings.global.script_version)
            rprint(PlayerIndex, "============================================================================")
        end
    end

    -- SAPP | Mute Handler
    
    if (settings.global.handlemutes == false) then
        muted[tonumber(PlayerIndex)] = false or nil
    end
    
    if (settings.global.handlemutes == true) then
        local file_name = settings.global.mute_dir
        if checkFile(file_name) then
            local stringToMatch = ip .. ", " .. hash .. ", ;(%d+)"
            local lines = lines_from(file_name)
            for k, v in pairs(lines) do
                if v:match(stringToMatch) then
                    local timeFound = string.match(v, (";(.+)"))
                    local words = tokenizestring(timeFound, ", ")
                    mute_duration[tonumber(PlayerIndex)] = tonumber(words[1])
                    muted[tonumber(PlayerIndex)] = true
                    if (mute_duration[tonumber(PlayerIndex)] == settings.global.default_mute_time) then
                        rprint(PlayerIndex, "You are muted permanently.")
                    else
                        init_mute_timer[tonumber(PlayerIndex)] = true
                        rprint(PlayerIndex, "You were muted! Time remaining: " .. mute_duration[tonumber(PlayerIndex)] .. " minute(s)")
                    end
                else
                    mute_duration[tonumber(PlayerIndex)] = 0
                    muted[tonumber(PlayerIndex)] = false
                    init_mute_timer[tonumber(PlayerIndex)] = false
                end
            end
        end
    end

    -- #Color Reservation
    if (settings.mod["Color Reservation"].enabled == true) then
        local t = settings.mod["Color Reservation"].color_table
        local ColorTable = settings.mod["Color Reservation"].color_table
        for k, v in pairs(ColorTable) do
            for i = 1, #ColorTable do
                local t = tokenizestring(ColorTable[i][1], ", ")
                if string.find(ColorTable[i][1], hash) then
                    colorres_bool[PlayerIndex] = true
                    i = i - 1
                    setColor(PlayerIndex, tonumber(i))
                end
            end
            break
        end
    end

    -- Used Globally
    local p_table = name .. ", " .. hash
    players[p_table] = { }

    local entry = ip .. ", " .. hash
    mute_timer[entry] = { }
    mute_timer[entry].timer = 0

    -- #Spawn From Sky
    if (settings.mod["Spawn From Sky"].enabled == true) then
        players[p_table].sky_timer = 0
        init_timer[PlayerIndex] = true
        first_join[PlayerIndex] = true
    end

    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        players[p_table].message_board_timer = 0
        welcome_timer[PlayerIndex] = true
    end

    -- #Alias System
    if (settings.mod["Alias System"].enabled == true) then
        addAlias(name, hash)
        players[p_table].alias_timer = 0
        welcome_timer[PlayerIndex] = true
    end

    -- #Anti Impersonator
    if (settings.mod["Anti Impersonator"].enabled == true) then

        local name_list = settings.mod["Anti Impersonator"].namelist
        local hash_list = settings.mod["Anti Impersonator"].hashlist


        if (table.match(name_list, name) and not table.match(hash_list, hash)) then
            local action = settings.mod["Anti Impersonator"].action
            local reason = settings.mod["Anti Impersonator"].reason
            if (action == "kick") then
                execute_command("k" .. " " .. id .. " \"" .. reason .. "\"")
                cprint(name .. " was kicked for " .. reason, 4 + 8)
            elseif (action == "ban") then
                local bantime = settings.mod["Anti Impersonator"].bantime
                execute_command("b" .. " " .. id .. " " .. bantime .. " \"" .. reason .. "\"")
                cprint(name .. " was banned for " .. bantime .. " minutes for " .. reason, 4 + 8)
            end
        end
    end

    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled == true) then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            file:write(timestamp .. "    [JOIN]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
            file:close()
        end
    end

    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        players[p_table].adminchat = nil
        players[p_table].boolean = nil
        if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
            if (settings.mod["Admin Chat"].restore_previous_state == true) then
                local t = tokenizestring(tostring(data[PlayerIndex]), ":")
                if t[2] == "true" then
                    rprint(PlayerIndex, "Your admin chat is on!")
                    players[p_table].adminchat = true
                    players[p_table].boolean = true
                else
                    players[p_table].adminchat = false
                    players[p_table].boolean = false
                end
            else
                players[p_table].adminchat = false
                players[p_table].boolean = false
            end
        end
    end

    -- #Admin Join Messages
    if (settings.mod["Admin Join Messages"].enabled == true) then
        local level = tonumber(get_var(PlayerIndex, "$lvl"))
        local join_message
        if (level >= 1) then
            local prefix = settings.mod["Admin Join Messages"].messages[level][1]
            local suffix = settings.mod["Admin Join Messages"].messages[level][2]
            join_message = prefix .. name .. suffix
            local function announceJoin(join_message)
                for i = 1, 16 do
                    if player_present(i) then
                        rprint(i, join_message)
                    end
                end
            end
            announceJoin(join_message)
        end
    end
end

function OnPlayerLeave(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")

    -- #CONSOLE OUTPUT
    for k, v in ipairs(player_data) do
        if (v:match(name) and v:match(hash) and v:match(id)) then
            cprint("--------------------------------------------------------------------------------")
            cprint(v, 4 + 8)
            cprint("--------------------------------------------------------------------------------")
            table.remove(player_data, k)
            break
        end
    end
    
    -- Used Globally
    local p_table = name .. ", " .. hash
    local ip = getIP(name, hash, id)
    
    -- #Spawn From Sky
    if (settings.mod["Spawn From Sky"].enabled == true) then
        if init_timer == true then
            init_timer[PlayerIndex] = false
        end
        if first_join == true then
            first_join[PlayerIndex] = false
        end
        players[p_table].sky_timer = 0
    end

    -- SAPP | Mute Handler
    if (settings.global.handlemutes == true) then
        if (muted[tonumber(PlayerIndex)] == true) then
            muted[tonumber(PlayerIndex)] = false
            local file_name = settings.global.mute_dir
            checkFile(file_name)
            local file = io.open(file_name, "r")
            local data = file:read("*a")
            file:close()
            local lines = lines_from(file_name)
            for k, v in pairs(lines) do
                if k ~= nil then
                    if string.match(v, ip) and string.match(v, hash) then
                        local updated_entry = ip .. ", " .. hash .. ", ;" .. time_diff[tonumber(PlayerIndex)]
                        cprint(updated_entry)
                        local f = io.open(file_name, "r")
                        local content = f:read("*all")
                        f:close()
                        content = string.gsub(content, v, updated_entry)
                        local f = io.open(file_name, "w")
                        f:write(content)
                        f:close()
                    end
                end
            end
        end
    end

    -- #Alias System
    if (settings.mod["Alias System"].enabled == true) then
        alias_bool[PlayerIndex] = false
        trigger[PlayerIndex] = false
        players[p_table].alias_timer = 0
    end

    -- #Message Board
    if (settings.mod["Message Board"].enabled == true) then
        welcome_timer[PlayerIndex] = false
        players[p_table].message_board_timer = 0
    end


    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled == true) then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            file:write(timestamp .. "    [QUIT]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
            file:close()
        end
    end

    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
            if PlayerIndex ~= 0 then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                    if (settings.mod["Admin Chat"].restore_previous_state == true) then
                        if players[p_table].adminchat == true then
                            bool = "true"
                        else
                            bool = "false"
                        end
                        data[PlayerIndex] = get_var(PlayerIndex, "$name") .. ":" .. bool
                        stored_data[data] = stored_data[data] or { }
                        table.insert(stored_data[data], tostring(data[PlayerIndex]))
                    else
                        players[p_table].adminchat = false
                        players[p_table].boolean = false
                    end
                end
            end
        end
    end

    -- #Teleport Manager
    if (settings.mod["Teleport Manager"].enabled == true) then
        wait_for_response[PlayerIndex] = false
        for i = 1, 3 do
            previous_location[PlayerIndex][i] = nil
        end
    end
    
    -- REMOVE IP entry from temporary ip_table
    for k, v in pairs(ip_table) do
        if v then
            if (v:match(name) and v:match(hash) and v:match(id)) then
                table.remove(ip_table, k)
            end
        end
    end
end

function OnPlayerPrespawn(PlayerIndex)
    -- #Spawn From Sky
    if (settings.mod["Spawn From Sky"].enabled == true) then
        if (first_join[PlayerIndex] == true) then
            first_join[PlayerIndex] = false
            local team = get_var(PlayerIndex, "$team")
            local function Teleport(PlayerIndex, id)
                local height = settings.mod["Spawn From Sky"].maps[mapname].height
                write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, 
                    settings.mod["Spawn From Sky"].maps[mapname][id][1], 
                    settings.mod["Spawn From Sky"].maps[mapname][id][2], 
                    settings.mod["Spawn From Sky"].maps[mapname][id][3] + math.floor(height))
                execute_command("god " .. tonumber(PlayerIndex))
            end
            if (team == "red") then
                Teleport(PlayerIndex, 1)
            elseif (team == "blue") then
                Teleport(PlayerIndex, 2)
            end
        end
    end
end

function OnPlayerSpawn(PlayerIndex)
    -- #Custom Weapons
    if (settings.mod["Custom Weapons"].enabled == true) then
        weapon[PlayerIndex] = true
        if player_alive(PlayerIndex) then
            local player_object = get_dynamic_player(PlayerIndex)
            if (player_object ~= 0) then
                if (settings.mod["Custom Weapons"].assign_custom_frags == true) then
                    local frags = settings.mod["Custom Weapons"].weapons[mapname][5]
                    write_word(player_object + 0x31E, tonumber(frags))
                end
                if (settings.mod["Custom Weapons"].assign_custom_plasmas == true) then
                    local plasmas = settings.mod["Custom Weapons"].weapons[mapname][6]
                    write_word(player_object + 0x31F, tonumber(plasmas))
                end
            end
        end
    end

    -- #Color Reservation
    if (settings.mod["Color Reservation"].enabled == true) then
        if (colorres_bool[PlayerIndex] == true) then
            colorres_bool[PlayerIndex] = false
            local player_object = read_dword(get_player(PlayerIndex) + 0x34)
            destroy_object(player_object)
        end
    end
end

function OnPlayerKill(PlayerIndex)
    -- #Respawn Time
    if (settings.mod["Respawn Time"].enabled == true) then
        local player = get_player(PlayerIndex)
        local function getSpawnTime()
            local spawntime
            if (get_var(1, "$gt") == "ctf") then
                spawntime = settings.mod["Respawn Time"].maps[mapname][1]
            elseif (get_var(1, "$gt") == "slayer") then
                if not getTeamPlay() then
                    spawntime = settings.mod["Respawn Time"].maps[mapname][2]
                else
                    spawntime = settings.mod["Respawn Time"].maps[mapname][3]
                end
            elseif (get_var(1, "$gt") == "koth") then
                if not getTeamPlay() then
                    spawntime = settings.mod["Respawn Time"].maps[mapname][4]
                else
                    spawntime = settings.mod["Respawn Time"].maps[mapname][5]
                end
            elseif (get_var(1, "$gt") == "oddball") then
                if not getTeamPlay() then
                    spawntime = settings.mod["Respawn Time"].maps[mapname][6]
                else
                    spawntime = settings.mod["Respawn Time"].maps[mapname][7]
                end
            elseif (get_var(1, "$gt") == "race") then
                if not getTeamPlay() then
                    spawntime = settings.mod["Respawn Time"].maps[mapname][8]
                else
                    spawntime = settings.mod["Respawn Time"].maps[mapname][9]
                end
            end
            return spawntime
        end
        write_dword(player + 0x2C, tonumber(getSpawnTime()) * 33)
    end
end

function OnPlayerChat(PlayerIndex, Message, type)

    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local response

    -- Used Globally
    local p_table = name .. ", " .. hash
    local privilege_level = tonumber(get_var(PlayerIndex, "$lvl"))

    -- #Command Spy
    if (settings.mod["Command Spy"].enabled == true) then
        local command
        local iscommand = nil
        local message = tostring(Message)
        local String = tokenizestring(message)
        if string.sub(String[1], 1, 1) == "/" then
            command = String[1]:gsub("\\", "/")
            iscommand = true
        else
            iscommand = false
        end

        local hidden_messages = settings.mod["Command Spy"].commands_to_hide
        for k, v in pairs(hidden_messages) do
            if (command == k) then
                hidden = true
                break
            else
                hidden = false
            end
        end

        if (tonumber(get_var(PlayerIndex, "$lvl")) == -1) and (iscommand) then
            local hidden_status = settings.mod["Command Spy"].hide_commands
            if (hidden_status == true and hidden == true) then
                response = false
            elseif (hidden_status == true and hidden == false) or (hidden_status == false) then
                CommandSpy(settings.mod["Command Spy"].prefix .. " " .. name .. ":    \"" .. message .. "\"")
                response = true
            end
        end
    end

    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled == true) then
        local message = tostring(Message)
        local command = tokenizestring(message)
        iscommand = nil
        if string.sub(command[1], 1, 1) == "/" or string.sub(command[1], 1, 1) == "\\" then
            iscommand = true
            chattype = "[COMMAND] "
        else
            iscommand = false
        end

        local chat_type = nil

        if type == 0 then
            chat_type = "[GLOBAL]  "
        elseif type == 1 then
            chat_type = "[TEAM]    "
        elseif type == 2 then
            chat_type = "[VEHICLE] "
        end

        if (player_present(PlayerIndex) ~= nil) then
            local dir = settings.mod["Chat Logging"].dir
            local function LogChat(dir, value)
                local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
                local file = io.open(dir, "a+")
                if file ~= nil then
                    local chatValue = string.format("%s\t%s\n", timestamp, tostring(value))
                    file:write(chatValue)
                    file:close()
                end
            end
            if iscommand then
                LogChat(dir, "   " .. chattype .. "     " .. name .. " [" .. id .. "]: " .. message)
                cprint(chattype .. " " .. name .. " [" .. id .. "]: " .. message, 3 + 8)
            else
                LogChat(dir, "   " .. chat_type .. "     " .. name .. " [" .. id .. "]: " .. message)
                cprint(chat_type .. " " .. name .. " [" .. id .. "]: " .. message, 3 + 8)
            end
        end
    end


    
    -- SAPP | Mute Handler
    if (settings.global.handlemutes == true) then
        if (muted[tonumber(PlayerIndex)] == true) then
            if (mute_duration[tonumber(PlayerIndex)] == settings.global.default_mute_time) then
                rprint(PlayerIndex, "You are muted permanently.")
            else
                rprint(PlayerIndex, "You are muted! Time remaining: " .. mute_duration[tonumber(PlayerIndex)] .. " minute(s)")
            end
            return false
        end
    end

    -- #Chat IDs
    if (settings.mod["Chat IDs"].enabled == true) then
        if not (game_over) and muted[tonumber(PlayerIndex)] == false or muted[tonumber(PlayerIndex)] == nil then

            local keyword = nil
            local message = tokenizestring(Message)
            if (#message == 0) then
                return nil
            end

            local keywords_to_ignore = settings.mod["Chat IDs"].ignore_list
            if (table.match(keywords_to_ignore, message[1])) then
                keyword = true
            else
                keyword = false
            end

            -- GLOBAL FORMAT
            local GlobalDefault = settings.mod["Chat IDs"].global_format[1]
            local Global_TModFormat = settings.mod["Chat IDs"].trial_moderator[1]
            local Global_ModFormat = settings.mod["Chat IDs"].moderator[1]
            local Global_AdminFormat = settings.mod["Chat IDs"].admin[1]
            local Global_SAdminFormat = settings.mod["Chat IDs"].senior_admin[1]

            --TEAM FORMAT
            local TeamDefault = settings.mod["Chat IDs"].team_format[1]
            local Team_TModFormat = settings.mod["Chat IDs"].trial_moderator[2]
            local Team_ModFormat = settings.mod["Chat IDs"].moderator[2]
            local Team_AdminFormat = settings.mod["Chat IDs"].admin[2]
            local Team_SAdminFormat = settings.mod["Chat IDs"].senior_admin[2]

            if not (keyword) or (keyword == nil) then
                local function ChatHandler(PlayerIndex, Message)
                    local function SendToTeam(Message, PlayerIndex, Global, Tmod, Mod, Admin, sAdmin)
                        for i = 1, 16 do
                            if player_present(i) then
                                if (get_var(i, "$team")) == (get_var(PlayerIndex, "$team")) then
                                    local message = ""
                                    execute_command("msg_prefix \"\"")
                                    if (Global == true) then
                                        for k, v in pairs(settings.mod["Chat IDs"].team_format) do
                                            TeamDefault = string.gsub(TeamDefault, "%%sender_name%%", name)
                                            TeamDefault = string.gsub(TeamDefault, "%%index%%", id)
                                            TeamDefault = string.gsub(TeamDefault, "%%message%%", Message)
                                            message = TeamDefault
                                        end

                                    elseif (Tmod == true) then
                                        for k, v in pairs(settings.mod["Chat IDs"].trial_moderator) do
                                            Team_TModFormat = string.gsub(Team_TModFormat, "%%sender_name%%", name)
                                            Team_TModFormat = string.gsub(Team_TModFormat, "%%index%%", id)
                                            Team_TModFormat = string.gsub(Team_TModFormat, "%%message%%", Message)
                                            message = Team_TModFormat
                                        end

                                    elseif (Mod == true) then
                                        for k, v in pairs(settings.mod["Chat IDs"].moderator) do
                                            Team_ModFormat = string.gsub(Team_ModFormat, "%%sender_name%%", name)
                                            Team_ModFormat = string.gsub(Team_ModFormat, "%%index%%", id)
                                            Team_ModFormat = string.gsub(Team_ModFormat, "%%message%%", Message)
                                            message = Team_ModFormat
                                        end

                                    elseif (Admin == true) then
                                        for k, v in pairs(settings.mod["Chat IDs"].admin) do
                                            Team_AdminFormat = string.gsub(Team_AdminFormat, "%%sender_name%%", name)
                                            Team_AdminFormat = string.gsub(Team_AdminFormat, "%%index%%", id)
                                            Team_AdminFormat = string.gsub(Team_AdminFormat, "%%message%%", Message)
                                            message = Team_AdminFormat
                                        end

                                    elseif (sAdmin == true) then
                                        for k, v in pairs(settings.mod["Chat IDs"].senior_admin) do
                                            Team_SAdminFormat = string.gsub(Team_SAdminFormat, "%%sender_name%%", name)
                                            Team_SAdminFormat = string.gsub(Team_SAdminFormat, "%%index%%", id)
                                            Team_SAdminFormat = string.gsub(Team_SAdminFormat, "%%message%%", Message)
                                            message = Team_SAdminFormat
                                        end
                                    end
                                    say(i, message)
                                    execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                                    response = false
                                end
                            end
                        end
                    end

                    local function SendToAll(Message, Global, Tmod, Mod, Admin, sAdmin)
                        local message = ""
                        execute_command("msg_prefix \"\"")
                        if (Global == true) then
                            for k, v in pairs(settings.mod["Chat IDs"].global_format) do
                                GlobalDefault = string.gsub(GlobalDefault, "%%sender_name%%", name)
                                GlobalDefault = string.gsub(GlobalDefault, "%%index%%", id)
                                GlobalDefault = string.gsub(GlobalDefault, "%%message%%", Message)
                                message = GlobalDefault
                            end

                        elseif (Tmod == true) then
                            for k, v in pairs(settings.mod["Chat IDs"].trial_moderator) do
                                Global_TModFormat = string.gsub(Global_TModFormat, "%%sender_name%%", name)
                                Global_TModFormat = string.gsub(Global_TModFormat, "%%index%%", id)
                                Global_TModFormat = string.gsub(Global_TModFormat, "%%message%%", Message)
                                message = Global_TModFormat
                            end

                        elseif (Mod == true) then
                            for k, v in pairs(settings.mod["Chat IDs"].moderator) do
                                Global_ModFormat = string.gsub(Global_ModFormat, "%%sender_name%%", name)
                                Global_ModFormat = string.gsub(Global_ModFormat, "%%index%%", id)
                                Global_ModFormat = string.gsub(Global_ModFormat, "%%message%%", Message)
                                message = Global_ModFormat
                            end

                        elseif (Admin == true) then
                            for k, v in pairs(settings.mod["Chat IDs"].admin) do
                                Global_AdminFormat = string.gsub(Global_AdminFormat, "%%sender_name%%", name)
                                Global_AdminFormat = string.gsub(Global_AdminFormat, "%%index%%", id)
                                Global_AdminFormat = string.gsub(Global_AdminFormat, "%%message%%", Message)
                                message = Global_AdminFormat
                            end

                        elseif (sAdmin == true) then
                            for k, v in pairs(settings.mod["Chat IDs"].senior_admin) do
                                Global_SAdminFormat = string.gsub(Global_SAdminFormat, "%%sender_name%%", name)
                                Global_SAdminFormat = string.gsub(Global_SAdminFormat, "%%index%%", id)
                                Global_SAdminFormat = string.gsub(Global_SAdminFormat, "%%message%%", Message)
                                message = Global_SAdminFormat
                            end
                        end
                        say_all(message)
                        execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                        response = false
                    end

                    for b = 0, #message do
                        if message[b] then
                            if not (string.sub(message[1], 1, 1) == "/" or string.sub(message[1], 1, 1) == "\\") then
                                if (GetTeamPlay() == true) then
                                    if (type == 0 or type == 2) then
                                        if (settings.mod["Chat IDs"].use_admin_prefixes == true) then
                                            if (privilege_level) == getPermLevel(nil, nil, "trial_moderator") then
                                                SendToAll(Message, nil, true, nil, nil, nil)
                                            elseif (privilege_level) == getPermLevel(nil, nil, "moderator") then
                                                SendToAll(Message, nil, nil, true, nil, nil)
                                            elseif (privilege_level) == getPermLevel(nil, nil, "admin") then
                                                SendToAll(Message, nil, nil, nil, true, nil)
                                            elseif (privilege_level) == getPermLevel(nil, nil, "senior_admin") then
                                                SendToAll(Message, nil, nil, nil, nil, true)
                                            else
                                                SendToAll(Message, true, nil, nil, nil, nil)
                                            end
                                        else
                                            SendToAll(Message, true, nil, nil, nil, nil)
                                        end
                                    elseif (type == 1) then
                                        if (settings.mod["Chat IDs"].use_admin_prefixes == true) then
                                            if (privilege_level) == getPermLevel(nil, nil, "trial_moderator") then
                                                SendToTeam(Message, PlayerIndex, nil, true, nil, nil, nil)
                                            elseif (privilege_level) == getPermLevel(nil, nil, "moderator") then
                                                SendToTeam(Message, PlayerIndex, nil, nil, true, nil, nil)
                                            elseif (privilege_level) == getPermLevel(nil, nil, "admin") then
                                                SendToTeam(Message, PlayerIndex, nil, nil, nil, true, nil)
                                            elseif (privilege_level) == getPermLevel(nil, nil, "senior_admin") then
                                                SendToTeam(Message, PlayerIndex, nil, nil, nil, nil, true)
                                            else
                                                SendToTeam(Message, PlayerIndex, true, nil, nil, nil, nil)
                                            end
                                        else
                                            SendToTeam(Message, PlayerIndex, true, nil, nil, nil, nil)
                                        end
                                    end
                                else
                                    SendToAll(Message)
                                end
                            else
                                response = true
                            end
                            break
                        end
                    end
                end
                if (settings.mod["Admin Chat"].enabled == true) then
                    if (players[p_table].adminchat ~= true) then
                        ChatHandler(PlayerIndex, Message)
                    end
                else
                    ChatHandler(PlayerIndex, Message)
                end
            end
        end
    end

    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        local function AdminChat(Message, PlayerIndex)
            for i = 1, 16 do
                if player_present(i) and tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                    if (settings.mod["Admin Chat"].environment == "rcon") then
                        rprint(i, "|l" .. Message)
                    elseif (settings.mod["Admin Chat"].environment == "chat") then
                        execute_command("msg_prefix \"\"")
                        say(i, Message)
                        execute_command("msg_prefix \" *  * SERVER *  * \"")
                    end
                end
            end
        end

        local message = tokenizestring(Message)
        if #message == 0 then
            return nil
        end

        if players[p_table].adminchat == true then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                for c = 0, #message do
                    if message[c] then
                        if string.sub(message[1], 1, 1) == "/" or string.sub(message[1], 1, 1) == "\\" then
                            response = true
                        else
                            local AdminMessageFormat = settings.mod["Admin Chat"].message_format[1]
                            for k, v in pairs(settings.mod["Admin Chat"].message_format) do
                                local prefix = settings.mod["Admin Chat"].prefix
                                AdminMessageFormat = string.gsub(AdminMessageFormat, "%%prefix%%", prefix)
                                AdminMessageFormat = string.gsub(AdminMessageFormat, "%%sender_name%%", name)
                                AdminMessageFormat = string.gsub(AdminMessageFormat, "%%index%%", id)
                                AdminMessageFormat = string.gsub(AdminMessageFormat, "%%message%%", Message)
                                AdminChat(AdminMessageFormat)
                                response = false
                            end
                        end
                        break
                    end
                end
            end
        end

        -- #Teleport Manager
        if (settings.mod["Teleport Manager"].enabled == true) then
            if wait_for_response[PlayerIndex] then
                if Message == ("yes") then
                    local file_name = settings.mod["Teleport Manager"].dir
                    delete_from_file(file_name, response_starting_line, response_num_lines, PlayerIndex)
                    rprint(PlayerIndex, "Successfully deleted teleport id #" .. response_starting_line)
                    wait_for_response[PlayerIndex] = false
                    response = false
                elseif Message == ("no") then
                    rprint(PlayerIndex, "Process Cancelled")
                    wait_for_response[PlayerIndex] = false
                    response = false
                end
                if Message ~= "yes" or Message ~= "no" then
                    rprint(PlayerIndex, "That is not a valid response, please try again. Type yes|no")
                    wait_for_response[PlayerIndex] = true
                    response = false
                end
            end
        end
    end
    return response
end

-- SAPP | Saves mute entry to txt file
function saveMuteEntry(PlayerIndex, offender_ip, offender_id, offender_hash, mute_time)
    local file_name = settings.global.mute_dir
    if checkFile(file_name) then
        local file = io.open(file_name, "r")
        local content = file:read("*a")
        file:close()
        local offender_name = get_var(offender_id, "$name")
        if not (string.match(content, offender_ip) and string.match(content, offender_id) and string.match(content, offender_hash)) then
        
            if (tonumber(mute_time) ~= settings.global.default_mute_time) then
                rprint(PlayerIndex, offender_name .. " has been muted for " .. mute_time .. " minute(s)")
                rprint(offender_id, "You have been muted for " .. mute_time .. " minute(s)")
            else
                rprint(PlayerIndex, offender_name .. " has been muted permanently")
                rprint(offender_id, "You were muted permanently")
            end
            
            local new_entry = offender_ip .. ", " .. offender_hash .. ", ;" .. mute_time
            local file = assert(io.open(file_name, "a+"))
            file:write(new_entry .. "\n")
            file:close()
        else
            rprint(PlayerIndex, offender_name .. " is already muted!")
        end
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)

    -- Used Globally
    local t = tokenizestring(Command)
    local privilege_level = tonumber(get_var(PlayerIndex, "$lvl"))

    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local p_table = name .. ", " .. hash
    
    
    -- remove later
    if (string.lower(Command) == "bgs") then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel(nil, nil, "senior_admin") then
            if (getCurrentVersion(false) ~= settings.global.script_version) then
                rprint(PlayerIndex, "============================================================================")
                rprint(PlayerIndex, "[BGS] Version "  .. getCurrentVersion(false) .. " is available for download.")
                rprint(PlayerIndex, "Current version: v" .. settings.global.script_version)
                rprint(PlayerIndex, "============================================================================")
            end
        else
            rprint(PlayerIndex, "BGS Version " .. settings.global.script_version)
        end
        return false
    end
    
    -- ENABLE or DISABLE a plugin (WIP)
    if (string.lower(t[1]) == settings.global.plugin_commands.list) then
        if (privilege_level) >= getPermLevel(nil, nil, "senior_admin") then
            rprint(PlayerIndex, "\n----- [ BASE GAME SETTINGS ] -----")
            local temp = {}
            for k, v in pairs(settings.mod) do
                table.insert(temp, k)
            end
            for k, v in pairs(temp) do
                if v then
                    if (settings.mod[v].enabled == true) then
                        rprint(PlayerIndex, "[" .. k .. "] " .. v .. " is enabled")
                    else
                        rprint(PlayerIndex, "[" .. k .. "] " .. v .. " is disabled")
                    end
                end
            end
            rprint(PlayerIndex, "-----------------------------------------------------\n")
        else
            rprint(PlayerIndex, "Insufficient Permission")
        end
        return false
    elseif (string.lower(t[1]) == settings.global.plugin_commands.enable) then
        if (t[2] ~= nil) and t[2]:match("%d") then
            if (privilege_level) >= getPermLevel(nil, nil, "senior_admin") then
                local id = t[2]
                local temp = {}
                for k, v in pairs(settings.mod) do
                    table.insert(temp, k)
                end
                for k, v in pairs(temp) do
                    if v then
                        if (tonumber(id) == tonumber(k)) then
                            if (settings.mod[v].enabled == false) then
                                settings.mod[v].enabled = true
                                rprint(PlayerIndex, "[" .. k .. "] " .. v .. " is enabled")
                            else
                                rprint(PlayerIndex, v .. " is already enabled!")
                            end
                        end
                    end
                end
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
        else
            rprint(PlayerIndex, "Invalid Syntax")
        end
        return false
    elseif (string.lower(t[1]) == settings.global.plugin_commands.disable) then
        if (t[2] ~= nil) and t[2]:match("%d") then
            if (privilege_level) >= getPermLevel(nil, nil, "senior_admin") then
                local id = t[2]
                local temp = {}
                for k, v in pairs(settings.mod) do
                    table.insert(temp, k)
                end
                for k, v in pairs(temp) do
                    if v then
                        if (tonumber(id) == tonumber(k)) then
                            if (settings.mod[v].enabled == true) then
                                settings.mod[v].enabled = false
                                rprint(PlayerIndex, "[" .. k .. "] " .. v .. " is disabled")
                            else
                                rprint(PlayerIndex, v .. " is already enabled!")
                            end
                        end
                    end
                end
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
        else
            rprint(PlayerIndex, "Invalid Syntax")
        end
        return false
    end

    -- SAPP | Mute command listener
    if (settings.global.handlemutes == true) then
        if (string.lower(t[1]) == settings.global.plugin_commands.mute) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= 1 then
                if (t[2] ~= nil) and string.match(t[2], "%d") then
                    local offender_id = get_var(tonumber(t[2]), "$n")
                    if offender_id ~= get_var(PlayerIndex, "$n") then
                        if player_present(offender_id) then
                            local proceed = nil
                            local valid = nil
                            
                            if (settings.global.can_mute_admins == true) then
                                proceed = true
                            elseif tonumber(get_var(offender_id, "$lvl")) >= getPermLevel(nil, nil, "trial_moderator") then
                                proceed = false
                                rprint(PlayerIndex, "You cannot mute admins.")
                            else
                                proceed = true
                            end
                            
                            local offender_ip = get_var(offender_id, "$ip")
                            local offender_hash = get_var(offender_id, "$hash")
                            mute_duration[tonumber(offender_id)] = 0
                            if (t[3] == nil) then
                                time_diff[tonumber(offender_id)] = tonumber(settings.global.default_mute_time)
                                mute_duration[tonumber(offender_id)] = tonumber(settings.global.default_mute_time)
                                valid = true
                            elseif string.match(t[3], "%d+") then
                                time_diff[tonumber(offender_id)] = tonumber(t[3])
                                mute_duration[tonumber(offender_id)] = tonumber(t[3])
                                init_mute_timer[tonumber(offender_id)] = true
                                valid = true
                            else
                                valid = false
                                rprint(PlayerIndex, "Invalid syntax. Usage: /" .. settings.global.plugin_commands.mute .. " [id] <time dif>")
                            end
                            if (proceed) and (valid) then
                                muted[tonumber(offender_id)] = true
                                saveMuteEntry(PlayerIndex, offender_ip, offender_id, offender_hash, mute_duration[tonumber(offender_id)])
                            end
                        else
                            rprint(PlayerIndex, "Player not present")
                        end
                    else
                        rprint(PlayerIndex, "Error. You cannot mute or unmute yourself.")
                    end
                else
                    rprint(PlayerIndex, "Invalid player. Usage: /" .. settings.global.plugin_commands.mute .. " [id] <time dif>")
                end
            else
                rprint(PlayerIndex, "Insufficient Permission.")
            end
            return false
        elseif (string.lower(t[1]) == settings.global.plugin_commands.unmute) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= 1 then
                if (t[2] ~= nil) and string.match(t[2], "%d") then
                    local offender_id = get_var(tonumber(t[2]), "$n")
                    if offender_id ~= get_var(PlayerIndex, "$n") then
                        if player_present(offender_id) then
                            local offender_name = get_var(offender_id, "$name")
                            local offender_ip = get_var(offender_id, "$ip")
                            local offender_hash = get_var(offender_id, "$hash")
                            if (muted[tonumber(offender_id)] == true) then
                            
                                muted[tonumber(offender_id)] = false
                                init_mute_timer[tonumber(offender_id)] = false
                                time_diff[tonumber(PlayerIndex)] = 0
                                
                                removeEntry(tostring(offender_ip), tostring(offender_hash), tonumber(offender_id))
                                
                                rprint(PlayerIndex, offender_name .. " has been unmuted")
                                rprint(offender_id, "You have been  unmuted")
                            else
                                rprint(PlayerIndex, offender_name .. " it not muted")
                            end
                        else
                            rprint(PlayerIndex, "Player not present")
                        end
                    else
                        rprint(PlayerIndex, "Error. You cannot mute or unmute yourself.")
                    end
                else
                    rprint(PlayerIndex, "Invalid player. Usage: /" .. settings.global.plugin_commands.unmute .. " [id]")
                end
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
            return false
        end
    end

    -- #List Players
    if (settings.mod["List Players"].enabled == true) then
        local commands = settings.mod["List Players"].command_aliases
        local count = #t
        for k, v in pairs(commands) do
            local cmds = tokenizestring(v, ",")
            for i = 1, #cmds do
                if (t[1] == cmds[i]) then
                    if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("List Players", nil, nil) then
                        listPlayers(PlayerIndex, count)
                    else
                        rprint(PlayerIndex, "Insufficient Permission")
                    end
                    return false
                end
            end
        end
    end

    -- #Get Coords
    if (settings.mod["Get Coords"].enabled == true) then
        if (string.lower(Command) == settings.mod["Get Coords"].base_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Get Coords", nil, nil) then
                local player_object = get_dynamic_player(PlayerIndex)
                if player_object ~= 0 then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    if settings.mod["Get Coords"].environment == "console" then
                        cprint(x .. ", " .. y .. ", " .. z)
                    elseif settings.mod["Get Coords"].environment == "rcon" then
                        rprint(PlayerIndex, x .. ", " .. y .. ", " .. z)
                    elseif settings.mod["Get Coords"].environment == "both" then
                        rprint(PlayerIndex, x .. ", " .. y .. ", " .. z)
                        cprint(x .. ", " .. y .. ", " .. z)
                    end
                    kill(PlayerIndex)
                    local player = get_player(PlayerIndex)
                    write_dword(player + 0x2C, 0 * 33)
                    return false
                end
            end
        end
    end
    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled == true) then
        local command = settings.mod["Admin Chat"].base_command
        if t[1] == (command) then
            if PlayerIndex ~= -1 and PlayerIndex >= 1 and PlayerIndex < 16 then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                    if t[2] == "on" or t[2] == "1" or t[2] == "true" or t[2] == '"1"' or t[2] == '"on"' or t[2] == '"true"' then
                        if players[p_table].boolean ~= true then
                            players[p_table].adminchat = true
                            players[p_table].boolean = true
                            rprint(PlayerIndex, "Admin Chat enabled.")
                            return false
                        else
                            rprint(PlayerIndex, "Admin Chat is already enabled.")
                            return false
                        end
                    elseif t[2] == "off" or t[2] == "0" or t[2] == "false" or t[2] == '"off"' or t[2] == '"0"' or t[2] == '"false"' then
                        if players[p_table].boolean ~= false then
                            players[p_table].adminchat = false
                            players[p_table].boolean = false
                            rprint(PlayerIndex, "Admin Chat disabled.")
                            return false
                        else
                            rprint(PlayerIndex, "Admin Chat is already disabled.")
                            return false
                        end
                    else
                        rprint(PlayerIndex, "Invalid Syntax: Type /" .. settings.mod["Admin Chat"].base_command .. " on|off")
                        return false
                    end
                else
                    rprint(PlayerIndex, "You do not have permission to execute that command!")
                    return false
                end
            else
                cprint("The Server cannot execute this command!", 4 + 8)
            end
        end
    end
    -- #Alias System
    if (settings.mod["Alias System"].enabled == true) then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Alias System", nil, nil) then
            if t[1] == string.lower(settings.mod["Alias System"].base_command) then
                if t[2] ~= nil then
                    if t[2] == string.match(t[2], "^%d+$") and t[3] == nil then
                        if player_present(tonumber(t[2])) then
                            local index = tonumber(t[2])
                            target_hash = tostring(get_var(index, "$hash"))
                            if trigger[PlayerIndex] == true then
                                -- aliases already showing (clear console then show again)
                                cls(PlayerIndex)
                                players[p_table].alias_timer = 0
                                trigger[PlayerIndex] = true
                                alias_bool[PlayerIndex] = true
                            else
                                -- show aliases (first time)
                                trigger[PlayerIndex] = true
                                alias_bool[PlayerIndex] = true
                            end
                        else
                            players[p_table].alias_timer = 0
                            trigger[PlayerIndex] = false
                            cls(PlayerIndex)
                            rprint(PlayerIndex, "Player not present")
                        end
                    else
                        players[p_table].alias_timer = 0
                        trigger[PlayerIndex] = false
                        cls(PlayerIndex)
                        rprint(PlayerIndex, "Invalid player id")
                    end
                    return false
                else
                    rprint(PlayerIndex, "Invalid syntax. Use /" .. settings.mod["Alias System"].base_command .. " [id]")
                    return false
                end
            end
        else
            rprint(PlayerIndex, "Insufficient Permission")
        end
    end
    -- #Teleport Manager
    if (settings.mod["Teleport Manager"].enabled == true) then
        local file_name = settings.mod["Teleport Manager"].dir
        if t[1] ~= nil then
            if t[1] == string.lower(settings.mod["Teleport Manager"].commands[1]) then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Teleport Manager", true, "setwarp") then
                    if t[2] ~= nil then
                        check_file_status(PlayerIndex)
                        if not empty_file then
                            local lines = lines_from(file_name)
                            for k, v in pairs(lines) do
                                if t[2] == v:match("[%a%d+_]*") then
                                    rprint(PlayerIndex, "That portal name already exists!")
                                    canset[PlayerIndex] = false
                                    break
                                else
                                    canset[PlayerIndex] = true
                                end
                            end
                        else
                            canset[PlayerIndex] = true
                        end
                        if t[2] == t[2]:match(mapname) then
                            rprint(PlayerIndex, "Teleport name cannot be the same as the current map name!")
                            canset[PlayerIndex] = false
                        end
                        if canset[PlayerIndex] == true then
                            if PlayerInVehicle(PlayerIndex) then
                                x1, y1, z1 = read_vector3d(get_object_memory(read_dword(get_dynamic_player(PlayerIndex) + 0x11C)) + 0x5c)
                            else
                                x1, y1, z1 = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
                            end
                            local file = io.open(file_name, "a+")
                            local line = t[2] .. " [Map: " .. mapname .. "] X " .. x1 .. ", Y " .. y1 .. ", Z " .. z1
                            file:write(line, "\n")
                            file:close()
                            rprint(PlayerIndex, "Teleport location set to: " .. x1 .. ", " .. y1 .. ", " .. z1)
                        end
                    else
                        rprint(PlayerIndex, "Invalid Syntax. Command Usage: /" .. settings.mod["Teleport Manager"].commands[1] .. " <teleport name>")
                    end
                else
                    rprint(PlayerIndex, "You're not allowed to execute /" .. settings.mod["Teleport Manager"].commands[1])
                end
                return false
            end
        end
        ---------------------------------------------------------
        -- GO TO COMMAND --
        if t[1] ~= nil then
            if t[1] == string.lower(settings.mod["Teleport Manager"].commands[2]) then
                check_file_status(PlayerIndex)
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Teleport Manager", true, "warp") then
                    if t[2] ~= nil then
                        if not empty_file then
                            local found = nil
                            local lines = lines_from(file_name)
                            for k, v in pairs(lines) do
                                local valid = nil
                                if t[2] == v:match("[%a%d+_]*") then
                                    if (player_alive(PlayerIndex)) then
                                        if string.find(v, mapname) then
                                            found = true
                                            -- numbers without decimal points -----------------------------------------------------------------------------
                                            if string.match(v, ("X%s*%d+,%s*Y%s*%d+,%s*Z%s*%d+")) then
                                                valid = true -- 0
                                                x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
                                                y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
                                                z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))
                                            elseif string.match(v, ("X%s*-%d+,%s*Y%s*-%d+,%s*Z%s*-%d+")) then
                                                valid = true -- *
                                                x = string.gsub(string.match(v, "X%s*-%d+"), "X%s*-%d+", string.match(string.match(v, "X%s*-%d+"), "-%d+"))
                                                y = string.gsub(string.match(v, "Y%s*-%d+"), "Y%s*-%d+", string.match(string.match(v, "Y%s*-%d+"), "-%d+"))
                                                z = string.gsub(string.match(v, "Z%s*-%d+"), "Z%s*-%d+", string.match(string.match(v, "Z%s*-%d+"), "-%d+"))
                                            elseif string.match(v, ("X%s*-%d+,%s*Y%s*%d+,%s*Z%s*%d+")) then
                                                valid = true -- 1
                                                x = string.gsub(string.match(v, "X%s*-%d+"), "X%s*-%d+", string.match(string.match(v, "X%s*-%d+"), "-%d+"))
                                                y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
                                                z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))
                                            elseif string.match(v, ("X%s*%d+,%s*Y%s*-%d+,%s*Z%s*%d+")) then
                                                valid = true -- 2
                                                x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
                                                y = string.gsub(string.match(v, "Y%s*-%d+"), "Y%s*-%d+", string.match(string.match(v, "Y%s*-%d+"), "-%d+"))
                                                z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))
                                            elseif string.match(v, ("X%s*%d+,%s*Y%s*%d+,%s*Z%s*-%d+")) then
                                                valid = true -- 3
                                                x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
                                                y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
                                                z = string.gsub(string.match(v, "Z%s*-%d+"), "Z%s*-%d+", string.match(string.match(v, "Z%s*-%d+"), "-%d+"))
                                            elseif string.match(v, ("X%s*-%d+,%s*Y%s*-%d+,%s*Z%s*%d+")) then
                                                valid = true -- 1 & 2
                                                x = string.gsub(string.match(v, "X%s*-%d+"), "X%s*-%d+", string.match(string.match(v, "X%s*-%d+"), "-%d+"))
                                                y = string.gsub(string.match(v, "Y%s*-%d+"), "Y%s*-%d+", string.match(string.match(v, "Y%s*-%d+"), "-%d+"))
                                                z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))
                                            elseif string.match(v, ("X%s*-%d+,%s*Y%s*%d+,%s*Z%s*-%d+")) then
                                                valid = true -- 1 & 3
                                                x = string.gsub(string.match(v, "X%s*-%d+"), "X%s*-%d+", string.match(string.match(v, "X%s*-%d+"), "-%d+"))
                                                y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
                                                z = string.gsub(string.match(v, "Z%s*-%d+"), "Z%s*-%d+", string.match(string.match(v, "Z%s*-%d+"), "-%d+"))
                                            elseif string.match(v, ("X%s*%d+,%s*Y%s*-%d+,%s*Z%s*-%d+")) then
                                                valid = true -- 2 & 3
                                                x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
                                                y = string.gsub(string.match(v, "Y%s*-%d+"), "Y%s*-%d+", string.match(string.match(v, "Y%s*-%d+"), "-%d+"))
                                                z = string.gsub(string.match(v, "Z%s*-%d+"), "Z%s*-%d+", string.match(string.match(v, "Z%s*-%d+"), "-%d+"))
                                                -- numbers with decimal points -----------------------------------------------------------------------------
                                            elseif string.match(v, ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")) then
                                                valid = true -- 0
                                                x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                                y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                                z = string.gsub(string.match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", string.match(string.match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                                            elseif string.match(v, ("X%s*-%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                                valid = true -- *
                                                x = string.gsub(string.match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", string.match(string.match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                                y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                                z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                                            elseif string.match(v, ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")) then
                                                valid = true -- 1
                                                x = string.gsub(string.match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", string.match(string.match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                                y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                                z = string.gsub(string.match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", string.match(string.match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                                            elseif string.match(v, ("X%s*%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*%d+.%d+")) then
                                                valid = true -- 2
                                                x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                                y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                                z = string.gsub(string.match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", string.match(string.match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                                            elseif string.match(v, ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                                valid = true -- 3
                                                x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                                y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                                z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                                            elseif string.match(v, ("X%s*-%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*%d+.%d+")) then
                                                valid = true -- 1 & 2
                                                x = string.gsub(string.match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", string.match(string.match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                                y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                                z = string.gsub(string.match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", string.match(string.match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                                            elseif string.match(v, ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                                valid = true -- 1 & 3
                                                x = string.gsub(string.match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", string.match(string.match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                                y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                                z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                                            elseif string.match(v, ("X%s*%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                                valid = true  -- 2 & 3
                                                x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                                y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                                z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                                            else
                                                rprint(PlayerIndex, "Script Error! Coordinates for that teleport do not match the regex expression!")
                                                cprint("Script Error! Coordinates for that teleport do not match the regex expression!", 4 + 8)
                                            end
                                            if (v ~= nil and valid == true) then
                                                if not PlayerInVehicle(PlayerIndex) then
                                                    local prevX, prevY, prevZ = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
                                                    previous_location[PlayerIndex][1] = prevX
                                                    previous_location[PlayerIndex][2] = prevY
                                                    previous_location[PlayerIndex][3] = prevZ
                                                    write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, tonumber(x), tonumber(y), tonumber(z))
                                                    rprint(PlayerIndex, "Teleporting to [" .. t[2] .. "] " .. math.floor(x) .. ", " .. math.floor(y) .. ", " .. math.floor(z))
                                                    valid = false
                                                else
                                                    TeleportPlayer(read_dword(get_dynamic_player(PlayerIndex) + 0x11C), tonumber(x), tonumber(y), tonumber(z) + 0.5)
                                                    rprint(PlayerIndex, "Teleporting to [" .. t[2] .. "] " .. math.floor(x) .. ", " .. math.floor(y) .. ", " .. math.floor(z))
                                                    valid = false
                                                end
                                            end
                                        else
                                            found = true
                                            rprint(PlayerIndex, "That warp is not linked to this map!")
                                        end
                                    else
                                        found = true
                                        rprint(PlayerIndex, "You cannot teleport when dead!")
                                    end
                                end
                            end
                            if found ~= true then
                                rprint(PlayerIndex, "That teleport name is not valid!")
                            end
                        else
                            rprint(PlayerIndex, "The teleport list is empty!")
                        end
                    else
                        rprint(PlayerIndex, "Invalid Syntax. Command Usage: /" .. settings.mod["Teleport Manager"].commands[2] .. " <teleport name>")
                    end
                else
                    rprint(PlayerIndex, "You're not allowed to execute /" .. settings.mod["Teleport Manager"].commands[2])
                end
                return false
                ---------------------------------------------------------
                -- BACK COMMAND --
            elseif t[1] == string.lower(settings.mod["Teleport Manager"].commands[3]) then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Teleport Manager", true, "back") then
                    if not PlayerInVehicle(PlayerIndex) then
                        if previous_location[PlayerIndex][1] ~= nil then
                            write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, previous_location[PlayerIndex][1], previous_location[PlayerIndex][2], previous_location[PlayerIndex][3])
                            rprint(PlayerIndex, "Returning to previous location!")
                            for i = 1, 3 do
                                previous_location[PlayerIndex][i] = nil
                            end
                        else
                            rprint(PlayerIndex, "Unable to teleport back! You haven't been anywhere!")
                        end
                    end
                else
                    rprint(PlayerIndex, "You're not allowed to execute /" .. settings.mod["Teleport Manager"].commands[3])
                end
                return false
                ---------------------------------------------------------
                -- LIST COMMAND --
            elseif t[1] == string.lower(settings.mod["Teleport Manager"].commands[4]) then
                local found = false
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Teleport Manager", true, "warplist") then
                    check_file_status(PlayerIndex)
                    if not empty_file then
                        local lines = lines_from(file_name)
                        for k, v in pairs(lines) do
                            if string.find(v, mapname) then
                                found = true
                                rprint(PlayerIndex, "[" .. k .. "] " .. v)
                            end
                        end
                        if not found then
                            rprint(PlayerIndex, "There are no warps for the current map.")
                        end
                    else
                        rprint(PlayerIndex, "The teleport list is empty!")
                    end
                else
                    rprint(PlayerIndex, "You're not allowed to execute /" .. settings.mod["Teleport Manager"].commands[4])
                end
                return false
                ---------------------------------------------------------
                -- LIST ALL COMMAND --
            elseif t[1] == string.lower(settings.mod["Teleport Manager"].commands[5]) then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Teleport Manager", true, "warplistall") then
                    check_file_status(PlayerIndex)
                    if not empty_file then
                        local lines = lines_from(file_name)
                        for k, v in pairs(lines) do
                            rprint(PlayerIndex, "[" .. k .. "] " .. v)
                        end
                    else
                        rprint(PlayerIndex, "The teleport list is empty!")
                    end
                else
                    rprint(PlayerIndex, "You're not allowed to execute /" .. settings.mod["Teleport Manager"].commands[5])
                end
                return false
                ---------------------------------------------------------
                -- DELETE COMMAND --
            elseif t[1] == string.lower(settings.mod["Teleport Manager"].commands[6]) then
                local command = t[1]
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Teleport Manager", true, "delwarp") then
                    if t[2] ~= nil then
                        check_file_status(PlayerIndex)
                        if not empty_file then
                            local lines = lines_from(file_name)
                            local del_found = nil
                            for k, v in pairs(lines) do
                                if k ~= nil then
                                    if t[2] == v:match(k) then
                                        del_found = true
                                        response_starting_line = nil
                                        response_num_lines = nil
                                        if string.find(v, mapname) then
                                            delete_from_file(file_name, k, 1, PlayerIndex)
                                            rprint(PlayerIndex, "Successfully deleted teleport id #" .. k)
                                        else
                                            wait_for_response[PlayerIndex] = true
                                            rprint(PlayerIndex, "Warning: That teleport is not linked to this map.")
                                            rprint(PlayerIndex, "Type 'YES' to delete, type 'NO' to cancel.")
                                            response_starting_line = k
                                            response_num_lines = 1
                                        end
                                    end
                                end
                            end
                            if del_found ~= true then
                                rprint(PlayerIndex, "Teleport Index ID does not exist!")
                            end
                        else
                            rprint(PlayerIndex, "The teleport list is empty!")
                        end
                    else
                        rprint(PlayerIndex, "Invalid Syntax. Command Usage: /" .. settings.mod["Teleport Manager"].commands[6] .. " <index id>")
                    end
                else
                    rprint(PlayerIndex, "You're not allowed to execute /" .. settings.mod["Teleport Manager"].commands[6])
                end
                return false
            end
        end
    end
end

-- #List Players
function listPlayers(PlayerIndex, count)
    if (count == 1) then
        rprint(PlayerIndex, "|" .. settings.mod["List Players"].alignment .. " [ ID.    -    Name.    -    Team.    -    IP. ]")
        for i = 1, 16 do
            if player_present(i) then
                local name = get_var(i, "$name")
                local id = get_var(i, "$n")
                local team = get_var(i, "$team")
                local ip = get_var(i, "$ip")
                local hash = get_var(i, "$hash")
                if get_var(0, "$ffa") == "0" then
                    if team == "red" then
                        team = "Red"
                    elseif team == "blue" then
                        team = "Blue"
                    else
                        team = "Hidden"
                    end
                else
                    team = "FFA"
                end
                rprint(PlayerIndex, "|" .. settings.mod["List Players"].alignment .. "     " .. id .. ".         " .. name .. "   |   " .. team ..   "   |   IP: " .. ip)
            end
        end
    else
        rprint(PlayerIndex, "Invalid Syntax")
        return false
    end
end

-- #Command Spy
function CommandSpy(Message)
    for i = 1, 16 do
        if (tonumber(get_var(i, "$lvl"))) >= getPermLevel("Command Spy", nil, nil) then
            rprint(i, Message)
        end
    end
end

-- Used Globally
function read_widestring(address, length)
    local count = 0
    local byte_table = {}
    for i = 1, length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return table.concat(byte_table)
end

-- Used Globally
function table.match(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end

-- Clears the players console
function cls(PlayerIndex)
    for _ = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

-- Used Globally
function tokenizestring(inputString, Separator)
    if Separator == nil then
        Separator = "%s"
    end
    local t = {};
    i = 1
    for str in string.gmatch(inputString, "([^" .. Separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- Used Globally
function getPermLevel(script, bool, args)
    local level = 0
    local trigger = nil
    local permission_table = nil

    if (script ~= nil and bool == nil and args == nil) then
        level = settings.mod[script].permission_level

    elseif (script == nil and bool == nil and args ~= nil) then
        permission_table = settings.global.permission_level
        trigger = true
        
    elseif (script ~= nil and bool == true and args ~= nil) then
        trigger = true
        permission_table = settings.mod["Teleport Manager"].permission_level
    end
    
    if (trigger) and (permission_table ~= nil) then
        for k, v in pairs(permission_table) do
            local words = tokenizestring(v, ",")
            for i = 1, #words do
                if (tostring(k) == args) then
                    level = words[i]
                    break
                end
            end
        end
    end
    return tonumber(level)
end

-- Used Globally
function GetTeamPlay()
    if get_var(0, "$ffa") == "0" then
        return true
    else
        return false
    end
end

-- Used Globally
function lines_from(file)
    lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

-- Used Globally
function PlayerInVehicle(PlayerIndex)
    if (get_dynamic_player(PlayerIndex) ~= 0) then
        local VehicleID = read_dword(get_dynamic_player(PlayerIndex) + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

-- Used Globally
function TeleportPlayer(ObjectID, x, y, z)
    if get_object_memory(ObjectID) ~= 0 then
        local veh_obj = get_object_memory(read_dword(get_object_memory(ObjectID) + 0x11C))
        write_vector3d((veh_obj ~= 0 and veh_obj or get_object_memory(ObjectID)) + 0x5C, x, y, z)
    end
end

-- Saves player join data (name, hash, ip address, id)
function savePlayerData(name, hash, ip, id)
    local a = string.gsub(settings.global.player_data[1], "%%name%%", name)
    local b = string.gsub(settings.global.player_data[2], "%%hash%%", hash)
    local c = string.gsub(settings.global.player_data[3], "%%ip_address%%", ip)
    local d = string.gsub(settings.global.player_data[4], "%%index_id%%", id)
    local data = a .. "\n" .. b .. "\n" .. c .. "\n" .. d
    table.insert(player_data, data)
end

-- Prints enabled scripts | Called by OnScriptLoad()
function printEnabled()
    cprint("\n----- [ BASE GAME SETTINGS ] -----", 3 + 5)
    for k, v in pairs(settings.mod) do
        if (settings.mod[k].enabled == true) then
            cprint(k .. " is enabled", 2 + 8)
        else
            cprint(k .. " is disabled", 4 + 8)
        end
    end
    cprint("----------------------------------\n", 3 + 5)
end

-- #Spawn From Sky
function timeUntilRestore(PlayerIndex)
    local p_table = get_var(PlayerIndex, "$name") .. ", " .. get_var(PlayerIndex, "$hash")
    players[p_table].sky_timer = players[p_table].sky_timer + 0.030
    if (players[p_table].sky_timer >= (settings.mod["Spawn From Sky"].maps[mapname].invulnerability)) then
        players[p_table].sky_timer = 0
        init_timer[tonumber(PlayerIndex)] = false
        execute_command("ungod " .. tonumber(PlayerIndex))
    end
end

-- #Weapon Settings
function loadWeaponTags()
    pistol = "weapons\\pistol\\pistol"
    sniper = "weapons\\sniper rifle\\sniper rifle"
    plasma_cannon = "weapons\\plasma_cannon\\plasma_cannon"
    rocket_launcher = "weapons\\rocket launcher\\rocket launcher"
    plasma_pistol = "weapons\\plasma pistol\\plasma pistol"
    plasma_rifle = "weapons\\plasma rifle\\plasma rifle"
    assault_rifle = "weapons\\assault rifle\\assault rifle"
    flamethrower = "weapons\\flamethrower\\flamethrower"
    needler = "weapons\\needler\\mp_needler"
    shotgun = "weapons\\shotgun\\shotgun"
end

function table.val_to_str (v)
    if "string" == type(v) then
        v = string.gsub(v, "\n", "\\n")
        if string.match(string.gsub(v, "[^'\"]", ""), '^"+$') then
            return "'" .. v .. "'"
        end
        return '"' .. string.gsub(v, '"', '\\"') .. '"'
    else
        return "table" == type(v) and table.tostring(v) or tostring(v)
    end
end

function table.key_to_str (k)
    if "string" == type(k) and string.match(k, "^[_%a][_%a%d]*$") then
        return k
    else
        return "[" .. table.val_to_str(k) .. "]"
    end
end

function table.tostring(tbl)
    local result, done = {}, {}
    for k, v in ipairs(tbl) do
        table.insert(result, table.val_to_str(v))
        done[k] = true
    end
    for k, v in pairs(tbl) do
        if not done[k] then
            table.insert(result, table.key_to_str(k) .. "=" .. table.val_to_str(v))
        end
    end
    return "{" .. table.concat(result, ",") .. "}"
end

function getIP(name, hash, id)
    for k, v in pairs(ip_table) do
        if v then
            local stringToMatch = name .. ", " .. hash .. ", " .. id
            if string.find(v, stringToMatch) then
                local ip = string.match(v, ("&(.+)"))
                local words = tokenizestring(ip, ", ")
                return tostring(words[1])
            end
        end
    end
end

-- #Alias System
function addAlias(name, hash)
    local file_name = settings.mod["Alias System"].dir
    checkFile(file_name)
    local file = io.open(file_name, "r")
    local data = file:read("*a")
    file:close()
    if string.match(data, hash) then
        local lines = lines_from(file_name)
        for k, v in pairs(lines) do
            if string.match(v, hash) then
                if not v:match(name) then
                    local alias = v .. ", " .. name
                    local f = io.open(file_name, "r")
                    local content = f:read("*all")
                    f:close()
                    content = string.gsub(content, v, alias)
                    local f = io.open(file_name, "w")
                    f:write(content)
                    f:close()
                end
            end
        end
    else
        local file = assert(io.open(file_name, "a+"))
        file:write("\n" .. hash .. ":" .. name, "\n")
        file:close()
    end
end

-- Used Globally
function checkFile(dir)
    local file_name = dir
    local file = io.open(file_name, "rb")
    if file then
        file:close()
        return true
    else
        local file = io.open(file_name, "a+")
        if file then
            file:close()
            return true
        end
    end
end

-- #Alias System
function concatValues(PlayerIndex, start_index, end_index)
    local file_name = settings.mod["Alias System"].dir
    local lines = lines_from(file_name)
    for k, v in pairs(lines) do
        if v:match(target_hash) then
            local aliases = string.match(v, (":(.+)"))
            local words = tokenizestring(aliases, ", ")
            local word_table = {}
            local row
            for i = tonumber(start_index), tonumber(end_index) do
                if words[i] ~= nil then
                    table.insert(word_table, words[i])
                    row = table.concat(word_table, ", ")
                end
            end
            if row ~= nil then
                rprint(PlayerIndex, "|" .. settings.mod["Alias System"].alignment .. " " .. row)
            end
            for _ in pairs(word_table) do
                word_table[_] = nil
            end
            break
        end
    end
end

-- #Teleport Manager
function check_file_status(PlayerIndex)
    local file_name = settings.mod["Teleport Manager"].dir
    local fileX = io.open(file_name, "rb")
    if fileX then
        fileX:close()
    else
        local fileY = io.open(file_name, "a+")
        if fileY then
            fileY:close()
        end
        if player_present(PlayerIndex) then
            rprint(PlayerIndex, file_name .. " doesn't exist. Creating...")
            cprint(file_name .. " doesn't exist. Creating...")
        end
    end
    local fileZ = io.open(file_name, "r")
    local line = fileZ:read()
    if line == nil then
        empty_file = true
    else
        empty_file = false
    end
    fileZ:close()
end

-- Used Globally
function delete_from_file(filename, starting_line, num_lines, PlayerIndex)

    local fp = io.open(filename, "r")
    if fp == nil then
        check_file_status(PlayerIndex)
    end
    local content = {}
    i = 1;
    for line in fp:lines() do
        if i < starting_line or i >= starting_line + num_lines then
            content[#content + 1] = line
        end
        i = i + 1
    end
    if i > starting_line and i < starting_line + num_lines then
        rprint(PlayerIndex, "Warning: End of File! No entries to delete.")
        cprint("Warning: End of File! No entries to delete.")
    end
    fp:close()
    fp = io.open(filename, "w+")
    for i = 1, #content do
        fp:write(string.format("%s\n", content[i]))
    end
    fp:close()
end

-- SAPP | Mute Handler
function removeEntry(ip, hash, PlayerIndex)
    local file_name = settings.global.mute_dir
    if checkFile(file_name) then
        local file = io.open(file_name, "r")
        local data = file:read("*a")
        file:close()
        local lines = lines_from(file_name)
        for k, v in pairs(lines) do
            if k ~= nil then
                if string.match(v, ip) and string.match(v, hash) then
                    delete_from_file(file_name, k, 1, PlayerIndex)
                end
            end
        end
    end
end

-- #Color Reservation
function setColor(PlayerIndex, ColorID)
    local player = get_player(PlayerIndex)
    write_byte(player + 0x60, tonumber(ColorID))
    colorres_bool[PlayerIndex] = true
end

function secondsToTime(seconds, places)

    local years = math.floor(seconds / (60 * 60 * 24 * 365))
    seconds = seconds % (60 * 60 * 24 * 365)
    local weeks = math.floor(seconds / (60 * 60 * 24 * 7))
    seconds = seconds % (60 * 60 * 24 * 7)
    local days = math.floor(seconds / (60 * 60 * 24))
    seconds = seconds % (60 * 60 * 24)
    local hours = math.floor(seconds / (60 * 60))
    seconds = seconds % (60 * 60)
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60

    if places == 6 then
        return string.format("%02d:%02d:%02d:%02d:%02d:%02d", years, weeks, days, hours, minutes, seconds)
    elseif places == 5 then
        return string.format("%02d:%02d:%02d:%02d:%02d", weeks, days, hours, minutes, seconds)
    elseif not places or places == 4 then
        return days, hours, minutes, seconds
    elseif places == 3 then
        return string.format("%02d:%02d:%02d", hours, minutes, seconds)
    elseif places == 2 then
        return string.format("%02d:%02d", minutes, seconds)
    elseif places == 1 then
        return string.format("%02", seconds)
    end
end

function isModuleAvailable(name)
    for _, searcher in ipairs(package.searchers or package.loaders) do
        return true
    end
end

function getCurrentVersion(bool)
    if isModuleAvailable("lua_http_client") then 
        ffi = require("ffi")
        ffi.cdef [[
            typedef void http_response;
            http_response *http_get(const char *url, bool async);
            void http_destroy_response(http_response *);
            void http_wait_async(const http_response *);
            bool http_response_is_null(const http_response *);
            bool http_response_received(const http_response *);
            const char *http_read_response(const http_response *);
            uint32_t http_response_length(const http_response *);
        ]]
        http_client = ffi.load("lua_http_client")
        
        local function GetPage(URL)
            local response = http_client.http_get(URL, false)
            local returning = nil
            if http_client.http_response_is_null(response) ~= true then
                local response_text_ptr = http_client.http_read_response(response)
                returning = ffi.string(response_text_ptr)
            end
            http_client.http_destroy_response(response)
            return returning
        end
        
        local url = 'https://raw.githubusercontent.com/Chalwk77/HALO-SCRIPT-PROJECTS/master/INDEV/Base%20Game%20Settings.lua'
        local data = string.match(GetPage(url), 'script_version = %d+.%d+')
        local version = string.gsub(data, "script_version =", "")

        if (bool == true) then
            if (tonumber(version) ~= settings.global.script_version) then
                cprint("============================================================================", 5+8)
                cprint("[BGS] Version "  .. tostring(version) .. " is available for download.")
                cprint("Current version: v" .. settings.global.script_version, 5+8)
                cprint("============================================================================", 5+8)
            else
                cprint("[BGS] Version " .. settings.global.script_version, 2+8)
            end
        end
        return tonumber(version)
    else
        cprint("[BGS] Error: Unable to check for updates. 'lua_http_client' module missing!", 4+8)
    end
end

function OnError(Message)
    print(debug.traceback())
end

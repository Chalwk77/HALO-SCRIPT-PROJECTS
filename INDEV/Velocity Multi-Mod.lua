--[[
--=====================================================================================================--
Script Name: Velocity Multi-Mod (v 1.10), for SAPP (PC & CE)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local settings = { }
-- Configuration [STARTS] ---------------------------------------
local function GameSettings()
    settings = {
        mod = {
            ["Admin Chat"] = {
                enabled = true, -- Enabled = true, Disabled = false
                base_command = "achat", -- /base_command [me | id | */all] [on|off|0|1|true|false)
                permission_level = 1, -- Minimum level required to execute /base_command
                execute_on_others = 4,
                prefix = "[ADMIN CHAT]",
                restore = true,
                environment = "rcon", -- Valid environments: "rcon", "chat".
                -- Message Format
                message_format = { "%prefix% %sender_name% [%index%] %message%" }
            },
            -- # Query a player's hash to check what aliases have been used with it.
            ["Alias System"] = {
                enabled = true,
                base_command = "alias", -- /base_command [id | me ]
                dir = "sapp\\alias.lua", -- Command Syntax: /base_command [id]
                permission_level = 1,
                use_timer = true,
                duration = 10, -- How long should the alias results be displayed for? (in seconds)
                alignment = "l", -- Left = l, Right = r, Center = c, Tab: t
            },
            -- # Custom (separate) join messages for staff on a per-level basis
            ["Admin Join Messages"] = {
                enabled = true,
                messages = {
                    -- [prefix] [message] (note: the joining player's name is automatically inserted between [prefix] and [message])
                    [1] = { "[TRIAL-MOD] ", " joined the server. Everybody hide!" },
                    [2] = { "[MODERATOR] ", " just showed up. Hold my beer!" },
                    [3] = { "[ADMIN] ", " just joined. Hide your bananas!" },
                    [4] = { "[SENIOR-ADMIN] ", " joined the server." },
                }
            },
            ["Anti Impersonator"] = {
                enabled = true,
                action = "kick", -- Valid actions, "kick", "ban"
                reason = "impersonating",
                bantime = 10, -- (In Minutes) -- Set to zero to ban permanently
                users = {
                    { ["Chalwk"] = { "6c8f0bc306e0108b4904812110185edd", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" } },
                    { ["Ro@dhog"] = { "0ca756f62f9ecb677dc94238dcbc6c75", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" } },
                    { ["?hoo"] = { "abd5c96cd22517b4e2f358598147c606", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" } },

                    -- repeat the structure to add more hash entries (assuming you own multiple copies of halo)
                    { ["NAME"] = { "hash1", "hash2", "hash3", "etc..." } },
                },
            },
            ["Chat IDs"] = {
                --[[
                    This feature modifies player chat messages.
                    --> Adds a Player Index ID in front of their name in square [] brackets.
                
                    Example: 
                    Team output: [Chalwk] [1]: This is a test message
                    Global output: Chalwk [1]: This is a test message
                --]]
                enabled = true,
                global_format = { "%sender_name% [%index%]: %message%" },
                team_format = { "[%sender_name%] [%index%]: %message%" },
                use_admin_prefixes = false, -- Set to TRUE to enable the below bonus feature.
                -- Ability to have separate chat formats on a per-admin-level basis...
                trial_moderator = {
                    lvl = 1,
                    "[T-MOD] %sender_name% [%index%]: %message%", -- global
                    "[T-MOD] [%sender_name%] [%index%]: %message%" -- team
                },
                moderator = {
                    lvl = 2,
                    "[MOD] %sender_name% [%index%]: %message%", -- global
                    "[MOD] [%sender_name%] [%index%]: %message%" -- team
                },
                admin = {
                    lvl = 3,
                    "[ADMIN] %sender_name% [%index%]: %message%", -- global
                    "[ADMIN] [%sender_name%] [%index%]: %message%" -- team
                },
                senior_admin = {
                    lvl = 4,
                    "[S-ADMIN] %sender_name% [%index%]: %message%", -- global
                    "[S-ADMIN] [%sender_name%] [%index%]: %message%" -- team
                },
                ignore_list = {
                    "skip",
                }
            },
            -- # Logs chat, commands and quit-join events.
            ["Chat Logging"] = {
                enabled = true,
                dir = "sapp\\Server Chat.txt"
            },
            -- Admins get notified when a player executes a command
            ["Command Spy"] = {
                enabled = true,
                permission_level = 1,
                prefix = "[SPY]",
                hide_commands = true,
                commands_to_hide = {
                    "/accept",
                    "/deny",
                    -- "/afk",
                    -- "/lead",
                    -- "/stfu",
                    -- "/unstfu",
                    -- "/skip",
                    -- repeat the structure to add more entries
                }
            },
            ["Console Logo"] = { -- A nifty console logo (ascii: 'kban')
                enabled = true
            },
            ["Color Reservation"] = {
                enabled = false, -- Enabled = true, Disabled = false
                color_table = {
                    [1] = { "6c8f0bc306e0108b4904812110185edd" }, -- white (Chalwk)
                    [2] = { "available" }, -- black
                    [3] = { "available" }, -- red
                    [4] = { "available" }, -- blue
                    [5] = { "available" }, -- gray
                    [6] = { "available" }, -- yellow
                    [7] = { "available" }, -- green
                    [8] = { "available" }, -- pink
                    [9] = { "available" }, -- purple
                    [10] = { "available" }, -- cyan
                    [11] = { "available" }, -- cobalt
                    [12] = { "available" }, -- orange
                    [13] = { "abd5c96cd22517b4e2f358598147c606" }, -- teal (Shoo)
                    [14] = { "0ca756f62f9ecb677dc94238dcbc6c75" }, -- sage (Ro@dhod)
                    [15] = { "available" }, -- brown
                    [16] = { "available" }, -- tan
                    [17] = { "available" }, -- maroon
                    [18] = { "available" } -- salmon
                }
            },
            ["Cute"] = {
                -- # What cute things did you do today? (requested by Shoo)
                enabled = true,
                base_command = "cute",

                -- Use %executors_name% (optional) variable to output the executor's name.
                -- Use %target_name% (optional) variable to output the target's name.

                messages = {
                    -- Target sees this message
                    "%target_name%, what cute things did you do today?",
                    -- Command response (to executor)
                    "[you] -> %target_name%, what cute things did you do today?",
                },
                permission_level = -1,
                environment = "chat" -- Valid environments: "rcon", "chat".
            },
            ["Custom Weapons"] = {
                enabled = false, -- Enabled = true, Disabled = false
                assign_weapons = false,
                assign_custom_frags = false,
                assign_custom_plasmas = false,
                weapons = {

                    -- [!] WARNING: 4th weapon slot is usually reserved for the objective (flag/oddball).
                    -- If this slot is occupied, you cannot pick up the objective.

                    -- [slot1,slot2,slot3,slot4] [frags,plasmas] [map enabled/disabled (true or false)]

                    -- If you don't want to utilize custom grenade assignments for a given map, 
                    -- and would prefer to use the game-type settings for grenade assignments instead, set the respective grenade type count to "00" (double zero).

                    -- If you want to utilize a given map for grenade assignment but not weapon assignments, set all 4 weapon slots to 'nil'.
                    -- You will spawn with default weapons set in the game-type settings.

                    -- If you want to utilize weapon assignments but don't want to spawn with grenades (at all) on a given map, 
                    -- set the respective grenade type count to '0' (single 0).

                    -- To completely disable custom weapon and grenade assignment for a given map, set the last value to 'false'

                    ["beavercreek"] = { pistol, sniper, nil, nil, 00, 00, false },
                    ["bloodgulch"] = { sniper, pistol, needler, nil, 2, 2, false },
                    ["boardingaction"] = { shotgun, pistol, nil, nil, 1, 3, false },
                    ["carousel"] = { sniper, pistol, shotgun, nil, 2, 2, false },
                    ["dangercanyon"] = { pistol, rocket_launcher, assault_rifle, nil, 00, 00, false },
                    ["deathisland"] = { sniper, pistol, assault_rifle, nil, 1, 1, false },
                    ["gephyrophobia"] = { sniper, pistol, rocket_launcher, nil, 3, 3, false },
                    ["icefields"] = { pistol, assault_rifle, nil, nil, 2, 3, false },
                    ["infinity"] = { pistol, sniper, rocket_launcher, nil, 4, 4, false },
                    ["sidewinder"] = { pistol, rocket_launcher, plasma_cannon, nil, 3, 2, false },
                    ["timberland"] = { pistol, assault_rifle, needler, nil, 3, 3, false },
                    ["hangemhigh"] = { pistol, shotgun, nil, nil, 2, 2, false },
                    ["ratrace"] = { assault_rifle, pistol, nil, nil, 0, 0, false },
                    ["damnation"] = { assault_rifle, pistol, nil, nil, 1, 3, false },
                    ["putput"] = { plasma_pistol, plasma_rifle, nil, nil, 1, 1, false },
                    ["prisoner"] = { pistol, rocket_launcher, nil, nil, 1, 1, false },
                    ["wizard"] = { pistol, sniper, nil, nil, 0, 0, true },
                    -- [ custom maps ]...
                    -- place custom weapon tag IDs in the loadWeaponTags() function and assign a variable name to them.
                    -- Repeat the structure to add more maps.
                    ["room_final"] = { rocket_launcher, nil, nil, nil, 00, 00, true },
                    ["dead_end"] = { pistol, assault_rifle, nil, nil, 00, 00, true },
                    ["gruntground"] = { needler, nil, nil, nil, 1, 1, true },
                    ["feelgoodinc"] = { rocket_launcher, nil, nil, nil, 00, 00, true },
                    ["lolcano"] = { rocket_launcher, nil, nil, nil, 00, 00, true },
                    ["camden_place"] = { pistol, nil, nil, nil, 00, 00, true },
                    ["alice_gulch"] = { pistol, nil, nil, nil, 00, 00, true },
                    ["snowdrop"] = { battle_rifle, pistol, nil, nil, 00, 00, true },
                },
            },
            ["Enter Vehicle"] = {
                enabled = true,
                base_command = "enter", -- /base_command <item> [id] (opt height/distance)
                permission_level = 1,
                execute_on_others = 4,
                multi_control = true,
                -- Destroy objects spawned:
                garbage_collection = {
                    on_death = true,
                    on_disconnect = true,
                },
            },
			-- Used for Item Spawner and Enter Vehicle
            ["Garbage Collection"] = {
                enabled = true,
                base_command = "clean", -- /base_command <item> [id] (opt height/distance)
                permission_level = 1,
                execute_on_others = 4,
            },
            ["Infinity Ammo"] = {
                enabled = true,
                server_override = false, -- If this is enabled, all players will have Infinity (perma-ammo) by default (the /infammo command cannot be used)
                base_command = "infammo",
                announcer = true, -- If this is enabled then all players will be alerted when someone goes into Infinity Ammo mode.
                permission_level = 1,
                multiplier_min = 0.001, -- minimum damage multiplier
                multiplier_max = 10, -- maximum damage multiplier
            },
            ["Item Spawner"] = {
                enabled = true,
                base_command = "spawn",  -- /base_command <item> [id]
                permission_level = 1,
                execute_on_others = 4,
                -- Destroy objects spawned:
                garbage_collection = {
                    on_death = true,
                    on_disconnect = true,
                },
                list = "itemlist",
                distance_from_playerX = 2.5,
                distance_from_playerY = 2.5,
                objects = {
                    -- "Item Name", "tag type", "tag name"
                    [1] = { "cyborg", "bipd", "characters\\cyborg_mp\\cyborg_mp" },

                    -- Equipment
                    [2] = { "camo", "eqip", "powerups\\active camouflage" },
                    [3] = { "health", "eqip", "powerups\\health pack" },
                    [4] = { "overshield", "eqip", "powerups\\over shield" },
                    [5] = { "frag", "eqip", "weapons\\frag grenade\\frag grenade" },
                    [6] = { "plasma", "eqip", "weapons\\plasma grenade\\plasma grenade" },

                    -- Vehicles
                    [7] = { "banshee", "vehi", "vehicles\\banshee\\banshee_mp" },
                    [8] = { "turret", "vehi", "vehicles\\c gun turret\\c gun turret_mp" },
                    [9] = { "ghost", "vehi", "vehicles\\ghost\\ghost_mp" },
                    [10] = { "tank", "vehi", "vehicles\\scorpion\\scorpion_mp" },
                    [11] = { "rhog", "vehi", "vehicles\\rwarthog\\rwarthog" },
                    [12] = { "hog", "vehi", "vehicles\\warthog\\mp_warthog" },

                    -- Weapons
                    [13] = { "rifle", "weap", "weapons\\assault rifle\\assault rifle" },
                    [14] = { "ball", "weap", "weapons\\ball\\ball" },
                    [15] = { "flag", "weap", "weapons\\flag\\flag" },
                    [16] = { "flamethrower", "weap", "weapons\\flamethrower\\flamethrower" },
                    [17] = { "needler", "weap", "weapons\\needler\\mp_needler" },
                    [18] = { "pistol", "weap", "weapons\\pistol\\pistol" },
                    [19] = { "ppistol", "weap", "weapons\\plasma pistol\\plasma pistol" },
                    [20] = { "prifle", "weap", "weapons\\plasma rifle\\plasma rifle" },
                    [21] = { "frg", "weap", "weapons\\plasma_cannon\\plasma_cannon" },
                    [22] = { "rocket", "weap", "weapons\\rocket launcher\\rocket launcher" },
                    [23] = { "shotgun", "weap", "weapons\\shotgun\\shotgun" },
                    [24] = { "sniper", "weap", "weapons\\sniper rifle\\sniper rifle" },

                    -- Projectiles
                    [25] = { "sheebolt", "proj", "vehicles\\banshee\\banshee bolt" },
                    [26] = { "sheerod", "proj", "vehicles\\banshee\\mp_banshee fuel rod" },
                    [27] = { "turretbolt", "proj", "vehicles\\c gun turret\\mp gun turret" },
                    [28] = { "ghostbolt", "proj", "vehicles\\ghost\\ghost bolt" },
                    [29] = { "tankbullet", "proj", "vehicles\\scorpion\\bullet" },
                    [30] = { "tankshell", "proj", "vehicles\\scorpion\\tank shell" },
                    [31] = { "hogbullet", "proj", "vehicles\\warthog\\bullet" },
                    [32] = { "riflebullet", "proj", "weapons\\assault rifle\\bullet" },
                    [33] = { "flame", "proj", "weapons\\flamethrower\\flame" },
                    [34] = { "needle", "proj", "weapons\\needler\\mp_needle" },
                    [35] = { "pistolbullet", "proj", "weapons\\pistol\\bullet" },
                    [36] = { "ppistolbolt", "proj", "weapons\\plasma pistol\\bolt" },
                    [37] = { "priflebolt", "proj", "weapons\\plasma rifle\\bolt" },
                    [38] = { "priflecbolt", "proj", "weapons\\plasma rifle\\charged bolt" },
                    [39] = { "rocketproj", "proj", "weapons\\rocket launcher\\rocket" },
                    [40] = { "shottyshot", "proj", "weapons\\shotgun\\pellet" },
                    [41] = { "snipershot", "proj", "weapons\\sniper rifle\\sniper bullet" },
                    [42] = { "fuelrodshot", "proj", "weapons\\plasma_cannon\\plasma_cannon" },

                    -- Custom Vehicles [ Bitch Slap ]
                    [43] = { "slap1", "vehi", "deathstar\\1\\vehicle\\tag_2830" }, -- Chain Gun Hog
                    [44] = { "slap2", "vehi", "deathstar\\1\\vehicle\\tag_3215" }, -- Quad Bike
                    [45] = { "wraith", "vehi", "vehicles\\wraith\\wraith" },
                    [46] = { "pelican", "vehi", "vehicles\\pelican\\pelican" },
                    -- Custom Weapons ...
                }
            },
            -- # This is a spectator-like feature.
            ["Lurker"] = {
                -- To enable a feature, set 'false' to 'true'
                enabled = true,
                base_command = "lurker", -- /base_command [me | id | */all] [on|off|0|1|true|false)
                permission_level = -1,
                execute_on_others = 4, -- Permission level needed to set for others.
                announcer = true, -- If this is enabled then all players will be alerted when someone goes into lurker mode.
                speed = true,
                god = true,
                camouflage = true,
                running_speed = 2, -- Speed boost applied (default running speed is 1)
                default_running_speed = 1, -- Speed the player returns to when they exit out of Lurker Mode.

                -- If the player picks up the oddball or flag, they receive a warning and are asked to drop the objective.
                -- If they do not drop the objective before the timer reaches 0, they are killed automatically.
                -- Warnings are given immediately upon picking up the objective.
                -- If the player has no warnings left their Lurker will be disabled (however, not revoked).
                -- ...
                time_until_death = 10, -- Time (in seconds) until the player is killed after picking up the objective.
                warnings = 4,
            },
            ["Message Board"] = {
                enabled = false,
                duration = 5, -- How long should the message be displayed on screen for? (in seconds)
                alignment = "l", -- Left = l, Right = r, Center = c, Tab: t
                -- Use %server_name% variable to output the server name.
                -- Use %player_name% variable to output the joining player's name.
                messages = {
                    "Welcome to %server_name%",
                    -- repeat the structure to add more entries
                }
            },
            ["Mute System"] = {
                enabled = true,
                dir = "sapp\\mutes.txt",
                permission_level = 1,
                can_mute_admins = true,
                mute_command = "mute",
                unmute_command = "unmute",
                mutelist_command = "mutelist",
                default_mute_time = 525600,
            },
            ["Portal Gun"] = {
                enabled = true,
                base_command = "portalgun", -- /base_command [me | id | */all] [on|off|0|1|true|false)
                announcer = true, -- If this is enabled then all players will be alerted when someone goes into Portal Gun mode.
                permission_level = 1,
                execute_on_others = 4,
            },
            -- # An alternative player list mod. Overrides SAPP's built in /pl command.
            ["Player List"] = {
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
            ["Respawn Time"] = {
                enabled = true,
                permission_level = 1,
                execute_on_others = 4,
                base_command = "setrespawn",
                -- [ This enables you to set the default re-spawn time for all maps and game types. 
                -- When enabled, the custom respawn settings in the 'maps' table have no effect.
                global_respawn_time = {
                    enabled = false,
                    time = 3
                },
                -- ]
                maps = {
                    -- CTF, SLAYER, TEAM-S, KOTH, TEAM-KOTH, ODDBALL, TEAM-ODDBALL, RACE, TEAM-RACE
                    ["beavercreek"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["bloodgulch"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["boardingaction"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["carousel"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["dangercanyon"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["deathisland"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["gephyrophobia"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["icefields"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["infinity"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["sidewinder"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["timberland"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["hangemhigh"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["ratrace"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["damnation"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["putput"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["prisoner"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["wizard"] = { 0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["tactics"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["gruntground"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["lolcano"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["homestead"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["camden_place"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["olympus_mons"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["chaosgulchv2"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["enigma"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["extinction"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["coldsnap"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["mario64"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["dead-end"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["destinycanyon"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["immure"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["sneak"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["windfall_island"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["feelgoodinc"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["battlegulch_v2_chaos"] = { 0.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["ragnarok"] = { 0.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["celebration_island"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["doom_wa_view"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["garden_ce"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["sciophobiav2"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["portent"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["pitfall"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["quagmire"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["baz_canyon"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["bigass"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["pardis_perdu"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["insomnia_map"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["zanzibar_intense"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["deltaruined_intense"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["knot"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 0.5, 0.5 },
                    ["juggernaught"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["room_final"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["yoyorast island v2"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["h3 foundry"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["cliffhanger"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["snowtorn_cove"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["h3 foundry"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["remnants"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["temprate"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["pueblo_fantasma_beta"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["combat_arena"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["h2_new_mombasa"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["h2_zanzibar"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["lavaflows"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["runway-mod"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["medical block"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["[hsp]the-pit"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["abandonment"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["ambush"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["armageddon"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["augury"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["bitch_slap"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["crimson_woods"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["fission_point"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["h2 coagulation"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["ministunt"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["no_remorse"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["sledding02"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["train.station"] = { 3.0, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 }
                }
            },
            ["Suggestions Box"] = {
                -- Players can suggest features or maps using /suggest {message}. Suggestions are saved to suggestions.txt
                enabled = true,
                base_command = "suggestion", -- /base_command {message}
                permission_level = -1, -- Minimum privilege level required to execute /suggestion (-1 for all players, 1-4 for admins)
                dir = "sapp\\suggestions.txt", -- file directory
                msg_format = "[%time_stamp%] %player_name%: %message%", -- Message format saved to suggestions.txt
                response = "Thank you for your suggestion, %player_name%" -- Message sent to the player when they execute /suggestion
            },
            ["Teleport Manager"] = {
                enabled = true,
                dir = "sapp\\teleports.txt",
                execute_on_others = 4,
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
        },
        global = {
            script_version = 1.10,
            beepOnLoad = false,
            beepOnJoin = true,
            check_for_updates = false,
            server_prefix = "**SERVER** ",
            plugin_commands = {
                velocity = { "velocity", -1 }, -- /velocity
                enable = { "enable", 1 }, -- /enable [id]
                disable = { "disable", 1 }, -- /disable [id]
                list = { "plugins", 1 }, -- /pluigns
                clearchat = { "clear", 1 }, -- /clear
            },
            -- Do not Touch...
            player_data = {
                "Player: %name%",
                "CD Hash: %hash%",
                "IP Address: %ip_address%",
                "Index ID: %index_id%",
                "Privilege Level: %level%",
                -------------------------------
            },
        }
    }
end
-- Configuration [ENDS] -----------------------------------------

-- Tables used Globally
local velocity, player_info = { }, { }
local players
local function InitPlayers()
    players = {
        ["Alias System"] = { },
        ["Message Board"] = { },
        ["Admin Chat"] = { },
        ["Lurker"] = { },
    }
end
-- String Library, Math Library, Table Library
local sub, gsub, find, lower, format, match, gmatch = string.sub, string.gsub, string.find, string.lower, string.format, string.match, string.gmatch
local floor = math.floor
local concat = table.concat

local function getip(p, bool)
    if (bool) then
        return get_var(p, "$ip"):match("(%d+.%d+.%d+.%d+)")
    else
        return get_var(p, "$ip"):match("(%d+.%d+.%d+.%d+:%d+)")
    end
end

local velocity = { }

local mapname = ""
local ce
local console_address_patch = nil
local game_over

-- #Color Reservation
local colorres_bool = {}
local can_use_colorres

-- #Item Spawner
local temp_objects_table = {}

-- #Enter Vehicle
local ev = {}
local ev_Status = {}
local ev_NewVehicle = {}
local ev_OldVehicle = {}

-- drones
local EV_drone_table = {}
local IS_drone_table = {}
local item_objects = {}

-- Mute Handler
local mute_table = { }

-- #Custom Weapons
local weapon = {}

-- #Infinity Ammo
local infammo = {}
local frag_check = {}
local modify_damage = {}
local damage_multiplier = {}

-- #Portal Gun
local weapon_status = {}
local portalgun_mode = {}

-- #Respawn Time
local respawn_cmd_override = { }
local respawn_time = { }

-- #Lurker
local lurker = {}
local object_picked_up = {}
local has_objective = {}
local lurker_warnings = {}
local scores = { }

-- #Teleport Manager
local canset = {}
local wait_for_response = {}
local previous_location = {}
for i = 1, 16 do
    previous_location[i] = {}
end

local function getServerName()
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local sv_name = read_widestring(network_struct + 0x8, 0x42)
    return sv_name
end

local function adjust_ammo(PlayerIndex)
    for i = 1, 4 do
        execute_command("ammo " .. tonumber(PlayerIndex) .. " 999 " .. i)
        execute_command("mag " .. tonumber(PlayerIndex) .. " 100 " .. i)
        execute_command("battery " .. tonumber(PlayerIndex) .. " 100 " .. i)
    end
end

local function DisableInfAmmo(TargetID)
    infammo[TargetID] = false
    frag_check[TargetID] = false
    modify_damage[TargetID] = false
    damage_multiplier[TargetID] = 0
end

local function isConsole(e)
    if (e) then
        if (e ~= -1 and e >= 1 and e < 16) then
            return false
        else
            return true
        end
    end
end

-- Checks if the MOD being called is enabled in settings.
local function modEnabled(script, e)
    if (settings.mod[script].enabled) then
        return true
    elseif (e) then
        respond(e, "Command Failed. " .. script .. " is disabled", "rcon", 4 + 8)
    end
end

-- Returns the require permission level of the respective mod.
local function getPermLevel(script, bool, p)
    local p = p or nil
    if not (bool) and (p == nil) then
        return tonumber(settings.mod[script].permission_level)
    elseif (bool) and (p == nil) then
        return tonumber(settings.mod[script].execute_on_others)
    elseif not (bool) and (p ~= nil) then
        return tonumber(settings.mod[script].permission_level[p.cmd])
    end
end

-- Checks if the player can execute this command on others
local function executeOnOthers(e, self, is_console, level, script)
    if not (self) and not (is_console)then
        if tonumber(level) >= getPermLevel(script, true) then
            return true
        else
            respond(e, "You are not allowed to executed this command on other players.", "rcon", 4 + 8)
            return false
        end
    else
        return true
    end
end

local function populateInfoTable(p)
    player_info[p] = { }
    if (halo_type == "PC") then
        ce = 0x0
    else
        ce = 0x40
    end
    local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local cns = ns + 0x1AA + ce + to_real_index(p) * 0x20
    local name, hash = read_widestring(cns, 12), get_var(p, "$hash")
    local ip, id, level = get_var(p, "$ip"), get_var(p, "$n"), tonumber(get_var(p, "$lvl"))
    local a, b, c, d, e
    local tab = settings.global.player_data
    for i = 1, #tab do
        if tab[i]:match("%%name%%") then
            a = gsub(tab[i], "%%name%%", name)
        elseif tab[i]:match("%%hash%%") then
            b = gsub(tab[i], "%%hash%%", hash)
        elseif tab[i]:match("%%index_id%%") then
            d = gsub(tab[i], "%%index_id%%", id)
        elseif tab[i]:match("%%ip_address%%") then
            c = gsub(tab[i], "%%ip_address%%", ip)
        elseif tab[i]:match("%%level%%") then
            e = gsub(tab[i], "%%level%%", level)
        end
    end
    table.insert(player_info[p], { ["name"] = a, ["hash"] = b, ["ip"] = c, ["id"] = d, ["level"] = e })
end

local function getPlayerInfo(Player, ID)
    if player_present(Player) then
        if player_info[Player] ~= nil or player_info[Player] ~= {} then
            for key, _ in ipairs(player_info[Player]) do
                return player_info[Player][key][ID]
            end
        else
            return error('getPlayerInfo() -> Unable to get ' .. ID)
        end
    end
end

local function announce(PlayerIndex, message)
    for i = 1, 16 do
        if (player_present(i) and i ~= PlayerIndex) then
            say(i, message)
        end
    end
end

-- #Alias System ---------------------------------------------
local max_columns, max_results = 5, 100
local startIndex, endIndex = 1, max_columns
local spaces = 2
local alias, alias_results = { }, { }
local initialStartIndex, known_pirated_hashes
local function PreLoad()
    initialStartIndex = tonumber(startIndex)
    known_pirated_hashes = { }
    known_pirated_hashes = {
        "388e89e69b4cc08b3441f25959f74103",
        "81f9c914b3402c2702a12dc1405247ee",
        "c939c09426f69c4843ff75ae704bf426",
        "13dbf72b3c21c5235c47e405dd6e092d",
        "29a29f3659a221351ed3d6f8355b2200",
        "d72b3f33bfb7266a8d0f13b37c62fddb",
        "76b9b8db9ae6b6cacdd59770a18fc1d5",
        "55d368354b5021e7dd5d3d1525a4ab82",
        "d41d8cd98f00b204e9800998ecf8427e",
        "c702226e783ea7e091c0bb44c2d0ec64",
        "f443106bd82fd6f3c22ba2df7c5e4094",
        "10440b462f6cbc3160c6280c2734f184",
    }
end
-- #Alias System
function alias:reset(ip)
    players["Alias System"][ip] = {
        eid = 0,
        timer = 0,
        total = 0,
        bool = false,
        trigger = false,
        shared = false,
        check_pirated_hash = false,
    }
end
--------------------------------------------------------------
-- #Message Board
local messageBoard = { }
local m_board = { }
local function set(Player, ip)
    m_board[ip] = { }
    local tab = settings.mod["Message Board"].messages
    for i = 1, #tab do
        if (tab[i]) then
            table.insert(m_board[ip], tab[i])
        end
    end
    for _, v in pairs(m_board[ip]) do
        for j = 1, #m_board[ip] do
            m_board[ip][j] = gsub(gsub(m_board[ip][j], "%%server_name%%", getServerName()), "%%player_name%%", get_var(Player, "$name"))
        end
    end
end

function messageBoard:show(Player, ip)
    set(Player, ip)
    players["Message Board"][ip] = {
        timer = 0,
        show = true,
    }
end

function messageBoard:hide(PlayerIndex, ip)
    players["Message Board"][ip] = nil
    m_board[ip] = nil
    cls(PlayerIndex)
end
--------------------------------------------------------------
-- #Admin Chat
local adminchat, achat_status = {}, { }
local achat_data = {}
function adminchat:set(ip)
    players["Admin Chat"][ip] = {
        adminchat = false,
        boolean = false,
    }
end
--------------------------------------------------------------
-- #Lurker
function velocity:LurkerReset(ip)
    players["Lurker"][ip] = {
        lurker_warn = false,
        lurker_timer = 0,
        lurker_warnings = settings.mod["Lurker"].warnings,
    }
end
local function getWarnings(ip)
    return players["Lurker"][ip].lurker_warnings
end
--------------------------------------------------------------

function OnScriptLoad()
    InitPlayers()
    loadWeaponTags()
    GameSettings()
    printEnabled()
    if (settings.global.check_for_updates) then
        getCurrentVersion(true)
    else
        cprint("[VELOCITY] Current Version: " .. settings.global.script_version, 2 + 8)
    end
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")

    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")

    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPrespawn")

    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    
    register_callback(cb['EVENT_DIE'], "OnPlayerKill")

    register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
    register_callback(cb['EVENT_WEAPON_DROP'], "OnWeaponDrop")
    
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")

    if (settings.global.beepOnLoad) then
        execute_command_sequence("beep 1200 200; beep 1200 200; beep 1200 200")
    end

    -- #Alias System
    if modEnabled("Alias System") then
        checkFile(settings.mod["Alias System"].dir)
        resetAliasParams()
        PreLoad()
    end
    
    if modEnabled("Teleport Manager") then
        checkFile(settings.mod["Teleport Manager"].dir)
    end
    
    -- #Mute System
    if modEnabled("Mute System") then
        checkFile(settings.mod["Mute System"].dir)
    end

    -- #Suggestions Box
    if modEnabled("Suggestions Box") then
        checkFile(settings.mod["Suggestions Box"].dir)
    end

    -- #Chat Logging
    if modEnabled("Chat Logging") then
        checkFile(settings.mod["Chat Logging"].dir)
    end

    -- #Custom Weapons
    if modEnabled("Custom Weapons") then
        if not (game_over) then
            if get_var(0, "$gt") ~= "n/a" then
                mapname = get_var(0, "$map")
            end
        end
    end

    for i = 1, 16 do
        if player_present(i) then
            populateInfoTable(i)
            local ip = get_var(i, "$ip")
            local level = tonumber(get_var(i, "$lvl"))

            -- #Admin Chat
            if modEnabled("Admin Chat") then
                if not (game_over) and tonumber(level) >= getPermLevel("Admin Chat", false) then
                    players["Admin Chat"][ip] = nil
                    adminchat:set(ip)
                end
            end
            
            -- #Lurker
            if modEnabled("Lurker") then
                if tonumber(level) >= getPermLevel("Lurker", false) then
                    velocity:LurkerReset(ip)
                end
                
            end
            
            -- #Mute System
            if modEnabled("Mute System") then
                local p, ip, name = { }, getip(i), get_var(i, "$name")
                p.tip = ip
                local muted = velocity:loadMute(p)
                if (muted ~= nil) and (ip == muted[1]) then
                    p.name, p.time, p.tid = name, muted[3], tonumber(i)
                    velocity:saveMute(p, true, true)
                end
            end
            
            -- #Message Board
            if modEnabled("Message Board") then
                if (players["Message Board"][ip] ~= nil) then
                    messageBoard:hide(i, ip)
                end
            end
        end
    end

    -- #Console Logo
    if modEnabled("Console Logo") then
        --noinspection GlobalCreationOutsideO
        function consoleLogo()
            -- Logo: ascii: 'kban'
            cprint("================================================================================", 2 + 8)
            cprint(os.date("%A, %d %B %Y - %X"), 6)
            cprint("")
            cprint("     '||'  '||'     |     '||'       ..|''||           ..|'''.| '||''''|  ", 4 + 8)
            cprint("      ||    ||     |||     ||       .|'    ||        .|'     '   ||  .    ", 4 + 8)
            cprint("      ||''''||    |  ||    ||       ||      ||       ||          ||''|    ", 4 + 8)
            cprint("      ||    ||   .''''|.   ||       '|.     ||       '|.      .  ||       ", 4 + 8)
            cprint("     .||.  .||. .|.  .||. .||.....|  ''|...|'         ''|....'  .||.....| ", 4 + 8)
            cprint("               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
            cprint("                     " .. getServerName(), 0 + 8)
            cprint("               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
            cprint("")
            cprint("================================================================================", 2 + 8)
        end
        timer(50, "consoleLogo")
    end
    local rcon = sig_scan("B8????????E8??000000A1????????55")
    if (rcon ~= 0) then
        console_address_patch = read_dword(rcon + 1)
        safe_write(true)
        write_byte(console_address_patch, 0)
        safe_write(false)
    end
    -- Register Console to Table
    alias:reset("000.000.000.000")
end

function OnScriptUnload()
    for i = 1, 16 do
        if player_present(i) then
            local ip = get_var(i, "$ip")
            local level = tonumber(get_var(i, "$lvl"))
            -- #Admin Chat
            if modEnabled("Admin Chat") then
                if not (game_over) and tonumber(level) >= getPermLevel("Admin Chat", false) then
                    players["Admin Chat"][ip].adminchat = false
                    players["Admin Chat"][ip].boolean = false
                end
            end
            -- #Mute System
            if modEnabled("Mute System") then
                local ip, name = getip(i), get_var(i, "$name")
                if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
                    local p = { }
                    p.tip, p.name, p.time, p.tid = ip, name, mute_table[ip].remaining, tonumber(i)
                    velocity:saveMute(p, false, true)
                end
            end
        end
    end
    if console_address_patch ~= nil then
        safe_write(true)
        write_byte(console_address_patch, 0x72)
        safe_write(false)
    end
end

function OnNewGame()
    -- Used Globally
    game_over = false
    mapname = get_var(0, "$map")

    PreLoad()
    resetAliasParams()
    for i = 1, 16 do
        if player_present(i) then
            local ip = get_var(i, "$ip")
            local level = tonumber(get_var(i, "$lvl"))

            -- #Message Board
            if modEnabled("Message Board") then
                if (players["Message Board"][ip] ~= nil) then
                    messageBoard:hide(i, ip)
                end
            end

            -- #Admin Chat
            if modEnabled("Admin Chat") then
                if not (game_over) and tonumber(level) >= getPermLevel("Admin Chat", false) then
                    players["Admin Chat"][ip].adminchat = false
                    players["Admin Chat"][ip].boolean = false
                end
            end

            -- #Lurker
            if modEnabled("Lurker") then
                if tonumber(level) >= getPermLevel("Lurker", false) then
                    velocity:LurkerReset(ip)
                end
            end
        end
    end

    -- #Chat Logging
    if modEnabled("Chat Logging") then
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

    -- #Color Reservation
    if modEnabled("Color Reservation") then
        if (getTeamPlay()) then
            can_use_colorres = false
        else
            can_use_colorres = true
        end
    end
    
    -- #Item Spawner
    if modEnabled("Item Spawner") then
        local objects_table = settings.mod["Item Spawner"].objects
        for i = 1, #objects_table do
            temp_objects_table[#temp_objects_table + 1] = objects_table[i][1]
        end
    end
end

function OnGameEnd()
    -- Prevents displaying chat ids when the game is over.
    -- Otherwise map voting breaks.
    game_over = true

    resetAliasParams()
    for i = 1, 16 do
        if player_present(i) then
            local ip = get_var(i, "$ip")
            local level = get_var(i, "$lvl")

            -- #Custom Weapons
            if modEnabled("Custom Weapons") and (settings.mod["Custom Weapons"].assign_weapons) then
                weapon[i] = false
            end

            
            -- #Mute System
            if modEnabled("Mute System") then
                local ip, name = getip(i), get_var(i, "$name")
                if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
                    local p = { }
                    p.tip, p.name, p.time, p.tid = ip, name, mute_table[ip].remaining, tonumber(i)
                    velocity:saveMute(p, false, false)
                end
            end
            
            -- #Message Board
            if modEnabled("Message Board") then
                if (players["Message Board"][ip] ~= nil) then
                    messageBoard:hide(i, ip)
                end
            end

            -- #Respawn Time
            if modEnabled("Respawn Time") then
                respawn_cmd_override[ip] = false
                respawn_time[ip] = 0
            end
            
            -- #Admin Chat
            if modEnabled("Admin Chat") then
                local mod = players["Admin Chat"][ip]
                local restore = settings.mod["Admin Chat"].restore
                if tonumber(level) >= getPermLevel("Admin Chat", false) then
                    if (restore) then
                        local bool
                        if (mod.adminchat) then
                            bool = "true"
                        else
                            bool = "false"
                        end
                        achat_status[ip] = bool
                        achat_data[achat_status] = achat_data[achat_status] or {}
                        table.insert(achat_data[achat_status], tostring(achat_status[ip]))
                    else
                        mod.adminchat = false
                        mod.boolean = false
                    end
                end
            end

            -- #Lurker
            if modEnabled("Lurker") then
                if tonumber(level) >= getPermLevel("Lurker", false) then
                    velocity:LurkerReset(ip)
                end
            end
        end
    end

    -- #Chat Logging
    if modEnabled("Chat Logging") then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local data = os.date("[%A %d %B %Y] - %X - The game is ending - ")
            file:write(data)
            file:close()
        end
    end
    cprint("The Game Has Ended | Map Voting has begun.", 4 + 8)
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            local ip = get_var(i, "$ip")

            -- #Custom Weapons
            local wTab = settings.mod["Custom Weapons"]
            if modEnabled("Custom Weapons") and (wTab.assign_weapons) then
                if wTab.weapons[mapname] ~= nil then
                    if (player_alive(i)) then
                        if (weapon[i] == true) then
                            local player = get_dynamic_player(i)
                            local x, y, z = read_vector3d(player + 0x5C)
                            local primary, secondary, tertiary, quaternary, Slot = select(1, determineWeapon())

                            if (primary) or (secondary) or (tertiary) or (quaternary) then
                                execute_command("wdel " .. i)
                            end

                            if (secondary) then
                                assign_weapon(spawn_object("weap", secondary, x, y, z), i)
                            end

                            if (primary) then
                                assign_weapon(spawn_object("weap", primary, x, y, z), i)
                            end

                            if (Slot == 3 or Slot == 4) then
                                timer(100, "delayAssignMore", player, x, y, z)
                            end
                            function delayAssignMore(player, x, y, z)
                                if (tertiary) then
                                    assign_weapon(spawn_object("weap", tertiary, x, y, z), i)
                                end

                                if (quaternary) then
                                    assign_weapon(spawn_object("weap", quaternary, x, y, z), i)
                                end
                            end
                        end
                        weapon[i] = false
                    end
                end
            end

            -- #Infinity Ammo
            if modEnabled("Infinity Ammo") and infammo[i] then
                if (frag_check[i] == true) and getFrags(i) == true then
                    execute_command("nades " .. tonumber(i) .. " 7")
                end
            end
            
            -- #Lurker
            if modEnabled("Portal Gun") then
                local tab = settings.mod["Lurker"]
                if (lurker[i] == true) then
                    execute_command("score " .. tonumber(i) .. " " .. scores[i])
                    if (tab.speed == true) then
                        execute_command("s " .. tonumber(i) .. " " .. tonumber(tab.running_speed))
                    end
                end
                if (lurker[i] == true) and (players["Lurker"][ip].lurker_warn == true) then
                    local LTab = players["Lurker"][ip]
                    LTab.lurker_timer = LTab.lurker_timer + 0.030

                    if (getWarnings(ip) <= 0) then
                        LTab.lurker_warn = false
                        cls(i)
                        say(i, "Lurker mode was disabled!")
                        cls(i)
                        -- No warnings left: Turn off lurker and reset counters
                        local params = { }
                        params.tid = tonumber(i)
                        params.tip = ip
                        params.tn = get_var(i, "$name")
                        params.bool = false
                        params.CmdTrigger = false
                        velocity:setLurker(params)
                        write_dword(get_player(i) + 0x2C, 0 * 33)
                    end

                    cls(i)
                    local days, hours, minutes, seconds = secondsToTime(LTab.lurker_timer, 4)
                    rprint(i, "|cWarning! Drop the " .. object_picked_up[i])
                    rprint(i, "|cYou will be killed in " .. tab.time_until_death - floor(seconds) .. " seconds")
                    rprint(i, "|c[ warnings left ] ")
                    rprint(i, "|c" .. getWarnings(ip))
                    rprint(i, "|c ")
                    rprint(i, "|c ")
                    rprint(i, "|c ")

                    if (LTab.lurker_timer >= tab.time_until_death) then
                        players["Lurker"][ip].lurker_warn = false
                        killSilently(i)
                        write_dword(get_player(i) + 0x2C, 0 * 33)
                        cls(i)
                        rprint(i, "|c=========================================================")
                        rprint(i, "|cYou were killed!")
                        rprint(i, "|c=========================================================")
                        rprint(i, "|c ")
                        rprint(i, "|c ")
                        rprint(i, "|c ")
                        rprint(i, "|c ")
                        object_picked_up[i] = ""
                    end
                end
            end

            -- #Portal Gun
            if modEnabled("Portal Gun") then
                if (player_present(i) and player_alive(i)) then
                    if (portalgun_mode[i] == true) then
                        local player_object = get_dynamic_player(i)
                        local playerX, playerY, playerZ = read_float(player_object + 0x230), read_float(player_object + 0x234), read_float(player_object + 0x238)
                        local shot_fired
                        local is_crouching
                        local couching = read_float(player_object + 0x50C)
                        local px, py, pz = read_vector3d(player_object + 0x5c)
                        if (couching == 0) then
                            pz = pz + 0.65
                            is_crouching = false
                        else
                            pz = pz + (0.35 * couching)
                            is_crouching = true
                        end
                        local ignore_player = read_dword(get_player(i) + 0x34)
                        local success, a, b, c, target = intersect(px, py, pz, playerX * 1000, playerY * 1000, playerZ * 1000, ignore_player)
                        if (success == true and target ~= nil) then
                            shot_fired = read_float(player_object + 0x490)
                            if (shot_fired ~= weapon_status[i] and shot_fired == 1 and is_crouching) then
                                execute_command("boost " .. i)
                            end
                            weapon_status[i] = shot_fired
                        end
                    end
                end
            end

            -- #Alias System
            if modEnabled("Alias System") then
                if (players["Alias System"][ip] and players["Alias System"][ip].trigger) then
                    players["Alias System"][ip].timer = players["Alias System"][ip].timer + 0.030
                    alias:show(i, ip, players["Alias System"][ip].total)
                    if players["Alias System"][ip].timer >= floor(settings.mod["Alias System"].duration) then
                        alias:reset(get_var(i, "$ip"))
                    end
                end
            end
            -- #Message Board
            if modEnabled("Message Board") then
                if players["Message Board"][ip] and (players["Message Board"][ip].show) then
                    players["Message Board"][ip].timer = players["Message Board"][ip].timer + 0.030
                    cls(i)
                    for j = 1, #m_board[ip] do
                        respond(i, "|" .. settings.mod["Message Board"].alignment .. " " .. m_board[ip][j], "rcon")
                    end
                    if players["Message Board"][ip].timer >= math.floor(settings.mod["Message Board"].duration) then
                        messageBoard:hide(i, ip)
                    end
                end
            end
            
            -- #Enter Vehicle
            if modEnabled("Enter Vehicle") then
                if (ev_Status[i]) then
                    if not PlayerInVehicle(i) then
                        enter_vehicle(ev_NewVehicle[i], i, 0)
                        local old_vehicle = get_object_memory(ev_OldVehicle[i])
                        write_vector3d(old_vehicle + 0x5C, 0, 0, 0)
                        timer(500, "DestroyObject", ev_OldVehicle[i])
                        ev_Status[i] = false
                    end
                end
            end
            
            -- #Mute System
            if modEnabled("Mute System") then
                local ip = getip(i)
                if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
                    mute_table[ip].timer = mute_table[ip].timer + 0.030
                    local days, hours, minutes, seconds = secondsToTime(mute_table[ip].timer, 4)
                    mute_table[ip].remaining = (mute_table[ip].duration) - floor(minutes)
                    if (mute_table[ip].remaining <= 0) then
                        local p = { }
                        p.tip, p.name, p.tid = ip, get_var(i, "$name"), tonumber(i)
                        velocity:unmute(p)
                    end
                end
            end
        end
    end
end

function determineWeapon()
    local primary, secondary, tertiary, quaternary, Slot
    local tab = settings.mod["Custom Weapons"]
    for i = 1, 4 do
        local weapon = tab.weapons[mapname][i]
        if (weapon ~= nil) then
            if (i == 1 and tab.weapons[mapname][i] ~= nil) then
                primary = tab.weapons[mapname][i]
                Slot = i
            end
            if (i == 2 and tab.weapons[mapname][i] ~= nil) then
                secondary = tab.weapons[mapname][i]
                Slot = i
            end
            if (i == 3 and tab.weapons[mapname][i] ~= nil) then
                tertiary = tab.weapons[mapname][i]
                Slot = i
            end
            if (i == 4 and tab.weapons[mapname][i] ~= nil) then
                quaternary = tab.weapons[mapname][i]
                Slot = i
            end
        end
    end
    return primary, secondary, tertiary, quaternary, Slot
end

function OnPlayerPrejoin(PlayerIndex)
    cprint("________________________________________________________________________________", 2 + 8)
    cprint("Player attempting to connect to the server...", 5 + 8)
    populateInfoTable(PlayerIndex)
    cprint(getPlayerInfo(PlayerIndex, "name"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "hash"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "ip"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "id"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "level"), 2 + 8)
    if (settings.global.beepOnJoin == true) then
        os.execute("echo \7")
    end
end

function OnPlayerConnect(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ip = get_var(PlayerIndex, "$ip")
    local level = getPlayerInfo(PlayerIndex, "level"):match("%d+")

    -- #CONSOLE OUTPUT
    if (player_info[PlayerIndex] ~= nil or player_info[PlayerIndex] ~= {}) then
        cprint("Join Time: " .. os.date("%A %d %B %Y - %X"), 2 + 8)
        cprint("Status: " .. name .. " connected successfully.", 5 + 8)
        cprint("________________________________________________________________________________", 2 + 8)
    end
    
    -- #Mute System
    if modEnabled("Mute System") then
        local p, ip, name = { }, getip(PlayerIndex), get_var(PlayerIndex, "$name")
        p.tip = ip
        local muted = velocity:loadMute(p)
        if (muted ~= nil) and (ip == muted[1]) then
            p.name, p.time, p.tid = name, muted[3], tonumber(PlayerIndex)
            velocity:saveMute(p, true, true)
        end
    end
    
    -- #Respawn Time
    if modEnabled("Respawn Time") then
        respawn_cmd_override[ip] = false
        respawn_time[ip] = 0
    end

    -- #Lurker
    if modEnabled("Lurker") then
        if (tonumber(level) >= getPermLevel("Lurker", false)) then
            velocity:LurkerReset(ip)
            scores[PlayerIndex] = 0
            lurker[PlayerIndex] = false
            has_objective[PlayerIndex] = false
        end
    end
    
    -- #Infinity Ammo
    if modEnabled("Infinity Ammo") then
        damage_multiplier[PlayerIndex] = 0
        if not (settings.mod["Infinity Ammo"].server_override) then
            infammo[PlayerIndex] = false
            modify_damage[PlayerIndex] = false
            damage_multiplier[PlayerIndex] = 0
        else
            infammo[PlayerIndex] = true
        end
    end

    -- #Alias System
    if modEnabled("Alias System") then
        alias:add(name, hash)
        if (tonumber(level) >= getPermLevel("Alias System", false)) then
            alias:reset(ip)
        end
    end

    -- #Message Board
    if modEnabled("Message Board") then
        messageBoard:show(PlayerIndex, ip)
    end

    -- #Admin Chat
    if modEnabled("Admin Chat") then
        local restore = settings.mod["Admin Chat"].restore
        if (tonumber(level) >= getPermLevel("Admin Chat", false)) then
            adminchat:set(ip)
            local mod = players["Admin Chat"][ip]
            if (restore) then
                local args = stringSplit(tostring(achat_status[ip]), "|")
                if (args[2] ~= nil) then
                    if (args[2] == "true") then
                        respond(PlayerIndex, "[reminder] Your admin chat is on!", "rcon")
                        mod.adminchat = true
                        mod.boolean = true
                    else
                        mod.adminchat = false
                        mod.boolean = false
                    end
                end
            else
                players["Admin Chat"][ip].adminchat = false
                players["Admin Chat"][ip].boolean = false
            end
        end
    end
    
    -- #Chat Logging
    if modEnabled("Chat Logging") then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            file:write(timestamp .. "    [JOIN]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
            file:close()
        end
    end

    -- #Admin Join Messages
    if modEnabled("Admin Join Messages") then
        local level = tonumber(get_var(PlayerIndex, "$lvl"))
        if (level >= 1) then
            local tab, join_message = settings.mod["Admin Join Messages"].messages
            join_message = tab[level][1] .. name .. tab[level][2]
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

    -- #Anti Impersonator
    if modEnabled("Anti Impersonator") then
        local tab = settings.mod["Anti Impersonator"]
        local found
        for key, _ in ipairs(tab.users) do
            local userdata = tab.users[key][name]
            if (userdata ~= nil) then
                for i = 1, #userdata do
                    if (userdata[i] == hash) then
                        found = true
                        break
                    end
                end
                if not (found) then
                    if (tab.action == "kick") then
                        execute_command("k" .. " " .. id .. " \"" .. tab.reason .. "\"")
                        cprint(name .. " was kicked for " .. tab.reason, 4 + 8)
                    elseif (tab.action == "ban") then
                        execute_command("b" .. " " .. id .. " " .. tab.bantime .. " \"" .. tab.reason .. "\"")
                        cprint(name .. " was banned for " .. tab.bantime .. " minutes for " .. tab.reason, 4 + 8)
                    end
                    break
                end
            end
        end
    end

    -- #Item Spawner
    if modEnabled("Item Spawner") then
        IS_drone_table[PlayerIndex] = nil
    end
    
    -- #Enter Vehicle
    if modEnabled("Enter Vehicle") then
        ev[PlayerIndex] = false
        ev_Status[PlayerIndex] = false
        EV_drone_table[PlayerIndex] = nil
    end
    
    -- #Color Reservation
    if modEnabled("Color Reservation") then
        if (can_use_colorres == true) then
            local ColorTable = settings.mod["Color Reservation"].color_table
            local player = getPlayer(PlayerIndex)
            local found
            for k, _ in ipairs(ColorTable) do
                for i = 1, #ColorTable do
                    local val = ColorTable[k][i]
                    if (val) then
                        if find(val, hash) then
                            k = k - 1
                            write_byte(player + 0x60, tonumber(k))
                            colorres_bool[PlayerIndex] = true
                            found = true
                            break
                        end
                        if not (found) then
                            if (val ~= "available") then
                                if (read_byte(getPlayer(PlayerIndex) + 0x60) == k - 1) then
                                    local function selectRandomColor(exclude)
                                        local num = rand(1, 18)
                                        if (num == exclude) then
                                            selectRandomColor(tonumber(k))
                                        else
                                            return num
                                        end
                                    end
                                    local colorID = selectRandomColor(tonumber(k))
                                    if colorID then
                                        write_byte(player + 0x60, colorID)
                                        colorres_bool[PlayerIndex] = true
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

function OnPlayerDisconnect(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ip = getPlayerInfo(PlayerIndex, "ip"):match("(%d+.%d+.%d+.%d+:%d+)")
    local level = getPlayerInfo(PlayerIndex, "level"):match("%d+")
    
    -- #CONSOLE OUTPUT
    cprint("________________________________________________________________________________", 4 + 8)
    if (player_info[PlayerIndex] ~= nil or player_info[PlayerIndex] ~= {}) then
        cprint(getPlayerInfo(PlayerIndex, "name"), 4 + 8)
        cprint(getPlayerInfo(PlayerIndex, "hash"), 4 + 8)
        cprint(getPlayerInfo(PlayerIndex, "ip"), 4 + 8)
        cprint(getPlayerInfo(PlayerIndex, "id"), 4 + 8)
        cprint(getPlayerInfo(PlayerIndex, "level"), 4 + 8)
        player_info[PlayerIndex] = nil
    end
    cprint("________________________________________________________________________________", 4 + 8)

    -- #Mute System
    if modEnabled("Mute System") then
        local ip, name = getip(PlayerIndex), get_var(PlayerIndex, "$name")
        if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
            local p = { }
            p.tip, p.name, p.time, p.tid = ip, name, mute_table[ip].remaining, tonumber(PlayerIndex)
            velocity:saveMute(p, true, true)
        end
    end
    
    -- #Respawn Time
    respawn_time[ip] = nil

    -- #Alias System
    if modEnabled("Alias System") then
        if (tonumber(level) >= getPermLevel("Alias System", false)) then
            alias:reset(ip)
        end
    end

    -- #Message Board
    if modEnabled("Message Board") then
        messageBoard:hide(PlayerIndex, ip)
    end
    
    -- #Teleport Manager
    if modEnabled("Teleport Manager") then
        wait_for_response[PlayerIndex] = false
        for i = 1, 3 do
            previous_location[PlayerIndex][i] = nil
        end
    end

    -- #Admin Chat
    if modEnabled("Admin Chat") then
        local restore = settings.mod["Admin Chat"].restore
        local mod = players["Admin Chat"][ip]
        if tonumber(level) >= getPermLevel("Admin Chat", false) then
            if (restore) then
                local bool
                if (mod.adminchat) then
                    bool = "true"
                else
                    bool = "false"
                end
                achat_status[ip] = bool
                achat_data[achat_status] = achat_data[achat_status] or {}
                table.insert(achat_data[achat_status], tostring(achat_status[ip]))
            else
                mod.adminchat = false
                mod.boolean = false
            end
        end
    end

    -- #Lurker
    if modEnabled("Lurker") then
        if (tonumber(level) >= getPermLevel("Lurker", false)) then
            velocity:LurkerReset(ip)
            scores[PlayerIndex] = 0
            lurker[PlayerIndex] = false
            has_objective[PlayerIndex] = false
        end
    end
    
    -- #Infinity Ammo
    if (modEnabled("Lurker") and infammo[PlayerIndex]) then
        DisableInfAmmo(PlayerIndex)
    end

    -- #Chat Logging
    if modEnabled("Admin Chat") then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            file:write(timestamp .. "    [QUIT]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
            file:close()
        end
    end
    
    -- #Enter Vehicle & Item Spawner
    if modEnabled("Enter Vehicle") or modEnabled("Item Spawner") then
        local tab = settings.mod["Enter Vehicle"]
        if (tab.garbage_collection.on_disconnect) then
            if ev_NewVehicle[PlayerIndex] ~= nil then
                ev[PlayerIndex] = false
                ev_Status[PlayerIndex] = false
            end
            CleanUpDrones(PlayerIndex, 1)
        end
        local tab = settings.mod["Item Spawner"]
        if (tab.garbage_collection.on_disconnect) then
            CleanUpDrones(PlayerIndex, 2)
        end
    end
end

function OnPlayerPrespawn(PlayerIndex)
    --
end

function OnPlayerSpawn(PlayerIndex)
    local ip = get_var(PlayerIndex, "$ip")
    -- #Custom Weapons
    if modEnabled("Custom Weapons") then
        local Wtab = settings.mod["Custom Weapons"]
        if player_alive(PlayerIndex) then
            if (Wtab.weapons[mapname] ~= nil) then
                if (Wtab.weapons[mapname][7]) then
                    weapon[PlayerIndex] = true
                    local player_object = get_dynamic_player(PlayerIndex)
                    if (player_object ~= 0) then
                        if (Wtab.assign_custom_frags == true) then
                            local frags = Wtab.weapons[mapname][5]
                            if (frags ~= 00) then
                                write_word(player_object + 0x31E, tonumber(frags))
                            end
                        end
                        if (Wtab.assign_custom_plasmas == true) then
                            local plasmas = Wtab.weapons[mapname][6]
                            if (plasmas ~= 00) then
                                write_word(player_object + 0x31F, tonumber(plasmas))
                            end
                        end
                    end
                end
            end
        end
    end
    -- #Color Reservation
    if modEnabled("Color Reservation") then
        if (can_use_colorres == true) then
            if (colorres_bool[PlayerIndex]) then
                colorres_bool[PlayerIndex] = false
                local player_object = read_dword(get_player(PlayerIndex) + 0x34)
                DestroyObject(player_object)
            end
        end
    end
    -- #Portal Gun
    if modEnabled("Portal Gun") then
        weapon_status[PlayerIndex] = 0
    end
    -- #Lurker
    if modEnabled("Lurker") then
        if (lurker[PlayerIndex] == true) then
            has_objective[PlayerIndex] = false
            velocity:LurkerReset(ip)
            local params = { }
            params.tid = tonumber(PlayerIndex)
            params.tip = ip
            params.tn = get_var(PlayerIndex, "$name")
            params.bool = true
            params.CmdTrigger = false
            velocity:setLurker(params)
        end
    end
    -- #Infinity Ammo
    if (modEnabled("Infinity Ammo") and infammo[PlayerIndex]) then
        frag_check[PlayerIndex] = true
        adjust_ammo(PlayerIndex)
    end
end

function OnPlayerKill(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local ip = get_var(PlayerIndex, "$ip")
    local level = tonumber(get_var(PlayerIndex, "$lvl"))

    -- #Respawn Time
    if modEnabled("Respawn Time") then
        local player = get_player(PlayerIndex)
        if not (respawn_cmd_override[ip]) then
            local mod = settings.mod["Respawn Time"]
            local function getSpawnTime()
                local spawntime
                if (get_var(1, "$gt") == "ctf") then
                    spawntime = mod.maps[mapname][1]
                elseif (get_var(1, "$gt") == "slayer") then
                    if not getTeamPlay() then
                        spawntime = mod.maps[mapname][2]
                    else
                        spawntime = mod.maps[mapname][3]
                    end
                elseif (get_var(1, "$gt") == "koth") then
                    if not getTeamPlay() then
                        spawntime = mod.maps[mapname][4]
                    else
                        spawntime = mod.maps[mapname][5]
                    end
                elseif (get_var(1, "$gt") == "oddball") then
                    if not getTeamPlay() then
                        spawntime = mod.maps[mapname][6]
                    else
                        spawntime = mod.maps[mapname][7]
                    end
                elseif (get_var(1, "$gt") == "race") then
                    if not getTeamPlay() then
                        spawntime = mod.maps[mapname][8]
                    else
                        spawntime = mod.maps[mapname][9]
                    end
                end
                return spawntime
            end        
            if not mod.global_respawn_time.enabled then
                if (mod.maps[mapname] ~= nil) then
                    write_dword(player + 0x2C, tonumber(getSpawnTime()) * 33)
                end
            else
                local time = mod.global_respawn_time.time
                write_dword(player + 0x2C, time * 33)
            end
        else
            write_dword(player + 0x2C, respawn_time[ip] * 33)
        end
    end
    -- #Lurker
    if modEnabled("Lurker") then
        if (level >= getPermLevel("Lurker", false)) then
            has_objective[PlayerIndex] = false
            scores[PlayerIndex] = 0
            local mod = players["Lurker"][ip]
            mod.lurker_warn = false
            mod.lurker_timer = 0
        end
    end
    
    -- #Enter Vehicle & Item Spawner
    if modEnabled("Enter Vehicle") or modEnabled("Item Spawner") then
        if (settings.mod["Enter Vehicle"].garbage_collection.on_death) then
            CleanUpDrones(PlayerIndex, 1)
        end
        if (settings.mod["Item Spawner"].garbage_collection.on_death) then
            CleanUpDrones(PlayerIndex, 2)
        end
    end
    
    -- #Infinity Ammo
    if (modEnabled("Infinity Ammo") and infammo[PlayerIndex]) then
        frag_check[PlayerIndex] = false
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    local id = tonumber(PlayerIndex)
    local level = tonumber(get_var(id, "$lvl"))
    local name = get_var(PlayerIndex, "$name")
    local ip = get_var(id, "$ip")
    local response

    if modEnabled("Mute System") then
        local ip = getip(PlayerIndex)
        if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
            if (mute_table[ip].duration == default_mute_time) then
                rprint(PlayerIndex, "[muted] You are muted permanently.")
            else
                rprint(PlayerIndex, "[muted] Time remaining: " .. mute_table[ip].duration .. " minute(s)")
            end
            return false
        end
    end
    
    
    -- Used throughout OnPlayerChat()
    local message = stringSplit(Message)
    if (#message == 0) then
        return nil
    end

    -- #Chat IDs & Admin Chat
    local keyword
    if modEnabled("Chat IDs") or modEnabled("Admin Chat") then
        local ignore = settings.mod["Chat IDs"].ignore_list
        if (table.match(ignore, message[1])) then
            keyword = true
        else
            keyword = false
        end
    end

    -- #Command Spy & Chat Logging
    local command
    local iscommand
    local cmd_prefix
    if modEnabled("Command Spy") or modEnabled("Chat Logging") then
        local cSpy = settings.mod["Command Spy"]
        if sub(message[1], 1, 1) == "/" or sub(message[1], 1, 1) == "\\" then
            command = message[1]:gsub("\\", "/")
            iscommand = true
            cmd_prefix = "[COMMAND] "
        else
            iscommand = false
        end

        if (tonumber(get_var(PlayerIndex, "$lvl")) == -1) and (iscommand) then
            local hidden_messages, hidden = cSpy.commands_to_hide
            for k, _ in pairs(hidden_messages) do
                if (command == k) then
                    hidden = true
                end
                break
            end
            local hide_commands = cSpy.hide_commands
            if (hide_commands and hidden) then
                response = false
            elseif (hide_commands and not hidden) or (hide_commands == false) then
                velocity:commandspy(cSpy.prefix .. " " .. name .. ":    \"" .. Message .. "\"")
                response = true
            end
        end

        local chat_type
        if type == 0 then
            chat_type = "[GLOBAL]  "
        elseif type == 1 then
            chat_type = "[TEAM]    "
        elseif type == 2 then
            chat_type = "[VEHICLE] "
        end
        local dir = settings.mod["Chat Logging"].dir
        local function LogChat(dir, msg)
            local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            local file = io.open(dir, "a+")
            if file ~= nil then
                local str = string.format("%s\t%s\n", timestamp, tostring(msg))
                file:write(str)
                file:close()
            end
        end
        if iscommand then
            LogChat(dir, "   " .. cmd_prefix .. "     " .. name .. " [" .. id .. "]: " .. Message)
            cprint(cmd_prefix .. " " .. name .. " [" .. id .. "]: " .. Message, 3 + 8)
        else
            LogChat(dir, "   " .. chat_type .. "     " .. name .. " [" .. id .. "]: " .. Message)
            cprint(chat_type .. " " .. name .. " [" .. id .. "]: " .. Message, 3 + 8)
        end
    end


    -- #Admin Chat
    if modEnabled("Admin Chat", PlayerIndex) then
        local mod = players["Admin Chat"][ip]
        local environment = settings.mod["Admin Chat"].environment
        local function AdminChat(Message)
            for i = 1, 16 do
                if player_present(i) and (level >= getPermLevel("Admin Chat", false)) then
                    if (environment == "rcon") then
                        respond(i, "|l" .. Message, "rcon")
                    elseif (environment == "chat") then
                        execute_command("msg_prefix \"\"")
                        respond(i, Message, "chat")
                        execute_command("msg_prefix \" *  * SERVER *  * \"")
                    end
                end
            end
        end
        if (mod.adminchat) then
            if (level >= getPermLevel("Admin Chat", false)) then
                for c = 0, #message do
                    if message[c] then
                        if not (keyword) or (keyword == nil) then
                            if sub(message[1], 1, 1) == "/" or sub(message[1], 1, 1) == "\\" then
                                response = true
                            else
                                local strFormat = settings.mod["Admin Chat"].message_format[1]
                                local prefix = settings.mod["Admin Chat"].prefix
                                local Format = (gsub(gsub(gsub(gsub(strFormat, "%%prefix%%", prefix), "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                AdminChat(Format)
                                response = false
                            end
                        end
                        break
                    end
                end
            end
        end
    end
    -- #Chat IDs
    if modEnabled("Chat IDs", PlayerIndex) then
        if not (game_over) then

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

            -- Permission Levels
            local tmod_perm = settings.mod["Chat IDs"].trial_moderator.lvl
            local mod_perm = settings.mod["Chat IDs"].moderator.lvl
            local admin_perm = settings.mod["Chat IDs"].admin.lvl
            local sadmin_perm = settings.mod["Chat IDs"].senior_admin.lvl

            if not (keyword) or (keyword == nil) then
                local function ChatHandler(PlayerIndex, Message)
                    local function SendToTeam(Message, PlayerIndex, Global, Tmod, Mod, Admin, sAdmin)
                        for i = 1, 16 do
                            if player_present(i) and (get_var(i, "$team") == get_var(PlayerIndex, "$team")) then
                                local formattedString = ""
                                execute_command("msg_prefix \"\"")
                                if (Global == true) then
                                    formattedString = (gsub(gsub(gsub(TeamDefault, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (Tmod == true) then
                                    formattedString = (gsub(gsub(gsub(Team_TModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (Mod == true) then
                                    formattedString = (gsub(gsub(gsub(Team_ModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (Admin == true) then
                                    formattedString = (gsub(gsub(gsub(Team_AdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (sAdmin == true) then
                                    formattedString = (gsub(gsub(gsub(Team_SAdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                end
                                say(i, formattedString)
                                execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                                response = false
                            end
                        end
                    end

                    local function SendToAll(Message, Global, Tmod, Mod, Admin, sAdmin)
                        local formattedString = ""
                        execute_command("msg_prefix \"\"")
                        if (Global == true) then
                            formattedString = (gsub(gsub(gsub(GlobalDefault, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (Tmod == true) then
                            formattedString = (gsub(gsub(gsub(Global_TModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (Mod == true) then
                            formattedString = (gsub(gsub(gsub(Global_ModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (Admin == true) then
                            formattedString = (gsub(gsub(gsub(Global_AdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (sAdmin == true) then
                            formattedString = (gsub(gsub(gsub(Global_SAdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        end
                        say_all(formattedString)
                        execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                        response = false
                    end

                    for b = 0, #message do
                        if message[b] then
                            if not (sub(message[1], 1, 1) == "/" or sub(message[1], 1, 1) == "\\") then
                                if (getTeamPlay()) then
                                    if (type == 0 or type == 2) then
                                        if (settings.mod["Chat IDs"].use_admin_prefixes == true) then
                                            if (level == tmod_perm) then
                                                SendToAll(Message, nil, true, nil, nil, nil)
                                            elseif (level == mod_perm) then
                                                SendToAll(Message, nil, nil, true, nil, nil)
                                            elseif (level == admin_perm) then
                                                SendToAll(Message, nil, nil, nil, true, nil)
                                            elseif (level == sadmin_perm) then
                                                SendToAll(Message, nil, nil, nil, nil, true)
                                            else
                                                SendToAll(Message, true, nil, nil, nil, nil)
                                            end
                                        else
                                            SendToAll(Message, true, nil, nil, nil, nil)
                                        end
                                    elseif (type == 1) then
                                        if (settings.mod["Chat IDs"].use_admin_prefixes == true) then
                                            if (level == tmod_perm) then
                                                SendToTeam(Message, PlayerIndex, nil, true, nil, nil, nil)
                                            elseif (level == mod_perm) then
                                                SendToTeam(Message, PlayerIndex, nil, nil, true, nil, nil)
                                            elseif (level == admin_perm) then
                                                SendToTeam(Message, PlayerIndex, nil, nil, nil, true, nil)
                                            elseif (level == sadmin_perm) then
                                                SendToTeam(Message, PlayerIndex, nil, nil, nil, nil, true)
                                            else
                                                SendToTeam(Message, PlayerIndex, true, nil, nil, nil, nil)
                                            end
                                        else
                                            SendToTeam(Message, PlayerIndex, true, nil, nil, nil, nil)
                                        end
                                    end
                                else
                                    if (settings.mod["Chat IDs"].use_admin_prefixes == true) then
                                        if (level == tmod_perm) then
                                            SendToAll(Message, nil, true, nil, nil, nil)
                                        elseif (level == mod_perm) then
                                            SendToAll(Message, nil, nil, true, nil, nil)
                                        elseif (level == admin_perm) then
                                            SendToAll(Message, nil, nil, nil, true, nil)
                                        elseif (level == sadmin_perm) then
                                            SendToAll(Message, nil, nil, nil, nil, true)
                                        else
                                            SendToAll(Message, true, nil, nil, nil, nil)
                                        end
                                    else
                                        SendToAll(Message, true, nil, nil, nil, nil)
                                    end
                                end
                            else
                                response = true
                            end
                            break
                        end
                    end
                end
                if modEnabled("Admin Chat") then
                    if (players["Admin Chat"][ip].adminchat ~= true) then
                        ChatHandler(PlayerIndex, Message)
                    end
                else
                    ChatHandler(PlayerIndex, Message)
                end
            end
        end
    end
    -- #Teleport Manager
    if modEnabled("Teleport Manager") then
        if wait_for_response[PlayerIndex] then
            if Message == ("yes") then
                local dir = settings.mod["Teleport Manager"].dir
                local warp_num = tonumber(getWarp())
                delete_from_file(dir, warp_num, 1, PlayerIndex)
                rprint(PlayerIndex, "Successfully deleted teleport id #" .. warp_num)
                wait_for_response[PlayerIndex] = false
            elseif Message == ("no") then
                rprint(PlayerIndex, "Process Cancelled")
                wait_for_response[PlayerIndex] = false
            end
            if Message ~= "yes" or Message ~= "no" then
                rprint(PlayerIndex, "That is not a valid response, please try again. Type yes|no")
            end
            response = false
        end
    end
    return response
end

local function checkAccess(e, console_allowed, script, others, alt, params)
    local access
    if (e ~= -1 and e >= 1 and e < 16) then
        if not (alt) then
            if (tonumber(get_var(e, "$lvl")) >= getPermLevel(script, others)) then
                access = true
            else
                rprint(e, "Command failed. Insufficient Permission.")
                access = false
            end
        else
            if (tonumber(get_var(e, "$lvl")) >= getPermLevel(script, others, params)) then
                access = true
            else
                rprint(e, "Command failed. Insufficient Permission.")
                access = false
            end
        end
    elseif (console_allowed) and (e < 1) then
        access = true
    elseif not (console_allowed) and (e < 1) then
        access = false
		respond(e, "Command Failed. Unable to execute from console.", "rcon", 4+8)
    end
    return access
end

-- Used in OnServerCommand()
local function isOnline(t, e)
    if (t) then
        if (t > 0 and t < 17) then
            if player_present(t) then
                return true
            else
                respond(e, "Command failed. Player not online.", "rcon", 4 + 8)
                return false
            end
        else
            respond(e, "Invalid player id. Please enter a number between 1-16", "rcon", 4 + 8)
        end
    end
end

local function cmdself(t, e)
    if (t) then
        if tonumber(t) == tonumber(e) then
            rprint(e, "You cannot execute this command on yourself.")
            return true
        end
    end
end

local function gameover(p)
    if (game_over) then
        rprint(p, "Command Failed -> Game has Ended.")
        rprint(p, "Please wait until the next game has started.")
        return true
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
    local level = tonumber(get_var(executor, "$lvl"))

    local TargetID, target_all_players, is_error
    local ip, name, hash = get_var(executor, "$ip"), get_var(executor, "$name"), get_var(executor, "$hash")
    local pl

    local pCMD = settings.global.plugin_commands

    local function hasAccess(e, lvl_req)
        local allow_access
        if isConsole(e) then
            return true
        elseif (level >= lvl_req) then
            return true
        else
            respond(e, "Insufficient Permission", "rcon", 5 + 8)
            return false
        end
    end

    -- #Command Spy
    if modEnabled("Command Spy") then
        if (Environment == 1) then
            if (level == -1) then
                local cSpy = settings.mod["Command Spy"]
                velocity:commandspy("[RCON] " .. cSpy.prefix .. " " .. name .. ":    \"" .. Command .. "\"")
            end
        end
    end

    local params = { }
    local function validate_params(parameter, pos)
        local function getplayers(arg, executor)
            if (arg == nil) then
                arg = executor
            end
            local players = { }
            if (arg == "me") then
                TargetID = executor
                table.insert(players, executor)
            elseif (arg:match("%d+")) then
                TargetID = tonumber(arg)
                table.insert(players, arg)
            elseif (arg == "*" or arg == "all") then
                for i = 1, 16 do
                    if player_present(i) then
                        target_all_players = true
                        table.insert(players, i)
                    end
                end
            else
                respond(executor, "Invalid player id. Usage: [number: 1-16] | */all | me", "rcon", 4 + 8)
                is_error = true
                return false
            end
            if players[1] then
                return players
            end
            players = nil
            return false
        end
        local pl = getplayers(args[tonumber(pos)], executor)
        if pl then
            for i = 1, #pl do
                if pl[i] == nil then
                    break
                end
                
                params.eid = executor
                params.eip = ip
                params.en = name
                params.eh = hash

                params.tid = tonumber(pl[i])
                params.tip = get_var(pl[i], "$ip")
                params.tn = get_var(pl[i], "$name")
                params.th = get_var(pl[i], "$hash")

                -- #Mute System
                if (parameter == "mute") then
                    if (args[2] ~= nil) then
                        params.time = args[2]
                    end
                    if (target_all_players) then
                        if not cmdself(params.tid, executor) then
                            velocity:saveMute(params, true, true)
                        end
                    end
                elseif (parameter == "unmute") then
                    if (target_all_players) then
                        if not cmdself(params.tid, executor) then
                            velocity:unmute(params)
                        end
                    end
                -- #Alias System
                elseif (parameter == "alias") then
                    local bool
                    if isConsole(executor) then
                        params.eip = '000.000.000.000'
                        bool = false
                    else
                        bool = settings.mod["Alias System"].use_timer
                    end
                    params.timer = bool
                    alias:reset(ip)
                    if (target_all_players) then
                        velocity:aliasCmdRoutine(params)
                    end
				-- #Admin Chat
                elseif (parameter == "achat") then
                    if (args[1] ~= nil) then
                        params.option = args[1]
                    end
                    if (target_all_players) then
                        velocity:determineAchat(params)
                    end
				-- #Portal Gun
                elseif (parameter == "portalgun") then
                    if (args[1] ~= nil) then
                        params.option = args[1]
                    end
                    if (target_all_players) then
                        velocity:portalgun(params)
                    end
				-- #Lurker
                elseif (parameter == "lurker") then
                    params.bool = true
                    params.CmdTrigger = true
                    if (args[1] ~= nil) then
                        params.option = args[1]
                    end
                    if (target_all_players) then
                        velocity:setLurker(params)
                    end
				-- #Respawn Time
                elseif (parameter == "setrespawn") then
                    if (args[2] ~= nil) then
                        params.time = args[2]
                    end
                    if (target_all_players) then
                        velocity:setRespawnTime(params)
                    end
				-- #Enter Vehicle
                elseif (parameter == "entervehicle") then
                    if (args[1] ~= nil) then
                        params.item = args[1] -- item
                    end
                    if (args[3] ~= nil) then
                        params.height = args[3] -- height
                    end
                    if (args[4] ~= nil) then
                        params.distance = args[4] -- distance
                    end
                    if (target_all_players) then
                        velocity:enterVehicle(params)
                    end
				-- #Item Spawner
                elseif (parameter == "itemspawner") then
                    if (args[1] ~= nil) then
                        params.item = args[1] -- object
                    end
                    if (target_all_players) then
                        velocity:spawnItem(params)
                    end
				-- #Garbage Collection
                elseif (parameter == "garbagecollection") then
                    if (args[1] ~= nil) then
                        params.table = args[2] -- table id
                    end
                    if (target_all_players) then
                        velocity:clean(params)
                    end
				-- #Infinity Ammo
                elseif (parameter == "infinityammo") then
                    if (args[1] ~= nil) then
                        params.off = args[3] -- off
                        params.multiplier = args[2] -- multipler
                    end
                    if (target_all_players) then
                        velocity:infinityAmmo(params)
                    end
				-- #Cute
                elseif (parameter == "cute") then
                    if (target_all_players) then
                        if not cmdself(params.tid, executor) then
                            velocity:cute(params)
                        end
                    end
				-- #Teleport Manager | warp
                elseif (parameter == "warp") then
                    if (args[1] ~= nil) then
                        params.warpname = args[1]
                    end
                    if (target_all_players) then
                        velocity:warp(params)
                    end
				-- #Teleport Manager | back
                elseif (parameter == "warpback") then
                    if (target_all_players) then
                        velocity:warpback(params)
                    end
                end
            end
        end
    end

    -- #Player List
    local cmd_list = settings.mod["Player List"].command_aliases
    for i = 1, #cmd_list do
        if (command == cmd_list[i]) then
            if modEnabled("Player List", executor) then
                if (checkAccess(executor, true, "Player List")) then
                    if (args[1] == nil) then
                        velocity:listplayers(executor)
                    else
                        respond(executor, "Invalid Syntax. Usage: /" .. command, "rcon", 4 + 8)
                    end
                end
            end
            return false
        end
    end

    -- #Mute System
    if (command == settings.mod["Mute System"].mute_command) then
        if modEnabled("Mute System", executor) then
            if (checkAccess(executor, true, "Mute System")) then
                local tab = settings.mod["Mute System"]
                if (args[1] ~= nil) and (args[2] ~= nil) then
                    validate_params("mute", 1) --/base_command [id] <args>
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            if not cmdself(params.tid, executor) then
                                velocity:saveMute(params, true, true)
                            end
                        end
                    end
                end
            end
        else
            respond(executor, "Invalid syntax. Usage: /" .. tab.mute_command.. " [id] <time diff>", "rcon", 2+8)
        end
        return false
    -- #Mute System
    elseif (command == settings.mod["Mute System"].unmute_command) then
        if modEnabled("Mute System", executor) then
            if (checkAccess(executor, true, "Mute System")) then
                local tab = settings.mod["Mute System"]
                if (args[1] ~= nil) then
                        validate_params("unmute", 1) --/base_command [id] <args>
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            if not cmdself(params.tid, executor) then
                                velocity:unmute(params)
                            end
                        end
                    end
                end
            else
                respond(executor, "Invalid syntax. Usage: /" .. tab.unmute_command.. " [id]", "rcon", 2+8)
            end
        end
        return false
    -- #Mute System
    elseif (command == settings.mod["Mute System"].mutelist_command) then
        if modEnabled("Mute System", executor) then
            if (checkAccess(executor, true, "Mute System")) then
                local p = { }
                p.eid = executor
                p.flag = args[1]
                velocity:mutelist(p)
            end
        end
        return false
    -- #Cute
    elseif (command == settings.mod["Cute"].base_command) then
        if modEnabled("Cute", executor) then
            if (checkAccess(executor, true, "Cute")) then
                local tab = settings.mod["Cute"]
                if (args[1] ~= nil) then
                    validate_params("cute", 1) --/base_command [id]
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            velocity:cute(params)
                        end
                    end
                else
                    respond(executor, "Invalid syntax. Usage: /" .. tab.base_command .. " [me | id | */all]", "rcon", 4 + 8)
                end
            end
        end
        return false
    -- #Infinity Ammo
    elseif (command == settings.mod["Infinity Ammo"].base_command) then
        if modEnabled("Infinity Ammo", executor) then
            if (checkAccess(executor, true, "Infinity Ammo")) then
                local tab = settings.mod["Infinity Ammo"]
                if (args[1] ~= nil and args[2] ~= nil) then
                    validate_params("infinityammo", 1) --/base_command [id] <args>
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            velocity:infinityAmmo(params)
                        end
                    end
                else
                    respond(executor, "Invalid syntax. Usage: /" .. tab.base_command .. " [me | id | */all] [multiplier]", "rcon", 4 + 8)
                end
            end
        end
        return false
    -- #Alias System
    elseif (command == settings.mod["Alias System"].base_command) then
        if modEnabled("Alias System", executor) then
            if (checkAccess(executor, true, "Alias System")) then
                local tab = settings.mod["Alias System"]
                if (args[1] ~= nil) then
                    validate_params("alias", 1) --/base_command [id] <args>
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            velocity:aliasCmdRoutine(params)
                        end
                    else
                        respond(executor, "Unable to check aliases from all players.", "rcon", 4 + 8)
                    end
                else
                    respond(executor, "Invalid syntax. Usage: /" .. tab.base_command .. " [id | me ]", "rcon", 4 + 8)
                end
            end
        end
        return false
        -- #Item Spawner
    elseif (command == settings.mod["Item Spawner"].base_command) then
        if not gameover(executor) then
            if modEnabled("Item Spawner", executor) then
                if (checkAccess(executor, true, "Item Spawner")) then
                    local tab = settings.mod["Item Spawner"]
                    if (args[1] ~= nil) and (args[2] ~= nil) then
                        validate_params("itemspawner", 2) --/base_command <args> [id]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:spawnItem(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " <item name> [id]", "rcon", 4 + 8)
                        return false
                    end
                end
            end
        end
        return false
        -- #Enter Vehicle
    elseif (command == settings.mod["Enter Vehicle"].base_command) then
        if not gameover(executor) then
            if modEnabled("Enter Vehicle", executor) then
                if modEnabled("Item Spawner", executor) then
                    if (checkAccess(executor, true, "Enter Vehicle")) then
                        local tab = settings.mod["Enter Vehicle"]
                        if (args[1] ~= nil) and (args[2] ~= nil) then
                            validate_params("entervehicle", 2) --/base_command <args> [id]
                            if not (target_all_players) then
                                if not (is_error) and isOnline(TargetID, executor) then
                                    velocity:enterVehicle(params)
                                end
                            end
                        else
                            respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " <vehicle name> [id] (opt height/distance)", "rcon", 4 + 8)
                            return false
                        end
                    end
                else
                    rprint(executor, "Error. Plugin: 'Item Spawner' needs to be enabled for this to work.")
                end
            end
        end
        return false
        -- #Garbage Collection
    elseif (command == settings.mod["Garbage Collection"].base_command) then
        if not gameover(executor) then
            if modEnabled("Garbage Collection", executor) or modEnabled("Garbage Collection", executor) then
				if (checkAccess(executor, true, "Garbage Collection")) then
					local tab = settings.mod["Garbage Collection"]
					if (args[1] ~= nil) and (args[2] ~= nil) then
						validate_params("garbagecollection", 1) --/base_command [id] <args>
						if not (target_all_players) then
							if not (is_error) and isOnline(TargetID, executor) then
								velocity:clean(params)
							end
						end
					else
						respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " [me | id | */all] [type]" , "rcon", 4 + 8)
						return false
					end
                end
            end
        end
        return false
        -- #Respawn Time
    elseif (command == settings.mod["Respawn Time"].base_command) then
        if not gameover(executor) then
            if modEnabled("Respawn Time", executor) then
                if (checkAccess(executor, true, "Respawn Time")) then
                    local tab = settings.mod["Respawn Time"]
                    if (args[1] ~= nil) then
                        validate_params("setrespawn", 1) --/base_command [id] <args>
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:setRespawnTime(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " [id] <time diff>", "rcon", 4 + 8)
                        return false
                    end
                end
            end
        end
        return false
        -- #Admin Chat
    elseif (command == settings.mod["Admin Chat"].base_command) then
        if not gameover(executor) then
            if modEnabled("Admin Chat", executor) then
                if (checkAccess(executor, true, "Admin Chat")) then
                    local tab = settings.mod["Admin Chat"]
                    if (args[1] ~= nil) and (args[2] ~= nil) then
                        validate_params("achat", 2) --/base_command <args> [id]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:determineAchat(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " n|off [id]", "rcon", 4 + 8)
                        return false
                    end
                end
            end
        end
        return false
        -- #Lurker
    elseif (command == settings.mod["Lurker"].base_command) then
        if not gameover(executor) then
            if modEnabled("Lurker", executor) then
                if (checkAccess(executor, true, "Lurker")) then
                    local tab = settings.mod["Lurker"]
                    if (args[1] ~= nil) and (args[2] ~= nil) then
                        validate_params("lurker", 2) --/base_command <args> [id]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:setLurker(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " on|off [id]", "rcon", 4 + 8)
                        return false
                    end
                end
            end
        end
        return false
        -- #Suggestions Box
    elseif (command == settings.mod["Suggestions Box"].base_command) then
        if not gameover(executor) then
            if modEnabled("Suggestions Box", executor) then
                if (checkAccess(executor, true, "Suggestions Box")) then
                    local tab = settings.mod["Suggestions Box"]
                    if (args[1] ~= nil) then
                        local p = { }
                        local content = gsub(Command, tab.base_command, "")
                        p.eid, p.en, p.message = executor, name, content
                        p.format, p.dir = tab.msg_format, tab.dir
                        velocity:suggestion(p)
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " {message}", "rcon", 4 + 8)
                        return false
                    end
                end
            end
        end
        return false
        -- #Portal Gun
    elseif (command == settings.mod["Portal Gun"].base_command) then
        if not gameover(executor) then
            if modEnabled("Portal Gun", executor) then
                if (checkAccess(executor, true, "Portal Gun")) then
                    local tab = settings.mod["Portal Gun"]
                    if (args[1] ~= nil) and (args[2] ~= nil) then
                        validate_params("portalgun", 2) --/base_command <args> [id]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:portalgun(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.base_command .. " on|off [me | id | */all] ", "rcon", 4 + 8)
                        return false
                    end
                end
            end
        end
        return false
        -- #Teleport Manager | SET WARP
    elseif (command == settings.mod["Teleport Manager"].commands[1]) then
        if not gameover(executor) then
            if modEnabled("Teleport Manager", executor) then
                local p = { }
                p.eid, p.level, p.cmd = executor, level, "setwarp"
                if (checkAccess(executor, false, "Teleport Manager", false, true, p)) then
                    if (args[1] ~= nil) then
                        p.warpname = args[1]
						velocity:setwarp(p)
                    else
                        local tab = settings.mod["Teleport Manager"]
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.commands[1] .. " <warp name>", "rcon", 4 + 8)
                        return false
                    end
                end
            end
        end
        return false
        -- #Teleport Manager | WARP
    elseif (command == settings.mod["Teleport Manager"].commands[2]) then
        if not gameover(executor) then
            if modEnabled("Teleport Manager", executor) then
                if (checkAccess(executor, true, "Teleport Manager", true, false, p)) then
                    local tab = settings.mod["Teleport Manager"]
                    if (args[1] ~= nil and args[2] ~= nil) then
                        validate_params("warp", 2) --/base_command <args> [id]
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:warp(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.commands[2] .. " [warp name] [me | id | */all] ", "rcon", 4 + 8)
                        return false
                    end
                end
            end
        end
        return false
        -- #Teleport Manager | BACK
    elseif (command == settings.mod["Teleport Manager"].commands[3]) then
        if not gameover(executor) then
            if modEnabled("Teleport Manager", executor) then
                if (checkAccess(executor, true, "Teleport Manager", true, false, p)) then
                    local tab = settings.mod["Teleport Manager"]
                    if (args[1] ~= nil and args[2] == nil) then
                        validate_params("warpback", 1) --/base_command <args>
                        if not (target_all_players) then
                            if not (is_error) and isOnline(TargetID, executor) then
                                velocity:warpback(params)
                            end
                        end
                    else
                        respond(executor, "Invalid Syntax: Usage: /" .. tab.commands[3] .. " [me | id | */all] ", "rcon", 4 + 8)
                        return false
                    end
                end
            end
        end
        return false
        -- ==========================================================================================================================
        -- #Velocity Version command
    elseif (command == pCMD.velocity[1]) then
        if hasAccess(executor, pCMD.velocity[2]) then
            if (settings.global.check_for_updates) then
                if (getCurrentVersion(false) ~= settings.global.script_version) then
                    respond(executor, "============================================================================", "rcon", 7 + 8)
                    respond(executor, "[VELOCITY] Version " .. getCurrentVersion(false) .. " is available for download.", "rcon", 5 + 8)
                    respond(executor, "Current version: v" .. settings.global.script_version, "rcon", 5 + 8)
                    respond(executor, "============================================================================", "rcon", 7 + 8)
                else
                    respond(executor, "Velocity Version " .. settings.global.script_version, "rcon", 5 + 8)
                end
            else
                respond(executor, "Update Checking disabled. Current version: " .. settings.global.script_version, "rcon", 5 + 8)
            end
        end
        return false
        -- #Clear Chat Command
    elseif (command == pCMD.clearchat[1]) then
        if not gameover(executor) then
            if hasAccess(executor, pCMD.clearchat[2]) then
                for _ = 1, 20 do
                    execute_command("msg_prefix \"\"")
                    say_all(" ")
                    execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                end
                respond(executor, "Chat was cleared!", "rcon", 5 + 8)
            end
        end
        return false
        -- #Plugin List
    elseif (command == pCMD.list[1]) then
        if not gameover(executor) then
            if hasAccess(executor, pCMD.list[2]) then
                local t = {}
                for k, _ in pairs(settings.mod) do
                    t[#t + 1] = k
                end
                for k, v in pairs(t) do
                    if v then
                        if (settings.mod[v].enabled) then
                            respond(executor, "[" .. k .. "] " .. v .. " is enabled", "rcon", 2 + 8)
                        else
                            respond(executor, "[" .. k .. "] " .. v .. " is disabled", "rcon", 4 + 8)
                        end
                    end
                end
                for _ in pairs(t) do
                    t[_] = nil
                end
            end
        end
        return false
        -- #Enable Plugin
    elseif (command == pCMD.enable[1]) then
        if not gameover(executor) then
            if (args[1] ~= nil and args[1]:match("%d+")) then
                if hasAccess(executor, pCMD.enable[2]) then
                    local id = args[1]
                    local t = {}
                    for k, _ in pairs(settings.mod) do
                        t[#t + 1] = k
                    end
                    for k, v in pairs(t) do
                        if v then
                            if (tonumber(id) == tonumber(k)) then
                                if not (settings.mod[v].enabled) then
                                    settings.mod[v].enabled = true
                                    respond(executor, "[" .. k .. "] " .. v .. " is enabled", "rcon", 2 + 8)
                                else
                                    respond(executor, v .. " is already enabled!", "rcon", 3 + 8)
                                end
                            end
                        end
                    end
                    for _ in pairs(t) do
                        t[_] = nil
                    end
                end
            else
                respond(executor, "Invalid Syntax. Usage: /" .. pCMD.enable[1], "rcon", 4 + 8)
            end
        end
        return false
        -- #Disable Plugin
    elseif (command == pCMD.disable[1]) then
        if not gameover(executor) then
            if (args[1] ~= nil and args[1]:match("%d+")) then
                if hasAccess(executor, pCMD.disable[2]) then
                    local id = args[1]
                    local t = {}
                    for k, _ in pairs(settings.mod) do
                        t[#t + 1] = k
                    end
                    for k, v in pairs(t) do
                        if v then
                            if (tonumber(id) == tonumber(k)) then
                                if (settings.mod[v].enabled) then
                                    settings.mod[v].enabled = false
                                    respond(executor, "[" .. k .. "] " .. v .. " is disabled", "rcon", 4 + 8)
                                else
                                    respond(executor, v .. " is already enabled!", "rcon", 3 + 8)
                                end
                            end
                        end
                    end
                    for _ in pairs(t) do
                        t[_] = nil
                    end
                end
            else
                respond(executor, "Invalid Syntax. Usage: /" .. pCMD.disable[1], "rcon", 4 + 8)
            end
        end
        return false
    end
end

function velocity:portalgun(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local option = params.option or nil
    local proceed

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))
    local tLvl = tonumber(get_var(tid, "$lvl"))

    if (option == nil) then
        if (tLvl >= 1) then
            if (portalgun_mode[tid] == true) then
                status = "enabled"
            else
                status = "disabled"
            end
            if (is_self) then
                respond(eid, "Your portalgun mode is " .. status, "rcon", 4 + 8)
            else
                respond(eid, tn .. "'s portalgun mode is " .. status, "rcon", 4 + 8)
            end
        else
            respond(eid, tn .. " is not an admin! [Portal Gun Off]", "rcon", 4+8)
        end
    else
        proceed = true
    end

    if (proceed) then
        local base_command = settings.mod["Portal Gun"].base_command
        if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Portal Gun")) then
            if (tLvl >= 1) then 
                local status, already_set, is_error
                if (option == "on") or (option == "1") or (option == "true") then
                    status, already_set, is_error = "Enabled", true, false
                    if (portalgun_mode[tid] ~= true) then
                        portalgun_mode[tid] = true
                    end
                elseif (option == "off") or (option == "0") or (option == "false") then
                    status, already_set, is_error = "Disabled", false, false
                    if (portalgun_mode[tid] ~= false) then
                        portalgun_mode[tid] = false
                    end
                else
                    is_error = true
                    respond(eid, "Invalid Syntax: Usage: /" .. base_command .. " [me | id | */all] on|off", "rcon", 4 + 8)
                end
                if not (is_error) and not (already_set) then
                    if not (is_self) then
                        respond(eid, "Portal Gun " .. status .. " for " .. tn, "rcon", 2 + 8)
                        respond(tid, "Your Portal Gun was " .. status .. " by " .. en, "rcon")
                    else
                        respond(eid, "Portal Gun " .. status, "rcon")
                    end
                elseif (already_set) then
                    respond(eid, "[SERVER] -> " .. tn .. ", Portal Gun is already " .. status, "rcon")
                end
            else
                respond(eid, "Failed to set " .. tn .. "'s portal gun to (" .. option .. ") [player not admin]", "rcon", 4 + 8)
            end
        end
    end
    return false
end

function velocity:listplayers(e)
    local header, cheader, ffa
    local count = 0
    local bool = true
    local alignment = settings.mod["Player List"].alignment
    if (getTeamPlay()) then
        header = "|" .. alignment .. " [ ID.    -    Name.    -    Team.    -    IP. ]"
        cheader = "ID.        Name.        Team.        IP."
    else
        ffa = true
        header = "|" .. alignment .. " [ ID.    -    Name.    -    IP. ]"
        cheader = "ID.        Name.        IP"
    end
    local str
    for i = 1, 16 do
        if player_present(i) then
            if (bool) then
                bool = false
                if not (isConsole(e)) then
                    rprint(e, header)
                else
                    cprint(cheader, 7 + 8)
                end
            end
            count = count + 1
            local id, name, team, ip = get_var(i, "$n"), get_var(i, "$name"), get_var(i, "$team"), get_var(i, "$ip")
            if not (ffa) then
                str = id .. ".         " .. name .. "   |   " .. team .. "   |   " .. ip
            else
                str = id .. ".         " .. name .. "   |   " .. ip
            end
            if not (isConsole(e)) then
                rprint(e, "|" .. alignment .. "     " .. str)
            else
                cprint(str, 5 + 8)
            end
        end
    end
    if (count == 0) and (isConsole(e)) then
        cprint("------------------------------------", 5 + 8)
        cprint("There are no players online", 4 + 8)
        cprint("------------------------------------", 5 + 8)
    end
end

function velocity:determineAchat(params)

    local params = params or {}
    local eid = params.eid or nil
    local eip = params.eip or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tip = params.tip or nil
    local tn = params.tn or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local option = params.option or nil
    local mod = players["Admin Chat"][tip]
    local proceed

    local is_self
    if (eid == tid) then
        is_self = true
    end
    
    local eLvl = tonumber(get_var(eid, "$lvl"))
    local tLvl = tonumber(get_var(tid, "$lvl"))

    if (option == nil) then
        if (tLvl >= 1) then
            if type(mod.adminchat) == 'true' then
                status = "enabled"
            else
                status = "disabled"
            end
            if (is_self) then
                respond(eid, "Your admin chat is " .. status, "rcon", 4 + 8)
            else
                respond(eid, tn .. "'s admin chat is " .. status, "rcon", 4 + 8)
            end
        else
            respond(eid, tn .. " is not an admin! [Admin Chat Off]", "rcon", 4+8)
        end
    else
        proceed = true
    end

    if (proceed) then
        local base_command = settings.mod["Admin Chat"].base_command
        if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Admin Chat")) then
            if (tLvl >= 1) then 
                local status, already_set, is_error
                if (option == "on") or (option == "1") or (option == "true") then
                    if (mod.boolean ~= true) then
                        status, already_set, is_error = "Enabled", false, false
                        mod.adminchat = true
                        mod.boolean = true
                    else
                        status, already_set, is_error = "Enabled", true, false
                    end
                elseif (option == "off") or (option == "0") or (option == "false") then
                    if (mod.boolean ~= false) then
                        status, already_set, is_error = "Disabled", false, false
                        mod.adminchat = false
                        mod.boolean = false
                    else
                        status, already_set, is_error = "Disabled", true, false
                    end
                else
                    is_error = true
                    respond(eid, "Invalid Syntax: Type /" .. base_command .. " [id] on|off.", "rcon", 4 + 8)
                end
                if not (is_error) and not (already_set) then
                    if not (is_self) then
                        respond(eid, "Admin Chat " .. status .. " for " .. tn, "rcon", 2 + 8)
                        respond(tid, "Your Admin Chat was " .. status .. " by " .. en, "rcon")
                    else
                        respond(eid, "Admin Chat " .. status, "rcon")
                    end
                elseif (already_set) then
                    respond(eid, "[SERVER] -> " .. tn .. ", Admin Chat is already " .. status, "rcon")
                end
            else
                respond(eid, "Failed to set " .. tn .. "'s admin chat to (" .. option .. ") [player not admin]", "rcon", 4 + 8)
            end
        end
    end
    return false
end

function velocity:setRespawnTime(params)
    local params = params or { }
    local eid = params.eid or nil
    local en = params.en or nil
    local eip = params.eip or nil

    local tid = params.tid or nil
    local tn = params.tn or nil
    local tip = params.tip or nil
    
    local time = params.time or nil
    
    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))
    
    local function getRSTime(p)
        if (get_player(p)) then
            return read_dword(get_player(p) + 0x2C)
        end
    end

    local proceed, access
    local time = params.time or nil
    if (time == nil) then
        if (respawn_cmd_override[tip] == true) then
            status = getRSTime(tid)
        else
            status = getRSTime(tid)
        end
        if (is_self) then
            respond(eid, "Your respawn time: " .. status .. " seconds", "rcon", 4 + 8)
        else
            respond(eid, tn .. "'s respawn time: " .. status .. " seconds", "rcon", 4 + 8)
        end
    else
        proceed = true
    end

    if (proceed) then
        if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Respawn Time")) then
            if not (is_error) then
                if not (is_self) then
                    if (respawn_time[tip] == nil) then 
                        respawn_time[tip] = getRSTime(tid)
                    else
                        respawn_time[tip] = time
                    end
                    respond(eid, tn .. "'s respawn time was set to " .. respawn_time[tip] .. " seconds", "rcon", 4 + 8)
                    respond(tid, "Your respawn time was set to " .. respawn_time[tip] .. " seconds", "rcon", 4 + 8)
                    respawn_cmd_override[tip] = true
                else
                    if (respawn_time[eip] == nil) then 
                        respawn_time[eip] = getRSTime(eid)
                    else
                        respawn_time[eip] = time
                    end
                    respawn_cmd_override[eip] = true
                    respond(eid, "Your respawn time was set to " .. respawn_time[eip] .. " seconds", "rcon", 4 + 8)
                end
            end
        end
    end
    return false
end

function velocity:enterVehicle(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil
    
    local height = params.height or nil
    local distance = params.distance or nil
    local item = params.item or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end
    
    local eLvl = tonumber(get_var(eid, "$lvl"))
    local tLvl = tonumber(get_var(tid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Enter Vehicle")) then
        if (tLvl >= 1) then 
            if not (is_error) then

                if (distance) then
                    if distance:match("%d+") then
                        distance = tonumber(distance)
                    else
                        respond(eid, "Command failed. Invalid distance parameter")
                    end
                else
                    distance = 2
                end
            
                if (height) then
                    if height:match("%d+") then
                        height = tonumber(height)
                    else
                        respond(eid, "Command failed. Invalid height parameter")
                    end
                else
                    height = 0.3
                end
                
                if player_alive(tid) then
                    local x, y, z, is_valid, err, no_match
                    local objects_table = settings.mod["Item Spawner"].objects
                    local player_object = get_dynamic_player(tid)
                    for i = 1, #objects_table do
                        if item:match(objects_table[i][1]) and (objects_table[i][2] == "vehi") then
                            if TagInfo(objects_table[i][2], objects_table[i][3]) then
                                if PlayerInVehicle(tid) then
                                    local VehicleID = read_dword(player_object + 0x11C)
                                    if (VehicleID == 0xFFFFFFFF) then
                                        return false
                                    end
                                    local vehicle = get_object_memory(VehicleID)
                                    x, y, z = read_vector3d(vehicle + 0x5c)
                                    ev_OldVehicle[tid] = VehicleID
                                else
                                    x, y, z = read_vector3d(player_object + 0x5c)
                                end
                                
                                local camera_x = read_float(player_object + 0x230)
                                local camera_y = read_float(player_object + 0x234)
                                x = x + camera_x * distance
                                y = y + camera_y * distance
                                z = z + height

                                ev_NewVehicle[tid] = spawn_object("vehi", objects_table[i][3], x, y, z)

                                local multi_control = settings.mod["Enter Vehicle"].multi_control

                                local function Enter(player, vehicle)
                                    enter_vehicle(vehicle, player, 0)
                                    ev[player] = true
                                end
                                
                                -- Multi Control - NOT in vehicle
                                if multi_control and not PlayerInVehicle(tid) then
                                    Enter(tid, ev_NewVehicle[tid])

                                    -- Multi Control - IN vehicle
                                elseif multi_control and PlayerInVehicle(tid) then
                                    Enter(tid, ev_NewVehicle[tid])

                                    -- NO Multi Control - NOT in vehicle
                                elseif not multi_control and not PlayerInVehicle(tid) then
                                    Enter(tid, ev_NewVehicle[tid])

                                    -- NO Multi Control - IN vehicle
                                elseif not multi_control and PlayerInVehicle(tid) then
                                    exit_vehicle(tid)
                                    ev_Status[tid] = true
                                end

                                if ev_NewVehicle[tid] ~= nil then
                                    EV_drone_table[tid] = EV_drone_table[tid] or {}
                                    table.insert(EV_drone_table[tid], ev_NewVehicle[tid])
                                end

                                ev[tid] = true
                                is_valid = true
                            else
                                err = true
                            end
                        else
                            no_match = true
                        end
                    end

                    if (is_valid) then
                        if not (is_self) then
                            respond(tid, "Entering " .. item, "rcon", 4 + 8)
                            respond(eid, "Entering " .. tn .. " into " .. item, "rcon", 4 + 8)
                        else
                            respond(tid, "Entering " .. item, "rcon", 4 + 8)
                        end
                    end
                    if not (is_valid) and (no_match) and not (err) then
                        respond(eid, "Failed to spawn object. [unknown object name]", "rcon", 4+8)
                    elseif (is_valid == nil or is_valid == false) and (err) and (no_match) then
                        respond(eid, "Failed to spawn object. [missing tag id", "rcon", 4+8)
                    end
                else
                    if not (is_self) then
                        respond(eid, "Command Failed. " .. tn .. " is dead!", "rcon", 4+8)
                    else
                        respond(eid, "Command failed. You are dead. [wait until you respawn]", "rcon", 4+8)
                    end
                end
            end
        else
            respond(eid, "Failed to spawn item for " .. tn .. " - [player not admin]", "rcon", 4 + 8)
        end
    end
    return false
end


function velocity:spawnItem(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil
    local item = params.item or nil
    
    local tab = settings.mod["Item Spawner"]
    
    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end
    
    local eLvl = tonumber(get_var(eid, "$lvl"))
    local tLvl = tonumber(get_var(tid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Item Spawner")) then
        if (tLvl >= 1) then 
            if player_alive(tid) then
                local objects_table = tab.objects
                local valid, err
                local sin = math.sin
                for i = 1, #objects_table do
                    if (item:match(objects_table[i][1])) then
                        local tag_type = objects_table[i][2]
                        local tag_name = objects_table[i][3]
                        if TagInfo(tag_type, tag_name) then
                            local function SpawnObject(tid, tag_type, tag_name)
                                local player_object = get_dynamic_player(tid)
                                if player_object ~= 0 then
                                    local x_aim = read_float(player_object + 0x230)
                                    local y_aim = read_float(player_object + 0x234)
                                    local z_aim = read_float(player_object + 0x238)
                                    local x = read_float(player_object + 0x5C)
                                    local y = read_float(player_object + 0x60)
                                    local z = read_float(player_object + 0x64)
                                    local obj_x = x + tab.distance_from_playerX * sin(x_aim)
                                    local obj_y = y + tab.distance_from_playerY * sin(y_aim)
                                    local obj_z = z + 0.3 * sin(z_aim) + 0.5
                                    item_objects[tid] = spawn_object(tag_type, tag_name, obj_x, obj_y, obj_z)
                                    if not (is_self) then
                                        -- Item Spawner Logic Here
                                        respond(eid, "Spawning " .. objects_table[i][1] .. " for " .. tn, "rcon", 4 + 8)
                                        respond(tid, en .. " spawned " .. objects_table[i][1] .. " for you", "rcon", 4 + 8)
                                    else
                                        respond(eid, "Spawning " .. objects_table[i][1], "rcon", 4 + 8)
                                    end
                                    valid = true
                                    if (item_objects[tid]) ~= nil then
                                        IS_drone_table[tid] = IS_drone_table[tid] or {}
                                        table.insert(IS_drone_table[tid], item_objects[tid])
                                    end
                                end
                            end
                            SpawnObject(tid, tag_type, tag_name)
                        else
                            err = true
                            respond(eid, "Error: Missing tag id for '" .. item .. "' in 'objects' table", "rcon", 4+8)
                        end
                        break
                    end
                end
                if not (valid) and not (err) then
                    respond(tid, "'" .. item .. "' is not a valid object or it is missing in the 'objects' table", "rcon", 4+8)
                end
            else
                if not (is_self) then
                    respond(eid, "Command Failed. " .. tn .. " is dead!", "rcon", 4+8)
                else
                    respond(eid, "Command failed. You are dead. [wait until you respawn]", "rcon", 4+8)
                end
            end
        else
            respond(eid, "Failed to spawn item for " .. tn .. " - [player not admin]", "rcon", 4 + 8)
        end
    end
    return false
end

function velocity:clean(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil
    local identifier = params.table or nil
    
    local tab = settings.mod["Garbage Collection"]
    
    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end
    
    local eLvl = tonumber(get_var(eid, "$lvl"))
    local tLvl = tonumber(get_var(tid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Garbage Collection")) then
        if (tLvl >= 1) then 
            local object, proceed
            if identifier:match("%d+") then
                identifier = tonumber(identifier)
                if (identifier > 0) and (identifier < 3) then
                    if (identifier == 1) then
                        object = "Enter Vehicle"
                    else
                        object = "Item Spawner"
                    end
                end
            elseif (identifier == "*" or identifier == "all") then
                identifier = tostring(identifier)
                object = "Enter Vehicle & Item Spawner"
            else
                respond(eid, "Invalid Table ID!", "rcon", 4+8)
            end

            if (ev_NewVehicle[tid] ~= nil) or (item_objects[tid] ~= nil) then
                proceed = true
            else
                respond(tid, tn .. " has nothing to clean up", "rcon", 4+8)
            end
            
            if (proceed) then
                CleanUpDrones(tid, identifier)
                if (is_self) then
                    respond(eid, "Cleaning up " .. object .. " objects", "rcon", 4+8)
                else
                    respond(eid, "Cleaning up " .. tn .. "'s " .. object .. " objects", "rcon", 4+8)
                end
            end
        else
            respond(eid, "Failed to clean objects for " .. tn .. " - [player not admin]", "rcon", 4 + 8)
        end
    end
    return false
end

function velocity:infinityAmmo(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil
    local multiplier = params.multiplier or nil
    
    local tab = settings.mod["Infinity Ammo"]
    
    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end
    
    local eLvl = tonumber(get_var(eid, "$lvl"))
    local tLvl = tonumber(get_var(tid, "$lvl"))

    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Infinity Ammo")) then
        local function EnableInfAmmo(TargetID, specified, multiplier)
            infammo[TargetID] = true
            frag_check[TargetID] = true
            adjust_ammo(TargetID)
            if specified then
                if not (lurker[TargetID]) then
                    local mult = tonumber(multiplier)
                    modify_damage[TargetID] = true
                    damage_multiplier[TargetID] = mult
                    respond(TargetID, "[cheat] Infinity Ammo enabled", "rcon", 4+8)
                    respond(TargetID, damage_multiplier[TargetID] .. "% damage multiplier applied", "rcon", 4+8)
                else
                    respond(eid, "Unable to set damage multipliers while in Lurker Mode", "rcon", 4+8)
                end
            else
                respond(TargetID, "[cheat] Infinity Ammo enabled", "rcon", 4+8)
                if (tab..announcer) then
                    announce(TargetID, get_var(TargetID, "$name") .. " is now in Infinity Ammo mode.")
                end
            end
        end
        
        local _min = tab.multiplier_min
        local _max = tab.multiplier_max 
        
        local function validate_multiplier(T3)
            if tonumber(T3) >= tonumber(_min) and tonumber(T3) < tonumber(_max) + 1 then
                return true
            else
                respond(eid, "Invalid multiplier. Choose a number between 0.001-10", "rcon", 4+8)
            end
            return false
        end
        
        if (is_self) then
            if (multiplier == nil) then
                EnableInfAmmo(eid, false, 0)
            elseif multiplier:match("%d+") then
                if validate_multiplier(multiplier) then
                    EnableInfAmmo(eid, true, multiplier)
                end
            elseif (multiplier == "off") then
                DisableInfAmmo(eid)
                if (tab.announcer) then
                    announce(eid, en .. " is no longer in Infinity Ammo Mode")
                end
            end
        elseif not (is_self) then
            if (multiplier == nil) then
                if player_present(tid) then
                    EnableInfAmmo(tid, false, 0)
                    respond(eid, "[cheat] Enabled infammo for " .. tn, "rcon", 4+8)
                else
                    respond(eid, "Player not present", "rcon", 4+8)
                end
            elseif multiplier:match("%d+") then
                if player_present(tid) then
                    if validate_multiplier(multiplier) then
                        EnableInfAmmo(tid, true, multiplier)
                        respond(eid, "[cheat] Enabled infammo for " .. tn, "rcon", 4+8)
                    end
                else
                    respond(eid, "Command failed. Player not online", "rcon", 4+8)
                end
            elseif (multiplier == "off") then
                DisableInfAmmo(tid)
                respond(eid, "[cheat] Disabled infammo for " .. tn, "rcon", 4+8)
                if (tab..announcer) then
                    announce(tid, tn .. " is no longer in Infinity Ammo Mode")
                end
            end
        end
    end
    return false
end

function velocity:cute(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tn = params.tn or nil
    local multiplier = params.multiplier or nil
    
    local tab = settings.mod["Infinity Ammo"]
    
    if isConsole(eid) then
        en = "SERVER"
    end
    
    local is_self
    if (eid == tid) then
        is_self = true
    end

    local tab = settings.mod["Cute"]
    local tFormat, eFormat = tab.messages[1], tab.messages[2]

    local tStr = (gsub(gsub(tFormat,"%%executors_name%%", en), "%%target_name%%", tn))

    if (tab.environment == "chat") then
        execute_command("msg_prefix \"\"")
        respond(tid, tStr, "chat", 2+8)
        execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
    else
        respond(tid, tStr, "rcon", 2+8)
    end

    local eStr = (gsub(gsub(eFormat,"%%executors_name%%", en), "%%target_name%%", tn))
    execute_command("msg_prefix \"\"")
    respond(eid, eStr, "rcon", 2+8)
    execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
    return false
end

function velocity:setwarp(params)
    local params = params or { }
    local eid = params.eid or nil
    local warpname = params.warpname or nil
    local dir = settings.mod["Teleport Manager"].dir
    
    if not isFileEmpty(dir) then
        local lines = lines_from(dir)
        for _, v in pairs(lines) do
            if (warpname == v:match("[%a%d+_]*")) then
                respond(eid, "That portal name already exists!", "rcon")
                canset[eid] = false
                break
            else
                canset[eid] = true
            end
        end
    else
        canset[eid] = true
    end
    
    if warpname:match(mapname) then
        respond(eid, "Teleport name cannot be the same as the current map name!", "rcon")
        canset[eid] = false
    end
    if (canset[eid] == true) then
        local x,y,z
        if PlayerInVehicle(eid) then
            x,y,z = read_vector3d(get_object_memory(read_dword(get_dynamic_player(eid) + 0x11C)) + 0x5c)
        else
            x,y,z = read_vector3d(get_dynamic_player(eid) + 0x5C)
        end
        local file = io.open(dir, "a+")
        local str = warpname .. " [Map: " .. mapname .. "] X " .. x .. ", Y " .. y .. ", Z " .. z
        file:write(str, "\n")
        file:close()
        respond(eid, "Teleport location set to: " .. floor(x) .. ", " .. floor(y) .. ", " .. floor(z), "rcon")
    end
end

function velocity:warp(params)
    local params = params or { }
    local eid = params.eid or nil
    local tid = params.tid or nil
    local en = params.en or nil
    local tn = params.tn or nil
    local warpname = params.warpname or nil
    local dir = settings.mod["Teleport Manager"].dir
    
    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end
    
    local eLvl = tonumber(get_var(eid, "$lvl"))
    
    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Teleport Manager")) then
        if not isFileEmpty(dir) then
            local found
            local valid
            local lines = lines_from(dir)
            for _, v in pairs(lines) do
                if (warpname == v:match("[%a%d+_]*")) then
                    if (player_alive(tid)) then
                        if find(v, mapname) then
                            found = true
                            -- numbers without decimal points -----------------------------------------------------------------------------
                            local x, y, z
                            if match(v, ("X%s*%d+,%s*Y%s*%d+,%s*Z%s*%d+")) then
                                valid = true -- 0
                                x = gsub(match(v, "X%s*%d+"), "X%s*%d+", match(match(v, "X%s*%d+"), "%d+"))
                                y = gsub(match(v, "Y%s*%d+"), "Y%s*%d+", match(match(v, "Y%s*%d+"), "%d+"))
                                z = gsub(match(v, "Z%s*%d+"), "Z%s*%d+", match(match(v, "Z%s*%d+"), "%d+"))
                            elseif match(v, ("X%s*-%d+,%s*Y%s*-%d+,%s*Z%s*-%d+")) then
                                valid = true -- *
                                x = gsub(match(v, "X%s*-%d+"), "X%s*-%d+", match(match(v, "X%s*-%d+"), "-%d+"))
                                y = gsub(match(v, "Y%s*-%d+"), "Y%s*-%d+", match(match(v, "Y%s*-%d+"), "-%d+"))
                                z = gsub(match(v, "Z%s*-%d+"), "Z%s*-%d+", match(match(v, "Z%s*-%d+"), "-%d+"))
                            elseif match(v, ("X%s*-%d+,%s*Y%s*%d+,%s*Z%s*%d+")) then
                                valid = true -- 1
                                x = gsub(match(v, "X%s*-%d+"), "X%s*-%d+", match(match(v, "X%s*-%d+"), "-%d+"))
                                y = gsub(match(v, "Y%s*%d+"), "Y%s*%d+", match(match(v, "Y%s*%d+"), "%d+"))
                                z = gsub(match(v, "Z%s*%d+"), "Z%s*%d+", match(match(v, "Z%s*%d+"), "%d+"))
                            elseif match(v, ("X%s*%d+,%s*Y%s*-%d+,%s*Z%s*%d+")) then
                                valid = true -- 2
                                x = gsub(match(v, "X%s*%d+"), "X%s*%d+", match(match(v, "X%s*%d+"), "%d+"))
                                y = gsub(match(v, "Y%s*-%d+"), "Y%s*-%d+", match(match(v, "Y%s*-%d+"), "-%d+"))
                                z = gsub(match(v, "Z%s*%d+"), "Z%s*%d+", match(match(v, "Z%s*%d+"), "%d+"))
                            elseif match(v, ("X%s*%d+,%s*Y%s*%d+,%s*Z%s*-%d+")) then
                                valid = true -- 3
                                x = gsub(match(v, "X%s*%d+"), "X%s*%d+", match(match(v, "X%s*%d+"), "%d+"))
                                y = gsub(match(v, "Y%s*%d+"), "Y%s*%d+", match(match(v, "Y%s*%d+"), "%d+"))
                                z = gsub(match(v, "Z%s*-%d+"), "Z%s*-%d+", match(match(v, "Z%s*-%d+"), "-%d+"))
                            elseif match(v, ("X%s*-%d+,%s*Y%s*-%d+,%s*Z%s*%d+")) then
                                valid = true -- 1 & 2
                                x = gsub(match(v, "X%s*-%d+"), "X%s*-%d+", match(match(v, "X%s*-%d+"), "-%d+"))
                                y = gsub(match(v, "Y%s*-%d+"), "Y%s*-%d+", match(match(v, "Y%s*-%d+"), "-%d+"))
                                z = gsub(match(v, "Z%s*%d+"), "Z%s*%d+", match(match(v, "Z%s*%d+"), "%d+"))
                            elseif match(v, ("X%s*-%d+,%s*Y%s*%d+,%s*Z%s*-%d+")) then
                                valid = true -- 1 & 3
                                x = gsub(match(v, "X%s*-%d+"), "X%s*-%d+", match(match(v, "X%s*-%d+"), "-%d+"))
                                y = gsub(match(v, "Y%s*%d+"), "Y%s*%d+", match(match(v, "Y%s*%d+"), "%d+"))
                                z = gsub(match(v, "Z%s*-%d+"), "Z%s*-%d+", match(match(v, "Z%s*-%d+"), "-%d+"))
                            elseif match(v, ("X%s*%d+,%s*Y%s*-%d+,%s*Z%s*-%d+")) then
                                valid = true -- 2 & 3
                                x = gsub(match(v, "X%s*%d+"), "X%s*%d+", match(match(v, "X%s*%d+"), "%d+"))
                                y = gsub(match(v, "Y%s*-%d+"), "Y%s*-%d+", match(match(v, "Y%s*-%d+"), "-%d+"))
                                z = gsub(match(v, "Z%s*-%d+"), "Z%s*-%d+", match(match(v, "Z%s*-%d+"), "-%d+"))
                                -- numbers with decimal points -----------------------------------------------------------------------------
                            elseif match(v, ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")) then
                                valid = true -- 0
                                x = gsub(match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", match(match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                y = gsub(match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", match(match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                z = gsub(match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", match(match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                            elseif match(v, ("X%s*-%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                valid = true -- *
                                x = gsub(match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", match(match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                y = gsub(match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", match(match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                z = gsub(match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", match(match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                            elseif match(v, ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")) then
                                valid = true -- 1
                                x = gsub(match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", match(match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                y = gsub(match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", match(match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                z = gsub(match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", match(match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                            elseif match(v, ("X%s*%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*%d+.%d+")) then
                                valid = true -- 2
                                x = gsub(match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", match(match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                y = gsub(match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", match(match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                z = gsub(match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", match(match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                            elseif match(v, ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                valid = true -- 3
                                x = gsub(match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", match(match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                y = gsub(match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", match(match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                z = gsub(match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", match(match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                            elseif match(v, ("X%s*-%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*%d+.%d+")) then
                                valid = true -- 1 & 2
                                x = gsub(match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", match(match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                y = gsub(match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", match(match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                z = gsub(match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", match(match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                            elseif match(v, ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                valid = true -- 1 & 3
                                x = gsub(match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", match(match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                y = gsub(match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", match(match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                z = gsub(match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", match(match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                            elseif match(v, ("X%s*%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                valid = true -- 2 & 3
                                x = gsub(match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", match(match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                y = gsub(match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", match(match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                z = gsub(match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", match(match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                            else
                                respond(eid, "Script Error! Coordinates for that teleport do not match the regex expression", "rcon", 4+8)
                                cprint("Script Error! Coordinates for that teleport do not match the regex expression!", 4 + 8)
                            end
                            if (v ~= nil and valid) then
                                if not PlayerInVehicle(tid) then
                                    local prevX, prevY, prevZ = read_vector3d(get_dynamic_player(tid) + 0x5C)
                                    previous_location[tid][1] = prevX
                                    previous_location[tid][2] = prevY
                                    previous_location[tid][3] = prevZ
                                    write_vector3d(get_dynamic_player(tid) + 0x5C, tonumber(x), tonumber(y), tonumber(z))
                                    valid = false
                                else
                                    TeleportPlayer(read_dword(get_dynamic_player(tid) + 0x11C), tonumber(x), tonumber(y), tonumber(z) + 0.5)
                                    valid = false
                                end
                                if (is_self) then
                                    respond(eid, "Teleporting to [" .. warpname .. "] " .. floor(x) .. ", " .. floor(y) .. ", " .. floor(z), "rcon", 4+8)
                                else
                                    respond(eid, "Teleporting " .. tn .. " to [" .. warpname .. "] " .. floor(x) .. ", " .. floor(y) .. ", " .. floor(z), "rcon", 4+8)
                                    respond(tid, en .. " teleport you to [" .. warpname .. "] " .. floor(x) .. ", " .. floor(y) .. ", " .. floor(z), "rcon", 4+8)
                                end
                            end
                        else
                            found = true
                            respond(eid, "That warp is not linked to this map", "rcon", 4+8)
                        end
                    else
                        found = true
                        respond(eid, "You cannot teleport when dead", "rcon", 4+8)
                    end
                end
            end
            if not (found) then
                respond(eid, "That teleport name is not valid", "rcon", 4+8)
            end
        else
            respond(eid, "The teleport list is empty!", "rcon", 4+8)
        end
    end
    return false
end

function velocity:warpback(params)
    local params = params or { }
    local eid = params.eid or nil
    local tid = params.tid or nil
    local en = params.en or nil
    local tn = params.tn or nil
    local warpname = params.warpname or nil
    local dir = settings.mod["Teleport Manager"].dir
    
    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end
    
    local eLvl = tonumber(get_var(eid, "$lvl"))
    
    if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Teleport Manager")) then
        if not PlayerInVehicle(tid) then
            if previous_location[tid][1] ~= nil then
                write_vector3d(get_dynamic_player(tid) + 0x5C, previous_location[tid][1], previous_location[tid][2], previous_location[tid][3])
                if (is_self) then
                    respond(eid, "Returning to previous location", "rcon", 4+8)
                else
                    respond(eid, "Returning " .. tn .. " to previous location", "rcon", 4+8)
                    respond(tid, en " sent you back to your previous location", "rcon", 4+8)
                end
                for i = 1, 3 do
                    previous_location[tid][i] = nil
                end
            else
                if (is_self) then
                    respond(eid, "Unable to teleport back! You haven't been anywhere!")
                else
                    respond(eid, "Unable to teleport " .. tn .. " back! They haven't been anywhere!")
                end
            end
        end
    end
end

function velocity:setLurker(params)
    local params = params or { }
    local eid = params.eid or nil
    local eip = params.eip or nil
    local en = params.en or nil

    local tid = params.tid or nil
    local tip = params.tip or nil
    local tn = params.tn or nil
    local bool = params.bool or nil
    local CmdTrigger = params.CmdTrigger or nil

    if isConsole(eid) then
        en = "SERVER"
    end

    local is_self
    if (eid == tid) then
        is_self = true
    end

    local eLvl = tonumber(get_var(eid, "$lvl"))
    local tLvl = tonumber(get_var(tid, "$lvl"))
    
    local proceed, access
    local option = params.option or nil
    if (option == nil) then
        if (CmdTrigger) then
            if (tLvl >= 1) then
                if (lurker[tid] == true) then
                    status = "enabled"
                else
                    status = "disabled"
                end
                if (is_self) then
                    respond(eid, "Your Lurker Mode is " .. status, "rcon", 4 + 8)
                else
                    respond(eid, tn .. "'s lurker mode is " .. status, "rcon", 4 + 8)
                end
            else
                respond(eid, tn .. " is not an admin! [Lurker Mode Off]", "rcon", 4+8)
            end
        else
            proceed = true
        end
    else
        proceed = true
    end

    if (proceed) then
        local mod = settings.mod["Lurker"]
        local function Enable()
            lurker[tid] = true
            if (mod.god) then
                execute_command("god " .. tid)
            end
            if (mod.camouflage) then
                execute_command("camo " .. tid)
            end
            if (mod.announcer) then
                announce(tid, tn .. " is now in lurker mode! [spectator]")
            end
        end

        local function Disable(tid)
            scores[tid] = 0
            lurker[tid] = false
            if (mod.speed) then
                execute_command("s " .. tid .. " " .. tonumber(mod.default_running_speed))
            end
            if (mod.god == true) then
                execute_command("ungod " .. tid)
            end
            killSilently(tid)
            velocity:LurkerReset(tip)
            cls(tid)
            if (mod.announcer) then
                announce(tid, tn .. " is no longer in lurker mode! [spectator]")
            end
        end

        if (executeOnOthers(eid, is_self, isConsole(eid), eLvl, "Lurker")) then
            if (CmdTrigger) and (option) then
                local status, already_set, is_error
                if (option == "on") or (option == "1") or (option == "true") then
                    if (lurker[tid] ~= true) then
                        status, already_set, is_error = "Enabled", false, false
                        Enable(tid, tn)
                    else
                        status, already_set, is_error = "Enabled", true, false
                    end
                elseif (option == "off") or (option == "0") or (option == "false") then
                    if (lurker[tid] ~= false) then
                        status, already_set, is_error = "Disable", false, false
                        Disable(tid, tn)
                    else
                        status, already_set, is_error = "Disable", true, false
                    end
                else
                    is_error = true
                    respond(eid, "Invalid Syntax: Type /" .. mod.base_command .. " [id] on|off.", "rcon", 4 + 8)
                end
                ------------------------- [ ON ENABLE ] --------------------------------------------------
                if not (is_error) and not (already_set) then
                    if not (is_self) then
                        respond(eid, "Lurker " .. status .. " for " .. tn, "rcon", 2 + 8)
                        respond(tid, "Your Lurker Mode was " .. status .. " by " .. en, "rcon")
                    else
                        respond(eid, "Lurker Mode " .. status, "rcon", 2 + 8)
                    end
                elseif (already_set) then
                    respond(eid, "[SERVER] -> " .. tn .. ", Lurker already " .. status, "rcon", 4 + 8)
                end
                ----------------------------------------------------------------------------------------------------------------------------------
            else
                if (bool) then
                    Enable()
                    respond(tid, "Lurker mode enabled!", "rcon", 2 + 8)
                else
                    Disable()
                    respond(tid, "Lurker mode disabled!", "rcon", 2 + 8)
                end
            end
        end
    end
    return false
end

-- #Suggestions Box
function velocity:suggestion(params)
    local params = params or {}
    local eid = params.eid or nil
    local en = params.en or nil
    local content = params.message or nil
    local msg_format = params.format or nil
    local dir = params.dir or nil
    if isConsole(eid) then
        en = "SERVER"
    end
    local t, text = {}
    t[#t + 1] = content
    if (t) then
        local file = io.open(dir, "a+")
        if (file) then
            for _, v in pairs(t) do
                text = v
            end
            local timestamp = os.date("%d/%m/%Y - %H:%M:%S")
            local str = gsub(gsub(gsub(msg_format, "%%time_stamp%%", timestamp), "%%player_name%%", en), "%%message%%", text .. "\n")
            file:write(str)
            file:close()
            local tab = settings.mod["Suggestions Box"]
            respond(eid, gsub(tab.response, "%%player_name%%", en), "rcon", 7 + 8)
            respond(eid, "------------ [ MESSAGE ] ------------------------------------------------", "rcon", 7 + 8)
            respond(eid, text)
            respond(eid, "-------------------------------------------------------------------------------------------------------------", "rcon", 7 + 8)
        end
    end
    for _ in pairs(t) do
        _ = nil
    end
end

-- #Alias System
function velocity:aliasCmdRoutine(params)
    local params = params or {}
    local eid = params.eid or nil
    local eip = params.eip or nil
    local tn = params.tn or nil
    local th = params.th or nil
    local use_timer = params.timer or nil

    local aliases, content
    local tab = players["Alias System"][eip]
    alias_results = { }

    tab.tHash = params.th
    tab.tName = params.tn

    local directory = settings.mod["Alias System"].dir
    local lines = lines_from(directory)
    for _, v in pairs(lines) do
        if (v:match(tab.tHash)) then
            aliases = v:match(":(.+)")
            content = stringSplit(aliases, ",")
            alias_results[#alias_results + 1] = content
        end
    end

    tab.eid = eid
    tab.shared = false
    tab.check_pirated_hash = true

    for i = 1, max_results do
        if (alias_results[1][i]) then
            tab.total = tab.total + 1
        end
    end

    local total = tab.total
    if (use_timer) then
        tab.trigger = true
        tab.bool = true
    else
        alias:show(eid, eip, total)
    end
end

function velocity:commandspy(Message)
    for i = 1, 16 do
        local level = get_var(i, "$lvl")
        if tonumber(level) >= getPermLevel("Command Spy", false) then
            respond(i, Message, "rcon", 2 + 8)
        end
    end
end

-- #Alias System
function resetAliasParams()
    for i = 1, 16 do
        if player_present(i) then
            if (tonumber(get_var(i, "$lvl")) >= settings.mod["Alias System"].permission_level) then
                alias:reset(get_var(i, "$ip"))
            end
        end
    end
end

-- #Alias System
local function spacing(n, sep)
    sep = sep or ""
    local String, Seperator = "", ","
    for i = 1, n do
        if i == floor(n / 2) then
            String = String .. sep
        end
        String = String .. " "
    end
    return Seperator .. String
end

-- #Alias System
local function FormatTable(table, rowlen, space, delimiter)
    local longest = 0
    for _, v in ipairs(table) do
        local len = string.len(v)
        if len > longest then
            longest = len
        end
    end
    local rows = {}
    local row = 1
    local count = 1
    for k, v in ipairs(table) do
        if count % rowlen == 0 or k == #table then
            rows[row] = (rows[row] or "") .. v
        else
            rows[row] = (rows[row] or "") .. v .. spacing(longest - string.len(v) + space, delimiter)
        end
        if count % rowlen == 0 then
            row = row + 1
        end
        count = count + 1
    end
    return concat(rows)
end

-- #Alias System
function alias:align(player, table, target, total, pirated, name, alignment)
    if not isConsole(player) then
        cls(player)
    end
    local function formatResults()
        local placeholder, row = { }

        for i = tonumber(startIndex), tonumber(endIndex) do
            if (table[1][i]) then
                placeholder[#placeholder + 1] = table[1][i]
                row = FormatTable(placeholder, max_columns, spaces)
            end
        end

        if (row ~= nil) then
            respond(player, "|" .. alignment .. " " .. row, "rcon")
        end

        for a in pairs(placeholder) do
            placeholder[a] = nil
        end

        startIndex = (endIndex + 1)
        endIndex = (endIndex + (max_columns))
    end

    while (endIndex < max_results + max_columns) do
        formatResults()
    end

    if (startIndex >= max_results) then
        startIndex = initialStartIndex
        endIndex = max_columns
    end
    respond(player, " ", "rcon")
    respond(player, "|" .. alignment .. " " .. 'Showing (' .. total .. ' aliases) for: "' .. target .. '"', "rcon")
    if (pirated) then
        respond(player, "|" .. alignment .. " " .. name .. ' is using a pirated copy of Halo.', "rcon")
    end
end

-- #Alias System
function alias:show(executor, ip, total)
    local tab = players["Alias System"][ip]
    local target = tab.tHash
    local name = tab.tName
    local check_pirated_hash = tab.check_pirated_hash
    if (check_pirated_hash) then
        tab.check_pirated_hash = false
        for i = 1, #known_pirated_hashes do
            if (target == known_pirated_hashes[i]) then
                tab.shared = true
            end
        end
    end
    local alignment = settings.mod["Alias System"].alignment
    alias:align(executor, alias_results, target, total, tab.shared, name, alignment)
end

-- #Alias System
function alias:add(name, hash)

    local function containsExact(w, s)
        return select(2, s:gsub('^' .. w .. '%W+', '')) +
                select(2, s:gsub('%W+' .. w .. '$', '')) +
                select(2, s:gsub('^' .. w .. '$', '')) +
                select(2, s:gsub('%W+' .. w .. '%W+', '')) > 0
    end

    local found, proceed
    local dir = settings.mod["Alias System"].dir
    local lines = lines_from(dir)
    for _, v in pairs(lines) do

        if containsExact(hash, v) and containsExact(name, v) then
            proceed = true
        end

        if containsExact(hash, v) and not containsExact(name, v) then
            found = true

            local alias = v .. ", " .. name

            local fRead = io.open(dir, "r")
            local content = fRead:read("*all")
            fRead:close()

            content = gsub(content, v, alias)

            local fWrite = io.open(dir, "w")
            fWrite:write(content)
            fWrite:close()
        end
    end
    if not (found) and not (proceed) then
        local file = assert(io.open(dir, "a+"))
        file:write(hash .. ":" .. name .. "\n")
        file:close()
    end
end

-- #Mute System
function velocity:saveMute(params, bool, showMessage)
    local params = params or { }
    
    local ip = params.tip or nil
    local name = params.tn or nil
    local eid = params.eid or nil
    local tid = params.tid or nil
    local time = params.time or nil
    
    local proceed
    if not (settings.mod["Mute System"].can_mute_admins) then
        if tonumber(get_var(tid, "$lvl")) >= 1 then
            proceed = false
        else
            proceed = true
        end
    else
        proceed = true
    end

    if (proceed) then
        mute_table[ip] = mute_table[ip] or { }
        mute_table[ip].muted = true
        mute_table[ip].timer = 0
        mute_table[ip].remaining = time
        mute_table[ip].duration = time
        
        local dir = settings.mod["Mute System"].dir
        
        local lines, found = lines_from(dir)
        for _, v in pairs(lines) do
            if (v:match(ip)) then
                found = true
                local fRead = io.open(dir, "r")
                local content = fRead:read("*all")
                fRead:close()
                content = gsub(content, v, ip .. ", " .. name .. ", " .. time)
                local fWrite = io.open(dir, "w")
                fWrite:write(content)
                fWrite:close()
            end
        end
        if not (found) then
            local file = assert(io.open(dir, "a+"))
            file:write(ip .. ", " .. name .. ", " .. time .. "\n")
            file:close()
        end
        if (bool) and (showMessage) then
            if (mute_table[ip].duration == default_mute_time) then
                respond(tid, "You are muted permanently", "rcon", 2+8)
                if (eid ~= nil) then
                    respond(eid, name .. " was muted permanently", "rcon", 2+8)
                end
            else
                respond(tid, "You were muted! Time remaining: " .. mute_table[ip].duration .. " minute(s)", "rcon", 2+8)
                if (eid ~= nil) then
                    respond(eid, name .. " was muted for " .. mute_table[ip].duration .. " minutes(s)", "rcon", 2+8)
                end
            end
        end
    else
        respond(eid, "Unable to mute " .. name .. ". [can_mute_admins is disabled]" , "rcon", 4+8)
    end
end

-- #Mute System
function velocity:unmute(params)
    local params = params or { }
    
    local ip = params.tip or nil
    local name = params.tn or nil
    local eid = params.eid or nil
    local tid = params.tid or nil
    local en = params.en or nil
    
    local proceed
    if not (settings.mod["Mute System"].can_mute_admins) then
        if tonumber(get_var(tid, "$lvl")) >= 1 then
            proceed = false
        else
            proceed = true
        end
    else
        proceed = true
    end
    
    if (proceed) then
        local dir = settings.mod["Mute System"].dir
        local lines = lines_from(dir)
        for _, v in pairs(lines) do
            if (v:match(ip)) then
                local fRead = io.open(dir, "r")
                local content = fRead:read("*all")
                fRead:close()
                local file = io.open(dir, "w")
                content = gsub(content, v, "")
                file:write(content)
                file:close()
                mute_table[ip] = { }
            end
        end
        
        if (eid ~= nil and eid == 0) or (eid == nil) then
            en = 'SERVER'
            id = 0
        elseif (eid ~= nil and eid > 0) then
            en = en
            id = eid
        end
        respond(tid, "You were unmuted by " .. en, "rcon", 2+8)
        respond(id, name .. " was unmuted by " .. en, "rcon", 2+8)
    else
        respond(eid, "Unable to unmute " .. name .. ". [can_mute_admins is disabled]" , "rcon", 4+8)
    end
end

-- #Mute System
function velocity:loadMute(params)
    local params = params or { }
    local ip = params.tip or nil
    local dir = settings.mod["Mute System"].dir
    local content, data
    
    local lines = lines_from(dir)
    for _, v in pairs(lines) do
        if (v:match(ip)) then
            content = v:match(v)
            data = stringSplit(content, ",")
        end
    end

    if (data) then
        i = 1
        local result = { }
        for j = 1, 3 do
            if (data[j] ~= nil) then
                result[j] = data[j]
                i = i + 1
            else
                return
            end
        end
        if (result ~= nil) then
            return result
        end
    end
end

-- #Mute System
function velocity:mutelist(params) 
    local params = params or { }
    local eid = params.eid or nil
    local flag = params.flag or nil
    local dir = settings.mod["Mute System"].dir
    
    respond(eid, "----------- IP - NAME - TIME REMAINING (in minutes) ----------- ", "rcon", 7+8)
    
    local lines = lines_from(dir)
    for k, v in pairs(lines) do
        if (k ~= nil) then
            if (flag == nil) then
                respond(eid, v, "rcon", 2+8)
            elseif (flag == "-o") then
                local count = 0
                for i = 1, 16 do
                    if player_present(i) then 
                        cout = count + 1
                        local ip = getip(i)
                        local muted = velocity:loadMute(ip)
                        if (ip == muted[1]) then
                            respond(eid, get_var(i, "$name") .. " [" .. tonumber(i) .. "]: " .. muted[3] .. " minutes left", "rcon", 7+8)
                        end
                    end
                end
                if (count == 0) then
                    respond(eid, "Nobody online is currently muted.", "rcon", 4+8)
                    break
                end
            else
                respond(eid, "Invalid syntax. Usage: /" .. mutelist_command.. " <flag>", "rcon", 2+8)
                break
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    -- #Lurker
    if modEnabled("Lurker", PlayerIndex) then
        if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
            if (lurker[CauserIndex] == true) then
                return false
            end
        end
    end
    -- #Infinity Ammo
    if modEnabled("Infinity Ammo", PlayerIndex) then
        if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
            if (modify_damage[CauserIndex] == true) then
                return true, Damage * tonumber(damage_multiplier[CauserIndex])
            end
        end
    end
end

function OnWeaponDrop(PlayerIndex)
    -- #Lurker
    if modEnabled("Lurker", PlayerIndex) then
        if (lurker[PlayerIndex] == true and has_objective[PlayerIndex] == true) then
            local ip = get_var(PlayerIndex, "$ip")
            cls(PlayerIndex)
            has_objective[PlayerIndex] = false
            velocity:LurkerReset(ip)
        end
    end
end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
    -- #Lurker
    if modEnabled("Lurker", PlayerIndex) then
        if (lurker[PlayerIndex] == true) then
            local ip = get_var(PlayerIndex, "$ip")
            local mod = players["Lurker"][ip]
            if (tonumber(Type) == 1) then
                local PlayerObj = get_dynamic_player(PlayerIndex)
                local WeaponObj = get_object_memory(read_dword(PlayerObj + 0x2F8 + (tonumber(WeaponIndex) - 1) * 4))
                local name = read_string(read_dword(read_word(WeaponObj) * 32 + 0x40440038))
                if (name == "weapons\\flag\\flag" or name == "weapons\\ball\\ball") then
                    if (name == "weapons\\flag\\flag") then
                        object_picked_up[PlayerIndex] = "flag"
                    elseif (name == "weapons\\ball\\ball") then
                        object_picked_up[PlayerIndex] = "oddball"
                    end
                    mod.lurker_warnings = mod.lurker_warnings - 1
                    mod.lurker_warn = true
                    has_objective[PlayerIndex] = true
                    if (mod.lurker_warnings <= 0) then
                        mod.lurker_warnings = 0
                    end
                end
            end
        end
    end
    -- #Infinity Ammo
    if (modEnabled("Lurker", PlayerIndex) and infammo[PlayerIndex]) then
        adjust_ammo(PlayerIndex)
    end
end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    if (PlayerIndex) then
        -- #Infinity Ammo
        if (modEnabled("Infinity Ammo", PlayerIndex) and infammo[PlayerIndex]) then
            adjust_ammo(PlayerIndex)
        end
    end
end

-- #Infinity Ammo
function getFrags(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if player_object ~= 0 and player_present(PlayerIndex) then
        safe_read(true)
        local frags = read_byte(player_object + 0x31E)
        local plasmas = read_byte(player_object + 0x31F)
        safe_read(false)
        if tonumber(frags) <= 0 or tonumber(plasmas) <= 0 then
            return true
        end
    end
    return false
end

function killSilently(PlayerIndex)
    local kill_message_addresss = sig_scan("8B42348A8C28D500000084C9") + 3
    local original = read_dword(kill_message_addresss)
    safe_write(true)
    write_dword(kill_message_addresss, 0x03EB01B1)
    safe_write(false)
    execute_command("kill " .. tonumber(PlayerIndex))
    safe_write(true)
    write_dword(kill_message_addresss, original)
    safe_write(false)
    -- Deduct one death
    local deaths = tonumber(get_var(PlayerIndex, "$deaths"))
    execute_command("deaths " .. tonumber(PlayerIndex) .. " " .. deaths - 1)
end

function CleanUpDrones(TargetID, TableID)
    -- Enter Vehicle
    local function CleanVehicles(TargetID)
        if EV_drone_table[TargetID] ~= nil then
            for k, v in pairs(EV_drone_table[TargetID]) do
                if EV_drone_table[TargetID][k] > 0 then
                    if v then
                        destroy_object(v)
                        EV_drone_table[TargetID][k] = nil
                    end
                end
            end
            EV_drone_table[TargetID] = nil
            ev_NewVehicle[TargetID] = nil
        end
    end

    -- Item Spawner
    local function CleanItems(TargetID)
        if IS_drone_table[TargetID] ~= nil then
            for k, v in pairs(IS_drone_table[TargetID]) do
                if IS_drone_table[TargetID][k] > 0 then
                    if v then
                        destroy_object(v)
                        IS_drone_table[TargetID][k] = nil
                    end
                end
            end
            IS_drone_table[TargetID] = nil
            item_objects[TargetID] = nil
        end
    end

    if (TableID == 1) then
        CleanVehicles(TargetID)
    elseif (TableID == 2) then
        CleanItems(TargetID)
    elseif (TableID == "all" or TableID == "*") then
        CleanVehicles(TargetID)
        CleanItems(TargetID)
    end
end

-----------------------------------------------------------------------------------------------
-- FUNCTIONS USED THROUGHOUT

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

function TagInfo(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function lines_from(file)
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

function checkFile(directory)
    local file = io.open(directory, "rb")
    if file then
        file:close()
        return true
    else
        local file = io.open(directory, "a+")
        if file then
            file:close()
            return true
        end
    end
end

function cls(PlayerIndex)
    if (PlayerIndex) then
        for _ = 1, 25 do
            respond(PlayerIndex, " ", "rcon")
        end
    end
end

function getTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
    end
end

function stringSplit(inp, sep)
    if (sep == nil) then
        sep = "%s"
    end
    local t, i = {}, 1
    for str in gmatch(inp, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function table.match(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function respond(executor, message, environment, color)
    if (executor) then
        color = color or 4 + 8
        if not (isConsole(executor)) then
            if (environment == "chat") then
                say(executor, message)
            elseif (environment == "rcon") then
                rprint(executor, message)
            end
        else
            cprint(message, color)
        end
    end
end

-- #Custom Weapons
function loadWeaponTags()

    -- [ stock weapons ]
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

    -- [ custom weapons ]
    -- snowdrop
    battle_rifle = "halo3\\weapons\\battle rifle\\tactical battle rifle"
end

function cmdsplit(str)
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

    local cmd = subs[1]
    local args = subs
    table.remove(args, 1)

    return cmd, args
end

function DestroyObject(object)
    if object then
        destroy_object(object)
    end
end

function read_widestring(address, length)
    local count = 0
    local byte_table = {}
    for i = 1, length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return concat(byte_table)
end

function secondsToTime(seconds, places)

    local years = floor(seconds / (60 * 60 * 24 * 365))
    seconds = seconds % (60 * 60 * 24 * 365)
    local weeks = floor(seconds / (60 * 60 * 24 * 7))
    seconds = seconds % (60 * 60 * 24 * 7)
    local days = floor(seconds / (60 * 60 * 24))
    seconds = seconds % (60 * 60 * 24)
    local hours = floor(seconds / (60 * 60))
    seconds = seconds % (60 * 60)
    local minutes = floor(seconds / 60)
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

function delete_from_file(dir, start_index, end_index, player)
    local fp = io.open(dir, "r")
    local t = {}
    i = 1;
    for line in fp:lines() do
        if i < start_index or i >= start_index + end_index then
            t[#t + 1] = line
        end
        i = i + 1
    end
    if i > start_index and i < start_index + end_index then
        rprint(player, "Warning: End of File! No entries to delete.")
        cprint("Warning: End of File! No entries to delete.")
    end
    fp:close()
    fp = io.open(dir, "w+")
    for i = 1, #t do
        fp:write(string.format("%s\n", t[i]))
    end
    fp:close()
end

function isFileEmpty(dir)
    local file = io.open(dir, "r")
    local line = file:read()
    if (line == nil) then
        return true
    else
        return false
    end
    file:close()
end

function getCurrentVersion(bool)
    local http_client
    local ffi = require("ffi")
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

    local url = 'https://raw.githubusercontent.com/Chalwk77/HALO-SCRIPT-PROJECTS/master/INDEV/Velocity%20Multi-Mod.lua'
    local version = GetPage(url):match("script_version = (%d+.%d+)")

    if (bool == true) then
        if (tonumber(version) ~= settings.global.script_version) then
            cprint("============================================================================", 5 + 8)
            cprint("[VELOCITY] Version " .. tostring(version) .. " is available for download.")
            cprint("Current version: v" .. settings.global.script_version, 5 + 8)
            cprint("============================================================================", 5 + 8)
        else
            cprint("[VELOCITY] Version " .. settings.global.script_version, 2 + 8)
        end
    end
    return tonumber(version)
end

-- Prints enabled scripts | Called by OnScriptLoad()
function printEnabled()
    cprint("\n----- [ VELOCITY ] -----", 3 + 5)
    for k, _ in pairs(settings.mod) do
        if (settings.mod[k].enabled) then
            cprint(k .. " is enabled", 2 + 8)
        else
            cprint(k .. " is disabled", 4 + 8)
        end
    end
    cprint("----------------------------------\n", 3 + 5)
end

function report()
    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. settings.global.script_version, 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)
end

function OnError()
    cprint(debug.traceback(), 4 + 8)
    timer(50, "report")
end

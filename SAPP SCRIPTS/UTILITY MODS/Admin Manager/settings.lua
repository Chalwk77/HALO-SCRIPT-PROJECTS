return {

    --- CONSOLE LEVEL:
    --
    -- Default level for console commands:
    console_default_level = 6,


    --- PASSWORD LENGTH:
    --
    -- Minimum and maximum password length for password admins:
    password_length_limit = { 4, 32 },


    --- ADMIN LEVEL DELETE CONFIRMATION DELAY:
    --
    -- Confirmation delay (in seconds) for deleting admin levels:
    -- If a player doesn't confirm the deletion within this time, the deletion is cancelled.
    confirmation_delay = 10,


    --- DATABASE DIRECTORIES:
    --
    -- Admin, command and logging data are stored in JSON format in the following files:
    directories = {

        -- Admins database:
        [1] = './Admin Manager/admins.json',

        -- Commands database:
        [2] = './Admin Manager/commands.json',

        [3] = './Admin Manager/logs.json',
    },


    --- LOGGING:
    --
    -- When enabled, management command logs are saved to the ./Admin Manager/logs.json file.
    logging = true,


    --- MANAGEMENT COMMANDS:
    --
    -- Management command permissions can be changed in the ./Admin Manager/commands/<command> directory.
    -- Format: ['<command file name>'] = true (or false)
    -- Setting a command to false will disable it for all players.
    management_commands = {
        ['change_level'] = true,
        ['confirm'] = true,
        ['disable_command'] = true,
        ['enable_command'] = true,
        ['hash_admin_add'] = true,
        ['hash_admin_delete'] = true,
        ['hash_admins'] = true,
        ['ip_admin_add'] = true,
        ['ip_admin_delete'] = true,
        ['ip_admins'] = true,
        ['level_add'] = true,
        ['level_delete'] = true,
        ['login'] = true,
        ['logout'] = true,
        ['pw_admin_add'] = true,
        ['pw_admin_delete'] = true,
        ['pw_admins'] = true,
        ['set_command'] = true,
    },


    --
    --- DEFAULT COMMANDS:
    --
    -- These are the default commands that are available to players at each level:
    -- When the plugin is first installed, these commands are copied to the `commands.json` file.
    -- You can edit the commands in the ./commands.json file, or use the management commands to change them.
    --
    -- Format: ['<level>'] = { ['<command>'] = true (or false) ... }
    -- Setting a command to false will disable it for all players.
    default_commands = {

        -- [!] NOTE:
        -- Level 1 is reserved for public commands.

        ['1'] = { -- public commands
            ['whatsnext'] = true,
            ['usage'] = true,
            ['unstfu'] = true,
            ['stats'] = true,
            ['stfu'] = true,
            ['sv_stats'] = true,
            ['report'] = true,
            ['info'] = true,
            ['lead'] = true,
            ['list'] = true,
            ['login'] = false,
            ['clead'] = true,
            ['about'] = true
        },

        ['2'] = { -- level 2
            ['uptime'] = true,
            ['kdr'] = true,
            ['mapcycle'] = true,
            ['change_password'] = true,
            ['admindel'] = true,
            ['adminadd'] = true,
            ['afk'] = true
        },

        ['3'] = { -- level 3
            ['skips'] = true,
            ['aimbot_scores'] = true
        },

        ['4'] = { -- level 4
            ['say'] = true,
            ['tell'] = true,
            ['mute'] = true,
            ['mutes'] = true,
            ['k'] = true,
            ['afks'] = true,
            ['balance_teams'] = true,
            ['pl'] = true,
            ['st'] = true,
            ['teamup'] = true,
            ['textban'] = true,
            ['textbans'] = true,
            ['textunban'] = true,
            ['unmute'] = true,
        },

        ['5'] = { -- level 5
            ['ub'] = true,
            ['inf'] = true,
            ['ip'] = true,
            ['ipban'] = true,
            ['ipban'] = true,
            ['ipban'] = true,
            ['ipbans'] = true,
            ['ipunban'] = true,
            ['map'] = true,
            ['refresh_ipbans'] = true,
            ['maplist'] = true,
            ['b'] = true,
            ['bans'] = true,
        },

        ['6'] = { -- level 6
            ['admin_add'] = true,
            ['admin_add_manually'] = true,
            ['admin_change_level'] = true,
            ['admin_change_pw'] = true,
            ['admin_del'] = true,
            ['admin_list'] = true,
            ['admin_prefix'] = true,
            ['adminadd_samelevel'] = true,
            ['adminban'] = true,
            ['admindel_samelevel'] = true,
            ['adminlevel'] = true,
            ['admins'] = true,
            ['afk_kick'] = true,
            ['aimbot_ban'] = true,
            ['alias'] = true,
            ['ammo'] = true,
            ['anticamp'] = true,
            ['anticaps'] = true,
            ['anticheat'] = true,
            ['antiglitch'] = true,
            ['antihalofp'] = true,
            ['antilagspawn'] = true,
            ['antispam'] = true,
            ['antiwar'] = true,
            ['area_add_cuboid'] = true,
            ['area_add_sphere'] = true,
            ['area_del'] = true,
            ['area_list'] = true,
            ['area_listall'] = true,
            ['assists'] = true,
            ['auto_update'] = true,
            ['ayy lmao'] = true,
            ['battery'] = true,
            ['beep'] = true,
            ['block_all_objects'] = true,
            ['block_all_vehicles'] = true,
            ['block_object'] = true,
            ['block_tc'] = true,
            ['boost'] = true,
            ['camo'] = true,
            ['cevent'] = true,
            ['chat_console_echo'] = true,
            ['cmd_add'] = true,
            ['cmd_del'] = true,
            ['cmdstart1'] = true,
            ['cmdstart2'] = true,
            ['collect_aliases'] = true,
            ['color'] = true,
            ['console_input'] = true,
            ['coord'] = true,
            ['cpu'] = true,
            ['custom_sleep'] = true,
            ['d'] = true,
            ['deaths'] = true,
            ['debug_strings'] = true,
            ['disable_all_objects'] = true,
            ['disable_all_vehicles'] = true,
            ['disable_backtap'] = true,
            ['disable_object'] = true,
            ['disable_timer_offsets'] = true,
            ['disabled_objects'] = true,
            ['dns'] = true,
            ['enable_object'] = true,
            ['enable_object'] = true,
            ['eventdel'] = true,
            ['events'] = true,
            ['files'] = true,
            ['full_ipban'] = true,
            ['gamespeed'] = true,
            ['god'] = true,
            ['gravity'] = true,
            ['hide_admin'] = true,
            ['hill_timer'] = true,
            ['hp'] = true,
            ['iprangeban'] = true,
            ['kill'] = true,
            ['kills'] = true,
            ['lag'] = true,
            ['loc_add'] = true,
            ['loc_del'] = true,
            ['loc_list'] = true,
            ['loc_listall'] = true,
            ['log'] = true,
            ['log_name'] = true,
            ['log_note'] = true,
            ['log_rotation'] = true,
            ['lua'] = true,
            ['lua_api_v'] = true,
            ['lua_call'] = true,
            ['lua_list'] = true,
            ['lua_load'] = true,
            ['lua_unload'] = true,
            ['m'] = true,
            ['mag'] = true,
            ['map_download'] = true,
            ['map_load'] = true,
            ['map_next'] = true,
            ['map_prev'] = true,
            ['map_query'] = true,
            ['map_skip'] = true,
            ['map_spec'] = true,
            ['mapcycle_add'] = true,
            ['mapcycle_begin'] = true,
            ['mapcycle_del'] = true,
            ['mapvote'] = true,
            ['mapvote_add'] = true,
            ['mapvote_begin'] = true,
            ['mapvote_del'] = true,
            ['mapvotes'] = true,
            ['max_idle'] = true,
            ['max_votes'] = true,
            ['motd'] = true,
            ['msg_prefix'] = true,
            ['mtv'] = true,
            ['nades'] = true,
            ['network_thread'] = true,
            ['no_lead'] = true,
            ['object_sync_cleanup'] = true,
            ['packet_limit'] = true,
            ['ping_kick'] = true,
            ['query_add'] = true,
            ['query_del'] = true,
            ['query_del'] = true,
            ['query_list'] = true,
            ['reload'] = true,
            ['reload_gametypes'] = true,
            ['remote_console'] = true,
            ['remote_console_list'] = true,
            ['remote_console_port'] = true,
            ['rprint'] = true,
            ['s'] = true,
            ['sapp_console'] = true,
            ['sapp_mapcycle'] = true,
            ['sapp_rcon'] = true,
            ['save_respawn_time'] = true,
            ['save_scores'] = true,
            ['say_prefix'] = true,
            ['score'] = true,
            ['scorelimit'] = true,
            ['scrim_mode'] = true,
            ['set_ccolor'] = true,
            ['setadmin'] = true,
            ['setcmd'] = true,
            ['setcmd'] = true,
            ['sh'] = true,
            ['sj_level'] = true,
            ['spawn'] = true,
            ['spawn_protection'] = true,
            ['t'] = true,
            ['t'] = true,
            ['team_score'] = true,
            ['team_score'] = true,
            ['text'] = true,
            ['timelimit'] = true,
            ['tp'] = true,
            ['unblock_object'] = true,
            ['ungod'] = true,
            ['unlag'] = true,
            ['unlock_console_log'] = true,
            ['v'] = true,
            ['var_add'] = true,
            ['var_conv'] = true,
            ['var_del'] = true,
            ['var_list'] = true,
            ['var_set'] = true,
            ['vdel'] = true,
            ['vdel_all'] = true,
            ['venter'] = true,
            ['vexit'] = true,
            ['wadd'] = true,
            ['wdel'] = true,
            ['wdrop'] = true,
            ['yeye'] = true,
            ['zombies'] = true
        }
    }
}


--
-- DEFAULT ADMIN EXAMPLES:
--

--[[


    EXAMPLE HASH-ADMIN FORMAT:
    hash_admins = {
        ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx] = {
            name = 'BOB',
            level = 6
        }
    }

    EXAMPLE IP-ADMIN FORMAT:
        hash_admins = {
            ["127.0.0.1"] = {
                name = 'BOB',
                level = 6
            },
            ["xxx.xxx.xxx.xxx"] = {
                 name = 'NAME',
                level = 1
            }
        }
    }

    EXAMPLE PASSWORD-ADMIN FORMAT:
    password_admins = {
        ["BOB"] = {
            password = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
            level = 6
        },
        ["ANOTHER NAME"] = {
            password = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
            level = 1
        }
    }

]]
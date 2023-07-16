This plugin replaces SAPP's built-in admin system and adds a few new features:

- Add as many admin levels as you want.
- Configure each admin level to have access to any command you want.
- Add admins by IP, Hash or Username & Password.
- Passwords and usernames are case-sensitive but may contain spaces.
- You can add/remove admins and commands manually by editing the relevant files (commands.json/admins.json) or with
  handy commands.
- Custom ban commands, including the ability to ban by IP, Hash or both.
- Mute commands, including the ability to mute by IP, Hash or both.
- Name ban command (ban desirable usernames).

Admin levels follow a hierarchy system. For example, if you add an admin by IP and Hash, the admin level will be the
highest of the two. Furthermore, a player will inherit all commands from the admin levels below their own.

## Management Commands:

todo: -- ADD COMMANDS ABOVE hash_ban, hash_bans, hash_unban, ip_ban, ip_bans, ip_unban, silence, silence_list, unsilence

| Command                                                                                                    | Description                                      | Permission Level |
|------------------------------------------------------------------------------------------------------------|--------------------------------------------------|------------------|
| **hash_admin_add** `<player id>` `<level>`                                                                 | Add player as a hash-admin                       | **6**            |
| **hash_admin_del** `<player id>`                                                                           | Remove player as a hash-admin                    | **6**            |
| **hash_admin_list**                                                                                        | List all hash-admins                             | **6**            |
| **ip_admin_add** `<player id>` `<level>`                                                                   | Add player as an ip-admin                        | **6**            | 
| **ip_admin_del** `<player id>`                                                                             | Remove player as an ip-admin                     | **6**            |
| **ip_admin_list**                                                                                          | List all ip-admins                               | **6**            |
| **pw_admin_add** `<player id>` `<level> <password>`                                                        | Add player as a password-admin                   | **6**            |
| **pw_admin_del** `<player id>`                                                                             | Remove player as a password-admin                | **6**            |
| **pw_admin_list**                                                                                          | List all password-admins                         | **6**            |
| **l** `<password>`                                                                                         | Login with a password (username is your IGN)     | **6**            |
| **lo**                                                                                                     | Logout of the server                             | **6**            |
| **change_level** `<player id>` `<type (hash/ip/password)>`                                                 | Change player admin level                        | **6**            |
| **level_add** `<level>`                                                                                    | Add an admin level                               | **6**            |
| **level_delete** `<level>`                                                                                 | Delete an admin level (requires confirmation)    | **6**            |
| **confirm**                                                                                                | Confirm level delete                             | **6**            |
| **set_command** `<command>` `<level>` `(opt 3rd arg: "true" to enable, "false" to disable)`                | Add or set a new/existing command to a new level | **6**            |
| **disable_command** `<command>`                                                                            | Disables a command                               | **6**            |
| **enable_command** `<command>`                                                                             | Enables a command                                | **6**            |
| **WORK IN PROGRESS**<br/><br/>**hash_ban** `<player id>` `<flag (-y -mo -d -h -m -s -r "example reason")>` | Ban a player by hash                             | **6**            |
| **WORK IN PROGRESS**<br/><br/>**hash_bans**                                                                | List all hash-bans                               | **6**            |
| **WORK IN PROGRESS**<br/><br/>**hash_unban** `<ban id>`                                                    | Unban a player's hash                            | **6**            |
| **WORK IN PROGRESS**<br/><br/>**ip_ban** `<player id>` `<flag (-y -mo -d -h -m -s -r "example reason")>`   | Ban a player by IP                               | **6**            |
| **WORK IN PROGRESS**<br/><br/>**ip_bans**                                                                  | List all IP-bans                                 | **6**            |
| **WORK IN PROGRESS**<br/><br/>**ip_unban** `<ban id>`                                                      | Unban a player's IP                              | **6**            |
| **WORK IN PROGRESS**<br/><br/>**silence** `<player id>` `<flag (-y -mo -d -h -m -s -r "example reason")>`  | Silence a player                                 | **6**            |
| **WORK IN PROGRESS**<br/><br/>**silence_list**                                                             | List all silenced players                        | **6**            |
| **WORK IN PROGRESS**<br/><br/>**unsilence** `<player id>`                                                  | Unsilence a player                               | **6**            |

Each management command above has a permission level.

The permission level is the minimum admin level required to use the command.
This can be edited inside the *./Admin Manager/commands/<command>* directory.

Additionally, each command has a `help` argument - this will display the command's usage and description. For
example: `hash_admin_add help`

### Getting started:

Before you can add members of your clan/community as admins, you must first add yourself as an admin.
This can be done by joining the server and executing one of the admin-add commands from the server console.
Once you're an admin, you can add other admins in-game using the desired admin-add command.

### Password encryption:

> Passwords are encrypted using the SHA256 algorithm.

### Admin database:

> The admin database is stored in the `admins.json` file. This file is created automatically when the plugin is loaded.
> The file is located in the `./Admin Manager` folder.

### Banning:

> Bans are stored in the `bans.json` file. This file is created automatically when the plugin is loaded.

You can optionally ban by:

- IP, Hash or both.
- Time (years, months, days, hours, minutes, seconds).

Ban command examples:
---
/hash_ban `1` `-y 1` `-mo 6` `-d 5` `-h 2` `-m 25` `-s 10` `-r "example reason"`
> Bans a player by hash for 1 year, 6 months, 5 days, 2 hours, 25 minutes and 10 seconds.
---

- /ip_ban `1` `-h 1`

> Bans a player by IP for 1 hour.

The order of the flags doesn't matter, but the player id must be the first argument.

### Logging:

> Admin commands are logged in the `logs.json` file. This file is created automatically when the plugin is loaded.
> You can optionally log management commands and/or default commands.

## Default Command Permissions:

```json
{
  "1": {
    "about": true,
    "clead": true,
    "info": true,
    "lead": true,
    "list": true,
    "login": true,
    "report": true,
    "stats": true,
    "stfu": true,
    "sv_stats": true,
    "unstfu": true,
    "usage": true,
    "whatsnext": true
  },
  "2": {
    "adminadd": true,
    "admindel": true,
    "afk": true,
    "change_password": true,
    "kdr": true,
    "mapcycle": true,
    "uptime": true
  },
  "3": {
    "aimbot_scores": true,
    "skips": true
  },
  "4": {
    "afks": true,
    "balance_teams": true,
    "k": true,
    "mute": true,
    "mutes": true,
    "pl": true,
    "say": true,
    "st": true,
    "teamup": true,
    "tell": true,
    "textban": true,
    "textbans": true,
    "textunban": true,
    "unmute": true
  },
  "5": {
    "b": true,
    "bans": true,
    "inf": true,
    "ip": true,
    "ipban": true,
    "ipbans": true,
    "ipunban": true,
    "map": true,
    "maplist": true,
    "refresh_ipbans": true,
    "ub": true
  },
  "6": {
    "admin_add": true,
    "admin_add_manually": true,
    "admin_change_level": true,
    "admin_change_pw": true,
    "admin_del": true,
    "admin_list": true,
    "admin_prefix": true,
    "adminadd_samelevel": true,
    "adminban": true,
    "admindel_samelevel": true,
    "adminlevel": true,
    "admins": true,
    "afk_kick": true,
    "aimbot_ban": true,
    "alias": true,
    "ammo": true,
    "anticamp": true,
    "anticaps": true,
    "anticheat": true,
    "antiglitch": true,
    "antihalofp": true,
    "antilagspawn": true,
    "antispam": true,
    "antiwar": true,
    "area_add_cuboid": true,
    "area_add_sphere": true,
    "area_del": true,
    "area_list": true,
    "area_listall": true,
    "assists": true,
    "auto_update": true,
    "ayy lmao": true,
    "battery": true,
    "beep": true,
    "block_all_objects": true,
    "block_all_vehicles": true,
    "block_object": true,
    "block_tc": true,
    "boost": true,
    "camo": true,
    "cevent": true,
    "chat_console_echo": true,
    "cmd_add": true,
    "cmd_del": true,
    "cmdstart1": true,
    "cmdstart2": true,
    "collect_aliases": true,
    "color": true,
    "console_input": true,
    "coord": true,
    "cpu": true,
    "custom_sleep": true,
    "d": true,
    "deaths": true,
    "debug_strings": true,
    "disable_all_objects": true,
    "disable_all_vehicles": true,
    "disable_backtap": true,
    "disable_object": true,
    "disable_timer_offsets": true,
    "disabled_objects": true,
    "dns": true,
    "enable_object": true,
    "eventdel": true,
    "events": true,
    "files": true,
    "full_ipban": true,
    "gamespeed": true,
    "god": true,
    "gravity": true,
    "hide_admin": true,
    "hill_timer": true,
    "hp": true,
    "iprangeban": true,
    "kill": true,
    "kills": true,
    "lag": true,
    "loc_add": true,
    "loc_del": true,
    "loc_list": true,
    "loc_listall": true,
    "log": true,
    "log_name": true,
    "log_note": true,
    "log_rotation": true,
    "lua": true,
    "lua_api_v": true,
    "lua_call": true,
    "lua_list": true,
    "lua_load": true,
    "lua_unload": true,
    "m": true,
    "mag": true,
    "map_download": true,
    "map_load": true,
    "map_next": true,
    "map_prev": true,
    "map_query": true,
    "map_skip": true,
    "map_spec": true,
    "mapcycle_add": true,
    "mapcycle_begin": true,
    "mapcycle_del": true,
    "mapvote": true,
    "mapvote_add": true,
    "mapvote_begin": true,
    "mapvote_del": true,
    "mapvotes": true,
    "max_idle": true,
    "max_votes": true,
    "motd": true,
    "msg_prefix": true,
    "mtv": true,
    "nades": true,
    "network_thread": true,
    "no_lead": true,
    "object_sync_cleanup": true,
    "packet_limit": true,
    "ping_kick": true,
    "query_add": true,
    "query_del": true,
    "query_list": true,
    "reload": true,
    "reload_gametypes": true,
    "remote_console": true,
    "remote_console_list": true,
    "remote_console_port": true,
    "rprint": true,
    "s": true,
    "sapp_console": true,
    "sapp_mapcycle": true,
    "sapp_rcon": true,
    "save_respawn_time": true,
    "save_scores": true,
    "say_prefix": true,
    "score": true,
    "scorelimit": true,
    "scrim_mode": true,
    "set_ccolor": true,
    "setadmin": true,
    "setcmd": true,
    "sh": true,
    "sj_level": true,
    "spawn": true,
    "spawn_protection": true,
    "t": true,
    "team_score": true,
    "text": true,
    "timelimit": true,
    "tp": true,
    "unblock_object": true,
    "ungod": true,
    "unlag": true,
    "unlock_console_log": true,
    "v": true,
    "var_add": true,
    "var_conv": true,
    "var_del": true,
    "var_list": true,
    "var_set": true,
    "vdel": true,
    "vdel_all": true,
    "venter": true,
    "vexit": true,
    "wadd": true,
    "wdel": true,
    "wdrop": true,
    "yeye": true,
    "zombies": true
  }
}
```

### ⚠️ WARNING ⚠️

> For this system to work, all players are given SAPP level 4.
> In the rare event that this plugin crashes, all players will have unrestricted access to SAPP's commands.

# INSTALLATION:

The release zip contains:

- **Admin Manager.lua** (sapp script)
- **Admin Manager** (folder)

Note: You will need a file decompression tool like [WinRAR](https://www.win-rar.com/start.html?&L=0)
or [7-zip](https://www.7-zip.org/download.html) to extract the **Admin.Manager.zip** file (download at bottom of page).

Place the **Admin Manager.lua** script in the servers *Lua folder*.
The **Admin Manager** folder MUST go in the server's root directory (the same location as *sapp.dll* & *strings.dll*).

### CONFIGURATION:

All configuration is done from within a file called **settings.lua**, located in the **Admin Manager** folder.
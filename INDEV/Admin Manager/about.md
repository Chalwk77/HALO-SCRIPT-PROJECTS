This plugin replaces SAPP's built-in admin system and adds a few new features:

- Add as many admin levels as you want.
- Configure each admin level to have access to any command you want.
- Add admins by IP, Hash or Username & Password.
- Passwords and usernames are case-sensitive but may contain spaces.
- You can add/remove admins and commands manually by editing the relevant files (commands.json/admins.json) or with
  handy commands.
- Custom ban commands, including the ability to ban by IP or Hash.
- Mute command includes the ability to mute by IP only (muting by hash will come in a future update).
- Name ban command lets you block players from using a specific name.
- Command spy (see commands executed by other players).
- VIP messages (custom admin join messages).
- Admin chat (custom text channel for admins only).

Admin levels follow a hierarchy system. For example, if you add an admin by IP and Hash, the admin level will be the
highest of the two. Furthermore, a player will inherit all commands from the admin levels below their own.

## <ins>Management Commands:

| Command                                                                                     | Description                                                         | Permission Level |
|---------------------------------------------------------------------------------------------|---------------------------------------------------------------------|------------------|
| **hash_admin_add** `<player id>` `<level>`                                                  | Add player as a hash-admin                                          | **6**            |
| **hash_admin_del** `<player id>`                                                            | Remove player as a hash-admin                                       | **6**            |
| **hash_admins** `<page>`                                                                    | List all hash-admins                                                | **6**            |
| **ip_admin_add** `<player id>` `<level>`                                                    | Add player as an ip-admin                                           | **6**            | 
| **ip_admin_del** `<player id>`                                                              | Remove player as an ip-admin                                        | **6**            |
| **ip_admins** `<page>`                                                                      | List all ip-admins                                                  | **6**            |
| **pw_admin_add** `<player id>` `<level> <password>`                                         | Add player as a password-admin                                      | **6**            |
| **pw_admin_del** `<player id>`                                                              | Remove player as a password-admin                                   | **6**            |
| **pw_admins** `<page>`                                                                      | List all password-admins                                            | **6**            |
| **login** `<password>`                                                                      | Login with a password (username is your IGN)                        | **6**            |
| **logout**                                                                                  | Logout of the server                                                | **6**            |
| **change_level** `<player id>` `<type (hash/ip/password)>`                                  | Change player admin level                                           | **6**            |
| **level_add** `<level>`                                                                     | Add an admin level                                                  | **6**            |
| **level_delete** `<level>`                                                                  | Delete an admin level (requires confirmation)                       | **6**            |
| **confirm**                                                                                 | Confirm level delete                                                | **6**            |
| **set_command** `<command>` `<level>` `(opt 3rd arg: "true" to enable, "false" to disable)` | Add or set a new/existing command to a new level                    | **6**            |
| **disable_command** `<command>`                                                             | Disables a command                                                  | **6**            |
| **enable_command** `<command>`                                                              | Enables a command                                                   | **6**            |
| **hash_ban** `<player id>` `<flag (-y -mo -d -h -m -s -r "example reason")>`                | Ban a player by hash (requires confirmation if the hash is pirated) | **6**            |
| **hash_bans** `<page>`                                                                      | List all hash-bans                                                  | **6**            |
| **hash_unban** `<ban id>`                                                                   | Unban a player's hash                                               | **6**            |
| **ip_ban** `<player id>` `<flag (-y -mo -d -h -m -s -r "example reason")>`                  | Ban a player by IP                                                  | **6**            |
| **ip_bans** `<page>`                                                                        | List all IP-bans                                                    | **6**            |
| **ip_unban** `<ban id>`                                                                     | Unban a player's IP                                                 | **6**            |
| **name_ban** `<player id or name>`                                                          | Ban a players name by ID or name                                    | **6**            |
| **name_bans** `<page>`                                                                      | List all name bans                                                  | **6**            |
| **name_unban** `<ban id>`                                                                   | Unban a name                                                        | **6**            |
| **mute** `<player id>` `<flag (-y -mo -d -h -m -s -r "example reason")>`                    | Mute a player by IP                                                 | **6**            |
| **mutes** `<page>`                                                                          | List all muted players                                              | **6**            |
| **unmute** `<player id>`                                                                    | Unmute a player's IP                                                | **6**            |
| **admin_chat** `<1/0 (on/off)>`                                                             | Toggle admin chat on or off for yourself                            | **6**            |
| **spy** `<1/0 (on/off)>`                                                                    | Toggle command spy on or off for yourself                           | **6**            |
| **ip_alias** `<player/ip>` `<page>`                                                         | Lookup aliases by player id or ip                                   | **6**            |
| **hash_alias** `<player/hash>` `<page>`                                                     | Lookup aliases by player id or hash                                  | **6**            |

Each management command above has a permission level.

The permission level is the minimum admin level required to use the command.
This can be edited inside the *./Admin Manager/commands/<command>* directory.

Additionally, each command has a `help` argument - this will display the command's usage and description. For
example: `hash_admin_add help`

---

### <ins>Getting started:

Before you can add members of your clan/community as admins, you must first add yourself as an admin.
Access to the server terminal is required to do this (one-time only).
This can be done by following this procedure:

- Join the server.
- Execute one of the admin-add (*hash_admin_add*, *ip_admin_add*, *pw_admin_add*) commands from the server console (
  terminal).

Once you're an admin, you will be able to add other admins while in-game.

---

### <ins>Password encryption:

> Passwords are encrypted using the SHA256 algorithm.

---

### <ins>Admin database:

> The admin database is stored in the `admins.json` file. This file is created automatically when the plugin is loaded.
> The file is located in the `./Admin Manager` folder.

---

### <ins>Banning:

> Bans are stored in the `bans.json` file. This file is created automatically when the plugin is loaded.

You can optionally ban by:

- IP, Hash or Text.
- Time (years, months, days, hours, minutes, seconds).

Ban command examples:

- /hash_ban `1` `-y 1` `-mo 6` `-r "caught cheating"`

> Bans a player by hash for 1 year, 6 months.

- /ip_ban `1` `-h 1`

> Bans a player by IP for 1 hour.

The order of the flags doesn't matter, but the player id must be the first argument.

Shared CD Key hashes are detected automatically.
If a player has a shared CD Key hash, the admin will be informed
and will have to confirm the ban by typing */confirm*.
Otherwise, the action will time out after 10 seconds.

---

### <ins>Logging:

> Admin commands are logged in the `logs.json` file. This file is created automatically when the plugin is loaded.
> You can optionally log management commands and/or default commands.

---

## <ins>Default Command Permissions:

> Default command permissions are stored in the `./Admin Manager/commands.json` file.
> This file is created automatically when the plugin is loaded.

The default command permissions are as follows:

- 1: Public
- 2: Moderator
- 3: Admin
- 4: Senior Admin
- 5: Head Admin
- 6: Owner

Add your own *custom levels* in the `./Admin Manager/commands.json` file, or edit the existing ones.
You can also add or remove levels using the `level_add` and `level_delete` commands.
There is no limit to the number of levels you can add. Just make sure there is at least one level with the `1` key.

If a command's value is set to `true`, then the command is enabled for that permission level.

You can define custom commands in this file, and it will manage the required permission level for those commands.

```json
{
  "1": {
    "about": true,
    "clead": true,
    "info": true,
    "lead": true,
    "list": false,
    "report": true,
    "stats": true,
    "stfu": true,
    "sv_stats": true,
    "unstfu": true,
    "usage": true,
    "whatsnext": true
  },
  "2": {
    "adminadd": false,
    "admindel": false,
    "afk": true,
    "change_password": false,
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
    "mute": false,
    "mutes": false,
    "pl": true,
    "say": true,
    "st": true,
    "teamup": true,
    "tell": true,
    "textban": false,
    "textbans": false,
    "textunban": false,
    "unmute": false
  },
  "5": {
    "b": false,
    "bans": false,
    "inf": true,
    "ip": true,
    "ipban": false,
    "ipbans": false,
    "ipunban": false,
    "map": true,
    "maplist": true,
    "refresh_ipbans": false,
    "ub": false
  },
  "6": {
    "admin_add": false,
    "admin_add_manually": false,
    "admin_change_level": false,
    "admin_change_pw": false,
    "admin_del": false,
    "admin_list": false,
    "admin_prefix": true,
    "adminadd_samelevel": false,
    "adminban": false,
    "admindel_samelevel": false,
    "adminlevel": false,
    "admins": false,
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
    "full_ipban": false,
    "gamespeed": true,
    "god": true,
    "gravity": true,
    "hide_admin": false,
    "hill_timer": true,
    "hp": true,
    "iprangeban": false,
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
    "setadmin": false,
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
--[[
--=====================================================================================================--
Script Name: Admin Manager, for SAPP (PC & CE)
Description: Custom Admin Manager

------------
- features -
------------

* Overrides SAPP's admin-level system.

* Allow the end-user to choose at what level certain commands be used
  and also introduces custom admin levels.

* This system will accommodate any number of custom levels with a table of associative commands.
------------------------------------------------------------------------------------------------

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local AdminManager = {

    management_commands = {

        -- COMMAND TO ADD IP-ADMIN:
        --
        {
            command = "ip_admin_add",
            permission_level = 1
        },

        -- COMMAND TO DELETE IP-ADMIN:
        --
        {
            command = "ip_admin_delete",
            permission_level = 1
        },

        -- COMMAND TO ADD HASH-ADMIN:
        --
        {
            command = "hash_admin_add",
            permission_level = 1
        },

        -- COMMAND TO DELETE HASH-ADMIN:
        --
        {
            command = "hash_admin_delete",
            permission_level = 1
        },

        -- COMMAND TO ADD PASSWORD-ADMIN:
        --
        {
            command = "pw_admin_add",
            permission_level = 1
        },

        -- COMMAND TO DEL PASSWORD-ADMIN:
        --
        {
            command = "pw_admin_delete",
            permission_level = 1
        },

        -- COMMAND TO VIEW ALL IP-ADMIN:
        --
        {
            command = "ip_admins",
            permission_level = 1
        },

        -- COMMAND TO VIEW ALL HASH-ADMIN:
        --
        {
            command = "hash_admins",
            permission_level = 1
        },

        -- COMMAND TO VIEW ALL PASSWORD-ADMIN:
        --
        {
            command = "pw_admins",
            permission_level = 1
        },

        -- COMMAND TO LOGIN:
        --
        {
            command = "login",
            permission_level = 1
        }
    },

    directories = {
        [1] = "admins.json",
        [2] = "commands.json"
    },

    -- Default commands --
    --
    -- When the script is loaded for the first time
    -- These will be the default commands settings:
    --
    commands = {

        ["1"] = { -- public commands
            "whatsnext",
            "usage",
            "unstfu",
            "stats",
            "stfu",
            "sv_stats",
            "report",
            "info",
            "lead",
            "list",
            "login",
            "clead",
            "about"
        },

        ["2"] = { -- level 2
            "uptime",
            "kdr",
            "mapcycle",
            "change_password",
            "admindel",
            "adminadd",
            "afk"
        },

        ["3"] = { -- level 3
            "skips",
            "aimbot_scores"
        },

        ["4"] = { -- level 4
            "say",
            "tell",
            "mute",
            "mutes",
            "k",
            "afks",
            "balance_teams",
            "pl",
            "st",
            "teamup",
            "textban",
            "textbans",
            "textunban",
            "unmute"
        },

        ["5"] = { -- level 5
            "ub",
            "inf",
            "ip",
            "ipban",
            "ipban",
            "ipban",
            "ipbans",
            "ipunban",
            "map",
            "refresh_ipbans",
            "maplist",
            "b",
            "bans"
        },

        ["6"] = { -- level 6
            "admin_add",
            "admin_add_manually",
            "admin_change_level",
            "admin_change_pw",
            "admin_del",
            "admin_list",
            "admin_prefix",
            "adminadd_samelevel",
            "adminban",
            "admindel_samelevel",
            "adminlevel",
            "admins",
            "afk_kick",
            "aimbot_ban",
            "alias",
            "ammo",
            "anticamp",
            "anticaps",
            "anticheat",
            "antiglitch",
            "antihalofp",
            "antilagspawn",
            "antispam",
            "antiwar",
            "area_add_cuboid",
            "area_add_sphere",
            "area_del",
            "area_list",
            "area_listall",
            "assists",
            "auto_update",
            "ayy lmao",
            "battery",
            "beep",
            "block_all_objects",
            "block_all_vehicles",
            "block_object",
            "block_tc",
            "boost",
            "camo",
            "cevent",
            "chat_console_echo",
            "cmd_add",
            "cmd_del",
            "cmdstart1",
            "cmdstart2",
            "collect_aliases",
            "color",
            "console_input",
            "coord",
            "cpu",
            "custom_sleep",
            "d",
            "deaths",
            "debug_strings",
            "disable_all_objects",
            "disable_all_vehicles",
            "disable_backtap",
            "disable_object",
            "disable_timer_offsets",
            "disabled_objects",
            "dns",
            "enable_object",
            "enable_object",
            "eventdel",
            "events",
            "files",
            "full_ipban",
            "gamespeed",
            "god",
            "gravity",
            "hide_admin",
            "hill_timer",
            "hp",
            "iprangeban",
            "kill",
            "kills",
            "lag",
            "loc_add",
            "loc_del",
            "loc_list",
            "loc_listall",
            "log",
            "log_name",
            "log_note",
            "log_rotation",
            "lua",
            "lua_api_v",
            "lua_call",
            "lua_list",
            "lua_load",
            "lua_unload",
            "m",
            "mag",
            "map_download",
            "map_load",
            "map_next",
            "map_prev",
            "map_query",
            "map_skip",
            "map_spec",
            "mapcycle_add",
            "mapcycle_begin",
            "mapcycle_del",
            "mapvote",
            "mapvote_add",
            "mapvote_begin",
            "mapvote_del",
            "mapvotes",
            "max_idle",
            "max_votes",
            "motd",
            "msg_prefix",
            "mtv",
            "nades",
            "network_thread",
            "no_lead",
            "object_sync_cleanup",
            "packet_limit",
            "ping_kick",
            "query_add",
            "query_del",
            "query_del",
            "query_list",
            "reload",
            "reload_gametypes",
            "remote_console",
            "remote_console_list",
            "remote_console_port",
            "rprint",
            "s",
            "sapp_console",
            "sapp_mapcycle",
            "sapp_rcon",
            "save_respawn_time",
            "save_scores",
            "say_prefix",
            "score",
            "scorelimit",
            "scrim_mode",
            "set_ccolor",
            "setadmin",
            "setcmd",
            "setcmd",
            "sh",
            "sj_level",
            "spawn",
            "spawn_protection",
            "t",
            "t",
            "team_score",
            "team_score",
            "text",
            "timelimit",
            "tp",
            "unblock_object",
            "ungod",
            "unlag",
            "unlock_console_log",
            "v",
            "var_add",
            "var_conv",
            "var_del",
            "var_list",
            "var_set",
            "vdel",
            "vdel_all",
            "venter",
            "vexit",
            "wadd",
            "wdel",
            "wdrop",
            "yeye",
            "zombies"
        }
    }
}

-- todo: add command to create new admin level
-- new_level [level] {args}
-- level_add {args}

-- One-time load of JSON routines:
local json = (loadfile "json.lua ")()

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnCommand")
    register_callback(cb["EVENT_JOIN"], "UpdateNameField")
    AdminManager:LoadFiles()
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

local function GetClientDetails(Ply)
    local name = get_var(Ply, "$name")
    local hash = get_var(Ply, "$hash")
    local ip = get_var(Ply, "$ip"):match("%d+.%d+.%d+.%d+")
    return name, hash, ip
end

local function WriteToFile(Dir, Content)
    local file = assert(io.open(Dir, "w"))
    if (file) then
        file:write(json:encode_pretty(Content))
        file:close()
    end
end

local function CMDSplit(CMD)
    local Args = { }
    for Params in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end
    return Args
end

function AdminManager:HasPermission(Ply, RequiredLevel)
    local level = self:GetPermissionLevel(Ply)
    if (tonumber(level) >= tonumber(RequiredLevel)) then
        return true
    else
        return false, Respond(Ply, "Insufficient Permission")
    end
end

function AdminManager:OnCommand(Executor, CMD, _, _)

    local Args = CMDSplit(CMD)
    if (Args) then

        for CommandIndex, v in pairs(self.management_commands) do
            if (Args[1] == v.command) then

                if self:HasPermission(Executor, v.permission_level) then

                    -- Command to add a new ip-admin:
                    --
                    if (CommandIndex == 1) then

                        local new_level = tonumber(Args[3])
                        local highest_level = #self.commands
                        local lowest_level = tonumber(self:GetLowestLevel())

                        -- Check if level is valid:
                        if (new_level and new_level >= lowest_level and new_level <= highest_level) then

                            local pl = self:GetPlayers(Executor, Args)
                            if (pl) then
                                local update_admins
                                for i = 1, #pl do
                                    local TargetID = tonumber(pl[i])
                                    local _, params = self:GetPermissionLevel(TargetID)
                                    if (not params.ip_admin) then
                                        self.admins[params.ip] = { name = params.name, level = new_level }
                                        update_admins = true
                                        execute_command("adminadd " .. TargetID .. " 4")
                                    else
                                        Respond(Executor, params.name .. " is already an ip-admin!")
                                    end
                                end
                                if (update_admins) then
                                    WriteToFile(self.directories[1], self.admins)
                                end
                            end
                        else
                            Respond(Executor, "Invalid Level. Please type a number between " .. lowest_level .. " & " .. highest_level)
                            goto done
                        end
                    elseif (CommandIndex == 2) then
                        if (Args[3]) then
                            local pl = self:GetPlayers(Executor, Args)
                            if (pl) then
                                local update_admins
                                for i = 1, #pl do
                                    local TargetID = tonumber(pl[i])
                                    local _, params = self:GetPermissionLevel(TargetID)
                                    if (not params.hash_admin) then
                                        self.admins[params.hash] = { name = params.name, level = Args[3] }
                                        update_admins = true
                                        execute_command("admin_add " .. TargetID .. " 4")
                                    else
                                        Respond(Executor, params.name .. " is already a hash-admin!")
                                    end
                                end
                                if (update_admins) then
                                    WriteToFile(self.directories[1], self.admins)
                                end
                            end
                        else
                            Respond(Executor, "Invalid Syntax. Usage: " .. v.command .. " [Admin ID] {Level}")
                            goto done
                        end
                    end
                end
                goto done
            end
        end
    end

    -- Logic that determines whether a player can execute a command or not:
    --
    for RequiredLevel, CommandTable in pairs(self.commands) do
        for _, Command in pairs(CommandTable) do
            if (CMD:sub(1, Command:len()):lower() == Command) then
                if not self:HasPermission(Executor, RequiredLevel) then
                    print("no permission")
                    return false
                end
                print("Player has permission. Executing /" .. Command)
                return true
            end
        end
    end

    :: done ::

    return false
end

local function GetContent(Dir)
    local content = ""
    local file = io.open(Dir, "r")
    if (file) then
        content = file:read("*all")
        file:close()
    end
    return content
end

function AdminManager:UpdateNameField(Ply)

    local name, hash, ip = GetClientDetails(Ply)

    local a = self.admins[ip]
    local b = self.admins[hash]

    -- Check if we need to update this players name:
    --
    local update
    if (a and a.name ~= name) then
        a.name, update = name, true
    elseif (b and b.name ~= name) then
        b.name, update = name, true
    end

    if (update) then
        WriteToFile(self.directories[1], self.admins)
    end
end

function AdminManager:GetPlayers(Executor, Args)
    local pl = { }
    if (Args[2] == "me" or Args[2] == nil) then
        if (Executor ~= 0) then
            table.insert(pl, Executor)
        else
            Respond(Executor, "The server cannot execute this command!", 10)
        end
    elseif (Args[2] ~= nil and Args[2]:match("^%d+$")) then
        if player_present(Args[2]) then
            table.insert(pl, Args[2])
        else
            Respond(Executor, "Player #" .. Args[2] .. " is not online", 10)
        end
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
        if (#pl == 0) then
            Respond(Executor, "There are no players online!", 10)
        end
    else
        Respond(Executor, "Invalid Player Expression. Please try again!", 10)
    end
    return pl
end

function AdminManager:GetPermissionLevel(Ply)

    local params = { }
    local name, hash, ip = GetClientDetails(Ply)

    local a = self:GetLowestLevel() -- public
    local b = self.admins[ip] -- ip admin
    local c = self.admins[hash] -- hash admin

    params.ip = ip
    params.hash = hash
    params.name = name

    params.ip_admin = b
    params.hash_admin = c

    -- Set server level to max admin level:
    --
    if (Ply == 0) then
        a = #self.commands
    end

    return (b and tostring(b.level) or c and tostring(c.level) or a), params
end

function AdminManager:GetLowestLevel()
    for Level, _ in pairs(self.commands) do
        return Level
    end
end

function AdminManager:LoadFiles()

    if (get_var(0, "$gt") ~= "n/a") then
        for i = 1, 16 do
            if player_present(i) then
                self:UpdateNameField(i)
            end
        end
    end

    -- Load admins:
    --
    local admins = GetContent(self.directories[1])
    admins = json:decode(admins)

    self.admins = admins or {}

    -- Create empty array in admins.json:
    --
    if (not admins) then
        WriteToFile(self.directories[1], self.admins)
    end
    --

    -- Load commands:
    --
    local commands = GetContent(self.directories[2])
    commands = json:decode(commands)

    self.commands = commands or self.commands

    -- Save default commands to self.directories[2]:
    --
    if (not commands) then
        cprint('Creating default command table in ' .. self.directories[2], 10)
        WriteToFile(self.directories[2], self.commands)
    end

    -- Convert an un-ordered string-indexed array into numerically indexed array:
    --
    local t = {}
    for Level, CommandTable in pairs(self.commands) do
        t[tonumber(Level)] = CommandTable
    end
    self.commands = t
end

function OnCommand(Ply, CmD, EnV, PWD)
    AdminManager:OnCommand(Ply, CmD, EnV, PWD)
end

function UpdateNameField(Ply)
    return AdminManager:UpdateNameField(Ply)
end

function OnScriptUnload()
    -- N/A
end
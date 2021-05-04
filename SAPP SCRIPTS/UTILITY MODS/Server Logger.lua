--[[
--=====================================================================================================--
Script Name: Server Logger, for SAPP (PC & CE)
Description: This script is intended to replace SAPP's built-in logger

This script will log:
* Join & Quit events
* Game Start Events
* Game End Events
* Script Load, Re-Load & Script Unload Events
* Global Chat
* Team Chat
* Vehicle Chat
* Chat Commands & RCON/Console

There is an additional option to prevent messages or commands containing sensitive information from being logged.
Sensitive Information is defined in a table called sensitive_content.

See config section for more information.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local Logger = {

    --
    -- CONFIGURATION STARTS HERE --
    --

    -- Server log directory:
    dir = "Server Log.txt",


    --====================--
    -- SENSITIVE CONTENT  --
    -- Any messages or commands containing these keywords will not be logged.
    --===========================================================================================--

    sensitive_content = {
        "login",
        "admin_add",
        "change_password",
        "admin_change_pw",
        "admin_add_manually",
    },

    -- If true, console commands containing these keywords will be logged!
    ignore_console = false,


    --=========================--
    -- SCRIPT LOAD & UNLOAD --
    --=========================--
    ["ScriptLoad"] = {
        enabled = true,
        Log = function(f)
            if (f.reloaded) then
                f:Write("[SCRIPT RE-LOAD] Server Logger was re-loaded")
            else
                f:Write("[SCRIPT LOAD] Server Logger was loaded")
            end
        end
    },
    ["ScriptUnload"] = {
        enabled = true,
        Log = function(f)
            f:Write("[SCRIPT UNLOAD] Advanced Server Logger was unloaded")
        end
    },


    --=========================--
    -- GAME START & END --
    --=========================--
    ["GameStart"] = {
        enabled = true,
        Log = function(f)
            f:Write("[GAME START] A new game has started on [" .. f.map .. " - " .. f.gt .. " (" .. f.mode .. ")]")
        end
    },
    ["GameEnd"] = {
        enabled = true,
        Log = function(f)
            f:Write("[GAME END] The game has ended! Showing post game carnage report...")
        end
    },


    --=========================--
    -- PLAYER JOIN & QUIT --
    --=========================--
    ["PlayerJoin"] = {
        enabled = true,
        Log = function(f, p)

            local a = p.name -- player name [string]
            local b = p.id -- player id [string]
            local c = p.ip -- player ip [string]
            local d = p.hash -- player hash [string]
            local e = f.pn -- player count [int]

            f:Write("[JOIN] Name: " .. a .. " [ID: " .. b .. " | IP: " .. c .. " | CD-Key Hash: " .. d .. " | Total Players: " .. e .. "/16]")
        end
    },
    ["PlayerQuit"] = {
        enabled = true,
        Log = function(f, p)

            local a = p.name -- player name [string]
            local b = p.id -- player id [string]
            local c = p.ip -- player ip [string]
            local d = p.hash -- player hash [string]
            local e = f.pn -- player count [int]

            f:Write("[QUIT] Name: " .. a .. " [ID: " .. b .. " | IP: " .. c .. " | CD-Key Hash: " .. d .. " | Total Players: " .. e .. "/16]")
        end
    },


    --=========================--
    -- CHAT MESSAGE & COMMAND --
    --=========================--
    ["MessageCreate"] = {
        enabled = true,
        Log = function(f)

            local str
            local a = f.chat[1] -- message [string]
            local b = f.chat[2] -- message type [int]
            local c = f.chat[3] -- player name [string]
            local d = f.chat[4] -- player id [int]
            f.chat = {}

            if (b == 0) then
                str = "[GLOBAL] " .. c .. " ID: [" .. d .. "]: " .. a
            elseif (b == 1) then
                str = "[TEAM] " .. c .. " ID: [" .. d .. "]: " .. a
            elseif (b == 2) then
                str = "[VEHICLE] " .. c .. " ID: [" .. d .. "]: " .. a
            else
                str = "[UNKNOWN] " .. c .. " ID: [" .. d .. "]: " .. a
            end
            f:Write(str)
        end
    },
    ["Command"] = {
        enabled = true,
        Log = function(fun)

            local a = fun.cmd[1] -- admin (true or false) [string NOT BOOLEAN]
            local b = fun.cmd[2] -- admin level [int]
            local c = fun.cmd[3] -- executor name [string]
            local d = fun.cmd[4] -- executor id [int]
            local e = fun.cmd[5] -- execute ip (or 127.0.0.1) [string]
            local f = fun.cmd[6] -- command [string]
            local g = fun.cmd[7] -- command environment
            fun.cmd = {}

            local cmd
            if (g == 0) then
                cmd = "[CONSOLE COMMAND] " .. c .. ": " .. f .. " [Admin = " .. a .. " | Level: " .. b .. " | ID: " .. d .. " | IP: " .. e .. "]"
            elseif (g == 1) then
                cmd = "[RCON COMMAND] " .. c .. ": " .. f .. " [Admin = " .. a .. " | Level: " .. b .. " | ID: " .. d .. " | IP: " .. e .. "]"
            elseif (g == 2) then
                cmd = "[CHAT COMMAND] " .. c .. ": /" .. f .. " [Admin = " .. a .. " | Level: " .. b .. " | ID: " .. d .. " | IP: " .. e .. "]"
            end

            fun:Write(cmd)
        end
    },

    --
    -- CONFIGURATION ENDS --
    --

    Reset = function(l)
        l.pn = 0
        l.cmd = {}
        l.chat = {}
        l.players = {}
    end
}

function OnScriptLoad()

    register_callback(cb["EVENT_JOIN"], "PlayerJoin")
    register_callback(cb["EVENT_LEAVE"], "PlayerQuit")

    register_callback(cb["EVENT_CHAT"], "MessageCreate")
    register_callback(cb["EVENT_COMMAND"], "Command")

    register_callback(cb["EVENT_GAME_START"], "GameStart")
    register_callback(cb["EVENT_GAME_END"], "GameEnd")

    Logger.reloaded = (get_var(0, "$gt") ~= "n/a") or false
    Logger["ScriptLoad"].Log(Logger)

    GameStart()
end

local script_version = 1.0

function OnScriptUnload()
    Logger["ScriptUnload"].Log(Logger)
end

function GameStart()

    local gt = get_var(0, "$gt")
    if (gt ~= "n/a") then

        Logger:Reset(Logger)
        if (not Logger.reloaded) then
            Logger.gt = gt
            Logger.map = get_var(0, "$map")
            Logger.mode = get_var(0, "$mode")
            Logger["GameStart"].Log(Logger)
        end

        for i = 1, 16 do
            if player_present(i) then
                Logger:InitPlayer(i, false)
            end
        end
    end
end

function GameEnd()
    Logger["GameEnd"].Log(Logger)
end

local function BlackListed(P, STR)

    local Args = { }
    for Params in STR:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end

    if (#Args > 0) then
        for i = 1, #Args do
            for _, word in pairs(Logger.sensitive_content) do
                if Args[i]:lower():find(word) then
                    if (P ~= nil and P == 0 and Logger.ignore_console) then
                        return false
                    end
                    return true
                end
            end
        end
    end
    return false
end

local function IsCommand(M)
    return (M:sub(1, 1) == "/" or M:sub(1, 1) == "\\")
end

function MessageCreate(P, M, T)
    if (P == 0 or not BlackListed(_, M) and not IsCommand(M)) then
        Logger.chat = { M, T, Logger.players[P].name, P }
        Logger["MessageCreate"].Log(Logger)
    end
end

local function IsAdmin(P, L)
    return (P == 0 and "true") or (L >= 1 and "true" or "false")
end

function Command(P, C, E, _)

    if (not BlackListed(P, C)) then
        local lvl = tonumber(get_var(P, "$lvl"))
        Logger.cmd = {
            IsAdmin(P, lvl),
            lvl,
            (Logger.players[P] and Logger.players[P].name) or "SERVER CONSOLE",
            P,
            (Logger.players[P] and Logger.players[P].ip) or "localhost",
            C,
            E,
        }
        Logger["Command"].Log(Logger)
    end
end

function PlayerJoin(P)
    Logger:InitPlayer(P, false)
end

function PlayerQuit(P)
    Logger:InitPlayer(P, true)
end

function Logger:InitPlayer(P, Reset, Reload)
    if (not Reset) then
        self.players[P] = {
            id = P,
            ip = get_var(P, "$ip"),
            name = get_var(P, "$name"),
            hash = get_var(P, "$hash")
        }
        self.pn = tonumber(get_var(0, "$pn"))
        if (not Reload) then
            self["PlayerJoin"].Log(self, self.players[P])
        end
        return
    end

    self.pn = tonumber(get_var(0, "$pn")) - 1
    self["PlayerQuit"].Log(self, self.players[P])
    self.players[P] = nil
end

function Logger:Write(STR)
    if (STR) then
        local file = io.open(self.dir, "a+")
        if (file) then
            file:write(STR .. "\n")
            file:close()
        end
    end
end

local function WriteError(str)
    local file = io.open("Server Logger (errors).log", "a+")
    if (file) then
        file:write(str .. "\n")
        file:close()
    end
end

function OnError(Error)

    local log = {
        { os.date("[%H:%M:%S - %d/%m/%Y]"), true, 12 },
        { Error, false, 12 },
        { debug.traceback(), true, 12 },
        { "--------------------------------------------------------", true, 5 },
        { "Please report this error on github:", true, 7 },
        { "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", true, 7 },
        { "Script Version: " .. script_version, true, 7 },
        { "--------------------------------------------------------", true, 5 }
    }

    for _, v in pairs(log) do
        WriteError(v[1])
        if (v[2]) then
            cprint(v[1], v[3])
        end
    end

    WriteError("\n")
end

-- For a future update:
return Logger
--
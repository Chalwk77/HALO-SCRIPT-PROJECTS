--[[
--=====================================================================================================--
Script Name: Advanced Server Logging, for SAPP (PC & CE)

This script will log:
* Join & Quit events
* Game Start Events
* Game End Events
* Script Load & Script Unload Events
* Global Chat
* Team Chat
* Vehicle Chat
* Chat Commands (w/password filtering)
* Rcon/Console Commands (w/password filtering)

> Chat Logs will be simultaneously saved to date.FullLog.txt and date.Chat.txt
> Command Logs will be simultaneously saved to date.FullLog.txt and date.Commands.txt
> This script will also censor passwords in command logs.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration Starts --
local full_log_path = "sapp\\%date%.FullLog.txt"

--[[
    These variables in can be used in on_join/on_quit & on_command/on_chat messages:
        %name%      = player name
        %id%        = player id
        %ip%        = player ip
        %hash%      = player hash
        %level%     = player admin level
        %state%     = admin status (true/false)
        %message%   = (Chat/Command output)
        %total%     = Total number of players currently online.
]]

local on_join = "[JOIN]    Name: %name%    ID: [%id%]    IP: [%ip%]    CD-Key Hash: [%hash%]    Total Players: [%total%/16]"
local on_quit = "[QUIT]    Name: %name%    ID: [%id%]    IP: [%ip%]    CD-Key Hash: [%hash%]    Total Players: [%total%/16]"

local on_load = "[SCRIPT LOAD] Advanced Logger was loaded"
local on_reload = "[SERVER] SAPP Was Reloaded"
local on_unload = "[SCRIPT UNLOAD] Advanced Logger was unloaded"
local on_game_end = "[GAME END] The Game has ended (post game carnage report showing)"
local on_game_start = "[GAME START] A new game has started on [%map% | mode: %mode%]"

local chat_logs_path = "sapp\\%date%.Chat.txt"
local on_chat = {
    [0] = "[GLOBAL] %name% ID: [%id%] IP: [%ip%]: %message%",
    [1] = "[TEAM] %name% ID: [%id%] IP: [%ip%]: %message%",
    [2] = "[VEHICLE] %name% ID: [%id%] IP: [%ip%]: %message%",
    [3] = "[UNKNOWN] %name% ID: [%id%] IP: [%ip%]: %message%",
}

local command_logs_path = "sapp\\%date%.Commands.txt"
local on_command = {
    [0] = "[CONSOLE COMMAND] [Admin = %state% | Level: %level%] %name% ID: [%id%] IP: [%ip%]: %message%",
    [1] = "[RCON COMMAND] [Admin = %state% | Level: %level%] %name% ID: [%id%] IP: [%ip%]: %message%",
    [2] = "[CHAT COMMAND] [Admin = %state% | Level: %level%] %name% ID: [%id%] IP: [%ip%]: /%message%",
    [3] = "[CENSORED] %message%" -- message will be replaced with "censor_character"
}

-- Any command containing these words will be censored:
local censored_content = {
    censor_character = "*****",
    "login",
    "admin_add",
    "change_password",
    "admin_change_pw",
    "admin_add_manually",
}

-- If true, player info will be printed to the server console when someone joins/quits:
local print_player_info = true
local player_info = {
    "Player: %name%",
    "CD Hash: %hash%",
    "IP Address: %ip%",
    "Index ID: %id%",
    "Privilege Level: %level%",
}
-- Configuration Ends --

local players = {}

local gsub, gmatch, sub = string.gsub, string.gmatch, string.sub
local lower, find = string.lower, string.find

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    register_callback(cb["EVENT_CHAT"], "OnServerChat")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")

    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")

    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")

    if (get_var(0, "$gt") ~= "n/a") then
        players = { }
        SaveClientData(0)
        for i = 1, 16 do
            if player_present(i) then
                SaveClientData(i)
            end
        end
        Write(on_reload, full_log_path)
    else
        Write(on_load, full_log_path)
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        local map = get_var(0, "$map")
        local mode = get_var(0, "$mode")
        local log = gsub(gsub(on_game_start, "%%map%%", map), "%%mode%%", mode)
        Write(log, full_log_path)
        Write(log, chat_logs_path)
        Write(log, command_logs_path)
        SaveClientData(0)
    end
end

function OnGameEnd()
    local map = get_var(0, "$map")
    local mode = get_var(0, "$mode")
    local log = gsub(gsub(on_game_end, "%%map%%", map), "%%mode%%", mode)
    Write(log, full_log_path)
    Write(log, chat_logs_path)
    Write(log, command_logs_path)
end

function OnServerChat(PlayerIndex, Message, type)
    if (type ~= 6) then
        local msg = TextSplit(Message)
        if (#msg == 0 or msg == nil) then
            return
        elseif not isCommand(msg) then

            local t = players[PlayerIndex]
            if (t) then

                local log = on_chat[type]
                if (log) then

                    t["%%message%%"], t["%%total%%"] = Message, get_var(0, "$pn")
                    for k, v in pairs(t) do
                        log = gsub(log, k, v)
                    end

                    cprint(log, 11)
                    Write(log, full_log_path)
                    Write(log, chat_logs_path)
                    t["%%message%%"] = ""
                end
            end
        end
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local cmd = TextSplit(Command)
    if (#cmd == 0 or cmd == nil) then
        return
    else

        local t = players[PlayerIndex]
        if (t) then

            t["%%message%%"], t["%%total%%"] = Command, get_var(0, "$pn")

            local content = CensoredContent(Command)
            if (content ~= nil) then
                t["%%message%%"] = content
                Environment = 3
            end

            local log = on_command[Environment]
            if (log) then
                for k, v in pairs(t) do
                    log = gsub(log, k, v)
                end
                cprint(log, 11)
                Write(log, full_log_path)
                Write(log, command_logs_path)
            end

            t["%%message%%"] = ""
        end
    end
end

function OnPlayerPrejoin(PlayerIndex)
    SaveClientData(PlayerIndex)
    if (print_player_info) then
        cprint("________________________________________________________________________________", 10)
        cprint("Player attempting to connect to the server...", 13)
        local t = players[PlayerIndex]
        if (t) then
            t = t.all_info
            for i = 1, #t do
                cprint(t[i], 10)
            end
        end
    end
end

local function QuitJoin(PlayerIndex, Type)
    local log = ""
    local t = players[PlayerIndex]
    if (t) then
        local time_stamp = os.date("%A %d %B %Y - %X")
        if (Type == 1) then
            log = on_join
            if (print_player_info) then
                cprint("Join Time: " .. time_stamp, 10)
                cprint("Status: " .. t["%%name%%"] .. " connected successfully.", 13)
                cprint("________________________________________________________________________________", 10)
            end
        elseif (Type == 2) then
            if (print_player_info) then
                cprint("________________________________________________________________________________", 12)
                t["%%total%%"] = get_var(0, "$pn") - 1
                local tab = t.all_info
                for i = 1, #tab do
                    cprint(tab[i], 12)
                end
                cprint("Quit Time: " .. time_stamp, 12)
                cprint("________________________________________________________________________________", 12)
            end
            log = on_quit
            players[PlayerIndex] = nil
        end
        for k, v in pairs(t) do
            log = gsub(log, k, v)
        end
        Write(log, full_log_path)
    end
end

function OnPlayerConnect(PlayerIndex)
    QuitJoin(PlayerIndex, 1)
end

function OnPlayerDisconnect(PlayerIndex)
    QuitJoin(PlayerIndex, 2)
end

function SaveClientData(PlayerIndex)

    local p = tonumber(PlayerIndex)
    local level = tonumber(get_var(p, "$lvl"))
    local state = tostring((level >= 1))

    local name = get_var(p, "$name")
    local ip = get_var(p, "$ip")
    local hash = get_var(p, "$hash")

    if (p == 0) then
        name = "SERVER"
        ip = "N/A"
        hash = "N/A"
        state = "true"
    end

    players[p] = {
        ["%%id%%"] = p,
        ["%%name%%"] = name,
        ["%%ip%%"] = ip,
        ["%%hash%%"] = hash,
        ["%%level%%"] = level,
        ["%%message%%"] = "",
        ["%%state%%"] = state,
        ["%%total%%"] = get_var(0, "$pn")
    }

    if (print_player_info) then
        local t = {}
        for i = 1, #player_info do
            t[#t + 1] = player_info[i]
        end
        for k, v in pairs(players[p]) do
            for i = 1, #t do
                t[i] = gsub(t[i], k, v)
            end
        end
        players[p].all_info = t
    end
end

function Write(Content, Path)

    local Date = os.date("[%d/%m/%Y]"):gsub('[:/]', '-')
    local path = gsub(Path, "%%date%%", Date)
    local file = io.open(path, "a+")

    if (file) then
        local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
        file:write(timestamp .. " " .. Content .. "\n")
    end
    file:close()
end

function TextSplit(Message)
    local args, index = {}, 1
    for Params in gmatch(Message, "([^%s]+)") do
        args[index] = Params
        index = index + 1
    end
    return args
end

function isCommand(table)
    if (sub(table[1], 1, 1) == "/" or sub(table[1], 1, 1) == "\\") then
        return true
    end
end

function CensoredContent(Message)
    local words = censored_content
    for i = 1, #words do
        local word = words[i]
        if find(Message:lower(), word) then
            return words.censor_character
        end
    end
    return nil
end

function OnScriptUnload()
    Write(on_unload, full_log_path)
end

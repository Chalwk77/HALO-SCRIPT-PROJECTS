--[[
--=====================================================================================================--
Script Name: Server Logger, for SAPP (PC & CE)

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

Copyright (c) 2019-2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration Starts --
local log_directory = "serverlog.txt"

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

local on_join = "[JOIN] Name: [%name%] ID: [%id%] IP: [%ip%] CD-Key Hash: [%hash%] Total Players: [%total%/16]"
local on_quit = "[QUIT] Name: [%name%] ID: [%id%] IP: [%ip%] CD-Key Hash: [%hash%] Total Players: [%total%/16]"

local on_load = "[SCRIPT LOAD] Server Logger was loaded"
local on_reload = "[SERVER] SAPP Was Reloaded"
local on_unload = "[SCRIPT UNLOAD] Server Logger was unloaded"
local on_game_end = "[GAME END] The Game has ended (post game carnage report showing)"
local on_game_start = "[GAME START] A new game has started on [%map% | mode: %mode%]"

local on_chat = {
    [0] = "[GLOBAL] %name% ID: [%id%] IP: [%ip%]: %message%",
    [1] = "[TEAM] %name% ID: [%id%] IP: [%ip%]: %message%",
    [2] = "[VEHICLE] %name% ID: [%id%] IP: [%ip%]: %message%",
    [3] = "[UNKNOWN] %name% ID: [%id%] IP: [%ip%]: %message%",
}

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
    "sv_password",
    "change_password",
    "admin_change_pw",
    "admin_add_manually",
}
-- Configuration Ends --

local players = {}
local find = string.find
local gsub, gmatch, sub = string.gsub, string.gmatch, string.sub

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
        for i = 1, 16 do
            if player_present(i) then
                SaveClientData(i)
            end
        end
        Write(on_reload)
    else
        Write(on_load)
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        local map, mode = get_var(0, "$map"), get_var(0, "$mode")
        local log = gsub(gsub(on_game_start, "%%map%%", map), "%%mode%%", mode)
        Write(log)
    end
end

function OnGameEnd()
    local map, mode = get_var(0, "$map"), get_var(0, "$mode")
    local log = gsub(gsub(on_game_end, "%%map%%", map), "%%mode%%", mode)
    Write(log)
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
                    Write(log)
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
                Write(log)
            end

            t["%%message%%"] = ""
        end
    end
end

function OnPlayerPrejoin(PlayerIndex)
    SaveClientData(PlayerIndex)
end

local function JoinQuit(PlayerIndex, Type)
    local log = ""
    local t = players[PlayerIndex]
    if (t) then
        if (Type == 1) then
            log = on_join
        elseif (Type == 2) then
            log = on_quit
            players[PlayerIndex] = nil
        end
        for k, v in pairs(t) do
            log = gsub(log, k, v)
        end
        Write(log)
    end
end

function OnPlayerConnect(PlayerIndex)
    JoinQuit(PlayerIndex, 1)
end

function OnPlayerDisconnect(PlayerIndex)
    JoinQuit(PlayerIndex, 2)
end

function SaveClientData(Ply)

    local level = tonumber(get_var(Ply, "$lvl"))
    local state = tostring((level >= 1))

    local name = get_var(Ply, "$name")
    local ip = get_var(Ply, "$ip")
    local hash = get_var(Ply, "$hash")

    players[Ply] = {
        ["%%id%%"] = Ply,
        ["%%ip%%"] = ip,
        ["%%name%%"] = name,
        ["%%hash%%"] = hash,
        ["%%message%%"] = "",
        ["%%level%%"] = level,
        ["%%state%%"] = state,
        ["%%total%%"] = get_var(0, "$pn")
    }
end

function Write(Content)
    local file = io.open(log_directory, "a+")
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

function isCommand(t)
    if (sub(t[1], 1, 1) == "/" or sub(t[1], 1, 1) == "\\") then
        return true
    end
    return false
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
    Write(on_unload)
end

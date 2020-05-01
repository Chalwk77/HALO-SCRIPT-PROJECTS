--[[
--=====================================================================================================--
Script Name: Play Time, for SAPP (PC & CE)
Description: Display your play time.

Command Syntax: /playtime [number: 1-16] | */all | me

-----[!] IMPORTANT [!] -----
1): This mod requires that the following plugins are installed to your server:
    http://regex.info/blog/lua/json

2): Place "json.lua" in your servers root directory.


Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

-- Config Starts --
local path = "sapp\\playtime.json"
local playtime_command = "playtime"
local permission_level = -1

local messages = {
    [1] = "Your playtime is Years: %Y%, Weeks: %W%, Days: %D%, Hours: %H%, Minutes: %M%, Seconds: %S%",
    [2] = "%name%'s playtime is Years: %Y%, Weeks: %W%, Days: %D%, Hours: %H%, Minutes: %M%, Seconds: %S%",
    [3] = "Invalid Player ID. Usage: /%cmd% [number: 1-16] | */all | me",
    [4] = "You do not have permission to execute this command!",
    [5] = "The server is excluded from this check!",
}
-- Config Ends --

api_version = "1.12.0.0"

local players = { }
local json = (loadfile "json.lua")()
local delta_time, floor = (1 / 30), math.floor
local gsub, gmatch, lower, upper = string.gsub, string.gmatch, string.lower, string.upper

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb['EVENT_GAME_END'], 'OnGameEnd')
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb['EVENT_GAME_START'], 'OnGameStart')
    register_callback(cb['EVENT_LEAVE'], 'OnPlayerDisconnect')
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")

    if (get_var(0, "$gt") ~= "n/a") then
        CheckFile()
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            if (players[i] ~= nil and players[i].time ~= nil) then
                players[i].time = players[i].time + delta_time
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        CheckFile()
    end
end

function OnGameEnd()
    if (get_var(0, "$gt") ~= "n/a") then
        for i = 1, 16 do
            if player_present(i) then
                UpdateTime(i)
            end
        end
    end
end

function OnServerCommand(Executor, Command, _, _)
    local Args = CmdSplit(Command)
    if (Args == nil) then
        return
    else
        Args[1] = (lower(Args[1]) or upper(Args[1]))
        if (Args[1] == playtime_command) then

            if HasAccess(Executor) then
                local pl = GetPlayers(Executor, Args)
                if (#pl > 0) then
                    for i = 1, #pl do

                        local msg
                        local TargetID = tonumber(pl[i])
                        local isSelf = (Executor == TargetID)

                        if (isSelf and TargetID ~= 0) or (not isSelf) then

                            local time = players[TargetID].time
                            local years, weeks, days, hours, minutes, seconds = secondsToTime(time)

                            if (isSelf) then
                                msg = gsub(gsub(gsub(gsub(gsub(gsub(messages[1],
                                        "%%Y%%", years),
                                        "%%W%%", weeks),
                                        "%%D%%", days),
                                        "%%H%%", hours),
                                        "%%M%%", minutes),
                                        "%%S%%", seconds)
                            else
                                local name = get_var(TargetID, "$name")
                                msg = gsub(gsub(gsub(gsub(gsub(gsub(gsub(messages[2],
                                        "%%Y%%", years),
                                        "%%W%%", weeks),
                                        "%%D%%", days),
                                        "%%H%%", hours),
                                        "%%M%%", minutes),
                                        "%%S%%", seconds),
                                        "%%name%%", name)
                            end
                            Respond(Executor, msg)
                        else
                            Respond(Executor, messages[5])
                        end

                    end
                end
            end
            return false
        end
    end
end

function Respond(Executor, Message)
    if (Executor > 0) then
        rprint(Executor, Message)
    else
        cprint(Message,10)
    end
end

function GetPlayers(Executor, Args)
    local pl = { }

    if (Args[2] == nil or Args[2] == "me") then
        table.insert(pl, Executor)
    elseif (Args[2]:match("%d+") and player_present(Args[2])) then
        table.insert(pl, Args[2])
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
    else
        Respond(Executor, gsub(messages[3], "%%cmd%%", Args[1]))
    end
    return pl
end

function CmdSplit(Cmd)
    local t, i = {}, 1
    for Args in gmatch(Cmd, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

function HasAccess(Executor)
    local lvl = tonumber(get_var(Executor, "$lvl"))
    if (lvl >= permission_level) then
        return true
    else
        Respond(Executor, messages[4])
    end
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnPlayerDisconnect(PlayerIndex)
    UpdateTime(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function GetPlayTime(IP)
    local file = io.open(path, "r")
    if (file ~= nil) then
        local data = file:read("*all")
        local stats = json:decode(data)
        io.close(file)
        if (stats[IP]) then
            return stats[IP]
        end
    end
    return nil
end

function InitPlayer(PlayerIndex, Reset)
    if (Reset) then
        players[PlayerIndex] = { }
    else

        local ip = get_var(PlayerIndex, "$ip"):match('(%d+.%d+.%d+.%d+)')
        local playtime, record = GetPlayTime(ip)

        if (playtime) then
            playtime, record = playtime.time, true
        else
            playtime, record = 0, false
        end

        local name = get_var(PlayerIndex, "$name")
        players[PlayerIndex] = { ip = ip, time = playtime, name = name }

        if (not record) then
            local file, stats = io.open(path, "r")
            if (file ~= nil) then
                local data = file:read("*all")
                stats = json:decode(data)
                stats[ip] = players[PlayerIndex]
                io.close(file)
            end

            local file = assert(io.open(path, "w"))
            if (file) then
                file:write(json:encode_pretty(stats))
                io.close(file)
            end
        end
    end
end

function UpdateTime(PlayerIndex)

    local file, stats = io.open(path, "r")
    local temp = players[PlayerIndex]

    if (file ~= nil) then
        local data = file:read("*all")
        stats = json:decode(data)
        stats[temp.ip].time = temp.time
        io.close(file)
    end

    if (stats) then
        local file = assert(io.open(path, "w"))
        if (file) then
            file:write(json:encode_pretty(stats))
            io.close(file)
        end
    end
end

function secondsToTime(seconds)
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

    return years, weeks, days, hours, minutes, seconds
end

function CheckFile()

    players = { }

    local file = io.open(path, "a")
    if (file ~= nil) then
        io.close(file)
    end

    local file, stats = io.open(path, "r")
    if (file ~= nil) then
        local data = file:read("*all")
        stats = json:decode(data)
        io.close(file)
    end

    if (not stats) then
        local file = assert(io.open(path, "w"))
        if (file) then
            file:write("{\n}")
            io.close(file)
        end
    end
end

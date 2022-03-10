--[[
--=====================================================================================================--
Script Name: Notify Me, for SAPP (PC & CE)
Description: This script will beautify the server terminal during certain events:

            - script_load
            - script_unload
            - event_chat
            - event_command
            - event_game_start
            - event_game_end
            - event_prejoin
            - event_join
            - event_leave
            - event_die
            - event_spawn
            - event_login
            - event_map_reset
            - event_team_switch

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--


api_version = '1.12.0.0'

local players = {}
local date = os.date
local char = string.char
local concat = table.concat

function OnScriptLoad()

    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_CHAT'], 'OnChat')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_LOGIN'], 'OnLogin')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_MAP_RESET'], "OnReset")
    register_callback(cb['EVENT_PREJOIN'], 'OnPreJoin')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')

    OnStart()
end

local function Notify(msg)
    for i = 1, #msg do
        cprint(msg[i][1], msg[i][2])
    end
end

function OnStart()
    if (get_var(0, "$gt") ~= "n/a") then

        players = { }

        local map = get_var(0, "$map")
        local mode = get_var(0, "$mode")

        Notify({ { "A new game has started on " .. map .. " - " .. mode, 5 } })
        timer(50, "Logo")

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnEnd()
    Notify({ { "Game Ended - Showing Post Game Carnage report", 5 } })
end

function OnPreJoin(Ply)

    players[Ply] = {
        id = Ply,
        ip = get_var(Ply, '$ip'),
        name = get_var(Ply, '$name'),
        team = get_var(Ply, '$team'),
        hash = get_var(Ply, '$hash'),
        level = tonumber(get_var(Ply, '$lvl'))
    }

    local player = players[Ply]
    Notify({
        { "________________________________________________________________________________", 10 },
        { "Player attempting to connect to the server...", 13 },
        { "Player: " .. player.name, 10 },
        { "CD Hash: " .. player.hash, 10 },
        { "IP Address: " .. player.ip, 10 },
        { "Index ID: " .. player.id, 10 },
        { "Privilege Level: " .. player.level, 10 }
    })
end

function OnJoin(Ply)
    Notify({
        { "Join Time: " .. os.date("%A %d %B %Y - %X"), 10 },
        { "Status: " .. players[Ply].name .. " connected successfully.", 13 },
        { "________________________________________________________________________________", 10 }
    })
end

function OnSpawn(Ply)
    Notify({ { players[Ply].name .. " spawned", 14 } })
end

function OnQuit(Ply)
    local player = players[Ply]
    Notify({
        { "________________________________________________________________________________", 12 },
        { "Player: " .. player.name, 12 },
        { "CD Hash: " .. player.hash, 12 },
        { "IP Address: " .. player.ip, 12 },
        { "Index ID: " .. player.id, 12 },
        { "Privilege Level: " .. get_var(Ply, '$lvl'), 12 },
        { "Ping: " .. get_var(Ply, '$ping'), 12 },
        { "________________________________________________________________________________", 12 }
    })
    players[Ply] = nil
end

function OnSwitch(Ply)
    local t = players[Ply]
    t.team = get_var(Ply, '$team')
    Notify({ { t.name .. " switched teams. New team: [" .. t.team .. "]", 13 } })
end

function OnWarp(Ply)
    Notify({ { players[Ply].name .. " is warping", 13 } })
end

function OnReset()
    Notify({ { "The map was reset!", 3 } })
end

function OnLogin(Ply)
    if (players[Ply]) then
        Notify({ { players[Ply].name .. " logged in", 7 } })
    end
end

local on_command = {
    [1] = { "[RCON CMD] $name ID: [$id]: $cmd", 2 },
    [2] = { "[CHAT CMD] $name ID: [$id]: /$cmd", 2 }
}

local function FormatStr(Str, Ply, CMD, MSG)
    local player = players[Ply]
    local words = {
        ['$cmd'] = CMD,
        ['$msg'] = MSG,
        ['$id'] = player.id,
        ['$ip'] = player.ip,
        ['$name'] = player.name
    }
    for k, v in pairs(words) do
        Str = Str:gsub(k, v)
    end
    return Str
end

function OnCommand(Ply, CMD, ENV)
    if (Ply > 0) then
        local msg = on_command[ENV]
        local str = FormatStr(msg[1], Ply, CMD)
        Notify({ { str, msg[2] } })
    end
end

local on_chat = {
    [0] = { "[GLOBAL] $name ID: [$id]: $msg", 3 },
    [1] = { "[TEAM] $name ID: [$id]: $msg", 3 },
    [2] = { "[VEHICLE] $name ID: [$id]: $msg", 3 },
    [3] = { "[UNKNOWN] $name ID: [$id]: $msg", 3 },
}

local function IsCommand(msg)
    return (msg:sub(1, 1) == "/" or msg:sub(1, 1) == "\\")
end

function OnChat(Ply, Msg, Type)
    if (Ply > 0 and not IsCommand(Msg)) then
        local msg = on_chat[Type]
        local str = FormatStr(msg[1], Ply, nil, Msg)
        Notify({ { str, msg[2] } })
    end
end

function OnDeath(Victim, Killer)
    local killer = tonumber(Killer)
    local victim = tonumber(Victim)

    local k = players[killer]
    local v = players[victim]
    if (v) then
        if (killer) then
            if (killer == -1) then
                Notify({ { v.name .. " was killed by the server", 8 } })
            elseif (killer == 0) then
                Notify({ { v.name .. " was squashed by a vehicle", 8 } })
            elseif (killer > 0) then
                if (v.id ~= killer) then
                    if (v.team == k.team) then
                        Notify({ { v.name .. " was betrayed by " .. k.name, 8 } })
                    else
                        Notify({ { v.name .. " was killed by " .. k.name, 8 } })
                    end
                else
                    Notify({ { v.name .. " committed suicide", 8 } })
                end
            end
        else
            Notify({ { v.name .. " died", 8 } })
        end
    end
end

local function ReadWideString(Address, Length)
    local count = 0
    local byte_table = {}
    for i = 1, Length do
        if (read_byte(Address + count) ~= 0) then
            byte_table[i] = char(read_byte(Address + count))
        end
        count = count + 2
    end
    return concat(byte_table)
end

function Logo()

    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local server_name = ReadWideString(network_struct + 0x8, 0x42)

    Notify({
        { "================================================================================", 10 },
        { date("%A, %d %B %Y - %X"), 6 },
        { "", 0 },
        { "     '||'  '||'     |     '||'       ..|''||           ..|'''.| '||''''|  ", 12 },
        { "      ||    ||     |||     ||       .|'    ||        .|'     '   ||  .    ", 12 },
        { "      ||''''||    |  ||    ||       ||      ||       ||          ||''|    ", 12 },
        { "      ||    ||   .''''|.   ||       '|.     ||       '|.      .  ||       ", 12 },
        { "     .||.  .||. .|.  .||. .||.....|  ''|...|'         ''|....'  .||.....| ", 12 },
        { "               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-", 7 },
        { "                             " .. server_name, 10 },
        { "               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-", 7 },
        { "", 0 },
        { "================================================================================", 10 }
    })
end

function OnScriptUnload()
    -- N/A
end
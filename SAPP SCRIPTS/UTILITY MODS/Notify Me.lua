--[[
--=====================================================================================================--
Script Name: Notify Me (UTILITY), for SAPP (PC & CE)
Description: A simple addon that notifies (via server terminal) of certain events.

             ====== Event Triggers ======
             - OnScriptLoad
             - OnScriptUnload
             - OnPlayerChat
             - OnServerCommand
             - OnGameStart
             - OnGameEnd
             - Pre Join
             - Join
             - Disconnect
             - Death
             - Spawn

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- do not touch --
local sub, gsub = string.sub, string.gsub
local players = {}
--------------------------------------------

-- Config Starts ------------------------------------------------------------------------

local on_chat = { -- Used for OnPlayerChat event.
    -- {message, console color}
    [0] = { "[GLOBAL] %name% ID: [%id%] IP: [%ip%]: %message%", 3 },
    [1] = { "[TEAM] %name% ID: [%id%] IP: [%ip%]: %message%", 3 },
    [2] = { "[VEHICLE] %name% ID: [%id%] IP: [%ip%]: %message%", 3 },
    [3] = { "[UNKNOWN] %name% ID: [%id%] IP: [%ip%]: %message%", 3 },
}

local on_command = { -- Used for OnServerCommand event.
    [1] = { "[RCON CMD] %name% ID: [%id%] IP: [%ip%]: %cmd%", 2 },
    [2] = { "[CHAT CMD] %name% ID: [%id%] IP: [%ip%]: /%cmd%", 2 },
}

local events = {
    ["OnServerCommand"] = {
        enabled = true, -- Set to "false" to disable this notification
        func = function(p)

            local environment = p.command[2]
            local cmd = on_command[environment]
            local color = cmd[2] or 2

            cmd = gsub(gsub(gsub(gsub(cmd[1],
                    "%%name%%", p.name),
                    "%%id%%", p.id),
                    "%%ip%%", p.ip),
                    "%%cmd%%", p.command[1])
            cprint(cmd, color)
            p.command = ""
        end
    },
    ["OnPlayerChat"] = {
        enabled = true, -- Set to "false" to disable this notification
        func = function(p)
            local type = p.message[2]
            local msg = on_chat[type]
            local color = on_chat[type][2] or 2
            msg = gsub(gsub(gsub(gsub(msg[1],
                    "%%name%%", p.name),
                    "%%id%%", p.id),
                    "%%ip%%", p.ip),
                    "%%message%%", p.message[1])
            cprint(msg, color)
            p.message = ""
        end
    },
    ["OnScriptLoad"] = {
        enabled = true, -- Set to "false" to disable this notification
        func = function(_)
            local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
            local servername = read_widestring(network_struct + 0x8, 0x42)
            local timestamp = os.date("%A, %d %B %Y - %X")
            cprint("================================================================================", 10)
            cprint(timestamp, 6)
            cprint("")
            cprint("     '||'  '||'     |     '||'       ..|''||           ..|'''.| '||''''|  ", 12)
            cprint("      ||    ||     |||     ||       .|'    ||        .|'     '   ||  .    ", 12)
            cprint("      ||''''||    |  ||    ||       ||      ||       ||          ||''|    ", 12)
            cprint("      ||    ||   .''''|.   ||       '|.     ||       '|.      .  ||       ", 12)
            cprint("     .||.  .||. .|.  .||. .||.....|  ''|...|'         ''|....'  .||.....| ", 12)
            cprint("               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-", 7)
            cprint("                             " .. servername, 10)
            cprint("               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-", 7)
            cprint("")
            cprint("================================================================================", 10)
        end
    },
    ["OnGameStart"] = {
        enabled = true, -- Set to "false" to disable this notification
        func = function(_)
            local mode, map = get_var(0, "$mode"), get_var(0, "$map")
            cprint("A new game has started on " .. map .. " - " .. mode, 5)
        end
    },
    ["OnGameEnd"] = {
        enabled = true, -- Set to "false" to disable this notification
        func = function(_)
            cprint("Game Ended - Showing Post Game Carnage report", 5)
        end
    },
    ["OnPreJoin"] = {
        enabled = true, -- Set to "false" to disable this notification
        func = function(params)
            cprint("________________________________________________________________________________", 10)
            cprint(params.name .. " is attempting to connect to the server...", 13)
            cprint("Player: " .. params.name, 10)
            cprint("CD Hash: " .. params.hash, 10)
            cprint("IP Address: " .. params.ip, 10)
            cprint("Index ID: " .. params.id, 10)
            cprint("Privilege Level: " .. params.level, 10)
        end
    },
    ["OnPlayerConnect"] = {
        enabled = true, -- Set to "false" to disable this notification
        func = function(params)
            cprint("Join Time: " .. os.date("%A %d %B %Y - %X"), 10)
            cprint("Status: " .. params.name .. " connected successfully.", 13)
            cprint("________________________________________________________________________________", 10)
        end
    },
    ["OnPlayerDisconnect"] = {
        enabled = true, -- Set to "false" to disable this notification
        func = function(params)
            cprint("________________________________________________________________________________", 12)
            cprint("Player: " .. params.name, 12)
            cprint("CD Hash: " .. params.hash, 12)
            cprint("IP Address: " .. params.ip, 12)
            cprint("Index ID: " .. params.id, 12)
            cprint("Privilege Level: " .. params.level, 12)
            cprint("Ping: " .. params.ping, 12)
            cprint("________________________________________________________________________________", 12)
        end
    },
    ["OnPlayerSpawn"] = {
        enabled = true, -- Set to "false" to disable this notification
        func = function(params)
            cprint(params.name .. " spawned", 14)
        end
    },
    ["OnPlayerDeath"] = {
        enabled = true, -- Set to "false" to disable this notification
        func = function(params)
            if (params.killer) then
                if (params.killer == -1) then
                    cprint(params.name .. " was killed by the server", 8)

                elseif (params.killer == 0) then
                    cprint(params.name .. " squashed by a vehicle", 8)

                elseif (params.killer > 0) then
                    if (params.id ~= params.killer) then
                        local kname = get_var(params.killer, "$name")
                        local Vteam, Kteam = get_var(params.id, "$team"), get_var(params.killer, "$team")
                        if (Vteam == Kteam) then
                            cprint(params.name .. " was betrayed by " .. kname, 8)
                        else
                            cprint(params.name .. " was killed by " .. kname, 8)
                        end
                    else
                        cprint(params.name .. " committed suicide", 8)
                    end
                end
            else
                cprint(params.name .. " died", 8)
            end
        end
    }
}

-- Config Ends ------------------------------------------------------------------------

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
    register_callback(cb["EVENT_CHAT"], "OnPlayerChat")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    timer(50, "Notify", "", "OnScriptLoad")
    if (get_var(0, "$gt") ~= "n/a") then
        players = { }
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        players = { }
        Notify(_, "OnGameStart")
    end
end

function OnGameEnd()
    if (get_var(0, "$gt") ~= "n/a") then
        Notify(_, "OnGameEnd")
    end
end

function OnServerCommand(Ply, CMD, Environment, _)
    if (Ply > 0) then
        players[Ply].command = { CMD, Environment }
        Notify(Ply, "OnServerCommand")
    end
end

local function isChatCommand(MSG)
    if (sub(MSG, 1, 1) == "/" or sub(MSG, 1, 1) == "\\") then
        return true
    end
    return false
end

function OnPlayerChat(Ply, Msg, Type)
    if (Ply and Type ~= 6) then
        if (not isChatCommand(Msg)) then
            players[Ply].message = { Msg, Type }
            Notify(Ply, "OnPlayerChat")
        end
    end
end

function OnPreJoin(Ply)
    InitPlayer(Ply, false)
    Notify(Ply, "OnPreJoin")
end

function OnPlayerConnect(Ply)
    Notify(Ply, "OnPlayerConnect")
end

function OnPlayerDisconnect(Ply)
    players[Ply].ping = tonumber(get_var(Ply, "$ping"))
    Notify(Ply, "OnPlayerDisconnect")
    InitPlayer(Ply, true)
end

function OnPlayerSpawn(Ply)
    players[Ply].killer = nil
    Notify(Ply, "OnPlayerSpawn")
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    players[VictimIndex].killer = tonumber(KillerIndex)
    Notify(VictimIndex, "OnPlayerDeath")
end

function Notify(Ply, Callback)
    for Event, v in pairs(events) do
        if (Event == Callback) and (v.enabled) then
            v.func(players[Ply])
        end
    end
end

function InitPlayer(Ply, Reset)
    if (Reset) then
        players[Ply] = { }
    else
        players[Ply] = {
            ping = 0,
            killer = nil,
            ip = get_var(Ply, "$ip"),
            name = get_var(Ply, "$name"),
            hash = get_var(Ply, "$hash"),
            id = tonumber(get_var(Ply, "$n")),
            level = tonumber(get_var(Ply, "$lvl"))
        }
    end
end

function OnTick()
    for i = 1, 16 do
        if (players[i] ~= nil and not player_present(i)) then
            players[i] = { }
        end
    end
end

function OnScriptUnload()

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
    return table.concat(byte_table)
end
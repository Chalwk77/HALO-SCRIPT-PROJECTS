--[[
--=====================================================================================================--
Script Name: Notify Me (UTILITY), for SAPP (PC & CE)
Description: A simple addon that notifies (via server terminal) of certain events.

             ====== Event Triggers ======
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

-- Config Starts ------------------------------------------------------------------------

local events = {
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

local players = {}

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
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
    end
end

function OnPreJoin(PlayerIndex)
    InitPlayer(PlayerIndex, false)
    Notify(PlayerIndex, "OnPreJoin")
end

function OnPlayerConnect(PlayerIndex)
    Notify(PlayerIndex, "OnPlayerConnect")
end

function OnPlayerDisconnect(PlayerIndex)
    players[PlayerIndex].ping = tonumber(get_var(PlayerIndex, "$ping"))
    Notify(PlayerIndex, "OnPlayerDisconnect")
    InitPlayer(PlayerIndex, true)
end

function OnPlayerSpawn(PlayerIndex)
    players[PlayerIndex].killer = nil
    Notify(PlayerIndex, "OnPlayerSpawn")
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    players[VictimIndex].killer = tonumber(KillerIndex)
    Notify(VictimIndex, "OnPlayerDeath")
end

function Notify(PlayerIndex, Callback)
    for Event, v in pairs(events) do
        if (Event == Callback) and (v.enabled) then
            v.func(players[PlayerIndex])
        end
    end
end

function InitPlayer(PlayerIndex, Reset)
    if (Reset) then
        players[PlayerIndex] = { }
    else
        players[PlayerIndex] = {
            ping = 0,
            killer = nil,
            ip = get_var(PlayerIndex, "$ip"),
            name = get_var(PlayerIndex, "$name"),
            hash = get_var(PlayerIndex, "$hash"),
            id = tonumber(get_var(PlayerIndex, "$n")),
            level = tonumber(get_var(PlayerIndex, "$lvl"))
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

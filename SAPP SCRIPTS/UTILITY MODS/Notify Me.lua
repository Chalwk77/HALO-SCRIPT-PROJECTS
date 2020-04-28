--[[
--=====================================================================================================--
Script Name: Notify Me (UTILITY), for SAPP (PC & CE)
Description: A simple addon that notifies (via server terminal) of certain events.

             -- Event Triggers:
             - Pre Join Event
             - Successful Join Event
             - Disconnect Event
             - Death Event (server, unknown, vehicle, PvP, Team Kill etc)
             - Spawn Event

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Config Starts ------------------------------------------------------------------------

local actions = {
    ["OnPreJoin"] = {
        func = function(params)
            cprint("________________________________________________________________________________", 2 + 8)
            cprint(params.name .. " is attempting to connect to the server...", 5 + 8)
            cprint("Player: " .. params.name, 2 + 8)
            cprint("CD Hash: " .. params.hash, 2 + 8)
            cprint("IP Address: " .. params.ip, 2 + 8)
            cprint("Index ID: " .. params.id, 2 + 8)
            cprint("Privilege Level: " .. params.level, 2 + 8)
        end
    },
    ["OnPlayerConnect"] = {
        func = function(params)
            cprint("Join Time: " .. os.date("%A %d %B %Y - %X"), 2 + 8)
            cprint("Status: " .. params.name .. " connected successfully.", 5 + 8)
            cprint("________________________________________________________________________________", 2 + 8)
        end
    },
    ["OnPlayerDisconnect"] = {
        func = function(params)
            cprint("________________________________________________________________________________", 4 + 8)
            cprint("Player: " .. params.name, 4 + 8)
            cprint("CD Hash: " .. params.hash, 4 + 8)
            cprint("IP Address: " .. params.ip, 4 + 8)
            cprint("Index ID: " .. params.id, 4 + 8)
            cprint("Privilege Level: " .. params.level, 4 + 8)
            cprint("________________________________________________________________________________", 4 + 8)
        end
    },
    ["OnPlayerSpawn"] = {
        func = function(params)
            cprint(params.name .. " spawned", 6 + 8)
        end
    },
    ["OnPlayerDeath"] = {
        func = function(params)

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

            elseif (params.killer == nil) then
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
    players = { }
end

function OnPreJoin(PlayerIndex)
    InitPlayer(PlayerIndex, false)
    DoAction(PlayerIndex, "OnPreJoin")
end

function OnPlayerConnect(PlayerIndex)
    DoAction(PlayerIndex, "OnPlayerConnect")
end

function OnPlayerDisconnect(PlayerIndex)
    DoAction(PlayerIndex, "OnPlayerDisconnect")
    InitPlayer(PlayerIndex, true)
end

function OnPlayerSpawn(PlayerIndex)
    DoAction(PlayerIndex, "OnPlayerSpawn")
    players[PlayerIndex].killer = nil
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    players[VictimIndex].killer = tonumber(KillerIndex)
    DoAction(VictimIndex, "OnPlayerDeath")
end

function DoAction(PlayerIndex, Event)
    for Action, v in pairs(actions) do
        if (Action == Event) then
            v.func(players[PlayerIndex])
        end
    end
end

function InitPlayer(PlayerIndex, Reset)
    if (Reset) then
        players[PlayerIndex] = { }
    else
        players[PlayerIndex] = {
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

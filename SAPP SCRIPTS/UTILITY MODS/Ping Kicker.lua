--[[
--=====================================================================================================--
Script Name: Ping Kicker, for SAPP (PC & CE)

Description:
An advanced mod that kicks players for high Ping.
Players will be warned 5 times before they are kicked.
Ping Limits are set dynamically (see config).

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

-- Config [STARTS] ----------------------------------------------

local maxWarnings = 5 -- Players will be kicked after this many warnings. 
local checkInterval = 5 -- (seconds) Every five seconds.
local ignoreAdmins = true -- Set to false to kick admins with high pings
local adminLevel = 1 -- Ignore admins at or above this level

-- Dynamic ping limit based on player count:
local limits = {

    -- Min Players, Max Players, Ping Limit:
    --

    { 1, 4, 750 }, -- Mod will start ping kicking if there are 1 to 4 players (if 750+ ping)

    { 5, 8, 450 }, -- Mod will start ping kicking if there are 5 to 8 players (if 450+ ping)

    { 9, 12, 375 }, -- Mod will start ping kicking if there are 9 to 12 players (if 375+ ping)

    { 13, 16, 200 }     -- Mod will start ping kicking if there are 13 to 16 players (if 200+ ping)
}

local messages = {

    warn = { -- To Target Player
        environment = "rcon", -- Valid response environments are: "rcon" or "chat"
        "--- [ HIGH PING WARNING ] ---",
        "Ping is too high! Limit: %limit% (ms) Your Ping: %ping% (ms)",
        "Please try to lower it if possible.",
        "Warnings Left: %warnings_left%/%total_warnings%",
    },

    kick = {
        environment = "chat", -- Valid response environments are: "rcon" or "chat"

        [1] = { -- Message sent to everyone (excluding Target Player):
            "--- PING KICK ---",
            "%name% was kicked for high ping. Limit: %limit% (ms) Their Ping: %ping% (ms)",
        },

        [2] = {-- Message sent to Target Player:
            "--- PING KICK ---",
            "You were kicked for high ping. Limit: %limit% (ms) Your Ping: %ping% (ms)"
        }
    }
}

-- One function temporarily removes the server prefix while
-- it relays specific messages then restores it.
-- The prefix will be restored to this:
local server_prefix = "**SAPP**"

-- Config [ENDS] ----------------------------------------------

local players = { }
local gameOver
local gsub, format = string.gsub, string.format
local delta_time = 1 / 30

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    if (get_var(0, "$gt") ~= "n/a") then
        gameOver, players = false, { }
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

function OnGameStart()
    gameOver, players = false, { }
end

function OnGameEnd()
    gameOver = true
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnPlayerDisconnect(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function OnTick()
    if (not gameOver) then
        for player, v in pairs(players) do
            if player_present(player) and (not Ignore(player)) then

                if (v.timer) then
                    v.timer = v.timer + delta_time

                    if (v.timer >= checkInterval) then
                        v.timer = 0

                        local limit = GetPingLimit()
                        local ping = GetPing(player)

                        if (ping >= limit) then

                            local params = { }
                            params.ping = ping
                            params.limit = limit
                            v.strikes = v.strikes + 1

                            if (v.strikes < maxWarnings) then
                                params.msg = messages.warn
                                Respond(player, params)
                            else

                                for i = 1, 16 do
                                    if player_present(i) and (i ~= player) then
                                        params.msg = messages.kick[1]
                                        Respond(i, params)
                                    end
                                end

                                params.msg = messages.kick[2]
                                Respond(player, params)
                                SilentKick(player)

                                cprint(v.name .. " was kicked for High Ping (" .. ping .. " ms)", 4 + 8)
                                execute_command("log_note " .. v.name .. " was kicked for High Ping (" .. ping .. " ms)")
                            end
                        end
                    end
                end
            end
        end
    end
end

function SilentKick(PlayerIndex)
    for _ = 1, 9999 do
        rprint(PlayerIndex, " ")
    end
end

function Respond(PlayerIndex, params)

    local msg = params.msg
    local Environment = msg.environment

    local sappResponseFunc = say
    if (Environment == "rcon") then
        cls(PlayerIndex, 25)
        sappResponseFunc = rprint
    end

    execute_command("msg_prefix \"\"")
    for j = 1, #msg do

        local FormatStr = gsub(gsub(gsub(gsub(gsub(msg[j],
                "%%ping%%", params.ping),
                "%%limit%%", params.limit),
                "%%total_warnings%%", maxWarnings),
                "%%name%%", players[PlayerIndex].name),
                "%%warnings_left%%", maxWarnings - players[PlayerIndex].strikes)

        sappResponseFunc(PlayerIndex, FormatStr)
    end
    execute_command("msg_prefix \" " .. server_prefix .. "\"")
end

function GetPingLimit()
    for Set = 1, #limits do
        local min = limits[Set][1]
        local max = limits[Set][2]
        local limit = limits[Set][3]
        local player_count = tonumber(get_var(0, "$pn"))
        if (player_count >= min and player_count <= max) then
            return limit
        end
    end
    return 1000
end

function InitPlayer(PlayerIndex, Reset)
    if (Reset) then
        players[PlayerIndex] = { }
    else
        players[PlayerIndex] = {
            strikes = 0, timer = 0,
            name = get_var(PlayerIndex, "$name")
        }
    end
end

function cls(PlayerIndex, Count)
    Count = Count or 25
    for _ = 1, Count do
        rprint(PlayerIndex, " ")
    end
end

function GetPing(PlayerIndex)
    return tonumber(get_var(PlayerIndex, "$ping"))
end

function Ignore(PlayerIndex)
    local level = tonumber(get_var(PlayerIndex, "$lvl"))
    if (ignoreAdmins and level >= adminLevel) then
        return true
    end
    return false
end

function OnError(Message)
    print(debug.traceback())
end

function OnScriptUnload()

end

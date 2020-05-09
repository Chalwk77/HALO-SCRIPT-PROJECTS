--[[
--=====================================================================================================--
Script Name: Ping Kicker, for SAPP (PC & CE)
Description: A simple addon Auto Kicks players for high Ping.
             Players will be warned 5 times before they are kicked.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

-- Config [STARTS] ----------------------------------------------

local limit = 300 -- Strike a player after going over this ping.
local maxStrikes = 5
local checkInterval = 5 -- (ms) Every five seconds.
local warning = "[PING KICK WARNING] Your ping is too high (%ping%) - Strikes Left: %remaining_strikes%/%total_strikes%"

-- Config [ENDS] ----------------------------------------------

local players = { }
local gsub, gameOver = string.gsub
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
            if (player) then
                if player_present(player) then

                    v.timer = v.timer + delta_time

                    if (v.timer >= checkInterval) then
                        v.timer = 0

                        local ping = GetPing(player)
                        if (ping >= limit) then

                            v.strikes = v.strikes + 1

                            -- Warn Player:
                            if (v.strikes < maxStrikes) then

                                local StrikesLeft = (maxStrikes - v.strikes)
                                local msg = gsub(gsub(gsub(warning, "%%remaining_strikes%%", StrikesLeft), "%%total_strikes%%", maxStrikes), "%%ping%%", ping)
                                say(player, msg)
                            else

                                -- Execute SAPP kick Command on this player:
                                execute_command("k " .. player .. " \"High Ping (" .. ping .. ")\"")

                                -- Print kick reason to server terminal:
                                cprint(v.name .. " was kicked for High Ping (" .. ping .. ")\"", 4 + 8)
                            end
                        end
                    end
                end
            end
        end
    end
end

function InitPlayer(PlayerIndex, Reset)
    if (Reset) then
        players[PlayerIndex] = { }
    else
        players[PlayerIndex] = {
            name = get_var(PlayerIndex, "$name"),
            strikes = 0, timer = 0
        }
    end
end

function GetPing(PlayerIndex)
    return tonumber(get_var(PlayerIndex, "$ping"))
end

function OnScriptUnload()

end

return PingKicker

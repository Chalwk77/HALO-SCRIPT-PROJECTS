--[[
--=====================================================================================================--
Script Name: Suicide Punisher, for SAPP (PC & CE)
Description: If a player excessively commits suicide "suicide_threshold" times within "punish_period" seconds, 
             this script will kick or ban them (see config).

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

-- Config starts
local suicide_threshold = 5
local punish_period = 30 -- In Seconds
local action = "kick" -- Valid actions are 'kick' & 'ban'
local bantime = 10 -- In Minutes (set to zero to ban permanently)
local reason = "Excessive Suicide"
-- Config ends

local suicide = {}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_GAME_END'], 'OnGameEnd')
    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
    register_callback(cb['EVENT_JOIN'], 'OnPlayerConnect')
    register_callback(cb['EVENT_LEAVE'], 'OnPlayerDisconnect')

    if (get_var(0, '$gt') ~= "n/a") then
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnPlayerDisconnect(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            InitPlayer(i, true)
        end
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)

    local killer = tonumber(KillerIndex)
    local victim = tonumber(PlayerIndex)

    if (killer > 0 and killer == victim) then
        suicide[victim].deaths = suicide[victim].deaths + 1
        if (suicide[victim].deaths >= suicide_threshold) then
            takeAction(victim)
        end
    end
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            if (suicide[i]) then
                if (suicide[i].deaths > 0 and suicide[i].deaths < suicide_threshold) then
                    suicide[i].timer = suicide[i].timer + 0.03333333333333333
                    local delta_time = punish_period - math.floor(suicide[i].timer % 60)
                    if (delta_time <= 0) then
                        suicide[i].deaths = 0
                        suicide[i].timer = 0
                    end
                end
            end
        end
    end
end

function InitPlayer(player, reset)
    if (not reset) then
        suicide[player] = {}
        suicide[player].deaths = 0
        suicide[player].timer = 0
    else
        suicide[player] = nil
    end
end

function takeAction(Player)
    local name = get_var(Player, "$name")
    if (action == "kick") then
        execute_command("k" .. " " .. Player .. " \"" .. reason .. "\"")
        cprint(name .. " was kicked for " .. reason, 4 + 8)
    elseif (action == "ban") then
        execute_command("b" .. " " .. Player .. " " .. bantime .. " \"" .. reason .. "\"")
        cprint(name .. " was banned for " .. bantime .. " minutes for " .. reason, 4 + 8)
    end
end

function OnScriptUnload()
    --
end

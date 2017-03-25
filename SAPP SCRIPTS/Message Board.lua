--[[
------------------------------------
Script Name: Message Board (utility), for SAPP | (PC\CE)
    Description: Announce welcome messages to the newley joined player.
                 Welcome messages are displayed on the player's console.
                 You can specify how long the messages are displayed on screen.
    
This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS
    
Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"

-- How long should the message be displayed on screen for? (in seconds) --
Welcome_Msg_Duration = 30

-- SENT TO CONSOLE --
message_board = {
    "Welcome to [my server]",
    "Message Board created by Chalwk (Jericho Crosby)",
    "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS"
    }

welcome_timer = { }
new_timer = { }

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    for i = 1, 16 do
        if player_present(i) then
            local player_id = get_var(i, "$n")
            players[player_id].new_timer = 0
        end
    end
end
    
function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            if (welcome_timer[i] == true) then
                local player_id = get_var(i, "$n")
                players[player_id].new_timer = players[player_id].new_timer + 0.030
                cls(i)
                for k, v in pairs(message_board) do rprint(i, "" .. v) end
                if players[player_id].new_timer >= math.floor(Welcome_Msg_Duration) then
                    welcome_timer[i] = false
                    players[player_id].new_timer = 0
                end
            end
        end
    end
end

function OnNewGame()
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                local player_id = get_var(i, "$n")
                players[player_id].new_timer = 0
            end
        end
    end
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                local player_id = get_var(i, "$n")
                welcome_timer[PlayerIndex] = false
                players[player_id].new_timer = 0
            end
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    welcome_timer[PlayerIndex] = true
    local player_id = get_var(PlayerIndex, "$n")
    players_alive[player_id] = { }
    players_alive[player_id].new_timer = 0
end

function OnPlayerLeave(PlayerIndex)
    welcome_timer[PlayerIndex] = false
    local player_id = get_var(PlayerIndex, "$n")
    players_alive[player_id].new_timer = 0
end

function cls(PlayerIndex)
    for clear_cls = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

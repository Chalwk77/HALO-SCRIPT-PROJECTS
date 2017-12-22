--[[
--=====================================================================================================--
Script Name: Juggernaut, for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description: Custom Game

    To Do List:
                    - When the current juggernaut leaves the server, select someone else to be the juggernaut.
                    - When a second player joins the server, the player to get "First Blood" becomes the Juggernaut.
                    - If only two players online, and no one is the Juggernaut yet, remove everybody's nav markers


Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

api_version = "1.11.0.0"
players = { }
players_available = { }
current_players = 0

-- configuration starts here --
player_count_threashold = 3
JuggernautAssignMessage = "$NAME is now the Juggernaut!"
-- configuration ends here --

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    for i = 1, 16 do
        if player_present(i) then
            players[get_var(i, "$n")].current_juggernaut = nil
        end
    end
    current_players = 0
end

function OnScriptUnload()
    gamestarted = false
end

function OnPlayerJoin(PlayerIndex)
    current_players = current_players + 1
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
end

function OnPlayerLeave(PlayerIndex)
    current_players = current_players - 1
end

function OnNewGame()
    gamestarted = true
    for i = 1, 16 do
        if player_present(i) then
            current_players = current_players + 1
            players[get_var(i, "$n")].current_juggernaut = nil
        end
    end
    -- If there are 3 or more players, select a random Juggernaut
    if current_players >= player_count_threashold then
        timer(1000 * 5, "SelectNewJuggernaut")
    end
end

function OnGameEnd()
    gamestarted = false
    current_players = 0
end

function SelectNewJuggernaut()
    if (gamestarted == true) then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(players_available, i)
                if #players_available > 0 then
                    local number = math.random(1, #players_available)
                    players[get_var(number, "$n")].current_juggernaut =(i)
                    SetNavMarker(i)
                    -- Clear the Table
                    players_available = { }
                end
            end
        end
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    -- Neither Killer or Victim are the current Juggernaut >> Make Killer the new Juggernaut - (first person to kill becomes the Juggernaut)
    if (current_players == 2) then
        if killer ~= players[get_var(killer, "$n")].current_juggernaut and(victim ~= players[get_var(PlayerIndex, "$n")].current_juggernaut) then
            players[get_var(killer, "$n")].current_juggernaut = killer
            SetNavMarker(KillerIndex)
            execute_command("msg_prefix \"\"")
            say_all(string.gsub(JuggernautAssignMessage, "$NAME", get_var(killer, "$name")))
            execute_command("msg_prefix \"** SERVER ** \"")
        end
    end
    -- Killer annihilates the current Juggernaut > Make them the new Juggernaut (only if there is 3 or more players online)
    if (current_players > 2) then
        if killer ~= players[get_var(killer, "$n")].current_juggernaut and(victim == players[get_var(PlayerIndex, "$n")].current_juggernaut) then
            players[get_var(killer, "$n")].current_juggernaut = killer
            SetNavMarker(KillerIndex)
            execute_command("msg_prefix \"\"")
            say_all(string.gsub(JuggernautAssignMessage, "$NAME", get_var(killer, "$name")))
            execute_command("msg_prefix \"** SERVER ** \"")
        end
    end
end

function SetNavMarker(Juggernaut)
    for i = 1, 16 do
        if player_present(i) then
            local m_player = get_player(i)
            local player = to_real_index(i)
            if m_player ~= 0 then
                if Juggernaut ~= nil then
                    write_word(m_player + 0x88, to_real_index(Juggernaut))
                else
                    write_word(m_player + 0x88, player)
                end
            end
        end
    end
end








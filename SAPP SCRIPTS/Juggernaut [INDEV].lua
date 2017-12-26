--[[
--=====================================================================================================--
Script Name: Juggernaut, for SAPP (PC & CE)
Version: beta v1.0
Implementing API version: 1.11.0.0

-- G A M E   I N F O R M A T I O N --
--><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><--
Compatible Game Modes: Slayer (Free for All)
Juggernaut will only run on default maps (for now).

The following game type rules must be set.
KILL IN ORDER: YES
OBJECTIVES INDICATOR: NAV POINTS

Game Play:
When the game begins a random player is selected to become the Juggernaut.
Juggernaut's are very powerful, wield 3 weapons, and have regenerating health and extra speed.
Your objective as the Juggernaut is stay alive for as long as possible and wreak havoc upon your enemies.

Everybody else's objective is to kill the Juggernaut.

When the game starts, if there are 3 (or more) players online, a random player will be selected as the juggernaut (player is selected 5 seconds after the game starts)
If there are only 2 players when the game starts, no one will be selected. Instead, the player to get "First Blood" will become the Juggernaut.

Scoring:
For every minute that you're alive as the Juggernaut you will receive 1 score point.
Killing the Juggernaut rewards you 5 points.
As the Juggernaut you will be rewarded 2 points for every kill.
The first player to reach 50 kills as Juggernaut wins.

Game mechanics
Custom Scoring System (editable)
Target Indicators
Regenerating Health (editable)
Speed Boost (editable)
Editable custom Weapon Layout
--><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><--

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

api_version = "1.11.0.0"
-- tables --
welcome_timer = { }
join_timer = { }
players = { }
weapons = { }
weapon = { }
frags = { }
plasmas = { }
score_timer = { }
players_alive = { }
weapons[00000] = "nil\\nil\\nil"
-- booleans --
MapIsListed = nil
bool = nil
tick_bool = nil
-- counts --
current_players = 0

-- ============= CONFIGURATION STARTS HERE =============--
-- Custom Server Prefix
SERVER_PREFIX = "JUGGERNAUT"

-- Points received for killing the juggernaut
bonus = 5
-- points received for every kill as juggernaut
points = 2
-- Health: (0 to 99999) (Normal = 1)
juggernaut_health = 2
-- Health will regenerate in chunks of 0.005 every 30 ticks until you gain maximum health.
juggernaut_health_increment = 0.0005
-- Shields: (0 to 3) (Normal = 1) (Full overshield = 3)
juggernaut_shields = 3
-- End the game once the Juggernaut has this many kills
killLimit = 50
-- On game Start: How many seconds until someone is chosen to be the Juggernaut
start_delay = 10

juggernaut_running_speed = {
    -- large maps --
    infinity = 1.45,
    icefields = 1.25,
    bloodgulch = 1.35,
    timberland = 1.35,
    sidewinder = 1.30,
    deathisland = 1.45,
    dangercanyon = 1.15,
    gephyrophobia = 1.20,
    -- small maps --
    wizard = 1.10,
    putput = 1.10,
    longest = 1.05,
    ratrace = 1.10,
    carousel = 1.15,
    prisoner = 1.10,
    damnation = 1.10,
    hangemhigh = 1.10,
    beavercreek = 1.10,
    boardingaction = 1.10
}

-- When a new game starts, if there are this many (or more) players online, select a random Juggernaut.
player_count_threashold = 3
-- Message to send all players when a new Juggernaut is assigned.
JuggernautAssignMessage = "$NAME is now the Juggernaut!"
-- When Juggernaut commits suicide, how long (in seconds) until someone is chosen to be Juggernaut.
SuicideSelectDelay = 5
-- Receive 1 score point every X seconds (60 by default)
allocated_time = 60
-- points received every "allocated_time" seconds
alive_points = 1

-- Juggernaut Weapon Layout --
-- Copy & Paste a Weapon Tag (see remarks at bottom of script) between the double quotes to change the weapon
weapons[1] = "weapons\\sniper rifle\\sniper rifle"	        -- Primary      | WEAPON SLOT 1
weapons[2] = "weapons\\pistol\\pistol"						-- Secondary    | WEAPON SLOT 2
weapons[3] = "weapons\\rocket launcher\\rocket launcher"    -- Tertiary     | WEAPON SLOT 3

-- Scoring Message Alignment | Left = l,    Right = r,    Center = c,    Tab: t
Alignment = "l"


-- Message Board Settings --
-- How long should the message be displayed on screen for? (in seconds) --
Message_Duration = 15
-- Left = l,    Right = r,    Center = c,    Tab: t
Message_Alignment = "l"

-- Use $SERVER_NAME variable to output the server name.
-- Use $PLAYER_NAME variable to output the joining player's name.

-- messages --
message_board = {
    "Welcome to $SERVER_NAME (beta v1.0)",
    "This custom game is still in development and may contain bugs.",
    "If you discover any, please report them on the following issue tracker:",
    "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues/25"
    }

gamesettings = {
    -- Values: true|false (yes, no)
    -- Assign extra frags|plasmas to Juggernaut?
    ["AssignFragGrenades"] = true,
    ["AssignPlasmaGrenades"] = true,
    -- Give extra health & Overshield to Juggernaut?
    ["GiveExtraHealth"] = true,
    ["GiveOvershield"] = true,
    -- When the Juggernaut commits suicide, a timer is initiated and someone is randomly selected (after X seconds) to become the new Juggernaut. 
    -- Should the Juggernaut who just committed suicide have a chance at being reselected when they respawn? 
    ["JuggernautReselection"] = false,
    -- If this is true, the script will award X points every X seconds to the Juggernaut
    ["AliveTimer"] = true,
    -- Should the Juggernaut's weapons be deleted when they die?
    ["DeleteWeapons"] = true,
    ["UseWelcomeMessages"] = true
}

function GrenadeTable()
    --  frag grenade table --
    frags = {
        beavercreek = 4,
        bloodgulch = 4,
        boardingaction = 4,
        carousel = 4,
        dangercanyon = 4,
        deathisland = 4,
        gephyrophobia = 4,
        icefields = 4,
        infinity = 4,
        sidewinder = 4,
        timberland = 4,
        hangemhigh = 4,
        ratrace = 4,
        damnation = 4,
        putput = 4,
        prisoner = 4,
        wizard = 4-- do not add a comma on the last entry
    }
    --  plasma grenades table --
    plasmas = {
        beavercreek = 4,
        bloodgulch = 4,
        boardingaction = 4,
        carousel = 4,
        dangercanyon = 4,
        deathisland = 4,
        gephyrophobia = 4,
        icefields = 4,
        infinity = 4,
        sidewinder = 4,
        timberland = 4,
        hangemhigh = 4,
        ratrace = 4,
        damnation = 4,
        putput = 4,
        prisoner = 4,
        wizard = 4
    }
end
    
function LoadMaps()
    -- mapnames table --
    mapnames = {
        "beavercreek",
        "bloodgulch",
        "boardingaction",
        "carousel",
        "dangercanyon",
        "deathisland",
        "gephyrophobia",
        "icefields",
        "infinity",
        "sidewinder",
        "timberland",
        "hangemhigh",
        "ratrace",
        "damnation",
        "putput",
        "prisoner",
        "wizard"
    }
end
-- ============= CONFIGURATION ENDS HERE =============--

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPrespawn")
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                players[get_var(i, "$n")].current_juggernaut = nil
                players[get_var(i, "$n")].previous_juggernaut = nil
                players[get_var(i, "$n")].kills = 0
                players[get_var(i, "$n")].join_timer = 0
                players_alive[get_var(i, "$n")].time_alive = 0
            end
        end
    end
    if (get_var(0, "$gt") ~= "n/a") then
        mapname = get_var(0, "$map")
        GrenadeTable()
        LoadMaps()
    end
    current_players = 0
    execute_command("scorelimit 250")
    execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
    --- sehe's death message patch ------------------------------
    deathmessages = sig_scan("8B42348A8C28D500000084C9") + 3
    original = read_dword(deathmessages)
    safe_write(true)
    write_dword(deathmessages, 0x03EB01B1)
    safe_write(false)
    -------------------------------------------------------------
end

function OnScriptUnload()
    players = { }
    players = { }
    weapons = { }
    weapon = { }
    frags = { }
    plasmas = { }
    --- sehe's death message patch ------------------------------
    safe_write(true)
    write_dword(deathmessages, original)
    safe_write(false)
    -------------------------------------------------------------
end

function OnNewGame()
    gamestarted = true
    mapname = get_var(0, "$map")
    GrenadeTable()
    LoadMaps()
    if (table.match(mapnames, mapname) == nil) then
        MapIsListed = false
        Error = 'Error: ' .. mapname .. ' is not listed in "mapnames table" - line 110'
        cprint(Error, 4 + 8)
        execute_command("log_note \"" .. Error .. "\"")
    else
        MapIsListed = true
    end
    timer(0, "delayStart")
    execute_command("map_skip 1")
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                players_alive[get_var(i, "$n")].time_alive = 0
                players[get_var(i, "$n")].current_juggernaut = nil
                players[get_var(i, "$n")].previous_juggernaut = nil
                players[get_var(i, "$n")].kills = 0
                players[get_var(i, "$n")].join_timer = 0
            end
        end
    end
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    servername = read_widestring(network_struct + 0x8, 0x42)
end

function delayStart()
    execute_command("msg_prefix \"\"")
    say_all("The Juggernaut will be selected in " .. tonumber(start_delay) .. " seconds")
    execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
    timer(1000 * start_delay, "SelectNewJuggernaut")
end

function OnGameEnd()
    gamestarted = false
    current_players = 0
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                welcome_timer[i] = false
                players_alive[get_var(i, "$n")].time_alive = 0
                players[get_var(i, "$n")].current_juggernaut = nil
                players[get_var(i, "$n")].previous_juggernaut = nil
                players[get_var(i, "$n")].kills = 0
                players[get_var(i, "$n")].join_timer = 0
            end
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    current_players = current_players + 1
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
    players[get_var(PlayerIndex, "$n")].previous_juggernaut = nil
    players[get_var(PlayerIndex, "$n")].kills = 0
    players[get_var(PlayerIndex, "$n")].join_timer = 0
    players_alive[get_var(PlayerIndex, "$n")] = { }
    players_alive[get_var(PlayerIndex, "$n")].time_alive = 0
    -- In the unlikely event that the player is juggernaut upon joining, only display the welcome message if they're not the juggernaut
    if (PlayerIndex ~= players[get_var(PlayerIndex, "$n")].current_juggernaut) then
        welcome_timer[PlayerIndex] = true
    end
end

function OnPlayerLeave(PlayerIndex)
    welcome_timer[PlayerIndex] = false
    current_players = current_players - 1
    players[get_var(PlayerIndex, "$n")].kills = 0
    players[get_var(PlayerIndex, "$n")].join_timer = 0
    if (PlayerIndex == players[get_var(PlayerIndex, "$n")].current_juggernaut) then
        if (current_players == 2) then
            -- Two players remain | Neither player are Juggernaut | First player to kill becomes the juggernaut
        elseif (current_players >= 2) then
            SelectNewJuggernaut()
        end
    end
end

function OnPlayerSpawn(PlayerIndex)
    weapon[PlayerIndex] = 0
    mapname = get_var(0, "$map")
    players_alive[get_var(PlayerIndex, "$n")].time_alive = 0
end

function OnPlayerPrespawn(PlayerIndex)
    if (PlayerIndex == players[get_var(PlayerIndex, "$n")].current_juggernaut) then
        players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
    end
end

function PlayerAlive(PlayerIndex)
    if player_present(PlayerIndex) then
        if (player_alive(PlayerIndex)) then
            return true
        else
            return false
        end
    end
end

function OnTick()
    if (current_players == 2) then
        for i = 1, current_players do
            if player_present(i) then
                if (i ~= players[get_var(i, "$n")].current_juggernaut) then
                    local m_player = get_player(i)
                    local player = to_real_index(i)
                    if m_player ~= 0 then
                        if i ~= nil then
                            if (tick_bool) == nil then
                                -- Nobody is the Juggernaut | Reposition NAV Markers (not sure how to remove them completely)
                                -- to do: Figure out how to remove|hide nav markers
                                write_word(m_player + 0x88, player + 10)
                            end
                        end
                    end
                    -- Someone is now the Juggernaut
                end
            end
        end
    end
    for j = 1, 16 do
        if player_present(j) then
            if player_alive(j) then
                if (j == players[get_var(j, "$n")].current_juggernaut) then
                    if (MapIsListed == false) then
                        return false
                    else
                        local player = get_dynamic_player(j)
                        if (weapon[j] == 0) then
                            execute_command("wdel " .. j)
                            local x, y, z = read_vector3d(player + 0x5C)
                            if (mapname == "bloodgulch") then
                                assign_weapon(spawn_object("weap", weapons[2], x, y, z), j)
                                assign_weapon(spawn_object("weap", weapons[3], x, y, z), j)
                                assign_weapon(spawn_object("weap", weapons[1], x, y, z), j)
                                weapon[j] = 1
                                if (bool == true) then
                                    AssignGrenades(j)
                                    bool = false
                                end
                                if (gamesettings["GiveExtraHealth"] == true) then
                                    write_float(player + 0xE0, math.floor(tonumber(juggernaut_health)))
                                end
                                if (gamesettings["GiveOvershield"] == true) then
                                    write_float(player + 0xE4, math.floor(tonumber(juggernaut_shields)))
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    for k = 1, 16 do
        if player_alive(k) then
            if (k == players[get_var(k, "$n")].current_juggernaut) then
                local player_object = get_dynamic_player(k)
                if (player_object ~= 0) then
                    if (player_alive(k)) then
                        if read_float(player_object + 0xE0) < 1 then
                            write_float(player_object + 0xE0, read_float(player_object + 0xE0) + juggernaut_health_increment)
                        end
                    end
                end
            end
        end
    end
	-- Problem | Hiding and/or camping Exploit ------------------------------------------------------------------------------------------
    if (gamesettings["AliveTimer"] == true) then
        for l = 1, 16 do
            if player_present(l) then
                if (score_timer[l] ~= false and PlayerAlive(l) == true) then
                    if (l == players[get_var(l, "$n")].current_juggernaut) then
                        players_alive[get_var(l, "$n")].time_alive = players_alive[get_var(l, "$n")].time_alive + 0.030
                        if (players_alive[get_var(l, "$n")].time_alive >= math.floor(allocated_time)) then
                            local minutes, seconds = secondsToTime(players_alive[get_var(l, "$n")].time_alive, 2)
                            execute_command("score " .. l .. " +" .. tostring(alive_points))
                            players_alive[get_var(l, "$n")].time_alive = 0
                        end
                    end
                end
            end
        end
	-----------------------------------------------------------------------------------------------------------------------------------
    end
    if (gamesettings["UseWelcomeMessages"] == true) then 
        for m = 1, 16 do
            if player_present(m) then
                if (welcome_timer[m] == true) then
                    if (m ~= players[get_var(m, "$n")].current_juggernaut) then
                        players[get_var(m, "$n")].join_timer = players[get_var(m, "$n")].join_timer + 0.030
                        cls(m)
                        for k, v in pairs(message_board) do
                            for j=1, #message_board do
                                if string.find(message_board[j], "$SERVER_NAME") then
                                    message_board[j] = string.gsub(message_board[j], "$SERVER_NAME", servername)
                                elseif string.find(message_board[j], "$PLAYER_NAME") then
                                    message_board[j] = string.gsub(message_board[j], "$PLAYER_NAME", get_var(m, "$name"))
                                end
                            end
                            rprint(m, "|" .. Message_Alignment .. " " .. v)
                        end
                        if players[get_var(m, "$n")].join_timer >= math.floor(Message_Duration) then
                            welcome_timer[m] = false
                            players[get_var(m, "$n")].join_timer = 0
                        end
                    end
                end
            end
        end
    end
end

function SelectNewJuggernaut(PlayerIndex)
    if (gamestarted == true) then
        for i = 1, 16 do
            if player_present(i) then
                if player_alive(i) then
                    -- (suicide) PLAYER WAS PREVIOUS JUGGERNAUT | NO LONGER JUGGERNAUT | SELECT NEW PLAYER AS JUGGERNAUT
                    if (players[get_var(i, "$n")].previous_juggernaut == false) and (i ~= players[get_var(i, "$n")].current_juggernaut) then
                        if (current_players > 1) then
                            local excludeIndex = get_var(i, "$n")
                            local index = math.random(1, current_players)
                            if (index == tonumber(excludeIndex)) then
                                while (index == tonumber(excludeIndex)) do
                                    local newNumber = math.random(1, current_players)
                                    if newNumber ~= tonumber(excludeIndex) then
                                        -- null current_juggernaut in the event of an error
                                        players[get_var(i, "$n")].current_juggernaut = (newNumber)
                                        execute_command("s " .. i .. " :" .. tonumber(juggernaut_running_speed[mapname]))
                                        SetNavMarker(i)
                                        bool = true
                                        execute_command("msg_prefix \"\"")
                                        say_all(string.gsub(JuggernautAssignMessage, "$NAME", get_var(newNumber, "$name")))
                                        execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
                                        break
                                    end
                                end
                            end
                        else
                            execute_command("msg_prefix \"\"")
                            say_all("There are not enough players to select a new Juggernaut!")
                            execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
                        end
                    else
                        -- NOT PREVIOUS JUGGERNAUT | NOT CURRENT JUGGERNAUT | (make them juggernaut)
                        if (current_players >= 2) then
                            local number = math.random(1, tonumber(current_players))
                            if (number ~= players[get_var(i, "$n")].current_juggernaut) then
                                players[get_var(number, "$n")].current_juggernaut = (number)
                                SetNavMarker(number)
                                bool = true
                                if (i ~= tonumber(number)) then
                                    execute_command("msg_prefix \"\"")
                                    say(i, string.gsub(JuggernautAssignMessage, "$NAME", get_var(number, "$name")))
                                    say(number, "You're now the Juggernaut!")
                                    execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
                                    execute_command("s " .. number .. " :" .. tonumber(juggernaut_running_speed[mapname]))
                                end
                                break
                            end
                        else
                            execute_command("msg_prefix \"\"")
                            say_all("There are not enough players to select a new Juggernaut!")
                            execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
                        end
                    end
                else
                    return nil
                end
            end
        end
    end
end

function AssignGrenades(PlayerIndex)
    if player_alive(PlayerIndex) then
        local player_object = get_dynamic_player(PlayerIndex)
        if (player_object ~= 0) then
            if (gamesettings["AssignFragGrenades"] == true) then
                if (frags[mapname] == nil) then
                    Error = 'Error: ' .. mapname .. ' is not listed in the Frag Grenade Table - Line 67 | Unable to set frags.'
                    cprint(Error, 4 + 8)
                    execute_command("log_note \"" .. Error .. "\"")
                else
                    write_word(player_object + 0x31E, frags[mapname])
                end
            end
            if (gamesettings["AssignPlasmaGrenades"] == true) then
                if (plasmas[mapname] == nil) then
                    Error = 'Error: ' .. mapname .. ' is not listed in the Plasma Grenade Table - Line 87 | Unable to set plasmas.'
                    cprint(Error, 4 + 8)
                    execute_command("log_note \"" .. Error .. "\"")
                else
                    write_word(player_object + 0x31F, plasmas[mapname])
                end
            end
        end
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    execute_command("msg_prefix \"\"")
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    if (killer == players[get_var(killer, "$n")].current_juggernaut) and (tonumber(victim) ~= tonumber(KillerIndex)) and (killer ~= -1) then
        players[get_var(killer, "$n")].kills = players[get_var(killer, "$n")].kills + 1
        rprint(killer, "|" .. Alignment .. "Kills as Juggernaut: " .. players[get_var(killer, "$n")].kills .. "/" ..tostring(killLimit))
    end
    if (PlayerIndex == players[get_var(PlayerIndex, "$n")].current_juggernaut) then
        score_timer[PlayerIndex] = false
        players_alive[get_var(PlayerIndex, "$n")].time_alive = 0
    end
    -- Prevent Juggernaut from dropping weapons and grenades on death --
    if (gamesettings["DeleteWeapons"] == true) then
        if (PlayerIndex == players[get_var(PlayerIndex, "$n")].current_juggernaut) then
            local player_object = get_dynamic_player(PlayerIndex)
            local weaponId = read_dword(player_object + 0x118)
            write_word(player_object + 0x31E, 0)
            write_word(player_object + 0x31F, 0)
            if weaponId ~= 0 then
                for j = 0, 3 do
                    local m_weapon = read_dword(player_object + 0x2F8 + j * 4)
                    destroy_object(m_weapon)
                end
            end
        end
    end
    -- Killer is Juggernaut | Victim is not Juggernaut | Update Score
    if (killer ~= -1) then
        -- Killer was not SERVER.
        if (killer == players[get_var(killer, "$n")].current_juggernaut) and(victim ~= players[get_var(victim, "$n")].current_juggernaut) and(killer ~= -1) then
            execute_command("score " .. KillerIndex .. " +" .. tostring(points))
            rprint(killer, "|" .. Alignment .. "+" .. tostring(points) .. " PTS")
        end
    end
    -- Neither Killer or Victim are Juggernaut | Make Killer Juggernaut | Update Score
    if (current_players == 2) then
        if (killer ~= players[get_var(killer, "$n")].current_juggernaut) and (victim ~= players[get_var(PlayerIndex, "$n")].current_juggernaut) and (tonumber(victim) ~= tonumber(KillerIndex)) then
            players[get_var(killer, "$n")].current_juggernaut = killer
            bool = true
            tick_bool = false
            -- Set NAV Markers
            SetNavMarker(KillerIndex)
            -- Set Player Running Speed
            execute_command("s " .. KillerIndex .. " :" .. tonumber(juggernaut_running_speed[mapname]))
            -- Update Score
            execute_command("score " .. KillerIndex .. " +" .. tostring(points))
            -- Send Messages
            rprint(killer, "|" .. Alignment .. " You received +" .. tostring(points) .. " points")
            for i = 1, current_players do
                if i ~= killer then
                    say(i, string.gsub(JuggernautAssignMessage, "$NAME", get_var(killer, "$name")))
                end
            end
            say(KillerIndex, "You're now the Juggernaut!")
        end
    end
    -- Killer is not Juggernaut | Victim is Juggernaut | Make Killer Juggernaut (only if there is 2 or more players) | Update with bonus Score
    if (current_players >= 2) then
        if (victim == players[get_var(victim, "$n")].current_juggernaut) and (killer ~= players[get_var(killer, "$n")].current_juggernaut) then
            players[get_var(victim, "$n")].current_juggernaut = nil
            players[get_var(killer, "$n")].current_juggernaut = killer
            -- Set NAV Markers
            SetNavMarker(KillerIndex)
            -- Set Player Running Speed
            execute_command("s " .. KillerIndex .. " :" .. tonumber(juggernaut_running_speed[mapname]))
            -- Update their score
            execute_command("score " .. KillerIndex .. " +" .. tostring(bonus))
            -- Send Messages
            rprint(killer, "|" .. Alignment .. " You received +" .. tostring(bonus) .. " points")
            for i = 1, current_players do
                if i ~= killer then
                    say(i, string.gsub(JuggernautAssignMessage, "$NAME", get_var(killer, "$name")))
                end
            end
            say(KillerIndex, "You're now the Juggernaut!")
        end
    end
    -- suicide | victim was juggernaut | SelectNewJuggernaut()
    if (tonumber(victim) == tonumber(KillerIndex)) and (victim == players[get_var(victim, "$n")].current_juggernaut) then
        for i = 1, current_players do
            if i ~= victim then
                say(i, get_var(killer, "$name") .. " committed suicide and is no longer the Juggernaut!")
                say(i, "A new player will be selected to become the Juggernaut in " .. SuicideSelectDelay .. " seconds!")
            end
        end
        say(KillerIndex, "You are no longer the Juggernaut!")
        -- Call SelectNewJuggernaut() | Select someone else as the new Juggernaut
        timer(1000 * SuicideSelectDelay, "SelectNewJuggernaut")
        -- Previous Juggernaut Handler --
        if (gamesettings["JuggernautReselection"] == false) then
            -- Don't allow reselection
            players[get_var(victim, "$n")].previous_juggernaut = false
        else
            -- Allow reselection
            players[get_var(victim, "$n")].previous_juggernaut = true
        end
    end
    -- suicide | victim was not juggernaut
    if (tonumber(PlayerIndex) == tonumber(KillerIndex) and (PlayerIndex ~= players[get_var(PlayerIndex, "$n")].current_juggernaut)) then
        say(PlayerIndex, get_var(PlayerIndex, "$name") .. " committed suicide")
    end
    -- pvp --
    if (killer > 0) and(victim ~= killer) then
        say_all(get_var(PlayerIndex, "$name") .. " was killed by " .. get_var(KillerIndex, "$name"))
    end
    -- Killed by Server, Vehicle, or Glitch|Unknown
    if (killer == 0) or(killer == nil) or(killer == -1) then
        say_all(get_var(PlayerIndex, "$name") .. " died")
    end
    -- END THE GAME --
    if (killer == players[get_var(killer, "$n")].current_juggernaut) then
        local kills = tonumber(players[get_var(killer, "$n")].kills)
        if (kills >= tonumber(killLimit)) then
            execute_command("sv_map_next")
        end
    end
    execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
end

function SetNavMarker(Juggernaut)
    for i = 1, 16 do
        if player_present(i) then
            if player_alive(i) then
                local m_player = get_player(i)
                local player = to_real_index(i)
                if m_player ~= 0 then
                    if (Juggernaut ~= nil) then
                        write_word(m_player + 0x88, to_real_index(Juggernaut))
                    else
                        write_word(m_player + 0x88, player)
                    end
                end
            end
        end
    end
end

-- to do: iterate through players and check if someone is juggernaut

function OnServerCommand(PlayerIndex, Command, Environment)
    local UnknownCMD = nil
    local t = tokenizestring(Command)
    local executor = tonumber(PlayerIndex)
    local arg2 = tonumber(t[2])
    if t[1] ~= nil then
        if t[1] == string.lower("j") then
            if player_alive(executor) then
                if player_present(executor) then
                    if (t[2] == nil) or (t[2] ~= nil and t[2] == "me") then
                        if (executor ~= players[get_var(executor, "$n")].current_juggernaut) then
                            SetNewJuggernaut(executor)
                        elseif (executor == players[get_var(executor, "$n")].current_juggernaut) then
                            rprint(executor, "You're already the Juggernaut!")
                        end
                    elseif (t[2] ~= nil and t[2] ~= "me") then
                        if not string.match(t[2], "%d") then
                            rprint(executor, "|" .. Alignment .. "Arg2 was not a number!")
                        else
                            if player_present(arg2) then
                                if player_alive(arg2) then
                                    if (arg2 ~= players[get_var(arg2, "$n")].current_juggernaut) and (arg2 ~= executor) then
                                        SetNewJuggernaut(arg2)
                                    elseif (arg2 == players[get_var(arg2, "$n")].current_juggernaut) and (arg2 ~= executor) then
                                        rprint(executor, get_var(arg2, "$name") .. " is already the Juggernaut!")
                                    elseif (arg2 ~= players[get_var(arg2, "$n")].current_juggernaut) and (arg2 == executor) then
                                        SetNewJuggernaut(arg2)
                                    elseif (arg2 == players[get_var(arg2, "$n")].current_juggernaut) and (arg2 == executor) then
                                        rprint(executor, "You're already the Juggernaut!")
                                    end
                                else
                                    rprint(executor, "Player is dead.")
                                end
                            else
                                rprint(executor, "Player number #" .. arg2 .. " is not in the server!")
                            end
                        end
                    end
                end
            else
                rprint(executor, "You are dead!")
            end
            UnknownCMD = false
        end
    end
    return UnknownCMD
end

function SetNewJuggernaut(player)
    -- Update and Reflect changes
    players[get_var(player, "$n")].current_juggernaut = (player)
    -- Set NAV Marker
    SetNavMarker(player)
    bool = true
    -- Send Messages
    rprint(player, "You're now the Juggernaut!")
    for i = 1, current_players do
        if i ~= player then
            execute_command("msg_prefix \"\"")
            say(i, string.gsub(JuggernautAssignMessage, "$NAME", get_var(number, "$name")))
            say(player, "You're now the Juggernaut!")
            execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
        end
    end
    -- Set running speed
    execute_command("s " .. player .. " :" .. tonumber(juggernaut_running_speed[mapname]))
end

function cls(PlayerIndex)
    for clear_cls = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

function table.match(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function tokenizestring(inputString, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = { }; i = 1
    for str in string.gmatch(inputString, "([^" .. separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function secondsToTime(seconds, places)
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60
    if places == 2 then
        return minutes, seconds
    end
end

function read_widestring(address, length)
    local count = 0
    local byte_table = {}
    for i = 1,length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return table.concat(byte_table)
end

function OnError(Message)
    print(debug.traceback())
end

--[[
===========================================================================================================================
		S C R I P T   R E M A R K S

[!] The Juggernaut can only carry 3 weapons at a time; the 4th Weapon Slot is reserved for Oddball or Flag.

-------------- Available Weapon Tags --------------

ITEM NAME               WEAPON TAG                                             TYPE
Assault Rifle           "weapons\\assault rifle\\assault rifle"                  weap
Oddball                 "weapons\\ball\\ball"	                                 weap
Flag	                "weapons\\flag\\flag"	                                 weap
Flamethrower	        "weapons\\flamethrower\\flamethrower"	                 weap
Fuel rod gun	        "weapons\\plasma_cannon\\plasma_cannon"                  weap
Needler	                "weapons\\needler\\mp_needler"                           weap
Pistol                  "weapons\\pistol\\pistol"                                weap
Plasma Pistol	        "weapons\\plasma pistol\\plasma pistol"                  weap
Plasma Rifle	        "weapons\\plasma rifle\\plasma rifle"                    weap
Rocket Launcher	        "weapons\\rocket launcher\\rocket launcher"              weap
Shotgun	                "weapons\\shotgun\\shotgun"                              weap
Sniper Rifle	        "weapons\\sniper rifle\\sniper rifle"                    weap
===========================================================================================================================
]]

-- [!] acknowledgements: sehe's death message patch

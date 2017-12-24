--[[
--=====================================================================================================--
Script Name: Juggernaut, for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description:    When the game begins a random player is selected to become the Juggernaut.
                Juggernaut's are very powerful, wield 3 weapons, and have regenerating health and extra speed.
                Your objective is stay alive for as long as possible and wreak havoc upon your enemies while you're the Juggernaut.
                Everybody else's objective is to kill the Juggernaut. 
                
                Scoring:
                For every minute that you're alive as the Juggernaut, you will receive 1 score point.
                Killing the Juggernaut rewards you 5 points.
                As the Juggernaut you will be rewarded 2 points for every kill.
                The first player to reach 50 kills as Juggernaut wins.
                - subject to change in support of a balanced game.
                
                
Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

api_version = "1.11.0.0"
-- tables --
players_available = { }
players = { }
weapons = { }
weapon = { }
frags = { }
plasmas = { }
weapons[00000] = "nil\\nil\\nil"
-- booleans --
MapIsListed = nil
bool = nil
tick_bool = nil
-- counts --
current_players = 0

-- ============= CONFIGURATION STARTS HERE =============--
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
-- determine player speed for current flag holder --
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

-- Juggernaut Weapon Layout --
-- Copy & Paste a Weapon Tag (see remarks at bottom of script) between the double quotes to change the weapon
weapons[1] = "weapons\\sniper rifle\\sniper rifle"	        -- Primary      | WEAPON SLOT 1
weapons[2] = "weapons\\pistol\\pistol"						-- Secondary    | WEAPON SLOT 2
weapons[3] = "weapons\\rocket launcher\\rocket launcher"    -- Tertiary     | WEAPON SLOT 3

-- Scoring Message Alignment | Left = l,    Right = r,    Center = c,    Tab: t
Alignment = "c"

gamesettings = {
    ["AssignFragGrenades"] = true,
    ["AssignPlasmaGrenades"] = true,
    ["GiveExtraHealth"] = true,
    ["GiveOvershield"] = true,
    ["JuggernautReselection"] = true
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
            players[get_var(i, "$n")].current_juggernaut = nil
            players[get_var(i, "$n")].previous_juggernaut = nil
        end
    end
    if (get_var(0, "$gt") ~= "n/a") then
        mapname = get_var(0, "$map")
        GrenadeTable()
        LoadMaps()
    end
    current_players = 0
    deathmessages = sig_scan("8B42348A8C28D500000084C9") + 3
    original = read_dword(deathmessages)
    safe_write(true)
    write_dword(deathmessages, 0x03EB01B1)
    safe_write(false)
end

function OnScriptUnload()
    players_available = { }
    players = { }
    weapons = { }
    weapon = { }
    frags = { }
    plasmas = { }
    safe_write(true)
    write_dword(deathmessages, original)
    safe_write(false)
end

function OnNewGame()
    gamestarted = true
    mapname = get_var(0, "$map")
    GrenadeTable()
    LoadMaps()
    for i = 1, 16 do
        if player_present(i) then
            current_players = current_players + 1
            players[get_var(i, "$n")].current_juggernaut = nil
            players[get_var(i, "$n")].previous_juggernaut = nil
        end
    end
    -- If there are 3 or more players, select a random Juggernaut
    if (current_players >= player_count_threashold) then
        SelectNewJuggernaut()
    end
    if (table.match(mapnames, mapname) == nil) then
        MapIsListed = false
        Error = 'Error: ' .. mapname .. ' is not listed in "mapnames table" - line 110'
        cprint(Error, 4 + 8)
        execute_command("log_note \"" .. Error .. "\"")
    else
        MapIsListed = true
    end
end

function OnGameEnd()
    gamestarted = false
    current_players = 0
end

function OnPlayerJoin(PlayerIndex)
    current_players = current_players + 1
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
    players[get_var(PlayerIndex, "$n")].previous_juggernaut = nil
end

function OnPlayerLeave(PlayerIndex)
    current_players = current_players - 1
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
end

function OnPlayerPrespawn(PlayerIndex)
    if (PlayerIndex == players[get_var(PlayerIndex, "$n")].current_juggernaut) then
        players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
    end
end

function OnTick()
    if (current_players == 2) then
        for i = 1, 2 do
            if player_present(i) then
                if (i ~= players[get_var(i, "$n")].current_juggernaut) then
                    local m_player = get_player(i)
                    local player = to_real_index(i)
                    if m_player ~= 0 then
                        if i ~= nil then
                            if (tick_bool) == nil then
                                -- No body is the Juggernaut | Reposition NAV Markers (not sure how to remove them completely)
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
                            -- WEAPON SLOT 1
                            assign_weapon(spawn_object("weap", weapons[2], x, y, z), j)
                            -- WEAPON SLOT 2
                            assign_weapon(spawn_object("weap", weapons[3], x, y, z), j)
                            -- WEAPON SLOT 3
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
	for k = 1,16 do
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
end

function SelectNewJuggernaut(PlayerIndex)
    if (gamestarted == true) then
        for i = 1, 16 do
            if player_present(i) then
                if player_alive(i) then
                    table.insert(players_available, i)
                    if (#players_available > 0) then
                        -- (suicide) PLAYER WAS PREVIOUS JUGGERNAUT | NO LONGER JUGGERNAUT
                        if (players[get_var(i, "$n")].previous_juggernaut == true) and (i ~= players[get_var(i, "$n")].current_juggernaut) then
                            if (current_players > 1) then
                                local excludeIndex = get_var(i, "$n")
                                local index = math.random(1, current_players)
                                if (index == tonumber(excludeIndex)) then
                                    while (index == tonumber(excludeIndex)) do
                                        local newNumber = math.random(1, current_players)
                                        if newNumber ~= tonumber(excludeIndex) then
                                            players[get_var(i, "$n")].current_juggernaut = nil
                                            players[get_var(i, "$n")].current_juggernaut =(newNumber)
                                            local running_speed = juggernaut_running_speed[mapname]
                                            execute_command("s " .. i .. " :" .. tonumber(running_speed))
                                            SetNavMarker(i)
                                            bool = true
                                            players_available = { }
                                            execute_command("msg_prefix \"\"")
                                            say_all(string.gsub(JuggernautAssignMessage, "$NAME", get_var(newNumber, "$name")))
                                            execute_command("msg_prefix \"** SERVER ** \"")
                                            break
                                        end
                                    end
                                end
                            else
                                execute_command("msg_prefix \"\"")
                                say_all("There are not enough players to select a new Juggernaut!")
                                execute_command("msg_prefix \"** SERVER ** \"")
                            end
                        else
                            -- NOT PREVIOUS JUGGERNAUT | NOT CURRENT JUGGERNAUT
                            if (i ~= players[get_var(i, "$n")].current_juggernaut) then
                                local number = math.random(1, current_players)
                                players[get_var(i, "$n")].current_juggernaut = nil
                                players[get_var(i, "$n")].current_juggernaut =(number)
                                SetNavMarker(i)
                                bool = true
                                players_available = { }
                                execute_command("msg_prefix \"\"")
                                say_all(string.gsub(JuggernautAssignMessage, "$NAME", get_var(number, "$name")))
                                execute_command("msg_prefix \"** SERVER ** \"")
                                break
                            end
                        end
                    else
                        return nil
                    end
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
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    -- Prevent Juggernaut from dropping weapons and grenades --
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
    -- Killer is Juggernaut | Victim is not Juggernaut | Update Score
    if (killer ~= -1) then
        -- Killer was not SERVER.
        if (killer == players[get_var(killer, "$n")].current_juggernaut) and (victim ~= players[get_var(victim, "$n")].current_juggernaut) and(killer ~= -1) then
            setscore(KillerIndex, tonumber(points))
            rprint(killer, "|" .. Alignment .. " You received +" .. tostring(points) .. " points")
        end
    end
    -- Neither Killer or Victim are Juggernaut | Make Killer Juggernaut | Update Score
    if (current_players == 2) then
        if (killer ~= players[get_var(killer, "$n")].current_juggernaut) and(victim ~= players[get_var(PlayerIndex, "$n")].current_juggernaut) then
            players[get_var(killer, "$n")].current_juggernaut = killer
            bool = true
            tick_bool = false
            SetNavMarker(KillerIndex)
            local running_speed = juggernaut_running_speed[mapname]
            execute_command("s " .. i .. " :" .. tonumber(running_speed))
            setscore(KillerIndex, tonumber(points))
            rprint(killer, "|" .. Alignment .. " You received +" .. tostring(points) .. " points")
            execute_command("msg_prefix \"\"")
            say_all(string.gsub(JuggernautAssignMessage, "$NAME", get_var(killer, "$name")))
            execute_command("msg_prefix \"** SERVER ** \"")
        end
    end
    -- Killer is not Juggernaut | Victim is Juggernaut | Make Killer Juggernaut (only if there is 2 or more players) | Update with bonus Score
    if (current_players >= 2) then
        if (victim == players[get_var(victim, "$n")].current_juggernaut) and (killer ~= players[get_var(killer, "$n")].current_juggernaut) then
            players[get_var(killer, "$n")].current_juggernaut = killer
            players[get_var(victim, "$n")].current_juggernaut = nil
            SetNavMarker(KillerIndex)
            local running_speed = juggernaut_running_speed[mapname]
            execute_command("s " .. i .. " :" .. tonumber(running_speed))
            setscore(KillerIndex, tonumber(bonus))
            execute_command("msg_prefix \"\"")
            say_all(string.gsub(JuggernautAssignMessage, "$NAME", get_var(killer, "$name")))
            rprint(killer, "|" .. Alignment .. " You received +" .. tostring(bonus) .. " points")
            execute_command("msg_prefix \"** SERVER ** \"")
        end
    end
    -- suicide | victim was juggernaut | SelectNewJuggernaut()
    if (tonumber(victim) == tonumber(KillerIndex)) and (victim == players[get_var(victim, "$n")].current_juggernaut) then
        execute_command("msg_prefix \"\"")
        say_all(get_var(killer, "$name") .. " committed suicide and is no longer the Juggernaut!")
        say_all("A new player will be selected to become the Juggernaut in " .. SuicideSelectDelay .. " seconds!")
        execute_command("msg_prefix \"** SERVER ** \"")
        timer(1000 * SuicideSelectDelay, "SelectNewJuggernaut")
        -- Previous Juggernaut Handler --
        if (gamesettings["JuggernautReselection"] == true) then
            players[get_var(victim, "$n")].previous_juggernaut = true
        else
            players[get_var(victim, "$n")].previous_juggernaut = false
        end
    end
    -- suicide | victim was no juggernaut
    if (tonumber(PlayerIndex) == tonumber(KillerIndex) and (PlayerIndex ~= players[get_var(PlayerIndex, "$n")].current_juggernaut)) then
        execute_command("msg_prefix \"\"")
        say(PlayerIndex, get_var(PlayerIndex, "$name") .. " committed suicide")
        execute_command("msg_prefix \"** SERVER ** \"")
    end
    -- pvp --
    if (killer > 0) and (victim ~= killer) then
        execute_command("msg_prefix \"\"")
        say_all(get_var(PlayerIndex, "$name") .. " was killed by " .. get_var(KillerIndex, "$name"))
        execute_command("msg_prefix \"** SERVER ** \"")
    end
    -- Killed by Server, Vehicle, or Glitch|Unknown
    if (killer == 0) or (killer == nil) or (killer == -1) then
        execute_command("msg_prefix \"\"")
        say_all(get_var(PlayerIndex, "$name") .. " died")
        execute_command("msg_prefix \"** SERVER ** \"")
    end
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

function OnServerCommand(PlayerIndex, Command, Environment)
    local UnknownCMD = nil
    local t = tokenizestring(Command)
    if t[1] ~= nil then
        if t[1] == string.lower("j") then
            if player_alive(PlayerIndex) then
                SelectNewJuggernaut()
            else
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, "Player is dead.")
                execute_command("msg_prefix \"** SERVER ** \"")
            end
            UnknownCMD = false
        end
    end
    return UnknownCMD
end

function setscore(PlayerIndex, score)
    if tonumber(score) then
        if get_var(0, "$gt") == "slayer" then
            if score >= 0x7FFF then
                execute_command("score " .. PlayerIndex .. " +1")
            elseif score <= -0x7FFF then
                execute_command("score " .. PlayerIndex .. " -1")
            else
                execute_command("score " .. PlayerIndex .. " " .. score)
            end
        end
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



--[[
==========================================================================================================================
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
==========================================================================================================================
]]

-- [!] acknowledgements: sehe's death message patch

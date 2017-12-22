--[[
--=====================================================================================================--
Script Name: Juggernaut, for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description: Custom Game [INDEV]

    To Do List:
                    - health, shields


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
-- counts --
current_players = 0
-- Points received for killing the juggernaut
bonus = 5
-- points received for every kill as juggernaut
points = 1

--============= CONFIGURATION STARTS HERE =============--
-- When a new game starts, if there are this many (or more) players online, select a random Juggernaut.
player_count_threashold = 3
-- Message to send to all players when a new Juggernaut is assigned.
JuggernautAssignMessage = "$NAME is now the Juggernaut!"

weapons[1] = "weapons\\pistol\\pistol"
weapons[2] = "weapons\\sniper rifle\\sniper rifle"
weapons[3] = "weapons\\rocket launcher\\rocket launcher"

-- Message Alignment | Left = l,    Right = r,    Center = c,    Tab: t
Alignment = "l"

gamesettings = {
    ["AssignFragGrenades"] = true,
    ["AssignPlasmaGrenades"] = true
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
        wizard = 4
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
--============= CONFIGURATION ENDS HERE =============--

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    for i = 1, 16 do
        if player_present(i) then
            players[get_var(i, "$n")].current_juggernaut = nil
        end
    end
    if get_var(0, "$gt") ~= "n/a" then
        mapname = get_var(0, "$map")
        GrenadeTable()
        LoadMaps()
    end
    current_players = 0
end

function OnPlayerSpawn(PlayerIndex)
    weapon[PlayerIndex] = 0
    mapname = get_var(0, "$map")
end

function AssignGrenades(PlayerIndex)
    if player_alive(PlayerIndex) then
        local player_object = get_dynamic_player(PlayerIndex)
        if (player_object ~= 0) then
            if (gamesettings["AssignFragGrenades"] == true) then
                if (frags[mapname] == nil) then 
                    Error = 'Error: ' .. mapname .. ' is not listed in the Frag Grenade Table - Line 55 | Unable to set frags.'
                    cprint(Error, 4+8)
                    execute_command("log_note \""..Error.."\"")
                else
                    write_word(player_object + 0x31E, frags[mapname])
                end
            end
            if (gamesettings["AssignPlasmaGrenades"] == true) then
                if (plasmas[mapname] == nil) then 
                    Error = 'Error: ' .. mapname .. ' is not listed in the Plasma Grenade Table - Line 75 | Unable to set plasmas.'
                    cprint(Error, 4+8)
                    execute_command("log_note \""..Error.."\"")
                else
                    write_word(player_object + 0x31F, plasmas[mapname])
                end
            end
        end
    end
end

function OnTick()
    if (current_players == 2) then
        for i = 1, 2 do
            if player_present(i) then
                -- if neither player is the current Juggernaut, remove the nav markers
                if (i ~= players[get_var(i, "$n")].current_juggernaut) then
                    local m_player = get_player(i)
                    local player = to_real_index(i)
                    if m_player ~= 0 then
                        if i ~= nil then
                            -- Remove NAV marker (it points to red base for some reason)
                            write_word(m_player + 0x88, player + 10)
                        end
                    end
                end
            end
        end
    end
    for j = 1, 16 do
        if (player_alive(j)) then
            if (j == players[get_var(j, "$n")].current_juggernaut) then
                if MapIsListed == false then
                    return false
                else
                    local player = get_dynamic_player(j)
                    if (weapon[j] == 0) then
                        execute_command("wdel " .. j)
                        local x, y, z = read_vector3d(player + 0x5C)
                        if (mapname == "bloodgulch") then
                            assign_weapon(spawn_object("weap", weapons[3], x, y, z), j)
                            assign_weapon(spawn_object("weap", weapons[1], x, y, z), j)
                            assign_weapon(spawn_object("weap", weapons[2], x, y, z), j)
                            weapon[j] = 1
                            if (bool == true) then
                                AssignGrenades(j)
                                bool = false
                            end
                        end
                    end
                end
            end
        end
    end
end

function OnScriptUnload()
    -- do nothing
end

function OnPlayerJoin(PlayerIndex)
    current_players = current_players + 1
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
end

function OnPlayerLeave(PlayerIndex)
    current_players = current_players - 1
    if (PlayerIndex == players[get_var(PlayerIndex, "$n")].current_juggernaut) then
        if (current_players == 2) then
            -- say something
        elseif (current_players >= 3) then
            timer(1000 * 3, "SelectNewJuggernaut")
        end
    end
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
        end
    end
    -- If there are 3 or more players, select a random Juggernaut
    if current_players >= player_count_threashold then
        timer(1000 * 3, "SelectNewJuggernaut")
    end
    if (table.match(mapnames, mapname) == nil) then 
        MapIsListed = false
        Error = 'Error: ' .. mapname .. ' is not listed in "mapnames table" - line 98'
        cprint(Error, 4+8)
        execute_command("log_note \""..Error.."\"")
    else
        MapIsListed = true
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
                    players[get_var(i, "$n")].current_juggernaut = (number)
                    SetNavMarker(i)
                    -- Clear the Table
                    players_available = { }
                    bool = true
                end
            end
        end
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    -- Killer is Juggernaut | Victim is not Juggernaut | Update Score
    if (killer == players[get_var(killer, "$n")].current_juggernaut) and (victim ~= players[get_var(victim, "$n")].current_juggernaut) then
        setscore(killer, points)
        rprint(KillerIndex, "|" .. Alignment .. "+3")
    end
    -- Neither Killer or Victim are Juggernaut | Make Killer Juggernaut | Update Score
    if (current_players == 2) then
        if (killer ~= players[get_var(killer, "$n")].current_juggernaut) and (victim ~= players[get_var(PlayerIndex, "$n")].current_juggernaut) then
            players[get_var(killer, "$n")].current_juggernaut = killer
            bool = true
            SetNavMarker(KillerIndex)
            setscore(killer, points)
            rprint(KillerIndex, "|" .. Alignment .. tostring(bonus))
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
            setscore(killer, bonus)
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

function table.match(table, value)
    for k,v in pairs(table) do
        if v == value then
            return k
        end
    end
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








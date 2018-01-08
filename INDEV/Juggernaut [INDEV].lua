--[[
--=====================================================================================================--
Script Name: Juggernaut, for SAPP (PC & CE), beta v1.0
Implementing API version: 1.11.0.0
Compatible Game Modes: Slayer (Free for All)
Juggernaut will only run on default maps (for now).

About:
When the game beings, if there are 3 (or more) players online, a random player will be selected as the Juggernaut.
There is a 5 second selection delay after the game beings. 
However, if there are only 2 players online when the game beings, no one will be selected. 
Instead, the player to get "First Blood" will become the Juggernaut.

Juggernaut's are very powerful, wield 3 weapons, and have regenerating health and extra speed.
Your objective as the Juggernaut is stay alive for as long as possible and wreak havoc upon your enemies; everybody else's objective is to kill the Juggernaut.

Scoring:
For every minute that you're alive as the Juggernaut you will receive 1 score point.
Killing the Juggernaut rewards you 5 points.
As the Juggernaut you will be rewarded 2 points for every kill.
The first player to reach 50 kills as Juggernaut wins.


This mod is highly editable. See Configuration section below.

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 
api_version = "1.12.0.0"
script_version = "  |  beta v1.0"
-- tables --
player_equipment = { }
initiate_timer = { }
welcome_timer = { }
join_timer = { }
players = { }
weapons = { }
weapon = { }
frags = { }
plasmas = { }
turn_timer = { }
score_timer = { }
save_equipment = { }
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
start_delay = 5
-- Player's can only be the Juggernaut for a limited amount of time.
TurnTime = 5

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
-- Receive 1 score point every X seconds (30 by default)
allocated_time = 30
-- points received every "allocated_time" seconds
alive_points = 1

-- Juggernaut Weapon Layout --
-- Copy & Paste a Weapon Tag (see remarks at bottom of script) between the double quotes to change the weapon
weapons[1] = "weapons\\sniper rifle\\sniper rifle"	        -- Primary      | WEAPON SLOT 1
weapons[2] = "weapons\\pistol\\pistol"						-- Secondary    | WEAPON SLOT 2
weapons[3] = "weapons\\rocket launcher\\rocket launcher"    -- Tertiary     | WEAPON SLOT 3
weapons[4] = "weapons\\shotgun\\shotgun"                    -- Quaternary   | WEAPON SLOT 3

-- Scoring Message Alignment | Left = l,    Right = r,    Centre = c,    Tab: t
Alignment = "l"


-- Message Board Settings --
-- How long should the message be displayed on screen for? (in seconds) --
Message_Duration = 10
-- Left = l,    Right = r,    Centre = c,    Tab: t
Message_Alignment = "l"

-- Use $SERVER_NAME variable to output the server name.
-- Use $PLAYER_NAME variable to output the joining player's name.

-- messages --
message_board = {
    "Welcome to $SERVER_NAME",
    "For live updates on the development of this game:",
    "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/projects/3"
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
    ["UseWelcomeMessages"] = true,
    -- Select new Juggernaut every 30 seconds
    ["UseTurnTimer"] = true
}

-- TO DO
-- Weapon Damage Modifier Settings
weapon_settings = {
        ["Sniper_DamageModifier"] = false,
        ["Pistol_DamageModifier"] = false
    }
---------------------------------------------------
    

-- You can only set a maximum of 7 grenades!
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
    register_callback(cb['EVENT_PRESPAWN'], "OnPreSpawn")
    register_callback(cb['EVENT_VEHICLE_ENTER'], "OnVehicleEntry")
    register_callback(cb['EVENT_VEHICLE_EXIT'], "OnVehicleExit")
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                players[get_var(i, "$n")].weapon_trigger = false
                players[get_var(i, "$n")].current_juggernaut = nil
                players[get_var(i, "$n")].previous_juggernaut = nil
                players[get_var(i, "$n")].kills = 0
                players[get_var(i, "$n")].join_timer = 0
                players[get_var(o, "$n")].turn_timer = 0
                players[get_var(i, "$n")].time_alive = 0
            end
        end
    end
    if (get_var(0, "$gt") ~= "n/a") then
        mapname = get_var(0, "$map")
        GrenadeTable()
        LoadMaps()
        CheckType()
    end
    current_players = 0
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
    CheckType()
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
                players[get_var(i, "$n")].weapon_trigger = false
                players[get_var(i, "$n")].current_juggernaut = nil
                players[get_var(i, "$n")].previous_juggernaut = nil
                players[get_var(i, "$n")].kills = 0
                players[get_var(i, "$n")].join_timer = 0
                players[get_var(i, "$n")].turn_timer = 0
                players[get_var(i, "$n")].time_alive = 0
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
    --timer(1000 * start_delay, "SelectNewJuggernaut")
    execute_command("scorelimit 250")
end

function OnGameEnd()
    gamestarted = false
    current_players = 0
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                welcome_timer[i] = false
                players[get_var(i, "$n")].weapon_trigger = false
                players[get_var(i, "$n")].current_juggernaut = nil
                players[get_var(i, "$n")].previous_juggernaut = nil
                players[get_var(i, "$n")].kills = 0
                players[get_var(i, "$n")].join_timer = 0
                players[get_var(i, "$n")].turn_timer = 0
                players[get_var(i, "$n")].time_alive = 0
            end
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    current_players = current_players + 1
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].weapon_trigger = false
    players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
    players[get_var(PlayerIndex, "$n")].previous_juggernaut = nil
    players[get_var(PlayerIndex, "$n")].kills = 0
    players[get_var(PlayerIndex, "$n")].join_timer = 0
    players[get_var(PlayerIndex, "$n")].turn_timer = 0
    players[get_var(PlayerIndex, "$n")].time_alive = 0
    if not players[get_var(PlayerIndex, "$n")].current_juggernaut then
        welcome_timer[PlayerIndex] = true
    end
end

function OnPlayerLeave(PlayerIndex)
    welcome_timer[PlayerIndex] = false
    current_players = current_players - 1
    players[get_var(PlayerIndex, "$n")].kills = 0
    players[get_var(PlayerIndex, "$n")].join_timer = 0
    players[get_var(PlayerIndex, "$n")].turn_timer = 0
    players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
end

function OnPlayerSpawn(PlayerIndex)
    weapon[PlayerIndex] = true
    mapname = get_var(0, "$map")
    players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
    players[get_var(PlayerIndex, "$n")].weapon_trigger = false
    players[get_var(PlayerIndex, "$n")].time_alive = 0
end

function OnPreSpawn(PlayerIndex)
    if (players[get_var(PlayerIndex, "$n")].current_juggernaut) then
        players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
        players[get_var(PlayerIndex, "$n")].weapon_trigger = false
        players[get_var(PlayerIndex, "$n")].time_alive = 0
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

function OnVehicleExit(PlayerIndex)
    if players[get_var(PlayerIndex, "$n")].current_juggernaut then
        if players[get_var(PlayerIndex, "$n")].weapon_trigger == true then
            weapon[PlayerIndex] = false
            local player_object = get_dynamic_player(PlayerIndex)
            if player_object ~= 0 then
                local PlayerObj = get_dynamic_player(PlayerIndex)
                local VehicleObj = get_object_memory(read_dword(PlayerObj + 0x11c))
                local vehicle_tag = read_string(read_dword(read_word(VehicleObj) * 32 + 0x40440038))
                if vehicle_tag == "vehicles\\warthog\\mp_warthog" then
                    assign_delay = 1000
                elseif vehicle_tag == "vehicles\\rwarthog\\rwarthog" then
                    assign_delay = 1000 * 1.1
                elseif vehicle_tag == "vehicles\\scorpion\\scorpion_mp" then
                    assign_delay = 1000 * 2
                elseif vehicle_tag == "vehicles\\ghost\\ghost_mp" then
                    assign_delay = 800
                elseif vehicle_tag == "vehicles\\banshee\\banshee_mp" then
                    assign_delay = 1000 * 1.1
                elseif vehicle_tag == "vehicles\\c gun turret\\c gun turret_mp" then
                    assign_delay = 1000 * 1.1
                end
                if (player_alive(PlayerIndex)) then
                    timer(assign_delay, "delayGive", PlayerIndex)
                end
            end
            players[get_var(PlayerIndex, "$n")].weapon_trigger = false
        end
    end
end

function delayGive(PlayerIndex)
    local x, y, z = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
    assign_weapon(spawn_object("weap", weapons[2], x, y, z), PlayerIndex)
    assign_weapon(spawn_object("weap", weapons[3], x, y, z), PlayerIndex)
    timer(50, "TertiaryDelay", x, y, z, PlayerIndex)
end

function OnVehicleEntry(PlayerIndex)
    if players[get_var(PlayerIndex, "$n")].current_juggernaut then
        players[get_var(PlayerIndex, "$n")].weapon_trigger = false
    end
end

function TertiaryDelay(x,y,z, player)
    assign_weapon(spawn_object("weap", weapons[1], x, y, z), player)
    assign_weapon(spawn_object("weap", weapons[4], x, y, z), player)
end

function OnTick()
    -- Juggernaut weapon, health and shield handler
    for i = 1, current_players do
        if player_present(i) then
            if player_alive(i) then
                if (players[get_var(i, "$n")].current_juggernaut) then
                    initiate_timer[i] = true
                    -- debugging
                    cprint("current_juggernaut: " .. get_var(i, "$name").. " [" .. players[get_var(i, "$n")].current_juggernaut .. "]")
                    if (MapIsListed == false) then
                        return false
                    else
                        local player = get_dynamic_player(i)
                        local x, y, z = read_vector3d(player + 0x5C)
                        if (weapon[i] == true) then
                            execute_command("wdel " .. i)
                            if (mapname == "bloodgulch") then
                                if not PlayerInVehicle(i) then
                                    assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                                    assign_weapon(spawn_object("weap", weapons[3], x, y, z), i)
                                    timer(50, "TertiaryDelay", x,y,z, i)
                                    weapon[i] = false
                                end
                                if (bool == true) then
                                    AssignGrenades(i)
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
                else
                    -- set default running speed for all non-juggernauts
                    execute_command("s " .. i .. " 1")
                end
            end
        end
    end
    if (current_players == 2) then
        for j = 1, current_players do
            if player_present(j) then
                if (j ~= players[get_var(j, "$n")].current_juggernaut) then
                    local m_player = get_player(j)
                    local player = to_real_index(j)
                    if m_player ~= 0 then
                        if j ~= nil then
                            if (tick_bool) == nil then
                                -- nobody is the Juggernaut | Reposition NAV Markers (not sure how to remove them completely)
                                write_word(m_player + 0x88, player + 10)
                            end
                        end
                    end
                    -- Someone is now the Juggernaut
                end
            end
        end
    end
    -- Juggernaut Health Regeneration handler
    for k = 1, current_players do
        if player_alive(k) then
            if (players[get_var(k, "$n")].current_juggernaut) then
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
    -- Timed Points Handler
    if (gamesettings["AliveTimer"] == true) then
        for l = 1, current_players do
            if player_present(l) then
                if (score_timer[l] ~= false and PlayerAlive(l) == true) then
                    if (players[get_var(l, "$n")].current_juggernaut) then
                        players[get_var(l, "$n")].time_alive = players[get_var(l, "$n")].time_alive + 0.030
                        if (players[get_var(l, "$n")].time_alive >= math.floor(allocated_time)) then
                            local minutes, seconds = secondsToTime(players[get_var(l, "$n")].time_alive, 2)
                            execute_command("score " .. l .. " +" .. tostring(alive_points))
                            players[get_var(l, "$n")].time_alive = 0
                        end
                    end
                end
            end
        end
    end
    -- Message Board Handler
    if (gamesettings["UseWelcomeMessages"] == true) then 
        for m = 1, current_players do
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
                    else
                        cls(m)
                        welcome_timer[m] = true
                    end
                end
            end
        end
    end
    -- TURN TIMER
    if (gamesettings["UseTurnTimer"] == true) then
        if not debugging then
            for n = 1, current_players do
                if player_present(n) then
                    if initiate_timer[n] == true then
                    
                        -- debugging
                        cprint(get_var(n, "$name") .. ": initiate_timer == true")
                        
                        if n == players[get_var(n, "$n")].current_juggernaut then
                            players[get_var(n, "$n")].turn_timer = players[get_var(n, "$n")].turn_timer + 0.030
                            
                            -- debugging
                            local minutes, seconds = secondsToTime(players[get_var(n, "$n")].turn_timer, 2)
                            cprint(get_var(n, "$name") .. ": " .. TurnTime - math.floor(seconds) .. " seconds")
                            
                            if players[get_var(n, "$n")].turn_timer >= math.floor(TurnTime) then
                                -- reset timers and select new juggernaut
                                players[get_var(n, "$n")].turn_timer = 0
                                local exclude = tonumber(players[get_var(n, "$n")].current_juggernaut)
                                players[get_var(n, "$n")].current_juggernaut = nil
                                SelectionHandler(exclude)
                                initiate_timer[n] = false
                                
                                -- debugging
                                cprint(get_var(n, "$name") .. ": initiate_timer == false", 4+8)
                                
                                -- Load equipment held before they became Juggernaut
                                if player_alive(n) then LoadEquipment(n) end
                            end
                        end
                    end
                end
            end
        end
    end
    -- monitor and save equipment | non-juggernaut only
    for o=1,current_players do
        if player_alive(o) then
            if not players[get_var(o, "$n")].current_juggernaut then
                SaveEquipment(o)
            end
        end
    end
end

-- prototype
function SelectionHandler(player)
    execute_command("msg_prefix \"\"")
    -- automatic selection
    if not CommandTrigger then
        math.randomseed(os.time())
        local indexToExclude = get_var(player, "$n")
        local selectedIndex = math.random(1, current_players)
        -- number chosen matches the selectedIndex id of the previous juggernaut
        if (selectedIndex == tonumber(indexToExclude)) then
            while selectedIndex == tonumber(indexToExclude) do
                local newNumber = math.random(1, current_players)
                players[get_var(newNumber, "$n")].current_juggernaut = (newNumber)
                execute_command("s " .. newNumber .. " :" .. tonumber(juggernaut_running_speed[mapname]))
                SetNavMarker(newNumber)
                bool = true
                for i=1,16 do
                    if (i ~= tonumber(newNumber)) then
                        say(i, string.gsub(JuggernautAssignMessage, "$NAME", get_var(newNumber, "$name")))
                    end
                end
                break
            end
        -- number chosen does not match the selectedIndex id of the previous juggernaut
        else
            players[get_var(selectedIndex, "$n")].current_juggernaut = (selectedIndex)
            execute_command("s " .. selectedIndex .. " :" .. tonumber(juggernaut_running_speed[mapname]))
            say(selectedIndex, "You're now the Juggernaut!")
            SetNavMarker(selectedIndex)
            bool = true
            for i=1,16 do
                if (i ~= tonumber(selectedIndex)) then
                    say(i, string.gsub(JuggernautAssignMessage, "$NAME", get_var(selectedIndex, "$name")))
                end
            end
        end
    end
    -- command trigger
    if CommandTrigger == true then
        players[get_var(player, "$n")].current_juggernaut = (player)
        say(player, "You're now the Juggernaut!")
        SetNavMarker(player)
        bool = true
        for j = 1, current_players do
            if j ~= player then
                say(j, string.gsub(JuggernautAssignMessage, "$NAME", get_var(player, "$name")))
            end
        end
        execute_command("s " .. player .. " :" .. tonumber(juggernaut_running_speed[mapname]))
        -- temporary
        debugging = true
    end
    execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
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
    if killer ~= -1 then
        if killer == players[get_var(KillerIndex, "$n")].current_juggernaut and tonumber(victim) ~= tonumber(killer) then
            players[get_var(killer, "$n")].kills = players[get_var(killer, "$n")].kills + 1
            rprint(killer, "|" .. Alignment .. "Kills as Juggernaut: " .. players[get_var(killer, "$n")].kills .. "/" ..tostring(killLimit))
        end
    end
    if (PlayerIndex == players[get_var(PlayerIndex, "$n")].current_juggernaut) then
        score_timer[PlayerIndex] = false
        players[get_var(PlayerIndex, "$n")].time_alive = 0
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
        if (killer == players[get_var(killer, "$n")].current_juggernaut) and (victim ~= players[get_var(victim, "$n")].current_juggernaut) and (killer ~= -1) then
            execute_command("score " .. KillerIndex .. " +" .. tostring(points))
            rprint(killer, "|" .. Alignment .. "+" .. tostring(points) .. " PTS")
        end
    end
    -- Neither Killer or Victim are Juggernaut | Make Killer Juggernaut | Update Score
    if (current_players == 2) then
        if (killer ~= players[get_var(killer, "$n")].current_juggernaut) and (victim ~= players[get_var(PlayerIndex, "$n")].current_juggernaut) and (tonumber(victim) ~= tonumber(KillerIndex)) then
            players[get_var(killer, "$n")].current_juggernaut = killer
            if PlayerInVehicle(KillerIndex) then
                players[get_var(killer, "$n")].weapon_trigger = true
            else
                players[get_var(killer, "$n")].weapon_trigger = false
            end
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
            if PlayerInVehicle(KillerIndex) then
                players[get_var(killer, "$n")].weapon_trigger = true
            else
                players[get_var(killer, "$n")].weapon_trigger = false
            end
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
    
    -- prototype | reset nav markers
    if (killer == -1 and victim == players[get_var(victim, "$n")].current_juggernaut) then
        for j = 1, current_players do
            if player_present(j) then
                if (j == players[get_var(j, "$n")].current_juggernaut) then
                    local m_player = get_player(j)
                    local player = to_real_index(j)
                    if m_player ~= 0 then
                        if j ~= nil then
                            if (tick_bool) == nil then
                                write_word(m_player + 0x88, player + 10)
                                players[get_var(victim, "$n")].current_juggernaut = nil
                            end
                        end
                    end
                end
            end
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
        -- remove their juggernaut status
        players[get_var(victim, "$n")].current_juggernaut = nil
        
        say(KillerIndex, "You are no longer the Juggernaut!")
        -- Call SelectNewJuggernaut() | Select someone else as the new Juggernaut
        SelectionHandler(victim)
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
    if (killer ~= -1) then
        if (killer == players[get_var(killer, "$n")].current_juggernaut) then
            local kills = tonumber(players[get_var(killer, "$n")].kills)
            if (kills >= tonumber(killLimit)) then
                execute_command("sv_map_next")
            end
        end
    end
    -- Reset their speed
    if victim == players[get_var(PlayerIndex, "$n")].current_juggernaut then
        execute_command("s " .. victim .. " 1")
    end
    
    -- debugging
    save_equipment[PlayerIndex] = false
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
                            CommandTrigger = true
                            SelectionHandler(executor)
                        elseif (players[get_var(executor, "$n")].current_juggernaut) then
                            rprint(executor, "You're already the Juggernaut!")
                        end
                    elseif (t[2] ~= nil and t[2] ~= "me") then
                        if not string.match(t[2], "%d") then
                            rprint(executor, "|" .. Alignment .. "Arg2 was not a number!")
                        else
                            if player_present(arg2) then
                                if player_alive(arg2) then
                                    if (arg2 ~= players[get_var(arg2, "$n")].current_juggernaut) and (arg2 ~= executor) then
                                        CommandTrigger = true
                                        SaveEquipment(arg2)
                                        say(arg2, "Equipment Saved")
                                        SelectionHandler(arg2)
                                    elseif (players[get_var(arg2, "$n")].current_juggernaut) and (arg2 ~= executor) then
                                        rprint(executor, get_var(arg2, "$name") .. " is already the Juggernaut!")
                                    elseif (arg2 ~= players[get_var(arg2, "$n")].current_juggernaut) and (arg2 == executor) then
                                        CommandTrigger = true
                                        SaveEquipment(arg2)
                                        say(arg2, "Equipment Saved")
                                        SelectionHandler(arg2)
                                    elseif (players[get_var(arg2, "$n")].current_juggernaut) and (arg2 == executor) then
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
                    UnknownCMD = false
                end
            else
                rprint(executor, "You are dead!")
                UnknownCMD = false
            end
        elseif t[1] == string.lower("e") then
            save_equipment[PlayerIndex] = false
            CommandTrigger = false
            debugging = false
            LoadEquipment(executor)
            say(executor, "Equipment Loaded")
            for i = 1,current_players do
                players[get_var(i, "$n")].current_juggernaut = nil
            end
            UnknownCMD = false
        end
    end
    return UnknownCMD
end

function PlayerInVehicle(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local VehicleID = read_dword(player_object + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
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

-- timer debugging function
function secondsToTime(seconds, places)
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60
    if places == 2 then
        return minutes, seconds
    end
end

function CheckType()
    local type_is_ctf = get_var(1, "$gt") == "ctf"
    local type_is_koth = get_var(1, "$gt") == "koth"
    local type_is_oddball = get_var(1, "$gt") == "oddball"
    local type_is_race = get_var(1, "$gt") == "race"
    if (type_is_ctf) or (type_is_koth) or (type_is_oddball) or (type_is_race) then
        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_DIE'])
        unregister_callback(cb['EVENT_GAME_END'])
        unregister_callback(cb['EVENT_LEAVE'])
        unregister_callback(cb['EVENT_GAME_START'])
        unregister_callback(cb['EVENT_SPAWN'])
        unregister_callback(cb['EVENT_COMMAND'])
        unregister_callback(cb['EVENT_PRESPAWN'])
        unregister_callback(cb['EVENT_VEHICLE_ENTER'])
        unregister_callback(cb['EVENT_VEHICLE_EXIT'])
        cprint("Warning: This script doesn't support CTF, KOTH, ODDBALL, or RACE", 4 + 8)
    end
    local type_is_slayer = get_var(1, "$gt") == "slayer"
    if (type_is_slayer) then
        if not(table.match(mapnames, mapname)) then
            unregister_callback(cb['EVENT_TICK'])
            unregister_callback(cb['EVENT_JOIN'])
            unregister_callback(cb['EVENT_DIE'])
            unregister_callback(cb['EVENT_GAME_END'])
            unregister_callback(cb['EVENT_LEAVE'])
            unregister_callback(cb['EVENT_GAME_START'])
            unregister_callback(cb['EVENT_SPAWN'])
            unregister_callback(cb['EVENT_COMMAND'])
            unregister_callback(cb['EVENT_PRESPAWN'])
            unregister_callback(cb['EVENT_VEHICLE_ENTER'])
            unregister_callback(cb['EVENT_VEHICLE_EXIT'])
            cprint("juggernaut.lua does not support the map " .. mapname, 4 + 8)
            cprint("Script cannot be used.", 4 + 8)
        end
    end
end

function OnError(Message)
    print(debug.traceback())
    execute_command_sequence("beep 1200 150; beep 1200 150; beep 1200 150")
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

---------------------------------------------------------------------------------------------------------------------------
-- [!] acknowledgements: 002's Equipment Saving functions
function SaveEquipment(PlayerIndex)
    local dynamic_player = get_dynamic_player(PlayerIndex)
    if dynamic_player ~= 0 then
        local player_info = {}
        player_info.Weapons = {}
        for i=0,3 do
            Weapon = get_object_memory(read_dword(dynamic_player + 0x2F8 + i * 4))
            if Weapon ~= 0 then
                player_info.Weapons[i+1] = {
                    ["id"] = read_dword(Weapon),
                    ["primary_ammo"] = read_word(Weapon + 0x2B6),
                    ["primary_clip"] = read_word(Weapon + 0x2B8),
                    ["secondary_ammo"] = read_word(Weapon + 0x2C6),
                    ["secondary_clip"] = read_word(Weapon + 0x2C8),
                    ["age"] = read_float(Weapon + 0x240)
                }
            end
        end
        player_info.primary_nades = read_byte(dynamic_player + 0x31E)
        player_info.secondary_nades = read_byte(dynamic_player + 0x31F)
        player_equipment[get_var(PlayerIndex,"$n")] = player_info
    end
end

function LoadEquipment(PlayerIndex)
    local player_info = player_equipment[get_var(PlayerIndex,"$n")]
    local dynamic_player = get_dynamic_player(PlayerIndex)
    if dynamic_player ~= 0 then
        destroy_object(read_dword(dynamic_player + 0x304))
        destroy_object(read_dword(dynamic_player + 0x300))
        destroy_object(read_dword(dynamic_player + 0x2FC))
        destroy_object(read_dword(dynamic_player + 0x2F8))
        for i,Weapon in pairs(player_info.Weapons) do
            local obj = spawn_object("weap","hi",0.0,0.0,0.0,0.0,Weapon.id)
            local obj_dyn = get_object_memory(obj)
            write_word(obj_dyn + 0x2B6, Weapon.primary_ammo)
            write_word(obj_dyn + 0x2B8, Weapon.primary_clip)
            write_word(obj_dyn + 0x2C6, Weapon.secondary_ammo)
            write_word(obj_dyn + 0x2C8, Weapon.secondary_clip)
            write_float(obj_dyn + 0x240, Weapon.age)
            sync_ammo(obj)
            assign_weapon(obj,PlayerIndex)
        end
        write_byte(dynamic_player + 0x31E,player_info.primary_nades)
        write_byte(dynamic_player + 0x31F,player_info.secondary_nades)
    end
end

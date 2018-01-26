--[[
--=====================================================================================================--
Script Name: Juggernaut, for SAPP Server Extension on (Halo PC & Halo PC Custom Edition), beta v1.1
Implementing API version: 1.12.0.0

When the game begins, the player to get "first blood" becomes the juggernaut. 

Juggernauts are very powerful, wield 4 weapons and have regenerating health and extra (variable) speed in combination with alternating camouflage and full over-shield.

The game incorporates changes to player physics, weapon projectiles, inventory saving and loading among other features.
Your objective as the juggernaut is to stay alive for as long as possible and wreak havoc on your enemies

The non-juggernaut objective is to hunt down and kill the aforementioned current juggernaut - you will now become the juggernaut yourself.

During a game, if there are only two players online then the only way to become the juggernaut is to kill them as previously mentioned. 

However, if there are 3 or more players online then a "turn timer" is initiated and you can only be the juggernaut for 60 seconds and then someone else is randomly selected to become the new juggernaut.
Note, you can kill the juggernaut before their time is up and take their role.


Coming in a future update...
Weapon degradation implementation.
After firing X bullets your weapon begins to wear down and doesn't function properly until it eventually breaks and you have to find a new weapon or PARTS to repair it... 
Maybe even a repair station where you have to stand at a designated spot for X amount of time while your weapon is automatically repaired!

The game can only end in two ways; either you reach the kill threshold required to end the game or wait until the game time limit has elapsed. 

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

api_version = "1.12.0.0"
-------------------- CONFIGURATION STARTS -----------------------------------------------------------------------------------------
-- Message to send all players when a new Juggernaut is assigned.
JuggernautAssignMessage = "$NAME is now the Juggernaut!"

-- Weapons assigned to the Juggernaut. Set 'true' >> 'false' to prevent that weapon from being assigned.
weapons = { }
weapons[1] = {"weap", "weapons\\sniper rifle\\sniper rifle",            true}
weapons[2] = {"weap", "weapons\\pistol\\pistol",                        true}
weapons[3] = {"weap", "weapons\\rocket launcher\\rocket launcher",      true}
weapons[4] = {"weap", "weapons\\shotgun\\shotgun",                      true}
-- Custom Server Prefix
SERVER_PREFIX = "JUGGERNAUT"

-- points awarded because they were the first player to become juggernaut
first_blood = 1
-- points awarded because they killed the juggernaut
gotcha_points = 2
-- general points awarded for every kill as juggernaut
general_points = 3
-- health: (0 to 99999) (Normal = 1)
juggernaut_health = 2
-- health will regenerate in chunks of (juggernaut_health_increment) every 30 ticks until they gain maximum health.
juggernaut_health_increment = 0.0005
-- shields: (0 to 3) (Normal = 1) (Full overshield = 3)
juggernaut_shields = 3
-- end the game once the juggernaut has this many kills
killLimit = 25
-- Default Running Speed for non-juggernauts
default_running_speed = 1
-- juggernaut Turn-Duration (in seconds)
TurnTime = 10
-- When juggernaut commits suicide, how long (in seconds) until someone else is chosen to be juggernaut?
SuicideSelectDelay = 5
-- juggernaut is rewarded (alive_points) every (allocated_time) seconds (30 by default)
allocated_time = 30
-- points rewarded every "allocated_time" seconds
alive_points = 1
-- If playerX is juggernaut and they are the only player in the server reset them after (reset_delay) amount of time.
reset_delay = 7
-- Minimum Players needed to become juggernaut
minimum_players = 2
-- turn timer will only be used if there is this many (or more) players online
turn_timer_min_players = 3
-- The game will end if this amount of time (in seconds) has elapsed [900 = 15 minutes]
game_time_limit = 900

-- Scoring Message Alignment | Left = l,    Right = r,    Centre = c,    Tab: t
Alignment = "l"

-- Message Board Settings | How long should the message be displayed on screen for? (in seconds)
message_duration = 5
-- Left = l,    Right = r,    Centre = c,    Tab: t
message_alignment = "l"

-- Use $SERVER_NAME variable to output the server name.
-- Use $PLAYER_NAME variable to output the joining player's name.

-- messages --
message_board = {
    "Welcome to $SERVER_NAME",
    "For live updates on the development of this game:",
    "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/projects/3"
    }

gamesettings = {
    -- assign extra frags|plasmas to juggernaut?
    ["AssignFragGrenades"] = true,
    ["AssignPlasmaGrenades"] = true,
    -- give extra health & overshield to juggernaut?
    ["GiveExtraHealth"] = true,
    ["GiveOvershield"] = true,
    -- award (alive_points) points every (allocated_time) seconds to the juggernaut?
    ["AliveTimer"] = true,
    -- delete juggernaut weapons when they die?
    ["DeleteWeapons"] = true,
    -- display messages in message board?
    ["UseWelcomeMessages"] = true,
    -- select new juggernaut every (TurnTime) seconds
    ["UseTurnTimer"] = true
}

-- DAMAGE MULTIPLIERS
damage_multipliers = { }
for i = 1, 16 do damage_multipliers[i] = {
        -- weapons                                        damage            melee
        { "weapons\\assault rifle\\assault rifle",          1.120,            4},     
        { "weapons\\flamethrower\\flamethrower",            1.140,            4}, 
        { "weapons\\needler\\mp_needler",                   1.110,            3}, 
        { "weapons\\pistol\\pistol",                        1.100,            1.1}, 
        { "weapons\\plasma pistol\\plasma pistol",          1.050,            3}, 
        { "weapons\\plasma rifle\\plasma rifle",            1.250,            1.3}, 
        { "weapons\\rocket launcher\\rocket launcher",      1.090,            1}, 
        { "weapons\\plasma_cannon\\plasma_cannon",          1.080,            1}, 
        { "weapons\\shotgun\\shotgun",                      1.250,            1.3}, 
        { "weapons\\sniper rifle\\sniper rifle",            1.500,            1.2}, 
        -- vehicles                                      damage           collision
        { "vehicles\\warthog\\mp_warthog",                  1.350,            1.050},
        { "vehicles\\ghost\\ghost_mp",                      1.020,            1.025},
        { "vehicles\\rwarthog\\rwarthog",                   1.500,            1.050},
        { "vehicles\\banshee\\banshee_mp",                  1.150,            1.35},
        { "vehicles\\scorpion\\scorpion_mp",                1.100,            4.50},
        { "vehicles\\c gun turret\\c gun turret_mp",        2.500,            1},
        -- grenades                                       damage
        { "weapons\\frag grenade\\explosion",               1.5},
        { "weapons\\plasma grenade\\attached",              4},
        { "weapons\\plasma grenade\\explosion",             2.5}
    }
end
-- Set frags, plasmas and running speed on a per map basis
function LoadMaps()
    map_settings = {
        -- large maps         frags   plasmas   Juggernaut Running Speed
        { "infinity",           6,       5,              1.45},
        { "icefields",          2,       3,              1.25},
        { "bloodgulch",         6,       3,              1.35},
        { "timberland",         4,       7,              1.35},
        { "sidewinder",         7,       3,              1.30},
        { "deathisland",        4,       2,              1.45},
        { "dangercanyon",       6,       3,              1.15},
        { "gephyrophobia",      2,       3,              1.20},
        -- small maps
        { "wizard",             3,       1,              1.10},
        { "putput",             1,       2,              1.10},
        { "longest",            2,       1,              1.05},
        { "ratrace",            3,       4,              1.10},
        { "carousel",           2,       5,              1.15},
        { "prisoner",           1,       1,              1.10},
        { "damnation",          4,       3,              1.10},
        { "hangemhigh",         3,       2,              1.10},
        { "beavercreek",        2,       1,              1.10},
        { "boardingaction",     2,       2,              1.10}
    }
    for k,v in pairs(map_settings) do
        if mapname == map_settings[k][1] then
            juggernaut_running_speed = map_settings[k][4]
        end 
    end
end
-------------------- CONFIGURATION ENDS -----------------------------------------------------------------------------------------

-- tables | player allocation and timers --
players = { }
welcome_timer = { }
join_timer = { }
score_timer = { }
death_bool = { }
reset_bool = { }
vehicle_check = { }
assign_delay = { }
damage_applied = { }
-- weapon assignment tables --
player_equipment = { }
assign_weapons = { }
-- damage multiplier tables --
damage_multiplier = { }
damage_type = { }

-- used for inventory restoring
death_location = { }
for i = 1, 16 do death_location[i] = { } end
delete_weapons_bool = { }
restore_inventory = { }

-- booleans --
set_after_spawn = { }
game_timer = nil

-- counts --
current_players = 0

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPrespawn")
    register_callback(cb['EVENT_VEHICLE_EXIT'], "OnVehicleExit")
    register_callback(cb['EVENT_VEHICLE_ENTER'], "OnVehicleEntry")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    deathmessages = sig_scan("8B42348A8C28D500000084C9") + 3
    original = read_dword(deathmessages)
    safe_write(true)
    write_dword(deathmessages, 0x03EB01B1)
    safe_write(false)
end

function OnScriptUnload()
    safe_write(true)
    write_dword(deathmessages, original)
    safe_write(false)
end

function OnNewGame()
    execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
    mapname = get_var(0, "$map")
    LoadMaps()
    CheckType()
    execute_command("map_skip 1")
    -- The game will only end once the Juggernaut has (killLimit) kills
    execute_command("timelimit 99999")
    execute_command("scorelimit 99999")
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    servername = read_widestring(network_struct + 0x8, 0x42)
    selection_bool = true
    -- start game countdown timer
    start_timer = true
    game_timer = os.clock()
end

function OnGameEnd()
    start_timer = false
    current_players = 0
    for i = 1, 16 do
        if player_present(i) then
            if player_present(i) then
                welcome_timer[i] = false
                if not (timeup) then
                    players[get_var(i, "$n")].kills = 0
                else
                    players[get_var(i, "$n")].vehicle_trigger = false
                    players[get_var(i, "$n")].current_juggernaut = nil
                    players[get_var(i, "$n")].swap_timer = 0
                    players[get_var(i, "$n")].join_timer = 0
                    players[get_var(i, "$n")].time_alive = 0
                    local kills = tonumber(players[get_var(i, "$n")].kills)
                    rprint(i, "|c" .. kills)
                end
            end
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    set_after_spawn[PlayerIndex] = false
    welcome_timer[PlayerIndex] = true
    restore_inventory[PlayerIndex] = false
    damage_type[PlayerIndex] = 0
    damage_multiplier[PlayerIndex] = 0
    damage_applied[PlayerIndex] = 0
    current_players = current_players + 1
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].vehicle_trigger = false
    players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
    players[get_var(PlayerIndex, "$n")].kills = 0
    players[get_var(PlayerIndex, "$n")].swap_timer = 0
    players[get_var(PlayerIndex, "$n")].join_timer = 0
    players[get_var(PlayerIndex, "$n")].time_alive = 0
    -- ensure nav markers are reset for everybody
    if current_players >= 2 then
        for i = 1, current_players do
            if player_present(i) then
                if (i ~= players[get_var(i, "$n")].current_juggernaut) then
                    ResetNavMarker()
                end
            end
        end
    end
end

function OnPlayerLeave(PlayerIndex)
    if players[get_var(PlayerIndex, "$n")] ~= nil then
        players[get_var(PlayerIndex, "$n")].kills = 0
        players[get_var(PlayerIndex, "$n")].join_timer = 0
        players[get_var(PlayerIndex, "$n")].swap_timer = 0
        players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
        current_players = current_players - 1
        for i = 1, 3 do death_location[PlayerIndex][i] = nil end
        welcome_timer[PlayerIndex] = false
        damage_applied[PlayerIndex] = nil
    end
end

function OnPlayerPrespawn(PlayerIndex)
    if PlayerIndex then
        if death_location[PlayerIndex][1] ~= nil then
            write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, death_location[PlayerIndex][1], death_location[PlayerIndex][2], death_location[PlayerIndex][3])
            for i = 1, 3 do
                death_location[PlayerIndex][i] = nil
            end
        end
    end
end

-- This function is called when a player has finished spawning.
function OnPlayerSpawn(PlayerIndex)
    if (set_after_spawn[PlayerIndex] == true) then
        set_after_spawn[PlayerIndex] = false
        SetNewJuggernaut(tonumber(PlayerIndex), false, false)
    else
        players[get_var(PlayerIndex, "$n")].current_juggernaut = nil
    end
    players[get_var(PlayerIndex, "$n")].swap_timer = 0
    players[get_var(PlayerIndex, "$n")].vehicle_trigger = false
    players[get_var(PlayerIndex, "$n")].time_alive = 0
    assign_weapons[PlayerIndex] = true
    if restore_inventory[PlayerIndex] then
        restore_inventory[PlayerIndex] = false
        RestoreWeapons(PlayerIndex)
    end
end

-- Ends the game when the (game_time_limit) has elapsed
function GameCountDownTimer()
    if (game_timer ~= nil) then
        local countdown_timer = math.floor(os.clock())
        if (countdown_timer == game_time_limit) then
            start_timer = false
            execute_command("sv_map_next")
            timeup = true 
        else
            timeup = false 
        end
    end
end

-- This function is called every game tick (1/30 second) - 33.3333333 ms.
-- Similar to Phasor's OnClientUpdate() function.
function OnTick()
    -- initiate game countdown timer --
    if (start_timer == true) then GameCountDownTimer() end
    -- weapon assignment and inventory saving --
    for i = 1,current_players do
        if player_present(i) then
            if player_alive(i) then
                if players[get_var(i, "$n")].current_juggernaut then
                    SetNavMarker(tonumber(i))
                    if (assign_weapons[i] == true) then 
                        local player_object = get_dynamic_player(i)
                        if player_object ~= 0 then
                            assign_weapons[i] = false
                            local inventory = {}
                            inventory.loadout = {}
                            for b = 0,3 do
                                weapon = get_object_memory(read_dword(player_object + 0x2F8 + b * 4))
                                if weapon ~= 0 then
                                    inventory.loadout[b+1] = {
                                        ["identifier"] = read_dword(weapon),
                                         -- primary loaded ammo
                                        ["primary_loaded_ammo"] = read_word(weapon + 0x2B8),
                                        -- primary reserve ammo
                                        ["primary_reserve_ammo"] = read_word(weapon + 0x2B6),
                                        -- secondary loaded ammo
                                        ["secondary_loaded_ammo"] = read_word(weapon + 0x2C6),
                                        -- secondary reserve ammo
                                        ["secondary_reserve_ammo"] = read_word(weapon + 0x2C8),
                                        -- battery age
                                        ["battery"] = read_float(weapon + 0x240)
                                    }
                                end
                            end
                            inventory.health = read_float(player_object + 0xE0)
                            inventory.frag_grenades = read_byte(player_object + 0x31E)
                            inventory.plasma_grenades = read_byte(player_object + 0x31F)
                            player_equipment[get_var(i,"$n")] = inventory
                            if not PlayerInVehicle(i) then
                                local x, y, z = GetCoords(i)
                                InventoryAssignment(i, x,y,z + 0.3)
                            else
                                players[get_var(i, "$n")].vehicle_trigger = true
                            end
                        end
                    end
                    -- turn timer --
                    if gamesettings["UseTurnTimer"] == true then
                        if (current_players >= turn_timer_min_players) then
                            if (i == players[get_var(i, "$n")].current_juggernaut) then
                                players[get_var(i, "$n")].swap_timer = players[get_var(i, "$n")].swap_timer + 0.030
                                if players[get_var(i, "$n")].swap_timer >= math.floor(TurnTime) then
                                    players[get_var(i, "$n")].current_juggernaut = nil
                                    players[get_var(i, "$n")].swap_timer = 0
                                    rprint(i, "You're no longer the Juggernaut!")
                                    local x, y, z = GetCoords(i)
                                    death_location[i][1] = x
                                    death_location[i][2] = y
                                    death_location[i][3] = z
                                    delete_weapons_bool[i] = true
                                    death_bool[i] = true
                                    
                                    -- to do:
                                    -- If the player was in a vehicle when SwapRole() is called, they aren't re-entered into that vehicle.
                                    -- fix this.
                                    
                                    -- Alternatively: set vehicle.trigger flag | reset OnVehicleExit()
                                    
                                    execute_command("kill " .. i)
                                    players[get_var(i, "$n")].vehicle_trigger = true
                                    restore_inventory[i] = true
                                    SwapRole(tonumber(i))
                                end
                            end
                        end
                    end
                else
                    execute_command("s " .. i .. " " .. tonumber(default_running_speed))
                end
            end
        end
    end
    -- not enough players | nil juggernaut | restore inventory | reset nav markers
    if current_players == 1 then
        for n = 1, 1 do
            if player_present(n) then
                if (n == players[get_var(n, "$n")].current_juggernaut) then
                    execute_command("msg_prefix \"\"")
                    players[get_var(n, "$n")].current_juggernaut = nil
                    selection_bool = true
                    for iDel = 1,4 do execute_command("wdel " .. n) end
                    ResetNavMarker()
                    if not PlayerInVehicle(n) then 
                        say(n, "Not enough players! You're no longer the Juggernaut.")
                        say(n, "Restoring previous weapon loadout in " .. reset_delay .. " seconds!")
                        timer(1000 * reset_delay, "ResetPlayer", n)
                    else
                        say(n, "Not enough players! You're no longer the Juggernaut.")
                        say(n, "Restoring previous weapon loadout")
                        vehicle_check[n] = true
                    end
                    execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
                end
            end
        end
    end
    -- Juggernaut Health Regeneration handler
    for k = 1, current_players do
        if player_alive(k) then
            if (k == players[get_var(k, "$n")].current_juggernaut) then
                local player_object = get_dynamic_player(k)
                if (player_object ~= 0) then
                    if read_float(player_object + 0xE0) < 1 then
                        write_float(player_object + 0xE0, read_float(player_object + 0xE0) + juggernaut_health_increment)
                    end
                end
            end
        end
    end
    -- Timed Points Handler
    if (gamesettings["AliveTimer"] == true) then
        for l = 1, current_players do
            if player_present(l) then
                if (score_timer[l] ~= false and player_alive(l) == true) then
                    if (players[get_var(l, "$n")].current_juggernaut) then
                        players[get_var(l, "$n")].time_alive = players[get_var(l, "$n")].time_alive + 0.030
                        if (players[get_var(l, "$n")].time_alive >= math.floor(allocated_time)) then
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
                        clear_console(m)
                        for k, v in pairs(message_board) do
                            for j=1, #message_board do
                                if string.find(message_board[j], "$SERVER_NAME") then
                                    message_board[j] = string.gsub(message_board[j], "$SERVER_NAME", servername)
                                elseif string.find(message_board[j], "$PLAYER_NAME") then
                                    message_board[j] = string.gsub(message_board[j], "$PLAYER_NAME", get_var(m, "$name"))
                                end
                            end
                            rprint(m, "|" .. message_alignment .. " " .. v)
                        end
                        if players[get_var(m, "$n")].join_timer >= math.floor(message_duration) then
                            welcome_timer[m] = false
                            players[get_var(m, "$n")].join_timer = 0
                        end
                    else
                        clear_console(m)
                        welcome_timer[m] = true
                    end
                end
            end
        end
    end
end

-- This function handles primary, secondary, tertiary and quaternary weapon assignment
-- This function also sets player health & shield ratios and calls AssignGrenades()
function InventoryAssignment(player, x,y,z)
    -- Delete their current weapon loadout
    for x = 1,4 do execute_command("wdel " .. player) end
    for i = 1,2 do
        if weapons[i][3] == true then
            assign_weapon(spawn_object(weapons[i][1], weapons[i][2], x, y, z), player)
        end
    end
    timer(100, "AssignTertiaryQuaternary", player, x,y,z)
    AssignGrenades(player)
    if (gamesettings["GiveExtraHealth"] == true) then
        write_float(get_dynamic_player(player) + 0xE0, math.floor(tonumber(juggernaut_health)))
    end
    if (gamesettings["GiveOvershield"] == true) then
        write_float(get_dynamic_player(player) + 0xE4, math.floor(tonumber(juggernaut_shields)))
    end
    -- NESTED FUNCTION: Assigns tertiary and quaternary weapons to the designated player.
    function AssignTertiaryQuaternary(player, x,y,z)
        for i = 3,4 do
            if weapons[i][3] == true then
                assign_weapon(spawn_object(weapons[i][1], weapons[i][2], x, y, z), player)
            end
        end
    end
end

function RestoreWeapons(PlayerIndex)
    if player_alive(PlayerIndex) then
        for X = 1,4 do execute_command("wdel " .. PlayerIndex) end
        local x, y, z = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
        local inventory = player_equipment[get_var(PlayerIndex,"$n")]
        for k, weapon in pairs(inventory.loadout) do
            local saved_weapons = spawn_object("null","null", x, y, z + 0.3, 90, weapon.identifier)
            local weapon_object = get_object_memory(saved_weapons)
            -- primary loaded ammo
            write_word(weapon_object + 0x2B8, weapon.primary_loaded_ammo)
            -- primary reserve ammo
            write_word(weapon_object + 0x2B6, weapon.primary_reserve_ammo)
            -- secondary loaded ammo
            write_word(weapon_object + 0x2C6, weapon.secondary_loaded_ammo)
            -- secondary reserve ammo
            write_word(weapon_object + 0x2C8, weapon.secondary_reserve_ammo)
            -- battery age
            write_float(weapon_object + 0x240, weapon.battery)
            sync_ammo(saved_weapons)
            assign_weapon(saved_weapons, PlayerIndex)
            -- set health | frags | plasmas
            write_float(get_dynamic_player(PlayerIndex) + 0xE0, inventory.health)
            write_byte(get_dynamic_player(PlayerIndex) + 0x31E, inventory.frag_grenades)
            write_byte(get_dynamic_player(PlayerIndex) + 0x31F, inventory.plasma_grenades)
        end
    end
end

function AssignGrenades(PlayerIndex)
    if player_alive(PlayerIndex) then
        local player_object = get_dynamic_player(PlayerIndex)
        if (player_object ~= 0) then
            for k,v in pairs(map_settings) do
                if mapname == map_settings[k][1] then
                    if (gamesettings["AssignFragGrenades"] == true) then
                        write_word(player_object + 0x31E, map_settings[k][2])
                    end
                    if (gamesettings["AssignPlasmaGrenades"] == true) then
                        write_word(player_object + 0x31F, map_settings[k][3])
                    end
                    break
                end
            end
        end
    end
end

function SwapRole(exclude)
    execute_command("msg_prefix \"\"")
    local random_number = math.random(1, current_players)
    if random_number ~= tonumber(exclude) then
        if not player_alive(random_number) then
            rprint(random_number, "You will be selected as the Juggernaut when you respawn!")
            set_after_spawn[random_number] = true
        else
            assign_weapons[random_number] = true
            players[get_var(random_number, "$n")].current_juggernaut = (random_number)
            execute_command("s " .. random_number .. " :" .. tonumber(juggernaut_running_speed))
            SetNavMarker(random_number)
            AnnounceNewJuggernaut(random_number)
        end
    else
        if GetNewNumber(exclude) ~= exclude then
            if not player_alive(new_random_number) then
                rprint(new_random_number, "You will be selected as the Juggernaut when you respawn!")
                set_after_spawn[new_random_number] = true
            else
                assign_weapons[new_random_number] = true
                players[get_var(new_random_number, "$n")].current_juggernaut = (new_random_number)
                execute_command("s " .. new_random_number .. " :" .. tonumber(juggernaut_running_speed))
                SetNavMarker(new_random_number)
                AnnounceNewJuggernaut(new_random_number)
            end
        end
    end
    execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
end

-- This function calls itself until (new_number) no longer evaluates to (exclude)
-- exclude is the index id of the immediate previous juggernaut.
-- new_number is the randomly selected index id of the juggernaut to be.
function GetNewNumber(exclude)
    local new_number = math.random(1,current_players)
    if new_number == exclude then
        GetNewNumber(exclude)
    else
        new_random_number = new_number
        return new_number
    end
end

-- This function is called when there are not enough players for a juggernaut to be in play.
function ResetPlayer(player)
    -- to do:
    -- protect against the possibility that this player enters a vehicle after the (ResetPlayer) timer has begun - called from OnTick()
    local player = tonumber(player)
    local x, y, z = read_vector3d(get_dynamic_player(player) + 0x5C)
    death_location[player][1] = x
    death_location[player][2] = y
    death_location[player][3] = z
    restore_inventory[player] = true
    delete_weapons_bool[player] = true
    execute_command("kill " .. player)
    reset_bool[player] = true
    local m_player = get_player(player)
    if m_player ~= 0 then
        write_word(m_player + 0x88, to_real_index(player) + 10)
    end
end

-- This function is called any time a death occurs.
function OnPlayerDeath(PlayerIndex, KillerIndex)
    execute_command("msg_prefix \"\"")
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    local server = -1
    -- used to restore player inventory
    if (delete_weapons_bool[victim] == true) then
        delete_weapons_bool[victim] = false
        DeleteWeapons(tonumber(victim))
        destroy_object(read_dword(get_player(victim) + 0x34))
        write_dword(get_player(tonumber(victim)) + 0x2C, 0)
        execute_command("deaths " .. victim .. " -1")
    end
    -- prevent juggernaut from dropping weapons and grenades on death
    if (gamesettings["DeleteWeapons"] == true) then
        if (victim == players[get_var(victim, "$n")].current_juggernaut) then
            DeleteWeapons(tonumber(victim))
        end
    end
    -- killer is juggernaut | update kill statistics
    if (killer ~= server) then
        if (killer > 0) then
            if (killer == players[get_var(killer, "$n")].current_juggernaut) and (victim ~= killer) then
                players[get_var(killer, "$n")].kills = players[get_var(killer, "$n")].kills + 1
                rprint(killer, "|" .. Alignment .. "Kills as Juggernaut: " .. players[get_var(killer, "$n")].kills .. "/" ..tostring(killLimit))
            end
        end
    end
    -- victim was juggernaut | reset score timers
    if (victim == players[get_var(victim, "$n")].current_juggernaut) then
        score_timer[victim] = false
        players[get_var(victim, "$n")].time_alive = 0
    end
    -- killer is already juggernaut | update score with (general_points)
    if (killer ~= server) then
        if (killer > 0) then
            if (killer == players[get_var(killer, "$n")].current_juggernaut) then
                execute_command("score " .. killer .. " +" .. tostring(general_points))
                rprint(killer, "|" .. Alignment .. "+" .. tostring(general_points) .. " pts")
            end
        end
    end
    -- killer was server | reset nav markers
    if (killer == server) and (victim == players[get_var(victim, "$n")].current_juggernaut) then
        players[get_var(victim, "$n")].current_juggernaut = nil
        SwapRole(tonumber(victim))
        ResetNavMarker()
    end
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    if (current_players >= minimum_players) then
        if killer ~= server then
            for i = 1,current_players do
                -- someone is already the juggernaut
                if (killer > 0) and (i == players[get_var(i, "$n")].current_juggernaut) then
                    selection_bool = false
                    -- killer & victim not juggernaut | someone else is currently juggernaut
                    if (killer ~= players[get_var(killer, "$n")].current_juggernaut) and (victim ~= players[get_var(victim, "$n")].current_juggernaut) then
                    selection_bool = false
                        break
                    -- killer not juggernaut | victim is juggernaut | make killer new juggernaut | update score with (gotcha_points)
                    elseif (killer ~= players[get_var(killer, "$n")].current_juggernaut) and (victim == players[get_var(victim, "$n")].current_juggernaut) then
                        selection_bool = false
                        players[get_var(victim, "$n")].current_juggernaut = nil
                        ResetNavMarker()
                        SetNewJuggernaut(tonumber(killer), false, true)
                        break
                    end
                end
            end
        end
    end
    
    -- nobody is the juggernaut | make killer juggernaut | update score with (first_blood)
    if (killer ~= server) and (killer > 0) then
        if (killer ~= players[get_var(killer, "$n")].current_juggernaut) and (victim ~= players[get_var(victim, "$n")].current_juggernaut) and (killer ~= victim) then
            if selection_bool == true then
                selection_bool = false
                SetNewJuggernaut(tonumber(killer), true, false)
            end
        end
    end
    
    -- suicide | victim was juggernaut | Call SwapRole() or Ignore
    if (victim == killer) and (victim == players[get_var(victim, "$n")].current_juggernaut) then
        say(victim, "You are no longer the Juggernaut!")
        -- remove their juggernaut status
        players[get_var(victim, "$n")].current_juggernaut = nil
        -- reset nav markers
        ResetNavMarker()
        if (current_players >= turn_timer_min_players) then
            for i = 1, current_players do
                if i ~= victim then
                    say(i, get_var(victim, "$name") .. " committed suicide and is no longer the Juggernaut!")
                    say(i, "A new player will be selected to become the Juggernaut in " .. SuicideSelectDelay .. " seconds!")
                end
            end
            -- Call SwapRole() | Select someone else as the new Juggernaut
            timer(1000 * SuicideSelectDelay, "SwapRole", victim)
        else
            selection_bool = true
            for i = 1,current_players do
                if i ~= victim then 
                    say(i, get_var(victim, "$name") .. " committed suicide")
                end
            end
        end
    end
    -- squashed by vehicle | victim was juggernaut | Call SwapRole() or Ignore
    if (killer == 0) and (victim == players[get_var(victim, "$n")].current_juggernaut) then
        -- remove their juggernaut status
        players[get_var(victim, "$n")].current_juggernaut = nil
        say(victim, "You are no longer the Juggernaut!")
        -- reset nav markers
        ResetNavMarker()
        if (current_players >= turn_timer_min_players) then
            for i = 1, current_players do
                if i ~= victim then
                    selection_bool = false
                    say(i, get_var(victim, "$name") .. " died!")
                    say(i, "A new player will be selected to become the Juggernaut in " .. SuicideSelectDelay .. " seconds!")
                end
            end
            -- Call SwapRole() | Select someone else as the new Juggernaut
            timer(1000 * SuicideSelectDelay, "SwapRole", victim)
        else
            selection_bool = true
        end
    end
    
    -- general death messages --------------------------------------------------------------------------------------------------
    --suicide | victim was not juggernaut
    if (victim == killer) and (victim ~= players[get_var(victim, "$n")].current_juggernaut) then
        say_all(get_var(victim, "$name") .. " committed suicide")
    end
    
    -- pvp --
    for i = 1,current_players do
        if (killer > 0) and (victim ~= killer) then
            if i ~= victim and i ~= killer then
                say(i, get_var(victim, "$name") .. " was killed by " .. get_var(killer, "$name"))
            elseif i == victim and i ~= killer then
                say(i, "You were killed by " .. get_var(killer, "$name"))
            elseif i == killer and i ~= victim then
                say(i, "You killed " .. get_var(victim, "$name"))
            end
        end
    end
    
    if (killer == 0) and (victim ~= players[get_var(victim, "$n")].current_juggernaut) then
        say_all(get_var(victim, "$name") .. " was killed by a vehicle!")
    end
    
    -- killed by server, vehicle, glitch or unknown
    if (killer == nil) or (killer == -1) and not death_bool[victim] and not reset_bool[victim] then
        say_all(get_var(victim, "$name") .. " died")
    end
    
    -- end the game --
    if (killer ~= server) and (killer > 0) then
        if (killer == players[get_var(killer, "$n")].current_juggernaut) and (killer ~= victim) then
            local kills = tonumber(players[get_var(killer, "$n")].kills)
            if (kills >= tonumber(killLimit)) then
                execute_command("sv_map_next")
            end
        end
    end
    death_bool[victim] = false
    damage_applied[PlayerIndex] = 0
    execute_command("msg_prefix \"** "..SERVER_PREFIX.." ** \"")
end

-- This function is called when we need to set a new juggernaut manually and advance|update their score.
-- Vehicle flags are also handled by this function
function SetNewJuggernaut(player, update, advance)
    -- set new juggernaut
    players[get_var(player, "$n")].current_juggernaut = player
    -- set nav marker to that player
    SetNavMarker(tonumber(player))
    assign_weapons[player] = true
    if PlayerInVehicle(player) then
        players[get_var(player, "$n")].vehicle_trigger = true
    else
        players[get_var(player, "$n")].vehicle_trigger = false
    end
    execute_command("s " .. player .. " :" .. tonumber(juggernaut_running_speed))
    -- awarded because they were the first player to become juggernaut
    if (update == true) and (advance == false) then
        execute_command("score " .. player .. " +" .. tostring(first_blood))
        rprint(player, "|" .. Alignment .. "+" .. tostring(first_blood) .. " pts")
    -- awarded because they killed the juggernaut
    elseif (update == false) and (advance == true) then
        execute_command("score " .. player .. " +" .. tostring(gotcha_points))
        rprint(player, "|" .. Alignment .. "+" .. tostring(gotcha_points) .. " pts")
    end
    AnnounceNewJuggernaut(player)
end

function AnnounceNewJuggernaut(player)
    for i = 1, current_players do
        if i ~= player then
            say(i, string.gsub(JuggernautAssignMessage, "$NAME", get_var(player, "$name")))
        else
            say(player, "You're now the Juggernaut!")
        end
    end
end

-- This function is called when damage is applied to a player.
function OnDamageApplication(ReceiverIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if tonumber(CauserIndex) > 0 then 
        if (CauserIndex == players[get_var(CauserIndex, "$n")].current_juggernaut) then
            damage_applied[CauserIndex] = MetaID
            ------- MELEE --------------------------------------------------------
            if MetaID == MELEE_ASSAULT_RIFLE or
                MetaID == MELEE_ODDBALL or
                MetaID == MELEE_FLAG or
                MetaID == MELEE_FLAME_THROWER or
                MetaID == MELEE_NEEDLER or
                MetaID == MELEE_PISTOL or
                MetaID == MELEE_PLASMA_PISTOL or
                MetaID == MELEE_PLASMA_RIFLE or
                MetaID == MELEE_PLASMA_CANNON or
                MetaID == MELEE_ROCKET_LAUNCHER or
                MetaID == MELEE_SHOTGUN or
                MetaID == MELEE_SNIPER_RIFLE then
                damage_type[CauserIndex] = 1
            end
            ------- WEAPONS --------------------------------------------------------
            if MetaID == ASSAULT_RIFLE_BULLET or
                MetaID == FLAME_THROWER_EXPLOSION or
                MetaID == NEEDLER_DETONATION or
                MetaID == NEEDLER_EXPLOSION or
                MetaID == NEEDLER_IMPACT or
                MetaID == PISTOL_BULLET or
                MetaID == PLASMA_PISTOL_BOLT or
                MetaID == PLASMA_PISTOL_CHARGED or
                MetaID == PLASMA_CANNON_EXPLOSION or
                MetaID == ROCKET_EXPLOSION or
                MetaID == SHOTGUN_PELLET or
                MetaID == SNIPER_RIFLE_BULLET then
                damage_type[CauserIndex] = 2
            end
            ------- GRENADES --------------------------------------------------------
            if MetaID == FRAG_GRENADE_EXPLOSION then 
                damage_type[CauserIndex] = 3
            elseif MetaID == PLASMA_GRENADE_EXPLOSOIN then
                damage_type[CauserIndex] = 3.1
            elseif MetaID == PLASMA_GRENADE_ATTACHED then
                damage_type[CauserIndex] = 3.2
            end
            ------- VEHICLES --------------------------------------------------------
            if MetaID == VEHICLE_GHOST_BOLT or
                MetaID == VEHICLE_WARTHOG_BULLET or
                MetaID == VEHICLE_TANK_SHELL or
                MetaID == VEHICLE_TANK_BULLET or
                MetaID == VEHICLE_BANSHEE_BOLT or
                MetaID == VEHICLE_BANSHEE_FUEL_ROD or
                MetaID == VEHICLE_TURRET_BOLT then
                damage_type[CauserIndex] = 4
            end
            ------- VEHICLE COLLISION --------------------------------------------------------
            if MetaID == VEHICLE_COLLISION then
                damage_type[CauserIndex] = 5
            end
            return true, Damage * DamageMultiplierHandler(CauserIndex)
        end
    end
end

-- This function is called secondary to OnDamageApplication() and handles damage multiplier ratios.
function DamageMultiplierHandler(CauserIndex)
    local player_object = get_dynamic_player(CauserIndex)
    if player_object ~= 0 then
        for k,v in pairs(damage_multipliers[tonumber(CauserIndex)]) do
            if damage_type[CauserIndex] == 3 then
                -- frag grenade (explosion)
                if string.find("weapons\\frag grenade\\explosion", v[1]) then
                    damage_multiplier[CauserIndex] = v[2]
                end
            elseif damage_type[CauserIndex] == 3.1 then
                -- plasma grenade (explosion)
                if string.find("weapons\\plasma grenade\\explosion", v[1]) then
                    damage_multiplier[CauserIndex] = v[2]
                end
            elseif damage_type[CauserIndex] == 3.2 then
                -- plasma grenade (attached)
                if string.find("weapons\\plasma grenade\\attached", v[1]) then
                    damage_multiplier[CauserIndex] = v[2]
                end
            elseif (damage_type[CauserIndex] == 1) or (damage_type[CauserIndex] == 2) then
                local weapon_object = get_object_memory(read_dword(get_dynamic_player(CauserIndex) + 0x118))
                if weapon_object ~= 0 then
                    local weapon_name = read_string(read_dword(read_word(weapon_object) * 32 + 0x40440038))
                    if string.find(weapon_name, v[1]) then
                        if (damage_type[CauserIndex] == 1) then
                            -- weapon melee damage
                            damage_multiplier[CauserIndex] = v[2]
                        elseif (damage_type[CauserIndex] == 2) then
                            -- weapon projectile damage
                            damage_multiplier[CauserIndex] = v[3]
                        end
                    end
                end
            elseif (damage_type[CauserIndex] == 4) or (damage_type[CauserIndex] == 5) then
                local vehicle_object = get_object_memory(read_dword(player_object + 0x11c))
                local vehicle_tag = read_string(read_dword(read_word(vehicle_object) * 32 + 0x40440038))
                if vehicle_object ~= nil then
                    if string.find(vehicle_tag, v[1]) then
                        -- vehicle weapon projectile damage
                        if (damage_type[CauserIndex] == 4) then
                            damage_multiplier[CauserIndex] = v[2]
                        -- vehicle collision damage
                        elseif (damage_type[CauserIndex] == 5) then
                            damage_multiplier[CauserIndex] = v[3]
                        end
                    end
                end
            end
        end
    end
    damage_type[CauserIndex] = 0
    return tonumber(damage_multiplier[CauserIndex])
end

-- This function is called when a player has entered a vehicle.
function OnVehicleEntry(PlayerIndex)
    if players[get_var(PlayerIndex, "$n")].current_juggernaut then
        players[get_var(PlayerIndex, "$n")].vehicle_trigger = false
    end
end

-- This function is called when a player has exited a vehicle (called immediately after pressing action key and before exit animation has ended)
function OnVehicleExit(PlayerIndex)
    if players[get_var(PlayerIndex, "$n")].current_juggernaut then
        if players[get_var(PlayerIndex, "$n")].vehicle_trigger == true then
            players[get_var(PlayerIndex, "$n")].vehicle_trigger = false
            assign_weapons[PlayerIndex] = false
            if (player_alive(PlayerIndex)) then
                local x, y, z = GetCoords(PlayerIndex)
                timer(CheckVehicle(PlayerIndex), "InventoryAssignment", PlayerIndex, x,y,z + 0.3)
            end
        end
    end
    if (vehicle_check[PlayerIndex] == true) then
        vehicle_check[PlayerIndex] = false
        timer(CheckVehicle(PlayerIndex), "RestoreWeapons", PlayerIndex)
    end
end

-- This function is called secondary to OnVehicleExit() and returns a number value determined by the current vehicle they are in.
-- When the player presses their action key, OnVehicleExit() is called immediately, but the player hasn't "technically" left the vehicle until the exit animation has ended.
-- Therefore, we call RestoreWeapons() from OnVehicleExit() after the specified amount of time as pre-defined in CheckVehicle() has expired.
-- For example, if the player was in a ghost, RestoreWeapons() isn't called for 800ms...
-- (which is just the right amount of time required to call RestoreWeapons() before the player has "technically" left that vehicle).
function CheckVehicle(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if player_object ~= 0 then
        local vehicle_object = get_object_memory(read_dword(player_object + 0x11c))
        local vehicle_tag = read_string(read_dword(read_word(vehicle_object) * 32 + 0x40440038))
        if vehicle_object ~= nil then
            if vehicle_tag == "vehicles\\warthog\\mp_warthog" then
                assign_delay[PlayerIndex] = 1000
            elseif vehicle_tag == "vehicles\\rwarthog\\rwarthog" then
                assign_delay[PlayerIndex] = 1000 * 1.1
            elseif vehicle_tag == "vehicles\\scorpion\\scorpion_mp" then
                assign_delay[PlayerIndex] = 1000 * 2
            elseif vehicle_tag == "vehicles\\ghost\\ghost_mp" then
                assign_delay[PlayerIndex] = 800
            elseif vehicle_tag == "vehicles\\banshee\\banshee_mp" then
                assign_delay[PlayerIndex] = 1000 * 1.1
            elseif vehicle_tag == "vehicles\\c gun turret\\c gun turret_mp" then
                assign_delay[PlayerIndex] = 1000 * 1.1
            else
                assign_delay[PlayerIndex] = 1000 * 2
            end
        end
    end
    return tonumber(assign_delay[PlayerIndex])
end

function DeleteWeapons(PlayerIndex)
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

-- This function is called any time we need to set the nav markers
function SetNavMarker(Juggernaut)
    for i = 1, 16 do
        if player_present(i) then
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

-- This function is called any time we need to reset the nav markers
function ResetNavMarker()
    for i = 1, current_players do
        if player_present(i) then
            local m_player = get_player(i)
            local player = to_real_index(i)
            if m_player ~= 0 then
                if i ~= nil then
                    write_word(m_player + 0x88, player + 10)
                end
            end
        end
    end
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

function GetCoords(PlayerIndex)
    local player = get_dynamic_player(PlayerIndex)
    if (player ~= 0) then
        local posX, posY, posZ = read_vector3d(player + 0x5C)
        local vehicle = get_object_memory(read_dword(player + 0x11C))
        if (vehicle ~= 0 and vehicle ~= nil) then
            local vehiPosX, vehiPosY, vehiPosZ = read_vector3d(vehicle + 0x5C)
            posX = posX + vehiPosX
            posY = posY + vehiPosY
            posZ = posZ + vehiPosZ
        end
        return round(posX, 2), round(posY, 2), round(posZ, 2)
    end
    return nil
end

-- This function is called from GetCoords() and rounds a number to the given number of decimal places.
function round(pos, places)
  local mult = 10^(places or 0)
  return math.floor(pos * mult + 0.5) / mult
end

function clear_console(PlayerIndex)
    for i = 1, 30 do
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

-- For debugging (not currently used)
function secondsToTime(seconds, places)
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60
    if places == 2 then
        return minutes, seconds
    end
end

function checkmap()
    local bool = nil
    for k,v in pairs(map_settings) do
        if mapname == map_settings[k][1] then
            bool = true
            break
        else
            bool = false
        end
    end
    return bool
end

function CheckType()
    local type_is_ctf = get_var(1, "$gt") == "ctf"
    local type_is_koth = get_var(1, "$gt") == "koth"
    local type_is_oddball = get_var(1, "$gt") == "oddball"
    local type_is_race = get_var(1, "$gt") == "race"
    if (type_is_ctf) or (type_is_koth) or (type_is_oddball) or (type_is_race) then
        unregister_callback(cb['EVENT_DIE'])
        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_LEAVE'])
        unregister_callback(cb['EVENT_SPAWN'])
        unregister_callback(cb['EVENT_GAME_END'])
        unregister_callback(cb['EVENT_PRESPAWN'])
        unregister_callback(cb['EVENT_GAME_START'])
        unregister_callback(cb['EVENT_VEHICLE_EXIT'])
        unregister_callback(cb['EVENT_VEHICLE_ENTER'])
        Error = "Error: [juggernaut.lua] doesn't support CTF, KOTH, ODDBALL, or RACE"
        cprint(Error, 4 + 8)
        execute_command("log_note \"" .. Error .. "\"")
    end
    if (get_var(1, "$gt") == "slayer") then
        if (checkmap() == false) then
            unregister_callback(cb['EVENT_DIE'])
            unregister_callback(cb['EVENT_TICK'])
            unregister_callback(cb['EVENT_JOIN'])
            unregister_callback(cb['EVENT_LEAVE'])
            unregister_callback(cb['EVENT_SPAWN'])
            unregister_callback(cb['EVENT_GAME_END'])
            unregister_callback(cb['EVENT_PRESPAWN'])
            unregister_callback(cb['EVENT_GAME_START'])
            unregister_callback(cb['EVENT_VEHICLE_EXIT'])
            unregister_callback(cb['EVENT_VEHICLE_ENTER'])
            Error = "Error: [juggernaut.lua] does not support the map " .. mapname .. ". Script cannot be used!"
            cprint(Error, 4 + 8)
            execute_command("log_note \"" .. Error .. "\"")
        else
            LoadItems()
        end
    end
end

function LoadItems()
    if get_var(0, "$gt") ~= "n/a" then
        -- Melee --
        MELEE_FLAG = TagInfo("jpt!", "weapons\\flag\\melee")
        MELEE_ODDBALL = TagInfo("jpt!", "weapons\\ball\\melee")
        MELEE_PISTOL = TagInfo("jpt!", "weapons\\pistol\\melee")
        MELEE_NEEDLER = TagInfo("jpt!", "weapons\\needler\\melee")
        MELEE_SHOTGUN = TagInfo("jpt!", "weapons\\shotgun\\melee")
        MELEE_PLASMA_RIFLE = TagInfo("jpt!", "weapons\\plasma rifle\\melee")
        MELEE_SNIPER_RIFLE = TagInfo("jpt!", "weapons\\sniper rifle\\melee")
        MELEE_FLAME_THROWER = TagInfo("jpt!", "weapons\\flamethrower\\melee")
        MELEE_PLASMA_PISTOL = TagInfo("jpt!", "weapons\\plasma pistol\\melee")
        MELEE_ASSAULT_RIFLE = TagInfo("jpt!", "weapons\\assault rifle\\melee")
        MELEE_ROCKET_LAUNCHER = TagInfo("jpt!", "weapons\\rocket launcher\\melee")
        MELEE_PLASMA_CANNON = TagInfo("jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_melee")
        
        -- Grenades Explosion/Attached --
        FRAG_GRENADE_EXPLOSION = TagInfo("jpt!", "weapons\\frag grenade\\explosion")
        PLASMA_GRENADE_ATTACHED = TagInfo("jpt!", "weapons\\plasma grenade\\attached")
        PLASMA_GRENADE_EXPLOSOIN = TagInfo("jpt!", "weapons\\plasma grenade\\explosion")
        
        -- Vehicles --
        VEHICLE_GHOST_BOLT = TagInfo("jpt!", "vehicles\\ghost\\ghost bolt")
        VEHICLE_TANK_BULLET = TagInfo("jpt!", "vehicles\\scorpion\\bullet")
        VEHICLE_WARTHOG_BULLET = TagInfo("proj", "vehicles\\warthog\\bullet")
        VEHICLE_TANK_SHELL = TagInfo("jpt!", "vehicles\\scorpion\\tank shell")
        VEHICLE_TURRET_BOLT = TagInfo("jpt!", "vehicles\\c gun turret\\mp bolt")
        VEHICLE_BANSHEE_BOLT = TagInfo("jpt!", "vehicles\\banshee\\banshee bolt")
        VEHICLE_BANSHEE_FUEL_ROD = TagInfo("jpt!", "vehicles\\banshee\\mp_banshee fuel rod")
        VEHICLE_COLLISION = TagInfo("jpt!", "globals\\vehicle_collision")
        
        -- weapon projectiles --
        ASSAULT_RIFLE_BULLET = TagInfo("jpt!", "weapons\\assault rifle\\bullet")
        FLAME_THROWER_EXPLOSION = TagInfo("jpt!", "weapons\\flamethrower\\explosion")
        NEEDLER_DETONATION = TagInfo("jpt!", "weapons\\needler\\detonation damage")
        NEEDLER_EXPLOSION = TagInfo("jpt!", "weapons\\needler\\explosion")
        NEEDLER_IMPACT = TagInfo("jpt!", "weapons\\needler\\impact damage")
        PISTOL_BULLET = TagInfo("jpt!", "weapons\\pistol\\bullet")
        PLASMA_PISTOL_BOLT = TagInfo("jpt!", "weapons\\plasma pistol\\bolt")
        PLASMA_PISTOL_CHARGED = TagInfo("jpt!", "weapons\\plasma rifle\\charged bolt")
        PLASMA_RIFLE_BOLT = TagInfo("jpt!", "weapons\\plasma rifle\\bolt")
        PLASMA_CANNON_EXPLOSION = TagInfo("jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion")
        ROCKET_EXPLOSION = TagInfo("jpt!", "weapons\\rocket launcher\\explosion")
        SHOTGUN_PELLET = TagInfo("jpt!", "weapons\\shotgun\\pellet")
        SNIPER_RIFLE_BULLET = TagInfo("jpt!", "weapons\\sniper rifle\\sniper bullet")
    end
end

function TagInfo(obj_type, obj_name)
    local tag_id = lookup_tag(obj_type, obj_name)
    return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end

--[[
--=====================================================================================================--
Script Name: Battle Royale (beta v1.0), for SAPP (PC & CE)
Description: N/A

[!] NOT READY FOR DOWNLOAD

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local boundry = { }

-- ==== Battle Royale Configuration [starts] ==== --

-- Players needed to start the game:
local players_needed = 1

-- Players will be auto-killed if Out Of Bounds for this many seconds:
local time_until_kill = 5

-- When enough players are present, the game will start in this many seconds:
local gamestart_delay = 10

-- Several functions temporarily remove the "** SERVER **" prefix when certain messages are broadcast.
-- The prefix will be restored to 'server_prefix' when the relay has finished.
local server_prefix = "**LNZ**"

boundry.maps = {
    -- IMPORTANT: (1 world unit = 10 feet or ~3.048 meters)

    ["timberland"] = {
        -- Boundry: x,y,z, Min Size, Max Size:
        1.250, -1.487, -21.264, 100, 4500,
        -- End the game this many minutes after the boundry reaches its smallest possible size of 'Min Size':
        extra_time = 2,
        -- How often does the Boundry reduce in size (in seconds):
        duration = 5,
        -- How many world units does the Boundry reduce in size:
        shrink_amount = 500,
    },
    ["carousel"] = {
        0.012, -0.029, -0.856, 30, 270,
        extra_time = 2, duration = 30, shrink_amount = 30,
    },
    ["ratrace"] = {
        8.340, -10.787, 0.222, 50, 415,
        extra_time = 2, duration = 30, shrink_amount = 50,
    },
    ["sidewinder"] = {
        2.051, 55.220, -2.801, 150, 5500,
        extra_time = 2, duration = 25, shrink_amount = 50,
    },
    ["beavercreek"] = {
        14.015, 14.238, -0.911, 10, 415,
        extra_time = 2, duration = 30, shrink_amount = 50,
    },
    ["dangercanyon"] = {
        -0.477, 55.331, 0.239, 60, 3600,
        extra_time = 2, duration = 10, shrink_amount = 500,
    },
    ["bloodgulch"] = {
        65.749, -120.409, 0.118, 30, 7100,
        extra_time = 2, duration = 30, shrink_amount = 700,
    },
    ["boardingaction"] = {
        18.301, -0.573, 0.420, 30, 4500,
        extra_time = 2, duration = 3, shrink_amount = 500,
    },
    ["gephyrophobia"] = {
        26.783, -74.000, -20.316, 40, 6200,
        extra_time = 2, duration = 20, shrink_amount = 500,
    },
    ["deathisland"] = {
        -30.282, 31.312, 16.601, 30, 5000,
        extra_time = 2, duration = 25, shrink_amount = 500,
    },
    ["icefields"] = {
        -26.032, 32.365, 9.007, 30, 7500,
        extra_time = 2, duration = 30, shrink_amount = 500,
    },
    ["infinity"] = {
        9.631, -64.030, 7.776, 100, 11500,
        extra_time = 2, duration = 30, shrink_amount = 1000,
    },
    ["hangemhigh"] = {
        21.020, -4.632, -4.229, 10, 605,
        extra_time = 2, duration = 30, shrink_amount = 50,
    },
    ["damnation"] = {
        6.298, 0.047, 3.400, 15, 600,
        extra_time = 2, duration = 15, shrink_amount = 50,
    },
    ["putput"] = {
        -3.751, -20.800, 0.902, 15, 1600,
        extra_time = 2, duration = 30, shrink_amount = 100,
    },
    ["prisoner"] = {
        0.902, 0.088, 1.392, 15, 400,
        extra_time = 2, duration = 30, shrink_amount = 50,
    },
    ["wizard"] = {
        -5.035, -5.064, -2.750, 20, 350,
        extra_time = 2, duration = 15, shrink_amount = 30,
    },
    ["longest"] = {
        -0.840, -14.540, 2.410, 20, 200,
        extra_time = 2, duration = 30, shrink_amount = 50,
    },
}
-- ==== Battle Royale Configuration [ends] ==== --

local bX, bY, bZ, bR
local min_size, max_size, extra_time, shrink_amount
local start_trigger, game_in_progress, game_time = true, false, 0
local monitor_coords
local time_scale = 0.030

local console_paused, paused = { }, { }
local out_of_bounds = { }

local last_man_standing = { }
last_man_standing.count = 0
last_man_standing.player = nil

local spectator, health_trigger, health, health_bool = { }, { }, { }, { }
local zone_transition = { }

local gamestart_countdown, init_countdown
local init_victory_timer, victory_timer = false, 0

local globals = nil
local red_flag, blue_flag, game_over
local kill_message_addresss, originl_kill_message
local floor, format = math.floor, string.format
local gmatch, sub = string.gmatch, string.sub

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    local gp = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if (gp == 3) then
        return
    end
    globals = read_dword(gp)
    
    kill_message_addresss = sig_scan("8B42348A8C28D500000084C9") + 3
    originl_kill_message = read_dword(kill_message_addresss)

    safe_write(true)
    write_dword(kill_message_addresss, 0x03EB01B1)
    safe_write(false)
end

function OnScriptUnload()
    safe_write(true)
    write_dword(kill_message_addresss, originl_kill_message)
    safe_write(false)
end

local function set(reset_scores)
    for i = 1, 16 do
        if player_present(i) then
            paused[i] = paused[i] or { }
            paused[i].start, paused[i].timer = false, 0

            spectator[i] = { }
            spectator[i].enabled, spectator[i].timer = false, 0

            zone_transition[i] = false

            -- Ensure all players have full health
            execute_command("hp " .. i .. " 1")
            health_trigger[i] = 0
            health_bool[i] = false
            health[i] = get_var(i, "$hp")

            if (reset_scores) then
                execute_command("score " .. i .. " 0")
                execute_command("kills " .. i .. " 0")
                execute_command("assists " .. i .. " 0")
                execute_command("deaths " .. i .. " 0")
            end
        end
    end
end

-- Initialize start up parameters:
local function init_params(reset)
    local mapname = get_var(0, "$map")
    local coords = boundry.maps[mapname]
    if (coords ~= nil) then
    
        -- Declare boundry Minimum/Maximum size
        min_size, max_size = coords[4], coords[5]

        -- Init Boundry coordinates and Radius
        bX, bY, bZ, bR = coords[1], coords[2], coords[3], coords[5]

        -- Declare boundry reduction rate/size
        shrink_duration, shrink_amount = coords.duration, coords.shrink_amount

        -- Extra time allocated when the boundry reaches its smallest possible size:
        extra_time = (coords.extra_time * 60)

        -- Calculated total game time:
        game_time = (shrink_duration * (max_size / shrink_amount))
        game_time = (game_time + extra_time)

        -- Set initial timers to ZERO.
        game_timer = 0
        reduction_timer = 0
        boundry_timer = 0

        -- Init boundry checker:
        monitor_coords = true

        if (reset) then            
            set(false)
            stopTimer()
            last_man_standing.count = 0
            last_man_standing.player = nil
            unregister_callback(cb['EVENT_DIE'])
            unregister_callback(cb['EVENT_TICK'])
            unregister_callback(cb['EVENT_CHAT'])
            unregister_callback(cb['EVENT_COMMAND'])
            unregister_callback(cb['EVENT_GAME_END'])
            unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])
        else
            set(true)
            startTimer()
            -- Register hooks into SAPP Events:
            register_callback(cb["EVENT_TICK"], "OnTick")
            register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
            register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
            register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
        end
    end
end

function OnGameStart()
    game_over = false
    red_flag, blue_flag = read_dword(globals + 0x8), read_dword(globals + 0xC)
end

function OnGameEnd()
    game_over = true
end

-- Receives a string and executes SAPP function 'say_all' without the **SERVER** prefix.
-- Restores the prefix when relay is done.
local SayAll = function(Message)
    if (Message) then
        execute_command("msg_prefix \"\"")
        say_all(Message)
        execute_command("msg_prefix \" " .. server_prefix .. "\"")
    end
end

-- This function returns the total number of players currently online.
local player_count = function()
    return tonumber(get_var(0, "$pn"))
end

function OnPlayerConnect(PlayerIndex)
    local p = tonumber(PlayerIndex)

    local enough_players = (player_count() >= players_needed)

    last_man_standing.count = last_man_standing.count + 1

    local function player_setup(player)
        console_paused[player] = false

        out_of_bounds[player] = { }
        out_of_bounds[player].yes, out_of_bounds[player].timer = false, 0

        paused[player] = { }
        paused[player].start, paused[player].timer, paused[player].duration = false, 0, 0

        spectator[player] = { }
        spectator[player].enabled, spectator[player].timer = false, 0
    end

    if (start_trigger) and (enough_players) then
        start_trigger = false
        
        -- Initialize game parameters:
        init_params(false)

        -- Setup player parameters:
        player_setup(p)
        
    elseif (game_in_progress and enough_players) or not (enough_players) then
        player_setup(p)
    end
end

function OnPlayerDisconnect(PlayerIndex)
    local p = tonumber(PlayerIndex)
    last_man_standing.count = last_man_standing.count - 1

    local count = last_man_standing.count
    spectator[p] = nil

    if (count < 1) then
        -- Initialize game parameters:
        init_params(true)
    elseif (count == 1) then
        for i = 1, 16 do
            if player_present(i) and (tonumber(i) ~= p) then
                last_man_standing.player = tonumber(i)
            end
        end
    end
end

function boundry:shrink()
    if (bR ~= nil) then
        bR = (bR - shrink_amount)
        if (bR < min_size) then
            bR = min_size
            boundry_timer = nil
            SayAll("BOUNDRY IS NOW AT ITS SMALLEST POSSIBLE SIZE!", 4 + 8)
        else
            SayAll("[ BOUNDRY REDUCTION ] Radius now (" .. bR .. ") world units", 4 + 8)
        end
    end
end

local function reduceHealth(p, bool)

    if not (health_bool[p]) then
        health_bool[p] = true
        health[p] = get_var(p, "$hp")
    end

    if not (bool) then
        health_trigger[p] = health_trigger[p] + time_scale

        if (zone_transition[p]) then
            zone_transition[p] = false
            local old_health = health[p]
            execute_command("hp " .. p .. " " .. old_health)
        end

        if (health_trigger[p] ~= nil and health_trigger[p] >= 2) then
            health_trigger[p] = 0

            local new_health = (get_var(p, "$hp") - 0.10)
            execute_command("hp " .. p .. " " .. new_health)

            local current_health = tonumber(get_var(p, "$hp"))
            if (current_health <= 0) then
                killSilently(p)
                spectator[p].enabled = true
                last_man_standing.count = last_man_standing.count - 1
                local name = get_var(p, "$name")
                SayAll(name .. " has perished! " .. last_man_standing.count .. " players remain.")
            end
        end
    else
        execute_command("hp " .. p .. " 0.10")
    end
end

local function restoreHealth(p)
    health_trigger[p] = 0
    if (health_bool[p]) then
        health_bool[p] = false
        local old_health = health[p]
        execute_command("hp " .. p .. " " .. old_health)
    end
end

function boundry:inSphere(p, px, py, pz, x, y, z, r)
    local coords = ((px - x) ^ 2 + (py - y) ^ 2 + (pz - z) ^ 2)
    if (coords < r) then
        console_paused[p], out_of_bounds[p].yes = false, false
        restoreHealth(p)
        return true
    elseif (coords >= r + 1) and (coords < max_size) then
        console_paused[p] = false
        reduceHealth(p, false)
        return false
    elseif (coords > max_size) and not (console_paused[p]) then
        zone_transition[p] = true
        console_paused[p] = true
        reduceHealth(p, true)
        return false
    end
end

function checkForPause()
    for i = 1, 16 do
        if player_present(i) then
            if (paused[i] ~= nil) then
                if (paused[i].start) then
                    paused[i].timer = paused[i].timer + time_scale
                    if (paused[i].timer >= paused[i].duration) then
                        paused[i].start, paused[i].timer = false, 0
                        cls(i, 25)
                    end
                end
            end
        end
    end
end

local function hide_player(p, coords)
    local xOff, yOff, zOff = 1000, 1000, 1000
    write_float(get_player(p) + 0x100, coords.z - zOff)
    write_float(get_player(p) + 0xF8, coords.x - xOff)
    write_float(get_player(p) + 0xFC, coords.y - yOff)
end

local function DispayHUD(params)

    local player = params.player
    local boundry_timer = params.boundry_timer
    local shrink_time_msg = params.shrink_time_msg
    local until_next_shrink = params.until_next_shrink
    local time_remaining = params.time_remaining
    local _extra_time = params.extra_time
    local time_stamp = params.time_stamp

    if (time_remaining ~= nil) then
        if (boundry_timer ~= nil) then
            shrink_time_msg = " | Time Until Boundry Reduction: " .. until_next_shrink
        else
            shrink_time_msg = ""
        end

        local header, send_timestamp = ""
        if (time_remaining >= _extra_time) then
            send_timestamp = true
            header = "Game Time Remaining: " .. time_stamp
        elseif (time_remaining <= _extra_time) and (time_remaining > 0) then
            send_timestamp = true
            header = "FINAL MINUTES: " .. time_stamp
        elseif (time_remaining <= 0) then
            send_timestamp = false
            game_timer = nil
            monitor_coords = false
            GameOver()
        end

        if (send_timestamp) and (monitor_coords) then
            if not (spectator[player].enabled) then
                out_of_bounds[player].timer = 0
            end
            rprint(player, "|c" .. header .. shrink_time_msg)
        end
    end
end

function endGameCheck()
    if (last_man_standing.count <= 1) then
        GameOver()
    end
end

function OnTick()
    if (init_countdown) then
        GameStartCountdown()
    elseif not (init_countdown) and not (init_victory_timer) then

        --endGameCheck()

        local time_stamp, until_next_shrink
        local time_remaining

        if (game_timer ~= nil) then
            game_timer = game_timer + time_scale

            local time = ((game_time + time_scale) - (game_timer))
            time_remaining = time

            local GTmins, GTsecs = select(1, secondsToTime(time, true)), select(2, secondsToTime(time, true))
            time_stamp = (GTmins .. ":" .. GTsecs)

            if (reduction_timer ~= nil) then
                reduction_timer = reduction_timer + time_scale

                local time = ((shrink_duration + time_scale) - (reduction_timer))
                if (time <= 0) then
                    reduction_timer = 0
                end

                local Smins, Ssecs = select(1, secondsToTime(time, true)), select(2, secondsToTime(time, true))
                until_next_shrink = (Smins .. ":" .. Ssecs)
            end
        end

        -- BOUNDRY REDUCTION TIMER:
        if (boundry_timer ~= nil) then
            boundry_timer = boundry_timer + time_scale
            if (boundry_timer >= (shrink_duration + time_scale)) then
                if (bR > min_size and bR <= max_size) then
                    boundry_timer = 0
                    boundry:shrink()
                end
            end
        end

        for i = 1, 16 do
            if player_present(i) then
                local player_object = get_dynamic_player(i)
                if (player_object ~= 0) then

                    checkForPause()

                    if (not paused[i].start) then
                        cls(i, 25)
                    end

                    local p = { }
                    p.player = tonumber(i)
                    p.boundry_timer = boundry_timer
                    p.shrink_time_msg = shrink_time_msg
                    p.until_next_shrink = until_next_shrink
                    p.time_remaining = time_remaining
                    p.extra_time, p.time_stamp = extra_time, time_stamp

                    if (spectator[i] ~= nil) and (spectator[i].enabled) then
                        local count = last_man_standing.count
                        rprint(i, "|cYOU ARE IN SPECTATOR MODE")
                        rprint(i, "|c--- Players Remaining --- ")
                        rprint(i, "|c" .. count)
                        
                        DispayHUD(p)

                        local coords = getXYZ(i)
                        if (coords) then
                            execute_command("camo " .. i)
                            hide_player(i, coords)
                        end

                    elseif (spectator[i] ~= nil) and not (spectator[i].eanbled) then

                        local px, py, pz = read_vector3d(player_object + 0x5c)
                        if boundry:inSphere(i, px, py, pz, bX, bY, bZ, bR) and (monitor_coords) then
                            if (not console_paused[i]) and (not paused[i].start) then

                                local rUnits = ((px - bX) ^ 2 + (py - bY) ^ 2 + (pz - bZ) ^ 2)
                                rprint(i, "|c--  I N S I D E   S A F E   Z O N E --")
                                rprint(i, "|cUNITS FROM CENTER: " .. floor(rUnits) .. "/" .. bR .. " (Final Size: " .. min_size .. " | Reduction Rate: " .. shrink_amount .. ")")
                                DispayHUD(p)
                            end

                        elseif (monitor_coords) then
                            if (not console_paused[i]) and (not paused[i].start) then

                                rprint(i, "|cWARNING:")
                                rprint(i, "|cYOU ARE OUTSIDE THE BOUNDRY!")

                                local rUnits = ((px - bX) ^ 2 + (py - bY) ^ 2 + (pz - bZ) ^ 2)
                                rprint(i, "|cUNITS FROM CENTER: " .. floor(rUnits) .. "/" .. bR)
                                out_of_bounds[i].yes = true

                            elseif (not paused[i].start) and console_paused[i] then

                                out_of_bounds[i].yes = true
                                out_of_bounds[i].timer = out_of_bounds[i].timer + time_scale

                                local _time_remaining = ((time_until_kill + 1) - out_of_bounds[i].timer)
                                local seconds = select(2, secondsToTime(_time_remaining, true))

                                rprint(i, "|c--------- WARNING ---------")
                                rprint(i, "|cYOU ARE LEAVING THE COMBAT AREA!")
                                rprint(i, "|cRETURN NOW OR YOU WILL BE SHOT!")
                                rprint(i, "|c(" .. seconds .. ")")
                                if (out_of_bounds[i].timer >= time_until_kill) then
                                    out_of_bounds[i].timer = 0
                                    killSilently(i)
                                end
                            end
                            execute_command("camo " .. i .. " 1")
                        end
                    end
                end
            end
        end
    elseif (init_victory_timer) then
        victory_timer = victory_timer + time_scale
        if (victory_timer < 5) then
            for i = 1, 16 do
                if player_present(i) then
                    local last_man = last_man_standing.player
                    if (last_man ~= nil) then
                        cls(i, 25)
                        if tonumber(i) == last_man then
                            rprint(i, "|c ----- V I C T O R Y -----")
                            rprint(i, "|cY O U   W O N   T H E   G A M E!")
                        else
                            rprint(i, "|cBetter Luck Next Time!")
                            rprint(i, "|c________________________________________")
                            rprint(i, "|c" .. get_var(last_man, "$name") .. " won the game!")
                        end
                        for _ = 1, 7 do
                            rprint(i, " ")
                        end
                    end
                end
            end
        else
            init_params(true)
            init_victory_timer, victory_timer = false, 0
        end
    end
end

local function getKDR(p)
    local kills, deaths = get_var(p, "$kills"), get_var(p, "$deaths")
    local kdr = (kills / deaths)
    return kdr
end

local function saveKDRs()
    local kdr_table = { }
    for i = 1, 16 do
        if player_present(i) then
            getKDR(i)
            kdr_table[#kdr_table + 1] = kdr
        end
    end
    table.sort(kdr_table)
    return kdr_table
end

local function bestKDR()
    local KDRTab = saveKDRs()
    local highest_score = tonumber(KDRTab[#KDRTab])

    for i = 1, 16 do
        if player_present(i) then
            local kdr = getKDR(i)
            if (kdr == highest_score) then
                last_man_standing.player = tonumber(i)
            end
        end
    end
end

function GameOver()
    local scores = { }

    local function end_game()
        init_victory_timer = true
        victory_timer = victory_timer or 0
        execute_command('sv_map_next')
    end

    game_timer = nil
    boundry_timer = nil
    monitor_coords = nil
    
    start_trigger, game_in_progress, game_time = true, false, 0
    
    cls(0, 25, true, "rcon")

    -- Time ran out - Calculate best score:
    if (game_timer == nil) then
        for i = 1, 16 do
            if player_present(i) then
                local score = tonumber(get_var(i, '$score'))
                if (score > 0) then
                    scores[#scores + 1] = score
                end
            end
        end

        -- Check who has the highest score:
        if (#scores >= 1) then
            table.sort(scores)
            local highest_score = tonumber(scores[#scores])
            local count = 0
            for i = 1, 16 do
                if player_present(i) then
                    local score = tonumber(get_var(i, '$score'))
                    if (score == highest_score) then
                        last_man_standing.player = tonumber(i)
                        count = count + 1
                    end
                end
            end
            -- Only one player has the highest score (no duplicate scores)
            if (count == 1) then
                end_game()
                -- More than one player have the same score. Calcuate who has the best KDR instead:
            elseif (count > 1) then
                bestKDR()
                end_game()
            end
        else
            -- No players have any score points. Calcuate who has the best KDR instead:
            bestKDR()
            end_game()
        end
    else
        end_game()
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    local v_name, k_name = get_var(victim, "$name"), get_var(killer, "$name")
    
    if (killer > 0) then

        last_man_standing.count = last_man_standing.count - 1
        spectator[victim].enabled = true
        
        local response
        
        -- More than 1 player remaining:
        if (last_man_standing.count > 1) then
            response = true
        -- Killer is the Victor. End the Game.
        elseif (last_man_standing.count <= 1) then
            response = false
            last_man_standing.player = killer
        end

        -- PvP:
        if (killer ~= victim) and (response) then
            SayAll(v_name .. " was killed by " .. k_name .. ". " .. last_man_standing.count .. " players remain!")
        -- Suicide:
        elseif (victim == killer) and (response) then
            SayAll(v_name .. " committed suicide. " .. last_man_standing.count .. " players remain!")
        end    

    elseif (killer == -1) or (killer == nil) or (killer == 0) then
        SayAll(v_name .. " died")
    end
    
end

function cls(PlayerIndex, count, clear_chat, type)
    count = count or 25
    if (PlayerIndex) and not (clear_chat) then
        for _ = 1, count do
            rprint(PlayerIndex, " ")
        end
    elseif (clear_chat) then
        if (type == "chat") then
            SayAll(" ")
        elseif (type == "rcon") then
            for i = 1, 16 do
                if player_present(i) then
                    for _ = 1, count do
                        rprint(i, " ")
                    end
                end
            end
        end
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    local msg = stringSplit(Message)
    local p = tonumber(PlayerIndex)

    if (#msg == 0) then
        return false
    elseif (sub(msg[1], 1, 1) == "/" or sub(msg[1], 1, 1) == "\\") then
        if (paused[p].start ~= true) then
            cls(p, 25)
            paused[p].duration, paused[p].start = 3, true
        end
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local msg = stringSplit(Command)
    local p = tonumber(PlayerIndex)

    if (#msg == 0) then
        return false
    elseif (paused[p].start ~= true) then
        cls(p, 25)
        paused[p].duration, paused[p].start = 3, true
    end
end

function secondsToTime(seconds, bool)
    local seconds = tonumber(seconds)
    if (seconds <= 0) and (bool) then
        return "00", "00";
    else
        hours = format("%02.f", floor(seconds / 3600));
        mins = format("%02.f", floor(seconds / 60 - (hours * 60)));
        secs = format("%02.f", floor(seconds - hours * 3600 - mins * 60));
        return mins, secs
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    local shooter = tonumber(CauserIndex)
    local victim = tonumber(PlayerIndex)
    if (shooter > 0 and shooter ~= victim) then
        if (out_of_bounds[shooter].yes) or (spectator[shooter].enabled) or (spectator[victim].enabled) then
            return false
        end
    end
end

function DestroyObject(object)
    if (object) then
        destroy_object(object)
    end
end

local function DeleteWeapons(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        write_word(player_object + 0x31E, 0)
        write_word(player_object + 0x31F, 0)
        local weaponId = read_dword(player_object + 0x118)
        if (weaponId ~= 0) then
            for j = 0, 3 do
                local weapon = read_dword(player_object + 0x2F8 + 4 * j)
                if (weapon ~= red_flag) and (weapon ~= blue_flag) then
                    DestroyObject(weapon)
                end
            end
        end
        return true
    end
end

function killSilently(PlayerIndex)
    if DeleteWeapons(PlayerIndex) then
        execute_command("kill " .. tonumber(PlayerIndex))
        write_dword(get_player(PlayerIndex) + 0x2C, 0 * 33)
        -- Deduct one death
        local deaths = tonumber(get_var(PlayerIndex, "$deaths"))
        execute_command("deaths " .. tonumber(PlayerIndex) .. " " .. deaths - 1)
    end
end

function GameStartCountdown()
    if (gamestart_countdown ~= nil) then
        gamestart_countdown = gamestart_countdown + time_scale
        local gamestart_delay = gamestart_delay + 1
        local time = ((gamestart_delay + time_scale) - (gamestart_countdown))
        game_in_progress = true

        if (time < 1) then
        
            stopTimer()
            set(true)
            cls(0, 25, true, "rcon")
            execute_command("sv_map_reset")
            register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
            register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")

        elseif (init_countdown) then
            checkForPause()

            local minutes, seconds = select(1, secondsToTime(time, true)), select(2, secondsToTime(time, true))
            local time_stamp = (minutes .. ":" .. seconds)

            for i = 1, 16 do
                if player_present(i) then
                    if (paused[i] ~= nil) and (not paused[i].start) then
                        cls(i, 25)
                        rprint(i, "|c________________________________________________________________", 4 + 8)
                        rprint(i, "|cA", 4 + 8)
                        rprint(i, "|cBATTLE ROYALE MOD", 4 + 8)
                        rprint(i, "|cBeta (v1.0)", 4 + 8)
                        rprint(i, "|cCreated by Chalwk", 4 + 8)
                        rprint(i, "|cGame will begin in " .. time_stamp, 4 + 8)
                        rprint(i, "|c________________________________________________________________", 4 + 8)
                    end
                end
            end
        end
    end
end

function startTimer()
    gamestart_countdown = 0
    init_countdown = true
end

function stopTimer()
    init_countdown = false
    gamestart_countdown = 0
end

function PlayerInVehicle(p)
    if (get_dynamic_player(p) ~= 0) then
        local VehicleID = read_dword(get_dynamic_player(p) + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

function getXYZ(p)
    local x, y, z
    local player_object = get_dynamic_player(p)
    if (player_object ~= 0 and player_alive(p)) then
        local coords = { }
        if PlayerInVehicle(p) then
            coords.invehicle = true
            local VehicleID = read_dword(player_object + 0x11C)
            local vehicle = get_object_memory(VehicleID)
            x, y, z = read_vector3d(vehicle + 0x5c)
        else
            coords.invehicle = false
            x, y, z = read_vector3d(player_object + 0x5c)
        end
        coords.x, coords.y, coords.z = x, y, z
        return coords
    end
end

-- Receives number - determines whether to pluralize.
-- Returns string 's' if the input is greater than 1.
function getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
end

function stringSplit(inp, sep)
    if (sep == nil) then
        sep = "%s"
    end
    local t, i = {}, 1
    for str in gmatch(inp, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

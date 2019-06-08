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
local players_needed = 2

-- Players will be auto-killed if Out Of Bounds for this many seconds:
local time_until_kill = 5

-- When enough players are present, the game will start in this many seconds:
local gamestart_delay = 60

-- Several functions temporarily remove the "** SERVER **" prefix when certain messages are broadcast.
-- The prefix will be restored to 'server_prefix' when the relay has finished.
local server_prefix = "**LNZ**"

boundry.maps = {
    -- IMPORTANT: (1 world unit = 10 feet or ~3.048 meters)
    
    ["timberland"] = {
        -- Boundry: x,y,z, Min Size, Max Size:
        1.179, -1.114, -21.197, 100, 4500,
        -- End game this many minutes after the Boundry reduced to a size of 'Min Size'
        extra_time = 2,
        -- How often does the Boundry reduce in size (in seconds):
        duration = 60,
        -- How many world units does the Boundry reduce in size:
        shrink_amount = 500,
    },
        
    ["sidewinder"] = {
        1.680, 31.881, -3.922, 150, 5500,
        extra_time = 2, duration = 60, shrink_amount = 50,
    },
    ["ratrace"] = {
        8.340, -10.787, 0.222, 40, 415,
        extra_time = 2, duration = 60, shrink_amount = 30,
    },
    
    -- Not yet Implemented --
    ["bloodgulch"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["beavercreek"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["boardingaction"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["carousel"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["dangercanyon"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["deathisland"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["gephyrophobia"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["icefields"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["infinity"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["hangemhigh"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["damnation"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["putput"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["prisoner"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["wizard"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
    ["longest"] = {
        0000, 0000, 0000, 0, 0,
        extra_time = 0, duration = 0, shrink_amount = 0,
    },
}
-- ==== Battle Royale Configuration [ends] ==== --

-- Boundry variables:
local bX, bY, bZ, bR
local min_size, max_size, extra_time, shrink_cycle, shrink_amount
local start_trigger, game_in_progress, game_time = true, false
local monitor_coords
local time_scale = 0.030
local console_paused, paused = { }, { }
local out_of_bounds = { }
local last_man_standing = { }

local gamestart_countdown, init_countdown

local floor, format = math.floor, string.format
local gmatch, sub = string.gmatch, string.sub
local globals = nil
local red_flag, blue_flag

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    
    local gp = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if (gp == 3) then
        return
    end
    globals = read_dword(gp)
end

function OnScriptUnload()
    --
end

-- Initialize start up parameters:
local function init_params(reset)

    start_trigger, game_in_progress = false, true
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
        
        monitor_coords = true
        
        local function set(reset_scores)
            for i = 1, 16 do
                if player_present(i) then
                    paused[i] = paused[i] or { }
                    paused[i].start, paused[i].timer = false, 0
                    if (reset_scores) then
                        execute_command("score " .. i .. " 0")
                        execute_command("kills " .. i .. " 0")
                        execute_command("assists " .. i .. " 0")
                        execute_command("deaths " .. i .. " 0")
                    end
                end
            end
        end
        
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
    last_man_standing.count = 0
    last_man_standing.player = nil
    red_flag, blue_flag = read_dword(globals + 0x8), read_dword(globals + 0xC)
end

function OnGameEnd()
    init_params(true)
end

local Say = function(Player, Message)
    if (Player) and (Message) then
        execute_command("msg_prefix \"\"")
        say(Player, Message)
        execute_command("msg_prefix \" " .. server_prefix .. "\"")
    end
end

local SayAll = function(Message)
    if (Message) then
        execute_command("msg_prefix \"\"")
        say_all(Message)
        execute_command("msg_prefix \" " .. server_prefix .. "\"")
    end
end

local player_count = function()
    return tonumber(get_var(0, "$pn"))
end

function OnPlayerConnect(PlayerIndex)
    local p = tonumber(PlayerIndex)
    
    local enough_players = (player_count() >= players_needed)
    
    last_man_standing.count = last_man_standing.count + 1
    
    local function player_setup(p)
        console_paused[p] = false
        out_of_bounds[p] = { }
        out_of_bounds[p].yes = false
        out_of_bounds[p].timer = 0
        paused[p] = { }
        paused[p].start, paused[p].timer = false, 0
    end
    
    if (start_trigger) and (enough_players) then
        
        -- Initialize game parameters:
        init_params(false)
        
        -- Setup player parameters:
        player_setup(p)
        
    elseif (game_in_progress and enough_players) then
        player_setup(p)
    elseif not (enough_players) then
        player_setup(p)
    end
end

function OnPlayerDisconnect(PlayerIndex)
    local p = tonumber(PlayerIndex)
    last_man_standing.count = last_man_standing.count - 1
    
    local count = last_man_standing.count
    
    if (count < 1) then
        -- Initialize game parameters:
        init_params(true)
    elseif (count == 1) then
        for i = 1,16 do
            if player_present(i) and (tonumber(i) ~= p) then
                last_man_standing.player = tonumber(i)
            end
        end
        GameOver()
    end
end

function boundry:shrink()
    if (bR ~= nil) then 
        bR = (bR - shrink_amount)
        if (bR < min_size) then
            bR = min_size
            boundry_timer = nil
            SayAll("BOUNDRY IS NOW AT ITS SMALLEST POSSIBLE SIZE!", 4+8)
        else
            SayAll("[ BOUNDRY REDUCTION ] Radius now (" .. bR .. ") world units", 4+8)
        end
    end
end

function boundry:inSphere(p, px, py, pz, x, y, z, r)
    local coords = ( (px - x) ^ 2 + (py - y) ^ 2 + (pz - z) ^ 2)
    if (coords < r) then
        console_paused[p] = false
        out_of_bounds[p].yes = false
        return true
    elseif (coords >= r + 1) and (coords < max_size) then
        console_paused[p] = false
        return false
    elseif (coords > max_size) and not (console_paused[p]) then
        console_paused[p] = true
        return false
    end
end

function checkForPause()
    for i = 1,16 do
        if player_present(i) then
            if (paused[i] ~= nil) then
                if (paused[i].start) then
                    paused[i].timer = paused[i].timer + time_scale
                    if (paused[i].timer >= 3) then
                        paused[i].start = false
                        paused[i].timer = 0
                        cls(i, 25)
                    end
                end
            end
        end
    end
end

function OnTick()
    if (init_countdown) then
        GameStartCountdown()
    elseif not (init_countdown) then
    
        local time_stamp, until_next_shrink
        local time_remaining 
        
        if (game_timer ~= nil) then
            game_timer = game_timer + time_scale
            local time = ( (game_time + time_scale) - (game_timer) )
            time_remaining = time
            local mins, secs = select(1, secondsToTime(time)), select(2, secondsToTime(time))
            time_stamp = (mins..":"..secs)
            if (reduction_timer ~= nil) then
                reduction_timer = reduction_timer + time_scale
                local time = ( (shrink_duration + time_scale) - (reduction_timer) )
                if (time <= 0) then
                    reduction_timer = 0
                end
                local mins, secs = select(1, secondsToTime(time)), select(2, secondsToTime(time))
                until_next_shrink = (mins..":"..secs)
            end
        end
        
        for i = 1,16 do
            if player_present(i) then
                local player_object = get_dynamic_player(i)
                if (player_object ~= 0) then
                
                    checkForPause()
                
                    if (not paused[i].start) then
                        cls(i, 25)
                    end
                    
                    local px,py,pz = read_vector3d(player_object + 0x5c) 
                    if boundry:inSphere(i, px,py,pz, bX, bY, bZ, bR) and (monitor_coords) then
                        if (not console_paused[i]) and (not paused[i].start) then
                            
                            local rUnits = ( (px - bX) ^ 2 + (py - bY) ^ 2 + (pz - bZ) ^ 2)
                            rprint(i, "|c-- INSIDE SAFE ZONE --")
                            rprint(i, "|cUNITS FROM CENTER: " .. floor(rUnits) .. "/" .. bR .. " (final size: " .. min_size .. ")")
                            
                            if (boundry_timer ~= nil) then
                                shrink_time_msg = " | Time Until Boundry Reduction: " .. until_next_shrink
                            else
                                shrink_time_msg = ""
                            end
                            
                            local header, send_timestamp = ""
                            if (time_remaining >= extra_time) then
                                send_timestamp = true
                                header = "Game Time Remaining: " .. time_stamp
                            elseif (time_remaining <= extra_time) and (time_remaining > 0) then
                                send_timestamp = true
                                header = "FINAL: " .. time_stamp
                            elseif (time_remaining <= 0) then
                                send_timestamp = false
                                game_timer = nil
                                monitor_coords = false
                                GameOver()
                            end
                            
                            if (send_timestamp) and (monitor_coords) then
                                out_of_bounds[i].timer = 0
                                rprint(i, "|c" .. header .. shrink_time_msg)
                            end
                        end

                    elseif (monitor_coords) then
                        if (not console_paused[i]) and (not paused[i].start) then
                        
                            rprint(i, "|cWARNING:")
                            rprint(i, "|cYOU ARE OUTSIDE THE BOUNDRY!")
                            
                            local rUnits = ( (px - bX) ^ 2 + (py - bY) ^ 2 + (pz - bZ) ^ 2)
                            rprint(i, "|cUNITS FROM CENTER: " .. floor(rUnits) .. "/" .. bR)
                            out_of_bounds[i].yes = true
                            
                        elseif (not paused[i].start) and console_paused[i] then
                        
                            out_of_bounds[i].yes = true
                            out_of_bounds[i].timer = out_of_bounds[i].timer + time_scale
                            
                            local time_remaining = ((time_until_kill + 1) - out_of_bounds[i].timer)
                            local seconds = select(2, secondsToTime(time_remaining))
                            
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
                
                if (boundry_timer ~= nil) then
                    boundry_timer = boundry_timer + time_scale                
                    if ( boundry_timer >= (shrink_duration) ) then
                        if (bR > min_size and bR <= max_size) then
                            boundry_timer = 0
                            boundry:shrink()
                        end
                    end
                end
            end
        end
    end
end

function saveKDRs()
    local kdr_table = { }
    for i = 1,16 do
        if player_present(i) then
            local kills, deaths = get_var(i, "$kills"), get_var(i, "$deaths")
            local kdr = (kills/deaths)
            kdr_table[#kdr_table + 1] = kdr
        end                    
    end
    table.sort(kdr_table)
    return kdr_table
end

function getKDR(p)
    local kills,deaths = get_var(p, "$kills"), get_var(p, "$deaths")
    local kdr = (kills/deaths)
    return kdr
end

function GameOver()
    local scores, winner = { }, ""
    
    -- Time ran out - Calculate best score:
    if (game_timer == nil) then
        for i = 1,16 do
            if player_present(i) then
                local score = tonumber(get_var(i, '$score'))
                if (score > 0) then
                    scores[#scores + 1] = score
                end
            end
        end
        
        local function bestKDR()
            local KDRTab = saveKDRs()
            local highest_score = tonumber(KDRTab[#KDRTab])
            
            for i = 1,16 do
                if player_present(i) then
                    local kdr = getKDR(i)
                    if (kdr == highest_score) then
                        winner = get_var(i, "$name")
                    end
                end
            end
        end
        
        -- Check who has the highest score:
        if (#scores >= 1) then
            table.sort(scores)
            local highest_score = tonumber(scores[#scores])
            local count = 0
            for i = 1,16 do
                if player_present(i) then
                    
                    local score = tonumber(get_var(i, '$score'))
                    if (score == highest_score) then
                    
                        winner = get_var(i, "$name")
                        count = count + 1
                    end
                end
            end
            -- Only one player has the highest score (no duplicate scores)
            if (count == 1) then
                SayAll(winner .. " won the game!")
            -- More than one player have the same score. Calcuate who has the best KDR instead:
            elseif (count > 1) then
                bestKDR()
                SayAll(winner .. " won the game!")
            end
        else
            -- No players have any score points. Calcuate who has the best KDR instead:
            bestKDR()
            SayAll(winner .. " won the game!")
        end
    else
        game_timer = nil
        boundry_timer = nil
        monitor_coords = nil
        cls(0, 25, true, "rcon")
        local id = last_man_standing.player
        local victor_name = get_var(id, "$name")
        SayAll(victor_name .. " won the game")
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    if (killer > 0) then
        
        last_man_standing.count = last_man_standing.count - 1
        
        -- More than 1 player remaining:
        if (last_man_standing.count > 1) then
            SayAll(last_man_standing.count .. " players remaining!")
            
        -- Killer is the Victor. End the Game.
        elseif (last_man_standing.count < 0) then
            last_man_standing.player = killer
            GameOver()
        end
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
            paused[p].start = true
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
        paused[p].start = true
    end
end

function secondsToTime(seconds)
    local seconds = tonumber(seconds)
    if (seconds <= 0) then
        return "00", "00";
    else
        hours = format("%02.f", floor(seconds/3600));
        mins = format("%02.f", floor(seconds/60 - (hours*60)));
        secs = format("%02.f", floor(seconds - hours*3600 - mins *60));
        return mins, secs
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    local killer = tonumber(CauserIndex)
    if (killer > 0 and PlayerIndex ~= CauserIndex) then
        if (out_of_bounds[killer].yes) then
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
        local kill_message_addresss = sig_scan("8B42348A8C28D500000084C9") + 3
        local original = read_dword(kill_message_addresss)
        safe_write(true)
        write_dword(kill_message_addresss, 0x03EB01B1)
        safe_write(false)
        execute_command("kill " .. tonumber(PlayerIndex))
        safe_write(true)
        write_dword(kill_message_addresss, original)
        safe_write(false)
        write_dword(get_player(PlayerIndex) + 0x2C, 0 * 33)
        -- Deduct one death
        local deaths = tonumber(get_var(PlayerIndex, "$deaths"))
        execute_command("deaths " .. tonumber(PlayerIndex) .. " " .. deaths - 1)
    end
end

function GameStartCountdown()
    gamestart_countdown = gamestart_countdown + 0.030
    local seconds = select(2, secondsToTime(gamestart_countdown))
    local time_remaining = gamestart_delay - math.floor(seconds)
    if (time_remaining <= 1) then
        stopTimer()
        register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
        register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")
    elseif (init_countdown) then
        checkForPause()
        for i = 1,16 do
            if player_present(i) then
                if (not paused[i].start) then
                    cls(i, 25)
                    local char = getChar(time_remaining)
                    rprint(i, "|cGame will begin in " .. time_remaining .. " second" .. char, 4+8)
                    for _ = 1,7 do rprint(i, " ") end
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

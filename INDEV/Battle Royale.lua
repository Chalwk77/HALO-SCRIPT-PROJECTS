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
local players_needed = 1
-- If players are out of bounds for this amount of time, the script will auto-the player.
local time_until_kill = 5
local server_prefix = "**LNZ**"

boundry.maps = {
    -- IMPORTANT: (1 world unit = 10 feet or ~3.048 meters)
    ["timberland"] = {
        -- Maximum Boundry size:
        max_size = 4500,
        -- Final minimum size:
        min_size = 100, 
        -- End game this many minutes after the Boundry reduced to a size of 'min_size'
        extra_time = 2,
        -- How often does the Boundry reduce in size:
        duration = 60,
        -- How many world units does the Boundry reduce in size:
        shrink_amount = 50,
        -- Boundry x,y,z, boundry radius:
        -- Note: Radius must be the same as 'max_size' 
        1.179, -1.114, -21.197, 4500
    },
        
    ["sidewinder"] = {
        max_size = 5500, min_size = 150, extra_time = 2, duration = 60, shrink_amount = 50,
        1.680, 31.881, -3.922, 5500
    },
    ["ratrace"] = {
        max_size = 415, min_size = 40, extra_time = 2, duration = 60, shrink_amount = 30,
        8.340, -10.787, 0.222, 415
    },
    -- Not yet Implemented --
    ["bloodgulch"] = { nil },
    ["beavercreek"] = { nil },
    ["boardingaction"] = { nil },
    ["carousel"] = { nil },
    ["dangercanyon"] = { nil },
    ["deathisland"] = { nil },
    ["gephyrophobia"] = { nil },
    ["icefields"] = { nil },
    ["infinity"] = { nil },
    ["hangemhigh"] = { nil },
    ["damnation"] = { nil },
    ["putput"] = { nil },
    ["prisoner"] = { nil },
    ["wizard"] = { nil },
    ["longest"] = { nil },
}
-- ==== Battle Royale Configuration [ends] ==== --

-- Boundry variables:
local bX, bY, bZ, bR
local min_size, max_size, extra_time, shrink_cycle, shrink_amount
local start_trigger, game_in_progress, game_time = true, false
local time_scale = 0.030
local console_paused = { }
local out_of_bounds = { }

local floor, format = math.floor, string.format
local globals = nil
local red_flag, blue_flag

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")
    local gp = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if (gp == 3) then
        return
    end
    globals = read_dword(gp)
end

function OnScriptUnload()
    --
end

function OnGameStart()
    red_flag, blue_flag = read_dword(globals + 0x8), read_dword(globals + 0xC)
end

local Say = function(Player, Message)
    if (Player) and (Message) then
        execute_command("msg_prefix \"\"")
        say(Player, Message)
        execute_command("msg_prefix \" " .. server_prefix .. "\"")
    end
end

local player_count = function()
    return tonumber(get_var(0, "$pn"))
end

function OnPlayerConnect(PlayerIndex)
    local p = tonumber(PlayerIndex)
    
    local enough_players = (player_count() >= players_needed)
    
    local function setup_params(p)
        console_paused[p] = false
        out_of_bounds[p] = { }
        out_of_bounds[p].yes = false
        out_of_bounds[p].timer = 0
    end
    
    if (start_trigger) and (enough_players) then
        start_trigger, game_in_progress = false, true
        local mapname = get_var(0, "$map")
        local coords = boundry.maps[mapname]
        if (coords ~= nil) then        
            min_size, max_size = coords.min_size, coords.max_size
            bX, bY, bZ, bR = coords[1], coords[2], coords[3], coords[4]
            shrink_duration, shrink_amount = coords.duration, coords.shrink_amount
            extra_time = coords.extra_time
            game_time = (shrink_duration * (max_size / shrink_amount))
            
            game_timer = 0
            reduction_timer = 0
            boundry_timer = 0
                       
            -- For Debugging (temp)
            delete_object = true
            --
            
            setup_params(p)
            
            -- Register a hook into SAPP's tick event.
            register_callback(cb["EVENT_TICK"], "OnTick")
        end
    elseif (game_in_progress and enough_players) then
        setup_params(p)
    end
end

function boundry:shrink()
    if (bR ~= nil) then 
        bR = (bR - shrink_amount)
        if (bR < min_size) then
            bR = min_size
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

function OnTick()
    for i = 1,16 do
        if player_present(i) then
            local player_object = get_dynamic_player(i)
            if (player_object ~= 0) then
                cls(i, 25)
                
                local time_stamp, until_next_shrink
                local time_remaining 
                
                if (game_timer ~= nil) then
                    game_timer = game_timer + time_scale
                    local time = ( (game_time + time_scale) - (game_timer) )
                    time_remaining = time
                    local mins, secs = select(1, secondsToTime(time, true)), select(2, secondsToTime(time, true))
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
                
                local px,py,pz = read_vector3d(player_object + 0x5c) 
                if boundry:inSphere(i, px,py,pz, bX, bY, bZ, bR) then
                    if not (console_paused[i]) then
                        local rUnits = ( (px - bX) ^ 2 + (py - bY) ^ 2 + (pz - bZ) ^ 2)
                        rprint(i, "|c-- INSIDE BOUNDS --")
                        rprint(i, "|cUNITS FROM CENTER: " .. floor(rUnits) .. "/" .. bR)
                        
                        if (boundry_timer ~= nil) then
                            shrink_time_msg = " | Time Until Boundry Reduction: " .. until_next_shrink
                        else
                            shrink_time_msg = ""
                        end
                        
                        local header, send_timestamp = ""
                        if (time_remaining <= extra_time) then
                            send_timestamp = true
                            header = "FINAL: " .. time_stamp
                        elseif (time_remaining >= extra_time) then
                            send_timestamp = true
                            header = "Game Time Remaining: " .. time_stamp
                        elseif (time_remaining < extra_time) then
                            send_timestamp = false
                            game_timer = nil
                        end
                        
                        if (send_timestamp) then
                            out_of_bounds[i].timer = 0
                            rprint(i, "|c" .. header .. shrink_time_msg)
                        end
                    end
                    -- 
                else
                    if not (console_paused[i]) then
                        rprint(i, "|cWARNING:")
                        rprint(i, "|cYOU ARE OUTSIDE THE BOUNDRY!")
                        local rUnits = ( (px - bX) ^ 2 + (py - bY) ^ 2 + (pz - bZ) ^ 2)
                        rprint(i, "|cUNITS FROM CENTER: " .. floor(rUnits) .. "/" .. bR)
                        out_of_bounds[i].yes = true
                    else
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
                        Say(i, "[ BOUNDRY REDUCTION ] Zone Size Decreased: " .. bR, 4+8)
                    elseif (bR <= min_size) then
                        boundry_timer = nil
                        Say(i, "BOUNDRY IS NOW AT ITS SMALLEST POSSIBLE SIZE!", 4+8)
                    end
                end
            end
        end
    end
end

function cls(PlayerIndex, count)
    count = count or 25
    if (PlayerIndex) then
        for _ = 1, count do
            rprint(PlayerIndex, " ")
        end
    end
end

function secondsToTime(seconds, ExtraTime)
    local seconds = tonumber(seconds)
    if (seconds <= 0) then
        return "00", "00";
    else
        hours = format("%02.f", floor(seconds/3600));
        mins = format("%02.f", floor(seconds/60 - (hours*60)));
        secs = format("%02.f", floor(seconds - hours*3600 - mins *60));
        if (ExtraTime) then
            mins = (mins + extra_time)
        end
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

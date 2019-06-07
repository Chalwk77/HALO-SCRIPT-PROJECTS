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
local server_prefix = "**LNZ**"

boundry.maps = {
    ["timberland"] = {
        max_size = 4500,
        min_size = 100, 
        duration = 60,
        shrink_amount = 50,
        1.179, -1.114, -21.197, 4500
    },
    
    -- Not yet Implemented --
    ["sidewinder"] = { nil },
    ["ratrace"] = { nil },
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
local min_size, max_size, shrink_cycle, shrink_amount
local start_trigger, game_in_progress, game_time = true, false
local time_scale = 0.030
local console_paused = { }
local floor, format = math.floor, string.format

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
end

function OnScriptUnload()
    --
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
    end
    
    if (start_trigger) and (enough_players) then
        start_trigger, game_in_progress = false, true
        local mapname = get_var(0, "$map")
        local coords = boundry.maps[mapname]
        if (coords ~= nil) then        
            min_size, max_size = coords.min_size, coords.max_size
            bX, bY, bZ, bR = coords[1], coords[2], coords[3], coords[4]
            shrink_duration, shrink_amount = coords.duration, coords.shrink_amount
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
                
                local time_remaining, until_next_shrink
                
                if (game_timer ~= nil) then
                    game_timer = game_timer + time_scale
                    local time = ( (game_time + time_scale) - (game_timer) )
                    local mins, secs = select(1, secondsToTime(time)), select(2, secondsToTime(time))
                    time_remaining = (mins..":"..secs)                    
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
                        
                        rprint(i, "|cGame Time Remaining: " .. time_remaining .. shrink_time_msg)
                    end
                    -- 
                else
                    if not (console_paused[i]) then
                        rprint(i, "|cWARNING:")
                        rprint(i, "|cYOU ARE OUTSIDE THE CIRCLE!")
                        local rUnits = ( (px - bX) ^ 2 + (py - bY) ^ 2 + (pz - bZ) ^ 2)
                        rprint(i, "|cUNITS FROM CENTER: " .. floor(rUnits) .. "/" .. bR)
                    else
                        rprint(i, "|c--------- WARNING ---------")
                        rprint(i, "|cYOU ARE LEAVING THE COMBAT AREA!")
                        rprint(i, "|cRETURN NOW OR YOU WILL BE SHOT!")
                    end
                    -- Camo serves as a visual indication to the player
                    -- that they are outside the boundry:
                    execute_command("camo " .. i .. " 1")
                end
            end
            
            if (boundry_timer ~= nil) then
                boundry_timer = boundry_timer + time_scale
                if ( boundry_timer >= (shrink_duration) ) then
                    if (bR > min_size and bR <= max_size) then
                        boundry_timer = 0
                        boundry:shrink()
                        Say(i, "[ BOUNDRY REDUCTION ] Zone Size: " .. bR, 4+8)
                    elseif (bR <= min_size) then
                        boundry_timer = nil
                        Say(i, "BOUNDRY IS NOW AT ITS SMALLEST POSSIBLE SIZE", 4+8)
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

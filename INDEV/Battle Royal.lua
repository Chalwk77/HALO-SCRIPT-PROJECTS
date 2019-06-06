--[[
--=====================================================================================================--
Script Name: Battle Royal (beta v1.0), for SAPP (PC & CE)
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

-- ==== Battle Royal Configuration [starts] ==== --
local players_needed = 1
local server_prefix = "**LNZ**"

boundry.maps = {
    ["timberland"] = {
        max_size = 4500,
        min_size = 20, 
        duration = 5,
        shrink_amount = 20,
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
-- ==== Battle Royal Configuration [ends] ==== --

-- Boundry variables:
local bX, bY, bZ, bR
local min_size, max_size, shrink_cycle, shrink_amount
local start_trigger, game_in_progress = true, false
local console_paused = { }

-- Debugging variables:
local debug_object, delete_object = { }

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
        console_paused[p] = { }
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
            
            -- For Debugging (temp)
            delete_object = true
            --
            
            setup_params(p)
            
            -- Create new timer array:
            boundry.timer = { }
            boundry.timer = 0
            boundry.init_timer = true
            
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
        return true
    elseif (coords >= r + 1) then
        return false
    elseif (coords > max_size) then
        console_paused[p] = true
        rprint(p, "|c--------- WARNING ---------")
        rprint(p, "|cYOU ARE LEAVING THE COMBAT AREA!")
        rprint(p, "|cRETURN NOW OR YOU WILL BE SHOT!")
        return nil
    end
end

function OnTick()
    for i = 1,16 do
        if player_present(i) then
            local player_object = get_dynamic_player(i)
            
            if (player_object ~= 0) then
                cls(i, 25)
                local px,py,pz = read_vector3d(player_object + 0x5c) 
                if boundry:inSphere(i, px,py,pz, bX, bY, bZ, bR) then
                    if not (console_paused[i]) then
                        local rUnits = ( (px - bX) ^ 2 + (py - bY) ^ 2 + (pz - bZ) ^ 2)
                        rprint(i, "|cINSIDE BOUNDS.")
                        rprint(i, "|cUNITS FROM CENTER: " .. math.floor(rUnits) .. "/" .. bR)
                        for _ = 1,7 do
                            rprint(i, " ")
                        end
                    end
                    -- 
                else
                    if not (console_paused[i]) then
                        rprint(i, "|cWARNING:")
                        rprint(i, "|cYOU ARE OUTSIDE THE BOUNDS!")
                        local rUnits = ( (px - bX) ^ 2 + (py - bY) ^ 2 + (pz - bZ) ^ 2)
                        rprint(i, "|cUNITS FROM CENTER: " .. math.floor(rUnits) .. "/" .. bR)
                        
                        for _ = 1,7 do
                            rprint(i, " ")
                        end
                    end
                    -- Camo serves as a visual indication to the player
                    -- that they are outside the boundry:
                    execute_command("camo " .. i .. " 1")
                end
            end
            
            if (boundry.timer ~= nil) and (boundry.init_timer) then
                boundry.timer = boundry.timer + 0.030
                
                if (delete_object) then
                    delete_object = false
                    local debug_obj = spawn_object("eqip", "powerups\\active camouflage", bX, bY, bZ + 0.5)
                    debug_object[#debug_object + 1] = debug_obj
                    timer(1500, "delete")    
                end                
                
                if ( boundry.timer >= (shrink_duration) ) then
                    if (bR > min_size and bR <= max_size) then
                        boundry.timer = 0
                        boundry:shrink()
                        Say(i, "BOUNDRY SHRUNK: " .. shrink_amount .. "/" .. bR .. " - MIN: " .. min_size, 4+8)
                    elseif (bR <= min_size) then
                        boundry.init_timer = false
                        boundry.timer = 0
                        
                        -- TO DO:
                        -- ...
                        
                        -- DEBUGGING:
                        Say(i, "THE PLAYABLE BOUNDRY IS NOW AT A MINIMUM SIZE OF " .. min_size .. " (actual: " .. bR .. ")", 4+8)
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

-- DEBUGGING:
function delete()
    for i = 1,#debug_object do
        local object = get_object_memory(debug_object[i])
        if (object ~= nil and object ~= 0) then
            destroy_object(debug_object[i])
            delete_object = true
        end
    end
end

--[[
--=====================================================================================================--
Script Name: Trophy Hunter (v2), for SAPP (PC & CE)
Description: This is an adaptation of Kill-Confirmed from Call of Duty. 

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local mod = { 

    trophy = "weapons\\ball\\ball",
    
    -- Scoring -
    claim = 1,               -- Collect your trophy
    claim_other = 1,         -- Collect somebody else's trophy
    steal_self = 2,          -- Collect your killer's trophy
    death_penalty = 1,       -- Death Penalty   [number of points deducted]
    suicide_penalty = 2,     -- Suicide Penalty [number of points deducted]
    
    server_prefix = "** SERVER **",
    
    messages = {
    
        -- Collection Messages --
        "%killer% collected %victim%'s trophy!",
        "%victim% stole %killer%'s trophy!",
        "%player% stole %killer% trophy!",

        -- Welcome Messages --
        "Welcome to Trophy Hunter",
        "Your victim will drop a trophy when they die!",
        "Collect this trophy to get points!",
        "Type /info or @info for more information.",

        -- Information Board --
        "|l-- POINTS --",
        "|lCollect your victims trophy:           |r+%claim% points",
        "|lCollect somebody else's trophy:        |r+%claim_other% points",
        "|lCollect your killer's trophy:          |r+%steal_self% points",
        "|lDeath Penalty:                         |r-%death_penalty% points",
        "|lSuicide Penalty:                       |r-%suicide_penalty% points",
        "|lCollecting trophies is the only way to score!",
    },
}

-- Variables for String Library:
local format = string.format
local sub, gsub = string.sub, string.gsub
local lower, upper = string.lower, string.upper
local match, gmatch = string.match, string.gmatch

-- Variables for Math Library:
local floor, sqrt = math.floor, math.sqrt

-- Game Variables:
local game_over

-- Game Tables: 
local trophies = { }
-- ...

function OnScriptLoad()

    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
    
    if (get_var(0, '$gt') ~= 'n/a') then
        if mod:checkGameType() then
            for i = 1, 16 do
                if player_present(i) then

                end
            end
        end
    end
end

function OnNewGame()
    if mod:checkGameType() then
        game_over = false
    end
end

function OnGameEnd()
    game_over = true
end

function OnPlayerConnect(PlayerIndex)
    --
end

function OnPlayerDisconnect(PlayerIndex)
    -- Init despawning logic:
end

function OnTick()

end

function OnPlayerChat(PlayerIndex, Message)
    local message = Message
    
    message = lower(message) or upper(message)
    
    if (message == "@info") then
        return false
    end
end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
    if (tonumber(Type) == 1) then
        mod:OnTrophyPickup(PlayerIndex, WeaponIndex)            
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    
    local params = { }
    params.kname, params.vname = get_var(killer, "$name"), get_var(victim, "$name")
    params.victim, params.killer = victim, killer
    
    -- Check if the player committed suicide:
    if (victim == killer) then
        return false
        
    -- Check if the player was killed by a vehicle (squashed & unoccupied):
    elseif (killer == 0) then
        return false
    
    -- Check if the player was killed by the server:
    elseif (killer == -1) then
        return false
        
    -- Check if the killer was Guardians or Unknown:
    elseif (killer == nil) then
        return false

    -- Check if the killer is a valid player.
    elseif (killer > 0) then
        -- Prevent killer from getting a point (until they collect their trophy)
        execute_command("score " .. killer .. " -1")
        mod:spawnTrophy(params)
    end
end

function mod:OnTrophyPickup(PlayerIndex, WeaponIndex)

    local player_object = get_dynamic_player(PlayerIndex)
    local WeaponID = read_dword(player_object + 0x118)
    
    if (WeaponID ~= 0) then
    
        local weapon = read_dword(player_object + 0x2F8 + (tonumber(WeaponIndex) - 1) * 4)
    
        local WeaponObject = get_object_memory(weapon)    
        if (mod:ObjectTagID(WeaponObject) == mod.trophy) then
        
            for k,v in pairs(trophies) do
                if (k == weapon) then
                
                    local params = { }
                                    
                    params.killer, params.victim = v[1], v[2]
                    params.kname, params.vname = v[3], v[4]
                    params.name = get_var(PlayerIndex, "$name")
                    
                    local msg = function(table, index)
                        return gsub(gsub(gsub(table[index], "%%killer%%", params.kname), "%%victim%%", params.vname), "%%player%%", params.name)
                    end
                    
                    execute_command("msg_prefix \"\"")
                    if (PlayerIndex == params.killer) then
                        params.type = 1
                        say_all(msg(mod.messages, 1))
                    elseif (PlayerIndex ~= params.killer and PlayerIndex ~= params.victim) then
                        params.type = 2
                        say_all(msg(mod.messages, 2))
                    elseif (PlayerIndex == params.victim) then
                        params.type = 3
                        say_all(msg(mod.messages, 3))
                    end
                    execute_command("msg_prefix \"" .. mod.server_prefix .. "\" ")

                    destroy_object(weapon)
                    trophies[k] = nil
                    
                    mod:UpdateScore(params)
                end
            end
        end
    end
end

function mod:UpdateScore(params)
    local params = params or nil
    if (params ~= nil) then
       
        if (params.type == 1) then
            execute_command("score " .. params.killer .. " +" .. mod.claim)
        elseif (params.type == 2) then
            execute_command("score " .. params.killer .. " +" .. mod.claim_other)
        elseif (params.type == 3) then
            execute_command("score " .. params.killer .. " +" .. mod.claim_self)
        end
        
        -- Prevent Victim's score from going into negatives:
        if tonumber(get_var(params.victim, "$score")) <= -1 then
            execute_command("score " .. params.victim .. " 0")
        end
    end
end

function mod:checkGameType()
    local gt = {"ctf","koth","oddbal","race"}
    for i = 1,#gt do
        if get_var(1, "$gt") == gt[i] then
            unregister_callback(cb['EVENT_DIE'])
            unregister_callback(cb['EVENT_TICK'])
            unregister_callback(cb['EVENT_JOIN'])
            unregister_callback(cb['EVENT_CHAT'])
            unregister_callback(cb['EVENT_LEAVE'])
            unregister_callback(cb['EVENT_GAME_END'])
            unregister_callback(cb['EVENT_WEAPON_PICKUP'])
            cprint("Trophy Hunter GAME TYPE ERROR!", 4 + 8)
            cprint("This script doesn't support " .. gt[i], 4 + 8)
            return false
        end
    end
end

function mod:spawnTrophy(params)
    local params = params or nil
    if (params ~= nil) then
    
        local coords = mod:getXYZ(params)
        local x,y,z,offset = coords.x,coords.y,coords.z,coords.offset
        local object = spawn_object("weap", mod.trophy, x, y, z + offset)
        
        local trophy = get_object_memory(object)
        trophies[object] = {params.killer, params.victim, params.kname, params.vname}
    end
end

function mod:getXYZ(params)
    local params = params or nil    
    if (params ~= nil) then
        local player_object = get_dynamic_player(params.victim)
        if (player_object ~= 0) then
                
            local coords = { }
            local x,y,z = 0,0,0
            
            if mod:isInVehicle(params.victim) then
                local VehicleID = read_dword(player_object + 0x11C)
                local vehicle = get_object_memory(VehicleID)
                coords.invehicle, coords.offset = true, 0.5
                x, y, z = read_vector3d(vehicle + 0x5c)
            else
                coords.invehicle, coords.offset = false, 0.3
                x, y, z = read_vector3d(player_object + 0x5c)
            end
            coords.x, coords.y, coords.z = format("%0.3f", x), format("%0.3f", y), format("%0.3f", z)
            return coords
        end
    end
end

function mod:isInVehicle(PlayerIndex)
    if (get_dynamic_player(PlayerIndex) ~= 0) then
        local VehicleID = read_dword(get_dynamic_player(PlayerIndex) + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

function mod:ObjectTagID(object)
    if (object ~= nil and object ~= 0) then
        return read_string(read_dword(read_word(object) * 32 + 0x40440038))
    else
        return ""
    end
end

--[[
--=====================================================================================================--
Script Name: Spawn Protection (v1.0), for SAPP (PC & CE)
Description: This mod will block receiving damage for a configurable amount of time (after the player spawns).
             You can optionally allow or block the victim's capabilities of inflicting damage while under protection, also.


Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local mod = { }
function mod:init()

    -- Time (in seconds) that players will be invincible (after spawning):
    mod.protection_duration = 5
    
    -- Should the player be able to inflict damage on others while under protection?
    mod.inflict_damage = true
    --------------------------
    
    -- Do Not Touch --
    mod.players = {}
    mod.delta_time = 0.03333333333333333
end

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "BlockReceivingDamage")
    
    if (get_var(0, "$gt") ~= "n/a") then
        mod:init()
        for i = 1, 16 do
            if player_present(i) then
                mod:initPlayer(i, true)
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        mod:init()
    end
end

function OnPlayerConnect(PlayerIndex)
    mod:initPlayer(PlayerIndex, true)
end

function OnPlayerDisconnect(PlayerIndex)
    mod:initPlayer(PlayerIndex, false)
end

function OnPlayerSpawn(PlayerIndex)
    for _,player in pairs(mod.players) do
        if (player.id == PlayerIndex) then 
            player.timer, player.protect = 0, true
        end
    end
end

function OnTick()
    for _,player in pairs(mod.players) do
        if (player.id) then 
            if (player_alive(player.id) and player.protect) then
                player.timer = player.timer + mod.delta_time
                local timeRemaining = player.duration - math.floor(player.timer % 60)
                if (timeRemaining <= 0) then
                    player.protect = false
                end
            end
        end
    end
end

function BlockReceivingDamage(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    -- Block all receiving Damage
    if (tonumber(CauserIndex) > 0) then
        for _,player in pairs(mod.players) do
        
            -- Prevent Victim from receiving damage
            if (player.id == PlayerIndex and player.protect) then 
                return false
                
            -- Block or Allow the protected player from inflicting damage (see variable "inflict_damage")
            elseif (player.id == CauserIndex and player.protect) then 
                if (mod.inflict_damage) then
                    return true
                else
                    return false
                end
            end
        end
    end
end

function mod:initPlayer(PlayerIndex, Init)
    if (PlayerIndex) then
        local players = mod.players
        if (Init) then
            players[#players + 1] = {
                id = PlayerIndex,
                timer = 0,
                protect = nil,
                duration = mod.protection_duration,
            }
        else
            for index,player in pairs(players) do
                if (player.id == PlayerIndex) then
                    players[index] = nil
                end
            end
        end
    end
end

function OnScriptUnload()
    --
end

--[[
--=====================================================================================================--
Script Name: Spawn Protection V2, for SAPP (PC & CE)
Description: Players will receive an overshield if they have between MIN and MAX deaths
             but receive an extra camo protection if they have greater than 10 deaths.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--


-- Config Starts --
local MIN = 5
local MAX = 10
-- Config Ends --

api_version = "1.12.0.0"
local consecutive = { }

function OnScriptLoad()
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    if (get_var(0, "$gt") ~= "n/a") then
        consecutive = { }
        for i = 1, 16 do
            if player_preset(i) then
                InitPlayer(i, false)
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end

function InitPlayer(Ply, Reset)
    if (Reset) then
        consecutive[Ply] = nil
    else
        consecutive[Ply] = 0
    end
end

function OnPlayerConnect(Ply)
    InitPlayer(Ply, false)
end

function OnPlayerSpawn(Ply)
    if (consecutive[Ply] >= MIN and consecutive[Ply] <= MAX) then
        powerup_interact(spawn_object("eqip", "powerups\\over shield"), Ply)
    elseif (consecutive[Ply] > MAX) then
        powerup_interact(spawn_object("eqip", "powerups\\over shield"), Ply)
        powerup_interact(spawn_object("eqip", "powerups\\active camouflage"), Ply)
    end
end

function OnPlayerDisconnect(Ply)
    InitPlayer(Ply, true)
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local killer, victim = tonumber(KillerIndex), tonumber(VictimIndex)
    local kteam = get_var(killer, "$team")
    local vteam = get_var(victim, "$team")
    local pvp = ((killer > 0) and killer ~= victim) and (kteam ~= vteam)
    if (pvp) then
        consecutive[killer] = 0
        consecutive[victim] = consecutive[victim] + 1
    end
end
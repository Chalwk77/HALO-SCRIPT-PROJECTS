--[[
Script Name: HPC Spawn Protection (version 2), for SAPP
    - Implementing API version: 1.11.0.0

    Description: By default, you will spawn with an Overshield, invisibility(7s), godmode(7s), and a speed boost(7s/1.3+) for every 10 consecutive deaths.

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS
    
    This script will allow you to:
        - optionally toggle:
        * godmode (invulnerability)
            * speed boost + define amount to boost by, (1.3 by default)
            * invisibility
            * overshield
        
    There are two modes:
        Mode1: 'consecutive deaths' (editable)
        If this setting is enabled, for every 10 consecutive deaths you have, you will spawn with protection.
            
        Mode2: Receive protection when you reach a specific amount of deaths (editable)
            
    TO DO:
        - Detect if Killer is camping
        - Punish Killer
        * Suggestions? https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues/5

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
]]

api_version = "1.11.0.0"
-- Mode 1 = consecutive deaths (editable)
-- Mode 2 = Specific amout of Deaths (editable)
-- Configuration--
local settings = {
    ["Mode1"] = true,
    ["Mode2"] = false,
    ["UseCamo"] = true,
    ["UseOvershield"] = true,
    ["UseSpeedBoost"] = true,
    ["UseInvulnerability"] = true,
}

-- attributes given every 10 deaths, (victim)
ConsecutiveDeaths = 10

-- Normal running speed
ResetSpeedTo = 1.0
-- Amount to boost by
SpeedBoost = 1.3
-- Speedboost activation time (in seconds)
SpeedDuration = 7.0
-- Godmode activation time (in seconds)
Invulnerable = 7.0
-- Camo activation time (in seconds)
CamoTime = 7.0
-- Configuration Ends --

-- Only edit these values if you know what you're doing!
-- If Victim has exactly this many deaths, he will spawn with protection.
_10_Deaths = 10
_20_Deaths = 20
_30_Deaths = 30
_45_Deaths = 45
_60_Deaths = 60
_75_Deaths = 75
_75_Deaths = 95
_75_Deaths = 115
_75_Deaths = 135

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
end

function OnScriptUnload() end

DEATHS = { }
scriptname = 'protection.lua'
-- If there's a script configuration error, log it.
logging = true

function OnPlayerJoin(PlayerIndex)
    DEATHS[PlayerIndex] = { 0 }
    name = get_var(PlayerIndex,"$name")
end
    
function OnPlayerLeave(PlayerIndex)
    DEATHS[PlayerIndex] = { 0 }
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local victim = tonumber(VictimIndex)
    local killer = tonumber(KillerIndex)
    if (killer > 0) then
        DEATHS[victim][1] = DEATHS[victim][1] + 1
    end
end

function ApplyCamo(PlayerIndex)
    if player_alive(PlayerIndex) then
        execute_command("camo me " .. CamoTime, PlayerIndex)
    else 
        return false
    end
end

function ApplyOvershield(PlayerIndex)
    if player_alive(PlayerIndex) then
        local ObjectID = spawn_object("eqip", "powerups\\over shield")	
        powerup_interact(ObjectID, PlayerIndex)
    else 
        return false
    end
end	

function Invulnerability(PlayerIndex)
    if player_alive(PlayerIndex) then
        timer(Invulnerable * 1000, "ResetInvulnerability", PlayerIndex)	
        execute_command("god me", PlayerIndex)
    else 
        return false
    end
end

function GiveSpeedBoost(PlayerIndex)
    if player_alive(PlayerIndex) then
        local PlayerIndex = tonumber(PlayerIndex)
        local victim = get_player(PlayerIndex)
        timer(SpeedDuration * 1000, "ResetPlayerSpeed", PlayerIndex)
        write_float(victim + 0x6C, SpeedBoost)
    else 
        return false
    end
end

function ResetPlayerSpeed(PlayerIndex)
    if player_alive(PlayerIndex) then
        local PlayerIndex = tonumber(PlayerIndex)
        local victim = get_player(PlayerIndex)
        write_float(victim + 0x6C, ResetSpeedTo)
        rprint(PlayerIndex, "|cSpeed Boost deactivated!")
    else 
        return false
    end
end

function ResetInvulnerability(PlayerIndex)
    if player_alive(PlayerIndex) then
        execute_command("ungod me", PlayerIndex)
        rprint(PlayerIndex, "|cGod Mode deactivated!")
    else 
        return false
    end
end

function CheckSettings(PlayerIndex)
    if (player_present(PlayerIndex)) then
        if player_alive(PlayerIndex) then
            cprint(name .. " received Spawn Protection!", 2+8)
            rprint(PlayerIndex, "|cYou have received Spawn Protection!")
            rprint(PlayerIndex, "|n")
            rprint(PlayerIndex, "|n")
            rprint(PlayerIndex, "|n")
            rprint(PlayerIndex, "|n")
            rprint(PlayerIndex, "|n")
            if settings["UseCamo"] then
                timer(0, "ApplyCamo", PlayerIndex)
            end
            if settings["UseSpeedBoost"] then 
                GiveSpeedBoost(PlayerIndex)
            end
            if settings["UseInvulnerability"] then
                Invulnerability(PlayerIndex)
            end
            if settings["UseOvershield"] then
                timer(0, "ApplyOvershield", PlayerIndex)
            end
        else 
            return false
        end
    else 
        return false
    end
end

function OnPlayerSpawn(PlayerIndex)
    if (player_present(PlayerIndex)) then
        if settings["Mode1"] and not settings["Mode2"] then
            if (DEATHS[PlayerIndex][1] == ConsecutiveDeaths) then
                CheckSettings(PlayerIndex)
                DEATHS[PlayerIndex][1] = 0
            end
        end
        if settings["Mode2"] and not settings["Mode1"] then
            if (DEATHS[PlayerIndex][1] == nil) then DEATHS[PlayerIndex][1] = 0 
            elseif (DEATHS[PlayerIndex][1] == _10_Deaths) then
                CheckSettings(PlayerIndex)
            elseif (DEATHS[PlayerIndex][1] == _20_Deaths) then
                CheckSettings(PlayerIndex)
            elseif (DEATHS[PlayerIndex][1] == _30_Deaths) then
                CheckSettings(PlayerIndex)
            elseif (DEATHS[PlayerIndex][1] == _45_Deaths) then
                CheckSettings(PlayerIndex)
            elseif (DEATHS[PlayerIndex][1] == _60_Deaths) then
                CheckSettings(PlayerIndex)
            elseif (DEATHS[PlayerIndex][1] == _75_Deaths) then
                CheckSettings(PlayerIndex)
            elseif (DEATHS[PlayerIndex][1] == _95_Deaths) then
                CheckSettings(PlayerIndex)
            elseif (DEATHS[PlayerIndex][1] == _115_Deaths) then
                CheckSettings(PlayerIndex)
            elseif (DEATHS[PlayerIndex][1] == _135_Deaths) then
                CheckSettings(PlayerIndex)
            end
        end
    end
end

function OnNewGame()
    if logging then
        if settings["Mode1"] and settings["Mode2"] then
            note = string.format("\n\n[SCRIPT ERROR] - " ..scriptname.. "\nMode [1] and Mode [2] are both enabled!\nYou can only enable one at a time!\n\n")
            unload()
        end
        if not settings["Mode1"] and not settings["Mode2"] then
            note = string.format("\n\n[SCRIPT ERROR] - " ..scriptname.. "\nMode [1] and Mode [2] are both disabled!\nYou must enable one of the two settings.\n\n")
            unload()
        end
        if settings["Mode1"] and settings["UseCamo"] == false and settings["UseSpeedBoost"] == false and settings["UseInvulnerability"] == false and settings["UseOvershield"] == false then
            note = string.format("\n\n[SCRIPT ERROR] - " ..scriptname.. "\nNo sub-settings enabled for Mode [1]")
            unload()
        elseif settings["Mode2"] and settings["UseCamo"] == false and settings["UseSpeedBoost"] == false and settings["UseInvulnerability"] == false and settings["UseOvershield"] == false then
            note = string.format("\n\n[SCRIPT ERROR] - " ..scriptname.. "\nNo sub-settings enabled for Mode [2]")
            unload()
        end
    end
end

function unload()
    cprint(note, 4+8)
    execute_command("log_note \""..note.."\"")
    execute_command("lua_unload " .. scriptname)
    cprint(scriptname .. " was unloaded!", 4+8)
end

function OnError(Message)
    print(debug.traceback())
end
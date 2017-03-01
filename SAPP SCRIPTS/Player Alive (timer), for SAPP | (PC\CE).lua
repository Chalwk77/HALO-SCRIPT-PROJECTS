--[[
Script Name: Player Alive (timer), for SAPP | (PC\CE)
Implementing API version: 1.11.0.0

    Description: While playerX is alive, if the timer reaches the elapsed "ALLOCATED_TIME" before they die, do something special.
                 It's up to you to code in your "something special" of choice.
                 
                    Timer for playerX will reset when:
                    - They quit the game (handled by OnTick)
                    - On Death (handled by PlayerAlive)
                    - Game Ends
                    
                    When the timer reaches the elapsed ALLOCATED_TIME threshold, 
                    it will reset to 0 seconds but not continue counting down until they respawn/rejoin.

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
]]

-- Config --
USE_TIMER = true
-- in seconds (1 minute by default) --
ALLOCATED_TIME = 60
-- Config ends --

-- Do not touch anything below unless you know what you're doing --
TIMER = { }
PLAYERS_ALIVE = { }
api_version = "1.11.0.0"
function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            TIMER[i] = false
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    local PLAYER_ID = get_var(PlayerIndex, "$n")
    PLAYERS_ALIVE[PLAYER_ID] = { }
    PLAYERS_ALIVE[PLAYER_ID].TIME_ALIVE = 0
end

function OnPlayerSpawn(PlayerIndex)
    TIMER[PlayerIndex] = true
    local PLAYER_ID = get_var(PlayerIndex, "$n")
    PLAYERS_ALIVE[PLAYER_ID].TIME_ALIVE = 0
end

function PlayerAlive(PlayerIndex)
    if player_present(PlayerIndex) then
        if (player_alive(PlayerIndex)) then
            return true
        else
            return false
        end
    end
end

function math.round(number, place)
	return math.floor(number * ( 10 ^ (place or 0) ) + 0.5) / ( 10 ^ (place or 0) )
end

function OnTick()
    if (USE_TIMER == true) then
        for i = 1, 16 do
            if player_present(i) then
                if (TIMER[i] ~= false and PlayerAlive(i) == true) then
                    local PLAYER_ID = get_var(i, "$n")
                    PLAYERS_ALIVE[PLAYER_ID].TIME_ALIVE = PLAYERS_ALIVE[PLAYER_ID].TIME_ALIVE + 0.030
                    if (PLAYERS_ALIVE[PLAYER_ID].TIME_ALIVE >= math.round(ALLOCATED_TIME)) then
                        TIMER[i] = false
                        -- do something here --
                        -- cprint("Alive for " .. tonumber(math.round(PLAYERS_ALIVE[PLAYER_ID].TIME_ALIVE)) .. " seconds!", 2+8)
                        rprint(i, "You have been alive for " .. tonumber(math.round(PLAYERS_ALIVE[PLAYER_ID].TIME_ALIVE)) .. " seconds!")
                    end
                end
            end
        end
    end
end

-- Written by Jericho Crosby, (Chalwk)

--[[
--=====================================================================================================--
Script Name: Player Alive (timer), for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description:    While playerX is alive, if the timer reaches the elapsed "ALLOCATED_TIME" before they die, do something special.
                It's up to you to code in your "something special" of choice.
                 
                Timer for playerX will reset when:
                    - They quit the game (handled by OnTick)
                    - On Death (handled by PlayerAlive)
                    - Game Ends
                    
                    When the timer reaches the elapsed ALLOCATED_TIME threshold, 
                    it will reset to 0 seconds but not continue counting down until they respawn or rejoin.

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

-- Config --
USE_TIMER = true
-- in seconds (1 minute by default) --
ALLOCATED_TIME = 60
-- Config ends --

-- Do not touch anything below unless you know what you're doing --
TIMER = { }
PLAYERS_ALIVE = { }
api_version = "1.12.0.0"
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

function secondsToTime(seconds, places)
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60
    if places == 2 then
        return minutes, seconds
    end
end

function OnTick()
    if (USE_TIMER == true) then
        for i = 1, 16 do
            if player_present(i) then
                if (TIMER[i] ~= false and PlayerAlive(i) == true) then
                    local PLAYER_ID = get_var(i, "$n")
                    PLAYERS_ALIVE[PLAYER_ID].TIME_ALIVE = PLAYERS_ALIVE[PLAYER_ID].TIME_ALIVE + 0.030
                    if (PLAYERS_ALIVE[PLAYER_ID].TIME_ALIVE >= math.floor(ALLOCATED_TIME)) then
                        TIMER[i] = false
                        local minutes, seconds = secondsToTime(PLAYERS_ALIVE[PLAYER_ID].TIME_ALIVE, 2)
                        cprint(get_var(i, "$name") .. " has been alive for " .. math.floor(minutes) .. " minute(s) and " .. math.floor(seconds) .. " second(s)")
                        -- do something here --

                        -----------------------
                    end
                end
            end
        end
    end
end

-- Written by Jericho Crosby, (Chalwk)

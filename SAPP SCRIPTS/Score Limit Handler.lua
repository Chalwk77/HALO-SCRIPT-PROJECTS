--[[
--=====================================================================================================--
Script Name: Score Limit Handler, for SAPP (PC & CE)
Description: This mod changes the scorelimit required to win the game based on how many player's are currently online.

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- configuration starts --
message = "The score limit has been updated to $SCORE_LIMIT"
-- time (in seconds) until the initial score is set after the game begins
initial_delay = 10

-- column number represents the current player count...
-- col 1 = 1 player online
-- col 2 = 2 players online ... ect

maps = {
    --                         col 1   col 2    col 3    col 4   col 5   col 6    col 7   col 8    col 9    col 10  col 11   col 12  col 13   col 14   col 15   col 16
    { "infinity",               15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "icefields",              15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "bloodgulch",             15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "timberland",             15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "sidewinder",             15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "deathisland",            15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "dangercanyon",           15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "gephyrophobia",          15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "wizard",                 15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "putput",                 15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "longest",                15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "ratrace",                15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "carousel",               15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "prisoner",               15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "damnation",              15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "hangemhigh",             15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "beavercreek",            15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50},
    { "boardingaction",         15,     nil,     nil,     20,     25,     nil,     30,     nil,     nil,     40,     nil,     45,     nil,     nil,     nil,     50}
}
-- configuration ends --

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerLeave")
    register_callback(cb["EVENT_GAME_START"], "OnNewGame")
end

function OnScriptUnload()

end

function OnNewGame()
    current_players = 0
    clock = os.clock()
    secondary = false
end

function OnPlayerJoin(PlayerIndex)
    current_players = current_players + 1
    if (secondary == true) then
        update_score = true
    end
end

function OnPlayerLeave(PlayerIndex)
    current_players = current_players - 1
end

function OnTick()
    if (clock ~= nil) then
        local countdown_timer = math.floor(os.clock())
        if (countdown_timer == tonumber(initial_delay)) then
            countdown_timer = 0
            secondary = true
            clock = nil
            SetScoreLimit()
        end
    end
    if (update_score == true) then
        update_score = false
        SetScoreLimit()
    end
end

function SetScoreLimit()
    if (current_players >= 1) then
        for k,v in pairs(maps) do
            if get_var(0, "$map") == maps[k][1] then
                if v[current_players+1] == nil then
                    current_scorelimit = read_byte(read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3) + 0x164)
                    scorelimit = current_scorelimit
                else
                    scorelimit = v[current_players+1]
                    execute_command('scorelimit ' .. tonumber(scorelimit))
                    say_all(string.gsub(message, "$SCORE_LIMIT", scorelimit))
                end
            end
        end
    end
    return scorelimit
end

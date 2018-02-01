--[[
--=====================================================================================================--
 Script Name: Score Limit Handler, for SAPP (PC & CE)
 Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
 * Notice: You can use this document subject to the following conditions:
 https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
 * Written by Jericho Crosby (Chalwk)
 --=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- configuration starts --
message = "The score limit has been updated to $SCORE_LIMIT"
maps = {
    { "infinity",               nil, 8, 11, 14, 17, 20, nil, 26, 29, 32, 35, nil, 41, 44, 47, 50},
    { "icefields",              5, 8, 11, 14, nil, 20, 23, 26, nil, 32, nil, 38, 41, 44, 47, 50},
    { "bloodgulch",             nil, nil, 11, 14, 17, nil, nil, 26, 29, nil, 35, 38, 41, nil, 47, 50},
    { "timberland",             5, 8, nil, 14, 17, 20, nil, 26, 29, 32, nil, 38, 41, 44, 47, 50},
    { "sidewinder",             5, 8, 11, 14, nil, 20, 23, 26, 29, nil, 35, 38, nil, nil, 47, 50},
    { "deathisland",            5, 8, 11, 14, nil, 20, 23, 26, nil, 32, 35, 38, 41, 44, 47, 50},
    { "dangercanyon",           nil, 8, 11, 14, 17, 20, nil, 26, 29, 32, nil, 38, 41, nil, 47, 50},
    { "gephyrophobia",          5, 8, 11, nil, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 50},
    { "wizard",                 nil, 8, 11, 14, 17, 20, 23, 26, 29, nil, 35, nil, 41, 44, 47, 50},
    { "putput",                 5, 8, 11, 14, nil, 20, nil, nil, nil, 32, 35, 38, 41, nil, 47, 50},
    { "longest",                5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, nil, 44, 47, 50},
    { "ratrace",                nil, 8, 11, 14, 17, 20, nil, 26, nil, 32, 35, 38, 41, 44, 47, 50},
    { "carousel",               5, 8, nil, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, nil, 47, 50},
    { "prisoner",               5, 8, 11, 14, nil, 20, 23, 26, 29, nil, 35, 38, 41, 44, 47, 50},
    { "damnation",              nil, 8, 11, 14, 17, nil, 23, nil, nil, 32, 35, nil, 41, 44, 47, 50},
    { "hangemhigh",             nil, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 50},
    { "beavercreek",            5, 8, 11, nil, 17, 20, 23, nil, 29, 32, 35, nil, 41, 44, 47, 50},
    { "boardingaction",         5, 8, 11, 14, 17, 20, nil, 26, 29, 32, 35, nil, 41, 44, 47, 50}
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
    mapname = get_var(0, "$map")
    current_players = 0
end

function OnPlayerJoin(PlayerIndex)
    current_players = current_players + 1
    update_score = true
end

function OnPlayerLeave(PlayerIndex)
    current_players = current_players - 1
end

function OnTick()
    if (update_score == true) then
        update_score = false
        CheckScoreLimit()
        execute_command('setscore ' .. scorelimit)
    end
end

function CheckScoreLimit()
    for k,v in pairs(maps) do
        if mapname == maps[k][1] then
            if v[current_players+1] == nil then
	            current_scorelimit = read_byte(read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3) + 0x164)
                scorelimit = current_scorelimit
            else
                scorelimit = v[current_players+1]
            end
        end
    end
    return say_all(string.gsub(message, "$SCORE_LIMIT", scorelimit)), scorelimit
end

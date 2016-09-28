--[[
------------------------------------
Script Name: HPC Set Respawn-Time (per map), for SAPP
- Implementing API version: 1.11.0.0
- Script Version: v2

Description:    This script will allow you to set player respawn time (in seconds) on a per map basis.

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.11.0.0"
map_respawn_settings = { }

-- ** Map Resapwn Time settings (in seconds) **
beavercreek_time = 3.5
bloodgulch_time = 2.5
boardingaction_time = 5
carousel_time = 2.5
dangercanyon_time = 3.5
deathisland_time = 4
gephyrophobia_time = 4
icefields_time = 2.5
infinity_time = 4
sidewinder_time = 5
timberland_time = 3.5
hangemhigh_time = 2.5
ratrace_time = 4
damnation_time = 2.5
putput_time = 3.5
prisoner_time = 3.5
wizard_time = 4.5

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], "OnPlayerKill")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    map_name = get_var(1, "$map")
    LoadMaps()
end

function OnScriptUnload()
    map_respawn_settings = { }
end

function OnPlayerKill(PlayerIndex)
    if map_name == "beavercreek" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, beavercreek_time * 33)
    end

    if map_name == "bloodgulch" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, bloodgulch_time * 33)
    end

    if map_name == "boardingaction" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, boardingaction_time * 33)
    end

    if map_name == "carousel" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, carousel_time * 33)
    end

    if map_name == "chillout" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, chillout_time * 33)
    end

    if map_name == "damnation" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, damnation_time * 33)
    end

    if map_name == "dangercanyon" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, dangercanyon_time * 33)
    end

    if map_name == "deathisland" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, deathisland_time * 33)
    end

    if map_name == "gephyrophobia" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, gephyrophobia_time * 33)
    end

    if map_name == "hangemhigh" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, hangemhigh_time * 33)
    end

    if map_name == "icefields" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, icefields_time * 33)
    end

    if map_name == "infinity" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, infinity_time * 33)
    end

    if map_name == "longest" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, longest_time * 33)
    end

    if map_name == "prisoner" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, prisoner_time * 33)
    end

    if map_name == "putput" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, putput_time * 33)
    end

    if map_name == "ratrace" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, ratrace_time * 33)
    end

    if map_name == "sidewinder" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, sidewinder_time * 33)
    end

    if map_name == "timberland" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, timberland_time * 33)
    end

    if map_name == "wizard" then
        local player = get_player(PlayerIndex)
        write_dword(player + 0x2C, wizard_time * 33)
    end
end	

function LoadMaps()
    map_respawn_settings = {
        "beavercreek",
        "bloodgulch",
        "boardingaction",
        "carousel",
        "chillout",
        "damnation",
        "dangercanyon",
        "deathisland",
        "gephyrophobia",
        "hangemhigh",
        "icefields",
        "infinity",
        "longest",
        "prisoner",
        "putput",
        "ratrace",
        "sidewinder",
        "timberland",
        "wizard"
    }
    map_name = get_var(1, "$map")
    map_respawn_settings[map_name] = map_respawn_settings[map_name] or false
end
    
function OnNewGame()
    LoadMaps()
end

function OnGameEnd()
    map_respawn_settings = { }
end
    
function OnError(Message)
    print(debug.traceback())
end
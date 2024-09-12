--[[
--======================================================================================================--
Script Name: Game Countdown, for SAPP (PC & CE)
Description: Shows the game time remaining in the following format: 00:00:00

Copyright (c) 2020-2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--======================================================================================================--
]]--

local output = 'Game Countdown: %02d:%02d:%02d'

api_version = '1.12.0.0'

local game_in_progress
local timelimit_address
local tick_counter_address
local sv_map_reset_tick_address

function OnScriptLoad()

    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    --
    -- Signatures found by Kavawuvi:
    --
    local tick_counter_sig = sig_scan("8B2D????????807D0000C644240600")
    if (tick_counter_sig == 0) then
        return
    end
    local sv_map_reset_tick_sig = sig_scan("8B510C6A018915????????E8????????83C404")
    if (sv_map_reset_tick_sig == 0) then
        return
    end
    local timelimit_location_sig = sig_scan("8B0D????????83C8FF85C97E17")
    if (timelimit_location_sig == 0) then
        return
    end
    --

    timelimit_address = read_dword(timelimit_location_sig + 2)
    sv_map_reset_tick_address = read_dword(sv_map_reset_tick_sig + 7)
    tick_counter_address = read_dword(read_dword(tick_counter_sig + 2)) + 0xC

    OnStart()
end

function OnStart()
    game_in_progress = (get_var(0, '$gt') ~= 'n/a')
end

function OnEnd()
    game_in_progress = false
end

local function Say(p, m)
    for _ = 1, 25 do
        rprint(p, ' ')
    end
    rprint(p, m)
end

local floor, format = math.floor, string.format
local function SecondsToTime(seconds)
    local hr = floor(seconds / 3600)
    local min = floor((seconds - (hr * 3600)) / 60)
    local sec = floor(seconds - (hr * 3600) - (min * 60))
    return format(output, hr, min, sec)
end

function OnTick()
    if game_in_progress then
        local timelimit = read_dword(timelimit_address)
        local tick_counter = read_dword(tick_counter_address)
        local sv_map_reset_tick = read_dword(sv_map_reset_tick_address)
        local time_remaining = SecondsToTime(floor((timelimit - (tick_counter - sv_map_reset_tick)) / 30))
        for i = 1, 16 do
            if player_present(i) then
                Say(i, time_remaining)
            end
        end
    end
end

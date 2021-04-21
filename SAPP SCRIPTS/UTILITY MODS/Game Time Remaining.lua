--[[
--======================================================================================================--
Script Name: Game Time Remaining, for SAPP (PC & CE)
Description: This script will print the game time remaining in the following format: H:M:S

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--======================================================================================================--
]]--

api_version = "1.12.0.0"
-- Config Begins --
local alignment = "|l" -- Left = l, Right = r, Center = c, Tab: t
-- Config Ends --

local game_in_progress
local timelimit_address
local tick_counter_address
local sv_map_reset_tick_address

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    -- Credits to Kavawuvi for these signatures:
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
    tick_counter_address = read_dword(read_dword(tick_counter_sig + 2)) + 0xC
    sv_map_reset_tick_address = read_dword(sv_map_reset_tick_sig + 7)
    timelimit_address = read_dword(timelimit_location_sig + 2)
    --
end

function OnGameStart()
    if get_var(0, "$gt") ~= "n/a" then
        game_in_progress = true
    end
end

function OnGameEnd()
    game_in_progress = false
end

local function cls(p)
    for _ = 1, 25 do
        rprint(p, " ")
    end
end

local floor, format = math.floor, string.format
local function SecondsToClock(seconds)
    seconds = tonumber(seconds)
    if (seconds <= 0) then
        return "00:00:00";
    else
        local hours, mins, secs
        hours = format("%02.f", floor(seconds / 3600));
        mins = format("%02.f", floor(seconds / 60 - (hours * 60)));
        secs = format("%02.f", floor(seconds - hours * 3600 - mins * 60));
        return hours .. ":" .. mins .. ":" .. secs
    end
end

function OnTick()
    if (game_in_progress) then

        local a = read_dword(timelimit_address)
        local b = read_dword(tick_counter_address)
        local c = read_dword(sv_map_reset_tick_address)

        local time_remaining = floor((a - (b - c)) / 30)
        for i = 1, 16 do
            if player_present(i) then
                cls(i)
                rprint(i, alignment .. SecondsToClock(time_remaining))
            end
        end
    end
end
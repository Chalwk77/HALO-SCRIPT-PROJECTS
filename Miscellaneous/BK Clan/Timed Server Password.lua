--[[
--======================================================================================================--
Script Name: Timed Server Password (v1.0), for SAPP (PC & CE)
Description: This script will automatically remove the server password after a given amount of time.

Planned feature:
      There will be a future update for this script.
      Version 1.1 will have an option to init the countdown timer immediately after a new server password is set.
      Currently, the timer begins as soon as a new game starts.

For @Rev - BK Clan.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)

--======================================================================================================--
]]--
-- Config [starts] ------------------------------
local duration = 300 -- in seconds
-- Config [ends] --------------------------------

api_version = "1.12.0.0"

local server, time_scale = {}, 0.03333333333333333
local floor, format = math.floor, string.format

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    if (get_var(0, "$gt") ~= "n/a") then
        StartTimer()
    end
end

function OnScriptUnload()

end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        StartTimer()
    end
end

function OnTick()
    if (server.init) then
        server.time = server.time + time_scale
        local delta_time = ((duration) - (server.time))
        local minutes, seconds = select(1, secondsToTime(delta_time)), select(2, secondsToTime(delta_time))
        print("Server Password will be removed in: " .. minutes .. ":" .. seconds)

        local time_up = ((tonumber(minutes) <= 0) and (tonumber(seconds) <= 0))
        if (time_up) then
            execute_command('sv_password ""')
            StopTimer()
            for i = 1,16 do
                if player_present(i) then
                    say(i, "Server password has been automatically removed.")
                end
            end
        end
    end
end

function StartTimer()
    server.time, server.init = 0, true
end

function StopTimer()
    server.time, server.init = 0, false
end

function secondsToTime(seconds)
    local seconds = tonumber(seconds)
    if (seconds <= 0) then
        return "00", "00";
    else
        local hours, mins, secs = format("%02.f", floor(seconds / 3600));
        mins = format("%02.f", floor(seconds / 60 - (hours * 60)));
        secs = format("%02.f", floor(seconds - hours * 3600 - mins * 60));
        return mins, secs
    end
end

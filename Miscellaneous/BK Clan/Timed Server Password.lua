--[[
Script Name: Timed Server Password (v1.0), for SAPP (PC & CE)
Description: This script will automatically remove the server password after X seconds.

For @Rev - BK Clan.

Copyright (c) 2020-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
]]--

-- Config [starts] ------------------------------
local duration = 300 -- in seconds
-- Config [ends] --------------------------------

api_version = "1.12.0.0"

local server, time_scale = {}, 1 / 30
local floor, format = math.floor, string.format

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_COMMAND"], "OnCommand")
    register_callback(cb["EVENT_GAME_START"], "StartTimer")
    StartTimer()
end

local function Respond(Ply, MSG)
    if (Ply == 0) then
        cprint(MSG)
        return
    end
    rprint(Ply, MSG)
end

function OnScriptUnload()
    -- N/A
end

function StartTimer()
    if (get_var(0, "$gt") ~= "n/a") then
        server.time, server.init = 0, true
    end
end

local function TimerRemaining(s)

    s = tonumber(s)
    if (s <= 0) then
        return "00", "00";
    end

    local h, m = format("%02.f", floor(s / 3600));
    m = format("%02.f", floor(s / 60 - (h * 60)));
    s = format("%02.f", floor(s - h * 3600 - m * 60));
    return m, s
end

function OnTick()
    if (server.init) then
        server.time = server.time + time_scale
        local delta_time = ((duration) - (server.time))
        local m, s = TimerRemaining(delta_time)
        local time_up = ((tonumber(m) <= 0) and (tonumber(s) <= 0))
        if (time_up) then
            execute_command('sv_password ""')
            server.time, server.init = 0, false
            say_all("Server password has been removed!")
        end
    end
end

function OnCommand(Ply, CMD, _)

    local Args = { }
    for Params in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end

    if (#Args > 0 and Args[1] == "sv_password") then
        if (Ply == 0 or tonumber(get_var(Ply, "$lvl")) >= 4 and Args[2]) then
            StartTimer()
            Respond(Ply, "Server password will be removed in " .. duration .. " seconds")
        end
    end
end
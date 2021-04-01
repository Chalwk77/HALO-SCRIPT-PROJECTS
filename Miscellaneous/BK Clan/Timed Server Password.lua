--[[
Script Name: Timed Server Password (v1.0), for SAPP (PC & CE)
Description: This script will automatically remove the server password after X seconds.

Script Updated: 02/04/2021
                1). Refactored some code (improvements)
                2). Added option to re initialise countdown when manually setting new server p/w

For @Rev - BK Clan.

Copyright (c) 2020-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
]]--

-- Config [starts] ------------------------------
local duration = 300 -- in seconds
-- Config [ends] --------------------------------

api_version = "1.12.0.0"

local server, time_scale = {}, 1 / 30
local floor, format = math.floor, string.format
local gmatch, lower = string.gmatch, string.lower

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_CHAT"], "ChatCommand")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    OnGameStart()
end

function OnScriptUnload()

end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        StartTimer()
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

        -- debugging:
        -- print("Server Password will be removed in: " .. m .. ":" .. s)

        local time_up = ((tonumber(m) <= 0) and (tonumber(s) <= 0))
        if (time_up) then
            execute_command('sv_password ""')
            StopTimer()
            say_all("Server password has been removed!")
        end
    end
end

function StartTimer()
    server.time, server.init = 0, true
end

function StopTimer()
    server.time, server.init = 0, false
end

local function CMDSplit(CMD)
    local Args = { }
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[#Args + 1] = lower(Params)
    end
    return Args
end

local function IsCommand(Str)
    return (Str:sub(1,1) == "/" or Str:sub(1,1) == "\\")
end

local function IsAdmin(Ply)
    return (tonumber(get_var(Ply, "$lvl")) >= 4) or (Ply == 0)
end

function ChatCommand(Ply, MSG, _)
    if IsCommand(MSG) then
        local Args = CMDSplit(MSG)
        if (Args and Args[1] ==  "/sv_password") then
            if IsAdmin(Ply) and (Args[2]) then
                StartTimer()
                rprint(Ply, "Server password will be removed in " .. duration .. " seconds")
            end
        end
    end
end
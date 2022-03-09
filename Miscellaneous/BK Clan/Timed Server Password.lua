--[[
Script Name: Timed Server Password (v1.1), for SAPP (PC & CE)
Description: This script will automatically remove the server password after X seconds.

For @Rev - BK Clan.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
]]--

-- Config [starts] ------------------------------
local duration = 1 -- in seconds
-- Config [ends] --------------------------------

api_version = '1.12.0.0'

local countdown
local time = os.time

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'StartTimer')
    StartTimer()
end

function StartTimer()
    countdown = nil
    if (get_var(0, '$gt') ~= 'n/a') then
        countdown = time() + duration
    end
end

function OnTick()
    if (countdown and time() >= countdown) then
        countdown = nil
        execute_command('sv_password ""')
        say_all('Server password has been removed!')
    end
end

local function CommandArgs(CMD)
    local args = { }
    for arg in CMD:gmatch('([^%s]+)') do
        args[#args + 1] = arg:lower()
    end
    return args
end

local function Allowed(Ply)
    return (Ply == 0 or tonumber(get_var(Ply, '$lvl')) >= 4)
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

function OnCommand(Ply, CMD, _)
    local args = CommandArgs(CMD)
    if (#args > 0 and args[1] == 'sv_password') then
        if (Allowed(Ply) and args[2]) then
            StartTimer()
            Respond(Ply, 'Server password will be removed in ' .. duration .. ' seconds')
        end
    end
end

function OnScriptUnload()
    -- N/A
end
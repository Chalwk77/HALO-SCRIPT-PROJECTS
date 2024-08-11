--[[
Script Name: Timed Server Password (v1.1), for SAPP (PC & CE)
Description: This script will automatically remove the server password after X seconds.

For @Rev - BK Clan.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
]]--

-- Config [starts] ------------------------------
local duration = 300 -- in seconds
-- Config [ends] --------------------------------

api_version = '1.12.0.0'

local time, countdown = os.time

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

local function stringSplit(str)
    local args = { }
    for arg in str:gmatch('([^%s]+)') do
        args[#args + 1] = arg:lower()
    end
    return args
end

local function allowed(player)
    return (player == 0 or tonumber(get_var(player, '$lvl')) >= 4)
end

local function send(player, message)
    return (player == 0 and cprint(message) or rprint(player, message))
end

function OnCommand(player, command, _)
    local args = stringSplit(command)
    if (#args > 0 and args[1] == 'sv_password' and allowed(player) and args[2]) then
        StartTimer()
        send(player, 'Server password will be removed in ' .. duration .. ' seconds')
    end
end

function OnScriptUnload()
    -- N/A
end
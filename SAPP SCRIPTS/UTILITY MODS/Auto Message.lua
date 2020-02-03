--[[
--=====================================================================================================--
Script Name: Auto Message (utility), for SAPP (PC & CE)
Description: This script will cycle (in order from first-to-last) through a list of pre-defined
             custom messages and broadcast them every x seconds.

You can broadcast a message on demand with /broadcast [id].
Command Syntax: 
    /broadcast list
        * Output Format:
        -------- MESSAGES --------
        [1] line 1
        [2] line 2
        [3] etc...
    /broadcast [id]
    

Copyright (c) 2019-2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts] --------------------------------------------

-- Custom broadcast command:
local base_command = "broadcast"

-- Minimum admin level required to use /base_command
local privilege_level = 1

-- #Messages
local announcements = {

    { "Like us on Facebook | facebook.com/page_id" },

    { "Follow us on Twitter | twitter.com/twitter_id" },

    { "We are recruiting. Sign up on our website | website url" },

    { "Rules / Server Information" },

    { "announcement 5" },

    { "other information here" }, -- message 6
    -- Repeat the structure to add more entries.
}

-- How often should messages be displayed? (in seconds)
local time_between_messages = 300 -- 300 = 5 minutes

-- Set to 'false' to print messages to player rcon.
local show_announcements_in_chat = true

-- If true, messages will also be printed to server console terminal (in pink).
local show_announcements_on_console = true

local server_prefix = "**SERVER**"
-- Configuration [ends] --------------------------------------------

local match, gmatch = string.match, string.gmatch
local time_scale = 0.03333333333333333

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    if (get_var(0, "$gt") ~= "n/a") then
        StartStopTimer(true)
    end
end

function OnScriptUnload()
    --
end

function OnNewGame()
    StartStopTimer(true)
end

function OnGameEnd()
    StartStopTimer(false)
end

function OnTick()
    if (announcements.init_timer) then
        announcements.countdown = announcements.countdown + time_scale
        if (announcements.countdown >= (time_between_messages)) then
            announcements.countdown = 0
            GetNext()
        end
    end
end

function StartStopTimer(Begin)
    announcements.message_index = 1
    announcements.countdown = 0
    if (Begin) then
        announcements.init_timer = true
    else
        announcements.init_timer = false
    end
end

function GetNext()
    for _ = 1, #announcements do
        if (announcements.message_index == #announcements + 1) then
            announcements.message_index = 1
        end
    end
    Show(announcements[announcements.message_index])
    announcements.message_index = announcements.message_index + 1
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local args = CmdSplit(Command)
    if (args[1] == base_command) then
        local invalid_command = false
        if hasPermission(PlayerIndex) then
            if (args[2] ~= nil) then
                if (args[2] == args[2]:match("list")) then
                    Respond(PlayerIndex, "-------- MESSAGES --------")
                    for i = 1, #announcements do
                        for _, v in pairs(announcements[i]) do
                            Respond(PlayerIndex, "[" .. i .. "] " .. v)
                        end
                    end
                elseif (args[2] == match(args[2], "^%d+$") and args[3] == nil) then
                    Show(announcements[tonumber(args[2])])
                else
                    invalid_command = true
                end
            else
                invalid_command = true
            end
        else
            rprint(PlayerIndex, "Insufficient Permission!")
        end

        if (invalid_command) then
            Respond(PlayerIndex, "Invalid Syntax. Usage: /" .. base_command .. " list|id")
        end

        return false
    end
end

function Respond(PlayerIndex, Message)
    if (PlayerIndex == 0) then
        cprint(Message)
    else
        rprint(PlayerIndex, Message)
    end
end

function Show(Tab)
    for _, Message in pairs(Tab) do
        if (show_announcements_on_console) then
            cprint(Message, 5 + 8)
        end
        if (show_announcements_in_chat) then
            execute_command("msg_prefix \"\"")
            say_all(Message)
            execute_command("msg_prefix \" **" .. server_prefix .. "**\"")
        else
            for i = 1, 16 do
                if player_present(i) then
                    rprint(i, Message)
                end
            end
        end
    end
end

function hasPermission(PlayerIndex)
    local is_console = (PlayerIndex == 0)
    local level = tonumber(get_var(PlayerIndex, "$lvl"))
    if (level >= privilege_level or is_console) then
        return true
    else
        return false
    end
end

function CmdSplit(CMD)
    local t, i = { }, 1;
    for Args in gmatch(CMD, '([^%s]+)') do
        t[i] = Args
        i = i + 1
    end
    return t
end

function secondsToTime(seconds)
    seconds = seconds % 60
    return seconds
end
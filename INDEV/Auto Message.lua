--[[
--=====================================================================================================--
Script Name: Auto Message (utility), for SAPP (PC & CE)
Description: This mod will cycle (in order | first to last) through a list of pre-defined messages and broadcast them every x seconds.

You can broadcast a message on demand with /broadcast [id].
Command Syntax: 
    /broadcast list
        * will output in the following format:
        -------- MESSAGES --------
        [1] line 1
        [2] line 2
        [3] etc...
    /broadcast [id]
    

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts]
prefix = "[Broadcast]"
server_prefix = "**SERVER**"

-- Custom broadcast command:
base_command = "broadcast"

-- Minimum admin level required to use /base_command
min_privilege_level = 1

-- #Errors
insufficient_permission = "Insufficient Permission!"
environment_error = "This command can only be executed by a player"

-- #Messages
announcements = {
    "Like us on Facebook | facebook.com/page_id",
    
    "Follow us on Twitter | twitter.com/twitter_id",
    
    "We are recruiting. Sign up on our website | website url",
    
    "Rules / Server Information",
    
    "announcement 5",
    
    "other information here"
    -- Make sure the last entry in the table doesn't have a comma.
    -- Repeat the structure to add more entries.
}

-- How often should messages be displayed? (in seconds)
time_between_messages = 300 -- 300 = 5 minutes

-- Configuration [ends] -------------------------

init_timer = nil
countdown = 0

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload()
    --
end

function OnNewGame()
    -- start timer
    starting_index = 1
    init_timer = true
end

function OnGameEnd()
    init_timer = false
    countdown = 0
end

function OnTick()
    if (init_timer == true) then
        timeUntilNext()
    end
end

function timeUntilNext()
    countdown = countdown + 0.030
    if (countdown >= (time_between_messages)) then
        countdown = 0
        broadcast()
    end
end

function broadcast()
    -- Broadcast logic
    for i = 1, #announcements do
        if (starting_index == #announcements + 1) then
            starting_index = 1
        end
        local message = announcements[starting_index]
        execute_command("msg_prefix \"\"")
        say_all(message)
        execute_command("msg_prefix \" **" .. server_prefix .. "**\"")
        cprint(message)
        break
    end
    starting_index = starting_index + 1
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local t = tokenizeString(Command)
    if (t[1] == base_command) then
        if (Environment ~= 0) then
            if hasPermission(PlayerIndex) then
                if t[2] ~= nil then 
                    if (t[2] == t[2]:match("list")) then
                        rprint(PlayerIndex, "-------- MESSAGES --------")
                        for i = 1, #announcements do
                            rprint(PlayerIndex, "[" .. i .. "] " .. announcements[i])
                        end
                    elseif (t[2] == string.match(t[2], "^%d+$") and t[3] == nil) then
                        execute_command("msg_prefix \"\"")
                        say_all(announcements[tonumber(t[2])])
                        execute_command("msg_prefix \" **" .. server_prefix .. "**\"")
                    else
                        rprint(PlayerIndex, "Invalid Syntax")
                    end
                else
                    rprint(PlayerIndex, "Invalid Syntax. Usage: /" .. base_command .. " list|id")
                end
            else
                rprint(PlayerIndex, insufficient_permission)
            end
            return false
        else
            cprint(environment_error, 2+8)
            return false
        end
    end
end

function hasPermission(PlayerIndex)
    if (tonumber(get_var(PlayerIndex, "$lvl"))) >= min_privilege_level then
        return true
    else
        return false
    end
end

function tokenizeString(inputString, Separator)
    if Separator == nil then
        Separator = "%s"
    end
    local t = { };
    i = 1
    for str in string.gmatch(inputString, '([^' .. Separator .. ']+)') do
        t[i] = str
        i = i + 1
    end
    return t
end

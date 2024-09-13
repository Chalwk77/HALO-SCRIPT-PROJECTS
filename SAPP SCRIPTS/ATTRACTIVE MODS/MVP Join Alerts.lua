--[[
--=====================================================================================================--
Script Name: MVP Join Alerts, for SAPP (PC & CE)
Description: This mod will automatically broadcast a special message when an MVP joins!
             Each MVP can have a unique message, and general welcome messages are available for other players.
             Supports IP Addresses & Hashes

Copyright (c) 2020-2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Config starts here:

local MVP = {
    ['127.0.0.1'] = 'YO! MVP $name has joined the server!',
    ['xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'] = '$name, a brother from another mother has joined!',
    ['AnotherPlayerName'] = 'Welcome, $name! Glad you could join us!',
}

local GENERAL_WELCOME_MESSAGES = {
    'Welcome to the server, $name!',
    'Hello $name, glad to have you!',
    'Hey $name, enjoy your stay!',
}

local server_prefix = '**SAPP**'

api_version = '1.12.0.0'

-- Config ends here.

-- Utility Functions
local function send(message, name)
    execute_command('msg_prefix ""')
    local finalMessage = message:gsub('$name', name)
    say_all(finalMessage)
    execute_command('msg_prefix "' .. server_prefix .. '"')
end

local function getPlayerInfo(Ply)
    local ip = get_var(Ply, '$ip'):match('%d+.%d+.%d+.%d+')
    local hash = get_var(Ply, 'hash')
    local name = get_var(Ply, '$name')
    return ip, hash, name
end

local function getWelcomeMessage(ip, hash)
    return MVP[hash] or MVP[ip] or GENERAL_WELCOME_MESSAGES[math.random(#GENERAL_WELCOME_MESSAGES)]
end

-- Event Handlers
function OnJoin(Ply)
    local ip, hash, name = getPlayerInfo(Ply)
    local message = getWelcomeMessage(ip, hash)
    send(message, name)
end

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
end

function OnScriptUnload()
    -- N/A
end
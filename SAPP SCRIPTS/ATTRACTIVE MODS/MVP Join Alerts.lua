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

-- A table containing custom welcome messages for certain IPs or player hashes
local MVP = {
    ['127.0.0.1'] = 'YO! MVP $name has joined the server!',
    ['xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'] = '$name, a brother from another mother has joined!',
    ['AnotherPlayerName'] = 'Welcome, $name! Glad you could join us!',
}

-- A table containing general welcome messages that will be used for other players
local GENERAL_WELCOME_MESSAGES = {
    'Welcome to the server, $name!',
    'Hello $name, glad to have you!',
    'Hey $name, enjoy your stay!',
}

-- A message relay function temporarily removes the server prefix,
-- and restores it to this when it's finish:
local server_prefix = '**SAPP**'

api_version = '1.12.0.0'

-- Config ends here.

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
end

local function send(message, name)
    execute_command('msg_prefix ""')
    local finalMessage = message:gsub('$name', name)
    say_all(finalMessage)
    execute_command('msg_prefix "' .. server_prefix .. '"')
end

function OnJoin(Ply)

    local ip = get_var(Ply, '$ip'):match('%d+.%d+.%d+.%d+')
    local hash = get_var(Ply, 'hash')
    local name = get_var(Ply, '$name')

    local mvp = MVP[hash] or MVP[ip]
    if mvp then
        send(mvp, name)
    else
        local general_messages = #GENERAL_WELCOME_MESSAGES + 1
        local chosen_msg = GENERAL_WELCOME_MESSAGES[rand(1, general_messages)]
        send(chosen_msg, name)
    end
end

function OnScriptUnload()
    -- N/A
end
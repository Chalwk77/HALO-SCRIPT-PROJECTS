--[[
--=====================================================================================================--
Script Name: MVP Join Alerts, for SAPP (PC & CE)
Description: This mod will automatically broadcast a special message when an MVP joins!
             Each MVP can have a unique message!

             Supports IP Addresses & Hashes

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- The $name placeholder will be replaced with the players name automagically:
--
local MVP = {
    ['127.0.0.1'] = 'YO! MVP $name has joined the server!',
    ['xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'] = '$name, a brother from another mother has joined!'
}

-- A message relay function temporarily removes the server prefix,
-- and restores it to this when it's finish:
local server_prefix = '**SAPP**'

-- Config Ends ------------

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
end

function OnJoin(Ply)

    local ip = get_var(Ply, '$ip'):match('%d+.%d+.%d+.%d+')
    local hash = get_var(Ply, 'hash')

    local mvp = (MVP[hash] or MVP[ip])
    if (mvp) then
        execute_command('msg_prefix ""')
        say_all(mvp:gsub('$name', get_var(Ply, '$name')))
        execute_command('msg_prefix "' .. server_prefix .. '"')
    end
end

function OnScriptUnload()
    -- N/A
end

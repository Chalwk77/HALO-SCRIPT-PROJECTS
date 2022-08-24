--[[
--=====================================================================================================--
Script Name: Ping Checker, for SAPP (PC & CE)
Description: A simple addon to check your ping (or others)

Copyright (c) 2020-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts:

-- Custom ping command:
--
local ping_command = 'ping'

-- Minimum permission level to execute the custom command:
--
local permission_level = -1

-- Message to omit when you execute the custom command:
-- The $name & $ping placeholders get replaced automagically.
--
local output = '$name: $ping'
-- config ends (do not touch anything below this point)

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
end

local function HasAccess(Ply)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    return (Ply == 0 or lvl >= permission_level)
end

local function CMDSplit(s)
    local args = {}
    for arg in s:gmatch('([^%s]+)') do
        args[#args + 1] = arg:lower()
    end
    return args
end

local function Respond(Ply, Str)
    return (Ply == 0 and cprint(Str) or rprint(Ply, Str))
end

function OnCommand(Ply, CMD, _, _)

    local args = CMDSplit(CMD)
    if (args and args[1] == ping_command and HasAccess(Ply)) then

        local player = (args[2] and tonumber(args[2]))
        if (player and player_present(player)) then

            local ping = get_var(player, '$ping')
            local name = get_var(player, '$name')
            local str = output :
            gsub('$ping', ping):
            gsub('$name', name)

            Respond(Ply, str)
        else
            Respond(Ply, 'Invalid Player ID or Player not online!')
        end

        return false
    end
end

function OnScriptUnload()
    -- N/A
end

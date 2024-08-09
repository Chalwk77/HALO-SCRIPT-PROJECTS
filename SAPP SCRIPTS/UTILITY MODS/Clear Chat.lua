--[[
--=====================================================================================================--
Script Name: Clear Chat, for SAPP (PC & CE)
Description: A simple script that allows you to clear the global server chat.

* Command Syntax: /clear

Copyright (c) 2016-2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]

api_version = '1.12.0.0'

-- config starts

-- Custom Command used to clear chat:
--
local command = "clear"

-- Minimum permission level required to execute the custom command:
--
local permission_level = 1


-- A message relay function temporarily removes the server prefix
-- and restores it to this when finished:
local prefix = "**ADMIN**"

-- config ends

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnCommand")
end

local function Send(Ply, Str)
    return (Ply == 0 and cprint(Str) or rprint(Ply, Str))
end

local function IsAdmin(Ply)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    return (Ply == 0 or lvl >= permission_level)
end

function OnCommand(Ply, CMD)

    if (CMD:sub(1, command:len()):lower() == command) then
        if IsAdmin(Ply) then
            execute_command('msg_prefix ""')
            for _ = 1, 20 do
                say_all(" ")
            end
            execute_command('msg_prefix "' .. prefix .. '"')
            Send(Ply, "Chat was cleared")
        else
            Send(Ply, 'Insufficient Permission')
        end
        return false
    end
end

function OnScriptUnload()
    -- N/A
end

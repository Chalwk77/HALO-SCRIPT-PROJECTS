--[[
--=====================================================================================================--
Script Name: Clear Chat, for SAPP (PC & CE)
Description: A simple script that allows you to clear the global server chat. 

Command Syntax: /clear or /cc
     
Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

~ Written by Jericho Crosby (Chalwk)

- This script is included in the Velocity Multi-Mod with many improvements.
--=====================================================================================================--
]]

api_version = '1.12.0.0'

-- config starts

-- Minimum admin level required to use /clear command
min_admin_level = 1

-- Server Prefix
server_prefix = "**SERVER** "
-- config ends

-- do not touch...
function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload()

end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local t = tokenizestring(Command)
    if PlayerIndex ~= -1 and PlayerIndex >= 1 and PlayerIndex < 16 then
        if t[1] == "cc" or t[1] == "clear" then
            if (tonumber(get_var(PlayerIndex, "$lvl"))) >= min_admin_level then
                for i = 1,20 do
                    execute_command("msg_prefix \"\"")
                    say_all(" ")
                    execute_command("msg_prefix \" " .. server_prefix .. " \"")
                end
                rprint(PlayerIndex, "Chat was cleared")
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
            return false
        end
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { };
    i = 1
    for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
        t[i] = str
        i = i + 1
    end
    return t
end

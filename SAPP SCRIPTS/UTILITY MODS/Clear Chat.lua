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
local command_aliases = {"cc", "clear"}

local permission_level = 1

local server_prefix = "**SERVER**"
-- config ends

local lower, upper, gmatch = string.lower, string.upper, string.gmatch

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnServerCommand(Executor, Command, _, _)
    local Args = CMDSplit(Command)
	if (Args == nil or Args == "") then
		return
	else
		Args[1] = lower(Args[1]) or upper(Args[1])
		for CmdIndex = 1,#command_aliases do
			if (Args[1] == command_aliases[CmdIndex]) then
				local level = tonumber(get_var(Executor, "$lvl"))
				if (level >= permission_level or Executor == 0) then
					for _ = 1, 20 do
						execute_command("msg_prefix \"\"")
						say_all(" ")
						execute_command("msg_prefix \" " .. server_prefix .. " \" ")
					end
					Send(Executor, "Chat was cleared")
				else
					Send(Executor, "Insufficient Permission")
				end
				return false
			end
        end
    end
end

function Send(Executor, Message)
	if (Executor == 0) then
		cprint(Message)
	else
		rprint(Executor, Message)
	end
end

function CMDSplit(CMD)
    local t, i = {}, 1
    for Args in gmatch(CMD, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

function OnScriptUnload()

end

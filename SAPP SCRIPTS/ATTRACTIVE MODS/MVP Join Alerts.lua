--[[
--=====================================================================================================--
Script Name: MVP Join Alerts, for SAPP (PC & CE)
Description: This mod will automatically broadcast a special message when an MVP joins! 
             Each MVP can have a unique message!

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

-- Config Starts ------------

-- This script temporarily removes the server prefix while broadcasting a message relay.
-- The prefix will be restored to this when the relay is finished (put your prefix here):
local server_prefix = "**SAPP**"

local MVPS = {

	-- {IP or HASH, MESSAGE},

	-- Example 1 (IP): 
	{"127.0.0.1", "YO! MVP %name% has joined the server!"},
	-- Example 2 (hash): 
	{"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", "YO! MVP %name% has joined the server!"},
}

-- Config Ends ------------

api_version = "1.12.0.0"

function OnScriptLoad()
	register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
end

function OnPlayerConnect(PlayerIndex)
	local ip = get_var(PlayerIndex, "$ip"):match("%d+.%d+.%d+.%d+")
	local hash = get_var(PlayerIndex, "hash")
	for k,v in pairs(MVPS) do
		if (k) and (v[1] == ip or v[1] == hash) then
			local name = get_var(PlayerIndex, "$name")
			local message = string.gsub(v[2], "%%name%%", name)
			execute_command("msg_prefix \"\"")
			say_all(message)
			execute_command("msg_prefix \" " .. server_prefix .. "\" ")
		end
	end 
end

function OnScriptUnload()
	
end

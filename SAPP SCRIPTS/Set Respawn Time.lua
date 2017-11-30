--[[
--=====================================================================================================--
Script Name: Set Respawn Time, for SAPP | (PC & CE)

- Implementing API version: 1.11.0.0

Description: This script will allow you to set the (global) player-respawn-time (in seconds)

* When you start your server, the script will set the default respawn time to "RespawnTime" - (see line 27) indefinitely, 
unless an admins changes the respawn time manually with the custom command.

Command Syntax: /respawntime <number>


Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

api_version = "1.11.0.0"

-- Configuration Starts --
RespawnTime = 5 -- (in seconds) | This will be the default respawn time when the script is initialized.
-- Minimum admin level required to use /respawntime command
ADMIN_LEVEL = 1
-- Custom command to type
command = "respawntime"

-- Globally announce that the respawn time has changed? true|false, true = yes, false = no
ANNOUNCE_CHANGE = true
message = "Attention: The respawn time is now $VALUE second(s)"

-- Message to send non-admins
no_permission = "You do not have permission to execute that command!"
-- Configuration Ends -

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], "OnPlayerKill")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload()
	unregister_callback(cb['EVENT_DIE'])
end

function OnPlayerKill(player_index)
	local player = get_player(player_index)
	write_dword(player + 0x2C, RespawnTime * 33)
end

function OnServerCommand(PlayerIndex, Command)
    local response = nil
    local t = tokenizestring(Command)
    if t[1] ~= nil then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= ADMIN_LEVEL then
			if (t[1] == string.lower(command)) then
				response = false
				if not string.match(t[2], "%d") then
					say(PlayerIndex, "Please enter a number!")
                else
					value = tonumber(t[2])
					unregister_callback(cb['EVENT_DIE'])
					register_callback(cb['EVENT_DIE'], "setRespawnTime")
					say(PlayerIndex, "Respawn Time set to " .. tostring(value))
					if (ANNOUNCE_CHANGE == true) then
						for i = 1, 16 do
							if player_present(i) then
								if i ~= PlayerIndex then
									say(i, string.gsub(message,"$VALUE",value))
                                end
                            end
                        end
						
                    end
                end
            end
        else
			response = false
			say(PlayerIndex, no_permission)
        end
    end
	return response
end

function setRespawnTime(player_index)
	local player = get_player(player_index)
	write_dword(player + 0x2C, value * 33)
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { }; i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function OnError(Message)
    print(debug.traceback())
end

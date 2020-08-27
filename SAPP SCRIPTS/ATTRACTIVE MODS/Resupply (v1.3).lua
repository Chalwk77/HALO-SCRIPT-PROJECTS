--[[
--=====================================================================================================--
Script Name: Resupply (v1.3), for SAPP (PC & CE)
Description: Use a custom command to resupply your inventory with grenades and ammo.
		     
			 Updated 28-08-20 (refactored some code)

Copyright (c) 2019-2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts] ----------
local command_aliases = {"res", "sup", "resupply"}
local privilege_level = -1
local ammo, mag = 200, 500
local grenades = 4
local battery = 100 -- Full battery
local message = "[RESUPPLY] +%ammo% ammo, +%mag% mag, +%grenades% grenades, %battery%% battery"
-- Configuration [ends] ------------

local lower, gsub = string.lower, string.gsub
function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
end

local function checkAccess(e)
    if (e ~= -1 and e >= 1 and e < 16) then
        if (tonumber(get_var(e, "$lvl"))) >= privilege_level then
            return true
        else
            rprint(e, "Command failed. Insufficient Permission.")
        end
    else
		cprint("This command cannot be executed from console.", 12)
    end
	return false
end

local function CMDSplit(Str)
    local Args, index = { }, 1
    for Params in gmatch(Str, "([^%s]+)") do
        Args[index] = Params
        index = index + 1
    end
    return Args
end

function OnServerCommand(PlayerIndex, Command)

    local CMD = CMDSplit(Command)
    if (#CMD == 0) then
        return
    else

		CMD[1] = CMD[1]:lower()
		local executor = tonumber(PlayerIndex)
		local response
		
		for i = 1,#command_aliases do
			if (CMD[1] == lower(command_aliases[i])) then
				if (checkAccess(executor)) then
					if (CMD[2] == nil) then
						if player_alive(executor) then
							for weapon = 1, 4 do
								execute_command("ammo " .. executor .. " " .. ammo .. " " .. weapon)
								execute_command("mag " .. executor .. " " .. mag .. " " .. weapon)
								execute_command("battery " .. executor .. " " .. battery .. " " .. weapon)
							end
							execute_command("nades " .. executor .. " " .. grenades)
							rprint(executor, gsub(gsub(gsub(gsub(message, "%%ammo%%", ammo), "%%mag%%", mag), "%%grenades%%", grenades), "%%battery%%", battery))
						else
							rprint(executor, "Please wait until you respawn.")
						end
					else
						rprint(executor, "Invalid syntax. Usage: /" .. command_aliases[i])
					end
				end
				response = false
				break
			end
		end
	end
    return response
end

--[[
--=====================================================================================================--
Script Name: Resupply Ammo, for SAPP (PC & CE)
Description:

Copyright (c) 2019-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-------------------
-- CONFIG STARTS --
-------------------

-- Custom command used to trigger resupply:
--
local command = 'res'

-- Minimum admin level required to execute /command:
-- Default: 1
-- Levels: -1 = public, 1-4 = admins
--
local permission_level = -1

-- Loaded ammo:
--
local ammo = 200

-- Unloaded ammo:
--
local mag = 500

-- Frags:
local frags = 1

-- Plasmas:
local plasmas = 4

-- Battery (100% = full):
local battery = 100

-- Message to omit when you type /<command>
local output = '[RESUPPLY] +$ammo ammo, +$mag mag, +$frags frags, +$plasmas plasmas, +$battery% battery'

-----------------
-- CONFIG ENDS --
-----------------

api_version = '1.12.0.0'

function OnScriptLoad()
	register_callback(cb['EVENT_COMMAND'], 'OnCommand')
end

local function HasPermission(Ply)
	local lvl = tonumber(get_var(Ply, '$lvl'))
	return (lvl >= permission_level)
end

function OnCommand(Ply, CMD)
	if (CMD:sub(1, command:len()):lower() == command) then
		if (HasPermission(Ply)) then

			-- update ammo:
			execute_command('ammo ' .. Ply .. ' ' .. ammo .. ' 5')
			execute_command('mag ' .. Ply .. ' ' .. mag .. ' 5')
			execute_command('battery ' .. Ply .. ' ' .. battery .. ' 5')

			-- update grenades:
			execute_command('nades ' .. Ply .. ' ' .. frags .. ' 1')
			execute_command('nades ' .. Ply .. ' ' .. plasmas .. ' 2')

			local str = output
			str = str                :
			gsub('$ammo', ammo)      :
			gsub('$mag', mag)        :
			gsub('$battery', battery):
			gsub('$frags', frags)    :
			gsub('$plasmas', plasmas)
			rprint(Ply, str)
		else
			rprint(Ply, 'Insufficient Permission')
		end

		return false
	end
end

function OnScriptUnload()
	-- N/A
end
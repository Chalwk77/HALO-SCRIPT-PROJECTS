--[[
--=====================================================================================================--
Script Name: Resupply Ammo, for SAPP (PC & CE)
Description: This Lua script provides a configurable command, 'res', for resupplying ammo, grenades, and battery.

Copyright (c) 2019-2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
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
local frags = 4
-- Plasmas:
local plasmas = 4
-- Battery (100% = full):
local battery = 100
-- Message to omit when you type /<command>
local output = '[RESUPPLY] +200 ammo, +500 mag, +4 frags, +4 plasmas, +100% battery'
-- Cooldown time in seconds between resupply requests (0 = no cooldown):
--
local cooldown = 0
-----------------
-- CONFIG ENDS --
-----------------

-- SAPP Lua API Version:
api_version = '1.12.0.0'

local last_resupply = {}

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
end

local function hasPermission(id)
    local lvl = tonumber(get_var(id, '$lvl'))
    return (lvl >= permission_level)
end

function OnCommand(id, cmd)
    if (cmd:sub(1, command:len()):lower() == command) then
        if (hasPermission(id)) then

            -- Check if the player can receive another resupply based on cooldown time
            if (cooldown > 0) then
                local now = os.time()
                if (last_resupply[id] and now < last_resupply[id] + cooldown) then
                    rprint(id, 'You must wait ' .. math.floor(last_resupply[id] + cooldown - now) .. ' more seconds before resupplying.')
                    return false
                else
                    last_resupply[id] = now
                end
            end

            -- update ammo:
            execute_command('ammo ' .. id .. ' ' .. ammo .. ' 5')
            execute_command('mag ' .. id .. ' ' .. mag .. ' 5')
            execute_command('battery ' .. id .. ' ' .. battery .. ' 5')

            -- update grenades:
            execute_command('nades ' .. id .. ' ' .. frags .. ' 1')
            execute_command('nades ' .. id .. ' ' .. plasmas .. ' 2')

            rprint(id, output)
        else

            rprint(id, 'Insufficient Permission')
        end
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
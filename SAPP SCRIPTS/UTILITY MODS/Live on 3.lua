--[[
--=====================================================================================================--
Script Name: Live on 3, for SAPP (PC & CE)
Description: Ya'll know what it is.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
-- Custom command used to trigger Live on Three:
--
local command = 'lo3'

-- Minimum permission level required to execute the custom command:
-- Valid perm levels: -1 to 4 (-1 for all players, including non-admin)
--
local permission = 1
-- config ends --

----------------------------------------------
-- [!] Do not touch anything below this point
-- unless you know what you're doing.
----------------------------------------------

-- SAPP Lua API Version:
api_version = '1.12.0.0'

local count = 3
local kill_message_address
local original_kill_message

-- Called when the script is loaded:
--
function OnScriptLoad()

    -- register needed event callback for the Command Handler:
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    -- Death Message address sigs:
    kill_message_address = sig_scan('8B42348A8C28D500000084C9') + 3
    original_kill_message = read_dword(kill_message_address)

    OnStart()
end

-- Called when a new game has begun:
-- Ensures var "count" is reset.
-- Important if an admin manually loads/reloads this script.
function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        count = 3
    end
end

-- Responsible for enabling or disabling stock death messages:
--
local function PatchDeathMsgs(address, value)
    safe_write(true)
    write_dword(address, value)
    safe_write(false)
end

-- Map reset function:
-- @return (recursively calls itself it count > 0)
--
function sv_map_reset()

    count = count - 1
    execute_command('sv_map_reset')
    say_all('Live on ' .. count + 1)

    -- enable default death messages:
    if (count <= 0) then
        PatchDeathMsgs(kill_message_address, original_kill_message)
    end

    return (count > 0)
end

-- Verify that the player has permission to execute the custom command:
-- @param p (Player memory address index) [number]
--
local function HasPerm(P)
    return (P == 0 or tonumber(get_var(P, '$lvl')) >= permission)
end

-- Command Handler:
-- @param Ply (Player memory address index) [number]
-- @param CMD (command string) [string]
--
function OnCommand(Ply, CMD)
    if (CMD:sub(1, command:len()):lower() == command) then

        if not HasPerm(Ply) then
            rprint(Ply, 'Insufficient Permission.')
            return false
        end

        PatchDeathMsgs(kill_message_address, 0x03EB01B1)

        count = 3
        timer(1000, 'sv_map_reset')
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
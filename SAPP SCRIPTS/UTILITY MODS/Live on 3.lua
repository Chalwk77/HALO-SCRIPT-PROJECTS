--[[
--=====================================================================================================--
Script Name: Live on 3, for SAPP (PC & CE)
Description: Ya'll know what it is.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local command = 'lo3'

-- Minimum permission level required to execute lo3 command:
local permission = 1

api_version = '1.12.0.0'

local kill_message_address
local original_kill_message

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    kill_message_address = sig_scan('8B42348A8C28D500000084C9') + 3
    original_kill_message = read_dword(kill_message_address)
end

local count = 3
function sv_map_reset()

    count = count - 1
    execute_command('sv_map_reset')
    say_all('Live on ' .. count + 1)

    safe_write(true)
    write_dword(kill_message_address, original_kill_message)
    safe_write(false)

    return (count > 0)
end

local function HasPerm(P)
    return (P == 0 or tonumber(get_var(P, '$lvl')) >= permission)
end

function OnCommand(Ply, CMD)
    if (CMD:sub(1, command:len()):lower() == command) then

        if not HasPerm(Ply) then
            rprint(Ply, 'Insufficient Permission.')
            return false
        end

        safe_write(true)
        write_dword(kill_message_address, 0x03EB01B1)
        safe_write(false)

        count = 3
        timer(1000, 'sv_map_reset')
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
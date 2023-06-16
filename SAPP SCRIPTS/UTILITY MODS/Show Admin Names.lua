--[[
--=====================================================================================================--
Script Name: Show Admin Names, for SAPP (PC & CE)
Description: Prints the name and level of admins who are currently online.

Copyright (c) 2021-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local command = 'whois'

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], 'CheckAdmins')
end

local function isAdmin(Ply)
    local level = tonumber(get_var(Ply, "$lvl"))
    return (level > 0 and level) or nil
end

function CheckAdmins(Ply, CMD)
    if (CMD:sub(1, command:len()):lower() == command) then
        for i = 1, 16 do
            if player_present(i) then
                local level = isAdmin(i)
                if (level) then
                    rprint(Ply, get_var(i, '$name') .. ' [level: ' .. level .. ']')
                end
            end
        end
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
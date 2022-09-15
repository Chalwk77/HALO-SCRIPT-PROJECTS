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

local function IsAdmin(Ply)
    local lvl = tonumber(get_var(Ply, "$lvl"))
    return (lvl > 0 and lvl) or nil
end

function CheckAdmins(Ply, CMD)
    if (CMD:sub(1, command:len()):lower() == command) then
        for i = 1, 16 do
            if player_present(i) then
                local lvl = IsAdmin(i)
                if (lvl) then
                    rprint(Ply, get_var(i, '$name') .. ' [level: ' .. lvl .. ']')
                end
            end
        end
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
--[[
--=====================================================================================================--
Script Name: Command Spy, for SAPP (PC & CE)
Description:    This script will show commands typed by non-admins (to admins).
                Admins wont see their own commands (:

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

local output_format = "[SPY] %name%: %command%"

local commands_to_hide = {
    -- Add your command here to hide it from command spy feedback.
    "/command1",
    "/command2",
    "/command3",
    "/command4",
    "/command5"
    -- Repeat the structure to add more commands.
}

api_version = "1.12.0.0"

local gmatch = string.gmatch
local gsub = string.gsub

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

local function CMDSplit(Str)
    local Args, index = { }, 1
    for Params in gmatch(Str, "([^%s]+)") do
        Args[index] = Params
        index = index + 1
    end
    return Args
end

function OnServerCommand(Ply, Command, _, _)

    local CMD = CMDSplit(Command)
    if (#CMD == 0) then
        return
    else

        CMD[1] = CMD[1]:lower()

        for i = 1, #commands_to_hide do
            if (CMD[1] == commands_to_hide[i]) then
                return
            end
        end

        local pLvL = tonumber(get_var(Ply, "$lvl"))
        if (pLvL == -1) then
            local name = get_var(Ply, "$name")
            for i = 1, 16 do
                if player_present(i) and (i ~= Ply) then
                    local aLvL = tonumber(get_var(i, "$lvl"))
                    if (aLvL >= 1) then

                        local cmd = ''
                        for i = 1, #CMD do
                            cmd = cmd .. CMD[i] .. " "
                        end

                        local str = gsub(gsub(output_format, "%%name%%", name), "%%cmd%%", cmd)
                        rprint(i, str)
                    end
                end
            end
        end
    end
end

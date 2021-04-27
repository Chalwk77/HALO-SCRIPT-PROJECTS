--[[
--=====================================================================================================--
Script Name: Command Spy, for SAPP (PC & CE)
Description:    This script will show commands typed by non-admins (to admins).
                Admins wont see their own commands (:

Copyright (c) 2020-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local output_format = {
    -- RCON:
    [1] = "[R-SPY] %name%: %cmd%",
    -- CHAT:
    [2] = "[C-SPY] %name%: /%cmd%",
}

-- If true, you will not see admin commands:
local ignore_admins = false

-- Add commands to be ignored:
local commands_to_hide = {
    "/command1",
    "/command2",
    "/command3",
    "/command4",
    "/command5",
    -- Repeat the structure to add more commands.
}

-- Command(s) containing these key words will not be sent:
local command_blacklist = {
    "login",
    "admin_add",
    "sv_password",
    "change_password",
    "admin_change_pw",
    "admin_add_manually",
}

api_version = "1.12.0.0"

local gsub = string.gsub

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "CommandSpy")
end

local function CMDSplit(STR)
    local Args = { }
    for Params in STR:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end
    return Args
end

--
-- This function checks if the command contains any blacklisted keywords:
--
local function BlackListed(CMD)
    for _, word in pairs(command_blacklist) do
        if CMD:lower():find(word) then
            return true
        end
    end
    return false
end

function CommandSpy(Ply, Command, ENV, _)

    local CMD = CMDSplit(Command)
    if (#CMD and not BlackListed(CMD[1])) then

        for _, v in pairs(commands_to_hide) do
            if (CMD[1] == v) then
                return
            end
        end

        local alvl = tonumber(get_var(Ply, "$lvl"))
        if (not ignore_admins or alvl == -1) then

            local name = get_var(Ply, "$name")
            for i = 1, 16 do
                if player_present(i) and (i ~= Ply) then

                    local bLvL = tonumber(get_var(i, "$lvl"))
                    if (bLvL >= 1) then

                        local cmd = ''
                        for j = 1, #CMD do
                            cmd = cmd .. CMD[j] .. " "
                        end

                        local str = gsub(gsub(output_format[ENV], "%%name%%", name), "%%cmd%%", cmd)
                        rprint(i, str)
                    end
                end
            end
        end
    end
end

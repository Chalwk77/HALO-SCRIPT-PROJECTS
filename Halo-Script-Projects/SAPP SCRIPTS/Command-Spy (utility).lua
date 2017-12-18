--[[
------------------------------------
Script Name: Command Spy (utility), for SAPP | (PC\CE)
    - Implementing API version: 1.11.0.0

Description: Spy on your players commands!
             This script will show commands typed by non-admins (to admins). 
             Admins wont see their own commands (:

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

settings = {
    ["HideCommands"] = true,
}

--=========================================================--
commands_to_hide = {
    -- Add your command here to hide it!
    "/command1",
    "/command2",
    "/command3",
    "/command4",
    "/command5"
    -- Repeat the structure to add more commands.
    }
--=========================================================--

api_version = "1.11.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
end

function OnPlayerChat(PlayerIndex, Message)
    if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 0 then
        AdminIndex = tonumber(PlayerIndex)
    end
    iscommand = nil
    local Message = tostring(Message)
    local command = tokenizestring(Message)
    if string.sub(command[1], 1, 1) == "/" then
        cmd = command[1]:gsub("\\", "/")
        iscommand = true
    else 
        iscommand = false
    end
    for k, v in pairs(commands_to_hide) do
        if (cmd == v) then
            hidden = true
            break
        else
            hidden = false
        end
    end    
    if (tonumber(get_var(PlayerIndex,"$lvl"))) == -1 then
        if (iscommand and PlayerIndex) then
            if (settings["HideCommands"] == true and hidden == true) then
                return false
            elseif (settings["HideCommands"] == true and hidden == false) or (settings["HideCommands"] == false) then
                CommandSpy("[SPY]   " .. get_var(PlayerIndex, "$name") .. ":    \"" .. Message .. "\"", PlayerIndex)
                return true
            end
        end
    end
end

function CommandSpy(Message, AdminIndex) 
    for i = 1,16 do
        if (tonumber(get_var(i,"$lvl"))) >= 1 then
            rprint(i, Message)
        end
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function OnError(Message)
    print(debug.traceback())
end
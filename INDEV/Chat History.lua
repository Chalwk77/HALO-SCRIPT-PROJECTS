--[[
--=====================================================================================================--
Script Name: Chat History, for SAPP (PC & CE)

[!] IN DEVELOPMENT || [!] IN DEVELOPMENT || [!] IN DEVELOPMENT || [!] IN DEVELOPMENT || [!] IN DEVELOPMENT [!]

Planned features:
Lookup chat/command logs for a given user (online or offline)
Lookup chat/command logs for hash
Lookup chat/command logs for ip-address
Bonus feature:
Execute the last chat command you entered with "!c".

Command Syntax:

Chat Logs: /ch -chat [player id || ip || hash] [timeDiff]
Aliases: /chathistory <player id || ip || hash> [timeDiff]

Command Logs: /ch -command [player id || ip || hash] [timeDiff]
Aliases: /commandhistory <player id || ip || hash> [timeDiff]

Time Format
Any commands which denote a [timeDiff] argument can be used as follows:
10s = 10 seconds
10m = 10 minutes
10h = 10 hours
10d = 10 days
10mo = 10 months
10y = 10 years

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
commands = {}
chat_history = {}

local logs = 'sapp\\chat_history.data'

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")

    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")
end

function OnScriptUnload()

end

function OnPlayerConnect(PlayerIndex)
    --

end

function OnPlayerDisconnect(PlayerIndex)
    --

end

function OnPlayerChat(PlayerIndex, Message, Type)
    --

end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    --

end

function tokenizeString(inputString, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = { };
    i = 1
    for str in string.gmatch(inputString, "([^" .. separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

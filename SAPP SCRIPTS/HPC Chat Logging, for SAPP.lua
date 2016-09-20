--[[
------------------------------------
Script Name: HPC Chat Logger V2, for SAPP
    - Implementing API version: 1.10.0.0

Description: This script will log player chat to <sapp server>/Server Chat.txt

* Change log:
    [1] I had to rewrite this script. It was driving me crazy.
    [2] Does the same thing. Just more efficient and clean.
    [3] Seems legit.
    [4] Enjoy.

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.10.0.0"
local dir = 'sapp\\Server Chat.txt'
local scriptname = "chatlogger.lua"

function OnScriptLoad()

    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
end

function OnScriptUnload()

end

function OnNewGame()

    local file = io.open(dir, "a+")
    if file ~= nil then
        local map = get_var(0, "$map")
        local gt = get_var(0, "$mode")
        local n1 = "\n"
        local t1 = os.date("[%A %d %B %Y] - %X - A new game has started on " .. map .. ", Mode: " .. gt)
        local n2 = "\n---------------------------------------------------------------------------------------------\n"
        file:write(n1, t1, n2)
        file:close()
    end
end

function WriteData(dir, value)

    local file = io.open(dir, "a+")
    if file ~= nil then
        local timestamp = os.date("[%H:%M:%S - %d/%m/%Y]    ")
        local chatValue = string.format("%s\t%s\n", timestamp, tostring(value))
        file:write(chatValue)
        file:close()
    end
end

function OnPlayerChat(PlayerIndex, Message)

    local name = get_var(PlayerIndex, "$name")
    local id = get_var(PlayerIndex, "$n")
    local GetChatFormat = string.format("[" .. tonumber(id) .. "]: " ..(tostring(Message)))
    WriteData(dir, name .. " " .. GetChatFormat)
end

function OnError(Message)
    print(debug.traceback())
end

--[[

SAPP will log player chat to the sapp.log file, however, it's difficult to wade through all the other event logs it handles.
Personally, I find it convenient to have a 'dedicated' server chat.txt file. Which is where this script comes into play.

]]

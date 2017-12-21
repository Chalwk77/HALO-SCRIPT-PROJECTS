--[[
--=====================================================================================================--
Script Name: Get Hash (command), for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description: Check yours or someone else's hash
Command Syntax: /hash me|1-16

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

api_version = "1.11.0.0"

-- Custom Command
custom_command = "hash"
-- Message sent to command executor if they type /hash, or /hash me
respondWith1 = "Your hash is $HASH"
-- Message sent to command executor if they type /hash 1-16
respondWith2 = "$PLAYER_NAME's hash is $HASH"
-- Minimum admin level required to execute /hash command. (-1 for all players)
PERMISSION_LEVEL = -1
-- Message Alignment | Left = l,    Right = r,    Center = c,    Tab: t
Alignment = "l"

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload() end

function OnServerCommand(PlayerIndex, Command)
    local UnknownCMD = nil
    local t = tokenizestring(Command)
    if t[1] ~= nil then
        if t[1] == string.lower(custom_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= PERMISSION_LEVEL then
                local index = tonumber(t[2])
                if (t[2] == nil) or(t[2] ~= nil and t[2] == "me") then
                    UnknownCMD = false
                    rprint(PlayerIndex, "|" .. Alignment .. string.gsub(respondWith1, "$HASH", get_var(PlayerIndex, "$hash")))
                elseif (t[2] ~= nil and t[2] ~= "me") then
                    if not string.match(t[2], "%d") then
                        UnknownCMD = false
                        rprint(PlayerIndex, "|" .. Alignment .. "Arg2 was not a number!")
                    else
                        if index ~= nil and index > 0 and index < 17 then
                            if player_present(index) then
                                UnknownCMD = false
                                rprint(PlayerIndex, "|" .. Alignment .. string.gsub(string.gsub(respondWith2, "$PLAYER_NAME", get_var(PlayerIndex, "$name")), "$HASH", get_var(PlayerIndex, "$hash")))
                            else
                                UnknownCMD = false
                                rprint(PlayerIndex, "|" .. Alignment .. "Invalid Player ID!")
                            end
                        end
                    end
                end
            else
                UnknownCMD = false
                rprint(PlayerIndex, "|" .. Alignment .. "You do not have permission to execute that command!")
            end
        end
    end
    return UnknownCMD
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { }; i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function OnError(Message)
    print(debug.traceback())
end

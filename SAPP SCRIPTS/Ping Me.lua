--[[
--=====================================================================================================--
Script Name: Ping Me, for SAPP | (PC & CE)

Description: Display yours or someone else's ping.

Command Syntax: /ping me|1-16


Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

api_version = "1.11.0.0"

custom_command = "ping"
respondWith1 = "Your ping is $PING"
respondWith2 = "$PLAYER_NAME's ping is $PING"
PERMISSION_LEVEL = -1

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload() end

function OnServerCommand(PlayerIndex, Command)
    local silent_UnknownCMD = nil
    local t = tokenizestring(Command)
    if t[1] ~= nil then
        if t[1] == string.lower(custom_command) then
            execute_command("msg_prefix \"\"")
            if tonumber(get_var(PlayerIndex, "$lvl")) >= PERMISSION_LEVEL then
                local index = tonumber(t[2])
                if (t[2] == nil) or(t[2] ~= nil and t[2] == "me") then
                    silent_UnknownCMD = false
                    say(PlayerIndex, string.gsub(respondWith1, "$PING", get_var(PlayerIndex, "$ping")))
                elseif (t[2] ~= nil and t[2] ~= "me") then
                    if not string.match(t[2], "%d") then
                        silent_UnknownCMD = false
                        say(PlayerIndex, "Arg2 was not a number!")
                    else
                        if index ~= nil and index > 0 and index < 17 then
                            if player_present(index) then
                                silent_UnknownCMD = false
                                say(PlayerIndex, string.gsub(string.gsub(respondWith2, "$PLAYER_NAME", get_var(PlayerIndex, "$name")), "$PING", get_var(PlayerIndex, "$ping")))
                            else
                                silent_UnknownCMD = false
                                say(PlayerIndex, "Invalid Player ID!")
                            end
                        end
                    end
                end
            else
                silent_UnknownCMD = false
                say(PlayerIndex, "You do not have permission to execute that command")
            end
            execute_command("msg_prefix \"** SERVER ** \"")
        end
    end
    return silent_UnknownCMD
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

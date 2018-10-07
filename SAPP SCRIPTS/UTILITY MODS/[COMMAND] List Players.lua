--[[
    --=====================================================================================================--
Script Name: [COMMAND] List Players, for SAPP (PC & CE)

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

command = "players"
permission_level = 1

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "CommandGetPlayers")
end

function OnScriptUnload() end

function CommandGetPlayers(PlayerIndex, Command, Environment)
    local UnknownCMD = nil
    local t = tokenizestring(Command)
    if t[1] ~= nil then
        if t[1] == string.lower(command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                for j = 1, 16 do
                    if player_present(j) then
                        local name = get_var(j, "$name")
                        local id = get_var(j, "$n")
                        local player_team = get_var(j, "$team")
                        local ip = get_var(j, "$ip")
                        local hash = get_var(j, "$hash")
                        if get_var(0, "$ffa") == "0" then
                            if player_team == "red" then
                                team = "Red Team"
                            elseif player_team == "blue" then
                                team = "Blue Team"
                            end
                        else
                            team = "FFA"
                        end
                        rprint(PlayerIndex, "Player Search:")
                        rprint(PlayerIndex, "[ ID.    -    Name.    -    Team.    -    IP. ]")
                        rprint(PlayerIndex, " " .. id .. ".   " .. name .. "   |   " .. team .. "  -  IP: " .. ip)
                    end
                end
            else
                rprint(PlayerIndex, "You do not have permission to execute that command.")
            end
            UnknownCMD = false
        end
    end
    return UnknownCMD
end

function tokenizestring(inputString, separator)
    if separator == nil then separator = "%s" end
    local t = { }; i = 1
    for str in string.gmatch(inputString, "([^" .. separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

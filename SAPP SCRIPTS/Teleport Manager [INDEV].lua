--[[
--=====================================================================================================--
Script Name: Teleport Management (utility), for SAPP (PC & CE)
Description: Allows the user to create custom teleports and warp to them on demand.

Warning: This script implements a heavy use of pattern matching (regex) and is extremely complicated. 
         Modify only if you know what you're doing!

Use this command to set a new teleport location
/setportal [teleport name]

Use this command to teleport to the desired teleport location
/tpo [teleport name]

Use this command to list all custom portals
/tplist
             
Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

-- configuration starts --

set_command = "setportal"
goto_command = "tpo"
list_command = "tplist"
sapp_dir = "sapp\\teleports.txt"
permission_level = -1
-- configuration ends  --

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload() end

function OnServerCommand(PlayerIndex, Command, Environment)
    local UnknownCMD = nil
    local t = tokenizestring(Command)
    ---------------------------------------------------------
    -- SET COMMAND --
    if t[1] ~= nil then
        if t[1] == string.lower(set_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                -- do to:
                -- check if portal name already exists
                if t[2] ~= nil then
                    local player = get_dynamic_player(PlayerIndex)
                    local x, y, z = read_vector3d(player + 0x5C)
                    local file = io.open(sapp_dir, "a+")
                    local line = t[2] .. ": X " .. x .. ", Y " .. y .. ", Z " .. z
                    file:write(line, "\n")
                    file:close()
                    say(PlayerIndex, "Teleport location set to: " .. x .. ", " .. y .. ", " .. z)
                else
                    say(PlayerIndex, "Invalid Syntax. Command Usage: /" .. set_command .. " <teleport name>")
                end
            else
                say(PlayerIndex, "You're not allowed to execute /" .. set_command)
            end
            UnknownCMD = false
        end
    end
    ---------------------------------------------------------
    -- GO TO COMMAND --
    if t[1] ~= nil then
        if t[1] == string.lower(goto_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                if t[2] ~= nil then
                    local file = sapp_dir
                    local lines = lines_from(file)
                    for k, v in pairs(lines) do
                        local teleport_name = v:match("[%a%d+_]*")
                        local valid = nil
                        if t[2] == teleport_name then
                            local regex_1 = ("%d+,%s*%d+,%s*%d+")
                            local regex_2 = ("-%d+,%s*-%d+,%s*-%d+")
                            local regex_3 = ("-%d+,%s*%d+,%s*%d+")
                            local regex_4 = ("%d+,%s*-%d+,%s*%d+")
                            local regex_5 = ("%d+,%s*%d+,%s*-%d+")
                            local regex_6 = ("-%d+,%s*-%d+,%s*%d+")
                            local regex_7 = ("-%d+,%s*%d+,%s*-%d+")
                            local regex_8 = ("%d+,%s*-%d+,%s*-%d+")
                            local regex_9 = ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")
                            local regex_10 = ("-%d+.%d+,%s*-%d+.%d+,%s*-%d+.%d+")
                            local regex_11 = ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")
                            local regex_12 = ("%d+.%d+,%s*-%d+.%d+,%s*%d+.%d+")
                            local regex_13 = ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")
                            local regex_14 = ("-%d+.%d+,%s*-%d+.%d+,%s*%d+.%d+")
                            local regex_15 = ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")
                            local regex_16 = ("%d+.%d+,%s*-%d+.%d+,%s*-%d+.%d+")
                            if string.match(v, regex_1) then
                                valid = true
                                local x1 = tostring(string.match(v, "X%s*%d+.%d+"))
                                local y1 = tostring(string.match(v, "Y%s*%d+.%d+"))
                                local z1 = tostring(string.match(v, "Z%s*%d+.%d+"))
                                x = string.gsub(x1, "X%s*%d+.%d+", string.match(x1, "%d+.%d+"))
                                y = string.gsub(y1, "Y%s*%d+.%d+", string.match(y1, "%d+.%d+"))
                                z = string.gsub(z1, "Z%s*%d+.%d+", string.match(z1, "%d+.%d+"))
                            elseif string.match(v, regex_2) then 
                                valid = true
                                local x1 = tostring(string.match(v, "X%s*-%d+.%d+"))
                                local y1 = tostring(string.match(v, "Y%s*-%d+.%d+"))
                                local z1 = tostring(string.match(v, "Z%s*-%d+.%d+"))
                                x = string.gsub(x1, "X%s*-%d+.%d+", string.match(x1, "-%d+.%d+"))
                                y = string.gsub(y1, "Y%s*-%d+.%d+", string.match(y1, "-%d+.%d+"))
                                z = string.gsub(z1, "Z%s*-%d+.%d+", string.match(z1, "-%d+.%d+"))
                            elseif string.match(v, regex_3) then 
                                -- to do
                            elseif string.match(v, regex_4) then 
                                -- to do
                            elseif string.match(v, regex_5) then 
                                -- to do
                            elseif string.match(v, regex_6) then
                                -- to do 
                            elseif string.match(v, regex_7) then
                                -- to do 
                            elseif string.match(v, regex_8) then 
                                -- to do
                            elseif string.match(v, regex_9) then
                                valid = true
                                local x1 = tostring(string.match(v, "X%s*%d+.%d+"))
                                local y1 = tostring(string.match(v, "Y%s*%d+.%d+"))
                                local z1 = tostring(string.match(v, "Z%s*%d+.%d+"))
                                x = string.gsub(x1, "X%s*%d+.%d+", string.match(x1, "%d+.%d+"))
                                y = string.gsub(y1, "Y%s*%d+.%d+", string.match(y1, "%d+.%d+"))
                                z = string.gsub(z1, "Z%s*%d+.%d+", string.match(z1, "%d+.%d+"))
                            elseif string.match(v, regex_10) then
                                -- to do
                            elseif string.match(v, regex_11) then
                                valid = true
                                local x1 = tostring(string.match(v, "X%s*-%d+.%d+"))
                                local y1 = tostring(string.match(v, "Y%s*%d+.%d+"))
                                local z1 = tostring(string.match(v, "Z%s*%d+.%d+"))
                                x = string.gsub(x1, "X%s*-%d+.%d+", string.match(x1, "-%d+.%d+"))
                                y = string.gsub(y1, "Y%s*%d+.%d+", string.match(y1, "%d+.%d+"))
                                z = string.gsub(z1, "Z%s*%d+.%d+", string.match(z1, "%d+.%d+"))
                            elseif string.match(v, regex_12) then
                                -- to do
                            elseif string.match(v, regex_13) then
                                valid = true
                                local x1 = tostring(string.match(v, "X%s*%d+.%d+"))
                                local y1 = tostring(string.match(v, "Y%s*%d+.%d+"))
                                local z1 = tostring(string.match(v, "Z%s*-%d+.%d+"))
                                x = string.gsub(x1, "X%s*%d+.%d+", string.match(x1, "%d+.%d+"))
                                y = string.gsub(y1, "Y%s*%d+.%d+", string.match(y1, "%d+.%d+"))
                                z = string.gsub(z1, "Z%s*-%d+.%d+", string.match(z1, "-%d+.%d+"))
                            elseif string.match(v, regex_14) then
                                -- to do
                            elseif string.match(v, regex_15) then
                                valid = true
                                local x1 = tostring(string.match(v, "X%s*-%d+.%d+"))
                                local y1 = tostring(string.match(v, "Y%s*%d+.%d+"))
                                local z1 = tostring(string.match(v, "Z%s*-%d+.%d+"))
                                x = string.gsub(x1, "X%s*-%d+.%d+", string.match(x1, "-%d+.%d+"))
                                y = string.gsub(y1, "Y%s*%d+.%d+", string.match(y1, "%d+.%d+"))
                                z = string.gsub(z1, "Z%s*-%d+.%d+", string.match(z1, "-%d+.%d+"))
                            elseif string.match(v, regex_16) then
                                -- to do
                            else
                                rprint(PlayerIndex, "Script Error! Coordinates for that teleport do not match the regex expression!")
                                cprint("Script Error! Coordinates for that teleport do not match the regex expression!", 4+8)
                            end
                            if (v ~= nil and valid == true) then
                                write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, tonumber(x), tonumber(y), tonumber(z))
                                rprint(PlayerIndex, "Teleporting to X: " .. x .. " Y: " .. y .. " Z: " .. z)
                                valid = false
                            else
                                cprint("That teleport name is not valid!", 4+8)
                                rprint(PlayerIndex, "That teleport name is not valid!")
                            end
                        end
                    end
                    UnknownCMD = false
                else
                    say(PlayerIndex, "Invalid Syntax. Command Usage: /" .. goto_command .. " <teleport name>")
                end
            else
                say(PlayerIndex, "You're not allowed to execute /" .. goto_command)
            end
            UnknownCMD = false
        end
    end
    ---------------------------------------------------------
    -- LIST COMMAND --
    if t[1] ~= nil then
        if t[1] == string.lower(list_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                local file = sapp_dir
                local lines = lines_from(file)
                for k,v in pairs(lines) do
                    rprint(PlayerIndex, "["..k.."] " .. v)
                end
            else
                say(PlayerIndex, "You're not allowed to execute /" .. list_command)
            end
            UnknownCMD = false
        end
    end
    return UnknownCMD
end

function file_exists(file)
    local File = io.open(file, "rb")
    if File then 
        File:close() 
    end
    return File ~= nil
end

function lines_from(file)
    if not file_exists(file) then 
        return {} 
    end
    lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end

function tokenizestring(inputString, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = { }; i = 1
    for str in string.gmatch(inputString, "([^" .. separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

--[[
--=====================================================================================================--
Script Name: Teleport Management (utility), for SAPP (PC & CE)
Description: Allows the user to create custom teleports and warp to them on demand.

Command Syntax:     /settp [name]
                    /tpo [name]
                    /tplist


Use this command to set a new teleport location
/settp [teleport name]

Use this command to teleport
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
                if t[2] ~= nil then
                    local player = get_dynamic_player(PlayerIndex)
                    local x, y, z = read_vector3d(player + 0x5C)
                    local file = io.open(sapp_dir, "a+")
                    local line = t[2] .. ": " .. x .. ", " .. y .. ", " .. z
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
                        local teleport_name = v:match("[%a%d_]*")
                        if t[2] == teleport_name then
                            local regex_1 = ("(%d+)(,) (%d+)(,) (%d+)")
                            local regex_2 = ("(-)(%d+)(,) (-)(%d+)(,) (-)(%d+)")
                            local regex_3 = ("(-)(%d+)(,) (%d+)(,) (%d+)")
                            local regex_4 = ("(%d+)(,) (-)(%d+)(,) (%d+)")
                            local regex_5 = ("(%d+)(,) (%d+)(,) (-)(%d+)")
                            local regex_6 = ("(-)(%d+)(,) (-)(%d+)(,) (%d+)")
                            local regex_7 = ("(-)(%d+)(,) (%d+(,) (-)(%d+)")
                            local regex_8 = ("(%d+)(,) (-)(%d+)(,) (-)(%d+)")
                            if v:match(regex_1) then
                                cprint("regex_1         data found:         " .. v:match(regex_1), 2+8)
                            elseif v:match(regex_2) then 
                                cprint("regex_2         data found:         " .. v:match(regex_2), 2+8)
                            elseif v:match(regex_3) then 
                                cprint("regex_3         data found:         " .. v:match(regex_3), 2+8)
                            elseif v:match(regex_4) then 
                                cprint("regex_4         data found:         " .. v:match(regex_4), 2+8)
                            elseif v:match(regex_5)     then 
                                cprint("regex_5         data found:         " .. v:match(regex_5), 2+8)
                            elseif v:match(regex_6) then 
                                cprint("regex_6         data found:         " .. v:match(regex_6), 2+8)
                            elseif v:match(regex_7) then 
                                cprint("regex_7         data found:         " .. v:match(regex_7), 2+8)
                            elseif v:match(regex_8) then 
                                cprint("regex_8         data found:         " .. v:match(regex_8), 2+8)
                            else
                                cprint("does not match!", 4+8)
                            end
                            -- local x = v:match("expression")
                            -- local y = v:match("expression")
                            -- local z = v:match("expression")
                            -- write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, x, y, z)
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

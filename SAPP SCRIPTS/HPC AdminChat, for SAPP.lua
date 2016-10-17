--[[
------------------------------------
Script Name: HPC AdminChat, for SAPP
    - Implementing API version: 1.11.0.0

Description: Admin Chat! Chat privately with other admins. 
             Command: /achat on|off
    
    This script is still in development and does not function! 
    Please do not download until an (Updated [date]) tag appears in the file name.

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS
        
Copyright ©2016 Jericho Crosby <jericho.crosby227@gmail.com>

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnAdminChat")
end

api_version = "1.11.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnAdminChat")
end

function OnAdminChat(PlayerIndex, Message)
    name = get_var(PlayerIndex, "$name")
    local t = tokenizestring(Message)
    count = #t
    local Message = tostring(Message)
    local words = tokenizestring(Message)
    if #words == 0 then
        return nil
    end
    achattoggle = nil
    if (tonumber(get_var(PlayerIndex,"$lvl"))) >0 then
        Admin = tonumber(PlayerIndex)
        if Admin then
            if string.sub(t[1], 1, 1) == "/" then
                cmd = t[1]:gsub("\\", "/")
                if cmd == "/achat" then
                    if t[2] == "on" then
                        rprint(PlayerIndex, "Admin Chat Toggled on!")
                        admincaht = true
                        goto achat
                    elseif t[2] == "off" then
                        admincaht = false
                        rprint(PlayerIndex, "Admin Chat Toggled off!")
                        goto achatoff 
                    elseif t[2] == nil then
                        admincaht = false
                        rprint(PlayerIndex, "Invalid Syntax! Type /achat on|off")
                    end
                end
            end
        end
    end
    ::achat::
    if admincaht == true then
        for i = 0, #words do
            if words[i] then
                if string.sub(words[1], 1, 1) == "/" or string.sub(words[1], 1, 1) == "\\" then 
                    return true
                else 
                    AdminChat(Message, Admin) 
                    return false
                end
            end
        end
    end
    ::achatoff::
    if admincaht == false then
        for i = 0, #words do
            if words[i] then
                return
            end
        end
    end
end

function AdminChat(Message, Admin) 
    for i = 1,16 do
        --if i ~= Admin then
            rprint(i, "[ADMIN CHAT]  " .. name.. ":      " .. Message)
        --end
    end
end

function output(Message, PlayerIndex)
    if Message then
        if Message == "" then
            return
        end
        cprint(Message, CommandOutputColor)
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

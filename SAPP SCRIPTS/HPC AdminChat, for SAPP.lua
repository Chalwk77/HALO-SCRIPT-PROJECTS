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

function OnAdminChat(PlayerIndex, Message)
    name = get_var(PlayerIndex, "$name")
    local token = tokenizestring(Message)
    count = #token
    local Message = tostring(Message)
    local adminchat = tokenizestring(Message)
    if #adminchat == 0 then
        return nil
    end
    AdminChatToggle = nil
    if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 0 then 
        Admin = tonumber(PlayerIndex)
        Admin = true 
    else 
        Admin = false 
        RegularPlayer = tonumber(PlayerIndex)
    end    
    if Admin then
        if string.sub(token[1], 1, 1) == "/" then
            cmd = token[1]:gsub("\\", "/")
            if cmd == "/achat" then
                if token[2] == "on" then
                    rprint(PlayerIndex, "Admin Chat Toggled on!")
                    AdminChatToggle = true
                    goto achat
                elseif token[2] == "off" then
                    AdminChatToggle = false
                    rprint(PlayerIndex, "Admin Chat Toggled off!")
                    goto achatoff 
                elseif token[2] == nil then
                    AdminChatToggle = false
                    rprint(PlayerIndex, "Invalid Syntax! Type /achat on|off")
                end
                return false
            end
        end
    else 
        say(PlayerIndex, "You do not have permission to execute that command!")
    end
    ::achat::
    if AdminChatToggle == true then
        for i = 0, #adminchat do
            if adminchat[i] then
                if string.sub(adminchat[1], 1, 1) == "/" or string.sub(adminchat[1], 1, 1) == "\\" then 
                    return true
                else 
                    AdminChat(Message, Admin) 
                    return false
                end
            end
        end
    end
    ::achatoff::
    if AdminChatToggle == false then
        for i = 0, #adminchat do
            if adminchat[i] then
                return
            end
        end
    end
end

function AdminChat(Message, Admin) 
    for i = 1,16 do
        if Admin then
            rprint(i, "[ADMIN CHAT]  " .. name.. ":      " .. Message)
        end
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

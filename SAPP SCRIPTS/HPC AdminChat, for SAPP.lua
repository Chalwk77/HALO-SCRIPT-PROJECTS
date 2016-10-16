--[[
------------------------------------
Script Name: HPC AdminChat, for SAPP
    - Implementing API version: 1.11.0.0

Description: Admin Chat! Chat privately with other admins. 
             Command: /achat on|off
    
    ~ B E T A ~

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

function OnAdminChat(PlayerIndex, Message)
    local t = tokenizestring(Message)
    count = #t
    local Message = tostring(Message)
    achattoggle = nil
    if string.sub(t[1], 1, 1) == "/" then
        cmd = t[1]:gsub("\\", "/")
        if cmd == "/achat" then
            if t[2] == "off" then
                rprint(PlayerIndex, "Admin Chat Toggled off!")
                chattoggle = false
            elseif t[2] == "on" then
               rprint(PlayerIndex, "Admin Chat Toggled on!")
               chattoggle = true
               -----  >>>>  -----
            -- chat   code  here --
               -----  <<<<  -----
            elseif t[20] == nil then
                say(PlayerIndex, "Invalid Syntax - /achat on|off")
                chattoggle = false
            end
            return false
        end
    end    
end

function AdminChat(Message, AdminIndex) 
    for i = 1,16 do
        if i ~= AdminIndex then
            rprint(i, Message)
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

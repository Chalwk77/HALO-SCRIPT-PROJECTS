--[[
------------------------------------
Script Name: AdminChat (utility), for SAPP | (PC\CE)
    - Implementing API version: 1.11.0.0

Description: Admin Chat! Chat privately with other admins. 
             Command: /achat on|off
    
    This script is still in development!
    Please do not download until an "Updated [date]" tag appears in the file name - e,g "HPC AdminChat, for SAPP - updated [xx-10-16]"
    
This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"
function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnAdminChat")
end

function OnScriptUnload() end


function OnAdminChat(PlayerIndex, Message)
    local message = tokenizestring(Message)
    if #message == 0 then
        return nil
    end
    local t = tokenizestring(Message)
    count = #t
    local Message = tostring(Message)
    if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 0 then 
        isadmin = true 
        AdminIndex = tonumber(PlayerIndex)
    else 
        isadmin = false 
        RegularPlayer = tonumber(PlayerIndex)
    end    
    if string.sub(t[1], 1, 1) == "/" then
        cmd = t[1]:gsub("\\", "/")
        if cmd == "/achat" then
            if isadmin then
                if t[2] == "on" or t[2] == "1" or t[2] == "true" then
                    rprint(AdminIndex, "Admin Chat Toggled on!")
                    AdminChatToggle = true
                    cprint("Toggled!", 2+8)
                elseif t[2] == "off" or t[2] == "0" or t[2] == "false" then
                    AdminChatToggle = false
                    rprint(AdminIndex, "Admin Chat Toggled off!")
                    return false
                else
                    AdminChatToggle = false
                    rprint(AdminIndex, "Invalid Syntax! Type /achat on|off")
                    return false
                end
            else 
                rprint(PlayerIndex, "You do not have permission to execute that command!")
            end
            return false
        end
    end
    if AdminChatToggle == true then
        for i = 0, #message do
            if message[i] then
                if string.sub(message[1], 1, 1) == "/" or string.sub(message[1], 1, 1) == "\\" then 
                    return true
                else
                -- TO DO:
                -- Only toggle on adminchat for the player executing the command, but still send their future messages to all admins.
                -- Other admins will be required to also type "/achat on" in order to respond.
--==========================================================================---
                    for i = 1,16 do                                         --- FIX
                        if (tonumber(get_var(i,"$lvl"))) >= 0 then          --- FIX
                            admin = tonumber(i)                             --- FIX
--==========================================================================---
                            if isadmin then
                                rprint(admin, "[ADMIN CHAT]  " .. get_var(AdminIndex, "$name") .. ":  " .. Message)
                            else
                                return true
                            end
                        end
                    end
                    return false
                end
            end
        end
    end
    if AdminChatToggle == false then
        for i = 0, #message do
            if message[i] then
                return
            end
        end
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

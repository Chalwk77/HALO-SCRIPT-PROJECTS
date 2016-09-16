--[[    
------------------------------------
Script Name: HPC Chat Logging, SAPP
    - Implementing API version: 1.10.0.0
    
Description: This script will log player chat to /logs/Server Chat.txt
    
Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.10.0.0"

WriteToFile = true
local fileDirectory = "logs\\Server Chat.txt"

function OnScriptUnload( )
    
end

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
end

function OnPlayerChat(PlayerIndex, Message)

    local name = get_var(PlayerIndex, "$name")
    local id = get_var(PlayerIndex, "$n")
    local GetChatFormat = string.format("["..get_var(PlayerIndex, "$n").."]: " ..(tostring(Message)))
    
	WriteLog(fileDirectory, name.. ": " ..GetChatFormat)
end

function WriteLog(fileDirectory, value)
	local file = io.open(fileDirectory, "a")
    if file then
    	if WriteToFile == true then
            local timestamp = os.date("%H:%M:%S - %d/%m/%Y")
            local line = string.format("%s\t%s\n", timestamp, tostring(value))
            file:write(line)
            file:close()
        end
    else
        -- If the file(s) /logs/Server Chat.txt do not exist, we call CreateDirectory() to produce them.
        cprint("ERROR: <writelog.lua> = [Function] on WriteLog() - File not Found: " ..fileDirectory)
        cprint("Creating file(s)..")
        CreateDirectory()
	end
end

function CreateDirectory()
    local file = io.open(fileDirectory, "a")
    if file == nil then
        os.execute("mkdir logs")
        createFile = io.open( "logs\\Server Chat.txt", "w+" )
        local line = string.format("File(s) Created!\n")
        createFile:write( line )
        createFile:close()
    else
    return false -- File already exists!
    end
end

function OnError(Message)
    print(debug.traceback())
end
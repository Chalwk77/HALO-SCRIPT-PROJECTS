--[[
------------------------------------
Script Name: HPC SyncAdmins, for SAPP
    - Implementing API version: 1.11.0.0

Description: This script will sync your admins.txt file with a remote server
Credits to 002 for HTTP Code: https://github.com/Halogen002/SAPP-HTTP-Client

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

TO DO:
. File Encoding

Copyright ©2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"

function OnScriptLoad() 
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    SyncAdmins() 
    admin_table = {}
    users_table = {}
end
-- Change this url accordingly.
url = 'http://example.com/files/'
admins = 'sapp\\admins.txt'
users = 'sapp\\users.txt'
prefix = "[SCRIPT] - SyncAdmins.lua|n"
Sync_Admins = true
Sync_Users = true
-- Backup Solution. 
admin_table = {
--      <username(1-11)>:<hash>:<admin level(0-4)
        "PlayerName1:a4fe9d916197f408e3af0033f1ee78fe:4", 
        "PlayerName2:a4fe9d916197f408e3af0033f1ee78fe:4", 
        "PlayerName3:a4fe9d916197f408e3af0033f1ee78fe:4", 
        "PlayerName4:a4fe9d916197f408e3af0033f1ee78fe:4", 
        "PlayerName5:a4fe9d916197f408e3af0033f1ee78fe:4", 
        "PlayerName6:a4fe9d916197f408e3af0033f1ee78fe:4", 
    }
users_table = {
--      <username(1-11)>:[index#]:<hash>:<admin level(0-4):
        "PlayerName1:0:6c8f0bc306e0108b4904812110185edd:4:",
        "PlayerName2:1:6c8f0bc306e0108b4904812110185edd:4:",
        "PlayerName3:2:6c8f0bc306e0108b4904812110185edd:4:",
        "PlayerName4:3:6c8f0bc306e0108b4904812110185edd:4:",
        "PlayerName5:4:6c8f0bc306e0108b4904812110185edd:4:",
        "PlayerName5:5:6c8f0bc306e0108b4904812110185edd:4:",
    }
function SyncAdmins(executor, Command, PlayerIndex, count)
    admin_page = GetPage(tostring(url) .. "admins.txt")
    users_page = GetPage(tostring(url) .. "users.txt")
    PlayerIndex = tonumber(PlayerIndex)
    response = nil
    if Sync_Admins then
        if admin_page == nil then 
            respond('Error: ' .. url .. 'admins.txt does not exist or the remote server is offline.', PlayerIndex)
            BackupSolutionAdmins(executor, Command, PlayerIndex, count)
            response = false
        else
            response = true
            if string.find(admin_page, "[A-Za-z0-9]:[1-4]") == nil then
                response = false
                respond('Error: Failed to read from admins.txt on remote server.', PlayerIndex)
            end
            if response then
                local file = io.open(admins, "w")
                local line = tokenizestring(admin_page, "*")
                for i = 1, #line do
                    file:write(line[i])
                    respond('Syncing Admins...|n' .. line[i], PlayerIndex)
                end
                file:close()
                respond('admins.txt successfully Synced!|n', PlayerIndex)
            end
        end
    end
    if Sync_Users then
        if users_page == nil then 
            respond('Error: ' .. url .. 'users.txt does not exist or the remote server is offline.', PlayerIndex)
            BackupSolutionUsers(executor, Command, PlayerIndex, count)
            response = false
        else
            response = true
            if string.find(users_page, "[A-Za-z0-9]:[1-4]:") == nil then
                response = false
                respond('Error: Failed to read from users.txt on remote server.', PlayerIndex)
            end
            if response then
                local file = io.open(users, "w")
                local line = tokenizestring(users_page, "*")
                for i = 1, #line do
                    file:write(line[i])
                    respond('Syncing Users...|n' .. line[i], PlayerIndex)
                end
                file:close()
                respond('users.txt successfully Synced!|n', PlayerIndex)
            end
        end
    end
    return response
end

function respond(Message, PlayerIndex)
	if Message then
		if Message == "" then 
			return 
		elseif type(Message) == "table" then
			Message = Message[1]
		end
		PlayerIndex = tonumber(PlayerIndex)
		if tonumber(PlayerIndex) and PlayerIndex ~= nil and PlayerIndex ~= -1 and PlayerIndex >= 0 and PlayerIndex < 16 then
            cprint("Response to: " .. get_var(PlayerIndex, "$name"), 4+8)
            cprint(Message, 2+8)
            rprint(PlayerIndex, Message)
		else
			cprint(Message, 2+8)
		end
	end
end

function OnScriptUnload() end

function BackupSolutionAdmins(executor, Command, PlayerIndex, count)
    respond('Going to backup solution...', PlayerIndex)
    if Sync_Admins then
        local file = io.open(admins, "w")
        for i = 2, #admin_table do
            file:write(admin_table[i], "\n")
            respond(admin_table[i], PlayerIndex)
        end
        file:close()
        respond('admins.txt successfully Synced!|n', PlayerIndex)
    end
end

function BackupSolutionUsers(executor, Command, PlayerIndex, count)
    respond('Going to backup solution...', PlayerIndex)
    if Sync_Users then
        local file = io.open(users, "w")
        for i = 2, #users_table do
            file:write(users_table[i], "\n")
            respond(users_table[i], PlayerIndex)
        end
        file:close()
        respond('users.txt successfully Synced!|n', PlayerIndex)
    end
end

function OnServerCommand(PlayerIndex, Command)
	local isadmin = nil
	if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 1 then 
        isadmin = true 
    else 
        isadmin = false 
    end
	local t = tokenizestring(Command)
	local count = #t
	if t[1] == "sync" or t[1] == "sv_sync_admins" then
        if isadmin then
            SyncAdmins(PlayerIndex, t[1], count)
        else 
            respond("You do not have permission to execute \"" .. Command .. "\"", PlayerIndex)
        end
    return false
    end
end

-- Found this neat little function here:
-- http://stackoverflow.com/questions/1426954/split-string-in-lua
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

-- 002's Code
ffi = require("ffi")
ffi.cdef [[
    typedef void http_response;
    http_response *http_get(const char *url, bool async);
    void http_destroy_response(http_response *);
    void http_wait_async(const http_response *);
    bool http_response_is_null(const http_response *);
    bool http_response_received(const http_response *);
    const char *http_read_response(const http_response *);
    uint32_t http_response_length(const http_response *);
]]
http_client = ffi.load("lua_http_client")

function GetPage(URL)
    local response = http_client.http_get(URL, false)
    local returning = nil
    if http_client.http_response_is_null(response) ~= true then
        local response_text_ptr = http_client.http_read_response(response)
        returning = ffi.string(response_text_ptr)
    end
    http_client.http_destroy_response(response)
    return returning
end

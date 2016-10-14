--[[
------------------------------------
Script Name: HPC SyncAdmins, for SAPP
- Implementing API version: 1.11.0.0

Description: This script will sync your admins.txt and users.txt files with a remote server.
An automatic backup solution will kick in if the host is offline/unavailable.

Credits to 002 for HTTP Code: https://github.com/Halogen002/SAPP-HTTP-Client

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

-------------------------------
TO DO LIST:
[!] This script does not function properly due to SAPP encoding the admin/users.txt files in UCS-2 LE BOM.
I am working on a solution!
It does however, work perfectly fine if the files are in ANSI/UTF-8 format.

. File Encoding
. Minor Tweaking
-------------------------------

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
    SyncUsers()
    admin_table = {}
    users_table = {}
end

function OnScriptUnload() end

-- Configuration --
-- Change this url accordingly.
url = 'http://example.com/files/'
admins = 'sapp\\admins.txt'
users = 'sapp\\users.txt'

settings = {
    ["Sync_Admins"] = true,
    ["Sync_Users"] = true,
    ["BackupMethod"] = true
}

local users_table = {
    -- Usernames can only have 11 characters!
    --      <username(1-11)>:[index#]:<hash>:<admin level(0-4):
    "PlayerName1:0:f443106bd82fd6f3c22ba2df7c5e4094:4:",
    "PlayerName2:1:c702226e783ea7e091c0bb44c2d0ec64:1:",
    "PlayerName3:2:d72b3f33bfb7266a8d0f13b37c62fddb:2:",
    "PlayerName4:3:55d368354b5021e7dd5d3d1525a4ab82:1:",
    "PlayerName5:4:3d5cd27b3fa487b040043273fa00f51b:3:",
    "PlayerName6:5:b661a51d4ccf44f5da2869b0055563cb:3:"
}

-- Backup Solution. 
local admin_table = {
    -- Usernames can only have 11 characters!
    --      <username(1-11)>:<hash>:<admin level(0-4)
    "PlayerName1:f443106bd82fd6f3c22ba2df7c5e4094:4", 
    "PlayerName2:c702226e783ea7e091c0bb44c2d0ec64:1", 
    "PlayerName3:d72b3f33bfb7266a8d0f13b37c62fddb:2", 
    "PlayerName4:55d368354b5021e7dd5d3d1525a4ab82:1", 
    "PlayerName5:3d5cd27b3fa487b040043273fa00f51b:3", 
    "PlayerName6:b661a51d4ccf44f5da2869b0055563cb:3"
}
-- Configuration Ends --

function OnServerCommand(PlayerIndex, Command)
    local isadmin = nil
    if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 1 then 
        isadmin = true 
    else 
        isadmin = false 
    end
    local t = tokenizestring(Command)
    error = "You do not have permission to execute /" .. Command
    if t[1] == "sync" and t[2] == "admins" then
        if isadmin then SyncAdmins()
        else 
            respond(error, PlayerIndex)
        end
        return false
    elseif t[1] == "sync" and t[2] == "users" then
        if isadmin then SyncUsers()
        else 
            respond(error, PlayerIndex)
        end
        return false
    elseif t[1] == "sync" and t[2] == "all" then
        if isadmin then SyncUsers() SyncAdmins()
        else 
            respond(error, PlayerIndex)
        end
        return false
    end
end

function SyncAdmins(Message, PlayerIndex)
    admin_url = GetPage(tostring(url) .. "admins.txt")
    response = nil
    if settings["Sync_Admins"] then
        if admin_url == nil then 
            respond('Script Error:', PlayerIndex)
            respond(url .. 'admins.txt does not exist or the remote server is offline.', PlayerIndex)
            if settings["BackupMethod"] then 
                BackupSolutionAdmins(Message, PlayerIndex)
            else
                respond('Script Error: [BackupMethod] disabled - Unable to sync admins.txt', PlayerIndex)
            end
            response = false
        else
            response = true
            if string.find(admin_url, "[A-Za-z0-9]:[1-4]") == nil then
                respond('Script Error: Failed to read from admins.txt on remote server.', PlayerIndex)
                if settings["BackupMethod"] then 
                    BackupSolutionAdmins(Message, PlayerIndex)
                else
                    respond('Script Error: [BackupMethod] disabled - Unable to sync admins.txt', PlayerIndex)
                end
                response = false
            end
            if response then
                local file = io.open(admins, "w")
                local line = tokenizestring(admin_url, "\n")
                respond('Syncing Admins...', PlayerIndex)
                for i = 1, #line do
                    file:write(line[i])
                    respond(line[i], PlayerIndex)
                end
                file:close()
                respond('admins.txt successfully Synced|n', PlayerIndex)
            end
        end
    else
        respond('Script Error: [Sync_Admins] setting disabled - Please enable it first.', PlayerIndex)
    end
    return response
end

function SyncUsers(Message, PlayerIndex)
    users_url = GetPage(tostring(url) .. "users.txt")
    response = nil
    if settings["Sync_Users"] then
        if users_url == nil then 
            respond('Script Error:', PlayerIndex)
            respond(url .. 'users.txt does not exist or the remote server is offline.', PlayerIndex)
            if settings["BackupMethod"] then 
                BackupSolutionUsers(Message, PlayerIndex)
            else
                respond('Script Error: [BackupMethod] disabled - Unable to sync users.txt', PlayerIndex)
            end
            response = false
        else
            response = true
            if string.find(users_url, "[A-Za-z0-9]:[1-4]:") == nil then
                respond('Script Error: Failed to read from users.txt on remote server.', PlayerIndex)
                if settings["BackupMethod"] then
                    BackupSolutionUsers(Message, PlayerIndex)
                else
                    respond('Script Error: [BackupMethod] disabled - Unable to sync users.txt', PlayerIndex)
                end
                response = false
            end
            if response then
                local file = io.open(users, "w")
                local line = tokenizestring(users_url, "\n")
                respond('Syncing Users...', PlayerIndex)
                for i = 1, #line do
                    file:write(line[i])
                    respond(line[i], PlayerIndex)
                end
                file:close()
                respond('users.txt successfully Synced|n', PlayerIndex)
            end
        end
    else
        respond('Script Error: [Sync_Users] setting disabled - Please enable it first.', PlayerIndex)
    end
    return response
end

function BackupSolutionAdmins(Message, PlayerIndex)
    respond('Going to backup solution...', PlayerIndex)
    local file = io.open(admins, "w")
    for i = 1, #admin_table do
        file:write(admin_table[i], "\n")
        respond(admin_table[i], PlayerIndex)
    end
    file:close()
    respond('admins.txt successfully Synced.', PlayerIndex)
end

function BackupSolutionUsers(Message, PlayerIndex)
    respond('Going to backup solution...', PlayerIndex)
    local file = io.open(users, "w")
    for i = 1, #users_table do
        file:write(users_table[i], "\n")
        respond(users_table[i], PlayerIndex)
    end
    file:close()
    respond('users.txt successfully Synced.', PlayerIndex)
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
            cprint(Message, 2+8)
            rprint(PlayerIndex, Message)
            note = string.format('[SyncAdminsUtility] -->> ' .. get_var(PlayerIndex, "$name") .. ': ' .. Message)
            execute_command("log_note \""..note.."\"")
        else
            cprint(Message, 2+8)
            v1note = string.format('[SyncAdminsUtility]: ' .. Message)
            execute_command("log_note \""..v1note.."\"")
        end
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

function OnError(Message)
    print(debug.traceback())
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

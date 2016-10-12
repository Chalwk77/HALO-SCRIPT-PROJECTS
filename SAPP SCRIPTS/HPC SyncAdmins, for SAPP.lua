--[[
------------------------------------
Script Name: HPC SyncAdmins, for SAPP
    - Implementing API version: 1.11.0.0

Description: This script will sync your admins.txt file with a remote server
Credits to 002 for HTTP Code: https://github.com/Halogen002/SAPP-HTTP-Client

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright ©2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"

function OnScriptLoad() SyncAdmins() end
-- Change this url accordingly.
url = "http://example.com/files"
admins = 'sapp\\admins.txt'
users = 'sapp\\users.txt'
prefix = "[SCRIPT] - SyncAdmins.lua|n"
Sync_Admins = true
Sync_Users = true
function SyncAdmins()
    admin_page = GetPage(tostring(url) .. "admins.txt")
    users_page = GetPage(tostring(url) .. "users.txt")
    if Sync_Admins then
        if admin_page == nil then 
            cprint(prefix .. "Error: " .. url .. "admins.txt does not exist or the remote server is offline.", 4+8)
        else
            proceed = true
            if string.find(admin_page, "%s*") == nil then
                proceed = false
                cprint(prefix .. "Error: Failed to read from admins.txt on remote server.", 4+8)
            end
            if proceed then
                local file = io.open(admins, "w")
                local line = tokenizestring(admin_page, "*")
                for i = 1, #line do
                    file:write(line[i])
                    cprint("Syncing Admins...|n" .. line[i], 2+8)
                end
                file:close()
                cprint("admins.txt successfully Synced!|n", 2+8)
            end
        end
    end
    if Sync_Users then
        if users_page == nil then 
            cprint(prefix .. "Error: " .. url .. "users.txt does not exist or the remote server is offline.", 4+8)
        else
            proceed = true
            if string.find(users_page, "%s*") == nil then
                proceed = false
                cprint(prefix .. "Error: Failed to read from users.txt on remote server.", 4+8)
            end
            if proceed then
                local file = io.open(users, "w")
                local line = tokenizestring(users_page, "*")
                for i = 1, #line do
                    file:write(line[i])
                    cprint("Syncing Users...|n" .. line[i], 2+8)
                end
                file:close()
                cprint("users.txt successfully Synced!|n", 2+8)
            end
        end
    end
end

function OnScriptUnload() end

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

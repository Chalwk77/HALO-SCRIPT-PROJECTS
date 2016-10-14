--[[
Script Name: HPC Admin Utility, for SAPP - (updated 14-10-16)
- Implementing API version: 1.11.0.0

    Description: Type "/admin me" in chat to add yourself as an admin - (level 4 by default)
                 This was particuarly useful to me when testing other scripts.
                 I'm sure you can think of some creative reasons to use this.

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS
    
Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
]]

-- Admin level
level = "4"
api_version = "1.11.0.0"

function OnScriptLoad( )
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    LoadTables( )
end

function OnScriptUnload() end

function LoadTables( )
    namelist = {
        "Billy", -- Example
        "Magneto", -- Example
        "name-not-used",
        "name-not-used",
        "name-not-used"
    }	
    hashlist = {
        "f1d7c0018b1648d7d48fe57ec35a9660", -- Example
        "e891e0a75336a75f9d03bb5e51a530dd", -- Example
        "hash-not-used",
        "hash-not-used",
        "hash-not-used"
    }
    iplist = {
--      Be sure to include port number seperated by a colon.
--      xxx.xxx.xxx.xxx:0000
        "121.73.21.53:2305", -- Example
        "204.147.144.85:2309", -- Example
        "ip-not-used",
        "ip-not-used",
        "ip-not-used"
    }
end

function OnServerCommand(PlayerIndex, Command)
    local t = tokenizestring(Command)
    count = #t
    if t[1] == "admin" then
        if t[2] == "me" then
            AdminUtility(PlayerIndex, Command)
        else  
            respond("Invalid Syntax: /admin me", PlayerIndex)
        end
    end
end

function AdminUtility(PlayerIndex, Command)
    
    local name = get_var(PlayerIndex,"$name")
    local hash = get_var(PlayerIndex,"$hash")
    local id = get_var(PlayerIndex, "$n")
    local ip = get_var(PlayerIndex, "$ip")
    
    local isadmin = nil
    if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 1 then 
        isadmin = true 
    else 
        isadmin = false 
    end
    
    if not isadmin then
        if table.match(namelist, name) and table.match(hashlist, hash) and table.match(iplist, ip) then
            execute_command("adminadd " .. id .. " " .. level)
            respond("Success! You're now an admin!", PlayerIndex)
            OnSuccess = string.format('[AdminUtility] - Successfully added ' .. name .. ' [' .. hash .. '] [' .. ip .. '] to the admin list.')
            execute_command("log_note \""..OnSuccess.."\"")
        else
            respond("You do not have permission to execute " .. Command, PlayerIndex)
        end
    else
        if isadmin == true then
            if table.match(namelist, name) and not table.match(hashlist, hash) and not table.match(iplist, ip) 
                or table.match(hashlist, hash) and not table.match(namelist, name) and not table.match(iplist, ip)
                or table.match(iplist, ip) and not table.match(namelist, name) and not table.match(hashlist, hash) then
                respond("You are already an admin...", PlayerIndex)
                respond("But your credentials do not match the database, Access Denied!", PlayerIndex)
            else
                respond("You are already an admin!", PlayerIndex)
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

function table.match(table, value)
    for k,v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function respond(Command, PlayerIndex)
    if Command then
        if Command == "" then 
            return 
            elseif type(Command) == "table" then
            Command = Command[1]
        end
        PlayerIndex = tonumber(PlayerIndex)
        if tonumber(PlayerIndex) and PlayerIndex ~= nil and PlayerIndex ~= -1 and PlayerIndex >= 0 and PlayerIndex < 16 then
            cprint("Response to: " .. get_var(PlayerIndex, "$name"), 4+8)
            cprint(Command, 2+8)
            rprint(PlayerIndex, Command)
            note = string.format('[AdminUtility] -->> ' .. get_var(PlayerIndex, "$name") .. ': ' .. Command)
            execute_command("log_note \""..note.."\"")
        else
            cprint(Command, 2+8)
        end
    end
end

function OnError(Message)
    print(debug.traceback())
end

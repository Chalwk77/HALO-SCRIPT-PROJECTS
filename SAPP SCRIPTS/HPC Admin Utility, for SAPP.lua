--[[
Script Name: HPC Admin Utility, for SAPP
- Implementing API version: 1.11.0.0

    Description: Type "/!Admin me" or "/sv_admin_me" to add yourself as an admin. 
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
        "ip-not-used"
        "ip-not-used"
        "ip-not-used"
    }
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
    local name = get_var(PlayerIndex,"$name")
    local hash = get_var(PlayerIndex,"$hash")
    local id = get_var(PlayerIndex, "$n")
    local ip = get_var(PlayerIndex, "$ip")
    if t[1] == "!Admin" and t[2] == "me" or t[1] == "sv_admin_me" then 
        if not isadmin then
            if table.match(namelist, name) and table.match(hashlist, hash) and table.match(iplist, ip) then
                execute_command("adminadd " .. id .. " " .. level)
                rprint(PlayerIndex, "|cSuccess! You're now an admin!")
                note = string.format("Successfully added player " .. name .. " [" .. hash .. "] to the admin list.")
                execute_command("log_note \""..note.."\"")
            else 
                rprint(PlayerIndex, "|cYou do not have permission to execute that command")
            end
        else 
            rprint(PlayerIndex, "|cYou are already an admin! |n|n|n|n")
        end
        return false
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

--[[
Script Name: HPC Admin Add-Yourself, for SAPP
- Implementing API version: 1.11.0.0

    Description: Type the key 'phrase' in chat to add yourself as an admin. This was particuarly useful to me when testing other scripts.
                 I'm sure you can think of some creative reasons to use this.
                    
    Your IGN and Hash must be listed in the name/hash tables. 
    
This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS
    
Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
]]

api_version = "1.11.0.0"
function OnScriptLoad( )
    register_callback(cb['EVENT_CHAT'], "OnChatMessage")
    LoadTables( )
end

level = "4"

function LoadTables( )
    namelist = {
        "Name1",
        "Name2",
        "name-not-used",
        "name-not-used",
        "name-not-used"
    }	
    hashlist = {
        "hash1",
        "hash2",
        "hash-not-used",
        "hash-not-used",
        "hash-not-used"
    }
end

function OnChatMessage(PlayerIndex, Message, type)
    name = get_var(PlayerIndex,"$name")
    hash = get_var(PlayerIndex,"$hash")
    id = get_var(PlayerIndex, "$n")
    local mlen = #Message
    local spcount = 0
    for i=1, #Message do
        local c = string.sub(Message, i,i)
        if c == ' ' then
            spcount = spcount+1
        end
    end
    if mlen == spcount then
        spcount = 0
        return 0
    end
    local t = tokenizestring(Message, " ")
    if t[1] == nil then
        return nil
    end
    if t[1] == "!Admin" then
        if table.match(namelist, name) and table.match(hashlist, hash) then
            execute_command("adminadd " .. id .. " " .. level)
            execute_command("msg_prefix \"\"")
            say(PlayerIndex, "Success! You're now an admin!")
            execute_command("msg_prefix \"** SAPP ** \"")
            note = string.format("Successfully added player " .. name .. " [" .. hash .. "] to the admin list.")
            execute_command("log_note \""..note.."\"")
            cprint("Successfully added player " .. name .. " [" .. hash .. "] to the admin list.", 2+8)
        else 
            execute_command("msg_prefix \"\"")
            say(PlayerIndex, "You do not have permission to execute this command.")
            execute_command("msg_prefix \"** SAPP ** \"")
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

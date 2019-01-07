--[[
--=====================================================================================================--
Script Name: Alias System, for SAPP (PC & CE)
Description: N/A

[!] [!] IN DEVELOPMENT [!] [!] * [!] [!] IN DEVELOPMENT [!] [!] * [!] [!] IN DEVELOPMENT [!] [!]
[!] [!] IN DEVELOPMENT [!] [!] * [!] [!] IN DEVELOPMENT [!] [!] * [!] [!] IN DEVELOPMENT [!] [!]
[!] [!] IN DEVELOPMENT [!] [!] * [!] [!] IN DEVELOPMENT [!] [!] * [!] [!] IN DEVELOPMENT [!] [!]
[!] [!] IN DEVELOPMENT [!] [!] * [!] [!] IN DEVELOPMENT [!] [!] * [!] [!] IN DEVELOPMENT [!] [!]

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Special thanks to Jeffrey Friedl for providing the JSON encode/decode routines.
* JSON.lua is required to use this script. Get the latest version here: http://regex.info/blog/lua/json

* Script written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"
JSON = (loadfile "sapp/JSON.lua")()

-- configuration starts
base_command = "alias"

-- minimum admin level required to use /alias command
min_admin_level = 1
-- configuration ends

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    checkFile()
end

function OnScriptUnload()
    
end

function OnPlayerJoin(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    addAlias(name, hash)
end

function getAliases(PlayerIndex, index)
    local file = io.open("sapp\\alias.lua", "r")
    local readjson = file:read("*a")
    local table = JSON:decode(readjson)
    file:close()
    local hash = get_var(index, "$hash")
    if table ~= nil then 
        if table[hash] ~= nil then 
            rprint(PlayerIndex, "Aliases: " .. table[hash] .. ",")
            cprint("Aliases: " .. table[hash] .. ",", 2+8)
        else
            rprint(PlayerIndex, "No aliases found!")
            cprint("table doesn't exist", 4+8)
        end
    end
end

function addAlias(name, hash)
    local file = io.open("sapp\\alias.lua", "r")
    local readjson = file:read("*a")
    local table = JSON:decode(readjson)
    file:close()
    -- proceed if file isn't empty
    if table ~= nil then 
        if table[hash] ~= nil then
            -- hash exists, name doesn't - add new name to hash table...
            if not string.match(table[hash], name) then
                -- hash doesn't exist, add it... (includes their name)
                -- TO DO...
            end
        else
            -- hash doesn't exist, add it... (includes their name)
            newAlias = {[tostring(hash)] = tostring(name)}
            local test = assert(io.open("sapp\\alias.lua", "a+"))
            data = JSON:encode(newAlias)
            test:write(data, "\n")
            test:close()
        end
    else
        -- create the very first entry (one time operation, unless file is deleted)
        newAlias = {[tostring(hash)] = tostring(name)}
        local test = assert(io.open("sapp\\alias.lua", "a+"))
        data = JSON:encode(newAlias)
        test:write(data, "\n")
        test:close()
    end
end

function checkFile()
    local file = io.open('sapp\\alias.lua', "rb")
    if file then
        file:close()
    else
        local file = io.open('sapp\\alias.lua', "a+")
        if file then
            file:close()
        end
    end
end

function OnServerCommand(PlayerIndex, Command)
    local t = tokenizestring(Command)
    local index
    response = nil
    if isAdmin(PlayerIndex) and t[1] == string.lower(base_command) then
        if t[2] ~= nil then
            if t[2] == string.match(t[2], "[A-Za-z]") then
                rprint(PlayerIndex, "Invalid player id")
            else
                index = tonumber(t[2])
                getAliases(PlayerIndex, index)
            end
            return false
        else
            rprint(PlayerIndex, "Invalid syntax. Use /" .. base_command .. " [id]")
            return false
        end
    end
end

function isAdmin(PlayerIndex)
    if (tonumber(get_var(PlayerIndex, "$lvl"))) >= min_admin_level then
        return true
    else
        return false
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { };
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

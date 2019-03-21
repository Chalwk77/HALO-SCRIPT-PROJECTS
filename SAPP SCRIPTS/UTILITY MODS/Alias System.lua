--[[
--=====================================================================================================--
Script Name: Alias System, for SAPP (PC & CE)
Description: Query a player's hash to check what aliases have been used with it.

Command syntax: /alias [id]

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

-- configuration starts
local base_command = "alias"
local dir = "sapp\\alias.lua"
local alignment = "l"
local duration = 10
local privilege_level = 1
local max_columns, max_results = 6, 100
-- configuration ends

local ip_table = {}
local mod, players, lower, concat, floor = { }, { }, string.lower, table.concat, math.floor

local function callReset()
    for i = 1,16 do
        if player_present(i) then
            if (tonumber(get_var(i, "$lvl")) >= privilege_level) then
                mod:reset(get_var(i, "$ip"))
            end
        end
    end
end

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")

    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")

    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    checkFile()
    callReset()
end

function mod:reset(ip)
    players[ip] = players[ip] or { }
    players[ip].timer = 0 
    players[ip].e = nil
    players[ip].t = nil
    players[ip].trigger = false
    players[ip].bool = false
end

function OnNewGame()
    callReset()
end

function OnGameEnd()
    callReset()
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            local ip = get_var(i, "$ip")
            if (players[ip] and players[ip].trigger == true) then
                players[ip].timer = players[ip].timer + 0.030
                mod:showAliases(i, ip)
                if players[ip].timer >= floor(duration) then
                    mod:reset(get_var(i, "$ip"))
                    players[ip].startIndex = 1
                    players[ip].endIndex = max_columns
                end
            end
        end
    end
end

function mod:showAliases(executor, ip)
    local target = players[ip].t
    
    if (players[ip].bool == true) then
        players[ip].bool = false
        rprint(executor, "|" .. alignment .. " " .. 'Showing aliases for: "' .. target .. '"')
    end
    
    local function formatAliases(executor)
        local t = {}
        local row, words, aliases
        
        local lines = lines_from(dir)
        for _, v in pairs(lines) do
            if v:match(target) then
                aliases = v:match(":(.+)")
                words = tokenizestring(aliases, ",")
            end
        end
        
        for i = tonumber(players[ip].startIndex), tonumber(players[ip].endIndex) do
            if words[i] then
                t[#t + 1] = words[i]
                row = concat(t, ", ")
            end
        end
        
        if row ~= nil then rprint(executor, row) end
        for _ in pairs(t) do t[_] = nil end
        
        players[ip].startIndex = (players[ip].endIndex + 1)
        players[ip].endIndex = (players[ip].endIndex + max_columns)
    end
    formatAliases(executor)
end

function OnPlayerJoin(PlayerIndex)
    local name, hash = get_var(PlayerIndex, "$name"), get_var(PlayerIndex, "$hash")
    mod:addAlias(name, hash)
    if (tonumber(get_var(PlayerIndex, "$lvl")) >= privilege_level) then
        ip_table[PlayerIndex] = {}
        ip_table[PlayerIndex][#ip_table[PlayerIndex] + 1] = get_var(PlayerIndex, "$ip")
    end
end

function OnPlayerLeave(PlayerIndex)
    if (tonumber(get_var(PlayerIndex, "$lvl")) >= privilege_level) then
        for _,v in ipairs(ip_table[PlayerIndex]) do
            mod:reset(v)
            ip_table[PlayerIndex] = nil
        end
    end
end

local function checkAccess(e)
    if (e ~= -1 and e >= 1 and e < 16) then
        if (tonumber(get_var(e, "$lvl"))) >= privilege_level then
            return true
        else
            rprint(e, "Command failed. Insufficient Permission.")
            return false
        end
    else
        return true
    end
end

local function isOnline(t, e)
    if (t) then
        if (t > 0 and t < 17) then
            if player_present(t) then
                return true
            else
                rprint(e, "Command failed. Player not online.")
                return false
            end
        else
            rprint(e, "Invalid player id. Please enter a number between 1-16")
        end
    end
end

function OnServerCommand(PlayerIndex, Command)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)

    local TargetID, target_all_players, is_error
    local ip = get_var(executor, "$ip")
    
    local function validate_params()
        cls(executor)
        mod:reset(get_var(executor, "$ip"))
        
        local function getplayers(arg, executor)
            local pl = { }
            if arg == "me" then
                TargetID = executor
                table.insert(pl, executor)
            elseif arg:match("%d+") then
                TargetID = tonumber(args[1])
                table.insert(pl, arg)
            elseif arg == "*" or (arg == "all") then
                for i = 1, 16 do
                    if player_present(i) then
                        target_all_players = true
                        table.insert(pl, i)
                    end
                end
            else
                rprint(executor, "Invalid player id")
                is_error = true
                return false
            end
            if pl[1] then return pl end
            pl = nil
            return false
        end

        local pl = getplayers(args[1], executor)
        if pl then
            for i = 1, #pl do
                if pl[i] == nil then break end
                players[ip].t = get_var(pl[i], "$hash")
            end
            if (pl ~= nil) then
                players[ip].e = tonumber(get_var(executor, "$n"))
                if (target_all_players) then
                    players[ip].startIndex = 1
                    players[ip].endIndex = tonumber(max_columns)
                    players[ip].bool = true
                    players[ip].trigger = true
                end
            end
        end
    end

    if (command == lower(base_command)) then
        if (checkAccess(executor)) then
            if (args[1] ~= nil) then
                is_error = false
                validate_params()
                if not (target_all_players) then
                    if not (is_error) and isOnline(TargetID, executor) then
                        players[ip].startIndex = 1
                        players[ip].endIndex = tonumber(max_columns)
                        players[ip].bool = true
                        players[ip].trigger = true
                    end
                end
            else
                rprint(executor, "Invalid syntax. Usage: /" .. base_command .. " [id | me | * | all]")
            end
        end
        return false
    end
end

function lines_from(file_name)
    local lines = {}
    for line in io.lines(file_name) do
        lines[#lines + 1] = line
    end
    return lines
end

function checkFile()
    local file = io.open(dir, "rb")
    if file then
        file:close()
        return true
    else
        local file = io.open(dir, "a+")
        if file then
            file:close()
            return true
        end
    end
end

local function containsExact(w, s)
    return select(2,s:gsub('^' .. w .. '%W+','')) +
         select(2,s:gsub('%W+' .. w .. '$','')) +
         select(2,s:gsub('^' .. w .. '$','')) +
         select(2,s:gsub('%W+' .. w .. '%W+','')) > 0
end

function mod:addAlias(name, hash)
    checkFile()
    local found, proceed
    local lines = lines_from(dir)
    for _, v in pairs(lines) do
        if containsExact(hash, v) and containsExact(name, v) then
            proceed = true
        end
        if containsExact(hash, v) and not containsExact(name, v) then
            found = true
            
            local alias = v .. ", " .. name
            
            local fRead = io.open(dir, "r")
            local content = fRead:read("*all")
            fRead:close()
            
            content = gsub(content, v, alias)
            
            local fWrite = io.open(dir, "w")
            fWrite:write(content)
            fWrite:close()
        end
    end
    if not (found) and not (proceed) then
        local file = assert(io.open(dir, "a+"))
        file:write(hash .. ":" .. name .. "\n")
        file:close()
    end
end

function cmdsplit(str)
    local subs = {}
    local sub = ""
    local ignore_quote, inquote, endquote
    for i = 1, string.len(str) do
        local bool
        local char = string.sub(str, i, i)
        if char == " " then
            if (inquote and endquote) or (not inquote and not endquote) then
                bool = true
            end
        elseif char == "\\" then
            ignore_quote = true
        elseif char == "\"" then
            if not ignore_quote then
                if not inquote then
                    inquote = true
                else
                    endquote = true
                end
            end
        end

        if char ~= "\\" then
            ignore_quote = false
        end

        if bool then
            if inquote and endquote then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end

            if sub ~= "" then
                table.insert(subs, sub)
            end
            sub = ""
            inquote = false
            endquote = false
        else
            sub = sub .. char
        end

        if i == string.len(str) then
            if string.sub(sub, 1, 1) == "\"" and string.sub(sub, string.len(sub), string.len(sub)) == "\"" then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end
            table.insert(subs, sub)
        end
    end

    local cmd = subs[1]
    local args = subs
    table.remove(args, 1)

    return cmd, args
end

function tokenizestring(inputString, Separator)
    if Separator == nil then Separator = "%s" end
    local t = {};
    local i = 1
    for str in string.gmatch(inputString, "([^" .. Separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function cls(PlayerIndex)
    for _ = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

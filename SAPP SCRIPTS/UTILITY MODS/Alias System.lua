--[[
--=====================================================================================================--
Script Name: Alias System, for SAPP (PC & CE)
Description: Query a player's hash to check what aliases have been used with it.

Command syntax: /alias [me | id | * | all]

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts]
local base_command = "alias"
 -- File is saved to root/sapp/dir.lua
local dir = "sapp\\alias.lua"

-- You can optionally display results for a specified amount of time. 
-- Set 'use_timer' to true to enable this feature.
local use_timer = true

-- How long should the alias results be displayed for? (in seconds) --
local duration = 10

-- Message Alignment:
-- Left = l,    Right = r,    Center = c,    Tab: t
local alignment = "l"

-- Minimum admin level required to use /base_command
local privilege_level = 1

local max_columns, max_results = 5, 100
local startIndex = 1
local endIndex = max_columns
local spaces = 3
-- Configuration [ends].

local ip_table, alias_results = { }, { }
local mod, players, lower, concat, floor, gsub, gmatch = { }, { }, string.lower, table.concat, math.floor, string.gsub, string.gmatch
local data = { }
local initialStartIndex

local function resetParams()
    for i = 1,16 do
        if player_present(i) then
            if (tonumber(get_var(i, "$lvl")) >= privilege_level) then
                mod:reset(get_var(i, "$ip"))
            end
        end
    end
end

function OnScriptLoad()
    if (use_timer) then
        register_callback(cb['EVENT_TICK'], "OnTick")
    end

    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")

    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    checkFile()
    resetParams()
end

function mod:reset(ip)
    players[ip] = players[ip] or { }
    players[ip].e = nil
    players[ip].t = nil
    players[ip].total = 0 
    if (use_timer) then
        players[ip].timer = 0 
        players[ip].trigger = false
        players[ip].bool = false
    end
end

function OnNewGame()
    initialStartIndex = tonumber(startIndex)
    resetParams()
end

function OnGameEnd()
    resetParams()
end

local function stringSplit(inp, sep)
    if (sep == nil) then
        sep = "%s"
    end
    local t, i = {}, 1
    for str in gmatch(inp, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

local function spacing(n)
    local spacing = ""
    for i = 1, n do
        spacing = spacing .. " "
    end
    return spacing
end

function data:align(player, table, target, total)
    cls(player)
    local function formatResults()
        local placeholder, row = { }
        for i = tonumber(startIndex), tonumber(endIndex) do
            if (table[1][i]) then
                placeholder[#placeholder + 1] = table[1][i]
                row = concat(placeholder, spacing(spaces))
            end
        end

        if (row ~= nil) then
            rprint(player, row)
        end

        for a in pairs(placeholder) do placeholder[a] = nil end
        startIndex = (endIndex + 1)
        endIndex = (endIndex + (max_columns))
    end
    
    while (endIndex < max_results + max_columns) do
        formatResults()
    end
    
    if (startIndex >= max_results) then
        startIndex = initialStartIndex
        endIndex = max_columns
    end
    rprint(player, "|" .. alignment .. " " .. 'Showing (' .. total .. ' aliases) for: "' .. target .. '"')
end

function mod:showAliases(executor, ip, total)
    local target = players[ip].t
    data:align(executor, alias_results, target, total)
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            local ip = get_var(i, "$ip")
            if (players[ip] and players[ip].trigger == true) then
                players[ip].timer = players[ip].timer + 0.030
                mod:showAliases(i, ip, players[ip].total)
                if players[ip].timer >= floor(duration) then
                    mod:reset(get_var(i, "$ip"))
                end
            end
        end
    end
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
        if next(ip_table[PlayerIndex]) then
            for _,v in ipairs(ip_table[PlayerIndex]) do
                mod:reset(v)
                ip_table[PlayerIndex] = nil
            end
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
    local total = 0
    
    local function validate_params()
        cls(executor)
        mod:reset(ip)
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
        local aliases
        if pl then
            local content
            for i = 1, #pl do
                if pl[i] == nil then break end
                players[ip].t = get_var(pl[i], "$hash")
                local lines = lines_from(dir)
                for _, v in pairs(lines) do
                    if (v:match(players[ip].t)) then
                        aliases = v:match(":(.+)")
                        content = stringSplit(aliases, ",")
                        alias_results[#alias_results + 1] = content
                    end
                end
            end
            if (pl ~= nil) then
                players[ip].e = tonumber(get_var(executor, "$n"))
                for i = 1, max_results do
                    if (alias_results[1][i]) then
                        players[ip].total = players[ip].total + 1
                    end
                end
                total = players[ip].total
                if (target_all_players) then -- prototype
                    if (use_timer) then
                        players[ip].bool = true
                        players[ip].trigger = true
                    else
                        mod:showAliases(executor, ip, total)
                    end
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
                        if (use_timer) then
                            players[ip].bool = true
                            players[ip].trigger = true
                        else
                            mod:showAliases(executor, ip, total)
                        end
                    end
                end
            else
                rprint(executor, "Invalid syntax. Usage: /" .. base_command .. " [id | me | * | all]")
            end
        end
        return false
    end
end

function lines_from(file)
    local lines = {}
    for line in io.lines(file) do
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

function cls(PlayerIndex)
    for _ = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

--[[
--=====================================================================================================--
Script Name: Alias System, for SAPP (PC & CE)
Description: Query a player's hash to check what aliases have been used with it.

Command syntax: /alias ( 'me' or [number: 1-16] ) [page id]

IMPORTANT: If you have downloaded this mod prior to 17th May 2019, you will need to delete alias.txt and let this mod regenerate it.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts] >> ----------------------------------------------
local base_command = "alias"
local dir = "sapp\\alias.lua" -- File is saved to root/sapp/dir.lua

-- You can optionally display results for a specified amount of time. 
-- Set 'use_timer' to true to enable this feature.
local use_timer = true

-- How long should the alias results be displayed for? (in seconds) --
local duration = 10

-- Minimum admin level required to use /base_command (-1 for all players, 1-4 for admins)
local privilege_level = 1

-- Message Alignment:
-- Left = l,    Right = r,    Center = c,    Tab: t
local alignment = "|l"

-- Maximum number of names shown per page.
local max_results_per_page = 50
-- Configuration [ends] << ----------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------
local players, player_info, lower, concat, floor, gsub, gmatch = { }, { }, string.lower, table.concat, math.floor, string.gsub, string.gmatch
local format = string.format
local server_ip = "000.000.000.000"
local function InitPlayers()
    players = {
        ["Alias System"] = { },
    }
end

local function getip(p)
    if (p) then
        return get_var(p, "$ip"):match("(%d+.%d+.%d+.%d+)")
    end
end

local function populateInfoTable(p)
    player_info[p] = { }
    local ip, level = getip(p), tonumber(get_var(p, "$lvl"))
    table.insert(player_info[p], { ["ip"] = ip, ["level"] = level})
end

local function getPlayerInfo(Player, ID)
    if player_present(Player) then
        if (player_info[Player] ~= nil) or (player_info[Player] ~= {}) then
            for key, _ in ipairs(player_info[Player]) do
                return player_info[Player][key][ID]
            end
        else
            return error('ALIAS SYSTEM: getPlayerInfo() -> Unable to get ' .. ID)
        end
    end
end

local max_columns, max_results = 5, 200
local startIndex, endIndex = 1, max_columns
local spaces = 2
local alias, alias_results = { }, { }
local initialStartIndex, known_pirated_hashes
local function PreLoad()
    initialStartIndex = tonumber(startIndex)
    known_pirated_hashes = { }
    known_pirated_hashes = {
        "388e89e69b4cc08b3441f25959f74103",
        "81f9c914b3402c2702a12dc1405247ee",
        "c939c09426f69c4843ff75ae704bf426",
        "13dbf72b3c21c5235c47e405dd6e092d",
        "29a29f3659a221351ed3d6f8355b2200",
        "d72b3f33bfb7266a8d0f13b37c62fddb",
        "76b9b8db9ae6b6cacdd59770a18fc1d5",
        "55d368354b5021e7dd5d3d1525a4ab82",
        "d41d8cd98f00b204e9800998ecf8427e",
        "c702226e783ea7e091c0bb44c2d0ec64",
        "f443106bd82fd6f3c22ba2df7c5e4094",
        "10440b462f6cbc3160c6280c2734f184",
        "3d5cd27b3fa487b040043273fa00f51b",
        "b661a51d4ccf44f5da2869b0055563cb",
        "740da6bafb23c2fbdc5140b5d320edb1",
        "7503dad2a08026fc4b6cfb32a940cfe0",
        "4486253cba68da6786359e7ff2c7b467",
        "f1d7c0018e1648d7d48f257dc35e9660",
        "40da66d41e9c79172a84eef745739521",
        "2863ab7e0e7371f9a6b3f0440c06c560",
        "34146dc35d583f2b34693a83469fac2a",
        "b315d022891afedf2e6bc7e5aaf2d357",
        "63bf3d5a51b292cd0702135f6f566bd1",
        "6891d0a75336a75f9d03bb5e51a53095",
        "325a53c37324e4adb484d7a9c6741314",
        "0e3c41078d06f7f502e4bb5bd886772a",
        "fc65cda372eeb75fc1a2e7d19e91a86f",
        "f35309a653ae6243dab90c203fa50000",
        "50bbef5ebf4e0393016d129a545bd09d",
        "a77ee0be91bd38a0635b65991bc4b686",
        "3126fab3615a94119d5fe9eead1e88c1",
    }
end

local function resetAliasParams()
    for i = 1, 16 do
        if player_present(i) then
            if (tonumber(get_var(i, "$lvl")) >= privilege_level) then
                local ip = getip(i)
                alias:reset(ip)
            end
        end
    end
end

-- #Alias System
function alias:reset(ip)
    alias_results[ip] = { }
    players["Alias System"][ip] = {
        eid = 0,
        timer = 0,
        current_page = 0,
        total_pages = 0,
        total_aliases = 0,
        current_count = 0,
        total_count = 0,
        bool = false,
        trigger = false,
        shared = false,
    }
end

function OnScriptLoad()
    InitPlayers()
    
    if (use_timer) then
        register_callback(cb['EVENT_TICK'], "OnTick")
    end

    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")

    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")

    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    

    checkFile(dir)
    resetAliasParams()
    PreLoad()
    alias:reset(server_ip)
    for i = 1, 16 do
        if player_present(i) then
            populateInfoTable(i)
        end
    end
end

function OnScriptUnload()
    --
end

function OnGameStart()
    PreLoad()
    resetAliasParams()
end

function OnGameEnd()
    resetAliasParams()
end

local function stringSplit(inp, sep)
    if (sep == nil) then sep = "%s" end
    local t, i = {}, 1
    for str in gmatch(inp, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            local ip = getip(i)
            if (players["Alias System"][ip] and players["Alias System"][ip].trigger) then
                players["Alias System"][ip].timer = players["Alias System"][ip].timer + 0.030
                alias:show(players["Alias System"][ip])
                if players["Alias System"][ip].timer >= floor(duration) then
                    alias:reset(ip)
                end
            end
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    local p = tonumber(PlayerIndex)
    local ip = getip(p)
    local level = tonumber(get_var(p, "$lvl"))
    
    local name, hash = get_var(p, "$name"), get_var(p, "$hash")
    alias:add(name, hash)
    
    populateInfoTable(PlayerIndex)
    
    if (level >= privilege_level) then
        alias:reset(ip)
    end
end

function OnPlayerDisconnect(p)
    local level = getPlayerInfo(p, "level")
    local ip = getPlayerInfo(p, "ip")
    if (tonumber(level) >= privilege_level) then
        if (players["Alias System"][ip] ~= nil) then
            alias:reset(ip)
        end
    end
end

local function isConsole(e)
    if (e) then
        if (e ~= -1 and e >= 1 and e < 16) then
            return false
        else
            return true
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
                respond(e, "Command failed. Player not online.", "rcon", 4 + 8)
                return false
            end
        else
            respond(e, "Invalid player id. Please enter a number between 1-16", "rcon", 4 + 8)
        end
    end
end

function OnServerCommand(PlayerIndex, Command)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)

    local TargetID, target_all_players, is_error
    local ip = getip(PlayerIndex)
    
    local params = { }
    local function validate_params(executor)
        local function getplayer(arg, executor)
            local pl = { }
            if (arg == "me") then
                TargetID = executor
                table.insert(pl, executor)
            elseif (arg:match("%d+")) then
                TargetID = tonumber(arg)
                table.insert(pl, tonumber(arg))
            else
                respond(executor, "Invalid player id. Usage: 'me' or [number: 1-16]", "rcon", 4 + 8)
                is_error = true
                return false
            end
            if pl[1] then
                return pl
            end
            pl = nil
            return false
        end
        local pl = getplayer(args[1], executor)
        if pl then
            for i = 1, #pl do
            
                if pl[i] == nil then
                    break
                end
                
                params.eid, params.eip = executor, ip
                params.tid = tonumber(pl[i])
                params.th, params.tn = get_var(pl[i], "$hash"), get_var(pl[i], "$name")

                if (params.eip == nil) then
                    params.eip = server_ip
                end

                local bool
                if isConsole(executor) then
                    bool = false
                else
                    bool = use_timer
                end

                if (args[2] ~= nil) then
                    params.page = args[2]
                end

                params.timer = bool
                alias:reset(params.eip)
            end
        end
    end
    if (command == base_command) then
        if (checkAccess(executor)) then
            if (args[1] ~= nil) then
                validate_params(executor)
                if not (is_error) and isOnline(TargetID, executor) then
                    alias:cmdRoutine(params)
                end
            else
                respond(executor, "Invalid syntax. Usage: /" .. base_command .. " ( 'me' or [number: 1-16] ) [page id]", "rcon", 4 + 8)
            end
        end
        return false
    elseif (players["Alias System"][ip] ~= nil) and (players["Alias System"][ip].trigger) then
        alias:reset(ip)
        cls(executor, 25)
        return true
    end
end

local getPageCount = function(total, max_results)
    local pages = total / (max_results)
    if ((pages) ~= floor(pages)) then
        pages = floor(pages) + 1
    end
    return pages
end

function alias:cmdRoutine(params)
    local params = params or {}
    
    local eid = params.eid or nil
    local eip = params.eip or nil

    local use_timer = params.timer or nil
    local current_page = params.page or nil

    if (current_page == nil) then
        current_page = 1
    end

    local tab = players["Alias System"][eip]
    local max_results = max_results_per_page

    tab.target_hash = params.th
    tab.target_name = params.tn
    tab.eid = eid

    local aliases, content
    local lines = lines_from(dir)
    for _, v in pairs(lines) do
        if (v:match(tab.target_hash)) then
            aliases = v:match(":(.+)")
            content = stringSplit(aliases, ",")
            alias_results[eip][#alias_results[eip] + 1] = content
        end
    end

    for i = 1, #known_pirated_hashes do
        if (tab.target_hash == known_pirated_hashes[i]) then
            tab.shared = true
        end
    end

    for i = 1, #alias_results[eip][1] do
        if (alias_results[eip][1][i]) then
            tab.total_count = tab.total_count + 1
        end
    end

    if (current_page == nil) or (type(current_page) == "string")then
        current_page = 1
    end

    local start = (max_results) * current_page
    local startpage = (start - max_results + 1)
    local endpage = start

    local table = { }
    for page_num = startpage, endpage do
        if (alias_results[eip][1][page_num]) then
            table[#table + 1] = alias_results[eip][1][page_num]
        end
    end

    local pages = getPageCount(tab.total_count, max_results)

    if (#table > 0) then
    
        alias_results[eip][1] = { }

        for k, v in pairs(table) do
            alias_results[eip][1][k] = v
        end

        for i = 1, max_results do
            if (alias_results[eip][1][i]) then
                tab.current_count = tab.current_count + 1
            end
        end

        tab.current_page = current_page
        tab.total_pages = pages
        tab.results = alias_results[eip][1]
        tab.max_results = max_results

        if (use_timer) then
            tab.trigger = true
            tab.bool = true
        else
            alias:show(tab)
        end
    else
        respond(eid, "Invalid Page ID. Valid pages: 1 to " .. pages, "rcon", 2 + 8)
    end
end

function alias:show(tab)
    alias:align(tab)
end

local function spacing(n)
    local String, Seperator = "", ","
    for i = 1, n do
        if i == floor(n / 2) then
            String = String .. ""
        end
        String = String .. " "
    end
    return Seperator .. String
end

local function FormatTable(table, rowlen, space)
    local longest = 0
    for _, v in ipairs(table) do
        local len = string.len(v)
        if (len > longest) then
            longest = len
        end
    end
    local rows = {}
    local row = 1
    local count = 1
    for k, v in ipairs(table) do
        if (count % rowlen == 0) or (k == #table) then
            rows[row] = (rows[row] or "") .. v
        else
            rows[row] = (rows[row] or "") .. v .. spacing(longest - string.len(v) + space)
        end
        if (count % rowlen == 0) then
            row = row + 1
        end
        count = count + 1
    end
    return concat(rows)
end

function alias:align(tab)
    local tab = tab or { }
    if (tab) then

        local executor = tab.eid

        local current_page = tab.current_page
        local total_pages = tab.total_pages
        local total_aliases = tab.total_aliases

        local current_count = tab.current_count
        local total_count = tab.total_count

        local target_hash = tab.target_hash
        local target_name = tab.target_name
        local pirated = tab.shared
        local results = tab.results
        local max_results = tab.max_results

        if not isConsole(executor) then
            cls(executor, 25)
        else
            alignment = ""
        end

        local function formatResults()
            local placeholder, row = { }

            for i = tonumber(startIndex), tonumber(endIndex) do
                if (results) then
                    placeholder[#placeholder + 1] = results[i]
                    row = FormatTable(placeholder, max_columns, spaces)
                end
            end

            if (row == "") or (row == " ") then
                row = nil -- just in case
            end

            if (row ~= nil) then
                respond(executor, alignment .. " " .. row, "rcon")
            end

            for a in pairs(placeholder) do
                placeholder[a] = nil
            end

            startIndex = (endIndex + 1)
            endIndex = (endIndex + (max_columns))
        end

        while (endIndex < total_count + max_columns) do
            formatResults()
        end

        if (startIndex >= total_count) then
            startIndex = initialStartIndex
            endIndex = max_columns
        end

        respond(executor, " ", "rcon", 2 + 8)
        --[Page X/X] Showing (X/X) aliases for xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 
        respond(executor, alignment .. " " .. '[Page ' .. current_page .. '/' .. total_pages .. '] Showing (' .. current_count .. '/' .. total_count .. ') aliases for: "' .. target_hash .. '"', "rcon", 2 + 8)
        if (pirated) then
            respond(executor, alignment .. " " .. target_name .. ' is using a pirated copy of Halo.', "rcon", 2 + 8)
        end
    end
end

function alias:add(name, hash)
    local lines = lines_from(dir)
    local data, alias, name_found, index
    
    for k, v in pairs(lines) do
        if (v:match(hash)) then
            data = stringSplit(gsub(v, hash .. ":", ""), ",")
            alias = v .. "," .. name
            index = k
        end
    end

    if (data) then
        local result, i = { }, 1
        for j = 1, #data do
            if (data[j] ~= nil) then
                result[i] = data[j]
                i = i + 1
            end
        end
        if (result ~= nil) then

            for i = 1, #result do
                if (name == result[i]) then
                    -- Name entry already exists for this hash: (do nothing).
                    name_found = true
                    break
                end
            end

            if not (name_found) then
                -- Name entry does not eist for this hash: (create new name entry).
                delete_from_file(dir, index, 1)
                local file = assert(io.open(dir, "a+"))
                file:write(alias .. "\n")
                file:close()
            end
        end
    else
        -- Hash entry does not exist in the database: (create entry).
        local file = assert(io.open(dir, "a+"))
        file:write(hash .. ":" .. name .. "\n")
        file:close()
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

function respond(executor, message, environment, color)
    if (executor) then
        color = color or 4 + 8
        if not (isConsole(executor)) then
            if (environment == "chat") then
                Say(executor, message)
            elseif (environment == "rcon") then
                rprint(executor, message)
            end
        else
            cprint(message, color)
        end
    end
end

function delete(dir, start_index, end_index)
    local fp = io.open(dir, "r")
    local t = {}
    i = 1;
    for line in fp:lines() do
        if i < start_index or i >= start_index + end_index then
            t[#t + 1] = line
        end
        i = i + 1
    end
    if i > start_index and i < start_index + end_index then
        cprint("Warning: End of File! No entries to delete.")
    end
    fp:close()
    fp = io.open(dir, "w+")
    for i = 1, #t do
        fp:write(format("%s\n", t[i]))
    end
    fp:close()
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

function delete_from_file(dir, start_index, end_index)
    local fp = io.open(dir, "r")
    local t = {}
    i = 1;
    for line in fp:lines() do
        if i < start_index or i >= start_index + end_index then
            t[#t + 1] = line
        end
        i = i + 1
    end
    if i > start_index and i < start_index + end_index then
        cprint("Warning: End of File! No entries to delete.")
    end
    fp:close()
    fp = io.open(dir, "w+")
    for i = 1, #t do
        fp:write(format("%s\n", t[i]))
    end
    fp:close()
end

function cls(PlayerIndex, count)
    if (PlayerIndex) then
        for _ = 1, count do
            respond(PlayerIndex, " ", "rcon")
        end
    end
end

--[[
--=====================================================================================================--
Script Name: Mute System (v 1.3), for SAPP (PC & CE)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [STASRTS] --
local mute_dir = "sapp\\test_mutes.txt"
local mute_command = "mute"
local unmute_command = "unmute"
local mutelist_command = "mutelist"
local default_mute_time = 525600
local privilege_level = 1
-- Configuration [ENDS] --

local mod, mute_table = { }, { }
local script_version = 1.3
local function getip(p)
    return get_var(p, "$ip"):match("(%d+.%d+.%d+.%d+)")
end

local gsub, match, gmatch = string.gsub, string.match, string.gmatch
local concat = table.concat
local floor = math.floor

function OnScriptLoad()
    checkFile(mute_dir)
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    for i = 1,16 do
        if player_present(i) then
            local p, ip, name = { }, getip(i), get_var(i, "$name")
            p.ip = ip
            local muted = mod:load(p)
            if (muted ~= nil) and (ip == muted[1]) then
                p.name, p.time, p.tid = name, muted[3], tonumber(i)
                mod:save(p, true, true)
            end
        end
    end
end

function OnScriptUnload()
    for i = 1,16 do
        if player_present(i) then
            local ip, name = getip(i), get_var(i, "$name")
            if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
                local p = { }
                p.ip, p.name, p.time, p.tid = ip, name, mute_table[ip].remaining, tonumber(i)
                mod:save(p, false, true)
            end
        end
    end
end

function OnGameEnd()
    for i = 1,16 do
        if player_present(i) then
            local ip, name = getip(i), get_var(i, "$name")
            if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
                local p = { }
                p.ip, p.name, p.time, p.tid = ip, name, mute_table[ip].remaining, tonumber(i)
                mod:save(p, false, false)
            end
        end
    end
end

local function getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
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

local function checkAccess(e, console)
    local access, others
    if (e ~= -1 and e >= 1 and e < 16) then
        if (tonumber(get_var(e, "$lvl")) >= privilege_level) then
            access = true
        else
            respond(e, "Command failed. Insufficient Permission", "rcon", 2+8)
            access = false
        end
    elseif (console) and (e < 1) then
        access = true
    end
    return access
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

local function cmdself(t, e)
    if (t) then
        if tonumber(t) == tonumber(e) then
            respond(e, "You cannot execute this command on yourself", "rcon", 2+8)
            return true
        end
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    local ip = getip(PlayerIndex)
    if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
        local name = get_var(PlayerIndex, "$name")
        cprint('[MUTED] ' .. name .. ": " .. Message)
        if (mute_table[ip].duration == default_mute_time) then
            rprint(PlayerIndex, "[muted] You are muted permanently.")
        else
            local char = getChar(mute_table[ip].duration)
            rprint(PlayerIndex, "[muted] Time remaining: " .. mute_table[ip].duration .. " minute" .. char)
        end
        return false
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
    local params = { }
    local is_error
    local function validate_params(parameter, pos)
        local function getplayers(arg, executor)
            if (arg == nil) then
                arg = executor
            end
            local players = { }
            if (arg == "me") then
                TargetID = executor
                table.insert(players, executor)
            elseif (arg:match("%d+")) then
                TargetID = tonumber(arg)
                table.insert(players, arg)
            elseif (arg == "*" or arg == "all") then
                for i = 1, 16 do
                    if player_present(i) then
                        target_all_players = true
                        table.insert(players, i)
                    end
                end
            else
                respond(executor, "Invalid player id. Usage: [number: 1-16] | */all | me", "rcon", 2+8)
                is_error = true
                return false
            end
            if players[1] then
                return players
            end
            players = nil
            return false
        end
        local pl = getplayers(args[tonumber(pos)], executor)
        if pl then
            for i = 1, #pl do
                if pl[i] == nil then
                    break
                end
                
                params.eid = executor
                params.en = get_var(executor, "$name")
                params.tid = tonumber(pl[i])
                params.ip = getip(pl[i])
                params.name = get_var(pl[i], "$name")
                
                if (parameter == "mute") then
                    if (args[2] ~= nil) then
                        params.time = args[2]
                    end
                    if (target_all_players) then
                        mod:save(params, true, true)
                    end
                elseif (parameter == "unmute") then
                    if (target_all_players) then
                        mod:unmute(params)
                    end
                end
            end
        end
    end
    if (command == mute_command) then
        if (args[1] ~= nil) and (args[2] ~= nil) then
            if checkAccess(executor, true) then
                validate_params("mute", 1)
                if not (target_all_players) then
                    if not (is_error) and isOnline(TargetID, executor) then
                        mod:save(params, true, true)
                    end
                end
            end
        else
            respond(executor, "Invalid syntax. Usage: /" .. mute_command.. " [id] <time diff>", "rcon", 2+8)
        end
        return false
    elseif (command == unmute_command) then
        if (args[1] ~= nil) then
            if checkAccess(executor, true) then
                validate_params("unmute", 1)
                if not (target_all_players) then
                    if not (is_error) and isOnline(TargetID, executor) then
                        mod:unmute(params)
                    end
                end
            end
        else
            respond(executor, "Invalid syntax. Usage: /" .. unmute_command.. " [id]", "rcon", 2+8)
        end
        return false
    elseif (command == mutelist_command) then
        if checkAccess(executor, true) then
            local p = { }
            p.eid = executor
            p.flag = args[1]
            mod:mutelist(p)
        end
        return false
    end
end

function OnPlayerConnect(PlayerIndex)
    local p, ip, name = { }, getip(PlayerIndex), get_var(PlayerIndex, "$name")
    p.ip = ip
    local muted = mod:load(p)
    if (muted ~= nil) and (ip == muted[1]) then
        p.name, p.time, p.tid = name, muted[3], tonumber(PlayerIndex)
        mod:save(p, true, true)
    end
end

function OnPlayerDisconnect(PlayerIndex)
    local ip, name = getip(PlayerIndex), get_var(PlayerIndex, "$name")
    if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
        local p = { }
        p.ip, p.name, p.time, p.tid = ip, name, mute_table[ip].remaining, tonumber(PlayerIndex)
        mod:save(p, true, true)
    end
end

function OnTick()
    for i = 1,16 do
        if player_present(i) then
            local ip = getip(i)
            if (mute_table[ip] ~= nil) and (mute_table[ip].muted) then
                mute_table[ip].timer = mute_table[ip].timer + 0.030
                local days, hours, minutes, seconds = secondsToTime(mute_table[ip].timer, 4)
                mute_table[ip].remaining = (mute_table[ip].duration) - floor(minutes)
                if (mute_table[ip].remaining <= 0) then
                    local p = { }
                    p.ip, p.name, p.tid = ip, get_var(i, "$name"), tonumber(i)
                    mod:unmute(p)
                end
            end
        end
    end
end

function mod:save(params, bool, showMessage)
    local params = params or { }
    
    local ip = params.ip or nil
    local name = params.name or nil
    local eid = params.eid or nil
    local en = params.en or nil
    local tid = params.tid or nil
    local time = params.time or nil

    mute_table[ip] = mute_table[ip] or { }
    mute_table[ip].muted = true
    mute_table[ip].timer = 0
    mute_table[ip].remaining = time
    mute_table[ip].duration = time
    
    local dir = mute_dir
    
    local lines, found = lines_from(dir)
    for _, v in pairs(lines) do
        if (v:match(ip)) then
            found = true
            local fRead = io.open(dir, "r")
            local content = fRead:read("*all")
            fRead:close()
            content = gsub(content, v, ip .. ", " .. name .. ", " .. time)
            local fWrite = io.open(dir, "w")
            fWrite:write(content)
            fWrite:close()
        end
    end
    if not (found) then
        local file = assert(io.open(dir, "a+"))
        file:write(ip .. ", " .. name .. ", " .. time .. "\n")
        file:close()
    end
    if (bool) and (showMessage) then
        if (mute_table[ip].duration == default_mute_time) then
            respond(tid, "You are muted permanently", "rcon", 2 + 8)
            if (eid ~= nil) then
                respond(eid, name .. " was muted permanently", "rcon", 2 + 8)
                for i = 1, 16 do
                    if tonumber(get_var(i, "$lvl")) >= 1 and (i ~= eid) then
                        respond(i, name .. " was muted permanently by " .. en, "rcon", 2 + 8)
                    end
                end
            end
        else
            local char = getChar(mute_table[ip].duration)
            respond(tid, "You were muted! Time remaining: " .. mute_table[ip].duration .. " minute" .. char, "rcon", 2 + 8)
            if (eid ~= nil) then
                respond(eid, name .. " was muted for " .. mute_table[ip].duration .. " minute" .. char, "rcon", 2 + 8)
                for i = 1, 16 do
                    if tonumber(get_var(i, "$lvl")) >= 1 and (i ~= eid) then
                        respond(i, name .. " was muted for " .. mute_table[ip].duration .. " minute" .. char .. " by " .. en, "rcon", 2 + 8)
                    end
                end
            end
        end
    end
end

function mod:unmute(params)
    local params = params or { }
    
    local ip = params.ip or nil
    local name = params.name or nil
    local eid = params.eid or nil
    local tid = params.tid or nil
    local en = params.en or nil
    
    local dir = mute_dir
    local lines = lines_from(dir)
    for _, v in pairs(lines) do
        if (v:match(ip)) then
            local fRead = io.open(dir, "r")
            local content = fRead:read("*all")
            fRead:close()
            local file = io.open(dir, "w")
            content = gsub(content, v, "")
            file:write(content)
            file:close()
            mute_table[ip] = { }
        end
    end
    
    if (eid ~= nil and eid == 0) or (eid == nil) then
        en = 'SERVER'
        id = 0
    elseif (eid ~= nil and eid > 0) then
        en = en
        id = eid
    end
    respond(tid, "You were unmuted by " .. en, "rcon", 2+8)
    respond(id, name .. " was unmuted by " .. en, "rcon", 2+8)
end

function mod:load(params)
    local params = params or { }
    local ip = params.ip or nil
    local dir = mute_dir
    local content, data
    
    local lines = lines_from(dir)
    for _, v in pairs(lines) do
        if (v:match(ip)) then
            content = v:match(v)
            data = stringSplit(content, ",")
        end
    end

    if (data) then
        local result, i = { }, 1
        for j = 1, 3 do
            if (data[j] ~= nil) then
                result[i] = data[j]
                i = i + 1
            end
        end
        if (result ~= nil) then
            return result
        end
    end
end

function mod:mutelist(params) 
    local params = params or { }
    local eid = params.eid or nil
    local flag = params.flag or nil
    local dir = mute_dir
    
    respond(eid, "----------- IP - NAME - TIME REMAINING (in minutes) ----------- ", "rcon", 7+8)
    
    local lines = lines_from(dir)
    for k, v in pairs(lines) do
        if (k ~= nil) then
            if (flag == nil) then
                respond(eid, v, "rcon", 2+8)
            elseif (flag == "-o") then
                local count = 0
                for i = 1, 16 do
                    if player_present(i) then 
                        cout = count + 1
                        local ip = getip(i)
                        local muted = mod:load(ip)
                        if (ip == muted[1]) then
                            local char = getChar(muted[3])
                            respond(eid, get_var(i, "$name") .. " [" .. tonumber(i) .. "]: " .. muted[3] .. " minute" .. char .. " left", "rcon", 7 + 8)
                        end
                    end
                end
                if (count == 0) then
                    respond(eid, "Nobody online is currently muted.", "rcon", 4+8)
                    break
                end
            else
                respond(eid, "Invalid syntax. Usage: /" .. mutelist_command.. " <flag>", "rcon", 2+8)
                break
            end
        end
    end
end

function stringSplit(inp, sep)
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

function lines_from(file)
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

function checkFile(directory)
    local file = io.open(directory, "rb")
    if file then
        file:close()
        return true
    else
        local file = io.open(directory, "a+")
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
                say(executor, message)
            elseif (environment == "rcon") then
                rprint(executor, message)
            end
        else
            cprint(message, color)
        end
    end
end

function secondsToTime(seconds, places)

    local years = floor(seconds / (60 * 60 * 24 * 365))
    seconds = seconds % (60 * 60 * 24 * 365)
    local weeks = floor(seconds / (60 * 60 * 24 * 7))
    seconds = seconds % (60 * 60 * 24 * 7)
    local days = floor(seconds / (60 * 60 * 24))
    seconds = seconds % (60 * 60 * 24)
    local hours = floor(seconds / (60 * 60))
    seconds = seconds % (60 * 60)
    local minutes = floor(seconds / 60)
    seconds = seconds % 60

    if places == 6 then
        return string.format("%02d:%02d:%02d:%02d:%02d:%02d", years, weeks, days, hours, minutes, seconds)
    elseif places == 5 then
        return string.format("%02d:%02d:%02d:%02d:%02d", weeks, days, hours, minutes, seconds)
    elseif not places or places == 4 then
        return days, hours, minutes, seconds
    elseif places == 3 then
        return string.format("%02d:%02d:%02d", hours, minutes, seconds)
    elseif places == 2 then
        return string.format("%02d:%02d", minutes, seconds)
    elseif places == 1 then
        return string.format("%02", seconds)
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

function report()
    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. script_version, 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)
end

function OnError()
    cprint(debug.traceback(), 4 + 8)
    timer(50, "report")
end

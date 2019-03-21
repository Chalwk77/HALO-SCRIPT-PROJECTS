--[[
--=====================================================================================================--
Script Name: Inventory Transactions, for SAPP (PC & CE)
Description: N/A

IN DEVELOPMENT

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts]

local commands = {
    -- TRIGGER, COMMAND, COST, VALUE, MESAGE, REQUIRED LEVEL: (minimum level required to execute the TRIGGER)
    {["heal1"] = {'hp', "10", "1", "100% Health", -1}},
    {["heal2"] = {'hp', "20", "2", "200% Health", -1}},
    {["heal3"] = {'hp', "30", "3", "300% Health", -1}},
    {["heal4"] = {'hp', "40", "4", "400% Health", -1}},
    {["heal5"] = {'hp', "50", "5", "500% Health", -1}},

    {["am1"] = {'ammo', "10", "200", "200 Ammo All Weapons", -1}},
    {["am2"] = {'ammo', "20", "350", "350 Ammo All Weapons", -1}},
    {["am3"] = {'ammo', "30", "500", "500 Ammo All Weapons", -1}},
    {["am4"] = {'ammo', "40", "700", "700 Ammo All Weapons", -1}},
    {["am5"] = {'ammo', "50", "900", "900 Ammo All Weapons", -1}},

    {["cam1"] = {'camo', "30", "60", "1 Minute of Camo", -1}},
    {["cam2"] = {'camo', "40", "120", "2 Minutes of Camo", -1}},
    {["cam3"] = {'camo', "50", "180", "3 Minutes of Camo", -1}},
    
    -- Balance Command: Syntax: 'command, message'
    {[1] = {"bal", "Money: $%money%", -1}},
}

local stats = {
    -- [ kills (killer)] --
    {["10"] = {'10', "(%kills%) +10 Upgrade Points"}},
    {["20"] = {'10', "(%kills%) +10 Upgrade Points"}},
    {["30"] = {'10', "(%kills%) +10 Upgrade Points"}},
    {["40"] = {'10', "(%kills%) +10 Upgrade Points"}},
    {["50"] = {'10', "(%kills%) +10 Upgrade Points"}},
    {["60"] = {'10', "(%kills%) +10 Upgrade Points"}},
    {["70"] = {'10', "(%kills%) +10 Upgrade Points"}},
    {["80"] = {'10', "(%kills%) +10 Upgrade Points"}},
    {["90"] = {'20', "(%kills%) +20 Upgrade Points"}},
    {["100"] = {'30', "(%kills%) +30 Upgrade Points"}},
    
    -- [ deaths (victim)] --
    {["event_die"] = {'-20', "DEATH (-%penalty_points% points)"}},
    
    -- [ kill streaks ] --
    
    -- [ suicide ] --
    {["event_suicide"] = {'-30', "SUICIDE (-%penalty_points% points)"}},
    
    -- [ team kill ] --
    {["event_tk"] = {'-50', "TEAM KILL (-%penalty_points% points)"}},
}

-- Configuration [ends] -----------------------------------------------------------------

local money, ip_table = { }, { }
local dir = "sapp\\stats.data"

local gsub, match, concat = string.gsub, string.match, table.concat

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_DIE'], 'OnPlayerKill')
    
    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")
    
    checkFile()
end

function OnScriptUnload()
    --
end

function OnGameStart()
    
end

function OnGameEnd()
    
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)

    local function checkAccess(e, level)
        if (e ~= -1 and e >= 1 and e < 16) then
            if (tonumber(get_var(e, "$lvl"))) >= level then
                return true
            else
                rprint(e, "Command failed. Insufficient Permission.")
                return false
            end
        else
            rprint(e, "Command failed. You can only execute this command from in game.")
            return false
        end
    end
    
    for key, _ in ipairs(commands) do
        local cmd = commands[key][command]
        if (cmd ~= nil) then
            local lvl = cmd[#cmd]
            if checkAccess(executor, lvl) then
                if (#cmd > 2) then
                    execute_command(cmd[1] .. ' ' .. executor .. ' ' .. cmd[3])
                    rprint(executor, cmd[4])
                    response = false
                end
            end
        end
        local bal = commands[key][1]
        if (bal ~= nil) then
            if (command == commands[key][1][1]) then
                local balance = money:getbalance(getIP(executor))
                rprint(executor, gsub(bal[2], "%%money%%", balance))
            end
        end
        response = false
    end
    return response
end

function money:Purchase(params)

end

function money:Add(params)
    local params = params or {}

    local player_ip = params.pip or nil
    local reward = params.money or nil
    
    local balance = money:getbalance(player_ip)
    
    local new_balance = balance
    if (new_balance == nil) or (new_balance <= 0) then
        new_balance = 0
    else
        new_balance = balance + reward
    end
    
    local found, proceed
    local lines = lines_from(dir)
    for _, v in pairs(lines) do
        if containsExact(player_ip, v) then
            found = true
            
            local fRead = io.open(dir, "r")
            local content = fRead:read("*all")
            fRead:close()
            
            content = gsub(content, v, player_ip .. ":" .. new_balance)
            
            local fWrite = io.open(dir, "w")
            fWrite:write(content)
            fWrite:close()
        end
    end
    
    if not (found) then
        local file = assert(io.open(dir, "a+"))
        file:write(player_ip .. ":" .. new_balance .. "\n")
        file:close()
    end
end

function money:Remove(params)
    local params = params or {}

    local player_ip = params.pip or nil
    local penalty = params.money or nil
    
    local balance = money:getbalance(player_ip)
    
    local new_balance = balance
    if (new_balance == nil) or (new_balance <= 0) then
        new_balance = 0
    else
        new_balance = balance - penalty
    end
    
    local found, proceed
    local lines = lines_from(dir)
    for _, v in pairs(lines) do
        if containsExact(player_ip, v) then
            found = true
            
            local fRead = io.open(dir, "r")
            local content = fRead:read("*all")
            fRead:close()
            
            content = gsub(content, v, player_ip .. ":" .. new_balance)
            
            local fWrite = io.open(dir, "w")
            fWrite:write(content)
            fWrite:close()
        end
    end
    
    if not (found) then
        local file = assert(io.open(dir, "a+"))
        file:write(player_ip .. ":" .. new_balance .. "\n")
        file:close()
    end
end

function money:Accept(params)

end

function money:Decline(params)

end

function money:Transfer(params)

end

function money:getbalance(player_ip)
    local balance = {}
    local str = ""
    local n = 1
    local file = io.open ( dir, "r" )
    if file == nil then
        return 0
    end
    local contents = file:read( "*a" )
    file:close()
    for i = 1, string.len( contents ) do
        local char = string.char( string.byte( contents, i ) )
        if char ~= ":" then
            str = str..char
        else
            balance[n] = (str)
            n = n + 1
            str = ""
        end
    end
    
    if (balance[1] == nil) or (balance[2] == nil) then 
        balance[2] = 0
    end
    
    return balance[2]
end

function money:getUpgrades(params)

end

function OnPlayerConnect(PlayerIndex)
    local hash = get_var(PlayerIndex, "$hash")
    local ip = get_var(PlayerIndex, "$ip"):match("(%d+.%d+.%d+.%d+)")
    if not ip_table[hash] then ip_table[hash] = {} end
    table.insert(ip_table[hash], {["ip"] = ip})
end

function OnPlayerDisconnect(PlayerIndex)
    --
end

function OnPlayerKill(PlayerIndex, KillerIndex)
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    
    if (victim ~= killer) then
        local total_kills = get_var(KillerIndex, "$kills")
        for key, _ in ipairs(stats) do
            local kill_table = stats[key][total_kills]
            if (kill_table ~= nil) then
                for k,_ in pairs(kill_table) do
                    if (tonumber(total_kills) == k) then
                        local params = { }
                        
                        local penalty_points = stats[key]["event_die"]
                        params.vip, params.kip = getIP(victim), getIP(killer)
                        params.vmoney, params.kmoney = kill_table[1], penalty_points[1]
                        
                        money:Add(params)
                        money:Remove(params)
                        
                        rprint(KillerIndex, gsub(kill_table[2], "%%kills%%", k))
                        
                        local event_die = stats[key]["event_die"]
                        rprint(victim, gsub(event_die[2], "%%penalty_points%%", event_die[1]))
                    end
                end
            end
        end
    elseif (victim == killer) then
        for key, _ in ipairs(stats) do
            local event_suicide = stats[key]["event_suicide"]
            if (event_suicide ~= nil) then
                local params = { }
                params.pip = getIP(victim)
                params.money = event_suicide[1]
                money:Remove(params)
                rprint(victim, gsub(event_suicide[2], "%%penalty_points%%", params.money))
            end
        end
    end
end

function getIP(PlayerIndex)
    local hash = get_var(PlayerIndex, "$hash")
    if ip_table[hash] ~= nil or ip_table[hash] ~= {} then
        for key, _ in ipairs(ip_table[hash]) do
            return ip_table[hash][key]["ip"]
        end
    end
end

function containsExact(w,s)
    return select(2,s:gsub('^' .. w .. '%W+','')) +
         select(2,s:gsub('%W+' .. w .. '$','')) +
         select(2,s:gsub('^' .. w .. '$','')) +
         select(2,s:gsub('%W+' .. w .. '%W+','')) > 0
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

--[[
--=====================================================================================================--
Script Name: Inventory Transactions, for SAPP (PC & CE)
Description: Earn 'money' for kills, scoring, assists, combo-kills and more.

Use that money to buy equipment and upgrades.
More details will come at a later date.

IN DEVELOPMENT (80% complete)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts]

-- Custom Variables that can be used in 'Insufficient Funds' message: 
-- "%balance%" (current balance)
-- "%price%" (money required to execute TRIGGER)
local insufficient_funds = "Insufficient funds. Current balance: $%balance%. You need $%price%"

local upgrade_info_command = "upgrades"
local upgrade_perm_lvl = -1

local commands = {
    -- TRIGGER, COMMAND, COST, VALUE, MESAGE, REQUIRED LEVEL: (minimum level required to execute the TRIGGER)
    { ["heal1"] = { 'hp', "10", "1", "100% Health", -1 } },
    { ["heal2"] = { 'hp', "20", "2", "200% Health", -1 } },
    { ["heal3"] = { 'hp', "30", "3", "300% Health", -1 } },
    { ["heal4"] = { 'hp', "40", "4", "400% Health", -1 } },

    -- repeat the structure to add new entries:
    { ["your_command"] = { 'sapp_command', "price_to_execute", "value", "custom_message", permission_level_number } },

    { ["am1"] = { 'ammo', "10", "200", "200 Ammo All Weapons", -1 } },
    { ["am2"] = { 'ammo', "20", "350", "350 Ammo All Weapons", -1 } },
    { ["am3"] = { 'ammo', "30", "500", "500 Ammo All Weapons", -1 } },
    { ["am4"] = { 'ammo', "40", "700", "700 Ammo All Weapons", -1 } },
    { ["am5"] = { 'ammo', "50", "900", "900 Ammo All Weapons", -1 } },

    { ["cam1"] = { 'camo', "30", "60", "1 Minute of Camo", -1 } },
    { ["cam2"] = { 'camo', "40", "120", "2 Minutes of Camo", -1 } },
    { ["cam3"] = { 'camo', "50", "180", "3 Minutes of Camo", -1 } },

    -- Note: balance command syntax here may change during development.
    { [1] = { "bal", "Money: $%money%", -1 } },

    -- Weapon Purchases:
    -- command | price | weapon | message
    { [2] = { "gold", "150", "reach\\objects\\weapons\\pistol\\magnum\\gold magnum", "Purchased Golden Gun for $%price%. New balance: $%balance%", -1 } },

    -- keyword | sapp_command | price | count | message
    { ["mine"] = { 'nades', "15", "2", "%count% Mines", -1 } },
    { ["gren"] = { 'ammo', "10", "2", "%count% Grenades", -1 } },
}

local upgrade_info = {
    "|cBIGASS AURORA UPGRADE SYTSTEM",
    " ",
    "|cPURCHASE UPGRADES",
    " ",
    "|cCommand | Upgrade | Cost",
    " ",
    "|c/heal1 | Health 100% | 10          /am1 | 200 Ammo All Weapons | 10",
    "|c/heal2 | Health 200% | 20          /am2 | 350 Ammo All Weapons | 20",
    "|c/heal3 | Health 300% | 30          /am3 | 500 Ammo All Weapons | 30",
    "|c/heal4 | Health 400% | 40          /am4 | 700 Ammo All Weapons | 40",
    "|c/heal5 | Health 500% | 50          /am5 | 900 Ammo All Weapons | 50",
    " ",
    "|c/cam1 | 1 Min Camo | 30            /mine | 2 Mines | 15",
    "|c/cam2 | 2 Min Camo | 40          /gren | 2 Grenades | 10",
    "|c/cam3 | 3 Min Camo | 50          /gold | Golden Gun | 150",
    " ",  
    " ",
    "|c*Type /bal to view how many Upgrade Points you currently have*",
    " ",
}

local stats = {

    combo = {
        [1] = { "3", "20", "(x%combos%) Kill Combo +%upgrade_points% Upgrade Points" },
        [2] = { "4", "20", "(x%combos%) Kill Combo +%upgrade_points% Upgrade Points" },
        [3] = { "5", "20", "(x%combos%) Kill Combo +%upgrade_points% Upgrade Points" },
        duration = 7 -- in seconds (default 5)
    },

    streaks = {
        [1] = { "5", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [2] = { "10", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [3] = { "15", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [4] = { "20", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [5] = { "25", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [6] = { "30", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [7] = { "35", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [8] = { "40", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
    },

    assists = {
        [1] = { "5", "15", "(x%assists%) Assists +%upgrade_points% Upgrade Points" },
        [2] = { "10", "15", "(x%assists%) Assists +%upgrade_points% Upgrade Points" },
        [3] = { "15", "15", "(x%assists%) Assists +%upgrade_points% Upgrade Points" },
        [4] = { "20", "15", "(x%assists%) Assists +%upgrade_points% Upgrade Points" },
        [5] = { "25", "15", "(x%assists%) Assists +%upgrade_points% Upgrade Points" },
        [6] = { "30", "15", "(x%assists%) Assists +%upgrade_points% Upgrade Points" },
    },
    
    kills = {
        [1] = { "5", "10", "Kills: (%kills%) +%upgrade_points% Upgrade Points" },
        [2] = { "10", "10", "Kills: (%kills%) +%upgrade_points% Upgrade Points" },
        [3] = { "20", "10", "Kills: (%kills%) +%upgrade_points% Upgrade Points" },
        [4] = { "30", "10", "Kills: (%kills%) +%upgrade_points% Upgrade Points" },
        [5] = { "40", "10", "Kills: (%kills%) +%upgrade_points% Upgrade Points" },
        [6] = { "50", "10", "Kills: (%kills%) +%upgrade_points% Upgrade Points" },
        [7] = { "60", "10", "Kills: (%kills%) +%upgrade_points% Upgrade Points" },
        [8] = { "70", "10", "Kills: (%kills%) +%upgrade_points% Upgrade Points" },
        [9] = { "80", "10", "Kills: (%kills%) +%upgrade_points% Upgrade Points" },
        [10] = { "90", "20", "Kills: (%kills%) +%upgrade_points% Upgrade Points" },
        [11] = { "100", "30", "Kills: (%kills%) +%upgrade_points% Upgrade Points" },
    },

    -- [ deaths (victim)] --
    { ["event_die"] = { '-20', "DEATH (-%penalty_points% points)" } },

    -- [ suicide ]
    { ["event_suicide"] = { '-30', "SUICIDE (-%penalty_points% points)" } },

    -- [ team kill ]
    { ["event_tk"] = { '-50', "TEAM KILL (-%penalty_points% points)" } },

    -- [ assist ]
    { ["event_assist"] = { '-50', "ASSIST (-%upgrade_points% points)" } },

    -- [ score ]
    { ["event_score"] = { '10', "+%upgrade_points% Upgrade Points" } },
}

-- Configuration [ends] -----------------------------------------------------------------

local money, mod, ip_table, weapon = { }, { }, { }, { }
local dir = "sapp\\stats.data"

local players = { }
local run_combo_timer = { }

-- Not currently used
-- local file_format = "%ip%|%money%"

local gsub, match, concat, floor, lower = string.gsub, string.match, table.concat, math.floor, string.lower

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_DIE'], 'OnPlayerKill')

    register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")

    register_callback(cb['EVENT_ASSIST'], "OnPlayerAssist")
    register_callback(cb['EVENT_SCORE'], "OnPlayerScore")

    --register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")

    checkFile()
end

function OnScriptUnload()
    -- to do
end

function OnGameStart()
    -- to do
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            players[i] = nil
        end
    end
end

function OnPlayerScore(PlayerIndex)
    for key, _ in ipairs(stats) do
        local event_score = stats[key]["event_score"]
        if (event_score ~= nil) then
            local params = { }
            params.ip = getIP(PlayerIndex)
            params.money = event_score[1]
            params.subtract = false
            money:update(params)
            rprint(PlayerIndex, gsub(event_score[2], "%%upgrade_points%%", params.money))
            break
        end
    end
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
            cprint("You cannot execute this command from the console.", 4 + 8)
            return false
        end
    end
    
    if (command == lower(upgrade_info_command)) then
        if (checkAccess(executor, upgrade_perm_lvl)) then
            if (args[1] == nil) then
                for k, _ in pairs(upgrade_info) do
                    if (k) then
                        rprint(executor, upgrade_info[k])
                    end
                end
            end
        end
        return false
    end


    local ip = getIP(executor)
    local balance = money:getbalance(ip)

    local TYPE_ONE

    for key, _ in ipairs(commands) do
        local cmd = commands[key][command]

        if (cmd ~= nil) then
            TYPE_ONE = true
            local lvl = cmd[#cmd]
            if checkAccess(executor, lvl) then
                if (#cmd > 2) then
                    if (balance >= tonumber(cmd[2])) then
                        execute_command(cmd[1] .. ' ' .. executor .. ' ' .. cmd[3])
                        local strFormat = gsub(cmd[4], "%%count%%", cmd[3])
                        rprint(executor, strFormat)
                    else
                        rprint(executor, gsub(gsub(insufficient_funds, "%%balance%%", balance), "%%price%%", cmd[2]))
                    end
                    return false
                end
            end
        end
        if not (TYPE_ONE) then
            local bal = commands[key][1]
            local gold = commands[key][2]

            -- Balance Command
            if (bal ~= nil) and (command == bal[1]) then
                rprint(executor, gsub(bal[2], "%%money%%", balance))
                return false
            end

            -- Golden Gun
            if (gold ~= nil) and (command == gold[1]) then
                local params = { }
                params.ip = getIP(executor)
                params.money = gold[2]
                params.subtract = true
                money:update(params)
                local new_balance = money:getbalance(ip)
                rprint(executor, gsub(gsub(gold[4], "%%price%%", gold[2]), "%%balance%%", new_balance))
                execute_command_sequence('wdel ' .. executor .. ' 0;spawn weap ' .. gold[3] .. ' ' .. executor .. ';wadd ' .. executor)
                return false
            end
        end
    end
end

function money:Purchase(params)
    -- to do
end

function money:update(params)
    local params = params or {}

    local ip = params.ip or nil
    local points = params.money or nil
    local subtract = params.subtract or nil
    local balance = tonumber(money:getbalance(ip))

    local new_balance = balance

    if not (subtract) then
        new_balance = balance + tonumber(points)
    else
        new_balance = balance - tonumber(points)
    end

    new_balance = new_balance

    if (new_balance <= 0) then
        new_balance = 0
    end

    local found
    local lines = lines_from(dir)
    for _, v in pairs(lines) do
        if containsExact(ip, v) then
            found = true

            local fRead = io.open(dir, "r")
            local content = fRead:read("*all")
            fRead:close()

            content = gsub(content, v, ip .. "|" .. tostring(new_balance))

            local fWrite = io.open(dir, "w")
            fWrite:write(content)
            fWrite:close()
        end
    end

    if not (found) then
        local file = assert(io.open(dir, "a+"))
        file:write(ip .. "|" .. tostring(new_balance) .. "\n")
        file:close()
    end
end

function money:Accept(params)
    -- to do
end

function money:Decline(params)
    -- to do
end

function money:Transfer(params)
    -- to do
end

function money:getbalance(player_ip)

    local function stringSplit(inputString, Separator)
        if (Separator == nil) then
            Separator = "%s"
        end
        local t = {};
        local i = 1
        for str in string.gmatch(inputString, "([^" .. Separator .. "]+)") do
            t[i] = str
            i = i + 1
        end
        return t
    end

    local data, balance
    local lines = lines_from(dir)
    for _, v in pairs(lines) do
        if (v:match(player_ip)) then
            balance = v:match("|(.+)")
            data = stringSplit(balance, ",")
        end
    end

    local t, result = { }
    for i = 1, 1 do
        if data[i] then
            t[#t + 1] = data[i]
            result = tonumber(concat(t, ", "))
        else
            return 0
        end
    end

    if (result ~= nil) then
        if (result <= 0) then
            return 0
        else
            return result
        end
    end

    for _ in pairs(t) do
        t[_] = nil
    end
end

function money:getUpgrades(params)
    -- to do
end

function OnPlayerConnect(PlayerIndex)
    local hash = get_var(PlayerIndex, "$hash")
    local ip = get_var(PlayerIndex, "$ip"):match("(%d+.%d+.%d+.%d+)")
    if not ip_table[hash] then
        ip_table[hash] = {}
    end
    table.insert(ip_table[hash], { ["ip"] = ip })

    players[PlayerIndex] = players[PlayerIndex] or { }
    players[PlayerIndex].combo = 0
    players[PlayerIndex].combo_timer = 0
    players[PlayerIndex].kills = 0
    players[PlayerIndex].streaks = 0
    players[PlayerIndex].assists = 0
end

function OnPlayerDisconnect(PlayerIndex)
    players[PlayerIndex] = nil
end

function OnPlayerKill(PlayerIndex, KillerIndex)
    local killer = tonumber(KillerIndex)
    local victim = tonumber(PlayerIndex)

    local kTeam = get_var(victim, "$team")
    local vTeam = get_var(killer, "$team")

    local kip = getIP(killer)

    local function isTeamPlay()
        if get_var(0, "$ffa") == "0" then
            return true
        else
            return false
        end
    end

    if (killer > 0) then

        -- [Combo Scoring]
        if run_combo_timer[victim] then
            run_combo_timer[victim] = false
            players[victim].combo = 0
            players[victim].combo_timer = 0
        end

        players[killer].combo = players[killer].combo + 1
        if not (run_combo_timer[killer]) then
            run_combo_timer[killer] = true
        end

        function comboCheckDelay()
            if (players[killer].combo_timer > 0) then
                local p = { }
                p.type, p.total, p.id, p.ip, p.table = "combos", players[killer].combo, killer, kip, stats.combo
                mod:check(p)
            end
        end
        if (run_combo_timer[killer]) then
            timer(50, "comboCheckDelay")
        end

        -- Killer Reward
        if (killer ~= victim and kTeam ~= vTeam) then

            -- [ STREAKS ]
            if (players[victim].streaks > 0) then
                players[victim].streaks = 0
            end
            
            local p1 = { }
            players[killer].streaks = players[killer].streaks + 1
            p1.type, p1.total, p1.id, p1.ip, p1.table = "streaks", players[killer].streaks, killer, kip, stats.streaks
            mod:check(p1)
            
            local p2 = { }
            players[killer].kills = players[killer].kills + 1
            p2.type, p2.total, p2.id, p2.ip, p2.table = "kills", players[killer].kills, killer, kip, stats.kills
            mod:check(p2)

            -- Victim Penalty
            for key, _ in ipairs(stats) do
                local event_die = stats[key]["event_die"]
                if (event_die ~= nil) then
                    local p = { }
                    p.ip = getIP(victim)
                    p.money = event_die[1]
                    p.subtract = true
                    money:update(p)
                    rprint(victim, gsub(event_die[2], "%%penalty_points%%", p.money))
                end
            end
            
        -- Suicide
        elseif (victim == killer) then
            for key, _ in ipairs(stats) do
                local event_suicide = stats[key]["event_suicide"]
                if (event_suicide ~= nil) then
                    local p = { }
                    p.ip = getIP(victim)
                    p.money = event_suicide[1]
                    p.subtract = true
                    money:update(p)
                    rprint(victim, gsub(event_suicide[2], "%%penalty_points%%", p.money))
                end
            end
        end
        -- Betray
        if (isTeamPlay() and (kTeam == vTeam)) and (killer ~= victim) then
            for key, _ in ipairs(stats) do
                local event_tk = stats[key]["event_tk"]
                if (event_tk ~= nil) then
                    local p = { }
                    p.ip = getIP(killer)
                    p.money = event_tk[1]
                    p.subtract = true
                    money:update(p)
                    rprint(killer, gsub(event_tk[2], "%%penalty_points%%", p.money))
                    break
                end
            end
        end
    end
end

function mod:check(params)
    local params = params or {}
    local ip = params.ip or nil
    local PlayerIndex = params.id or nil
    local identifier = params.type or nil
    local total = params.total or nil
    local t = params.table or nil
    local p = { }
    for i = 1, #t do
        local required = tonumber(t[i][1])
        if (required ~= nil) then
            if (total == required) then
                p.money = t[i][2]
                p.subtract = false
                p.ip = ip
                money:update(p)
                local message = t[i][3]
                rprint(PlayerIndex, gsub(gsub(message, "%%" .. tostring(identifier) .. "%%", required), "%%upgrade_points%%", p.money))
                break
            end
        end
    end
end

function OnPlayerAssist(PlayerIndex)
    players[PlayerIndex].assists = players[PlayerIndex].assists + 1
    local p, ip = { }, getIP(PlayerIndex)
    p.type, p.total, p.id, p.ip, p.table = "assists", players[PlayerIndex].assists, PlayerIndex, ip, stats.assists
    mod:check(p)
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            if (run_combo_timer[i]) then
                players[i].combo_timer = players[i].combo_timer + 0.030
                if (players[i].combo_timer >= floor(stats.combo.duration)) then
                    run_combo_timer[i] = false
                    players[i].combo_timer = 0
                    players[i].combo = 0
                end
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

function containsExact(w, s)
    return select(2, s:gsub('^' .. w .. '%W+', '')) +
            select(2, s:gsub('%W+' .. w .. '$', '')) +
            select(2, s:gsub('^' .. w .. '$', '')) +
            select(2, s:gsub('%W+' .. w .. '%W+', '')) > 0
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

function report()
    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)
end

function OnError()
    cprint(debug.traceback(), 4 + 8)
    timer(50, "report")
end

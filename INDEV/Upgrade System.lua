
--[[
--=====================================================================================================--
Script Name: Upgrade System, for SAPP (PC & CE)
Description:
            Earn 'money' for:
            -> Kills & Assists
            -> Kill-Combos & Kill-Streaks
            -> CTF Scoring
            Use your money to buy weapons and upgrades with custom commands.
            [!] More details will come at a later date.
            [!] STILL IN DEVELOPMENT (approx 97% complete)
			
			TO DO:
			* Bug fixes
			* Write money transfer command
			* Possibly refactor some code. 
			* Final tests before publishing as a finished resource
       
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

-- Configuration [starts]

-- If this is true, player money will be permanently saved when they exit the server and restored when they rejoin.
local save_money = true
-- Player money data will be saved to the following file. (Located in the servers root "sapp" dir)
local dir = "sapp\\money.data"

-- Custom Variables that can be used in 'Insufficient Funds' message: 
-- "%balance%" (current balance)
-- "%price%" (money required to execute TRIGGER)
local insufficient_funds = "Insufficient funds. Current balance: $%balance%. You need $%price%"

-- The balance each player will start with when they join the server for the first time.
-- Note: If 'save_money' is false, the player's balance on join will always be the value of "starting_balace"
local starting_balace = 0

local upgrade_info_command = "upgrades"
local upgrade_perm_lvl = -1

-- Give yourself money!
local add_command = "add"
local add_perm_level = 4

local remove_command = "remove"
local remove_perm_level = 4

local commands = {
    -- TRIGGER, COMMAND, COST, VALUE, MESAGE, REQUIRED LEVEL: (minimum level required to execute the TRIGGER)
    { ["heal1"] = { 'hp', "10", "1", "Purchased 100% Health for $%price%. New balance: $%balance%", -1 } },
    { ["heal2"] = { 'hp', "20", "2", "Purchased 200% Health for $%price%. New balance: $%balance%", -1 } },
    { ["heal3"] = { 'hp', "30", "3", "Purchased 300% Health for $%price%. New balance: $%balance%", -1 } },
    { ["heal4"] = { 'hp', "40", "4", "Purchased 400% Health for $%price%. New balance: $%balance%", -1 } },
    { ["heal5"] = { 'hp', "50", "5", "Purchased 500% Health for $%price%. New balance: $%balance%", -1 } },

    -- repeat the structure to add new entries:
    { ["your_command"] = { 'sapp_command', "price_to_execute", "value", "custom_message", permission_level_number } },

    { ["am1"] = { 'ammo', "10", "200", "Purchased (900 Ammo All Weapons) for $%price%. New balance: $%balance%", -1 } },
    { ["am2"] = { 'ammo', "10", "350", "Purchased (350 Ammo All Weapons) for $%price%. New balance: $%balance%", -1 } },
    { ["am3"] = { 'ammo', "10", "500", "Purchased (500 Ammo All Weapons) for $%price%. New balance: $%balance%", -1 } },
    { ["am4"] = { 'ammo', "10", "700", "Purchased (700 Ammo All Weapons) for $%price%. New balance: $%balance%", -1 } },
    { ["am5"] = { 'ammo', "10", "900", "Purchased (900 Ammo All Weapons) for $%price%. New balance: $%balance%", -1 } },

    { ["cam1"] = { 'camo', "30", "60", "Purchased (1 Minute of Camo) for $%price%. New balance: $%balance%", -1 } },
    { ["cam2"] = { 'camo', "40", "120", "Purchased (2 Minutes of Camo) for $%price%. New balance: $%balance%", -1 } },
    { ["cam3"] = { 'camo', "50", "180", "Purchased (3 Minutes of Camo) for $%price%. New balance: $%balance%", -1 } },

    -- Note: balance command syntax here may change during development.
    { [1] = { "bal", "Money: $%money%", -1 } },

    -- keyword | sapp_command | price | count | message
    { ["mine"] = { 'nades', "15", "2", "Purchased (%count% Mines) for $%price%. New balance: $%balance%", -1 } },
    { ["gren"] = { 'nades', "10", "2", "Purchased (%count% Grenades) for $%price%. New balance: $%balance%", -1 } },
    
    -- Weapon Purchases:
    -- command | price | weapon | message
    weapons = {
    { ["gold"] = { '200', "reach\\objects\\weapons\\pistol\\magnum\\gold magnum", "Purchased Golden Gun for $%price%. New balance: $%balance%", -1 } },
    --{ ["gold"] = { '200', "weapons\\pistol\\pistol", "Purchased Golden Gun for $%price%. New balance: $%balance%", -1 } },
    
    { ["mine"] = { '15', "tag_id", "Purchased (%count% Mines) for $%price%. New balance: $%balance%", -1 } },
    { ["gren"] = { '10', "tag_id", "Purchased (%count% Grenades) for $%price%. New balance: $%balance%", -1 } },
    
    },
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
        -- required kills [number] | reward [number] | message [string]
        -- Custom variables that can be used in COMBO messages: %combos% (current combo) | %upgrade_points% (reward points)
        [1] = { "3", "20", "(x%combos%) Kill Combo +%upgrade_points% Upgrade Points" },
        [2] = { "4", "20", "(x%combos%) Kill Combo +%upgrade_points% Upgrade Points" },
        [3] = { "5", "20", "(x%combos%) Kill Combo +%upgrade_points% Upgrade Points" },
        -- Repeat the structure to add more entries.
        -- Time you have to get X amount of kill-combos
        duration = 7 -- in seconds (default 7)
    },

    streaks = {
        -- Custom variables that can be used in STREAK messages: %streaks% (current streak) | %upgrade_points% (reward points)
        -- required streaks [number] | reward [number] | message [string]
        [1] = { "5", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [2] = { "10", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [3] = { "15", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [4] = { "20", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [5] = { "25", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [6] = { "30", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [7] = { "35", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        [8] = { "40", "15", "(x%streaks%) Kill Streak +%upgrade_points% Upgrade Points" },
        -- Repeat the structure to add more entries.
    },

    assists = {
        -- Custom variables that can be used in ASSIST messages: %streaks% (current assists) | %upgrade_points% (reward points)
        -- required assists [number] | reward [number] | message [string]
        [1] = { "5", "15", "(x%assists%) Assists +%upgrade_points% Upgrade Points" },
        [2] = { "10", "15", "(x%assists%) Assists +%upgrade_points% Upgrade Points" },
        [3] = { "15", "15", "(x%assists%) Assists +%upgrade_points% Upgrade Points" },
        [4] = { "20", "15", "(x%assists%) Assists +%upgrade_points% Upgrade Points" },
        [5] = { "25", "15", "(x%assists%) Assists +%upgrade_points% Upgrade Points" },
        [6] = { "30", "15", "(x%assists%) Assists +%upgrade_points% Upgrade Points" },
        -- Repeat the structure to add more entries.
    },
    
    kills = {
        -- Custom variables that can be used in (consecutive) KILL messages: %kills% (current kills) | %upgrade_points% (reward points)
        -- required kills [number] | reward [number] | message [string]
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
        -- Repeat the structure to add more entries.
    },

    penalty = {
        -- [ victim death ] (points deducted | message)
        [1] = { "20", "DEATH (-%penalty_points% points)" },
        -- [ victim suicide ] (points deducted | message)
        [2] = { "30", "SUICIDE (-%penalty_points% points)" },
        -- [ killer betray ] (points deducted | message)
        [3] = { "50", "TEAM KILL (-%penalty_points% points)" },
    },

    score = {
        -- [ score ] (reward points | message)
        [1] = { "10", "SCORE (+%upgrade_points% Upgrade Points)" },
    },
}

-- Configuration [ends] -----------------------------------------------------------------

-- Do not touch.
local money, mod, ip_table, weapon = { }, { }, { }, { }

local players = { }
local run_combo_timer = { }
local money_table = { }
local check_for_room, give_weapon = { }, { }
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

    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")

    checkFile()
    for i = 1, 16 do
        if player_present(i) then
            local hash = get_var(i, "$hash")
            if not ip_table[hash] then
                ip_table[hash] = {}
            end
            local ip = get_var(i, "$ip")
            table.insert(ip_table[hash], { ["ip"] = ip })

            players[i] = players[i] or { }
            players[i].combos = 0
            players[i].combo_timer = 0
            players[i].kills = 0
            players[i].streaks = 0
            players[i].assists = 0
            run_combo_timer[i] = false
            check_for_room[i] = false
            give_weapon[i] = false
        end
    end
    if not (save_money) then
        money_table = {["money"] = {}}
    end
end

function OnScriptUnload()
    for i = 1, 16 do
        if player_present(i) then
            players[i] = nil
            run_combo_timer[i] = nil
            local hash = get_var(i, "$hash")
            ip_table[hash] = nil
            check_for_room[i] = false
            give_weapon[i] = false
        end
    end
end

function OnGameStart()
    -- not currently used
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            run_combo_timer[i] = nil
            check_for_room[i] = false
            give_weapon[i] = false
        end
    end
end

function OnPlayerScore(PlayerIndex)
    local p, ip = { }, getIP(PlayerIndex)
    p.ip, p.money, p.subtract = ip, stats.score[1][1], false
    money:update(p)
    rprint(PlayerIndex, gsub(stats.score[1][2], "%%upgrade_points%%", p.money))
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
    
    local function AddRemove(bool)
        local ip = getIP(executor)
        local p = { }
        p.ip = ip
        p.money = args[1]
        p.subtract = bool
        money:update(p)
    end
    
    if (command == lower(upgrade_info_command)) then
        if (checkAccess(executor, upgrade_perm_lvl)) then
            if (args[1] == nil) then
                for k, _ in pairs(upgrade_info) do
                    if (k) then
                        rprint(executor, upgrade_info[k])
                    end
                end
            else
                rprint(executor, "Invalid Syntax. Usage: /" .. command)
            end
        end
        return false
    elseif (command == lower(add_command)) then
        if (checkAccess(executor, add_perm_level)) then
            if (args[1] ~= nil) and args[1]:match("%d+") then
                AddRemove(false)
                local ip = getIP(executor)
                local balance = money:getbalance(ip)
                rprint(executor, "Success! $" .. args[1] .. " has been added to your account. ")
                rprint(executor, "New Balance: " .. balance)
            else
                rprint(executor, "Invalid Syntax. Usage: /" .. command)
            end
            return false
        end
    elseif (command == lower(remove_command)) then
        if (checkAccess(executor, remove_perm_level)) then
            if (args[1] ~= nil) and args[1]:match("%d+") then
                AddRemove(true)
                local ip = getIP(executor)
                local balance = money:getbalance(ip)
                rprint(executor, "Success! $" .. args[1] .. " has been taken from your account. ")
                rprint(executor, "New Balance: " .. balance)
            else
                rprint(executor, "Invalid Syntax. Usage: /" .. command)
            end
            return false
        end
    end

    local TYPE_ONE
    
    for key, _ in ipairs(commands) do
        local cmd = commands[key][command]
        if (cmd ~= nil) then
            TYPE_ONE = true
            local lvl = cmd[#cmd]
            if checkAccess(executor, lvl) then
                if (#cmd > 2) then
                    if (args[1] == nil) then
                        local ip = getIP(executor)
                        local balance = money:getbalance(ip)
                        local cost = cmd[2]
                        if (balance >= tonumber(cost)) then
                            execute_command(cmd[1] .. ' ' .. executor .. ' ' .. cmd[3])
                            local p = { }
                            p.ip = ip
                            p.money = cost
                            p.subtract = true
                            money:update(p)
                            local new_balance = money:getbalance(ip)
                            local count = cmd[3]
                            local strFormat = gsub(gsub(gsub(cmd[4], "%%price%%", cmd[2]), "%%balance%%", new_balance), "%%count%%", count)
                            rprint(executor, strFormat)
                        else
                            rprint(executor, gsub(gsub(insufficient_funds, "%%balance%%", balance), "%%price%%", cmd[2]))
                        end
                    else
                        rprint(executor, "Invalid Syntax. Usage: /" .. command)
                    end
                    return false
                end
            end
        end
        
        function getweaponobjectid(player, slot)
            local player_object = get_dynamic_player(executor)
            if player_object then
                return read_dword(get_object_memory(player_object) + 0x2F8 + slot * 4)
            end
        end
    
        if not (TYPE_ONE) then
            local tab = commands.weapons
            for key, _ in ipairs(tab) do
                local entry = tab[key][command]
                if (entry ~= nil) then
                    local cost = entry[1]
                    local tag_id = entry[2]
                    local message = entry[3]
                    local lvl = entry[4]
                    if checkAccess(executor, lvl) then
                        if TagInfo("weap", tag_id) then                        
                            check_for_room[executor] = true
                            function delay_add()
                                if (give_weapon[executor]) then
                                    local ip = getIP(executor)
                                    local balance = money:getbalance(ip)
                                    if (balance >= tonumber(cost)) then
                                        local p = { }
                                        p.ip, p.money, p.subtract = ip, cost, true
                                        money:update(p)
                                        local new_balance = money:getbalance(ip)
                                        local strFormat = gsub(gsub(message, "%%price%%", cost), "%%balance%%", new_balance)
                                        rprint(executor, strFormat)
                                        execute_command_sequence('spawn weap ' .. tag_id .. ' ' .. executor .. ';wadd ' .. executor)
                                        give_weapon[executor] = false
                                    else
                                        rprint(executor, gsub(gsub(insufficient_funds, "%%balance%%", balance), "%%price%%", cost))
                                    end
                                else
                                    rprint(executor, "You don't have enough room in your inventory.")
                                end
                            end
                            timer(50, "delay_add")
                        else
                            rprint(executor, "That doesn't command work on this map.")
                        end
                    end
                    return false
                end
            end
            local bal = commands[key][1]
            -- Balance Command
            if (bal ~= nil) and (command == bal[1]) then
                if checkAccess(executor, bal[3]) then
                    local balance = money:getbalance(getIP(executor))   
                    rprint(executor, gsub(bal[2], "%%money%%", balance))
                end
                return false
            end
        end
    end
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
    
    if (save_money) then
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
    else
        for key, _ in pairs(money_table["money"]) do
            if (ip == key) then
                money_table["money"][key].balance = new_balance
            end
        end
    end
end

function money:Transfer(params)
    -- to do
end

function money:getbalance(player_ip)
    
    if (save_money) then
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
    else
        for key, _ in pairs(money_table["money"]) do
            if (player_ip == key) then
                if (money_table["money"][key].balance <= 0) then
                    return 0
                else
                    return money_table["money"][key].balance
                end
            end
        end
    end
end

function OnPlayerConnect(PlayerIndex)

    local hash = get_var(PlayerIndex, "$hash")
    local ip = get_var(PlayerIndex, "$ip")
    
    if not ip_table[hash] then
        ip_table[hash] = {}
    end
    table.insert(ip_table[hash], { ["ip"] = ip })

    players[PlayerIndex] = players[PlayerIndex] or { }
    players[PlayerIndex].combos = 0
    players[PlayerIndex].combo_timer = 0
    players[PlayerIndex].kills = 0
    players[PlayerIndex].streaks = 0
    players[PlayerIndex].assists = 0
    
    check_for_room[PlayerIndex] = false
    give_weapon[PlayerIndex] = false
    
    if (save_money) then
        local found
        local lines = lines_from(dir)
        for _, v in pairs(lines) do
            if containsExact(ip, v) then
                found = true
            end
        end

        if not (found) then
            local file = assert(io.open(dir, "a+"))
            file:write(ip .. "|" .. tostring(starting_balace) .. "\n")
            file:close()
        end
    else
        money_table["money"][ip] = { ["balance"] = starting_balace }
    end
end

function OnPlayerDisconnect(PlayerIndex)
    players[PlayerIndex] = nil
    check_for_room[PlayerIndex] = false
    give_weapon[PlayerIndex] = false
    local ip = getIP(PlayerIndex)
    if not (save_money) then
        money_table["money"][ip] = { ["balance"] = starting_balace }
    end
end

function OnPlayerKill(PlayerIndex, KillerIndex)
    local killer = tonumber(KillerIndex)
    local victim = tonumber(PlayerIndex)

    local function isTeamPlay()
        if get_var(0, "$ffa") == "0" then
            return true
        else
            return false
        end
    end

    if (killer > 0) then
    
        local kTeam = get_var(victim, "$team")
        local vTeam = get_var(killer, "$team")
    
        local kip = getIP(killer)
        local vip = getIP(victim)

        -- [Combo Scoring]
        if run_combo_timer[victim] then
            run_combo_timer[victim] = false
            players[victim].combos = 0
            players[victim].combo_timer = 0
        end

        players[killer].combos = players[killer].combos + 1
        if not (run_combo_timer[killer]) then
            run_combo_timer[killer] = true
        end

        function comboCheckDelay()
            if (players[killer].combo_timer > 0) then
                local p = { }
                p.type, p.total, p.id, p.ip, p.table = "combos", players[killer].combos, killer, kip, stats.combo
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
            p1.type, p1.total, p1.id, p1.ip, p1.table, p1.subtract= "streaks", players[killer].streaks, killer, kip, stats.streaks, false
            mod:check(p1)
            
            local p2 = { }
            players[killer].kills = players[killer].kills + 1
            p2.type, p2.total, p2.id, p2.ip, p2.table, p2.subtract = "kills", players[killer].kills, killer, kip, stats.kills, false
            mod:check(p2)
            
            -- Victim Death Penalty
            local p3 = { }
            p3.ip, p3.money, p3.subtract = vip, stats.penalty[1][1], true
            money:update(p3)
            rprint(victim, gsub(stats.penalty[1][2], "%%penalty_points%%", p3.money))
            
        -- Victim Suicide
        elseif (victim == killer) then
            local p = { }
            p.ip, p.money, p.subtract = vip, stats.penalty[2][1], true
            money:update(p)
            rprint(victim, gsub(stats.penalty[2][2], "%%penalty_points%%", p.money))
        end
        -- Betray
        if (isTeamPlay() and (kTeam == vTeam)) and (killer ~= victim) then
            local p = { }
            p.ip, p.money, p.subtract = vip, stats.penalty[3][1], true
            money:update(p)
            rprint(victim, gsub(stats.penalty[3][2], "%%penalty_points%%", p.money))
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
    local subtract = params.subtract
    local p = { }
    for i = 1, #t do
        local required = tonumber(t[i][1])
        if (required ~= nil) then
            if (total == required) then
                p.money = t[i][2]
                p.subtract = subtract
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
    p.type, p.total, p.id, p.ip, p.table, p.subtract = "assists", players[PlayerIndex].assists, PlayerIndex, ip, stats.assists, false
    mod:check(p)
end

local function hasEnoughRoom(executor)
    local player_object = get_dynamic_player(executor)
    if player_object ~= 0 then
        local weapon
        for i = 0,3 do
            weapon = get_object_memory(read_dword(player_object + 0x2F8 + i * 4))
            if (weapon ~= 0) then 
                print(weapon)
                if (weapon ~= 1074148100) then
                    return true
                else
                    check_for_room[executor] = false
                    return false
                end
            end
        end
    end
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            if (check_for_room[i]) then
                local player_object = get_dynamic_player(i)
                if (player_object ~= 0)then
                    local weapon
                    for j = 0,3 do
                        weapon = get_object_memory(read_dword(player_object + 0x2F8 + j * 4))
                        if (weapon ~= 0) then 
                            if (weapon ~= 1074148100) then
                                give_weapon[i] = true
                                check_for_room[i] = false
                            else
                                give_weapon[i] = false
                                check_for_room[i] = false
                            end
                        end
                    end
                end
            end
            if (run_combo_timer[i]) then
                players[i].combo_timer = players[i].combo_timer + 0.030
                if (players[i].combo_timer >= floor(stats.combo.duration)) then
                    run_combo_timer[i] = false
                    players[i].combo_timer = 0
                    players[i].combos = 0
                end
            end
        end
    end
end

function getIP(PlayerIndex)
    local hash = get_var(PlayerIndex, "$hash")
    if next(ip_table) then
        if ip_table[hash] ~= nil or ip_table[hash] ~= {} then
            for key, _ in ipairs(ip_table[hash]) do
                return ip_table[hash][key]["ip"]
            end
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

function TagInfo(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
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

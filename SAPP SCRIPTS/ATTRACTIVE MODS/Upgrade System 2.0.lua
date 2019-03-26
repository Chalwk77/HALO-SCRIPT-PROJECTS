--[[
--=====================================================================================================--
Script Name: Upgrade System, for SAPP (PC & CE)
Description: This is an economy mod.
            Earn 'money' for:
            -> Kills & Assists
            -> Kill-Combos & Kill-Streaks
            -> CTF Scoring
            Use your money to buy weapons and upgrades with custom commands.
       
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

-- Configuration [starts]

-- If this is true, player money will be permanently saved when they exit the server and restored when they rejoin.
local save_money = false
-- Player money data will be saved to the following file. (Located in the servers root "sapp" dir)
local dir = "sapp\\money.data"

-- Custom Variables that can be used in 'Insufficient Funds' message: 
-- "%balance%" (current balance)
-- "%price%" (money required to execute TRIGGER)
local insufficient_funds = "Insufficient funds. Current balance: $%balance%. You need $%price%"

-- The balance each player will start with when they join the server for the first time.
-- Note: If 'save_money' is false, the player's balance on join will always be the value of "starting_balance"
local starting_balance = 0

local balance_command = "bal"
local balance_perm_lvl = -1
local balance_msg_format = "Upgrade Points: %money%"

local upgrade_info_command = "upgrades"
local upgrade_perm_lvl = -1

-- Add money to your account (perm level to execute is 4 by default)
local add_cmd = "add"
local add_perm_lvl = 4
local add_cmd_message = "$%money% has been added to your account. New Balance: $%balance%"

-- Deduct money from your account (perm level to execute is 4 by default)
local remove_cmd = "remove"
local remove_perm_lvl = 4
local remove_cmd_message = "$%money% has been remove from account. New Balance: $%balance%"

-- Transfer your funds to other players!
-- Command syntax: /transfer [player id | */all] [amount] (optional -s)
-- You can split the amount specified between the players specified by declaring the "-s" flag.
local transfer_command = "transfer"
local transfer_perm_lvl = -1
local transfer_toSenderMsg = "You sent %receiver_name% $%amount%. New Balance: $%sender_balance%"
local transfer_toReceiverMsg = "%sender_name% sent you $%amount%. New balance: $%receiver_balance%"

local weapon_list = "weapons"
local weapon_list_perm = -1
local max_columns, max_results = 5, 25
local startIndex = 1 -- <<--- do not touch
local endIndex = max_columns -- <<--- do not touch
local spaces = 2 -- Spaces between results
local output_format = "/%command% | $%price%"

local commands = {
    sapp = {
        {
            ["heal"] = { -- Command Syntax: /heal [id]. (example, /heal 5, will give you 500% Health).
                id = "hp", --<<---- do not touch
                -- PRICE | HEALTH AMOUNT | MESSAGE | PERMISSION LEVEL | ENABLED/DISABLED
                [1] = { "10", "1", "Purchased 100% Health for $%price%. New balance: $%balance%", -1, true },
                [2] = { "15", "2", "Purchased 200% Health for $%price%. New balance: $%balance%", -1, true },
                [3] = { "20", "3", "Purchased 300% Health for $%price%. New balance: $%balance%", -1, true },
                [4] = { "25", "4", "Purchased 400% Health for $%price%. New balance: $%balance%", -1, true },
                [5] = { "30", "5", "Purchased 500% Health for $%price%. New balance: $%balance%", -1, true },
            },

            ["am"] = { -- Command Syntax: /am [id]. (example, /am 5, will give you 900 Ammo All Weapons).
                id = "ammo", --<<---- do not touch
                -- PRICE | AMMO AMOUNT + INDEX | MESSAGE | PERMISSION LEVEL | ENABLED/DISABLED
                [1] = { "10", "200 5", "Purchased (200 Ammo All Weapons) for $%price%. New balance: $%balance%", -1, true },
                [2] = { "15", "350 5", "Purchased (350 Ammo All Weapons) for $%price%. New balance: $%balance%", -1, true },
                [3] = { "20", "500 5", "Purchased (500 Ammo All Weapons) for $%price%. New balance: $%balance%", -1, true },
                [4] = { "25", "700 5", "Purchased (700 Ammo All Weapons) for $%price%. New balance: $%balance%", -1, true },
                [5] = { "30", "900 5", "Purchased (900 Ammo All Weapons) for $%price%. New balance: $%balance%", -1, true },
            },

            ["cam"] = { -- Command Syntax: /cam [id]. (example, /cam 3, will give you 3 Minutes of Camo).
                id = "camo", --<<---- do not touch
                -- PRICE | DURATION | MESSAGE | PERMISSION LEVEL | ENABLED/DISABLED
                [1] = { "30", "60", "Purchased (1 Minute of Camo) for $%price%. New balance: $%balance%", -1, true },
                [2] = { "40", "120", "Purchased (2 Minutes of Camo) for $%price%. New balance: $%balance%", -1, true },
                [3] = { "50", "180", "Purchased (3 Minutes of Camo) for $%price%. New balance: $%balance%", -1, true },
            },
        },
    },

    -- CUSTOM GOD COMMAND
    custom_god = {
        {
            ["god2"] = { -- Command Syntax: /god2 [id]. (example, /god2 6, will give you 1 minute of god).
                id = "god", --<<---- do not touch
                -- PRICE | DURATION | MESSAGE | PERMISSION LEVEL | ENABLED/DISABLED
                [1] = { "5", "10", "Purchased (%seconds% Seconds of God) for $%price%. New balance: $%balance%", -1, true },
                [2] = { "10", "20", "Purchased (%seconds% Seconds of God) for $%price%. New balance: $%balance%", -1, true },
                [3] = { "15", "30", "Purchased (%seconds% Seconds of God) for $%price%. New balance: $%balance%", -1, true },
                [4] = { "20", "40", "Purchased (%seconds% Seconds of God) for $%price%. New balance: $%balance%", -1, true },
                [5] = { "25", "50", "Purchased (%seconds% Seconds of God) for $%price%. New balance: $%balance%", -1, true },
                [6] = { "30", "60", "Purchased (%seconds% Seconds of God) for $%price%. New balance: $%balance%", -1, true },
            },
        },
    },

    weapons = {
        {
            ["weapon_table"] = {
                -- command | price | tag id | message | permission level | enabled/disabled (set to true to enable)
                [1] = { "pistol", '10', "weapons\\pistol\\pistol", "Purchased Pistol for $%price%. New balance: $%balance%", -1, true },
                [2] = { "sniper", '15', "weapons\\sniper rifle\\sniper rifle", "Purchased Sniper for $%price%. New balance: $%balance%", -1, true },
                [3] = { "pcannon", '35', "weapons\\plasma_cannon\\plasma_cannon", "Purchased Plasma Cannon for $%price%. New balance: $%balance%", -1, true },
                [4] = { "rlauncher", '35', "weapons\\rocket launcher\\rocket launcher", "Purchased Rocket Launcher for $%price%. New balance: $%balance%", -1, true },
                [5] = { "ppistol", '5', "weapons\\plasma pistol\\plasma pistol", "Purchased Plasms Pistol for $%price%. New balance: $%balance%", -1, true },
                [6] = { "prifle", '5', "weapons\\plasma rifle\\plasma rifle", "Purchased Plasma Rifle for $%price%. New balance: $%balance%", -1, true },
                [7] = { "arifle", '7', "weapons\\assault rifle\\assault rifle", "Purchased Assault Rifle for $%price%. New balance: $%balance%", -1, true },
                [8] = { "fthrower", '7', "weapons\\flamethrower\\flamethrower", "Purchased Flame  Thrower for $%price%. New balance: $%balance%", -1, true },
                [9] = { "needler", '5', "weapons\\needler\\mp_needler", "Purchased Needler for $%price%. New balance: $%balance%", -1, true },
                [10] = { "shotgun", '10', "weapons\\shotgun\\shotgun", "Purchased Shotgun for $%price%. New balance: $%balance%", -1, true },
                [11] = { "gold", '200', "reach\\objects\\weapons\\pistol\\magnum\\gold magnum", "Purchased Golden Gun for $%price%. New balance: $%balance%", -1, true },
                [12] = { "brifle", '50', "halo3\\weapons\\battle rifle\\tactical battle rifle", "Purchased Battle Rifle for $%price%. New balance: $%balance%", -1, true },
            },
        }
    },

    grenades = { -- command | price | amount | type | tag id | message | permission level | enabled/disabled (set to true to enable)
        { ["mine"] = { '15', "2", "1", "my_weapons\\trip-mine\\trip-mine", "Purchased (%count% Mines) for $%price%. New balance: $%balance%", -1, true } },
        { ["gren1"] = { '10', "2", "2", "my_weapons\\trip-mine\\trip-mine", "Purchased (%count% Grenades) for $%price%. New balance: $%balance%", -1, true } },

        { ["frag"] = { '10', "2", "1", "weapons\\frag grenade\\frag grenade", "Purchased (%count% Frag Grenades) for $%price%. New balance: $%balance%", -1, true } },
        { ["plasma"] = { '10', "2", "2", "weapons\\plasma grenade\\plasma grenade", "Purchased (%count% Plasma Grenades) for $%price%. New balance: $%balance%", -1, true } },
    },
}

local upgrade_info = {
    "|cBIGASS AURORA UPGRADE SYSTEM",
    " ",
    "|cPURCHASE UPGRADES",
    " ",
    "|cCommand | Upgrade | Cost",
    " ",
    "|c/heal 1 | Health 100% | 10        /am 1 | 200 Ammo All Weapons | 10",
    "|c/heal 2 | Health 200% | 20        /am 2 | 350 Ammo All Weapons | 20",
    "|c/heal 3 | Health 300% | 30        /am 3 | 500 Ammo All Weapons | 30",
    "|c/heal 4 | Health 400% | 40        /am 4 | 700 Ammo All Weapons | 40",
    "|c/heal 5 | Health 500% | 50        /am 5 | 900 Ammo All Weapons | 50",
    " ",
    "|c/cam 1 | 1 Min Camo | 30          /mine | 2 Mines | 15",
    "|c/cam 2 | 2 Min Camo | 40          /gren | 2 Grenades | 10",
    "|c/cam 3 | 3 Min Camo | 50          /gold | Golden Gun | 150",
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
        [1] = { "10", "DEATH (-%penalty_points% points)" },
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
local money, mod, ip_table = { }, { }, { }
local game_over

local players = { }
local run_combo_timer = { }
local money_table = { }
local check_available_slots, give_weapon = { }, { }
local divide = { }
local results = { }

-- CUSTOM GOD MODE
local godmode, trigger = { }, { }
local gsub, concat, floor, lower = string.gsub, table.concat, math.floor, string.lower

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
            ip_table[hash] = ip_table[hash] or { }

            local ip = get_var(i, "$ip")
            table.insert(ip_table[hash], { ["ip"] = ip })

            players[i] = players[i] or { }
            players[i].combos = 0
            players[i].combo_timer = 0
            players[i].kills = 0
            players[i].streaks = 0
            players[i].assists = 0
            players[i].god = 0
            players[i].god_duration = 0

            godmode[i] = nil
            trigger[i] = nil

            run_combo_timer[i] = false

            check_available_slots[i] = false
            give_weapon[i] = false

            divide[i] = false
            if not (save_money) then
                money_table = { ["money"] = {} }
                money_table["money"][ip] = { ["balance"] = starting_balance }
                rprint(i, "UPGRADE SYSTEM RELOADED -> MONEY RESET.")
            end
        end
    end
    if next(results) then
        for _ in pairs(results) do
            results[_] = nil
        end
    end
end

function OnScriptUnload()
    for i = 1, 16 do
        if player_present(i) then
            players[i] = nil

            local hash = get_var(i, "$hash")
            ip_table[hash] = nil

            run_combo_timer[i] = nil
            check_available_slots[i] = false
            give_weapon[i] = false

            divide[i] = false

            godmode[i] = nil
            trigger[i] = nil
        end
    end
end

local function stringSplit(inp, sep)
    if (sep == nil) then
        sep = "%s"
    end
    local t, i = {}, 1
    for str in string.gmatch(inp, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

local function spacing(n)
    local spacing = ""
    for i = 1, spaces do
        spacing = spacing .. " "
    end
    return spacing
end

function OnGameStart()
    game_over = false
    if not (save_money) then
        money_table = { ["money"] = {} }
    end

    -- Do not touch
    local original_StartIndex = tonumber(startIndex)
    local tab = commands.weapons
    for key, _ in pairs(tab) do
        local table_data = tab[key]["weapon_table"]
        if (table_data) then
            for k, _ in pairs(table_data) do
                local cmd = table_data[k][1]
                local cost = table_data[k][2]
                local tag_id = table_data[k][3]
                local enabled = table_data[k][6]
                if (enabled) then
                    local response = gsub(gsub(output_format, "%%command%%", cmd), "%%price%%", cost)
                    if TagInfo("weap", tag_id) then
                        results[#results + 1] = response
                    end
                end
            end
        end
    end
end

function OnGameEnd()
    game_over = true
    for i = 1, 16 do
        if player_present(i) then
            run_combo_timer[i] = nil
            check_available_slots[i] = false
            give_weapon[i] = false
            divide[i] = nil
            players[i] = nil
            godmode[i] = nil
            trigger[i] = nil
        end
    end
    for _ in pairs(results) do
        results[_] = nil
    end
end

function OnPlayerScore(PlayerIndex)
    local p, ip = { }, getIP(PlayerIndex)
    p.ip, p.money, p.subtract = ip, stats.score[1][1], false
    money:update(p)
    rprint(PlayerIndex, gsub(stats.score[1][2], "%%upgrade_points%%", p.money))
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

local function gameover(p)
    if (game_over) then
        rprint(p, "Command Failed -> Game has Ended.")
        rprint(p, "Please wait until the next game has started.")
        return true
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)

    local target_players, TargetID, target_all_players = { }, { }
    local ip

    local function checkAccess(e, level)
        if (e ~= -1 and e >= 1 and e < 16) then
            if (tonumber(get_var(e, "$lvl"))) >= level then
                ip = getIP(executor)
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

    local function validate_params()
        local function getplayers(arg, executor)
            local pl = { }
            if (arg:match("%d+")) then
                TargetID = tonumber(args[1])
                if (TargetID ~= executor) and (player_present(TargetID)) then
                    table.insert(pl, arg)
                end
            elseif (arg == "*") or (arg == "all") then
                for i = 1, 16 do
                    if (tonumber(i) ~= executor) and (player_present(i)) then
                        target_all_players = true
                        table.insert(pl, i)
                    end
                end
            else
                rprint(executor, "Invalid command parameter")
                is_error = true
                return false
            end
            if pl[1] then
                return pl
            end
            pl = nil
            return false
        end
        local pl, proceed, player_count, can_deposit = getplayers(args[1], executor)
        if pl then
            if (args[3] ~= nil) then
                if (args[3] == "-s") then
                    divide[executor] = true
                else
                    rprint(executor, "Error! (args[3]) ->  Invalid command flag. Usage: -s")
                    is_error = true
                    return false
                end
            end

            proceed, player_count = true, #pl
            local balance = money:getbalance(ip)
            for i = 1, #pl do
                if pl[i] == nil then
                    break
                end
                if (proceed) then
                    proceed = false
                    local amount = tonumber(args[2])
                    local required_amount = (amount * player_count)
                    local split = (amount / player_count)

                    if (divide[executor] == true) then
                        args[2] = math.floor(split)
                    end

                    if (balance < required_amount) and not (divide[executor]) then
                        if (balance >= amount) then
                            if (player_count > 1) then
                                rprint(executor, "You do not have enough money to send $" .. amount .. " to all (" .. player_count .. ") players.")
                                rprint(executor, 'You need $' .. required_amount .. '. Type "/transfer * ' .. amount .. ' -s"  to split $' .. math.floor(split) .. ' between ' .. player_count .. ' players.')
                            else
                                can_deposit, is_error = false, true
                                rprint(executor, "You do not have enough money to send $" .. amount .. " to " .. get_var(TargetID, "$name"))
                            end
                        else
                            can_deposit, is_error = false, true
                            rprint(executor, gsub(gsub(insufficient_funds, "%%balance%%", balance), "%%price%%", args[2]))
                        end
                    else
                        can_deposit = true
                    end
                    divide[executor] = false
                end

                if (can_deposit) then
                    if (balance >= tonumber(args[2])) then
                        target_players.eip = ip
                        target_players.eid = tonumber(get_var(executor, "$n"))
                        target_players.en = get_var(executor, "$name")

                        target_players.tip = get_var(pl[i], "$ip")
                        target_players.tid = tonumber(get_var(pl[i], "$n"))
                        target_players.tn = get_var(pl[i], "$name")

                        target_players.amount = args[2]
                        target_players.player_count = tonumber(i)
                        if (target_all_players) then
                            money:transfer(target_players)
                        end
                    else
                        can_deposit = false
                        rprint(executor, gsub(gsub(insufficient_funds, "%%balance%%", balance), "%%price%%", args[2]))
                        break
                    end
                end
            end
        end
    end

    local function AddRemove(bool)
        local p = { }
        p.ip = ip
        p.money = args[1]
        p.subtract = bool
        money:update(p)
    end

    local function cmdEnabled(index)
        if (index) then
            return true
        else
            rprint(executor, "Unable to execute. Command disabled.")
        end
    end

    if (command == lower(balance_command)) then
        if (checkAccess(executor, balance_perm_lvl)) then
            if (args[1] == nil) then
                local balance = money:getbalance(ip)
                if (balance ~= nil) then
                    rprint(executor, gsub(balance_msg_format, "%%money%%", balance))
                end
            else
                rprint(executor, "Invalid Syntax. Usage: /" .. command)
            end
        end
        return false
    elseif (command == lower(upgrade_info_command)) then
        if not gameover(executor) then
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
        end
        return false
    elseif (command == lower(add_cmd)) then
        if not gameover(executor) then
            if (checkAccess(executor, add_perm_lvl)) then
                if (args[1] ~= nil) and args[1]:match("%d+") then
                    AddRemove(false)
                    local balance = money:getbalance(ip)
                    local strFormat = gsub(gsub(add_cmd_message, "%%money%%", args[1]), "%%balance%%", balance)
                    rprint(executor, strFormat)
                else
                    rprint(executor, "Invalid Syntax. Usage: /" .. command .. " [amount]")
                end
            end
        end
        return false
    elseif (command == lower(remove_cmd)) then
        if not gameover(executor) then
            if (checkAccess(executor, remove_perm_lvl)) then
                if (args[1] ~= nil) and args[1]:match("%d+") then
                    AddRemove(true)
                    local balance = money:getbalance(ip)
                    local strFormat = gsub(gsub(remove_cmd_message, "%%money%%", args[1]), "%%balance%%", balance)
                    rprint(executor, strFormat)
                else
                    rprint(executor, "Invalid Syntax. Usage: /" .. command .. " [amount]")
                end
            end
        end
        return false
    elseif (command == lower(transfer_command)) then
        if not gameover(executor) then
            if (checkAccess(executor, transfer_perm_lvl)) then
                if (args[1] ~= nil) and (args[2] ~= nil) then
                    is_error = false
                    validate_params()
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            money:transfer(target_players)
                        end
                    end
                else
                    rprint(executor, "Invalid syntax. Usage: /" .. transfer_command .. " [player id] [amount] (optional -s)")
                end
            end
        end
        return false
    elseif (command == lower(weapon_list)) then
        if not gameover(executor) then
            if (checkAccess(executor, weapon_list_perm)) then
                if (args[1] == nil) then
                    rprint(executor, "PURCHASE WEAPONS WITH THESE COMMANDS:")
                    --================================================================--
                    --================================================================--
                    if (endIndex >= max_results) then
                        startIndex = 1
                        endIndex = max_columns
                    end
                    local function formatResults()
                    
                        local temp = { }
                        local t, row, content, done = {}

                        for k, v in pairs(results) do
                            content = stringSplit(v, ",")
                            t[#t + 1] = content
                        end

                        for i = tonumber(startIndex), tonumber(endIndex) do
                            if t[i] then
                                temp[#temp + 1] = t[i][1]
                                row = concat(temp, spacing(spaces))
                            end
                        end

                        if (row ~= nil) then
                            rprint(executor, row, 5 + 8)
                        end

                        for _ in pairs(t) do t[_] = nil end
                        for _ in pairs(temp) do temp[_] = nil end
                        
                        startIndex = (endIndex + 1)
                        endIndex = (endIndex + (max_columns))
                    end

                    while (endIndex < max_results) do
                        formatResults()
                    end
                    --================================================================--
                    --================================================================--
                else
                    rprint(executor, "Invalid Syntax. Usage: /" .. command)
                end
            end
        end
        return false
    end

    -- SAPP COMMANDS
    local c = commands.sapp
    for key, _ in ipairs(c) do
        local cmd = c[key][command]
        if (cmd ~= nil) then
            if not gameover(executor) then
                local param = tonumber(args[1])
                if (param ~= nil) and (cmd[param] ~= nil) then
                    local lvl = cmd[param][4]
                    if (checkAccess(executor, lvl)) then
                        local cost = cmd[param][1]
                        local value = cmd[param][2]
                        local message = cmd[param][3]
                        local enabled = cmd[param][5]
                        local sapp_command = cmd.id
                        if (enabled) then
                            local balance = money:getbalance(ip)
                            if (balance >= tonumber(cost)) then
                                execute_command(sapp_command .. ' ' .. executor .. ' ' .. value)
                                local p = { }
                                p.ip, p.money, p.subtract = ip, cost, true
                                money:update(p)
                                local new_balance = money:getbalance(ip)
                                local strFormat = gsub(gsub(message, "%%price%%", cost), "%%balance%%", new_balance)
                                rprint(executor, strFormat)
                            else
                                rprint(executor, gsub(gsub(insufficient_funds, "%%balance%%", balance), "%%price%%", cost))
                            end
                        else
                            rprint(executor, 'Sorry, that command is disabled.')
                        end
                    end
                else
                    rprint(executor, 'Invalid Syntax. Usage: /' .. command .. ' [id]. (ID = number between 1-' .. #cmd .. ')')
                end
            else
                rprint(executor, "Command failed. Please wait until you respawn.")
            end
            return false
        end
    end

    -- WEAPON COMMANDS
    local tab = commands.weapons
    for key, _ in pairs(tab) do
        local table_data = tab[key]["weapon_table"]
        if (table_data) then
            for k, _ in pairs(table_data) do
                local cmd = table_data[k][1]
                if (command == cmd) then
                    local enabled = table_data[k][6]
                    if cmdEnabled(table_data[k][6]) then
                        if player_alive(executor) then
                            local lvl = table_data[k][5]
                            if checkAccess(executor, lvl) then
                                local cost = table_data[k][2]
                                function delay_add()
                                    if (give_weapon[executor]) then
                                        give_weapon[executor] = false

                                        local p = { }
                                        p.ip, p.money, p.subtract = ip, cost, true
                                        money:update(p)

                                        local new_balance = money:getbalance(ip)
                                        local message = table_data[k][4]
                                        local strFormat = gsub(gsub(message, "%%price%%", cost), "%%balance%%", new_balance)
                                        rprint(executor, strFormat)

                                        local player_object = get_dynamic_player(executor)
                                        local x, y, z = read_vector3d(player_object + 0x5C)
                                        local tag_id = table_data[k][3]
                                        local weap = assign_weapon(spawn_object("weap", tag_id, x, y, z), executor)
                                    end
                                end
                                local balance = money:getbalance(ip)
                                if (balance >= tonumber(cost)) then
                                    check_available_slots[executor] = true
                                    timer(100, "delay_add")
                                else
                                    rprint(executor, gsub(gsub(insufficient_funds, "%%balance%%", balance), "%%price%%", cost))
                                end
                            end
                        else
                            rprint(executor, "Command failed. Please wait until you respawn.")
                        end
                    end
                    return false
                end
            end
        end
    end

    local tab = commands.grenades
    for key, _ in ipairs(tab) do
        local entry = tab[key][command]
        if (entry ~= nil) then
            TYPE_THREE = true
            if not gameover(executor) then
                if cmdEnabled(entry[7]) then
                    if player_alive(executor) then
                        local cost = entry[1]
                        local count = entry[2]
                        local type = entry[3]
                        local tag_id = entry[4]
                        local message = entry[5]
                        local lvl = entry[6]
                        if checkAccess(executor, lvl) then
                            if TagInfo("weap", tag_id) then
                                local balance = money:getbalance(ip)
                                if (balance >= tonumber(cost)) then
                                    execute_command('nades ' .. ' ' .. executor .. ' ' .. count .. ' ' .. type)
                                    local p = { }
                                    p.ip, p.money, p.subtract = ip, cost, true
                                    money:update(p)
                                    local new_balance = money:getbalance(ip)
                                    local strFormat = gsub(gsub(gsub(message, "%%price%%", cost), "%%balance%%", new_balance), "%%count%%", count)
                                    rprint(executor, strFormat)
                                else
                                    rprint(executor, gsub(gsub(insufficient_funds, "%%balance%%", balance), "%%price%%", cost))
                                end
                            else
                                rprint(executor, "That doesn't command work on this map.")
                            end
                        end
                    else
                        rprint(executor, "Command failed. Please wait until you respawn.")
                    end
                end
            end
            return false
        end
    end

    -- SAPP COMMANDS
    local c = commands.custom_god
    for key, _ in ipairs(c) do
        local cmd = c[key][command]
        if (cmd ~= nil) then
            if not gameover(executor) then
                local param = tonumber(args[1])
                if (param ~= nil) and (cmd[param] ~= nil) then
                    local lvl = cmd[param][4]
                    if (checkAccess(executor, lvl)) then
                        local cost = cmd[param][1]
                        local duration = cmd[param][2]
                        local message = cmd[param][3]
                        local enabled = cmd[param][5]
                        local sapp_command = cmd.id
                        if (enabled) then
                            local p = { }
                            p.ip, p.money, p.subtract = ip, cost, true
                            money:update(p)
                            local new_balance = money:getbalance(ip)
                            players[executor].god = 0
                            players[executor].god_duration = tonumber(duration)
                            godmode[executor] = true
                            trigger[executor] = true
                            local strFormat = gsub(gsub(gsub(message, "%%price%%", cost), "%%balance%%", new_balance), "%%seconds%%", duration)
                            rprint(executor, strFormat)
                        else
                            rprint(executor, 'Sorry, that command is disabled.')
                        end
                    end
                else
                    rprint(executor, 'Invalid Syntax. Usage: /' .. command .. ' [id]. (ID = number between 1-' .. #cmd .. ')')
                end
            else
                rprint(executor, "Command failed. Please wait until you respawn.")
            end
            return false
        end
    end
end

function money:update(params)
    local params = params or {}

    local ip = params.ip or nil

    if (ip == nil) then
        return error('Something Went Wrong')
    end

    local points = params.money or nil

    local subtract = params.subtract or nil
    local balance = money:getbalance(ip)

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

function money:transfer(params)
    local params = params or {}

    local eip = params.eip or nil
    local eid = params.eid or nil
    local en = params.en or nil

    local tip = params.tip or nil
    local tid = params.tid or nil
    local tn = params.tn or nil

    local amount = params.amount or nil
    local player_count = params.player_count or nil

    local p1 = { }
    p1.ip = tip
    p1.money = amount
    p1.subtract = false
    money:update(p1)

    local p2 = { }
    p2.ip = eip
    p2.money = amount
    p2.subtract = true
    money:update(p2)

    local eBal = money:getbalance(eip)
    local tBal = money:getbalance(tip)

    local strFormat = gsub(gsub(gsub(transfer_toReceiverMsg, "%%sender_name%%", en), "%%amount%%", amount), "%%receiver_balance%%", tBal)
    rprint(tid, strFormat)

    local strFormat = gsub(gsub(gsub(transfer_toSenderMsg, "%%receiver_name%%", tn), "%%amount%%", amount), "%%sender_balance%%", eBal)
    rprint(eid, strFormat)
end

function money:getbalance(player_ip)

    if (save_money) then
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
        if next(money_table["money"]) then
            for key, _ in pairs(money_table["money"]) do
                if (player_ip == key) then
                    if (money_table["money"][key].balance <= 0) then
                        return 0
                    else
                        return money_table["money"][key].balance
                    end
                end
            end
        else
            return 0
        end
    end
end

function OnPlayerConnect(PlayerIndex)

    local hash = get_var(PlayerIndex, "$hash")
    local ip = get_var(PlayerIndex, "$ip")
    ip_table[hash] = ip_table[hash] or {}
    table.insert(ip_table[hash], { ["ip"] = ip })

    players[PlayerIndex] = players[PlayerIndex] or { }
    players[PlayerIndex].combos = 0
    players[PlayerIndex].combo_timer = 0
    players[PlayerIndex].kills = 0
    players[PlayerIndex].streaks = 0
    players[PlayerIndex].assists = 0

    -- God Mode (custom command)
    players[PlayerIndex].god = 0
    players[PlayerIndex].god_duration = 0
    godmode[PlayerIndex] = false
    trigger[PlayerIndex] = false

    -- /transfer split bool
    divide[PlayerIndex] = false

    check_available_slots[PlayerIndex] = false
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
            file:write(ip .. "|" .. tostring(starting_balance) .. "\n")
            file:close()
        end
    else
        money_table["money"][ip] = { ["balance"] = starting_balance }
    end
end

function OnPlayerDisconnect(PlayerIndex)
    players[PlayerIndex] = nil
    check_available_slots[PlayerIndex] = false
    give_weapon[PlayerIndex] = false
    local ip = getIP(PlayerIndex)
    if not (save_money) then
        money_table["money"][ip] = { ["balance"] = starting_balance }
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

        -- God Mode (custom command)
        players[victim].god = 0
        players[victim].god_duration = 0
        godmode[victim] = false
        trigger[victim] = false

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
            p1.type, p1.total, p1.id, p1.ip, p1.table, p1.subtract = "streaks", players[killer].streaks, killer, kip, stats.streaks, false
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

function OnTick()
    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            if (godmode[i] == true) then
                players[i].god = players[i].god + 0.030
                if (trigger[i]) then
                    trigger[i] = false
                    execute_command('god ' .. i)
                elseif (players[i].god >= players[i].god_duration) then
                    execute_command('ungod ' .. i)
                    godmode[i] = false
                    players[i].god = 0
                    players[i].god_duration = 0
                    rprint(i, "You are no longer in god mode.")
                end
            end
            if (check_available_slots[i]) then
                check_available_slots[i] = false
                local player_object = get_dynamic_player(i)
                if (player_object ~= 0) then
                    local weapon
                    for j = 0, 3 do
                        weapon = get_object_memory(read_dword(player_object + 0x2F8 + j * 4))
                        if (weapon ~= 0) then
                            if (j < 2) then
                                give_weapon[i] = true
                            else
                                execute_command('wdel ' .. i .. ' 0')
                                give_weapon[i] = true
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

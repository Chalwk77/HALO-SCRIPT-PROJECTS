--[[
--=====================================================================================================--
Script Name: Market (with account saving), for SAPP (PC & CE)
Description: Earn money for killing and scoring.
Version: 1.09

Use your money to buy the following:

Type			Command        Price        Catalogue Message
----			-------	       -----        -----------------
Camouflage      m1             $60          Duration: 30 seconds
God Mode        m2             $200         Duration: 30 seconds
Grenades        m3             $30          2x of each
Overshield      m4             $60          Shield Percentage: Full Shield
Health          m5             $100         Health Percentage: Full
Speed Boost     m6             $60          1.3x
Teleport        n/a            $350         Teleport where aiming

All commands (including teleport) have a cooldown.
Default: 60 seconds each.

---------------------------------------------------------------------------------------------------------------
Players are required to create an account (in-game) to use this script.
Account Management Commands:

1. /account create <username> <password>
2. /account login <username> <password>

If you have an existing account, your balance will be restored when you log into your account.

Your login session will expire if your ip address changes or the server is rebooted.
If this happens, you will need to log into your account using the above command.
---------------------------------------------------------------------------------------------------------------

Command to view available items for purchase: /market
Command to view current balance: /money

Two available admin-override commands:
1. /deposit <pid> <amount>
2. /withdraw <pid> <amount>

If a user doesn't log into an account after 30 days, it's considered stale and will be deleted.

----
This script requires that the following JSON library be installed on your server.
Place in the same location as strings.dll & sapp.dll: http://regex.info/blog/lua/json
----

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

local Account = {

    -- Starting balance:
    --
    balance = 0,


    -- File that contains the user accounts:
    --
    file = 'accounts.json',


    -- Account management command syntax:
    --
    account_management_syntax = { "account", "create", "login" },


    -- Command used to view available items for purchase:
    --
    catalogue_command = 'market',


    -- Command used to view current balance:
    --
    get_balance_command = 'money',


    -- Command used to add funds:
    --
    -- Syntax: /deposit <pid> <amount>
    add_funds_command = 'deposit',
    on_add = "Deposited $$amount into $name's account",


    -- Command used to remove funds:
    --
    -- Syntax: /withdraw <pid> <amount>
    remove_funds_command = 'withdraw',
    on_remove = "Withdrew $$amount from $name's account",


    -- Players must be this level (or higher) to add/remove funds from an account:
    required_level = 1,
    --

    -- If a user doesn't log into an account after this many days, it's considered
    -- stale and will be deleted:
    stale_account_period = 30,


    -- Money deposited/withdrawn during these events:
    --
    -- Set the money value to 0 to disable event.
    --
    -- deposit:
    ['pvp'] = { 8, "+$8 (pvp)" },
    ['on_score'] = { 10, "+$10 (score)" },
    ['run_over'] = { 5, "+$5 (run over)" },
    ['guardians'] = { 6, "+$6 (guardians)" },
    ['first_blood'] = { 10, "+$10 (first blood)" },
    ['killed_from_grave'] = { 25, "+$25 (killed from grave)" },
    --
    -- withdraw:
    ['suicide'] = { -4, "-$4 (suicide)" },
    ['squashed'] = { -2, "-$2 (squashed)" },
    ['betrayal'] = { -7, "-$7 (betrayal)" },
    ['fall_damage'] = { -5, "-$5 (fall damage)" }, -- doesn't work on protected maps, but wont break the script
    ['died/unknown'] = { -5, "-$5 (died/unknown)" },
    ['distance_damage'] = { -5, "-$5 (distance damage" }, -- doesn't work on protected maps, but wont break the script


    ----------------------------------------------------
    -- COMMAND SETTINGS --------------------------------
    ----------------------------------------------------
    buy_commands = {

        --
        -- SET THE PRICE TO 0 to disable.
        --

        -- Camouflage:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, duration, cooldown period, catalogue message}
        ['camo'] = { 'm1', 60, 30, 60, "-$60 -> Camo (30 seconds)" },

        --
        -- God Mode:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, duration, cooldown period, catalogue message}
        ['god'] = { 'm2', 200, 30, 60, "-$200 -> God (30 seconds)" },

        --
        -- Grenades:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, total, cooldown period, catalogue message}
        ['nades'] = { 'm3', 30, 2, 60, "-$30 -> Frags/Plasmas (x2 each)" },

        --
        -- Speed Boost:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, speed, cooldown period, catalogue message}
        ['s'] = { 'm4', 60, 1.3, 60, "-$60 -> Speed Boost (1.3x)" },

        --
        -- Overshield:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, state, cooldown period, catalogue message}
        ['sh'] = { 'm5', 100, 1, 60, "-$100 -> Camo (full shield)" },

        --
        -- Health:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, h-points, cooldown period, catalogue message}
        ['hp'] = { 'm6', 100, 1, 60, "-$100 -> HP (full health)" },

        --
        -- Boost:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, n/a, cooldown period, catalogue message}
        ['boost'] = { 'm7', 350, 'n/a', 60, "-$350 -> Teleport where aiming" }


        --
        -- MORE FEATURES ARE COMING IN FUTURE UPDATES
        -- MORE FEATURES ARE COMING IN FUTURE UPDATES
        -- MORE FEATURES ARE COMING IN FUTURE UPDATES
        --
    }
}
-- config ends --

local players = { }
local ffa, falling, distance, first_blood

local json = loadfile('./json.lua')()
local floor = math.floor

local match, gsub = string.match, string.gsub
local gmatch, lower = string.gmatch, string.lower

local open = io.open
local time, date, diff = os.time, os.date, os.difftime

api_version = '1.12.0.0'

function OnScriptLoad()

    local dir = read_string(read_dword(sig_scan('68??????008D54245468') + 0x1))
    Account.dir = dir .. '\\sapp\\' .. Account.file

    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_SCORE'], 'OnScore')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDeath')
    OnStart()

    Account:CheckFile(true)
end

local function GetIP(Ply)
    return get_var(Ply, '$ip')
end

local function WriteToFile(self, t)
    local file = open(self.dir, 'w')
    if (file) then
        file:write(json:encode_pretty(t))
        file:close()
    end
end

local function NewTimes()
    local now = time
    local finish = now() + Account.buy_commands['god'][3]
    return now, finish
end

function Account:new(t)

    setmetatable(t, self)
    self.__index = self

    self.meta_id = 0
    self.god = false
    self.logged_in = false

    for cmd, b in pairs(t.buy_commands) do
        b.execute = function()
            if (cmd == 'god') then
                t.god = true
                t.time, t.finish = NewTimes()
                execute_command(cmd .. ' ' .. t.pid)
            elseif (cmd == 'boost') then
                execute_command(cmd .. ' ' .. t.pid)
            else
                t.time = time
                t.start = true
                t.finish = time() + b[4]
                execute_command(cmd .. ' ' .. t.pid .. ' ' .. b[3])
            end
        end
        b.ungod = function()
            t.god = false
            t.time, t.finish = NewTimes()
            t:respond("God Mode perk has expired.")
            execute_command('ungod ' .. t.pid)
        end
    end
    return t
end

function Account:deposit(t)
    if (t[1] == 0 or not self.logged_in) then
        return
    end
    self.balance = self.balance + t[1]
    self:respond(t[2])
end

function Account:withdraw(t)
    if (t[1] == 0 or not self.logged_in) then
        return
    end

    if (t[1] < 0) then
        self.balance = self.balance + t[1]
    else
        self.balance = self.balance - t[1]
    end

    self.balance = (self.balance < 0 and 0 or self.balance)
    if (not t[2]) then
        return
    end
    self:respond(t[2])
end

function Account:CheckFile(ScriptLoad)
    self.database = (ScriptLoad and nil or self.database)
    if (get_var(0, '$gt') ~= 'n/a' and self.database == nil) then
        local content = ''
        local file = open(self.dir, 'r')
        if (file) then
            content = file:read('*all')
            file:close()
        end
        local data = json:decode(content)
        if (not data) then
            WriteToFile(self, {})
        end
        self.database = data or {}
    end
end

function Account:Cache(name, password, balance)

    local day = date('*t').day
    local month = date('*t').month
    local year = date('*t').year

    self.logged_in = true
    self.database[name] = {
        password = password,
        balance = balance,
        last_login = { day = day, month = month, year = year }
    }
end

function Account:respond(msg)
    rprint(self.pid, msg)
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function OnJoin(Ply)
    local ip = GetIP(Ply)
    local now, finish = NewTimes()
    local name = get_var(Ply, '$name')
    local team = get_var(Ply, '$team')
    local t = { pid = Ply, time = now, team = team, name = name, finish = finish }
    if (players[ip]) then
        for k, v in pairs(t) do
            players[ip][k] = v
        end
    else
        players[ip] = Account:new(t)
    end
end

function OnScore(Ply)
    local ip = GetIP(Ply)
    local t = players[ip]
    t:deposit(t['on_score'])
end

local function Plural(n)
    return (n > 1 and "s" or "")
end

function OnTick()

    -- Delete stale accounts:
    for username, v in pairs(Account.database) do
        if (username) then
            local day = v.last_login.day
            local month = v.last_login.month
            local year = v.last_login.year
            local reference = time { day = day, month = month, year = year }
            local days_from = diff(time(), reference) / (24 * 60 * 60)
            local whole_days = floor(days_from)
            if (whole_days >= Account.stale_account_period) then
                cprint("Deleting stale account for user " .. username, 12)
                Account.database[username] = nil
            end
        end
    end

    for _, t in pairs(players) do
        if (t.logged_in) then
            for cmd, b in pairs(t.buy_commands) do
                if (cmd == 'god' and t.god and t.time() >= t.finish) then
                    b:ungod()
                end
                if (b.cooldown_start and b.cooldown_time() >= b.cooldown_finish) then
                    b.cooldown_start = false
                    t:respond("Perk /", cmd .. " cooldown has expired.")
                end
            end
        end
    end
end

function OnSwitch(Ply)
    local ip = GetIP(Ply)
    players[ip].team = get_var(Ply, '$team')
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        Account:CheckFile(false)

        players = {}
        first_blood = true

        ffa = (get_var(0, '$ffa') == '1')

        -- these will not work on protected maps:
        falling = GetTag('jpt!', 'globals\\falling')
        distance = GetTag('jpt!', 'globals\\distance')
        --

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnEnd()
    WriteToFile(Account, Account.database)
end

local function HasPermission(t)
    local l = tonumber(get_var(t.pid, '$lvl'))
    return (l >= t.required_level or t:respond("Insufficient Permission") and false)
end

function OnCommand(Ply, CMD, _, _)

    if (Ply > 0) then

        local args = { }
        for arg in gmatch(CMD, '([^%s]+)') do
            args[#args + 1] = arg
        end

        if (#args > 0) then

            local ip = GetIP(Ply)
            local t = players[ip]

            args[1], args[2] = lower(args[1]), lower(args[2] or '')

            local management = t.account_management_syntax
            if (args[1] == management[1]) then

                local name = args[3]
                local password = args[4]

                if (args[2] == management[2] and args[3]) then
                    if (#args > 4) then
                        t:respond("Too many arguments!")
                        t:respond("Make sure username & password do not contain spaces.")
                    elseif (not t.logged_in) then
                        if (t.database[name]) then
                            t:respond("That account username already exists.")
                        else
                            t:Cache(name, password, t.balance)
                            t:respond("Account successfully created.")
                        end
                    else
                        t:respond("You already have an account.")
                    end
                    return false

                elseif (args[2] == management[3] and args[3]) then
                    if (#args > 4) then
                        t:respond("Too many arguments!")
                        t:respond("Make sure username & password do not contain spaces.")
                    elseif (t.database[name]) then
                        if (password == t.database[name].password) then
                            t:Cache(name, password, t.balance)
                            t:respond("Successfully logged in. Balance: $" .. t.balance)
                        else
                            t:respond("Invalid password. Please try again.")
                        end
                    else
                        t:respond("Account username does not exist")
                    end
                    return false
                end
            end

            if (args[1] == t.get_balance_command) then
                if (t.logged_in) then
                    t:respond("You have $" .. t.balance)
                else
                    t:respond("You are not logged in.")
                end
                return false
            elseif (args[1] == t.add_funds_command or args[1] == t.remove_funds_command) then
                if HasPermission(t) then
                    local p = players[GetIP(args[2])]
                    if not player_present(args[2]) then
                        t:respond("Player #" .. args[2] .. " is not online.")
                    elseif (p.pid == t.pid and not p.logged_in) then
                        t:respond("You are not logged in.")
                    elseif (p.pid ~= t.pid and not p.logged_in) then
                        t:respond(p.name .. " is not logged in.")
                    elseif (not args[2] or not match(args[2], '%d+')) then
                        t:respond("Invalid Command syntax. Usage: /" .. args[1] .. " <pid> <amount>")
                    elseif (not args[3] or not match(args[3], '%d+')) then
                        t:respond("Invalid amount")
                    elseif (args[1] == t.add_funds_command) then
                        p.balance = p.balance + args[3]
                        t:respond(gsub(gsub(t.on_add, '$amount', args[3]), '$name', p.name))
                    elseif (args[1] == t.remove_funds_command) then
                        p.balance = p.balance - args[3]
                        t:respond(gsub(gsub(t.on_remove, '$amount', args[3]), '$name', p.name))
                    end
                end
                return false
            end

            local response = true
            for _, v in pairs(t.buy_commands) do
                if (args[1] == t.catalogue_command) then
                    t:respond('/' .. v[1] .. ' ' .. v[#v])
                    response = false
                elseif (args[1] == v[1] and v[1] ~= 'n/a') then
                    if (not t.logged_in) then
                        t:respond("You are not logged in.")
                    elseif (v[2] == 0) then
                        t:respond("Command disabled")
                    elseif (v.start) then
                        local time_remaining = v.finish - v.time()
                        t:respond("Command on cooldown")
                        t:respond("Please wait " .. time_remaining .. " second" .. Plural(time_remaining))
                    elseif (t.balance >= v[2]) then
                        t:respond(v[#v])
                        t:withdraw({ v[2] })
                        v:execute()
                    else
                        t:respond("You do not have enough money!")
                        t:respond("You need $" .. v[2] - t.balance)
                    end
                    return false
                end
            end

            return response
        end
    end
end

function OnDeath(Victim, Killer, MetaID)

    local victim = tonumber(Victim)
    local killer = tonumber(Killer)

    local v = players[GetIP(victim)]
    local k = players[GetIP(killer)]

    if (v) then

        -- event_damage_application:
        if (MetaID) then
            v.meta_id = MetaID
            goto done
        end

        v.god = false
        v.time, v.finish = NewTimes()

        -- event_die:
        local squashed = (killer == 0)
        local guardians = (killer == nil)
        local suicide = (killer == victim)
        local pvp = (killer > 0 and killer ~= victim)
        local fell = (v.meta_id == falling or distance)
        local betrayal = ((k and not ffa) and (v.team == k.team and killer ~= victim))

        if (pvp and not betrayal) then

            if (first_blood) then
                first_blood = false
                k:deposit(k['first_blood'])
            end

            if (not player_alive(killer)) then
                k:deposit(k['killed_from_grave'])
                goto done
            end

            local DyN = get_dynamic_player(killer)
            if (DyN ~= 0) then
                local vehicle = read_dword(DyN + 0x11C)
                if (vehicle ~= 0xFFFFFFFF) then
                    k:deposit(k['run_over'])
                    goto done
                end
            end
            k:deposit(k['pvp'])

        elseif (guardians) then
            k:deposit(k['guardians'])
            v:deposit(v['guardians'])
        elseif (suicide) then
            v:withdraw(v['suicide'])
        elseif (betrayal) then
            k:withdraw(k['betrayal'])
        elseif (squashed) then
            v:withdraw(v['squashed'])
        elseif (fell ~= nil) then
            v:withdraw(v['fall_damage'])
        else
            v:withdraw(v['died/unknown'])
        end

        :: done ::
    end
end

function OnScriptUnload()
    -- N/A
end
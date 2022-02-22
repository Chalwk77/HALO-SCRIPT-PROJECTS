--[[
--=====================================================================================================--
Script Name: Market, for SAPP (PC & CE)
Description: Earn money for killing!

             Use your money to buy one of the following:
             1. Camouflage ($60, 30 seconds)
             2. God Mode ($200, 30 seconds)
             3. Grenades (frags/plasmas) - ($30 each, 2x)
             4. Overshield ($60, full shield)
             5. Health ($100, full health)
             6. Speed Boost ($60, 1.3x)

             Easily edit custom command, price, state and catalogue message.

             Command to view available items for purchase: /market
             Command to view current balance: /money

             Accounts are linked to your IP:PORT.
             If you have an existing account, your balance will be restored upon joining.

             Balances are reset when the server is restarted.

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


    -- Command used to view available items for purchase:
    --
    catalogue_command = 'buy',


    -- Command used to view current balance:
    --
    get_balance_command = "money",


    -- Command used to add funds:
    --
    -- Syntax: /deposit <pid> <amount>
    add_funds_command = "deposit",
    on_add = "Deposited $$amount into $name's account",

    -- Command used to remove funds:
    --
    -- Syntax: /withdraw <pid> <amount>
    remove_funds_command = "withdraw",
    on_remove = "Withdrew $$amount from $name's account",

    -- Players must be this level (or higher) to add/remove funds from an account:
    required_level = 1,
    --


    -- Money deposited/withdrawn during these events:
    --
    -- deposit:
    ['pvp'] = { 8, "+$8 (pvp)" },
    ['run_over'] = { 5, "+$5 (run over)" },
    ['guardians'] = { 6, "+$5 (guardians)" },
    ['first_blood'] = { 10, "+$5 (first blood)" },
    ['killed_from_grave'] = { 25, "+$25 (killed from grave)" },
    --
    -- withdraw:
    ['suicide'] = { -4, "-$4 (suicide)" },
    ['squashed'] = { -2, "-$2 (squashed)" },
    ['betrayal'] = { -7, "-$7 (betrayal)" },
    ['fall_damage'] = { -5, "-$5 (fall damage)" },
    ['died/unknown'] = { -5, "-$5 (died/unknown)" },
    ['distance_damage'] = { -5, "-$5 (distance damage" },


    ----------------------------------------------------
    -- COMMAND SETTINGS --------------------------------
    ----------------------------------------------------
    buy_commands = {

        -- Camouflage:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, duration, catalogue message}
        ['camo'] = { 'm1', 60, 30, "-$60 -> Camo (30 seconds)" },

        --
        -- God Mode:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, duration, catalogue message}
        ['god'] = { "m2", 200, 30, "-$200 -> God (30 seconds)" },

        --
        -- Frags:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, total, catalogue message}
        ['nades'] = { 'm3', 30, 2, "-$30 -> Frags (x2)" },

        --
        -- Plasmas:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, total, catalogue message}
        ['plasmas'] = { 'm4', 30, 2, "-$30 -> Plasmas (x2)" },

        --
        -- Speed Boost:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, speed, catalogue message}
        ['s'] = { 'm5', 60, 1.3, "-$60 -> Speed Boost (1.3x)" },

        --
        -- Overshield:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, state, catalogue message}
        ['sh'] = { 'm6', 100, 1, "-$100 -> Camo (full shield)" },

        --
        -- Health:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, h-points, catalogue message}
        ['hp'] = { 'm7', 100, 1, "-$100 -> HP (full health)" },
    }
}

-- config ends --

local players = { }
local time = os.time
local ffa, falling, distance, first_blood
local interval = Account.buy_commands['god'][3]
local gmatch, lower, match, gsub = string.gmatch, string.lower, string.match, string.gsub

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDeath')
    OnStart()
end

function Account:new(t)
    t = t or {}
    setmetatable(t, self)
    self.meta_id = 0
    self.god = false
    self.god_timer = function(self)
        return (self.time() >= self.finish)
    end
    self.__index = self
    return t
end

function Account:deposit(t)
    self.balance = self.balance + t[1]
    self:respond(t[2])
end

function Account:withdraw(t, respond)
    self.balance = self.balance - t[1]
    self.balance = (self.balance < 0 and 0 or self.balance)
    if (not respond) then
        self:respond(t[2])
    end
end

function Account:respond(msg)
    rprint(self.pid, msg)
end

local function GetIP(Ply)
    return get_var(Ply, '$ip')
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

local function NewTimes()
    local now = time
    local finish = now() + interval
    return now, finish
end

function OnJoin(Ply)
    local ip = GetIP(Ply)
    local now, finish = NewTimes()
    players[ip] = Account:new({
        pid = Ply,
        time = now,
        finish = finish,
        team = get_var(Ply, '$team'),
        name = get_var(Ply, '$name')
    })
end

function OnTick()
    for _, v in pairs(players) do
        if (v.god and v.god_timer(v)) then
            v.god = false
            v.time, v.finish = NewTimes()
            v:respond("God Mode has expired")
            execute_command("ungod " .. v.pid)
        end
    end
end

function OnSwitch(Ply)
    players[GetIP(Ply)].team = get_var(Ply, '$team')
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        players = {}
        first_blood = true
        ffa = (get_var(0, '$ffa') == '1')

        falling = GetTag('jpt!', 'globals\\falling')
        distance = GetTag('jpt!', 'globals\\distance')

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

local function HasPermission(t)
    local l = tonumber(get_var(t.pid, "$lvl"))
    return (l >= t.required_level or t:respond("Insufficient Permission") and false)
end

function OnCommand(Ply, CMD, _, _)

    if (Ply > 0) then

        local args = { }
        for arg in gmatch(CMD, '([^%s]+)') do
            args[#args + 1] = lower(arg)
        end

        if (#args > 0) then

            local response = true
            local t = players[GetIP(Ply)]

            if (args[1] == t.get_balance_command) then
                t:respond("You have $" .. t.balance)
                return false
            elseif (args[1] == t.add_funds_command) then
                if HasPermission(t) then
                    if (not args[2] or not match(args[2], "%d+")) then
                        t:respond("Invalid Command syntax. Usage: /" .. args[1] .. " <pid> <amount>")
                        return false
                    elseif not player_present(args[2]) then
                        t:respond("Player #" .. args[2] .. " is not online.")
                        return false
                    elseif (not args[3] or not match(args[3], "%d+")) then
                        t:respond("Invalid amount")
                        return false
                    else
                        local p = players[GetIP(args[2])]
                        p:deposit({
                            args[3],
                            gsub(gsub(p.on_add, "$amount", args[3]), "$name", p.name)
                        })
                    end
                end
                return false
            elseif (args[1] == t.remove_funds_command) then
                if HasPermission(t) then
                    if (not args[2] or not match(args[2], "%d+")) then
                        t:respond("Invalid Command syntax. Usage: /" .. args[1] .. " <pid> <amount>")
                        return false
                    elseif not player_present(args[2]) then
                        t:respond("Player #" .. args[2] .. " is not online.")
                        return false
                    elseif (not args[3] or not match(args[3], "%d+")) then
                        t:respond("Invalid amount")
                        return false
                    else
                        local p = players[GetIP(args[2])]
                        p:withdraw({
                            args[3],
                            gsub(gsub(p.on_remove, "$amount", args[3]), "$name", p.name)
                        })
                    end
                end
                return false
            end

            for cmd, v in pairs(t.buy_commands) do
                if (args[1] == t.catalogue_command) then
                    t:respond("/" .. v[1] .. " " .. v[#v])
                    response = false
                elseif (args[1] == v[1]) then
                    if (t.balance >= v[2]) then
                        t:respond(v[#v])
                        t:withdraw({ v[2] }, true)
                        if (cmd == "god") then
                            t.god = true
                            execute_command(cmd .. " " .. Ply)
                            return false
                        end
                        execute_command(cmd .. " " .. Ply .. " " .. v[3])
                    else
                        t:respond("You do not have enough money!")
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
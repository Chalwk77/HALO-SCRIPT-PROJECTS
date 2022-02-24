--[[
--=====================================================================================================--
Script Name: Market (without account saving), for SAPP (PC & CE)
Description: Earn money for killing and scoring.
Version: 1.0

* In this version, player stats are reset at the beginning of each game.

Use your money to buy the following:

Type			Command        Price        Catalogue Message
----			-------	       -----        -----------------
Camouflage      m1             $60          Duration: 30 seconds
God Mode        m2             $200         Duration: 30 seconds
Grenades        m3             $30          2x of each
Overshield      m4             $60          Shield Percentage: Full Shield
Health          m5             $100         Health Percentage: Full
Speed Boost     m6             $60          1.3x
Teleport        n/a            $350         Teleport with flashlight key.

All commands (including teleport) have a cooldown.
Default: 60 seconds each.

Command to view available items for purchase: /market
Command to view current balance: /money

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
        -- ["SAPP COMMAND EXECUTED"] = {"n/a", price, n/a, cooldown period, catalogue message}
        ['boost'] = { 'n/a', 350, 'n/a', 60, "-$350 -> Teleport with flashlight key" }


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

local time = os.time
local match, gsub = string.match, string.gsub
local gmatch, lower = string.gmatch, string.lower

api_version = '1.12.0.0'

function OnScriptLoad()

    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_SCORE'], 'OnScore')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDeath')
    OnStart()
end

function Account:new(t)

    setmetatable(t, self)
    self.__index = self

    self.meta_id = 0
    self.god = false
    self.flashlight = 0
    return t
end

function Account:deposit(t)
    if (t[1] == 0) then
        return
    end
    self.balance = self.balance + t[1]
    self:respond(t[2])
end

function Account:withdraw(t)
    if (t[1] == 0) then
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

function Account:respond(msg)
    rprint(self.pid, msg)
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

local function NewTimes()
    local now = time
    local finish = now() + Account.buy_commands['god'][3]
    return now, finish
end

function OnJoin(Ply)
    local now, finish = NewTimes()
    local name = get_var(Ply, '$name')
    local team = get_var(Ply, '$team')
    players[Ply] = Account:new({ pid = Ply, time = now, team = team, name = name, finish = finish })
end

function OnQuit(Ply)
    players[Ply] = nil
end

function OnScore(Ply)
    local t = players[Ply]
    t:deposit(t['on_score'])
end

local function Plural(n)
    return (n > 1 and "s" or "")
end

function OnTick()
    for i, t in pairs(players) do
        if player_alive(i) then
            local DyN = get_dynamic_player(i)
            local flashlight = read_bit(DyN + 0x208, 4)
            if (flashlight ~= t.flashlight and flashlight == 1) then
                local cmd = t.buy_commands['boost']
                if (cmd[2] == 0) then
                    t:respond("Boost currently disabled.")
                    goto next
                elseif (cmd.start) then
                    local time_remaining = cmd.finish - cmd.time()
                    t:respond("Command on cooldown")
                    t:respond("Please wait " .. time_remaining .. " second" .. Plural(time_remaining))
                    goto next
                elseif (t.balance >= cmd[2]) then
                    cmd.time = time
                    cmd.start = true
                    cmd.finish = time() + cmd[4]
                    t:respond(cmd[#cmd])
                    t:withdraw({ cmd[2] })
                    execute_command('boost ' .. i)
                else
                    t:respond("You do not have enough money!")
                    t:respond("You need $" .. cmd[2] - t.balance)
                end
            end
            :: next ::
            t.flashlight = flashlight
            if (t.god and t.time() >= t.finish) then
                t.god = false
                t.time, t.finish = NewTimes()
                t:respond("God Mode perk has expired.")
                execute_command('ungod ' .. t.pid)
            end
        end
        for cmd, b in pairs(t.buy_commands) do
            if (b.start and b.time() >= b.finish) then
                b.start = false
                t:respond("Perk /", cmd .. " cooldown has expired.")
            end
        end
    end
end

function OnSwitch(Ply)
    players[Ply].team = get_var(Ply, '$team')
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

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

local function HasPermission(t)
    local l = tonumber(get_var(t.pid, '$lvl'))
    return (l >= t.required_level or t:respond("Insufficient Permission") and false)
end

function OnCommand(Ply, CMD, _, _)

    if (Ply > 0) then

        local args = { }
        for arg in gmatch(CMD, '([^%s]+)') do
            args[#args + 1] = lower(arg)
        end

        if (#args > 0) then

            local t = players[Ply]

            if (args[1] == t.get_balance_command) then
                t:respond("You have $" .. t.balance)
                return false
            elseif (args[1] == t.add_funds_command or args[1] == t.remove_funds_command) then
                if HasPermission(t) then
                    local p = players[tonumber(args[2])]
                    if not player_present(args[2]) then
                        t:respond("Player #" .. args[2] .. " is not online.")
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
            for cmd, v in pairs(t.buy_commands) do
                if (args[1] == t.catalogue_command) then
                    t:respond('/' .. v[1] .. ' ' .. v[#v])
                    response = false
                elseif (args[1] == v[1] and v[1] ~= 'n/a') then
                    if (v[2] == 0) then
                        t:respond("Command disabled")
                    elseif (v.start) then
                        local time_remaining = v.finish - v.time()
                        t:respond("Command on cooldown")
                        t:respond("Please wait " .. time_remaining .. " second" .. Plural(time_remaining))
                    elseif (t.balance >= v[2]) then
                        v.time = time
                        v.start = true
                        v.finish = time() + v[4]
                        t:respond(v[#v])
                        t:withdraw({ v[2] })
                        if (cmd == 'god') then
                            t.god = true
                            t.time, t.finish = NewTimes()
                            execute_command(cmd .. ' ' .. Ply)
                            return false
                        end
                        execute_command(cmd .. ' ' .. Ply .. ' ' .. v[3])
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

    local v = players[victim]
    local k = players[killer]

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
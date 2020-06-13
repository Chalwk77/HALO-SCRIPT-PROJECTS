--[[
--=====================================================================================================--
Script Name: Economy System, for SAPP (PC & CE)
Description: N/A

NOTE: This mod requires that you download and install a file called "json.lua".
Place "json.lua" in the server's root directory - not inside the Lua Folder.
It's crucial that the file name is exactly "json.lua".

Download Link:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/Miscellaneous/json.lua
--------------------------------------------------------------------------------------

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local Account = {

    dir = "accounts.txt",
    currency_symbol = "$",

    -- Starting Balance (accepts decimals)
    starting_balance = 200,

    commands = {

        sapp = {
            -- todo: finish this shit
        },

        bal = {
            cmd = "bal",
            permission_level = 1,
            responses = {
                "Your balance is %sym%%amount%",
                "%name%'s balance is %sym%%amount%"
            }
        },
        add = {
            cmd = "add",
            permission_level = 1,
            responses = {
                "[Cheat] Received %sym%%amount% | New Balance: %sym%%total%",
                "[Cheat] %name% received %sym%%amount% | New Balance: %sym%%total%",
            }
        },
        remove = {
            cmd = "remove",
            permission_level = 1,
            responses = {
                "[Cheat] Deducting %sym%%amount% | New Balance: %total%",
                "[Cheat] Deducted %sym%%amount% from %name%'s account  | New Balance: %total%",
            }
        }
    },

    stats = {

        Non_Consecutive_Kills = {
            -- Non-consecutive, threshold-based kills:
            enabled = true,
            msg = "Total Kills: %kills% (+%sym%%amount% dollars added!)",
            -- { kills required | amount awarded }
            kills = {
                { 5, 10 }, { 10, 10 }, { 15, 10 },
                { 20, 10 }, { 25, 15 }, { 30, 15 },
                { 35, 15 }, { 40, 15 }, { 45, 20 },
                { 50, 20 }, { 55, 20 }, { 60, 20 },
                { 65, 35 }, { 70, 35 }, { 75, 35 },
                { 80, 35 }, { 85, 50 }, { 90, 50 },
                { 95, 50 }, { 100, 100 },
            }
        },

        Combo = {
            enabled = true,
            -- required kills | money added
            msg = "Combo Kills: %combo%x (+%sym%%amount% dollars added)",
            duration = 100, -- in seconds (default 7)
            kills = {
                { 2, 15 },
                { 4, 15 },
                { 5, 10 },
                { 6, 10 },
                { 7, 15 },
                { 8, 15 },
                { 9, 20 },
                { 10, 25 },
                { 11, 25 },
                { 12, 25 },
                { 13, 30 },
                { 14, 30 },
                { 15, 150 },
            }
        },

        Streaks = {
            enabled = true,
            msg = "Kill Streak: %streaks% (+%sym%%amount% dollars added)",
            -- required streaks | reward
            kills = {
                { 5, 15 },
                { 10, 20 },
                { 15, 25 },
                { 20, 30 },
                { 25, 35 },
                { 30, 40 },
                { 35, 45 },
                { 40, 50 },
                { 45, 55 },
                { 50, 60 },
                { 55, 65 },
                { 60, 70 },
                { 65, 75 },
                { 70, 80 },
                { 75, 85 },
                { 80, 95 },
                { 85, 100 },
                { 90, 110 },
                { 95, 120 },
                { 100, 130 }
            }
        },

        Penalties = {
            -- amount deducted | message | enabled/disabled
            [1] = { 2, "DEATH: (-%sym%%amount% dollars taken)", true },
            [2] = { 5, "SUICIDE: (-%sym%%amount% dollars taken)", true },
            [3] = { 30, "BETRAY: (-%sym%%amount% dollars taken)", true }
        },

        -- Every kill will reward X amount of money
        PvP = {
            enabled = true, -- Set to 'false' to disable
            award = 10,
            msg = "PvP: x%kills% kills (+%sym%%amount% dollars added)"
        },

        Assists = {
            enabled = true,
            reward = 30,
            msg = "ASSIST: (+%sym%%amount% dollars added)"
        },

        -- reward points | message | enabled/disabled
        Score = {
            enabled = true,
            reward = 30,
            msg = "SCORE: (+%sym%%amount% dollars added)"
        }
    },

    --
    -- Advanced users only:
    --
    --

    -- Client data will be saved as a json array and
    -- the array index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for IP-only indexing.
    ClientIndexType = 2,

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    serverPrefix = "**SAPP**"
}

local floor = math.floor
local gmatch, len = string.gmatch, string.len
local sub, gsub, format = string.sub, string.gsub, string.format
local json = (loadfile "json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb['EVENT_SCORE'], "OnPlayerScore")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb['EVENT_ASSIST'], "OnPlayerAssist")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    if (get_var(0, "$gt") ~= "n/a") then
        Account:CheckFile()
        for Ply = 1, 16 do
            if player_present(Ply) then
                Account:AddNewAccount(Ply)
            end
        end
    end
end

function OnScriptUnload()
    Account:UpdateALL()
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        Account:CheckFile()
    end
end

function OnGameEnd()
    Account:UpdateALL()
end

function Account:OnServerCommand(Ply, Command, _, _)
    local CMD = CMDSplit(Command)
    if (#CMD == 0) then
        return
    else
        CMD[1] = CMD[1]:lower()
        if (CMD[1] == self.commands.bal.cmd) then
            if checkAccess(Ply, self.commands.bal.permission_level) then
                local pl = GetPlayers(Ply, CMD)
                if (pl) then
                    for i = 1, #pl do
                        local TargetID = pl[i]
                        if (TargetID == Ply) then
                            local m = self.commands.bal.responses[1]
                            local bal = self:FormatMoney(self.players[Ply].balance)
                            local msg = gsub(gsub(m, "%%sym%%", self.currency_symbol), "%%amount%%", bal)
                            Respond(Ply, msg, "rprint", 2 + 8)
                        else
                            local m = self.commands.bal.responses[2]
                            local bal = self:FormatMoney(self.players[TargetID].balance)
                            local name = get_var(TargetID, "$name")
                            local msg = gsub(gsub(gsub(m, "%%sym%%", self.currency_symbol), "%%amount%%", bal), "%%name%%", name)
                            Respond(Ply, msg, "rprint", 2 + 8)
                        end
                    end
                end
            end
            return false
        elseif (CMD[1] == self.commands.add.cmd) then
            if checkAccess(Ply, self.commands.add.permission_level) then
                if (CMD[2] ~= nil and CMD[3] ~= nil) then
                    local pl = GetPlayers(Ply, CMD)
                    if (pl) then
                        for i = 1, #pl do
                            local TargetID, Amount = pl[i], CMD[3]
                            if Amount:match("^%d+$") or Amount:match("[%.2f]") then
                                local Msg = ""
                                if (TargetID == Ply) then
                                    Msg = self.commands.add.responses[1]
                                else
                                    Msg = self.commands.add.responses[2]
                                end
                                local patterns = {
                                    { "%%sym%%", self.currency_symbol },
                                    { "%%amount%%", self:FormatMoney(Amount) },
                                    { "%%total%%", self:FormatMoney(self.players[TargetID].balance + Amount) },
                                    { "%%name%%", get_var(TargetID, "$name") },
                                }
                                for i = 1, #patterns do
                                    Msg = (gsub(Msg, patterns[i][1], patterns[i][2]))
                                end
                                Respond(Ply, Msg, "rprint", 2 + 8)
                                self:Deposit(TargetID, Amount)
                            end
                        end
                    end
                else
                    Respond(Executor, "Invalid Syntax. Usage: /" .. CMD[1] .. " [player id]|me|*/all [amount]", "rprint", 12)
                end
            end
            return false
        elseif (CMD[1] == self.commands.remove.cmd) then
            if checkAccess(Ply, self.commands.remove.permission_level) then
                if (CMD[2] ~= nil and CMD[3] ~= nil) then
                    local pl = GetPlayers(Ply, CMD)
                    if (pl) then
                        for i = 1, #pl do
                            local TargetID, Amount = pl[i], CMD[3]
                            if Amount:match("^%d+$") or Amount:match("[%.2f]") then
                                local Msg = ""
                                if (TargetID == Ply) then
                                    Msg = self.commands.remove.responses[1]
                                else
                                    Msg = self.commands.remove.responses[2]
                                end
                                local patterns = {
                                    { "%%sym%%", self.currency_symbol },
                                    { "%%amount%%", self:FormatMoney(Amount) },
                                    { "%%total%%", self:FormatMoney(self.players[TargetID].balance - Amount) },
                                    { "%%name%%", get_var(TargetID, "$name") },
                                }
                                for i = 1, #patterns do
                                    Msg = (gsub(Msg, patterns[i][1], patterns[i][2]))
                                end
                                Respond(Ply, Msg, "rprint", 2 + 8)
                                self:Withdraws(TargetID, Amount)
                            end
                        end
                    end
                else
                    Respond(Executor, "Invalid Syntax. Usage: /" .. CMD[1] .. " [player id]|me|*/all [amount]", "rprint", 12)
                end
            end
            return false
        end
    end
end

function Account:OnTick()
    for ply, v in pairs(self.players) do
        if (ply) and player_present(ply) and player_alive(ply) then
            if (self.stats.Combo.enabled) then
                if (v.combos and v.combos.init) then
                    v.combos.timer = v.combos.timer + 1 / 30
                    if (v.combos.timer >= self.stats.Combo.duration) then
                        v.combos.timer, v.combos.total = 0, 0
                        v.combos.init = false
                    end
                end
            end
        end
    end
end

function Account:OnPlayerDeath(VictimIndex, KillerIndex)

    local victim, killer = tonumber(VictimIndex), tonumber(KillerIndex)
    if (killer == 0) then
        return
    elseif (killer > 0) then

        local stats = self.stats
        local kTeam = get_var(killer, "$team")
        local vTeam = get_var(victim, "$team")

        if (killer ~= victim) then
            if (kTeam ~= vTeam) then
                local NCK = stats.Non_Consecutive_Kills
                if (NCK.enabled) then
                    local kills = tonumber(get_var(killer, "$kills"))
                    for _, v in pairs(NCK.kills) do
                        if (kills == v[1]) then
                            self:Deposit(killer, v[2], NCK.msg)
                            if (stats.Penalties[1][3]) then
                                self:Withdraw(victim, stats.Penalties[1][1], stats.Penalties[1][2])
                            end
                        end
                    end
                end
                -- PvP:
                if (stats.PvP.enabled) then
                    self:Deposit(killer, stats.PvP.award, stats.PvP.msg)
                end
                -- Streaks:
                if (stats.Streaks.enabled) then
                    self.players[killer].streaks = self.players[killer].streaks + 1
                    for _, v in pairs(stats.Streaks.kills) do
                        if (self.players[killer].streaks == v[1]) then
                            self.players[killer].streaks = 0
                            self:Deposit(killer, v[2], stats.Streaks.msg)
                        end
                    end
                end
                -- Combo Scoring:
                if (stats.Combo.enabled) then
                    self.players[killer].combos.total = self.players[killer].combos.total + 1
                    if not (self.players[killer].combos.init) then
                        self.players[killer].combos.init = true
                    elseif (self.players[killer].combos.timer < stats.Combo.duration) then
                        for _, v in pairs(stats.Combo.kills) do
                            if (self.players[killer].combos.total == v[1]) then
                                self:Deposit(killer, v[2], stats.Combo.msg)
                            end
                        end
                    end
                end
            elseif (stats.Penalties[3][3]) and isTeamPlay() then
                -- BETRAY:
                self:Withdraw(killer, stats.Penalties[3][1], stats.Penalties[3][2])
            end
        elseif (stats.Penalties[2][3]) then
            -- SUICIDE:
            self:Withdraw(victim, stats.Penalties[2][1], stats.Penalties[2][2])
        end
    end
end

function OnPlayerAssist(Ply)
    local assist = Account.stats.assist
    if (assist.enabled) then
        Account:Deposit(Ply, assist.reward, assist.msg)
    end
end

function OnPlayerScore(Ply)
    local score = Account.stats.Score
    if (score.enabled) then
        Account:Deposit(Ply, score.reward, score.msg)
    end
end

function OnPlayerSpawn(Ply)
    if (Account.players[Ply]) then
        Account.players[Ply].streaks = 0
        Account.players[Ply].combos.total = 0
        Account.players[Ply].combos.timer = 0
        Account.players[Ply].combos.init = false
    end
end

function OnPlayerConnect(Ply)
    Account:AddNewAccount(Ply)
end

function OnPlayerDisconnect(Ply)
    Account:UpdateJSON(Account:GetIP(Ply), Account.players[Ply])
    Account.players[Ply] = nil
end

function Account:Deposit(Ply, Amount, Msg)
    self.players[Ply].balance = self.players[Ply].balance + Amount
    if (Msg) then
        rprint(Ply, self:FormatStr(Ply, Msg, Amount))
    end
end

function Account:Withdraw(Ply, Amount, Msg)
    self.players[Ply].balance = self.players[Ply].balance - Amount
    if (self.players[Ply].balance <= 0) then
        self.players[Ply].balance = 0
    end
    if (Msg) then
        rprint(Ply, self:FormatStr(Ply, Msg, Amount))
    end
end

function Account:UpdateJSON(IP, Table)
    Table.combos, Table.streaks = nil, nil
    local accounts = self:GetAccountData()
    if (accounts) then
        local file = assert(io.open(self.dir, "w"))
        if (file) then
            accounts[IP] = Table
            file:write(json:encode_pretty(accounts))
            io.close(file)
        end
    end
end

function Account:AddNewAccount(Ply)
    local content = ""
    local File = io.open(self.dir, "r")
    if (File) then
        content = File:read("*all")
        io.close(File)
    end
    if (len(content) > 0) then
        local file = assert(io.open(self.dir, "w"))
        if (file) then
            local account = json:decode(content)
            local IP = self:GetIP(Ply)
            if (account[IP] == nil) then
                account[IP] = { balance = self.starting_balance }
            end
            file:write(json:encode_pretty(account))
            io.close(file)
            self.players[Ply] = { }
            self.players[Ply] = account[IP]
            self.players[Ply].streaks = 0
            self.players[Ply].combos = { total = 0, init = false }
            rprint(Ply, "Your balance is " .. self.currency_symbol .. " " .. self:FormatMoney(account[IP].balance))
        end
    end
end

function Account:UpdateALL()
    if (get_var(0, "$gt") ~= "n/a") then
        for Ply = 1, 16 do
            if player_present(Ply) then
                local IP = self:GetIP(Ply)
                self:UpdateJSON(IP, self.players[Ply])
            end
        end
    end
end

function Account:GetAccountData()
    local file = io.open(self.dir, "r")
    local table
    if (file) then
        local data = file:read("*all")
        if (len(data) > 0) then
            table = json:decode(data)
        end
        file:close()
    end
    return table
end

function Account:CheckFile()
    self.players = { }
    local FA = io.open(self.dir, "a")
    if (FA) then
        io.close(FA)
    end
    local content = ""
    local FB = io.open(self.dir, "r")
    if (FB) then
        content = FB:read("*all")
        io.close(FB)
    end
    if (len(content) == 0) then
        local FC = assert(io.open(self.dir, "w"))
        if (FC) then
            FC:write("{\n}")
            io.close(FC)
        end
    end
end

function Account:GetIP(Ply)
    local IP = get_var(Ply, "$ip")
    if (self.ClientIndexType == 1) then
        IP = IP:match("%d+.%d+.%d+.%d+")
    end
    return IP
end

function Account:FormatStr(Ply, Msg, Amount)
    local k = tonumber(get_var(Ply, "$kills"))
    local d = tonumber(get_var(Ply, "$deaths"))
    local patterns = {
        { "%%kills%%", k },
        { "%%deaths%%", d },
        { "%%combo%%", self.players[Ply].combos.total },
        { "%%streaks%%", self.players[Ply].streaks },
        { "%%amount%%", self:FormatMoney(Amount) },
        { "%%sym%%", self.currency_symbol }
    }
    for i = 1, #patterns do
        Msg = (gsub(Msg, patterns[i][1], patterns[i][2]))
    end
    return Msg
end

function Account:FormatMoney(M)

    local s = format("%d", floor(M))
    local pos = len(s) % 3

    if (pos == 0) then
        pos = 3
    end

    return sub(s, 1, pos)
            .. gsub(sub(s, pos + 1), "(...)", ",%1")
            .. sub(format("%.2f", M - floor(M)), 2)
end

function isTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
    else
        return false
    end
end

function CMDSplit(CMD)
    local Args, index = { }, 1
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = Params
        index = index + 1
    end
    return Args
end

function Respond(Ply, Message, Type, Color)
    Color = Color or 10
    execute_command("msg_prefix \"\"")

    if (Ply == 0) then
        cprint(Message, Color)
    end

    if (Type == "rprint") then
        rprint(Ply, Message)
    elseif (Type == "say") then
        say(Ply, Message)
    elseif (Type == "say_all") then
        say_all(Message)
    end
    execute_command("msg_prefix \" " .. Account.serverPrefix .. "\"")
end

function checkAccess(Ply, PermLvl)
    if (Ply ~= -1 and Ply >= 1 and Ply < 16) then
        if (tonumber(get_var(Ply, "$lvl")) >= PermLvl) then
            return true
        else
            Respond(Ply, "Command failed. Insufficient Permission", "rprint", 12)
            return false
        end
    elseif (Ply < 1) then
        return true
    end
    return false
end

function GetPlayers(Ply, Args)
    local pl = { }
    if (Args[2] == nil or Args[2] == "me") then
        if (Ply == 0) then
            return Respond(Ply, "Cannot execute command for the server", "rprint", 4 + 8)
        else
            pl[#pl + 1] = tonumber(Ply)
        end
    elseif (Args[2]:match("^%d+$")) and player_present(Args[2]) then
        pl[#pl + 1] = tonumber(Args[2])
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                pl[#pl + 1] = tonumber(i)
            end
        end
    else
        Respond(Ply, "Invalid Player ID or Player not Online", "rprint", 4 + 8)
        Respond(Ply, "Command Usage: /" .. Args[1] .. " [number: 1-16] | */all | me", "rprint", 4 + 8)
    end
    return pl
end

function OnPlayerDeath(V, K)
    return Account:OnPlayerDeath(V, K)
end

function OnTick()
    return Account:OnTick()
end

function OnServerCommand(P, C, _, _)
    return Account:OnServerCommand(P, C, _, _)
end

return Account

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
    starting_balance = 200,

    stats = {

        Non_Consecutive_Kills = {
            -- Non-consecutive, threshold-based kills:
            enabled = true,
            msg = "Total Kills: %kills% (+%currency_symbol%%amount%) dollars added!",
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

        Streaks = {
            enabled = true,
            msg = "%streaks% Kill Streak (+%currency_symbol%%amount% dollars added)",
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
            [1] = { 2, "DEATH (-%currency_symbol%%amount% dollars)", true },
            [2] = { 5, "SUICIDE (-%currency_symbol%%amount% dollars)", true },
            [3] = { 30, "BETRAY (-%currency_symbol%%amount% dollars)", true }
        },

        -- Every kill will reward X amount of money
        PvP = {
            enabled = true, -- Set to 'false' to disable
            award = 10,
            msg = "(x%kills%) kills (+%currency_symbol%%amount%) dollars"
        },

        Assists = {
            enabled = true,
            reward = 30,
            msg = "ASSIST (+%currency_symbol%%amount% dollars)"
        },

        -- reward points | message | enabled/disabled
        Score = {
            enabled = true,
            reward = 30,
            msg = "SCORE (+%currency_symbol%%amount% dollars)"
        }
    },


    --
    -- Advanced users only: Client data will be saved as a json array and
    -- the array index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for IP-only indexing.
    ClientIndexType = 2,
}

local len = string.len
local floor = math.floor
local sub, gsub, format = string.sub, string.gsub, string.format
local json = (loadfile "json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb['EVENT_SCORE'], "OnPlayerScore")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_ASSIST'], "OnPlayerAssist")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    if (get_var(0, "$gt") ~= "n/a") then
        Account:CheckFile()
        Account.players = { }
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
        Account.players = { }
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
        local kills = tonumber(get_var(killer, "$kills"))

        if (killer ~= victim) then
            if (kTeam ~= vTeam) then
                local non_consec = stats.Non_Consecutive_Kills
                if (non_consec.enabled) then
                    for _, v in pairs(non_consec.kills) do
                        if (kills == v[1]) then
                            self:Deposit(killer, v[2], non_consec.msg)
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
    Account.players[Ply].streaks = 0
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
    local accounts = self:GetAccountData()
    if (accounts) then
        local file = assert(io.open(self.dir, "w"))
        if (file) then
            if (Table.streaks) then
                Table.streaks = nil
            end
            accounts[IP] = Table
            file:write(json:encode_pretty(accounts))
            io.close(file)
        end
    end
end

function Account:AddNewAccount(Ply)
    local content = ""
    local File = io.open(self.dir, "r")
    if (File ~= nil) then
        content = File:read("*all")
        io.close(File)
    end
    if (len(content) > 0) then
        local file = assert(io.open(self.dir, "w"))
        if (file) then

            self.players[Ply] = { }

            local IP = self:GetIP(Ply)
            local account = json:decode(content)

            if (account[IP] == nil) then
                account[IP] = {
                    balance = format("%.2f", self.starting_balance),
                }
                file:write(json:encode_pretty(account))
                io.close(file)
            end

            self.players[Ply] = account[IP]
            self.players[Ply].streaks = 0
        end
    end
end

function Account:UpdateALL()
    if (get_var(0, "$gt") ~= "n/a") then
        local accounts = self:GetAccountData()
        if (accounts) then
            for Ply = 1, 16 do
                if player_present(Ply) then
                    local IP = self:GetIP(Ply)
                    self:UpdateJSON(IP, accounts[IP])
                end
            end
        end
    end
end

function Account:GetAccountData()
    local file = io.open(self.dir, "r")
    if (file ~= nil) then
        local data = file:read("*all")
        if (len(data) > 0) then
            return json:decode(data)
        end
    end
    return nil
end

function Account:CheckFile()
    local FA = io.open(self.dir, "a")
    if (FA ~= nil) then
        io.close(FA)
    end
    local content = ""
    local FB = io.open(self.dir, "r")
    if (FB ~= nil) then
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
        { "%%streaks%%", self.players[Ply].streaks },
        { "%%amount%%", self:FormatMoney(Amount) },
        { "%%currency_symbol%%", self.currency_symbol }
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

function OnPlayerDeath(V, K)
    Account:OnPlayerDeath(V, K)
end

return Account

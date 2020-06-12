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
    starting_balance = 200,

    -- Advanced users only: Client data will be saved as a json array and
    -- the array index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for IP-only indexing.
    ClientIndexType = 1
}

local len = string.len
local json = (loadfile "json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
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

function OnPlayerConnect(Ply)
    Account:AddNewAccount(Ply)
end

function OnPlayerDisconnect(Ply)
    Account:UpdateJSON(Account:GetIP(Ply), Account.players[Ply])
    Account.players[Ply] = nil
end

function Account:Deposit(Ply, Amount)
    self.players[Ply].balance = self.players[Ply].balance + Amount
end

function Account:Withdraw(Ply, Amount)
    self.players[Ply].balance = self.players[Ply].balance - Amount
end

function Account:UpdateJSON(IP, Table)
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
                account[IP] = { balance = self.starting_balance }
                file:write(json:encode_pretty(account))
                io.close(file)
            end

            self.players[Ply] = account[IP]
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

return Account

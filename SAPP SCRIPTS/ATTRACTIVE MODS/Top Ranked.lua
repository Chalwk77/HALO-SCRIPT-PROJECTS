--[[
--=====================================================================================================--
Script Name: Top Ranked, for SAPP (PC & CE)
Description: A fully integrated ranking system for SAPP servers.
Players earn credits for killing, scoring and achievements, such as sprees, kill-combos and more.

Credits vary for individual weapons.
For example, you will earn 6 credits for killing someone with the sniper rifle, however, only 4 credits with the plasma pistol.

1): This mod requires that the following json library is installed to your server:
    Place "json.lua" in your servers root directory:
    http://regex.info/blog/lua/json

Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local Rank = {

    dir = "ranks.json",

    check_rank_cmd = "rank",
    check_rank_cmd_permission = -1,
    check_rank_cmd_permission_other = 4,

    messages = {
        [1] = {
            "You are ranked %rank% out of %totalplayers%!",
            "Credits: %credits%",
        },
        [2] = {
            "%name% is ranked %rank% out of %totalplayers%!",
            "Credits: %credits%",
        },
        [3] = { "You do not have permission to execute this command." },
        [4] = { "You do not have permission to execute this command on other players" },
    },

    credits = {

        -- Score (credits added):
        score = 25,

        -- Killed by Server (credits deducted):
        server = 0,

        -- killed by guardians (credits deducted):
        guardians = -5,

        -- suicide (credits deducted):
        suicide = -10,

        -- betrayal (credits deducted):
        betrayal = -15,

        -- {consecutive kills, xp rewarded}
        spree = {
            { 5, 5 },
            { 10, 10 },
            { 15, 15 },
            { 20, 20 },
            { 25, 25 },
            { 30, 30 },
            { 35, 35 },
            { 40, 40 },
            { 45, 45 },
            -- Award 50 credits for every 5 kills at or above 50
            { 50, 50 },
        },

        -- kill-combo required, credits awarded
        multi_kill = {
            { 2, 8 },
            { 3, 10 },
            { 4, 12 },
            { 5, 14 },
            { 6, 16 },
            { 7, 18 },
            { 8, 20 },
            { 9, 23 },
            -- Award 25 credits every 2 kills at or above 10 kill-combos
            { 10, 25 },
        },

        tags = {

            --
            -- tag {type, name, credits}
            --

            -- FALL DAMAGE --
            { "jpt!", "globals\\falling", -3 },
            { "jpt!", "globals\\distance", -4 },

            -- VEHICLE COLLISION --
            -- If you can run over someone with the gun-turret then you deserve these points for sure...
            { "vehi", "vehicles\\ghost\\ghost_mp", 5 },
            { "vehi", "vehicles\\rwarthog\\rwarthog", 6 },
            { "vehi", "vehicles\\warthog\\mp_warthog", 7 },
            { "vehi", "vehicles\\banshee\\banshee_mp", 8 },
            { "vehi", "vehicles\\scorpion\\scorpion_mp", 10 },
            { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 1000 },

            -- VEHICLE PROJECTILES --
            { "jpt!", "vehicles\\ghost\\ghost bolt", 7 },
            { "jpt!", "vehicles\\scorpion\\bullet", 6 },
            { "jpt!", "vehicles\\warthog\\bullet", 6 },
            { "jpt!", "vehicles\\c gun turret\\mp bolt", 7 },
            { "jpt!", "vehicles\\banshee\\banshee bolt", 7 },
            { "jpt!", "vehicles\\scorpion\\shell explosion", 10 },
            { "jpt!", "vehicles\\banshee\\mp_fuel rod explosion", 10 },

            -- WEAPON PROJECTILES --
            { "jpt!", "weapons\\pistol\\bullet", 5 },
            { "jpt!", "weapons\\shotgun\\pellet", 6 },
            { "jpt!", "weapons\\plasma rifle\\bolt", 4 },
            { "jpt!", "weapons\\needler\\explosion", 8 },
            { "jpt!", "weapons\\plasma pistol\\bolt", 4 },
            { "jpt!", "weapons\\assault rifle\\bullet", 5 },
            { "jpt!", "weapons\\needler\\impact damage", 4 },
            { "jpt!", "weapons\\flamethrower\\explosion", 5 },
            { "jpt!", "weapons\\rocket launcher\\explosion", 8 },
            { "jpt!", "weapons\\needler\\detonation damage", 3 },
            { "jpt!", "weapons\\plasma rifle\\charged bolt", 4 },
            { "jpt!", "weapons\\sniper rifle\\sniper bullet", 6 },
            { "jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion", 8 },

            -- GRENADES --
            { "jpt!", "weapons\\frag grenade\\explosion", 8 },
            { "jpt!", "weapons\\plasma grenade\\attached", 7 },
            { "jpt!", "weapons\\plasma grenade\\explosion", 5 },

            -- MELEE --
            { "jpt!", "weapons\\flag\\melee", 5 },
            { "jpt!", "weapons\\ball\\melee", 5 },

            { "jpt!", "weapons\\pistol\\melee", 4 },

            { "jpt!", "weapons\\needler\\melee", 4 },
            { "jpt!", "weapons\\shotgun\\melee", 5 },

            { "jpt!", "weapons\\flamethrower\\melee", 5 },
            { "jpt!", "weapons\\sniper rifle\\melee", 5 },
            { "jpt!", "weapons\\plasma rifle\\melee", 4 },
            { "jpt!", "weapons\\plasma pistol\\melee", 4 },
            { "jpt!", "weapons\\assault rifle\\melee", 4 },
            { "jpt!", "weapons\\rocket launcher\\melee", 10 },
            { "jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_melee", 10 },
        }
    },

    --
    -- Advanced users only:
    --
    --

    -- Client data is saved as a json array.
    -- The array index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for IP-only indexing.
    ClientIndexType = 2,

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    server_prefix = "**SAPP**",
    --
}

local len = string.len
local gmatch, gsub = string.gmatch, string.gsub
local lower, upper = string.lower, string.upper
local json = (loadfile "json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_SCORE"], "OnPlayerScore")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")
    if (get_var(0, "$gt") ~= "n/a") then
        Rank:CheckFile()
    end
end

function OnScriptUnload()
    Rank:UpdateALL()
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        Rank:CheckFile()
    end
end

function OnGameEnd()
    Rank:UpdateALL()
end

function OnPlayerConnect(Ply)
    Rank:AddNewPlayer(Ply)
end

function OnPlayerDisconnect(Ply)
    Rank:UpdateJSON(Ply)
    Rank.players[Ply] = nil
end

function OnPlayerScore(Ply)
    Rank:UpdateCredits(Ply, Rank.credits.score)
end

function Rank:AddNewPlayer(Ply)

    local content = ""
    local File = io.open(self.dir, "r")
    if (File) then
        content = File:read("*all")
        io.close(File)
    end

    if (len(content) > 0) then
        local file = assert(io.open(self.dir, "w"))
        if (file) then

            local pl = json:decode(content)
            local IP = self:GetIP(Ply)
            local name = get_var(Ply, "$name")

            if (pl[IP] == nil) then
                pl[IP] = {
                    name = name,
                    last_damage = nil,
                    rank = 0, credits = 0,
                    ip = IP, id = Ply
                }
            end

            file:write(json:encode_pretty(pl))
            io.close(file)

            self.players[Ply] = { }
            self.players[Ply] = pl[IP]
            self.players[Ply].id = Ply
            self.players[Ply].name = name

            self:GetRank(Ply, IP)
        end
    end
end

function Rank:UpdateJSON(Ply)
    local ranks = self:GetRanks()
    if (ranks) then
        local file = assert(io.open(self.dir, "w"))
        if (file) then
            ranks[self.players[Ply].ip] = self.players[Ply]
            file:write(json:encode_pretty(ranks))
            io.close(file)
        end
    end
end

function Rank:UpdateALL()
    if (get_var(0, "$gt") ~= "n/a") then
        local ranks = self:GetRanks()
        if (ranks) then
            local file = assert(io.open(self.dir, "w"))
            if (file) then
                file:write(json:encode_pretty(ranks))
                io.close(file)
            end
        end
    end
end

local function GetAllIP()
    local p = { }
    for i = 1, 16 do
        if player_present(i) then
            p[i] = Rank:GetIP(i)
        end
    end
    return p
end

function Rank:GetRanks()
    local ranks
    local file = io.open(self.dir, "r")
    if (file) then
        local data = file:read("*all")
        if (len(data) > 0) then
            ranks = json:decode(data)
            local p = GetAllIP()
            if (#p > 0) then
                for i, ip in pairs(p) do
                    ranks[ip] = self.players[i]
                end
            end
        end
        file:close()
    end
    return ranks
end

function Rank:GetRank(Ply, IP, CMD)

    local ranks = Rank:GetRanks()
    if (ranks ~= nil) then

        local results = { }
        for _, v in pairs(ranks) do
            results[#results + 1] = { ["ip"] = v.ip, ["credits"] = v.credits, ["name"] = v.name }
        end

        table.sort(results, function(a, b)
            return a.credits > b.credits
        end)

        for k, v in pairs(results) do
            if (IP == v.ip) then
                local function PrintSelf(I)
                    for i = 1, #self.messages[2] do
                        local str = gsub(gsub(gsub(gsub(self.messages[I][i],
                                "%%rank%%", k),
                                "%%name%%", v.name),
                                "%%credits%%", v.credits),
                                "%%totalplayers%%", #results)
                        Rank:Respond(Ply, str, say, 10)
                    end
                end
                if (CMD) then
                    if (self:GetIP(Ply) == IP) then
                        PrintSelf(1)
                    else
                        PrintSelf(2)
                    end
                else
                    PrintSelf(1)
                    local str = v.name .. " connected -> Rank " .. k .. " out of " .. #results .. " with " .. v.credits .. " credits."
                    Rank:Respond(Ply, str, say, 10, true)
                end
            end
        end
    end
end

function Rank:GetIP(Ply)
    local IP = get_var(Ply, "$ip")
    if (self.ClientIndexType == 1) then
        IP = IP:match("%d+.%d+.%d+.%d+")
    end
    return IP
end

function Rank:CheckFile()
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

local function GetTag(ObjectType, ObjectName)
    local Tag = lookup_tag(ObjectType, ObjectName)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

local function CheckDamageTag(DamageMeta)
    for _, d in pairs(Rank.credits.tags) do
        local tag = GetTag(d[1], d[2])
        if (tag ~= nil) then
            if (tag == DamageMeta) then
                return d[3]
            end
        end
    end
    return 0
end

local function GetVehicleCredits(VehicleObject)
    local name = GetVehicleTag(VehicleObject)
    if (name ~= nil) then
        for _, d in pairs(Rank.credits.tags) do
            if (d[2] == name) then
                return d[3]
            end
        end
    end
    return 0
end

local function InVehicle(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local VehicleID = read_dword(DyN + 0x11C)
        if (VehicleID ~= 0XFFFFFFFF) then
            local VehicleObject = get_object_memory(VehicleID)
            local credits = GetVehicleCredits(VehicleObject)
            if (credits ~= 0) then
                return credits
            else
                return nil
            end
        end
    end
    return nil
end

function Rank:KillingSpree(Ply)
    local player = get_player(Ply)
    if (player ~= 0) then
        local spree = read_word(player + 0x96)
        for _, v in pairs(self.credits.spree) do
            if (spree >= v[1] and spree % 5 == 0) then
                self:UpdateCredits(Ply, v[2])
            end
        end
    end
end

function Rank:KillingSpree(Ply)
    local player = get_player(killer)
    if (player ~= 0) then
        local t = self.credits.spree
        local k = read_word(player + 0x96)
        for _, v in pairs(t) do
            if (k == v[1]) or (k >= t[#t][1] and k % 5 == 0) then
                self:UpdateCredits(Ply, v[2])
            end
        end
    end
end

function Rank:MultiKill(Ply)
    local player = get_player(Ply)
    if (player ~= 0) then
        local k = read_word(player + 0x98)
        local t = self.credits.multi_kill
        for _, v in pairs(t) do
            if (k == v[1]) or (k >= t[#t][1] and k % 2 == 0) then
                return self:UpdateCredits(Ply, v[2])
            end
        end
    end
end

function Rank:OnPlayerDeath(VictimIndex, KillerIndex)
    local killer, victim = tonumber(KillerIndex), tonumber(VictimIndex)

    local last_damage = self.players[victim].last_damage
    local kteam = get_var(killer, "$team")
    local vteam = get_var(victim, "$team")

    local server = (killer == -1)
    local guardians = (killer == nil)
    local suicide = (killer == victim)
    local pvp = ((killer > 0) and killer ~= victim)
    local betrayal = ((kteam == vteam) and killer ~= victim)

    if (pvp) then
        local vehicle = InVehicle(killer)

        Rank:MultiKill(killer)
        Rank:KillingSpree(killer)

        if (vehicle) then
            self:UpdateCredits(killer, vehicle)
        else
            self:UpdateCredits(killer, CheckDamageTag(last_damage))
        end
    elseif (server) then
        self:UpdateCredits(victim, self.credits.server)
    elseif (guardians) then
        self:UpdateCredits(victim, self.credits.guardians)
    elseif (suicide) then
        self:UpdateCredits(victim, self.credits.suicide)
    elseif (betrayal) then
        self:UpdateCredits(victim, self.credits.betrayal)
    else
        self:UpdateCredits(victim, CheckDamageTag(last_damage))
    end
end

function Rank:UpdateCredits(Ply, Amount)
    local cr = self.players[Ply].credits
    cr = cr + (Amount)
    if (cr < 0) then
        cr = 0
    end
end

function OnDamageApplication(VictimIndex, KillerIndex, MetaID, _, _, _)
    local k, v = tonumber(KillerIndex), tonumber(VictimIndex)
    if player_present(v) then
        if (k > 0) then
            Rank.players[k].last_damage = MetaID
        end
        Rank.players[v].last_damage = MetaID
    end
end

function GetVehicleTag(Vehicle)
    if (Vehicle ~= nil and Vehicle ~= 0) then
        return read_string(read_dword(read_word(Vehicle) * 32 + 0x40440038))
    end
    return nil
end

function Rank:Respond(Ply, Message, Type, Color, Exclude)
    Color = Color or 10
    execute_command("msg_prefix \"\"")
    if (Ply == 0) then
        cprint(Message, Color)
    elseif (not Exclude) then
        if (Type ~= say_all) then
            Type(Ply, Message)
        else
            Type(Message)
        end
    else
        for i = 1, 16 do
            if player_present(i) and (i ~= Ply) then
                Type(i, Message)
            end
        end
    end
    execute_command("msg_prefix \" " .. self.server_prefix .. "\"")
end

local function CMDSplit(CMD)
    local Args, index = { }, 1
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = Params
        index = index + 1
    end
    return Args
end

function Rank:OnServerCommand(Executor, Command, _, _)
    local Args = CMDSplit(Command)
    if (Args == nil) then
        return
    else
        Args[1] = lower(Args[1]) or upper(Args[1])
        if (Args[1] == self.check_rank_cmd) then
            local lvl = tonumber(get_var(Executor, "$lvl"))
            if (lvl >= self.check_rank_cmd_permission) then
                local pl = self:GetPlayers(Executor, Args)
                if (pl) then
                    for i = 1, #pl do
                        local TargetID = tonumber(pl[i])
                        if (TargetID ~= Executor and lvl < self.check_rank_cmd_permission_other) then
                            self:Respond(Executor, self.messages[4], rprint, 10)
                        else
                            Rank:GetRank(Executor, self:GetIP(TargetID), true)
                        end
                    end
                end
            else
                self:Respond(Executor, self.messages[3], rprint, 10)
            end
            return false
        end
    end
end

function Rank:GetPlayers(Executor, Args)
    local pl = { }
    if (Args[2] == "me" or Args[2] == nil) then
        if (Executor ~= 0) then
            table.insert(pl, Executor)
        else
            self:Respond(Executor, "The server cannot execute this command!", rprint, 10)
        end
    elseif (Args[2] ~= nil) and (Args[2]:match("^%d+$")) then
        if player_present(Args[2]) then
            table.insert(pl, Args[2])
        else
            self:Respond(Executor, "Player #" .. Args[2] .. " is not online", rprint, 10)
        end
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
        if (#pl == 0) then
            self:Respond(Executor, "There are no players online!", rprint, 10)
        end
    else
        self:Respond(Executor, "Invalid Command Syntax. Please try again!", rprint, 10)
    end
    return pl
end

-- SUPPORT FOR MY RAGE QUIT SCRIPT:
function UpdateRageQuit(ip, amount)
    local ranks = Rank:GetRanks()
    if (ranks) then
        local file = assert(io.open(Rank.dir, "w"))
        if (file) then
            if (ranks[ip] ~= nil) then
                ranks[ip].credits = ranks[ip].credits - amount
                local name = ranks[ip].name
                local str = name .. " was penalized " .. amount .. "x credits for rage-quitting"
                Rank:Respond(_, str, say_all, 10)
                Rank:Respond(0, str, "n/a", 10)
            end
            file:write(json:encode_pretty(ranks))
            io.close(file)
        end
    end
end

function OnServerCommand(P, C, _, _)
    return Rank:OnServerCommand(P, C, _, _)
end

function OnPlayerDeath(V, K)
    return Rank:OnPlayerDeath(V, K)
end
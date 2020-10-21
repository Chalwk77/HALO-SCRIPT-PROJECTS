api_version = "1.12.0.0"

local Rank = {

    dir = "ranks.json",

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
    serverPrefix = "**SAPP**",
    --

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
    }
}

local len = string.len
local json = (loadfile "json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_SCORE"], "OnPlayerScore")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
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
    Rank:UpdateJSON(Rank.players[Ply].ip)
    Rank.players[Ply] = nil
end

function OnPlayerScore(Ply)
    UpdateCredits(Ply, Rank.credits.score)
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
            local ip = self:GetIP(Ply)
            if (pl[ip] == nil) then
                pl[ip] = { rank = 0, credits = 0, last_damage = nil, ip = ip }
            end

            file:write(json:encode_pretty(pl))
            io.close(file)

            local total_players = 0

            self.players[Ply] = { }
            self.players[Ply] = pl[ip]

            execute_command("msg_prefix \"\"")
            say_all("You are ranked " .. self.players[Ply].rank .. " out of " .. total_players)
            execute_command("msg_prefix \" " .. Rank.serverPrefix .. "\"")
        end
    end
end

function Rank:UpdateJSON(ip)
    local ranks = self:GetRanks()
    if (ranks) then
        local file = assert(io.open(self.dir, "w"))
        if (file) then
            ranks[ip] = self.players[ip]
            file:write(json:encode_pretty(ranks))
            io.close(file)
        end
    end
end

local function GetAllIP()
    local p = { }
    for i = 1, 16 do
        if player_present(i) then
            p[#p + 1] = Rank:GetIP(i)
        end
    end
    return p
end

function Rank:UpdateALL()
    if (get_var(0, "$gt") ~= "n/a") then
        local p = GetAllIP()
        if (#p > 0) then
            local ranks = self:GetRanks()
            if (ranks) then
                local file = assert(io.open(self.dir, "w"))
                if (file) then
                    for _, ip in pairs(p) do
                        ranks[ip] = self.players[ip]
                    end
                    file:write(json:encode_pretty(ranks))
                    io.close(file)
                end
            end
        end
    end
end

function Rank:GetRanks()
    local table
    local file = io.open(self.dir, "r")
    if (file) then
        local data = file:read("*all")
        if (len(data) > 0) then
            table = json:decode(data)
        end
        file:close()
    end
    return table
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

function OnPlayerDeath(VictimIndex, KillerIndex)
    local killer, victim = tonumber(KillerIndex), tonumber(VictimIndex)

    local last_damage = Rank.players[victim].last_damage
    local kteam = get_var(killer, "$team")
    local vteam = get_var(victim, "$team")

    local server = (killer == -1)
    local guardians = (killer == nil)
    local suicide = (killer == victim)
    local pvp = ((killer > 0) and killer ~= victim)
    local betrayal = ((kteam == vteam) and killer ~= victim)

    if (pvp) then
        local vehicle = InVehicle(killer)
        if (vehicle) then
            UpdateCredits(killer, vehicle)
        else
            UpdateCredits(killer, CheckDamageTag(last_damage))
        end
    elseif (server) then
        UpdateCredits(victim, Rank.credits.server)
    elseif (guardians) then
        UpdateCredits(victim, Rank.credits.guardians)
    elseif (suicide) then
        UpdateCredits(victim, Rank.credits.suicide)
    elseif (betrayal) then
        UpdateCredits(victim, Rank.credits.betrayal)
    else
        UpdateCredits(victim, CheckDamageTag(last_damage))
    end
end

function UpdateCredits(Ply, Amount)
    print(Amount, Amount, Amount, Amount, Amount, Amount, Amount)
    Rank.players[Ply].credits = Rank.players[Ply].credits + Amount
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
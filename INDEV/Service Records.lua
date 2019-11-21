--[[
--=====================================================================================================--
Script Name: Service Records, for SAPP (PC & CE)

### Important:
This mod requires that the following json library is installed to your server:
http://regex.info/blog/lua/json

Place "json.lua" in your servers root directory.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

api_version = "1.12.0.0"
local players, ranks = {}, {}

-- Configuration Starts --
local path = "sapp\\playerdata.json"

local AnnounceRank = true
local rank_feedback = "Server Statistics: You are currently ranked %rank% out of %total%."

local function FormatTable(PlayerIndex)
    return {
        id = PlayerIndex,
        name = get_var(PlayerIndex, "$name"),
        hash = get_var(PlayerIndex, "$hash"),
        rank = ranks[1].title,
        credits = 0,
        credits_until_next_rank = ranks[2][1],
        last_damage = "",
        joins = 0,
        kdr = 0,
        games_played = 0,
        time_played = 0,
        distance_traveled = 0,
        stats = {
            kills = {
                total = 0,
                deaths = 0,
                assists = 0,
                betrays = 0,
                suicides = 0,
                melee = 0,
                fragnade = 0,
                plasmanade = 0,
                grenadestuck = 0,
                sniper = 0,
                shotgun = 0,
                rocket = 0,
                fuelrod = 0,
                plasmarifle = 0,
                plasmapistol = 0,
                empblast = 0,
                rockethog = 0,
                pistol = 0,
                needler = 0,
                flamethrower = 0,
                flagmelee = 0,
                oddballmelee = 0,
                assaultrifle = 0,
                chainhog = 0,
                tankshell = 0,
                tankmachinegun = 0,
                ghost = 0,
                turret = 0,
                bansheefuelrod = 0,
                banshee = 0,
                splatter = 0
            },
            sprees = {
                double_kill = 0,
                triple_kill = 0,
                overkill = 0,
                killtacular = 0,
                killtrocity = 0,
                killimanjaro = 0,
                killtastrophe = 0,
                killpocalypse = 0,
                killionaire = 0,
                kiling_spree = 0,
                killing_frenzy = 0,
                running_riot = 0,
                rampage = 0,
                untouchable = 0,
                invincible = 0,
                anomgstopkillingme = 0
            },
            medals = {
                sprees = "False",
                assists = "False",
                closequarters = "False",
                crackshot = "False",
                roadrage = "False",
                grenadier = "False",
                heavyweapons = "False",
                jackofalltrades = "False",
                mobileasset = "False",
                multikill = "False",
                sidearm = "False",
                triggerman = "False"
            }
        }
    }
end

ranks = {
    [1] = {
        title = "Recruit",
        [1] = 0,
    },
    [2] = {
        title = "Private",
        [1] = 7500,
    },
    [3] = {
        title = "Corporal",
        [1] = 10000,
        [2] = 15000, -- grade 1
    },
    [4] = {
        title = "Sergeant",
        [1] = 20000,
        [2] = 26250, -- grade 1
        [3] = 32500, -- grade 2
    },
    [5] = {
        title = "Warrant Officer",
        [1] = 45000,
        [2] = 78000, -- grade 1
        [3] = 111000, -- grade 2
        [4] = 144000, -- grade 3
    },
    [6] = {
        title = "Captain",
        [1] = 210000,
        [2] = 233000, -- grade 1
        [3] = 256000, -- grade 2
        [4] = 279000, -- grade 3
    },
    [7] = {
        title = "Major",
        [1] = 325000,
        [2] = 350000, -- grade 1
        [3] = 375000, -- grade 2
        [4] = 400000, -- grade 3
    },
    [8] = {
        title = "Lt. Colonel",
        [1] = 450000,
        [2] = 480000, -- grade 1
        [3] = 510000, -- grade 2
        [4] = 540000, -- grade 3
    },
    [9] = {
        title = "Commander",
        [1] = 600000,
        [2] = 650000, -- grade 1
        [3] = 700000, -- grade 2
        [4] = 750000, -- grade 3
    },
    [10] = {
        title = "Colonel",
        [1] = 850000,
        [2] = 960000, -- grade 1
        [3] = 1070000, -- grade 2
        [4] = 1180000, -- grade 3
    },
    [11] = {
       title = "Brigadier",
        [1] = 1400000,
        [2] = 1520000, -- grade 1
        [3] = 1640000, -- grade 2
        [4] = 1760000, -- grade 3
    },
    [12] = {
        title = "General",
        [1] = 2000000,
        [2] = 2200000, -- grade 1
        [3] = 2350000, -- grade 2
        [4] = 2500000, -- grade 3
        [5] = 2650000, -- grade 4
    },
    [13] = {
        title = "Field Marshall",
        [1] = 3000000
    },
    [14] = {
        title = "Hero",
        [1] = 3700000
    },
    [15] = {
        title = "Legend",
        [1] = 4600000
    },
    [16] = {
        title = "Mythic",
        [1] = 5650000
    },
    [17] = {
        title = "Noble",
        [1] = 7000000
    },
    [18] = {
        title = "Eclipse",
        [1] = 8500000
    },
    [19] = {
        title = "Nova",
        [1] = 11000000
    },
    [20] = {
        title = "Forerunner",
        [1] = 13000000
    },
    [21] = {
        title = "Reclaimer",
        [1] = 16500000
    },
    [22] = {
        title = "Inheritor",
        [1] = 20000000
    },
}

-- Configuration Ends --

local json = (loadfile "json.lua")()
local tags = {}
local avenger = { }
local game_over
local script_version = 1.0
local first_blood

local gsub = string.gsub
local format = string.format

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb['EVENT_GAME_START'], 'OnGameStart')
    register_callback(cb['EVENT_LEAVE'], 'OnPlayerDisconnect')
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPreSpawn")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")

    if (get_var(0, "$gt") ~= "n/a") then
        CheckFile()
        LoadItems()
        players = {}
        game_over = false
        for i = 1, 16 do
            if player_present(i) then
                local ip = get_var(i, "$ip"):match('(%d+.%d+.%d+.%d+)')
                players[i] = { ip = ip, data = GetStats(ip), avenger = nil }
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        CheckFile()
        LoadItems()
        players = {}
        game_over = false
    end
end

function OnGameEnd()
    if (get_var(0, "$gt") ~= "n/a") then
        game_over = true
        for i = 1, 16 do
            if player_present(i) then
                local t = players[i].data
                t.stats.games_played = t.stats.games_played + 1
                UpdateStats(i)
            end
        end
    end
end

function OnPlayerConnect(PlayerIndex)

    local p = tonumber(PlayerIndex)
    local ip = get_var(p, "$ip"):match('(%d+.%d+.%d+.%d+)')
    if (p == 2) then
        ip = "000.000.000.000"
    elseif (p == 3) then
        ip = "101.202.303.404"
    end

    players[p] = { ip = ip, data = {}, avenger = nil }

    if (not GetStats(ip)) then

        local stats = nil
        local file = io.open(path, "r")
        if (file ~= nil) then
            local data = file:read("*all")
            stats = json:decode(data)
            io.close(file)
        end

        local file = assert(io.open(path, "w"))
        if (file) then
            stats[ip] = FormatTable(p)
            file:write(json:encode_pretty(stats))
            io.close(file)
        end
    end

    players[p].data = GetStats(ip)

    if (AnnounceRank) then
        AnnouncePlayerRank(p)
    end
end

function OnPlayerDisconnect(PlayerIndex)
    local p = tonumber(PlayerIndex)
    players[p] = nil
    --

end

function OnPlayerPreSpawn(PlayerIndex)
    local p = tonumber(PlayerIndex)
    if player_present(p) then
        local t = players[p]
        if (t) then
            t.data.last_damage = ""
        end
    end
    --
end

function OnPlayerDeath(PlayerIndex, KillerIndex)

    local killer = tonumber(KillerIndex)
    local victim = tonumber(PlayerIndex)

    local kteam = get_var(killer, "$team")
    local vteam = get_var(victim, "$team")

    local v_params = players[victim]
    if (v_params) then
        v = v_params.data

        local k_params = players[killer]
        if (k_params) then
            k = k_params.data
        end

        local k_player_object = get_dynamic_player(killer)
        local v_player_object = get_dynamic_player(victim)
        
        local suicide = (killer == victim)
        local betrayal = ((kteam == vteam) and killer ~= victim)
        local pvp = ((killer > 0) and killer ~= victim)
        local vehicle_squash = (killer == 0)
        local guardians = (killer == nil)
        local server = (killer == -1)
        local fall_distance_damage = (v.last_damage == tags[1] or v.last_damage == tags[2])
        
        v.stats.kills.deaths = v.stats.kills.deaths + 1
        
        local coords = getXYZ(killer, k_player_object)
        -- Road Rage:
        if (coords.invehicle and coords.seat == 0) then
            k.credits = k.credits + 5
        end

        local melee = function()
            for i = 1, #tags.melee do
                if (v.last_damage == tags.melee[i]) then
                    k.credits = k.credits + 13
                    return true
                end
            end
        end

        if (suicide) then
            v.stats.kills.suicides = v.stats.kills.suicides + 1
        elseif (pvp) then

            k.stats.kills.total = k.stats.kills.total + 1
            ConsecutiveKills(killer)
            MultiKill(killer)
            KillingSpree(killer)
            
            -- Killed from the grave
            if (not player_alive(killer)) then
                k.stats.kills.total = k.stats.kills.total + 10
            end

            if (v.last_damage == tags[15] or v.last_damage == tags[17] or v.last_damage == tags[21]) then
                k.stats.kills.needler = k.stats.kills.needler + 1
                k.credits = k.credits + 7
            elseif (v.last_damage == tags[24]) then
                k.stats.kills.fragnade = k.stats.kills.fragnade + 1
                k.credits = k.credits + 8
            elseif (v.last_damage == tags[25]) then
                k.stats.kills.grenadestuck = k.stats.kills.grenadestuck + 1
                k.credits = k.credits + 8
            elseif (v.last_damage == tags[26]) then
                k.stats.kills.plasmanade = k.stats.kills.plasmanade + 1
                k.credits = k.credits + 8
            elseif (v.last_damage == tags[3]) then
                k.stats.kills.splatter = k.stats.kills.splatter + 1
                k.credits = k.credits + 13
            elseif (v.last_damage == tags[10]) then
                k.stats.kills.bansheefuelrod = k.stats.kills.bansheefuelrod + 1
                k.credits = k.credits + 13
            elseif (v.last_damage == tags[8]) then
                k.stats.kills.banshee = k.stats.kills.banshee + 1
                k.credits = k.credits + 13
            elseif (v.last_damage == tags[7]) then
                k.stats.kills.turret = k.stats.kills.turret + 1
                k.credits = k.credits + 6
            elseif (v.last_damage == tags[4]) then
                k.stats.kills.ghost = k.stats.kills.ghost + 1
                k.credits = k.credits + 7
            elseif (v.last_damage == tags[5]) then
                k.stats.kills.tankmachinegun = k.stats.kills.tankmachinegun + 1
                k.credits = k.credits + 8
            elseif (v.last_damage == tags[9]) then
                k.stats.kills.tankshell = k.stats.kills.tankshell + 1
                k.credits = k.credits + 13
            elseif (v.last_damage == tags[6]) then
                k.stats.kills.chainhog = k.stats.kills.chainhog + 1
                k.credits = k.credits + 8
            elseif (v.last_damage == tags[16]) then
                k.stats.kills.assaultrifle = k.stats.kills.assaultrifle + 1
                k.credits = k.credits + 8
            elseif (v.last_damage == tags[18]) then
                k.stats.kills.flamethrower = k.stats.kills.flamethrower + 1
                k.credits = k.credits + 6
            elseif (v.last_damage == tags[11]) then
                k.stats.kills.pistol = k.stats.kills.pistol + 1
                k.credits = k.credits + 8
            elseif (v.last_damage == tags[14]) then
                k.stats.kills.plasmapistol = k.stats.kills.plasmapistol + 1
                k.credits = k.credits + 6
            elseif (v.last_damage == tags[22]) then
                k.stats.kills.empblast = k.stats.kills.empblast + 1
                k.credits = k.credits + 6
            elseif (v.last_damage == tags[12]) then
                k.stats.kills.plasmarifle = k.stats.kills.plasmarifle + 1
                k.credits = k.credits + 7
            elseif (v.last_damage == tags[23]) then
                k.stats.kills.fuelrod = k.stats.kills.fuelrod + 1
                k.credits = k.credits + 11
            elseif (v.last_damage == tags[13]) then
                k.stats.kills.shotgun = k.stats.kills.shotgun + 1
                k.credits = k.credits + 8
            elseif (v.last_damage == tags[19]) then
                k.stats.kills.sniper = k.stats.kills.sniper + 1
                k.credits = k.credits + 13
            elseif (v.last_damage == tags[20]) then
                local player = read_dword(get_player(victim) + 0x34)
                k.credits = k.credits + 13
                if (player ~= 0) then
                    if (coords.invehicle) then
                        k.stats.kills.rockethog = k.stats.kills.rockethog + 1
                    else
                        k.stats.kills.rocket = k.stats.kills.rocket + 1
                    end
                end
            end
        elseif (betrayal) then
            k.stats.kills.betrays = k.stats.kills.betrays + 1
        elseif (fall_distance_damage) then
            --
        end
        --
        if (k and melee) then
            k.stats.kills.melee = k.stats.kills.melee + 1
        end
        --
        
        -- First Blood:
        if (first_blood == 0 and k) then
            first_blood = first_blood + 1
            k.credits = k.credits + 10
        end
        
        -- Reload This
        local reloading = read_byte(v_player_object + 0x2A4)
        if (reloading == 5) then
            k.credits = k.credits + 5
        end
        
        -- Avenger
        for i = 1, 16 do
            if player_present(i) then
                if (i ~= victim) then
                    if get_var(i, "$team") == get_var(victim, "$team") then
                        players[i].avenger = k_params.ip
                    end
                end
            end
        end

        if (k) then
            if (k_params.avenger == v_params.ip) then
                k.credits = k.credits + 5
                print("AVENGER")
            end
        end
        
        SetRank(killer)
        UpdateStats(victim)
        UpdateStats(killer)
    end
end

function ConsecutiveKills(killer)
    local k = players[killer]
    if (k) then
        k = k.data
        local player = get_player(killer)
        if (player ~= 0) then
            local kills = tonumber(get_var(killer, "$kills"))
            if (kills == 10) then
                k.credits = k.credits + 5
            elseif (kills == 20) then
                k.credits = k.credits + 5
            elseif (kills == 30) then
                k.credits = k.credits + 5
            elseif (kills == 40) then
                k.credits = k.credits + 5
            elseif (kills == 50) then
                k.credits = k.credits + 10
            elseif (kills == 60) then
                k.credits = k.credits + 10
            elseif (kills == 70) then
                k.credits = k.credits + 10
            elseif (kills == 80) then
                k.credits = k.credits + 10
            elseif (kills == 90) then
                k.credits = k.credits + 10
            elseif (kills == 100) then
                k.credits = k.credits + 10
            elseif (kills > 100) then
                k.credits = k.credits + 5
            end
        end
    end
end

function MultiKill(killer)
    local k = players[killer]
    if (k) then
        k = k.data
        local player = get_player(killer)
        if (player ~= 0) then
            local multi = read_word(player + 0x98)
            if (multi == 2) then
                k.credits = k.credits + 8
            elseif (multi == 3) then
                k.credits = k.credits + 10
            elseif (multi == 4) then
                k.credits = k.credits + 12
            elseif (multi == 5) then
                k.credits = k.credits + 14
            elseif (multi == 6) then
                k.credits = k.credits + 16
            elseif (multi == 7) then
                k.credits = k.credits + 18
            elseif (multi == 8) then
                k.credits = k.credits + 20
            elseif (multi == 9) then
                k.credits = k.credits + 22
            elseif (multi >= 10) then
                k.credits = k.credits + 25
            end
        end
    end
end

function KillingSpree(killer)
    local k = players[killer]
    if (k) then
        k = k.data
        local player = get_player(killer)
        if (player ~= 0) then
            local spree = read_word(player + 0x96)
            if (spree == 5) then
                k.credits = k.credits + 5
            elseif (spree == 10) then
                k.credits = k.credits + 10
            elseif (spree == 15) then
                k.credits = k.credits + 15
            elseif (spree == 20) then
                k.credits = k.credits + 20
            elseif (spree == 25) then
                k.credits = k.credits + 25
            elseif (spree == 30) then
                k.credits = k.credits + 30
            elseif (spree == 35) then
                k.credits = k.credits + 35
            elseif (spree >= 40 and spree % 5 == 0) then
                k.credits = k.credits + 40
            end
        end
    end
end

function SetRank(PlayerIndex)
    local t = players[PlayerIndex]
    if (t) then
        t = t.data
        for i = 1,#ranks do
            for j = 1,#ranks[i] do
                local CRC = ranks[i][j]
                local NRC = ranks[i+1]
                if (NRC ~= nil) then
                    NRC = NRC[1]
                    if (t.credits > CRC and t.credits < NRC) then
                        t.rank = ranks[i].title
                    end
                end
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0) then
        local t = players[PlayerIndex]
        if (t) then
            t.data.last_damage = MetaID
        end
    end
end

function UpdateStats(PlayerIndex)
    if (PlayerIndex > 0) then
        local stats = GetStats()
        local t = players[PlayerIndex]
        if (stats and t) then
            stats[t.ip] = t.data
            local file = assert(io.open(path, "w"))
            if (file) then
                file:write(json:encode_pretty(stats))
                io.close(file)
            end
        end
    end
end

function GetStats(ip)
    local stats = nil
    local file = io.open(path, "r")
    if (file ~= nil) then
        local data = file:read("*all")
        stats = json:decode(data)
        if (stats ~= nil and ip) then
            stats = stats[ip]
        end
        io.close(file)
    end
    return stats
end

function AnnouncePlayerRank(PlayerIndex)

    local t = players[PlayerIndex]
    local stats = GetStats()

    local credits = { }
    for k, v in pairs(stats) do
        table.insert(credits, { ip = k, credits = v.credits })
    end

    table.sort(credits, function(a, b)
        return a.credits > b.credits
    end)

    for k, v in pairs(credits) do
        if (v.ip == t.ip) then
            local msg = gsub(gsub(rank_feedback, "%%rank%%", k), "%%total%%", #credits)
            return rprint(PlayerIndex, msg)
        end
    end
end

function CheckFile()
    local file = io.open(path, "a")
    if (file ~= nil) then
        io.close(file)
    end

    local stats = nil
    local file = io.open(path, "r")
    if (file ~= nil) then
        local data = file:read("*all")
        stats = json:decode(data)
        io.close(file)
    end

    if (stats == nil) then
        local file = assert(io.open(path, "w"))
        if (file) then
            file:write("{\n}")
            io.close(file)
        end
    end
end

function LoadItems()
    first_blood = 0
    tags = {
        -- fall damage --
        [1] = GetTag("jpt!", "globals\\falling"),
        [2] = GetTag("jpt!", "globals\\distance"),

        -- vehicle collision --
        [3] = GetTag("jpt!", "globals\\vehicle_collision"),

        -- vehicle projectiles --
        [4] = GetTag("jpt!", "vehicles\\ghost\\ghost bolt"),
        [5] = GetTag("jpt!", "vehicles\\scorpion\\bullet"),
        [6] = GetTag("jpt!", "vehicles\\warthog\\bullet"),
        [7] = GetTag("jpt!", "vehicles\\c gun turret\\mp bolt"),
        [8] = GetTag("jpt!", "vehicles\\banshee\\banshee bolt"),
        [9] = GetTag("jpt!", "vehicles\\scorpion\\shell explosion"),
        [10] = GetTag("jpt!", "vehicles\\banshee\\mp_fuel rod explosion"),

        -- weapon projectiles --
        [11] = GetTag("jpt!", "weapons\\pistol\\bullet"),
        [12] = GetTag("jpt!", "weapons\\plasma rifle\\bolt"),
        [13] = GetTag("jpt!", "weapons\\shotgun\\pellet"),
        [14] = GetTag("jpt!", "weapons\\plasma pistol\\bolt"),
        [15] = GetTag("jpt!", "weapons\\needler\\explosion"),
        [16] = GetTag("jpt!", "weapons\\assault rifle\\bullet"),
        [17] = GetTag("jpt!", "weapons\\needler\\impact damage"),
        [18] = GetTag("jpt!", "weapons\\flamethrower\\explosion"),
        [19] = GetTag("jpt!", "weapons\\sniper rifle\\sniper bullet"),
        [20] = GetTag("jpt!", "weapons\\rocket launcher\\explosion"),
        [21] = GetTag("jpt!", "weapons\\needler\\detonation damage"),
        [22] = GetTag("jpt!", "weapons\\plasma rifle\\charged bolt"),
        [23] = GetTag("jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion"),

        -- grenades --
        [24] = GetTag("jpt!", "weapons\\frag grenade\\explosion"),
        [25] = GetTag("jpt!", "weapons\\plasma grenade\\attached"),
        [26] = GetTag("jpt!", "weapons\\plasma grenade\\explosion"),

        melee = {
            -- weapon melee --
            [1] = GetTag("jpt!", "weapons\\flag\\melee"),
            [2] = GetTag("jpt!", "weapons\\ball\\melee"),
            [3] = GetTag("jpt!", "weapons\\pistol\\melee"),
            [4] = GetTag("jpt!", "weapons\\needler\\melee"),
            [5] = GetTag("jpt!", "weapons\\shotgun\\melee"),
            [6] = GetTag("jpt!", "weapons\\flamethrower\\melee"),
            [7] = GetTag("jpt!", "weapons\\sniper rifle\\melee"),
            [8] = GetTag("jpt!", "weapons\\plasma rifle\\melee"),
            [9] = GetTag("jpt!", "weapons\\plasma pistol\\melee"),
            [10] = GetTag("jpt!", "weapons\\assault rifle\\melee"),
            [11] = GetTag("jpt!", "weapons\\rocket launcher\\melee"),
            [12] = GetTag("jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_melee"),
        },
    }
end

function GetTag(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function getXYZ(PlayerIndex, PlayerObject)
    local coords, x, y, z = { }
    if player_alive(PlayerIndex) then
        local VehicleID = read_dword(PlayerObject + 0x11C)        
        if (VehicleID == 0xFFFFFFFF) then
            coords.invehicle = false
            x, y, z = read_vector3d(PlayerObject + 0x5c)
        else
            coords.seat = tonumber(read_word(PlayerObject + 0x2F0))
            coords.invehicle = true
            x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
        end
        coords.x, coords.y, coords.z = x, y, z
    end
    return coords
end

function OnScriptUnload()

end

function report()
    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. format("%0.2f", script_version), 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)
end

function OnError()
    cprint(debug.traceback(), 4 + 8)
    timer(50, "report")
end

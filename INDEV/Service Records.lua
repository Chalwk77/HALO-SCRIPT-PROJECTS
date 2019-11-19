--[[
--=====================================================================================================--
Script Name: Service Records, for SAPP (PC & CE)
Description: N/A

IN DEVELOPMENT -> IN DEVELOPMENT -> IN DEVELOPMENT -> IN DEVELOPMENT

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

api_version = "1.12.0.0"
local players = {}

-- Configuration Starts --
local path = "sapp\\playerdata.json"

local function FormatTable(params)
    local structure = {
        [params.ip] = {
            id = params.id,
            name = params.name,
            hash = params.hash,
            rank = params.rank or "Recruit",
            credits = params.credits or 0,
            credits_until_next_rank = params.credits_until_next_rank or 7500,
            stats = {
                kills = params.kills or 0,
                deaths = params.deaths or 0,
                assists = params.assists or 0,
                betrays = params.betrays or 0,
                suicides = params.suicides or 0,
                joins = params.joins or 0,
                krd = params.kdr or 0,
                games_played = params.games_played or 0,
                distance_traveled = params.distance_traveled or 0,
            },
            sprees = {
                double_kill = params.double_kill or 0,
                triple_kill = params.triple_kill or 0,
                overkill = params.overkill or 0,
                killtacular = params.killtacular or 0,
                killtrocity = params.killtrocity or 0,
                killimanjaro = params.killimanjaro or 0,
                killtastrophe = params.killtastrophe or 0,
                killpocalypse = params.killpocalypse or 0,
                killionaire = params.killionaire or 0,
                kiling_spree = params.kiling_spree or 0,
                killing_frenzy = params.killing_frenzy or 0,
                running_riot = params.running_riot or 0,
                rampage = params.rampage or 0,
                untouchable = params.untouchable or 0,
                invincible = params.invincible or 0,
                anomgstopkillingme = params.anomgstopkillingme or 0,
            },
        }
    }
    return structure
end

local ranks = {
    ["Recruit"] = {
        [1] = 0,
    },
    ["Private"] = {
        [1] = 7500
    },
    ["Corporal"] = {
        [1] = 10000,
        [2] = 15000, -- grade 1
    },
    ["Sergeant"] = {
        [1] = 20000,
        [2] = 26250, -- grade 1
        [3] = 32500, -- grade 2
    },
    ["Warrant Officer"] = {
        [1] = 45000,
        [2] = 78000, -- grade 1
        [3] = 111000, -- grade 2
        [4] = 144000, -- grade 3
    },
    ["Captain"] = {
        [1] = 210000,
        [2] = 233000, -- grade 1
        [3] = 256000, -- grade 2
        [4] = 279000, -- grade 3
    },
    ["Major"] = {
        [1] = 325000,
        [2] = 350000, -- grade 1
        [3] = 375000, -- grade 2
        [4] = 400000, -- grade 3
    },
    ["Lt. Colonel"] = {
        [1] = 450000,
        [2] = 480000, -- grade 1
        [3] = 510000, -- grade 2
        [4] = 540000, -- grade 3
    },
    ["Commander"] = {
        [1] = 600000,
        [2] = 650000, -- grade 1
        [3] = 700000, -- grade 2
        [4] = 750000, -- grade 3
    },
    ["Colonel"] = {
        [1] = 850000,
        [2] = 960000, -- grade 1
        [3] = 1070000, -- grade 2
        [4] = 1180000, -- grade 3
    },
    ["Brigadier"] = {
        [1] = 1400000,
        [2] = 1520000, -- grade 1
        [3] = 1640000, -- grade 2
        [4] = 1760000, -- grade 3
    },
    ["General"] = {
        [1] = 2000000,
        [2] = 2200000, -- grade 1
        [3] = 2350000, -- grade 2
        [4] = 2500000, -- grade 3
        [5] = 2650000, -- grade 4
    },
    ["Field Marshall"] = {
        [1] = 3000000
    },
    ["Hero"] = {
        [1] = 3700000
    },
    ["Legend"] = {
        [1] = 4600000
    },
    ["Mythic"] = {
        [1] = 5650000
    },
    ["Noble"] = {
        [1] = 7000000
    },
    ["Eclipse"] = {
        [1] = 8500000
    },
    ["Nova"] = {
        [1] = 11000000
    },
    ["Forerunner"] = {
        [1] = 13000000
    },
    ["Reclaimer"] = {
        [1] = 16500000
    },
    ["Inheritor"] = {
        [1] = 20000000
    },
}

-- Configuration Ends --

local json = (loadfile "json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
    register_callback(cb['EVENT_GAME_START'], 'OnGameStart')
    if (get_var(0, "$gt") ~= "n/a") then
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                local ip = get_var(i, "$ip"):match('(%d+.%d+.%d+.%d+)')
                players[i] = { ip = ip, stats = GetStats(ip) }
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        players = {}
    end
end

function OnPlayerConnect(PlayerIndex)

    local ip = get_var(PlayerIndex, "$ip"):match('(%d+.%d+.%d+.%d+)')
    players[PlayerIndex] = { ip = ip, stats = nil }

    if (not GetStats(ip)) then
        local params = {}
        params.id = tonumber(PlayerIndex)
        params.name = get_var(PlayerIndex, "$name")
        params.hash = get_var(PlayerIndex, "$hash")
        params.ip = ip
        local file = assert(io.open(path, "a+"))
        if (file) then
            file:write(json:encode_pretty(FormatTable(params)))
            io.close(file)
        end
    end

    players[PlayerIndex].stats = GetStats(ip)
end

function OnPlayerDeath(PlayerIndex, KillerIndex)

    local killer = tonumber(KillerIndex)
    local victim = tonumber(PlayerIndex)

    local k, v = players[killer], players[vicitm]
    print(k, v)

    if (killer > 0) then
        if (killer == victim and k) then
            v.stats.suicides = v.stats.suicides + 1
            UpdateStats(PlayerIndex)
        end
    end
end

function UpdateStats(PlayerIndex)
    local stats = GetStats()
    local Tab = players[PlayerIndex]

    if (stats) then
        for k, v in pairs(stats) do
            if (k == Tab.ip) then
                v = Tab.stats
                local file = assert(io.open(path, "w"))
                if (file) then
                    file:write(json:encode_pretty(stats))
                    io.close(file)
                end
                break
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
        if (stats and ip) then
            stats = stats[ip]
        end
        io.close(file)
    end
    return stats
end

function OnScriptUnload()

end


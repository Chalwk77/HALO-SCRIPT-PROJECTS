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

-- Configuration Starts --
local path = "sapp\\playerdata.json"

local function FormatTable(params) 
    local structure = {
        [params.ip] = {
            id = params.id,
            name = params.name,
            hash = params.hash,
            rank = params.rank or "Private",
            stats = {
                kills = params.kills or 0,
                deaths = params.deaths or 0,
                assists = params.assists or 0,
                betrays = params.betrays or 0,
                suicides = params.suicides or 0,
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
            medals = {},
            weapons = {},
        }
    }
    return structure
end

-- Configuration Ends --

local json = (loadfile "json.lua")()

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
end

function OnPlayerConnect(PlayerIndex)
 
    local params = {}
    params.id = tonumber(PlayerIndex)
    params.name = get_var(PlayerIndex, "$name")
    params.hash = get_var(PlayerIndex, "$hash")
    params.ip = get_var(PlayerIndex, "$ip"):match('(%d+.%d+.%d+.%d+)')
    
    local stats = GetStats(params)
    
    if (not stats) then
        params.new_entry = true
        UpdateStats(params)
    else
        params.rank = "Other Rank" -- test
        UpdateStats(params)
    end    
end

function UpdateStats(params)
    if (not params.new_entry) then
    
        -- copy:
        local stats = nil
        local file = io.open(path,"r")
        if (file ~= nil) then
            local data = file:read("*all")
            stats = json:decode(data)
            io.close(file)
        end
        
        -- update:
        if (stats) then
            
            -- test
            for k,v in pairs(stats) do
                if (k == params.ip) then
                    v.rank = params.rank
                end
            end
            --
        
            local file = assert(io.open(path, "r+"))
            if (file) then
                file:write(json:encode_pretty(stats))
                io.close(file)
            end
        end
    else
        local file = assert(io.open(path, "a+"))
        if (file) then
            file:write(json:encode_pretty(FormatTable(params)))
            io.close(file)
        end
    end
end

function GetStats(params)
    local stats = nil
    local file = io.open(path,"r")
    if (file ~= nil) then
        local data = file:read("*all")
        stats = json:decode(data)
        if (stats) then
            stats = stats[params.ip]
        end
        io.close(file)
    end
    return stats
end

function OnScriptUnload()

end


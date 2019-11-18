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

    UpdateStats(params)
end

function UpdateStats(params)
    local stats = GetStats(params)
    if (stats) then
        for IP,Tab in pairs(stats) do 
            if (IP == params.ip) then
                for k1,v1 in pairs(Tab) do
                    for k2,v2 in pairs(params) do
                        if (k1 == k2) then
                            if (type(k1) == "string") then
                                Tab[k1] = params[k2]
                            -- elseif (type(k1) == "table") then
                                -- for i = 1,#k1 do
                                    -- for j = 1,#params[k2] do
                                        -- Tab[k1][i] = params[k2][j]
                                    -- end
                                -- end
                            end
                        end
                    end
                end
            end
        end
        local file = assert(io.open(path, "r+"))
        if (file) then
            file:write(json:encode_pretty(stats))
            io.close(file)
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
        io.close(file)
    end
    return stats
end

function OnScriptUnload()

end


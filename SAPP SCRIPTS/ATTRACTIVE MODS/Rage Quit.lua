--[[
--=====================================================================================================--
Script Name: Rage Quit, for SAPP (PC & CE)
Description: Announces a simple message when someone rage quits.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local RageQuit = {

    -- A player is considered raging if they quit
    -- before the grace period lapses after being killed:
    grace = 10,

    -- Message output when a player rage quits:
    message = '$name rage quit because of $killer'
}

local time = os.time
local players = {}

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], 'OnDie')
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
end

local function GetIP(Ply)
    return get_var(Ply, '$ip')
end

function RageQuit:NewPlayer(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

function OnJoin(Ply)
    players[GetIP(Ply)] = RageQuit:NewPlayer({
        pid = Ply,
        name = get_var(Ply, '$name')
    })
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        players = { }
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnTick()
    for ip, v in pairs(players) do
        if (v.killer) then
            if (v.finish - v.start() == 0) then
                v.start, v.finish = nil, nil
            elseif (not player_present(v.pid)) then
                local str = v.message
                str = str:gsub('$name', v.name):gsub('$killer', v.killer.name)
                say_all(str)
                players[ip] = nil
            end
        elseif (not player_present(v.pid)) then
            players[ip] = nil
        end
    end
end

function OnDie(Victim, Killer)
    local victim = tonumber(Victim)
    local killer = tonumber(Killer)
    if (killer > 0 and killer ~= victim) then
        local v = players[GetIP(victim)]
        local k = players[GetIP(killer)]
        if (v and k) then
            v.killer = k
            v.start = time
            v.finish = time() + v.grace
        end
    end
end

function OnScriptUnload()
    -- N/A
end
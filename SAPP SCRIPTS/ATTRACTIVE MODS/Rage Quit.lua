--[[
--====================================================================--
Script Name: Rage Quit, for SAPP (PC & CE)
Description: Announces a simple message when someone rage quits.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--====================================================================--
]]--

-- config starts --

-- A player is considered raging if they quit
-- before the grace period lapses after being killed:
--
local grace = 5

-- Message output when a player rage quits:
--
local output = '$name rage quit because of $killer'

-- config ends --

local time = os.time
local players = {}

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], 'OnDie')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

function OnJoin(Ply)
    players[Ply] = { pid = Ply, name = get_var(Ply, '$name') }
end

function OnQuit(Ply)
    local t = players[Ply]
    players[Ply] = nil
    if (t and t.killer) then
        if (t.finish - t.start() > 0) then
            local str = output
            str = str:gsub('$name', t.name):gsub('$killer', t.killer.name)
            say_all(str)
        end
    end
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

function OnDie(Victim, Killer)
    local victim = tonumber(Victim)
    local killer = tonumber(Killer)

    local v = players[victim]
    local k = players[killer]

    if (k and v and killer > 0 and killer ~= victim) then
        v.killer = players[killer]
        v.start = time
        v.finish = time() + grace
    end
end

function OnScriptUnload()
    -- N/A
end
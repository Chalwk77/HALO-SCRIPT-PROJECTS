--[[
--====================================================================--
Script Name: Rage Quit, for SAPP (PC & CE)
Description: Announces a simple message when someone rage quits. Detects both kill-related and general rage quits.

Copyright (c) 2022-2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--====================================================================--
]]--

-- Configuration starts --------------------------------------------------
local GRACE_PERIOD_AFTER_KILL = 10 -- in seconds
local GENERAL_RAGE_QUIT_PERIOD = 15 -- in seconds
-- Messages ---------------------------------------------------
local KILL_RAGE_QUIT_MESSAGE = '%s rage quit because of %s'
local GENERAL_RAGE_QUIT_MESSAGE = '%s rage quit!'
local SERVER_PREFIX = '**SAPP**'
-- Configuration ends ----------------------------------------------------

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'onJoin')
    register_callback(cb['EVENT_LEAVE'], 'onQuit')
    register_callback(cb['EVENT_DIE'], 'onDeath')
end

local players = {}

local function send(message, ...)
    execute_command('msg_prefix ""')
    cprint(string.format(message, ...))
    execute_command('msg_prefix "' .. SERVER_PREFIX .. '"')
end

function onJoin(id)
    local name = get_var(id, '$name')
    players[id] = {
        name = name,
        joined = os.time(),
    }
end

function onQuit(id)
    local t = players[id]
    if t then
        if t.killer and t.finish - t.joined > 0 then
            send(KILL_RAGE_QUIT_MESSAGE, t.name, t.killer.name)
        elseif t.joined + GENERAL_RAGE_QUIT_PERIOD > os.time() then
            send(GENERAL_RAGE_QUIT_MESSAGE, t.name)
        end
        players[id] = nil
    end
end

function onDeath(Victim, Killer)
    local victim, killer = tonumber(Victim), tonumber(Killer)

    if not (killer > 0 and killer ~= victim) then
        return
    end

    local v = players[victim]
    local k = players[killer]

    if not (v and k) then
        return
    end

    v.killer = k
    v.joined = os.time()
    v.finish = os.time() + GRACE_PERIOD_AFTER_KILL
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                onJoin(i)
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end
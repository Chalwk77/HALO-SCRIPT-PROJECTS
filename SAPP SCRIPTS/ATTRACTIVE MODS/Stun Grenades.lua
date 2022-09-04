--[[
--=====================================================================================================--
Script Name: Stun Grenades, for SAPP (PC & CE)
Description: Make frags and plasmas behave like stun grenades.

			 When someone is damaged by a grenade,
			 their speed is reduced to 0.5% for 5-10 seconds (depending on damage type).

			 Plasma explosion  = 5 seconds
			 Plasma sticky     = 10 seconds
			 Frag explosion    = 5 seconds

Copyright (c) 2019-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local tags = {

    -- format:
    -- {tag name, stun time, stun percent}
    { 'weapons\\frag grenade\\explosion', 5, 0.5 },
    { 'weapons\\plasma grenade\\explosion', 5, 0.5 },
    { 'weapons\\plasma grenade\\attached', 10, 0.5 },
}

api_version = '1.12.0.0'

local stuns = {}
local players = {}
local time = os.time

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamage")
    OnStart()
end

local function GetTag(Class, Name)
    local tag = lookup_tag(Class, Name)
    return (tag ~= 0 and read_dword(tag + 0xC) or 0)
end

local function TagsToID()
    local t = {}

    for i = 1, #tags do

        local v = tags[i]
        local name = v[1]
        local tag = GetTag('jpt!', name)

        if (tag ~= 0) then
            t[tag] = { v[2], v[3] }
        end
    end

    return t
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        players = { }
        stuns = TagsToID()
    end
end

function OnTick()
    for i, player in pairs(players) do
        if (i) and player_alive(i) then
            if (player.start() < player.finish) then
                execute_command('s ' .. i .. ' ' .. player.stun_percent)
            else
                execute_command('s ' .. i .. ' 1')
                players[i] = nil
            end
        elseif (i) and (not player_alive(i)) then
            players[i] = nil
        end
    end
end

function OnDamage(Victim, Killer, MetaID)

    local victim = tonumber(Victim)
    local killer = tonumber(Killer)

    local pvp = (killer > 0 and victim ~= killer)

    if (pvp and stuns[MetaID]) then

        local stun_time = stuns[MetaID][1]
        local stun_percent = stuns[MetaID][2]

        players[victim] = {
            start = time,
            finish = time() + stun_time,
            stun_percent = stun_percent,
        }
    end
end

function OnScriptUnload()
    -- N/A
end
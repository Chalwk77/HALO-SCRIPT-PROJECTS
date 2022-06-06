--[[
--=====================================================================================================--
Script Name: Block Team Damage, for SAPP (PC & CE)
Description: Prevent grenades/rocket launcher damage from killing teammates.

Designed in response to this post: https://opencarnage.net/index.php?/topic/8587-friendly-fire-desync/

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts:
local jpt_tags = { -- damage tag ids that will be blocked
    'weapons\\rocket launcher\\explosion',
    'weapons\\frag grenade\\explosion',
    'weapons\\plasma grenade\\attached',
    'weapons\\plasma grenade\\explosion',
}
-- config ends

api_version = "1.12.0.0"

local meta_ids = {}

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

-- Store meta id of each jpt! tag in a table (meta_ids) to avoid continuous calls to GetTag() (for performance reasons):
local function GetJPTTags()

    meta_ids = nil
    local t = {}

    for i = 1, #jpt_tags do
        local tag = GetTag('jpt!', jpt_tags[i])
        if (tag) then
            t[tag] = true
        end
    end

    meta_ids = t
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a' and get_var(0, '$ffa') == '0') then
        register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'BlockDamage')
        GetJPTTags()
        return
    end
    unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])
end

function BlockDamage(Victim, Killer, MapID)

    local killer = tonumber(Killer)
    local victim = tonumber(Victim)

    local v_team = get_var(victim, '$team')
    local k_team = get_var(killer, '$team')

    if (killer ~= victim and k_team == v_team and meta_ids[MapID]) then
        return false
    end

    return true
end

function OnScriptUnload()
    -- N/A
end
--[[
--=====================================================================================================--
Script Name: Block or Replace, for SAPP (PC & CE)
Description: Block or replace objects easily


Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local tags = {

    -- Replace Format:
    -- {tag path to replace, replacement tag path}

    -- Block format:
    -- {tag path to block}

    ["mode_name_here"] = {

        -- EXAMPLE BLOCK:
        { "eqip", "weapons\\frag grenade\\frag grenade" },

        -- EXAMPLE REPLACE:
        { "weap", "weapons\\assault rifle\\assault rifle", "weap", "weapons\\pistol\\pistol" },
        --
        -- repeat the structure to add more replace/block entries for this mode.
        --
    },

    -- repeat the structure to add more mode entries:
    ["mode_name_here"] = {

    }
}

api_version = "1.12.0.0"

local block, replace

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnStart")
    OnStart()
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return (Tag ~= 0 and read_dword(Tag + 0xC)) or nil
end

function OnStart()
    if (get_var(0, "$gt") ~= 'n/a') then

        block, replace = {}, {}

        local mode = get_var(0, "$mode")
        if (tags[mode]) then
            for i = 1, #tags[mode] do
                local t = tags[mode][i]
                if (#t > 2) then
                    replace[#replace + 1] = { GetTag(t[1], t[2]), GetTag(t[3], t[4]) }
                else
                    block[#block + 1] = GetTag(t[1], t[2])
                end
            end
            register_callback(cb['EVENT_OBJECT_SPAWN'], "ObjectHandler")
            return
        end
        unregister_callback(cb['EVENT_OBJECT_SPAWN'])
    end
end

function ObjectHandler(_, MapID)
    for i = 1, #block do
        if (MapID == block[i]) then
            return false
        end
    end
    for i = 1, #replace do
        if (MapID == replace[i][1]) then
            return true, replace[i][2]
        end
    end
end

function OnScriptUnload()
    -- N/A
end
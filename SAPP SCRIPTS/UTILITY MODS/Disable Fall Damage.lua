--[[
--=====================================================================================================--
Script Name: Disable Fall Damage, for SAPP (PC & CE)
Description: This mod will allow you to disable fall damage on a per-map basis.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local falldamage = { }
local mapname, gamestarted = nil, nil

function falldamage.Init()

    -- Configuration [starts] -----------------------------------------------------
    falldamage.maps = {
        -- (true = enabled, false = disabled):
        ["putput"] = false,
        ["wizard"] = false,
        ["longest"] = false,
        ["ratrace"] = false,
        ["carousel"] = false,
        ["infinity"] = false,
        ["chillout"] = false,
        ["prisoner"] = false,
        ["damnation"] = false,
        ["icefields"] = false,
        ["bloodgulch"] = false,
        ["hangemhigh"] = false,
        ["sidewinder"] = false,
        ["timberland"] = false,
        ["beavercreek"] = false,
        ["deathisland"] = false,
        ["dangercanyon"] = false,
        ["gephyrophobia"] = false,
        ["boardingaction"] = false,
    }
    -- Configuration [ends] -----------------------------------------------------

    -- Do not Touch:
    gamestarted = true
    mapname = get_var(1, "$map")

    falldamage.falling = GetTag("jpt!", "globals\\falling")
    falldamage.distalce = GetTag("jpt!", "globals\\distance")
end


function OnScriptLoad()

    -- Register needed Event Callbacks:
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")

    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")

    if (get_var(0, "$gt") ~= "n/a") then
        gamestarted = true
        mapname = get_var(1, "$map")
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        falldamage.Init()
    end
end

function OnGameEnd()
    gamestarted = false
end

function OnScriptUnload()
    -- Not Used...
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (gamestarted) then
        if (MetaID == falldamage.falling or MetaID == falldamage.distance) then
            if not falldamage.maps[mapname] then
                return true, 0
            end
        end
    end
end

-- Credits to Kavawuvi for this function:
function GetTag(tagclass, tagname)
    local tagarray = read_dword(0x40440000)
    for i = 0, read_word(0x4044000C) - 1 do
        local tag = tagarray + i * 0x20
        local class = string.reverse(string.sub(read_string(tag), 1, 4))
        if (class == tagclass) then
            if (read_string(read_dword(tag + 0x10)) == tagname) then
                return read_dword(tag + 0xC)
            end
        end
    end
    return nil
end

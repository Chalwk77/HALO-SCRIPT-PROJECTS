--[[
--=====================================================================================================--
Script Name: Disable Grenades, for SAPP (PC & CE)
Description: Simple script that will disable grenade assignments on a per-gamemode basis.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- config start:
local game_modes = {

    -- [Game Mode], false = Grenades Disabled, true = grenades enabled
    ["FFA SWAT"] = false,

    -- Repeat the structure to add more entries:
    ["game mode here"] = false,
}
-- config ends

local disabled
local function DisableGrenades()
    if (get_var(0, '$gt') ~= 'n/a') then
        local mode = get_var(0, "$mode")
        for k, enabled in pairs(game_modes) do
            if (mode == k) and (not enabled) then
                return true
            end
        end
    end
    return false
end

function OnScriptLoad()
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    disabled = DisableGrenades()
end

function OnGameStart()
    disabled = DisableGrenades()
end

function OnPlayerSpawn(Ply)
    if (disabled) then
        local DyN = get_dynamic_player(Ply)
        if (DyN ~= 0) then
            write_word(DyN + 0x31E, 0)
            write_word(DyN + 0x31F, 0)
        end
    end
end
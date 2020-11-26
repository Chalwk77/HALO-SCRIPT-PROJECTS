--[[
--=====================================================================================================--
Script Name: Disable Grenades, for SAPP (PC & CE)
Description: This script will prevent players from spawning with grenades (on per game mode basis).
             Note: This does not prevent players from picking them up.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- config start:
local game_modes = {
    -- Simply list all of the game modes you want this script to disable grenades on.
    "FFA Swat",
    "put game mode here",
}
-- config ends

local function DisableGrenades()
    if (get_var(0, '$gt') ~= 'n/a') then
        local current_mode = string.lower(get_var(0, "$mode"))
        for _, mode in pairs(game_modes) do
            if (current_mode == string.lower(mode)) then
                register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
                return true
            end
        end
    end
    unregister_callback(cb["EVENT_SPAWN"])
    return false
end

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    DisableGrenades()
end

function OnGameStart()
    DisableGrenades()
end

function OnPlayerSpawn(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        write_word(DyN + 0x31E, 0)
        write_word(DyN + 0x31F, 0)
    end
end
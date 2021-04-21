--[[
--=====================================================================================================--
Script Name: Disable Fall Damage, for SAPP (PC & CE)
Description: This script will allow you to disable fall damage on a per-map-per-game mode basis.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local FallDamage = {
    maps = {
        -- Configuration [starts] -----------------------------------------------------
        -- {map enabled/disabled}, {game mode 1, game mode 2 ...}

        -- true = prevent damage
        -- false = allow damage

        ["putput"] = { true, { "game_mode_here"} },
        ["wizard"] = { true, { "game_mode_here"} },
        ["longest"] = { true, { "game_mode_here"} },
        ["ratrace"] = { true, { "game_mode_here"} },
        ["carousel"] = { true, { "game_mode_here"} },
        ["infinity"] = { true, { "game_mode_here"} },
        ["chillout"] = { true, { "game_mode_here"} },
        ["prisoner"] = { true, { "game_mode_here"} },
        ["damnation"] = { true, { "game_mode_here"} },
        ["icefields"] = { true, { "game_mode_here"} },
        ["bloodgulch"] = { true, { "game_mode_here"} },
        ["hangemhigh"] = { true, { "game_mode_here"} },
        ["sidewinder"] = { true, { "game_mode_here"} },
        ["timberland"] = { true, { "game_mode_here"} },
        ["beavercreek"] = { true, { "game_mode_here"} },
        ["deathisland"] = { true, { "game_mode_here"} },
        ["dangercanyon"] = { true, { "game_mode_here"} },
        ["gephyrophobia"] = { true, { "game_mode_here"} },
        ["boardingaction"] = { true, { "game_mode_here"} }
        -- Configuration [ends] -----------------------------------------------------
    }
}

local lower = string.lower

function FallDamage:Init()
    if (get_var(0, "$gt") ~= "n/a") then
        execute_command("cheat_jetpack false")
        local map = get_var(0, "$map")
        if (self.maps[map] and self.maps[map][1]) then
            local cur_mode = lower(get_var(0, "$mode"))
            for _, mode in pairs(self.maps[map][2]) do
                if (cur_mode == lower(mode)) then
                    execute_command("cheat_jetpack true")
                end
            end
        end
    end
end

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    FallDamage:Init()
end

function OnGameStart()
    FallDamage:Init()
end

function OnScriptUnload()
    -- N/A
end
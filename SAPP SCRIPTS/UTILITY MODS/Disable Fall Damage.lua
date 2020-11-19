--[[
--=====================================================================================================--
Script Name: Disable Fall Damage, for SAPP (PC & CE)
Description: This mod will allow you to disable fall damage on a per-map, per-gamemode basis.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local FallDamage = { }
local lower = string.lower
function FallDamage:Init()

    if (get_var(0, "$gt") ~= "n/a") then

        -- Configuration [starts] -----------------------------------------------------
        self.maps = {

            -- {map enabled/disabled}, {game mode 1, game mode 2 ...}

            ["putput"] = { true, { "rocketz", "ffa shottys" } },
            ["wizard"] = { true, { "rocketz", "ffa shottys", "FFA SWAT" } },
            ["longest"] = { true, { "rocketz", "ffa shottys" } },
            ["ratrace"] = { true, { "rocketz", "ffa shottys" } },
            ["carousel"] = { true, { "rocketz", "ffa shottys" } },
            ["infinity"] = { true, { "rocketz", "ffa shottys" } },
            ["chillout"] = { true, { "rocketz", "ffa shottys", "FFA SWAT" } },
            ["prisoner"] = { true, { "rocketz", "ffa shottys", "FFA SWAT" } },
            ["damnation"] = { true, { "rocketz", "ffa shottys" } },
            ["icefields"] = { true, { "rocketz", "ffa shottys" } },
            ["bloodgulch"] = { true, { "rocketz", "ffa shottys" } },
            ["hangemhigh"] = { true, { "rocketz", "ffa shottys" } },
            ["sidewinder"] = { true, { "rocketz", "ffa shottys" } },
            ["timberland"] = { true, { "rocketz", "ffa shottys" } },
            ["beavercreek"] = { true, { "rocketz", "ffa shottys", "FFA SWAT" } },
            ["deathisland"] = { true, { "rocketz", "ffa shottys" } },
            ["dangercanyon"] = { true, { "rocketz", "ffa shottys" } },
            ["gephyrophobia"] = { true, { "rocketz", "ffa shottys" } },
            ["boardingaction"] = { true, { "rocketz", "ffa shottys" } },
        }
        -- Configuration [ends] -----------------------------------------------------

        local map = get_var(0, "$map")
        if (self.maps[map] and self.maps[map][1]) then
            local cur_gammode = get_var(0, "$mode")
            for _, gamemode in pairs(self.maps[map][2]) do
                if (lower(cur_gammode) == lower(gamemode)) then
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
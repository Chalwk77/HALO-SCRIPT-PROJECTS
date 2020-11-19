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

api_version = \"1.12.0.0\"

local FallDamage = { }
local lower = string.lower
function FallDamage:Init()

    if (get_var(0, \"$gt\") ~= \"n/a\") then

        -- Configuration [starts] -----------------------------------------------------
        self.maps = {

            -- {map enabled/disabled}, {game mode 1, gamemode 2 ...}

            [\"putput\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"wizard\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"longest\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"ratrace\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"carousel\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"infinity\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"chillout\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"prisoner\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"damnation\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"icefields\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"bloodgulch\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"hangemhigh\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"sidewinder\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"timberland\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"beavercreek\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"deathisland\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"dangercanyon\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"gephyrophobia\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
            [\"boardingaction\"] = { true, { \"Loadout-SlayerFFA\", \"ffa shottys\" } },
        }
        -- Configuration [ends] -----------------------------------------------------

        local map = get_var(0, \"$map\")
        if (self.maps[map] and self.maps[map][1]) then
            local cur_gammode = get_var(0, \"$mode\")
            for _, gamemode in pairs(self.maps[map][2]) do
                if (lower(cur_gammode) == lower(gamemode)) then
					execute_command(\"cheat_jetpack true\")
                end
            end
        end
    end
end

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], \"OnGameStart\")
    FallDamage:Init()
end

function OnGameStart()
    FallDamage:Init()
end

function OnScriptUnload()
    -- N/A
end
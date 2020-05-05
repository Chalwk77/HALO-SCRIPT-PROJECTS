--[[
--=====================================================================================================--
Script Name: Script Manager (beta v1.0), for SAPP (PC & CE)
Description: This mod will handle script loading and unloading.
             You can specify on a per-map/per-gamemode basis what scripts are loaded.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local manager = { }
-- ======================= CONFIGURATION STARTS ======================= --
manager.settings = {
    -- In the below example, two scripts (called "LNZ_AA" & "LNZ_AB") are loaded when the gamemode is
    -- any of the following gametypes: "lnz-Tslayer", "lnz-CTF", "lnz-FFA", "lnz-Classic"
    ["MapName"] = {
        use = true, -- set to false to prevent scripts from loading on this map
        {
            -- Script Names (not case sensitive):
            "LNZ_AA",
            "LNZ_AB",
        },
        -- Game Modes (case sensitive):
        "lnz-Tslayer",
        "lnz-CTF",
        "lnz-FFA",
        "lnz-Classic-KOTH",
    },
    -- If the current gamemode in play is not specified in the list of available gamemodes for that map as seen above,
    -- the script will not be loaded.

    --
    --==================================================================--
    -- Stock maps and stock gametypes:
    --==================================================================--
    ["chillout"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["sidewinder"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["ratrace"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["bloodgulch"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["beavercreek"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["boardingaction"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["carousel"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["dangercanyon"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["deathisland"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["gephyrophobia"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["icefields"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["infinity"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["timberland"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["hangemhigh"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["damnation"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["putput"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["prisoner"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["wizard"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    ["longest"] = {
        use = true,
        { -- Scripts:
            "",
        }, -- Game Modes:
        "",
    },
    -- Repeat the structure to add custom maps.
}
-- ======================= CONFIGURATION ENDS ======================= --

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    if (get_var(0, "$gt") ~= "n/a") then
        manager:Handle("load")
    end
end

function OnScriptUnload()
    manager:Handle("unload")
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        manager:Handle("load")
    end
end

function manager:Handle(state)
    local current_map, mode = get_var(0, "$map"), get_var(0, "$mode")

    local scripts, modes = {}

    for map, _ in pairs(manager.settings) do
        if (map == current_map and manager.settings[map].use) then
            for _, data in pairs(manager.settings[map]) do
                if (data ~= "" and data ~= nil) then
                    if (type(data) == 'table') then
                        for i = 1, #data do
                            if (data[i] ~= "" or data[i] ~= nil) then
                                scripts[#scripts + 1] = data[i]
                            end
                        end
                    end
                    if (#scripts > 0) then
                        if (type(data) == 'string' and data == mode) then
                            for i = 1, #scripts do
                                if (state == "load") then
                                    manager:LoadScript(scripts[i])
                                else
                                    manager:UnloadScript(scripts[i])
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function manager:LoadScript(script)
    cprint("[Script Manager] Loading Script: " .. script, 2 + 8)
    execute_command('lua_load ' .. ' "' .. script .. '"')
end

function manager:UnloadScript(script)
    cprint("[Script Manager] Unloading Script: " .. script, 2 + 8)
    execute_command('lua_unload ' .. ' "' .. script .. '"')
end

-- For a future update:
return manager

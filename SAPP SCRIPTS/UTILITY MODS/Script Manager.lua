--[[
--=====================================================================================================--
Script Name: Script Manager (v1.2), for SAPP (PC & CE)
Description: This utility mod will enable you to load scripts on a per map, per game mode basis.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local ScriptManager = {
    --
    --==================================================================--
    -- Stock maps:
    --==================================================================--
    --
    -- Script names are separated by commas and must be encapsulated
    -- in double quotes.
    --

    -- Example Usage:
    --["mapname"] = {
    --    ["FFA Swat"] = { "No Grenades", "No Fall Damage", "Another Script" },
    --    ["another game mode"] = { "some script", "another script" },
    --},

    maps = {
        ["chillout"] = {
            ["gamemode_here"] = { "script name here" },
        },
        ["sidewinder"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["ratrace"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["bloodgulch"] = {
            ["LNZ-OITC"] = { "Market" }
        },
        ["beavercreek"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["boardingaction"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["carousel"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["dangercanyon"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["deathisland"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["gephyrophobia"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["icefields"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["infinity"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["timberland"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["hangemhigh"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["damnation"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["putput"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["prisoner"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["wizard"] = {
            ["gamemode_here"] = { "script name here" }
        },
        ["longest"] = {
            ["gamemode_here"] = { "script name here" }
        }
    },

    -- DO NOT TOUCH --
    loaded = { }
}
-- ======================= CONFIGURATION ENDS ======================= --

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    ScriptManager:Init()
end

function OnStart()
    ScriptManager:Init()
end

function ScriptManager:Init()
    if (get_var(0, '$gt') ~= 'n/a') then
        local scripts = { }
        local map, mode = get_var(0, '$map'), get_var(0, '$mode')
        for a, b in pairs(self.maps[map] or {}) do
            if (a == mode) then
                for _, script in pairs(b) do
                    if (script and script ~= '') then
                        scripts[#scripts + 1] = script
                        if (not self.loaded[script]) then
                            self.loaded[script] = true
                        end
                    end
                end
            end
        end
        self:DetermineState(scripts)
    end
end

function ScriptManager:DetermineState(ScriptsToLoad)
    for LoadedScript, Load in pairs(self.loaded) do
        local unload = true
        for _, Script in pairs(ScriptsToLoad or {}) do
            if (LoadedScript == Script) then
                unload = false
                if (Load) then
                    Load = false
                    self:Load(Script)
                end
            end
        end
        if (unload) then
            self.loaded[LoadedScript] = nil
            self:Unload(LoadedScript)
        end
    end
end

function ScriptManager:Load(script)
    cprint("[Script Manager] Loading Script: " .. script, 10)
    execute_command('lua_load' .. ' "' .. script .. '"')
end

function ScriptManager:Unload(script)
    cprint("[Script Manager] Unloading Script: " .. script, 10)
    execute_command('lua_unload' .. ' "' .. script .. '"')
end

function OnScriptUnload()
    -- N/A
end
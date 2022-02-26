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
            ["gamemode_here"] = { "script_name_here" },
        },
        ["sidewinder"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["ratrace"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["bloodgulch"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["beavercreek"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["boardingaction"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["carousel"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["dangercanyon"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["deathisland"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["gephyrophobia"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["icefields"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["infinity"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["timberland"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["hangemhigh"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["damnation"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["putput"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["prisoner"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["wizard"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        ["longest"] = {
            ["gamemode_here"] = { "script_name_here" }
        },
        --
        -- repeat the structure to add more configurations:
        --
    },

    -- do not touch --
    loaded = { }
    --
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
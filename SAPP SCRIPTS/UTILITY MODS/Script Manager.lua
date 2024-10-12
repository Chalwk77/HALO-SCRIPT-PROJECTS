--[[
--=====================================================================================================--
Script Name: Script Manager, for SAPP (PC & CE)
Description: This script automatically loads scripts based on the current map and game mode.

Copyright (c) 2024, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

local ScriptManager = {
    maps = {
        -- Example Usage:
        -- ['map_name'] = {
        --     ['game_mode'] = { 'script1', 'script2' },
        -- },
        ['bloodgulch'] = { ['LNZ-DAC'] = { 'Notify Me' } },
        -- Add more maps and game modes as needed...
    },

    -- Internal tracking, do not touch:
    loaded = {},
    scripts = {},
}

-- Initialize the script manager
function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], 'OnGameStart')
    cprint("[Script Manager] Initialized.")
end

-- Load scripts based on current map and game mode
function OnGameStart()
    local gameType = get_var(0, '$gt')

    if gameType ~= 'n/a' then
        local map = get_var(0, '$map')
        local mode = get_var(0, '$mode')

        ScriptManager:LoadScriptsForMapAndMode(map, mode)
        ScriptManager:UnloadUnusedScripts()
    end
end

-- Load scripts for the specified map and mode
function ScriptManager:LoadScriptsForMapAndMode(map, mode)
    local gameScripts = self.maps[map] and self.maps[map][mode]

    if gameScripts then
        for _, script in ipairs(gameScripts) do
            if not self.loaded[script] then
                self:LoadScript(script)
            end
        end
    else
        cprint("[Script Manager] No scripts found for " .. map .. " in mode " .. mode)
    end
end

-- Unload scripts that are no longer needed
function ScriptManager:UnloadUnusedScripts()
    for script, _ in pairs(self.loaded) do
        if not self.scripts[script] then
            self:UnloadScript(script)
        end
    end
end

-- Load a specified script
function ScriptManager:LoadScript(script)
    local success, err = pcall(function()
        self.loaded[script] = true
        self.scripts[script] = true
        cprint('[Script Manager] Loading Script: ' .. script)
        execute_command('lua_load "' .. script .. '"')
    end)

    if not success then
        cprint('[Script Manager] Error loading script: ' .. script .. ' - ' .. err)
    end
end

-- Unload a specified script
function ScriptManager:UnloadScript(script)
    local success, err = pcall(function()
        self.loaded[script] = nil
        cprint('[Script Manager] Unloading Script: ' .. script)
        execute_command('lua_unload "' .. script .. '"')
    end)

    if not success then
        cprint('[Script Manager] Error unloading script: ' .. script .. ' - ' .. err)
    end
end

function OnScriptUnload()
    -- Clean up any loaded scripts if needed
    for script, _ in pairs(ScriptManager.loaded) do
        ScriptManager:UnloadScript(script)
    end
    cprint("[Script Manager] Unloaded all scripts.")
end

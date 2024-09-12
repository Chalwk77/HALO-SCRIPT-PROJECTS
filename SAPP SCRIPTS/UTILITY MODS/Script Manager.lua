--[[
--=====================================================================================================--
Script Name: Script Manager, for SAPP (PC & CE)
Description: This script automatically loads scripts on a per map, per mode basis.

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
        --     ['FFA Swat'] = { 'No Grenades', 'No Fall Damage', 'Another Script' },
        --     ['another game mode'] = { 'some script', 'another script' },
        -- },
        ['bloodgulch'] = { ['Race'] = {"Notify Me"} },
        ['chillout'] = { ['game_mode_here'] = {} },
        ['sidewinder'] = { ['game_mode_here'] = {} },
        ['ratrace'] = { ['game_mode_here'] = {} },
        ['beavercreek'] = { ['game_mode_here'] = {} },
        ['boardingaction'] = { ['game_mode_here'] = {} },
        ['carousel'] = { ['game_mode_here'] = {} },
        ['dangercanyon'] = { ['game_mode_here'] = {} },
        ['deathisland'] = { ['game_mode_here'] = {} },
        ['gephyrophobia'] = { ['game_mode_here'] = {} },
        ['icefields'] = { ['game_mode_here'] = {} },
        ['infinity'] = { ['game_mode_here'] = {} },
        ['timberland'] = { ['game_mode_here'] = {} },
        ['hangemhigh'] = { ['game_mode_here'] = {} },
        ['damnation'] = { ['game_mode_here'] = {} },
        ['putput'] = { ['game_mode_here'] = {} },
        ['prisoner'] = { ['game_mode_here'] = {} },
        ['wizard'] = { ['game_mode_here'] = {} },
        ['longest'] = { ['game_mode_here'] = {} },
    },

    -- Do not touch the following:
    loaded = {},
    scripts = {}
}

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
end

function OnStart()
    if get_var(0, '$gt') ~= 'n/a' then

        local SM = ScriptManager
        SM.scripts = {}

        local map = get_var(0, '$map')
        local mode = get_var(0, '$mode')
        local game_scripts = SM.maps[map] and SM.maps[map][mode]

        if game_scripts then
            for _, script in ipairs(game_scripts) do
                if not SM.loaded[script] then
                    SM:LoadScript(script)
                end
            end
        end

        for script, _ in pairs(SM.loaded) do
            if not SM.scripts[script] then
                SM:UnloadScript(script)
            end
        end
    end
end

function ScriptManager:LoadScript(script)
    self.loaded[script], self.scripts[script] = true, true
    cprint('[Script Manager] Loading Script: ' .. script)
    execute_command('lua_load "' .. script .. '"')
end

function ScriptManager:UnloadScript(script)
    self.loaded[script] = nil
    cprint('[Script Manager] Unloading Script: ' .. script)
    execute_command('lua_unload "' .. script .. '"')
end

function OnScriptUnload()
    -- N/A
end
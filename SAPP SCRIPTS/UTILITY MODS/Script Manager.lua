--[[
--=====================================================================================================--
Script Name: Script Manager, for SAPP (PC & CE)
Description: This script automatically loads scripts on a per-map, per-gametype basis.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = '1.12.0.0'

local ScriptManager = {

    -------------------
    -- config starts --
    -------------------

    --
    -- Script names must be comma separated in double/single quotes.
    -- However, they are not case-sensitive.
    --

    maps = {

        --
        -- Example Usage:
        --
        ['map_name'] = {
            ['FFA Swat'] = { 'No Grenades', 'No Fall Damage', 'Another Script' },
            ['another game mode'] = { 'some script', 'another script' },
        },

        ['bloodgulch'] = {
            ['Sabotage'] = { 'Attrition' }
        },

        ['chillout'] = {
            ['game_mode_here'] = { },
        },

        ['sidewinder'] = {
            ['game_mode_here'] = { }
        },

        ['ratrace'] = {
            ['Sabotage'] = { 'Attrition' }
        },

        ['beavercreek'] = {
            ['game_mode_here'] = {}
        },

        ['boardingaction'] = {
            ['game_mode_here'] = {}
        },

        ['carousel'] = {
            ['game_mode_here'] = {}
        },

        ['dangercanyon'] = {
            ['game_mode_here'] = {}
        },

        ['deathisland'] = {
            ['game_mode_here'] = {}
        },

        ['gephyrophobia'] = {
            ['game_mode_here'] = {}
        },

        ['icefields'] = {
            ['game_mode_here'] = {}
        },

        ['infinity'] = {
            ['game_mode_here'] = {}
        },

        ['timberland'] = {
            ['game_mode_here'] = {}
        },

        ['hangemhigh'] = {
            ['game_mode_here'] = {}
        },

        ['damnation'] = {
            ['game_mode_here'] = {}
        },

        ['putput'] = {
            ['game_mode_here'] = {}
        },

        ['prisoner'] = {
            ['game_mode_here'] = {}
        },

        ['wizard'] = {
            ['game_mode_here'] = {}
        },

        ['longest'] = {
            ['game_mode_here'] = {}
        },

        --
        -- repeat the structure to add more entries.
        --
    }

    -----------------
    -- config ends --
    -----------------
}

local loaded, scripts = {}, {}

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

local function Load(script)
    loaded[script], scripts[script] = true, true
    cprint('[Script Manager] Loading Script: ' .. script)
    execute_command('lua_load "' .. script .. '"')
end

local function Unload(script)
    loaded[script] = nil
    cprint('[Script Manager] Unloading Script: ' .. script)
    execute_command('lua_unload "' .. script .. '"')
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        scripts = { }

        local map = get_var(0, '$map')
        local mode = get_var(0, '$mode')

        -- Load scripts for the current map & mode:
        local settings = ScriptManager.maps[map]
        local game_scripts = (settings and settings[mode])

        -- Load scripts:
        if (game_scripts) then
            for i = 1, #game_scripts do
                local script = game_scripts[i]
                if (not loaded[script]) then
                    Load(script)
                end
            end
        end

        -- unload scripts that are no longer needed:
        for Script, _ in pairs(loaded) do
            if (not scripts[Script]) then
                Unload(Script)
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end
--[[
--=====================================================================================================--
Script Name: Mapcycle Manager, for SAPP (PC & CE)
Description:

    The Mapcycle Manager script enables server administrators to manage map rotations efficiently and
    facilitates seamless switching between classic and custom map rotations using simple commands.

    Upon loading, the script initializes with a predefined set of classic maps and their corresponding
    game types and placeholders for custom maps. Administrators can easily switch between five modes:

    - Classic Mode: Loads a predefined rotation of classic Halo maps.
    - Custom Mode: Loads a rotation of user-defined custom maps.
    - Small Mode: Loads a rotation of small maps.
    - Medium Mode: Loads a rotation of medium maps.
    - Large Mode: Loads a rotation of large maps.

    The commands for toggling the map cycles are simple and can be issued by admins:

    - /custom:                            Set the map cycle to all custom maps.
    - /classic:                           Set the map cycle to all classic maps.
    - /small:                             Set the map cycle to small maps only.
    - /medium:                            Set the map cycle to medium maps only.
    - /large:                             Set the map cycle to large maps only.
    - /whatis:                            Provide information about the next map in the current cycle.
    - /nextmap:                           Show and load the next map in the current cycle.
    - /prev:                              Show and load the previous map in the current cycle.
    - /restart:                           Restart the map cycle.
    - /loadmap <map_name> <gametype_name> <mapcycle_type>:  Load a specific map and gametype from defined cycle.

    The script automatically cycles through the selected map rotation at the end of each game, with the
    flexibility for administrators to manually set the map cycle if desired. Permissions can be set to restrict
    who can add or remove maps from the cycles.

    Prerequisites:
    1. Disable SAPP's built-in map cycle feature for this script to function correctly.
    2. Remove any commands that load maps from SAPP to avoid conflicts; this script is a drop-in replacement
       for SAPP's built-in map cycle feature.

Copyright (c) 2024, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

--------------------------------------------
-- Configuration starts
--------------------------------------------

local config = {

    ------------------------
    -- Command Configuration
    ------------------------

    -- Minimum permission level required to execute any command in the commands table:
    required_permission = 1,

    -- Table of commands for managing the map cycle in the game server:
    -- Format: command_label = { 'alias1', 'alias2', ... }
    commands = {
        custom = { 'set_custom', 'use_custom', 'sv_set_custom' },
        classic = { 'set_classic', 'use_classic', 'sv_set_classic' },
        small = { 'set_small', 'use_small', 'sv_set_small' },
        medium = { 'set_medium', 'use_medium', 'sv_set_medium' },
        large = { 'set_large', 'use_large', 'sv_set_large' },
        whatis = { 'next_map_info', 'sv_next_map_info' },
        next = { 'next_map', 'sv_next_map' },
        prev = { 'prev_map', 'sv_prev_map' },
        restart = { 'restart_map_cycle', 'sv_restart_map_cycle' },
        loadmap = { 'load_map', 'sv_load_map' }
    },

    -----------------------------
    -- Default Map Configuration
    -----------------------------

    -- Specifies the default map cycle to be used when the script is loaded.
    -- Options include 'CLASSIC', 'CUSTOM', 'SMALL', 'MEDIUM', and 'LARGE'.
    default_mapcycle = 'CLASSIC',

    -- Specifies the default map that will be loaded when the script is loaded.
    -- Ensure the specified map is included in the chosen map cycle.
    default_map = 'beavercreek',

    -- Specifies the default game type to be used with the default map.
    -- Ensure the specified gametype is included in the chosen map cycle.
    default_gametype = 'ctf',

    --------------------------
    -- Map Cycle Configuration
    --------------------------

    -- Set to true to enable randomization of the map order in the map cycle.
    -- When set to false, maps will be loaded in the defined order.
    mapcycle_randomization = {
        CLASSIC = false,
        CUSTOM = false,
        SMALL = false,
        MEDIUM = false,
        LARGE = false
    },

    -- Format:
    -- Each entry in the map cycle is structured as follows:
    -- { map, gametype }
    -- The map cycle is organized into different categories, allowing server administrators to switch between
    -- classic, custom, small, medium, and large maps.

    mapcycle = {
        CLASSIC = {
            { 'beavercreek', 'ctf' },
            { 'bloodgulch', 'ctf' },
            { 'boardingaction', 'slayer' },
            { 'carousel', 'koth' },
            { 'chillout', 'race' },
            { 'damnation', 'slayer' },
            { 'dangercanyon', 'koth' },
            { 'deathisland', 'oddball' },
            { 'gephyrophobia', 'race' },
            { 'hangemhigh', 'ctf' },
            { 'icefields', 'slayer' },
            { 'infinity', 'oddball' },
            { 'longest', 'race' },
            { 'prisoner', 'koth' },
            { 'putput', 'slayer' },
            { 'ratrace', 'ctf' },
            { 'sidewinder', 'slayer' },
            { 'timberland', 'koth' },
            { 'wizard', 'oddball' }
        },
        CUSTOM = {
            { 'custom_map1', 'ctf' },
            { 'custom_map2', 'koth' },
            { 'custom_map3', 'oddball' },
            { 'custom_map4', 'race' },
            { 'custom_map5', 'slayer' }
        },
        SMALL = {
            { 'beavercreek', 'oddball' },
            { 'chillout', 'ctf' },
            { 'longest', 'race' },
            { 'prisoner', 'slayer' },
            { 'wizard', 'koth' },
        },
        MEDIUM = {
            { 'carousel', 'koth' },
            { 'damnation', 'oddball' },
            { 'putput', 'race' },
            { 'hangemhigh', 'slayer' },
            { 'ratrace', 'ctf' },
            { 'sidewinder', 'slayer' },
        },
        LARGE = {
            { 'bloodgulch', 'race' },
            { 'boardingaction', 'slayer' },
            { 'deathisland', 'koth' },
            { 'icefields', 'oddball' },
            { 'infinity', 'ctf' },
            { 'gephyrophobia', 'race' },
            { 'timberland', 'slayer' },
        }
    }
}

--------------------------------------------
-- Configuration ends
--------------------------------------------

local mapcycleType
local mapcycleIndex
local next_map_flag

api_version = '1.12.0.0'

local function getIndex(current_map, current_gametype)
    local cycle = config.mapcycle[mapcycleType]

    for i = 1, #cycle do
        local map, gametype = cycle[i][1], cycle[i][2]
        if map == current_map and gametype == current_gametype then
            return i
        end
    end

    error('No map cycle found for ' .. current_map .. ' ' .. current_gametype .. ' in ' .. mapcycleType .. ' cycle.')
end

local function shuffle(cycle)
    local len = #cycle
    for i = len, 2, -1 do
        local j = math.random(1, i)
        cycle[i], cycle[j] = cycle[j], cycle[i]
    end
end

-- Shuffle all map cycles that are set to randomize:
local function shuffleAllMapCycles()
    for cycle_type, should_shuffle in pairs(config.mapcycle_randomization) do
        if should_shuffle and config.mapcycle[cycle_type] then
            shuffle(config.mapcycle[cycle_type])
        end
    end
end

local function initializeMapCycle()
    next_map_flag = false

    -- Shuffle all map cycles marked for randomization
    shuffleAllMapCycles()

    mapcycleType = config.default_mapcycle
    local map = config.default_map
    local gametype = config.default_gametype

    -- Determine the index based on randomization settings
    mapcycleIndex = config.mapcycle_randomization[mapcycleType] and 1 or getIndex(map, gametype)

    -- Retrieve the map and gametype based on the determined index
    map = config.mapcycle[mapcycleType][mapcycleIndex][1]
    gametype = config.mapcycle[mapcycleType][mapcycleIndex][2]

    -- Execute the command to load the selected map and gametype
    execute_command('map ' .. map .. ' ' .. gametype)
end


function OnScriptLoad()
    initializeMapCycle()
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_END'], 'OnGameEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
end

local function inform(playerId, message)
    if playerId == 0 then
        cprint(message)
    else
        rprint(playerId, message)
    end
end

local function loadSpecificMap(playerId, map_name, gametype_name, mapcycle_type)

    local cycle_type = mapcycle_type:upper()

    if not config.mapcycle[cycle_type] then
        inform(playerId, 'Invalid map cycle type: ' .. mapcycle_type)
        return false
    end

    -- Switch to the specified map cycle type:
    mapcycleType = cycle_type

    -- Check if the map exists in the specified map cycle:
    local cycle = config.mapcycle[mapcycleType]
    for i = 1, #cycle do
        local map, gametype = cycle[i][1], cycle[i][2]
        if map == map_name and gametype == gametype_name then
            mapcycleIndex = i
            execute_command('map ' .. map .. ' ' .. gametype)
            inform(playerId, 'Loading map [' .. map_name .. '] with gametype [' .. gametype_name .. '] from the [' .. mapcycle_type .. '] cycle.')
            return true
        end
    end

    inform(playerId, 'Map ' .. map_name .. ' with gametype ' .. gametype_name .. ' not found in ' .. mapcycle_type .. ' cycle.')
    return false
end

local function loadMap(direction)
    local count = #config.mapcycle[mapcycleType]

    if direction == 'next' then
        mapcycleIndex = (mapcycleIndex % count) + 1
    elseif direction == 'prev' then
        mapcycleIndex = (mapcycleIndex - 2) % count + 1
    end

    local map, gametype = config.mapcycle[mapcycleType][mapcycleIndex][1], config.mapcycle[mapcycleType][mapcycleIndex][2]
    execute_command('map ' .. map .. ' ' .. gametype)
end

local function loadNextMap()
    loadMap('next')
end

local function loadPrevMap()
    loadMap('prev')
end

function OnGameEnd()
    if next_map_flag then
        loadNextMap()
    end
    next_map_flag = false
end

function OnStart()
    next_map_flag = true
end

local function isAlias(commandString, aliasTable)

    for _, alias in ipairs(aliasTable) do
        if commandString == alias then
            return true
        end
    end

    return false
end

local function hasPermission(playerId)
    local level = tonumber(get_var(playerId, '$lvl')) or 0
    if playerId == 0 or level >= config.required_permission then
        return true
    end
    inform(playerId, 'You do not have permission to execute this command!')
    return false
end

function string.split(str)
    local t = { }
    for arg in str:gmatch('([^%s]+)') do
        t[#t + 1] = arg
    end
    return t
end

local function restartMapCycle()
    mapcycleIndex = 1
    next_map_flag = false
    local map, gametype = config.mapcycle[mapcycleType][1][1], config.mapcycle[mapcycleType][1][2]
    execute_command('map ' .. map .. ' ' .. gametype)
end

local function getNextMap()
    local count = #config.mapcycle[mapcycleType]
    mapcycleIndex = (mapcycleIndex % count) + 1
    return config.mapcycle[mapcycleType][mapcycleIndex][1], config.mapcycle[mapcycleType][mapcycleIndex][2]
end

function OnCommand(playerId, command)
    local args = string.split(command)
    local commandString = args[1]:lower()

    for key, aliasTable in pairs(config.commands) do
        if commandString == key or isAlias(commandString, aliasTable) then
            if not hasPermission(playerId) then
                return false
            end

            if key == 'custom' or key == 'classic' or key == 'small' or key == 'medium' or key == 'large' then
                mapcycleType = key:upper()
                mapcycleIndex = 1
                next_map_flag = false
                inform(playerId, 'Map cycle set to [' .. key:upper() .. '].')
                execute_command('map ' .. config.mapcycle[mapcycleType][1][1] .. ' ' .. config.mapcycle[mapcycleType][1][2])
            elseif key == 'next' then
                loadNextMap()
                inform(playerId, 'Loading next map in [' .. mapcycleType .. '] cycle.')
            elseif key == 'prev' then
                loadPrevMap()
                inform(playerId, 'Loading previous map in [' .. mapcycleType .. '] cycle.')
            elseif key == 'whatis' then
                local map, gametype = getNextMap()
                inform(playerId, 'Next map in [' .. mapcycleType .. '] cycle: ' .. map .. ' ' .. gametype)
            elseif key == 'restart' then
                restartMapCycle()
                inform(playerId, 'Map cycle has been restarted.')
            elseif key == 'loadmap' then
                if #args < 4 then
                    inform(playerId, 'Usage: /loadmap <map_name> <gametype_name> <mapcycle_type>')
                else
                    local map_name = args[2]
                    local gametype_name = args[3]
                    local mapcycle_type = args[4]
                    loadSpecificMap(playerId, map_name, gametype_name, mapcycle_type)
                end
            end
            return false
        end
    end
end
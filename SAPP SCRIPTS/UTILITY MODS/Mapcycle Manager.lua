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

    Automatic Map Cycle Adjustments:
    The script includes an optional feature that allows for automatic adjustments of the map cycle based on the current player count.
    When enabled, the script will dynamically change the map cycle to small, medium, or large maps based on the number of players in the game.
    This feature can be toggled on or off by the server administrator.

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

    -- Table of commands for managing the map cycle in the game server:
    -- Each command can have multiple aliases for easier usage.
    -- The structure is as follows:
    -- command_label = {
    --     level = <required_permission_level>,
    --     aliases = { 'alias1', 'alias2', ... },
    --     cooldown = <time_in_seconds>
    -- }
    -- Permission levels:
    --   -1: Public access (accessible to all players)
    --    1-4: Admin access (only accessible to admins)

    commands = {
        custom = { level = 4, aliases = { 'set_custom', 'use_custom', 'sv_set_custom' }, cooldown = 10 },
        classic = { level = 4, aliases = { 'set_classic', 'use_classic', 'sv_set_classic' }, cooldown = 10 },
        small = { level = 4, aliases = { 'set_small', 'use_small', 'sv_set_small' }, cooldown = 10 },
        medium = { level = 4, aliases = { 'set_medium', 'use_medium', 'sv_set_medium' }, cooldown = 10 },
        large = { level = 4, aliases = { 'set_large', 'use_large', 'sv_set_large' }, cooldown = 10 },
        whatis = { level = -1, aliases = { 'next_map_info', 'sv_next_map_info' }, cooldown = 10 },
        next = { level = 4, aliases = { 'next_map', 'nextmap', 'sv_next_map' }, cooldown = 10 },
        prev = { level = 4, aliases = { 'prevmap', 'prev_map', 'sv_prev_map' }, cooldown = 10 },
        restart = { level = 4, aliases = { 'restart_map_cycle', 'sv_restart_map_cycle' }, cooldown = 10 },
        loadmap = { level = 4, aliases = { 'load_map', 'sv_load_map' }, cooldown = 10 }
    },

    -----------------------------
    -- Default Map Configuration
    -----------------------------

    -- Specifies the default map cycle, map and gametype to be used when the script is loaded.
    default_mapcycle = 'CLASSIC',
    default_map = 'beavercreek',
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
            { 'carousel', 'king' },
            { 'chillout', 'race' },
            { 'damnation', 'slayer' },
            { 'dangercanyon', 'king' },
            { 'deathisland', 'oddball' },
            { 'gephyrophobia', 'race' },
            { 'hangemhigh', 'ctf' },
            { 'icefields', 'slayer' },
            { 'infinity', 'oddball' },
            { 'longest', 'race' },
            { 'prisoner', 'king' },
            { 'putput', 'slayer' },
            { 'ratrace', 'ctf' },
            { 'sidewinder', 'slayer' },
            { 'timberland', 'king' },
            { 'wizard', 'oddball' }
        },
        CUSTOM = {
            { 'custom_map1', 'ctf' },
            { 'custom_map2', 'king' },
            { 'custom_map3', 'oddball' },
            { 'custom_map4', 'race' },
            { 'custom_map5', 'slayer' }
        },
        SMALL = {
            { 'beavercreek', 'oddball' },
            { 'chillout', 'ctf' },
            { 'longest', 'race' },
            { 'prisoner', 'slayer' },
            { 'wizard', 'king' },
        },
        MEDIUM = {
            { 'carousel', 'king' },
            { 'damnation', 'oddball' },
            { 'putput', 'race' },
            { 'hangemhigh', 'slayer' },
            { 'ratrace', 'ctf' },
            { 'sidewinder', 'slayer' },
        },
        LARGE = {
            { 'bloodgulch', 'race' },
            { 'boardingaction', 'slayer' },
            { 'deathisland', 'king' },
            { 'icefields', 'oddball' },
            { 'infinity', 'ctf' },
            { 'gephyrophobia', 'race' },
            { 'timberland', 'slayer' },
        }
    },

    ------------------------------------
    -- Automatic Map Cycle Configuration
    ------------------------------------
    automatic_map_adjustments = {
        enabled = false,
        small = { min = 0, max = 4 }, -- Adjust the values as needed
        medium = { min = 5, max = 12 }, -- Adjust the values as needed
        large = { min = 13, max = 16 }, -- Adjust the values as needed
    },

    --------------------------
    -- Customizable Messages
    --------------------------
    messages = {
        permission_denied = "You do not have permission to execute this command!",
        command_on_cooldown = "Command is on cooldown! Please wait {seconds} seconds.",
        invalid_map_cycle_type = "Invalid map cycle type: {cycle_type}",
        map_loaded = "Loading map [{map_name}] with gametype [{gametype}] from the [{cycle_type}] cycle.",
        map_not_found = "Map {map_name} with gametype {gametype} not found in {cycle_type} cycle.",
        next_map_info = "Next map in [{cycle_type}] cycle: [{map_name}/{gametype}] -> {time_remaining}",
        map_cycle_set = "Map cycle set to [{cycle_type}].",
        loading_next_map = "Loading next map [{map_name}/{gametype}] in [{cycle_type}] cycle.",
        loading_previous_map = "Loading previous map [{map_name}] in [{cycle_type}] cycle.",
        map_cycle_restarted = "Map cycle [{cycle_type}] has been restarted.",
        loadmap_usage = "Usage: /loadmap <map_name> <gametype_name> <mapcycle_type>"
    },
}

--------------------------------------------
-- Configuration ends
--------------------------------------------

local mapcycleType
local mapcycleIndex
local next_map_flag
local commandCooldowns
local timelimit_address
local tick_counter_address
local sv_map_reset_tick_address

api_version = '1.12.0.0'

local function initializeCooldowns()
    for i = 1, 16 do
        if player_present(i) then
            commandCooldowns[i] = {}
        end
    end
end

local function getMapIndex(current_map, current_gametype)
    for i, cycle in ipairs(config.mapcycle[mapcycleType]) do
        if cycle[1] == current_map and cycle[2] == current_gametype then
            return i
        end
    end
    error('No map cycle found for ' .. current_map .. ' ' .. current_gametype .. ' in ' .. mapcycleType .. ' cycle.')
end

local function shuffle(cycle)
    for i = #cycle, 2, -1 do
        local j = math.random(1, i)
        cycle[i], cycle[j] = cycle[j], cycle[i]
    end
end

-- Shuffle all map cycles that are set to randomize:
local function shuffleAllMapCycles()
    for cycle_type, should_shuffle in pairs(config.mapcycle_randomization) do
        if should_shuffle then
            shuffle(config.mapcycle[cycle_type])
        end
    end
end

local function loadMapAndGametype(type, index)
    local map = config.mapcycle[type][index][1]
    local gametype = config.mapcycle[type][index][2]
    execute_command('map ' .. map .. ' ' .. gametype)
end

local function initializeMapCycle()
    next_map_flag = false

    -- Shuffle all map cycles marked for randomization
    shuffleAllMapCycles()

    mapcycleType = config.default_mapcycle
    local map = config.default_map
    local gametype = config.default_gametype

    -- Determine the index based on randomization settings
    mapcycleIndex = config.mapcycle_randomization[mapcycleType] and 1 or getMapIndex(map, gametype)

    loadMapAndGametype(mapcycleType, mapcycleIndex)
end

local function loadTimelimitAddresses()
    local tick_counter_sig = sig_scan("8B2D????????807D0000C644240600")
    if (tick_counter_sig == 0) then
        return
    end

    local sv_map_reset_tick_sig = sig_scan("8B510C6A018915????????E8????????83C404")
    if (sv_map_reset_tick_sig == 0) then
        return
    end

    local timelimit_location_sig = sig_scan("8B0D????????83C8FF85C97E17")
    if (timelimit_location_sig == 0) then
        return
    end

    timelimit_address = read_dword(timelimit_location_sig + 2)
    sv_map_reset_tick_address = read_dword(sv_map_reset_tick_sig + 7)
    tick_counter_address = read_dword(read_dword(tick_counter_sig + 2)) + 0xC
end

local floor, format = math.floor, string.format
local function SecondsToTime(seconds)
    local hr = floor(seconds / 3600)
    local min = floor((seconds % 3600) / 60)
    local sec = floor(seconds % 60)
    return format("%02d:%02d:%02d", hr, min, sec)
end

local function getTimeRemaining()
    local timelimit = read_dword(timelimit_address)
    local tick_counter = read_dword(tick_counter_address)
    local sv_map_reset_tick = read_dword(sv_map_reset_tick_address)
    local time_remaining_in_seconds = floor((timelimit - (tick_counter - sv_map_reset_tick)) / 30)
    return SecondsToTime(time_remaining_in_seconds)
end

function OnScriptLoad()

    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_END'], 'OnGameEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')

    commandCooldowns = {}
    initializeMapCycle()
    initializeCooldowns()
    loadTimelimitAddresses()
end

function OnJoin(playerId)
    commandCooldowns[playerId] = {}
end

function OnQuit(playerId)
    commandCooldowns[playerId] = nil
end

local function replacePlaceholders(message, placeholders)
    for key, value in pairs(placeholders) do
        message = message:gsub("{" .. key .. "}", tostring(value))
    end
    return message
end

-- Adjust existing functions to use the configurable messages:
local function inform(playerId, message, placeholders)
    message = replacePlaceholders(message, placeholders or {})
    return playerId == 0 and cprint(message) or rprint(playerId, message)
end

local function loadSpecificMap(playerId, map_name, gametype_name, mapcycle_type)

    next_map_flag = false

    local cycle_type = mapcycle_type:upper()
    if not config.mapcycle[cycle_type] then
        inform(playerId, config.messages.invalid_map_cycle_type, { cycle_type = mapcycle_type })
        return false
    end

    local cycle = config.mapcycle[cycle_type]
    for i = 1, #cycle do
        local map, gametype = cycle[i][1], cycle[i][2]
        if map == map_name and gametype == gametype_name then
            mapcycleIndex = i
            mapcycleType = cycle_type
            loadMapAndGametype(mapcycleType, mapcycleIndex)
            inform(playerId, config.messages.map_loaded, {
                map_name = map_name,
                gametype = gametype_name,
                cycle_type = mapcycle_type
            })
            return true
        end
    end

    inform(playerId, config.messages.map_not_found, {
        map_name = map_name,
        gametype = gametype_name,
        cycle_type = mapcycle_type
    })
    return false
end

local function loadMap(direction)
    next_map_flag = false

    local count = #config.mapcycle[mapcycleType]
    mapcycleIndex = (mapcycleIndex + (direction == 'next' and 1 or -1)) % count

    if mapcycleIndex < 1 then
        mapcycleIndex = count
    end

    loadMapAndGametype(mapcycleType, mapcycleIndex)
end

local function loadNextMap()
    loadMap('next')
end

local function loadPrevMap()
    loadMap('prev')
end

local function adjustMapCycleBasedOnPlayerCount()
    if not config.automatic_map_adjustments.enabled then
        return false
    end

    local playerCount = tonumber(get_var(0, '$pn'))
    local t = config.automatic_map_adjustments

    local cycles = {
        { type = 'SMALL', min = t.small.min, max = t.small.max },
        { type = 'MEDIUM', min = t.medium.min, max = t.medium.max },
        { type = 'LARGE', min = t.large.min, max = t.large.max },
    }

    for _, cycle in ipairs(cycles) do
        if playerCount >= cycle.min and playerCount <= cycle.max then
            mapcycleType = cycle.type
            mapcycleIndex = 1
            return true
        end
    end
    return false
end

function OnGameEnd()
    adjustMapCycleBasedOnPlayerCount()
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

local function hasPermission(playerId, commandKey)
    local level = tonumber(get_var(playerId, '$lvl')) or 0
    local requiredLevel = config.commands[commandKey].level
    if playerId == 0 or level >= requiredLevel then
        return true
    end
    inform(playerId, config.messages.permission_denied)
    return false
end

function string.split(str)
    local t = {}
    for word in str:gmatch("%S+") do
        t[#t + 1] = word
    end
    return t
end

local function restartMapCycle()
    next_map_flag = false
    mapcycleIndex = 1
    loadMapAndGametype(mapcycleType, mapcycleIndex)
end

local function getNextMap()
    mapcycleIndex = (mapcycleIndex % #config.mapcycle[mapcycleType]) + 1
    local mapInfo = config.mapcycle[mapcycleType][mapcycleIndex]
    return mapInfo[1], mapInfo[2]
end

local function getPreviousMap()
    mapcycleIndex = (mapcycleIndex - 2) % #config.mapcycle[mapcycleType] + 1
    local mapInfo = config.mapcycle[mapcycleType][mapcycleIndex]
    return mapInfo[1], mapInfo[2]
end

local function commandOnCooldown(playerId, key, cmdInfo)
    if playerId == 0 then
        return false
    end

    local currentTime = os.time()
    local lastUsed = commandCooldowns[playerId][key] or 0
    local cooldownTime = lastUsed + cmdInfo.cooldown

    if currentTime < cooldownTime then
        inform(playerId, config.messages.command_on_cooldown, { seconds = cooldownTime - currentTime })
        return true
    end

    commandCooldowns[playerId][key] = currentTime
    return false
end

function OnCommand(playerId, command)
    local args = string.split(command)
    local commandString = args[1]:lower()

    for key, cmdInfo in pairs(config.commands) do
        if commandString == key or isAlias(commandString, cmdInfo.aliases) then

            if not hasPermission(playerId, key) or commandOnCooldown(playerId, key, cmdInfo) then
                return false
            end

            if key == 'custom' or key == 'classic' or key == 'small' or key == 'medium' or key == 'large' then
                mapcycleType = key:upper()
                mapcycleIndex = 1
                next_map_flag = false
                inform(playerId, config.messages.map_cycle_set, { cycle_type = key:upper() })
                loadMapAndGametype(mapcycleType, mapcycleIndex)
            elseif key == 'next' then
                local map, gametype = getNextMap()
                loadNextMap()
                inform(playerId, config.messages.loading_next_map, {
                    map_name = map,
                    gametype = gametype,
                    cycle_type = mapcycleType
                })

            elseif key == 'prev' then
                local map, gametype = getPreviousMap()
                loadPrevMap()
                inform(playerId, config.messages.loading_previous_map, {
                    map_name = map,
                    gametype = gametype,
                    cycle_type = mapcycleType
                })
            elseif key == 'whatis' then
                local map, gametype = getNextMap()
                local time_remaining = getTimeRemaining()
                inform(playerId, config.messages.next_map_info, {
                    map_name = map,
                    gametype = gametype,
                    cycle_type = mapcycleType,
                    time_remaining = time_remaining
                })
            elseif key == 'restart' then
                restartMapCycle()
                inform(playerId, config.messages.map_cycle_restarted, {cycle_type = mapcycleType})
            elseif key == 'loadmap' then
                if #args < 4 then
                    inform(playerId, config.messages.loadmap_usage)
                else
                    loadSpecificMap(playerId, args[2], args[3], args[4])
                end
            end
            return false
        end
    end
end
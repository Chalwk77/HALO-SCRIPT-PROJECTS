--[[
--=====================================================================================================--
Script Name: Mapcycle Manager, for SAPP (PC & CE)
Description:

    The Mapcycle Manager script enables server administrators to efficiently manage map rotations and facilitates
    the seamless switching between classic and custom map rotations using simple commands.

    Upon loading, the script initializes with a predefined set of classic maps and their corresponding
    game types, as well as placeholders for custom maps. Administrators can easily switch between five modes:

    - **Classic Mode**: Loads a predefined rotation of classic Halo maps.
    - **Custom Mode**: Loads a rotation of user-defined custom maps.
    - **Small Mode**: Loads a rotation of small maps.
    - **Medium Mode**: Loads a rotation of medium maps.
    - **Large Mode**: Loads a rotation of large maps.

    The script supports JSON file storage for persistent map cycles, ensuring that map selections are
    retained across server restarts. The commands for toggling the map cycles are simple and can be issued by players:
    - Use **/custom** to set the mapcycle to all custom maps.
    - Use **/classic** to set the mapcycle to all classic maps.
    - Use **/small** to set the mapcycle to small maps only.
    - Use **/medium** to set the mapcycle to medium maps only.
    - Use **/large** to set the mapcycle to large maps only.
    - Use **/nextmap** to show the next map in the cycle only.
    - Use **/addmap <type> <map> <gametype>** to add a map to the specified cycle (requires permission).
    - Use **/removemap <type> <map>** to remove a map from the specified cycle (requires permission).

    The script automatically cycles through the selected map rotation at the end of each game, with the
    flexibility for administrators to manually set the map cycle if desired. Permissions can be set to restrict
    who can add or remove maps from the cycles.

    **Prerequisites**:
    1. Disable SAPP's built-in mapcycle feature for this script to function correctly.
    2. Place the `json.lua` library in the server's root directory (the same location as `sapp.dll` and `strings.dll`).

Copyright (c) 2024, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

--------------------------------------------
-- Configuration starts
--------------------------------------------

-- Commands to set the map cycle
local commands = {
    custom = 'custom',
    classic = 'classic',
    small = 'small',
    medium = 'medium',
    large = 'large',
    nextmap = 'nextmap',
    addmap = 'addmap',
    removemap = 'removemap'
}

-- File name for storing the map cycle
local file_name = 'mapcycle.json'

-- Minimum permission level required to change map cycle
local required_permission = 1

-- Default map cycle configuration
local default_mapcycle = {

    -- All map cycles are defined here.
    -- Format: { 'map_name', 'gametype' }

    CLASSIC = {
        { 'bloodgulch', 'slayer' },
        { 'boardingaction', 'slayer' },
        { 'carousel', 'koth' },
        { 'chillout', 'ctf' },
        { 'damnation', 'ctf' },
        { 'dangercanyon', 'slayer' },
        { 'deathisland', 'slayer' },
        { 'gephyrophobia', 'koth' },
        { 'hangemhigh', 'slayer' },
        { 'icefields', 'race' },
        { 'infinity', 'ctf' },
        { 'longest', 'slayer' },
        { 'prisoner', 'slayer' },
        { 'putput', 'ctf' },
        { 'ratrace', 'race' },
        { 'sidewinder', 'koth' },
        { 'timberland', 'slayer' },
        { 'wizard', 'koth' }
    },

    -- bloodgulch:LNZ-DAC:[bloodgulch]
    -- beavercreek:LNZ-DAC:[beavercreek]
    -- ratrace:LNZ-DAC:[ratrace]
    -- icefields:LNZ-DAC:[icefields]
    -- carousel:LNZ-DAC:[carousel]
    -- chillout:LNZ-DAC:[chillout]
    -- wizard:LNZ-DAC:[wizard]
    -- timberland:LNZ-DAC:[timberland]
    -- longest:LNZ-DAC:[longest]
    -- hangemhigh:LNZ-DAC:[hangemhigh]
    -- prisoner:LNZ-DAC:[prisoner]
    -- damnation:LNZ-DAC:[damnation]

    CUSTOM = {
        { 'custom_map1', 'ctf' },
        { 'custom_map2', 'koth' },
        { 'custom_map3', 'race' }
    },

    SMALL = {
        { 'small_map1', 'slayer' },
        { 'small_map2', 'koth' },
        { 'small_map3', 'ctf' }
    },

    MEDIUM = {
        { 'medium_map1', 'slayer' },
        { 'medium_map2', 'koth' },
        { 'medium_map3', 'ctf' }
    },

    LARGE = {
        { 'large_map1', 'slayer' },
        { 'large_map2', 'koth' },
        { 'large_map3', 'ctf' }
    }
}

--------------------------------------------
-- Configuration ends
--------------------------------------------

api_version = '1.12.0.0'
local mapcycle = {}
local json = loadfile('./json.lua')()
local sapp_path, mapcycle_path

-- Function to handle file reading
local function readFile(file)
    local f = io.open(file, 'r')
    if not f then
        return ''
    end
    local contents = f:read('*all')
    f:close()
    return contents
end

-- Function to handle file writing
local function writeFile(file, contents)
    local f = io.open(file, 'w')
    if f then
        f:write(json:encode_pretty(contents))
        f:close()
    else
        cprint("Error: Unable to write to file " .. file)
    end
end

-- Load file and decode JSON content
local function loadFile(file)
    local contents = readFile(file)
    return contents ~= '' and json:decode(contents) or nil
end

local function setInitialMapCycle()
    mapcycle.type = 'CLASSIC'
    mapcycle.index = 1
    mapcycle.set_manually = true
    local map, gametype = mapcycle.CLASSIC[1][1], mapcycle.CLASSIC[1][2]
    execute_command('map ' .. map .. ' ' .. gametype)
end

function OnScriptLoad()
    sapp_path = read_string(read_dword(sig_scan('68??????008D54245468') + 0x1))
    mapcycle_path = sapp_path .. '\\sapp\\' .. file_name

    mapcycle = loadFile(mapcycle_path)
    if not mapcycle then
        writeFile(mapcycle_path, default_mapcycle)
        mapcycle = default_mapcycle
    end

    setInitialMapCycle()
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_END'], 'OnGameEnd')
end

local function inform(playerId, message)
    if playerId == 0 then
        cprint(message)  -- Print to console for server messages
    else
        rprint(playerId, message)  -- Print to specific player
    end
end

-- Generic map modification function
local function modify_map(playerId, action, type, map, gametype)
    type = type:upper()

    if not default_mapcycle[type] then
        inform(playerId, 'Invalid map cycle type! Valid types: CLASSIC, CUSTOM, SMALL, MEDIUM, LARGE.')
        return
    end

    if action == 'add' then
        table.insert(default_mapcycle[type], { map, gametype })
        inform(playerId, 'Added map ' .. map .. ' with gametype ' .. gametype .. ' to ' .. type .. ' cycle.')
    elseif action == 'remove' then
        for i, entry in ipairs(default_mapcycle[type]) do
            if entry[1] == map then
                table.remove(default_mapcycle[type], i)
                inform(playerId, 'Removed map ' .. map .. ' from ' .. type .. ' cycle.')
                return
            end
        end
        inform(playerId, 'Map ' .. map .. ' not found in ' .. type .. ' cycle.')
    end
    writeFile(mapcycle_path, default_mapcycle)  -- Save changes to the file
end

local function loadNextMap()
    local type = mapcycle.type
    mapcycle.index = (mapcycle.index % #mapcycle[type]) + 1
    local map, gametype = mapcycle[type][mapcycle.index][1], mapcycle[type][mapcycle.index][2]
    execute_command('map ' .. map .. ' ' .. gametype)
end

function OnGameEnd()
    if not mapcycle.set_manually then
        loadNextMap()
    end
    mapcycle.set_manually = false
end

-- Custom function to set the map cycle
local function set_mapcycle(playerId, type)
    mapcycle.set_manually = true
    mapcycle.type = type:upper()
    mapcycle.index = 1
    local map, gametype = mapcycle[mapcycle.type][1][1], mapcycle[mapcycle.type][1][2]
    execute_command('map ' .. map .. ' ' .. gametype)
    inform(playerId, 'Mapcycle set to ' .. type .. ': Next map is ' .. map .. ' (' .. gametype .. ')')
end

local function hasPermission(playerId)
    local level = tonumber(get_var(playerId, '$lvl')) or 0
    if playerId == 0 or level >= required_permission then
        return true
    end
    inform(playerId, 'You do not have permission to execute this command!')
    return false
end

local valid_commands = {
    [commands.custom] = 'CUSTOM',
    [commands.classic] = 'CLASSIC',
    [commands.small] = 'SMALL',
    [commands.medium] = 'MEDIUM',
    [commands.large] = 'LARGE'
}

function OnCommand(playerId, command)
    local cmd = command:lower()

    if valid_commands[cmd] and hasPermission(playerId) then
        set_mapcycle(playerId, valid_commands[cmd])
        return false
    elseif cmd == commands.nextmap then
        local type = mapcycle.type
        local next_index = (mapcycle.index % #mapcycle[type]) + 1
        local next_map = mapcycle[type][next_index][1]
        local next_gametype = mapcycle[type][next_index][2]
        inform(playerId, 'Next map: ' .. next_map .. ' (' .. next_gametype .. ') Next index: [' .. next_index .. ']')
        return false
    elseif cmd:find(commands.addmap) == 1 and hasPermission(playerId) then
        local args = { command:match('^/addmap%s+(%S+)%s+(%S+)%s+(%S+)$') }
        if #args < 3 then
            inform(playerId, 'Usage: /addmap <type> <map> <gametype>')
        else
            modify_map(playerId, 'add', args[1], args[2], args[3])
        end
        return false
    elseif cmd:find(commands.removemap) == 1 and hasPermission(playerId) then
        local args = { command:match('^/removemap%s+(%S+)%s+(%S+)$') }
        if #args < 2 then
            inform(playerId, 'Usage: /removemap <type> <map>')
        else
            modify_map(playerId, 'remove', args[1], args[2])
        end
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
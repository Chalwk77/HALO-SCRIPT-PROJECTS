--[[
--=====================================================================================================--
Script Name: Color Changer, for SAPP (PC & CE)
Description:

Copyright (c) 2023, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local ColourChanger = {

    --- Admin level:
    -- The minimum level required to change your colour.
    -- Default (1)
    level = 1,

    --- Custom Command:
    command = 'setcolor',

    colours = {
        [0] = 'white',
        [1] = 'black',
        [2] = 'red',
        [3] = 'blue',
        [4] = 'gray',
        [5] = 'yellow',
        [6] = 'green',
        [7] = 'pink',
        [8] = 'purple',
        [9] = 'cyan',
        [10] = 'cobalt',
        [11] = 'orange',
        [12] = 'teal',
        [13] = 'sage',
        [14] = 'brown',
        [15] = 'tan',
        [16] = 'maroon',
        [17] = 'salmon'
    }
}

local players = {}
local colours_address

api_version = '1.12.0.0'

local function Write(address, value)
    safe_write(true)
    write_char(address, value)
    safe_write(false)
end

local function patchColours(state)
    if (state) then
        colours_address = sig_scan('741F8B482085C9750C')
        if (colours_address == 0) then
            colours_address = sig_scan('EB1F8B482085C9750C')
        end
        Write(colours_address, 235)
        return
    end
    if (colours_address == 0) then
        return
    end
    Write(colours_address, 116)
end

local function overrideTeamColours(state)
    if (get_var(0, '$gt') ~= 'n/a') then
        players = {}
        patchColours(state)
    end
end

function OnScriptLoad()
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart(true)
end

function OnSpawn(id)

    local player = players[id]
    if (not player) then
        return
    end

    local x, y, z = player.x, player.y, player.z
    local dynamic_player = get_dynamic_player(id)
    if (dynamic_player == 0) then
        return
    end

    write_vector3d(dynamic_player + 0x5C, x, y, z)
    players[id] = nil
end

local function say(id, str)
    rprint(id, str)
end

local function getPos(id)
    local x, y, z

    local dynamic_player = get_dynamic_player(id)

    if (dynamic_player == 0 or not player_alive(id)) then
        return nil
    end

    local vehicle = read_dword(dynamic_player + 0x11C)
    local object = get_object_memory(vehicle)

    if (vehicle ~= 0xFFFFFFFFF) then
        x, y, z = read_vector3d(dynamic_player + 0x5c)
    elseif (object ~= 0) then
        x, y, z = read_vector3d(object + 0x5c)
    end

    return x, y, z
end

local function setColor(id, colour_id)

    local x, y, z = getPos(id)

    if (not x) then
        say(id, 'Unable to set color.')
        return
    end

    local colour_name = ColourChanger.colours[colour_id]
    players[id] = {
        color = colour_id,
        x = x,
        y = y,
        z = z
    }
    write_byte(get_player(id) + 0x60, colour_id)
    say(id, 'Setting colour to ' .. colour_name .. '.')

    destroy_object(read_dword(get_player(id) + 0x34))
end

local function hasPermission(id, level)
    local lvl = tonumber(get_var(id, '$lvl'))
    return (lvl >= level and true) or false
end

local function stringSplit(s)

    local t = {}
    for arg in s:gmatch('([^%s]+)') do
        t[#t + 1] = arg:lower()
    end

    return t
end

function OnCommand(id, command)

    if (id == 0) then
        return true
    end

    local self = ColourChanger
    local args = stringSplit(command)

    if (args[1]:sub(1, self.command:len()):lower() == self.command) then

        if not hasPermission(id, self.level) then
            say(id, 'You do not have permission to execute this command.')
            return false
        end

        local color = tonumber(args[2])
        if (not color or not self.colours[color]) then
            say(id, 'Invalid color id. Please enter a number between 0-17.')
            return
        end

        setColor(id, color)

        return false
    end
end

function OnStart(state)
    overrideTeamColours(state)
end

function OnScriptUnload()
    overrideTeamColours(false)
end
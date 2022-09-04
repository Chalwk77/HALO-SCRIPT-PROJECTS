--[[
--=====================================================================================================--
Script Name: Tactical Insertion, for SAPP (PC & CE)
Description: Set your next spawn point with a custom command.
             See config section for more.

Copyright (c) 2019-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts
-- Set the command you want to use to set your next spawn point:
-- Syntax: /ti
--
local command = 'ti'

-- Number of uses per game:
--
local uses_per_game = 5

-- Minimum permission level required to execute the custom command:
-- Default: -1
-- Valid levels: (-1 = everyone, 1-4 = admins)
--
local permission_level = -1
-- config ends

api_version = '1.12.0.0'

local players = {}
local format = string.format

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_PRESPAWN'], 'OnPreSpawn')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        players = { }

        for i = 1, 16 do
            if player_present(i) then
                OnJoin()
            end
        end
    end
end

-- Creates an iterable cache of player data:
-- (player_id, { uses = 0, spawn = nil })
function OnJoin(Ply)
    players[Ply] = {
        teleport = false,
        uses = uses_per_game,
        x = 0,
        y = 0,
        z = 0
    }
end

-- Called when a player quits the server:
--
function OnQuit(Ply)
    players[Ply] = nil
end

-- Returns a table of strings:
--
local function CMDSplit(s)
    local args = {}

    for arg in s:gmatch('([^%s]+)') do
        args[#args + 1] = arg:lower()
    end

    return args
end


-- Retrieves a player's map coordinates and
-- returns 3x 32 bit floating point numbers
--
local function GetXYZ(Ply)
    local x, y, z

    local dyn = get_dynamic_player(Ply)
    if (dyn ~= 0) then
        local vehicle = read_dword(dyn + 0x11C)
        local object = get_object_memory(vehicle)
        if (vehicle == 0xFFFFFFFF) then
            x, y, z = read_vector3d(dyn + 0x5C)
        else
            x, y, z = read_vector3d(object + 0x5c)
        end
    end
    return x, y, z
end

-- STAR OF THE SHOW:
-- Called when a player is respawning.
--
function OnPreSpawn(Ply)
    local dyn = get_dynamic_player(Ply)
    local p = players[Ply]
    if (dyn ~= 0 and p.teleport) then
        p.teleport = false
        local x, y, z = p.x, p.y, p.z
        local z_off = 0.3
        write_vector3d(dyn + 0x5C, x, y, z + z_off)
    end
end

local function HasPermission(Ply)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    return (lvl >= permission_level)
end

-- Our custom command handler:
--
function OnCommand(Ply, CMD)
    local args = CMDSplit(CMD)

    if (args and CMD:sub(1, command:len()):lower() == command) then

        if HasPermission(Ply) then
            if player_alive(Ply) then

                local p = players[Ply]
                if (p.uses <= 0) then
                    rprint(Ply, "You have no more uses left for this game.")
                    return false
                end

                p.uses = p.uses - 1
                local x, y, z = GetXYZ(Ply)
                players[Ply] = {
                    teleport = true,
                    uses = p.uses,
                    x = x,
                    y = y,
                    z = z
                }

                local str = string.format("You have %s uses left for this game.", p.uses)
                x = format('%.2f', x)
                y = format('%.2f', y)
                z = format('%.2f', z)
                rprint(Ply, 'Tac-Inset set to ' .. x .. ', ' .. y .. ', ' .. z .. '.')
                rprint(Ply, str)
            else
                rprint(Ply, 'Command failed. You are not alive.')
            end
        else
            rprint(Ply, 'Command failed. You do not have permission to use this command')
        end

        return false
    end
end

-- Although not used in this script,
-- without it, SAPP will throw an error.
--
function OnScriptUnload()
    -- N/A
end
--[[
--=====================================================================================================--
Script Name: Tactical Insertion, for SAPP (PC & CE)
Description: Set your next spawn point with a custom command (/ti).

Players are limited to 5 (default) uses per game.

Copyright (c) 2019-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts
-- Set the command you want to use to set your next spawn point:
local command = 'ti'

-- Number of uses per game:
local uses_per_game = 5
-- config ends

api_version = '1.12.0.0'

local players = {}
local format = string.format

function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_PRESPAWN'], 'OnPreSpawn')
    OnStart()
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        players = { }

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

local function GetIP(Ply)
    return get_var(Ply, '$ip'):match('%d+.%d+.%d+.%d+')
end

function OnJoin(Ply)
    local ip = GetIP(Ply)
    players[ip] = players[ip] or {
        teleport = false,
        uses = uses_per_game,
        x = 0,
        y = 0,
        z = 0
    }
end

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

function OnPreSpawn(Ply)

    local dyn = get_dynamic_player(Ply)
    local ip = GetIP(Ply)

    local p = players[ip]
    if (dyn ~= 0 and p.teleport) then
        p.teleport = false
        local x, y, z = p.x, p.y, p.z
        local z_off = 0.1
        write_vector3d(dyn + 0x5C, x, y, z + z_off)
    end
end

function OnCommand(Ply, CMD)

    if (CMD:sub(1, command:len()):lower() == command) then

        if player_alive(Ply) then

            local ip = GetIP(Ply)
            local p = players[ip]

            if (p.uses <= 0) then
                rprint(Ply, 'You have no more uses left for this game.')
                return false
            end

            p.uses = p.uses - 1

            local x, y, z = GetXYZ(Ply)
            players[ip] = {
                teleport = true,
                uses = p.uses,
                x = x,
                y = y,
                z = z
            }

            rprint(Ply, 'Tac-Insert set to to: ' .. format('%.2f, %.2f, %.2f', x, y, z))
            rprint(Ply, format('You have %s uses left for this game.', p.uses))
        else
            rprint(Ply, 'Command failed. You are not alive.')
        end

        return false
    end
end

function OnDeath(Victim)
    local ip = GetIP(Victim)
    local p = players[ip]
    if (p.teleport) then
        rprint(Victim, 'You will spawn at your Tac-Insert point.')
    end
end

function OnSpawn(Ply)
    local ip = GetIP(Ply)
    local p = players[ip]
    local str = format('You have %s tac-insert uses left for this game.', p.uses)
    rprint(Ply, str)
    rprint(Ply, 'Use /' .. command .. ' to set your next spawn point.')
end

function OnScriptUnload()
    -- N/A
end
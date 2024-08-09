--[[
--=====================================================================================================--
Script Name: Get Object Identity, for SAPP (PC & CE)

Command Syntax:
/getidentity on|off

Point your crosshair at any object and fire your weapon.
The mod will display the following information in the rcon console:

Object Type
Object Name
Object Meta ID
Object X,Y,Z coordinates

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]

api_version = '1.12.0.0'

-- Custom command used to toggle get-mode on/off:
local command = 'get_objects'

-- Minimum permission level required to execute the custom command:
local permission_level = 4

local admins = {}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_COMMAND'], "OnCommand")
    register_callback(cb['EVENT_GAME_START'], "OnStart")
    OnStart()
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        admins = {}
    end
end

local function GetCamXYZ(dyn)

    local cam_x = read_float(dyn + 0x230)
    local cam_y = read_float(dyn + 0x234)
    local cam_z = read_float(dyn + 0x238)
    local couching = read_float(dyn + 0x50C)
    local cx, cy, cz = read_vector3d(dyn + 0x5c)

    if (couching == 0) then
        cz = cz + 0.65
    else
        cz = cz + (0.35 * couching)
    end

    return cx, cy, cz, cam_x * 1000, cam_y * 1000, cam_z * 1000
end

local function Tell(Ply, Type, Name, Meta, ox, oy, oz)

    -- clear player rcon: (writes 25 blank lines to it)
    for _ = 1, 25 do
        rprint(Ply, " ")
    end

    -- print to player rcon:
    rprint(Ply, 'Type: ' .. Type)
    rprint(Ply, 'Name: ' .. Name)
    rprint(Ply, 'Meta: ' .. Meta)
    rprint(Ply, 'X,Y,Z: ' .. ox .. ', ' .. oy .. ', ' .. oz)

    -- print to terminal:
    cprint('Type: ' .. Type)
    cprint('Name: ' .. Name)
    cprint('Meta: ' .. Meta)
    cprint('X,Y,Z: ' .. ox .. ', ' .. oy .. ', ' .. oz)
end

function OnTick()
    for i, v in pairs(admins) do

        local dyn = get_dynamic_player(i)
        if (dyn ~= 0 and player_alive(i)) then

            local px, py, pz, cx, cy, cz = GetCamXYZ(dyn)
            local ignore_player = read_dword(get_player(i) + 0x34)
            local success, _, _, _, target = intersect(px, py, pz, cx * 1000, cy * 1000, cz * 1000, ignore_player)

            if (success and target) then

                local shooting = read_float(dyn + 0x490)
                if (shooting ~= v.click and shooting == 1) then
                    local object = get_object_memory(target)
                    if (object ~= 0) then

                        local type = read_byte(object + 0xB4)
                        local name = read_string(read_dword(read_word(object) * 32 + 0x40440038))
                        local meta = read_dword(object)
                        local ox, oy, oz = read_vector3d(object + 0x5C)

                        type = (type == 0 and 'bipd') or (type == 1 and 'vehi') or (type == 2 and 'eqip') or 'weap'
                        Tell(i, type, name, meta, ox, oy, oz)
                    end
                end

                v.click = shooting
            end
        end
    end
end

function OnCommand(Ply, CMD)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    if (CMD:sub(1, #command):lower() == command) then
        if (lvl < permission_level) then
            rprint(Ply, 'You do not have permission to execute that command')
        elseif (not admins[Ply]) then
            admins[Ply] = { click = 0 }
            rprint(Ply, 'Get Object mode enabled')
        else
            admins[Ply] = nil
            rprint(Ply, 'Get Object mode disabled')
        end
        return false
    end
end

function OnScriptUnload()
    -- N/A
end
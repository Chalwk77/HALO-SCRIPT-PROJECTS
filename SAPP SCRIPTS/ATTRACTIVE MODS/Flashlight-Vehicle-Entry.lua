--[[
--=====================================================================================================--
Script Name: Flashlight Entry, for SAPP (PC & CE)
Description: Aim your reticle at an unoccupied vehicle and press your flashlight key to enter it.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local vehicles = {

    --
    -- Set to false to disable flashlight entry for that vehicle:
    --

    ['vehicles\\ghost\\ghost_mp'] = true,
    ['vehicles\\rwarthog\\rwarthog'] = true,
    ['vehicles\\banshee\\banshee_mp'] = true,
    ['vehicles\\warthog\\mp_warthog'] = true,
    ['vehicles\\scorpion\\scorpion_mp'] = true,
    ['vehicles\\c gun turret\\c gun turret_mp'] = true
}
-- config ends --

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

local players = {}

function OnJoin(Ply)
    players[Ply] = { flashlight = 0 }
end

function OnQuit(Ply)
    players[Ply] = nil
end

local function GetCamera(dyn)
    local x = read_float(dyn + 0x230) * 1000
    local y = read_float(dyn + 0x234) * 1000
    local z = read_float(dyn + 0x238) * 1000
    return x, y, z
end

local function GetXYZ(dyn)
    local couching = read_float(dyn + 0x50C)
    local px, py, pz = read_vector3d(dyn + 0x5c)
    if (couching == 0) then
        pz = pz + 0.65
    else
        pz = pz + (0.35 * couching)
    end
    return px, py, pz
end

local function Occupied(obj)
    for i = 1, 16 do
        local dyn = get_dynamic_player(i)
        if (player_present(i) and player_alive(i) and dyn ~= 0) then
            local vehicle = read_dword(dyn + 0x11C)
            local object = get_object_memory(vehicle)
            if (object ~= 0 and vehicle ~= 0xFFFFFFFF and object == obj) then
                return true
            end
        end
    end
    return false
end

local function Valid(o)
    return (vehicles[read_dword(o)] and not Occupied(o))
end

local function Intersecting(px, py, pz, cx, cy, cz, Ply)
    local ignore = read_dword(get_player(Ply) + 0x34)
    local success, _, _, _, map_object = intersect(px, py, pz, cx, cy, cz, ignore)
    local object = get_object_memory(map_object)
    if (object ~= 0 and Valid(object)) then
        return (success and map_object) or nil
    end
end

function OnTick()
    for i, v in pairs(players) do
        local dyn = get_dynamic_player(i)
        if (i and dyn ~= 0 and player_alive(i)) then

            local px, py, pz = GetXYZ(dyn)
            local cx, cy, cz = GetCamera(dyn)

            local flashlight = read_bit(dyn + 0x208, 4)
            local vehicle = Intersecting(px, py, pz, cx, cy, cz, i)
            if (vehicle and flashlight ~= v.flashlight and flashlight == 1) then
                enter_vehicle(vehicle, i, 0)
            end

            v.flashlight = flashlight
        end
    end
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return (Tag ~= 0 and read_dword(Tag + 0xC)) or nil
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        local t = {}
        for k, v in pairs(vehicles) do
            local tag = GetTag('vehi', k)
            if (tag) then
                t[tag] = v
            end
        end
        vehicles = t

        players = {}
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnScriptUnload()
    -- N/A
end
--[[
--=====================================================================================================--
Script Name: Deployable Mines, for SAPP (PC & CE)
Description: Deploy super-explosive mines while driving.
             To Deploy a mine, press your flashlight key.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

local Mines = {

    -- The number of mines players will spawn with:
    --
    mines_per_life = 20,

    -- Time (in seconds) until a mine despawns:
    --
    despawn_rate = 60,

    -- Trigger explosion when player is <= this many w/units
    --
    radius = 0.7,

    -- vehicle tag paths --
    -- Set to false to disable vehicle dispensing:
    --
    vehicles = {
        ['vehicles\\ghost\\ghost_mp'] = true,
        ['vehicles\\rwarthog\\rwarthog'] = true,
        ['vehicles\\warthog\\mp_warthog'] = true,
        ['vehicles\\banshee\\banshee_mp'] = true,
        ['vehicles\\scorpion\\scorpion_mp'] = false,
        ['vehicles\\c gun turret\\c gun turret_mp'] = false
    }
}

-- config ends --

local players = { }
local time = os.time
local sqrt = math.sqrt

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

function EditRocket(rollback)
    for address, v in pairs(Mines.jpt) do
        if (not rollback) then
            write_dword(address, v[1])
        else
            write_dword(address, v[2])
        end
    end
end

function Mines:NewPlayer(o)

    setmetatable(o, self)
    self.__index = self

    o.meta = 0
    o.flashlight = 0
    o.mines = self.mines_per_life

    return o
end

function Mines:NewMine(pos)

    local max = self.mines_per_life
    local Ply = self.pid

    if (self.mines == 0) then
        rprint(Ply, "No more mines for this life!")
        return
    end

    local x, y, z = pos.x, pos.y, pos.z
    local mine = spawn_object('', '', x, y, z, 0, self.mine)
    self.objects[mine] = {
        owner = Ply,
        expiration = time() + self.despawn_rate,
        destroy = function(m, mx, my, mz)

            destroy_object(m)
            Mines.objects[m] = nil

            if (mx) then
                EditRocket()
                local rocket = spawn_projectile(self.rocket, 0, mx, my, mz)
                local object = get_object_memory(rocket)
                write_float(object + 0x68, 0)
                write_float(object + 0x6C, 0)
                write_float(object + 0x70, -9999)
                timer(1000, "EditRocket", "true")
            end
        end
    }

    self.mines = self.mines - 1
    rprint(Ply, 'Mine Deployed! ' .. self.mines .. '/' .. max)
end

local function GetPos(DyN)
    local pos = { }

    local VehicleID = read_dword(DyN + 0x11C)
    local vehicle = get_object_memory(VehicleID)

    if (VehicleID == 0xFFFFFFFF) then
        pos.x, pos.y, pos.z = read_vector3d(DyN + 0x5c)
    elseif (vehicle ~= 0) then
        pos.vehicle = vehicle
        pos.seat = read_word(DyN + 0x2F0)
        pos.x, pos.y, pos.z = read_vector3d(vehicle + 0x5c)
    end

    return pos
end

local function Dist(x1, y1, z1, x2, y2, z2)
    return sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
end

function OnTick()
    for i, v in pairs(players) do
        if (v) then

            local DyN = get_dynamic_player(i)
            if (player_alive(i) and DyN ~= 0) then
                local flashlight = read_bit(DyN + 0x208, 4)
                if (v.flashlight ~= flashlight and flashlight == 1) then
                    v:NewMine(GetPos(DyN))
                end
                v.flashlight = flashlight
            end

            for mine, t in pairs(v.objects) do
                if (time() >= t.expiration) then
                    t.destroy(mine)
                elseif (t.owner ~= i and player_alive(i) and DyN ~= 0) then
                    local pos = GetPos(DyN)
                    local object = get_object_memory(mine)
                    if (object ~= 0) then
                        local mx, my, mz = read_vector3d(object + 0x5C)
                        if Dist(pos.x, pos.y, pos.z, mx, my, mz) <= v.radius then
                            t.destroy(mine, mx, my, mz)
                        end
                    end
                end
            end
        end
    end
end

function OnJoin(Ply)
    players[Ply] = Mines:NewPlayer({
        pid = Ply,
        name = get_var(Ply, '$name')
    })
end

function OnQuit(Ply)
    for mine, t in pairs(Mines.objects) do
        if (t.owner == Ply) then
            t.destroy(mine)
        end
    end
end

function OnSpawn(Ply)
    players[Ply].mines = Mines.mines_per_life
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return (Tag ~= 0 and read_dword(Tag + 0xC)) or nil
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        Mines.mine = GetTag('eqip', 'powerups\\health pack')
        Mines.rocket = GetTag('proj', 'weapons\\rocket launcher\\rocket')
        Mines.rocket_explosion = GetTag('jpt!', 'weapons\\rocket launcher\\explosion')

        if (Mines.mine and Mines.rocket and Mines.rocket_explosion) then

            Mines.jpt = {}
            Mines.objects = {}

            local tag_count = read_dword(0x4044000C)
            local tag_address = read_dword(0x40440000)

            for i = 0, tag_count - 1 do
                local tag = tag_address + 0x20 * i
                local tag_name = read_string(read_dword(tag + 0x10))
                local tag_class = read_dword(tag)
                if (tag_class == 1785754657 and tag_name == 'weapons\\rocket launcher\\explosion') then
                    local tag_data = read_dword(tag + 0x14)
                    Mines.jpt = {
                        [tag_data + 0x1d0] = { 1148846080, 1117782016 },
                        [tag_data + 0x1d4] = { 1148846080, 1133903872 },
                        [tag_data + 0x1d8] = { 1148846080, 1134886912 },
                        [tag_data + 0x1f4] = { 1092616192, 1086324736 }
                    }
                    break
                end
            end

            for i = 1, 16 do
                if player_present(i) then
                    OnJoin(i)
                end
            end

            register_callback(cb['EVENT_JOIN'], 'OnJoin')
            register_callback(cb['EVENT_TICK'], 'OnTick')
            register_callback(cb['EVENT_LEAVE'], 'OnQuit')
            register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
            return
        end

        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb['EVENT_LEAVE'])
        unregister_callback(cb['EVENT_SPAWN'])
    end
end

function OnScriptUnload()
    -- N/A
end
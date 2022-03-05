--[[
--=====================================================================================================--
Script Name: Deployable Mines, for SAPP (PC & CE)
Description: Deploy super-explosive mines (disguised as health packs) while driving.
             To Deploy a mine, press your flashlight key.

             When an enemy walks/drives over them they explode.
             You cannot die by your own mines.
             Mines despawn after 60 seconds (by default).
             Deploy using your flashlight key.

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

    --[[

    Available object tags that can represent mines:
    Default: 'powerups\\health pack'

    'powerups\\active camouflage'
    'powerups\\health pack'
    'powerups\\over shield'
    'powerups\\double speed'
    'powerups\\full-spectrum vision'
    'weapons\\frag grenade\\frag grenade'
    'weapons\\plasma grenade\\plasma grenade'
    'powerups\\needler ammo\\needler ammo'
    'powerups\\assault rifle ammo\\assault rifle ammo'
    'powerups\\pistol ammo\\pistol ammo'
    'powerups\\rocket launcher ammo\\rocket launcher ammo'
    'powerups\\shotgun ammo\\shotgun ammo'
    'powerups\\sniper rifle ammo\\sniper rifle ammo'
    'powerups\\flamethrower ammo\\flamethrower ammo'

    ]]
    mine_object = { 'eqip', 'powerups\\health pack' },

    -- Tags used ot simulate an explosion:
    --
    mine_explosion_projectile = { 'proj', 'weapons\\rocket launcher\\rocket' },
    mine_explosion_tag = { 'jpt!', 'weapons\\rocket launcher\\explosion' },


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
    },

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished:
    server_prefix = "**SAPP**"
    --
}

-- config ends --

local players = { }
local time = os.time
local sqrt = math.sqrt
local dma_original, dma
local ffa, falling, distance

api_version = '1.12.0.0'

local function DisableDeathMessages()
    dma = sig_scan("8B42348A8C28D500000084C9") + 3
    dma_original = read_dword(dma)
    safe_write(true)
    write_dword(dma, 0x03EB01B1)
    safe_write(false)
end

local function EnableDeathMessages()
    safe_write(true)
    write_dword(dma, dma_original)
    safe_write(false)
end

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
    o.killer = 0
    o.flashlight = 0
    o.mines = self.mines_per_life

    return o
end

local function CorrectVehicle(self, vehicle)
    for tag, enabled in pairs(self.vehicles) do
        if (enabled and read_string(read_dword(read_word(vehicle) * 32 + 0x40440038)) == tag) then
            return true
        end
    end
    return false
end

function Mines:NewMine(pos)

    if (self.mines == 0) then
        rprint(self.pid, "No more mines for this life!")
        return
    elseif (pos.seat) then

        if (pos.seat ~= 0) then
            rprint(self.pid, 'You must be in the drivers seat')
            return
        elseif (not CorrectVehicle(self, pos.vehicle)) then
            rprint(self.pid, 'This vehicle cannot deploy mines')
            return
        end

        local x, y, z = pos.x, pos.y, pos.z
        local mine = spawn_object('', '', x, y, z, 0, self.mine)
        self.objects[mine] = {

            owner = self.pid,
            expiration = time() + self.despawn_rate,

            destroy = function(m, mx, my, mz)

                destroy_object(m)
                Mines.objects[m] = nil

                if (mx) then
                    EditRocket()
                    local rocket = spawn_projectile(self.projectile, 0, mx, my, mz)
                    local object = get_object_memory(rocket)
                    write_float(object + 0x68, 0)
                    write_float(object + 0x6C, 0)
                    write_float(object + 0x70, -9999)
                    timer(1000, "EditRocket", "true")
                end
            end
        }

        self.mines = self.mines - 1
        rprint(self.pid, 'Mine Deployed! ' .. self.mines .. '/' .. self.mines_per_life)
    end
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
                    local object = get_object_memory(mine)
                    if (object ~= 0) then
                        local pos = GetPos(DyN)
                        local mx, my, mz = read_vector3d(object + 0x5C)
                        if Dist(pos.x, pos.y, pos.z, mx, my, mz) <= v.radius then
                            v.killer = t.owner
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
        name = get_var(Ply, '$name'),
        team = get_var(Ply, '$team')
    })
end

function OnQuit(Ply)
    for mine, t in pairs(Mines.objects) do
        if (t.owner == Ply) then
            t.destroy(mine)
        end
    end
end

function CheckDamage(Victim, Killer, MetaID, _, _)

    local killer, victim = tonumber(Killer), tonumber(Victim)

    local v = players[victim]
    if (v) then

        -- event_damage_application:
        if (MetaID) then
            v.meta = MetaID
        else

            -- event_die:
            local k = players[killer]
            local mine_k = players[v.killer]

            local squashed = (killer == 0)
            local guardians = (killer == nil)
            local suicide = (killer == victim)
            local pvp = (killer > 0 and killer ~= victim)
            local fell = (v.meta_id == falling or v.meta_id == distance)
            local betrayal = (k and not ffa and (v.team == k.team and killer ~= victim))

            execute_command("msg_prefix \"\"")
            if (v.meta == Mines.explosion and mine_k) then
                say_all(v.name .. " was blown up by " .. mine_k.name .. "'s mine!")
            elseif (guardians) then
                say_all(v.name .. ' killed by guardians')
            elseif (suicide) then
                say_all(v.name .. ' committed suicide')
            elseif (fell or squashed) then
                say_all(v.name .. ' died')
            elseif (betrayal) then
                say_all(v.name .. ' was betrayed by ' .. k.name)
            elseif (pvp) then
                say_all(v.name .. ' was killed by ' .. k.name)
            end
            execute_command("msg_prefix \" **" .. Mines.server_prefix .. "**\"")
        end
    end
end

function OnSpawn(Ply)
    players[Ply].meta = 0
    players[Ply].killer = 0
    players[Ply].mines = Mines.mines_per_life
end

function OnSwitch(Ply)
    players[Ply].team = get_var(Ply, '$team')
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return (Tag ~= 0 and read_dword(Tag + 0xC)) or nil
end

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        Mines.mine = GetTag(Mines.mine_object[1], Mines.mine_object[2])
        Mines.explosion = GetTag(Mines.mine_explosion_tag[1], Mines.mine_explosion_tag[2])
        Mines.projectile = GetTag(Mines.mine_explosion_projectile[1], Mines.mine_explosion_projectile[2])

        if (Mines.mine and Mines.explosion and Mines.projectile) then

            -- May not work on all maps:
            --
            falling = GetTag('jpt!', 'globals\\falling')
            distance = GetTag('jpt!', 'globals\\distance')
            --

            ffa = (get_var(0, '$ffa') == '1')

            Mines.jpt = {}
            Mines.objects = {}

            local tag_count = read_dword(0x4044000C)
            local tag_address = read_dword(0x40440000)

            for i = 0, tag_count - 1 do
                local tag = tag_address + 0x20 * i
                local tag_name = read_string(read_dword(tag + 0x10))
                local tag_class = read_dword(tag)
                if (tag_class == 1785754657 and tag_name == Mines.mine_explosion_tag[2]) then
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

            DisableDeathMessages()

            register_callback(cb['EVENT_JOIN'], 'OnJoin')
            register_callback(cb['EVENT_TICK'], 'OnTick')
            register_callback(cb['EVENT_LEAVE'], 'OnQuit')
            register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
            register_callback(cb["EVENT_DIE"], 'CheckDamage')
            register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
            register_callback(cb["EVENT_DAMAGE_APPLICATION"], 'CheckDamage')
            return
        end

        EnableDeathMessages()
        unregister_callback(cb["EVENT_DIE"])
        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb['EVENT_LEAVE'])
        unregister_callback(cb['EVENT_SPAWN'])
        unregister_callback(cb['EVENT_TEAM_SWITCH'])
        unregister_callback(cb["EVENT_DAMAGE_APPLICATION"])
    end
end

function OnScriptUnload()
    EnableDeathMessages()
end
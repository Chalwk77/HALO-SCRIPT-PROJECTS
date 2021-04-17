--[[
--=====================================================================================================--
Script Name: Dispensable-Mines, for SAPP (PC & CE)
Description: Dispense mines while driving!
             You can toggle mine dispensing on a per-vehicle basis (see config)

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Configuration Starts --
local Mines = {

    -- The number of mines players will spawn with:
    mines_per_life = 20,
    --

    -- Time (in seconds) until a mine despawns:
    despawn_rate = 60,
    --

    -- Trigger explosion when player is <= this many w/units
    trigger_radius = 0.7,
    --

    -- Mines are represented by this object:
    object = { "eqip", "powerups\\health pack" },
    --

    -- vehicle tag paths --
    -- Set to false to disable vehicle dispensing on per-vehicle basis:
    vehicles = {
        ["vehicles\\ghost\\ghost_mp"] = true,
        ["vehicles\\rwarthog\\rwarthog"] = true,
        ["vehicles\\warthog\\mp_warthog"] = true,
        ["vehicles\\banshee\\banshee_mp"] = true,
        ["vehicles\\scorpion\\scorpion_mp"] = true,
        ["vehicles\\c gun turret\\c gun turret_mp"] = true
    }
    --
}

-- Configuration Ends --

local team_play
local rocket_meta
local sqrt = math.sqrt
local time_scale = 1 / 30
local tag_count, tag_address

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "CheckDamage")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "CheckDamage")
    OnGameStart()
end

function Mines:InitPlayer(Ply, Reset)

    if (not Reset) then
        self.players[Ply] = {
            key = nil,
            damage_meta = nil,
            killer = nil,
            mines = self.mines_per_life,
            name = get_var(Ply, "$name"),
        }
        return
    end

    self.players[Ply] = nil
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return (Tag ~= 0 and read_dword(Tag + 0xC)) or nil
end

local function TagName(TAG)
    if (TAG ~= nil and TAG ~= 0) then
        return read_string(read_dword(read_word(TAG) * 32 + 0x40440038))
    end
    return ""
end

function Mines:Init()

    self.game_in_progress = false

    if (get_var(0, "$gt") ~= "n/a") then

        tag_count = read_dword(0x4044000C)
        tag_address = read_dword(0x40440000)

        self.game_in_progress = true

        team_play = (get_var(0, "$ffa") == "0") or false
        rocket_meta = GetTag("jpt!", "weapons\\rocket launcher\\explosion")

        self:ClearAllMines()
        self.players = { }

        for i = 1, 16 do
            if player_present(i) then
                self:InitPlayer(i, false)
            end
        end
    end
end

function OnGameStart()
    Mines:Init()
end

function OnGameEnd()
    Mines.game_in_progress = false
    Mines:ClearAllMines()
end

local function GetPos(DyN)
    local pos = { }

    local VehicleID = read_dword(DyN + 0x11C)
    local Object = get_object_memory(VehicleID)

    if (VehicleID == 0xFFFFFFFF) then
        pos.x, pos.y, pos.z = read_vector3d(DyN + 0x5c)
    elseif (Object ~= 0) then
        pos.object = Object
        pos.seat = read_word(DyN + 0x2F0)
        pos.x, pos.y, pos.z = read_vector3d(Object + 0x5c)
    end

    return pos
end

function Mines:NewMine(Ply, X, Y, Z)

    local mine = spawn_object(self.object[1], self.object[2], X, Y, Z)
    local object = get_object_memory(mine)

    self.mines[mine] = {
        x = X,
        y = Y,
        z = Z,
        timer = 0,
        owner = Ply,
        object = object
    }

    local mines_left = self.players[Ply].mines
    rprint(Ply, "Mine Deployed! " .. mines_left .. "/" .. self.mines_per_life)
end

function Mines:InProximity(px, py, pz, mx, my, mz)
    return sqrt((px - mx) ^ 2 + (py - my) ^ 2 + (pz - mz) ^ 2) <= self.trigger_radius
end

function Mines:OnTick()

    if (self.game_in_progress) then

        for i, v in pairs(self.players) do

            local DyN = get_dynamic_player(i)
            if (player_alive(i) and DyN ~= 0) then
                local key = read_bit(DyN + 0x208, 4)
                if (self.key ~= key and key == 1) then
                    if (v.mines > 0) then
                        local pos = GetPos(DyN)
                        if (pos.seat and pos.seat == 0) then
                            for tag, enabled in pairs(self.vehicles) do
                                if (TagName(pos.object) == tag and enabled) then
                                    pos.in_vehicle = true
                                    v.mines = v.mines - 1
                                    self:NewMine(i, pos.x, pos.y, pos.z)
                                    break
                                end
                            end
                        end
                    else
                        rprint(i, "You have 0 mines left for this life!")
                    end
                end
                self.key = key
            end
        end

        for k, v in pairs(self.mines) do

            v.timer = v.timer + time_scale
            if (v.timer >= self.despawn_rate) then
                self:Destroy(k)
            else

                local object = get_object_memory(k)
                if (object ~= 0) then

                    if (not player_present(v.owner)) then
                        self:Destroy(k)
                    else

                        local mx, my, mz = read_vector3d(object + 0x5c)
                        v.x, v.y, v.z = mx, my, mz
                        for i, Ply in pairs(self.players) do

                            if (i ~= v.owner) then

                                local DyN = get_dynamic_player(i)
                                if (player_alive(i) and DyN ~= 0) then

                                    local pos = GetPos(DyN)
                                    if self:InProximity(pos.x, pos.y, pos.z, v.x, v.y, v.z) then
                                        if (not team_play or get_var(i, "$team") ~= get_var(v.owner, "$team")) then

                                            EditRocket(false)

                                            local tag = GetTag("proj", "weapons\\rocket launcher\\rocket")

                                            local projectile = spawn_projectile(tag, i, v.x, v.y, v.z)
                                            local proj_obj = get_object_memory(projectile)

                                            write_float(proj_obj + 0x68, 0)
                                            write_float(proj_obj + 0x6C, 0)
                                            write_float(proj_obj + 0x70, -9999)
                                            timer(1000, "EditRocket", "true")

                                            Ply.killer = v.owner
                                            self:Destroy(k)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function Mines:Destroy(mine)
    destroy_object(mine)
    self.mines[mine] = nil
end

function Mines:ClearAllMines()
    self.mines = self.mines or { }
    for k, _ in pairs(self.mines) do
        destroy_object(k)
    end
    self.mines = { }
end

function OnPlayerJoin(Ply)
    Mines:InitPlayer(Ply, false)
end

function Mines:OnPlayerSpawn(Ply)
    if (self.players and self.players[Ply]) then
        self.players[Ply].key = nil
        self.players[Ply].killer = nil
        self.players[Ply].damage_meta = nil
        self.players[Ply].mines = self.mines_per_life
    end
end

function OnPlayerQuit(Ply)
    Mines:InitPlayer(Ply, true)
end

function Mines:CheckDamage(Ply, Server, MetaID, _, _)
    Server = tonumber(Server)

    if (self.players and self.players[Ply]) then
        if (Server == 0 and MetaID) then
            self.players[Ply].damage_meta = MetaID
        elseif (Server < 0 and self.players[Ply].damage_meta == rocket_meta) then
            local KID = self.players[Ply].killer
            if (KID) then
                local name = self.players[Ply].name
                local k_name = self.players[KID].name
                say_all(name .. " was blown up by " .. k_name .. "'s mine!")
            end
        end
    end
end

function EditRocket(rollback)
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if (tag_class == 1785754657 and tag_name == "weapons\\rocket launcher\\explosion") then
            local tag_data = read_dword(tag + 0x14)
            if (not rollback) then
                write_dword(tag_data + 0x1d0, 1148846080)
                write_dword(tag_data + 0x1d4, 1148846080)
                write_dword(tag_data + 0x1d8, 1148846080)
                write_dword(tag_data + 0x1f4, 1092616192)
            else
                write_dword(tag_data + 0x1d0, 1117782016)
                write_dword(tag_data + 0x1d4, 1133903872)
                write_dword(tag_data + 0x1d8, 1134886912)
                write_dword(tag_data + 0x1f4, 1086324736)
            end
            break
        end
    end
end

function OnScriptUnload()
    Mines:ClearAllMines()
end

function OnTick()
    return Mines:OnTick()
end
function CheckDamage(V, C, M)
    return Mines:CheckDamage(V, C, M)
end
function OnPlayerSpawn(Ply)
    return Mines:OnPlayerSpawn(Ply)
end

return Mines
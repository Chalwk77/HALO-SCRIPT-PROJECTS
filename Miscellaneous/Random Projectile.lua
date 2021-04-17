--[[
--=====================================================================================================--
Script Name: Random Projectiles, for SAPP (PC & CE)
Description: Random Projectile Spawner

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
--=====================================================================================================--
]]--

local proj = {
    "vehicles\\banshee\\banshee bolt",
    "vehicles\\c gun turret\\mp gun turret",
    "vehicles\\ghost\\ghost bolt",
    "vehicles\\scorpion\\bullet",
    "vehicles\\warthog\\bullet",
    "weapons\\assault rifle\\bullet",
    "weapons\\flamethrower\\flame",
    "weapons\\needler\\mp_needle",
    "weapons\\needler\\needle",
    "weapons\\pistol\\bullet",
    "weapons\\plasma pistol\\bolt",
    "weapons\\plasma rifle\\bolt",
    "weapons\\plasma rifle\\charged bolt",
    "weapons\\shotgun\\pellet",
    "weapons\\sniper rifle\\sniper bullet",
    "weapons\\plasma_cannon\\plasma_cannon",
    "weapons\\rocket launcher\\rocket",
    "vehicles\\banshee\\mp_banshee fuel rod",
    "vehicles\\scorpion\\tank shell"
}

local projectiles
local time_scale = 1 / 30

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_OBJECT_SPAWN"], "OnObjectSpawn")
    OnGameStart()
end

local function CleanUpDrones(TIndex, Obj)

    projectiles = projectiles or { }

    if (TIndex) then
        destroy_object(Obj)
        projectiles[TIndex] = nil
        return
    end

    for _, v in pairs(projectiles) do
        destroy_object(v[1])
    end

    projectiles = { }
end

function OnGameStart()
    CleanUpDrones()
end

local function Tag(Type, Name)
    local tag_id = lookup_tag(Type, Name)
    return (tag_id ~= 0 and read_dword(tag_id + 0xC)) or nil
end

local function TagName(TAG)
    if (TAG ~= nil and TAG ~= 0) then
        return read_string(read_dword(read_word(TAG) * 32 + 0x40440038))
    end
    return ""
end

local function HoldingGRifle(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local Weapon = get_object_memory(read_dword(DyN + 0x118))
        if (Weapon ~= 0 and TagName(Weapon) == "weapons\\gravity rifle\\gravity rifle") then
            return true
        end
    end
    return false
end

local function SpawnObject(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0 and player_alive(Ply)) then

        local xAim = math.sin(read_float(DyN + 0x230))
        local yAim = math.sin(read_float(DyN + 0x234))
        local zAim = math.sin(read_float(DyN + 0x238))

        local px, py, pz = read_vector3d(DyN + 0x5c)
        local distance = 3

        local x = px + distance * xAim
        local y = py + distance * yAim
        local z = pz + distance * zAim

        math.randomseed(os.clock())
        math.random();
        math.random();
        math.random();

        local tag = Tag("proj", proj[math.random(1, #proj)])
        if (tag) then
            local projectile = spawn_projectile(tag, Ply, x, y, z + 0.3)
            local obj = get_object_memory(projectile)
            if (obj ~= 0) then
                local velocity = math.random(0.1, 0.6)
                write_float(obj + 0x68, velocity * xAim)
                write_float(obj + 0x6C, velocity * yAim)
                write_float(obj + 0x70, velocity * zAim)
                projectiles[#projectiles + 1] = { projectile, obj, timer = 0 }
            end
        end
    end
end

function OnObjectSpawn(Ply, MapID)
    if (Ply and not HoldingGRifle(Ply)) then
        if (MapID == Tag("proj", "weapons\\flamethrower\\flame")) then
            return false, SpawnObject(Ply)
        end
    end
end

function OnTick()
    for k, v in pairs(projectiles) do
        v.timer = v.timer + time_scale
        if (v.timer >= 5) then
            CleanUpDrones(k, v[1])
        end
    end
end

function OnScriptUnload()
    -- N/A
end

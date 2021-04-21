--[[
--=====================================================================================================--
Script Name: Random Projectiles, for SAPP (PC & CE)
Description: While using the flamethrower, a random projectile will be spawned
             with a random velocity between 0.1-0.6.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local proj = {
    "vehicles\\scorpion\\tank shell",
    "weapons\\rocket launcher\\rocket",
    "weapons\\sniper rifle\\sniper bullet",
    "weapons\\plasma_cannon\\plasma_cannon",
    "vehicles\\banshee\\mp_banshee fuel rod"
}

local weapons = {
    ["weapons\\pistol\\pistol"] = false,
    ["weapons\\shotgun\\shotgun"] = false,
    ["weapons\\needler\\mp_needler"] = false,
    ["weapons\\plasma rifle\\plasma rifle"] = true,
    ["weapons\\sniper rifle\\sniper rifle"] = false,
    ["weapons\\flamethrower\\flamethrower"] = false,
    ["weapons\\plasma_cannon\\plasma_cannon"] = false,
    ["weapons\\plasma pistol\\plasma pistol"] = false,
    ["weapons\\assault rifle\\assault rifle"] = false,
    ["weapons\\rocket launcher\\rocket launcher"] = false,
}

local players
local projectiles
local time_scale = 1 / 30

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_OBJECT_SPAWN"], "OnObjectSpawn")
    OnGameStart()
end

local function InitPlayer(Ply, Reset)
    if (not Reset) then
        players[Ply] = { fire = nil }
    end
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
    if (get_var(0, "$gt") ~= "n/a") then
        players = { }
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

function OnPlayerJoin(Ply)
    InitPlayer(Ply, false)
end

function OnPlayerQuit(Ply)
    InitPlayer(Ply, true)
end

local function Tag(Type, Name)
    local tag_id = lookup_tag(Type, Name)
    return (tag_id ~= 0 and read_dword(tag_id + 0xC)) or nil
end

local function SpawnObject(Ply, DyN)

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
        local projectile = spawn_projectile(tag, Ply, x, y, z)
        local obj = get_object_memory(projectile)
        if (obj ~= 0) then
            local velocity = 1
            write_float(obj + 0x68, velocity * xAim)
            write_float(obj + 0x6C, velocity * yAim)
            write_float(obj + 0x70, velocity * zAim)
            projectiles[#projectiles + 1] = { projectile, obj, timer = 0 }
        end
    end
end

local function TagName(OBJ)
    if (OBJ ~= nil and OBJ ~= 0) then
        return read_string(read_dword(read_word(OBJ) * 32 + 0x40440038))
    else
        return ""
    end
end

local function HoldingWeapon(DyN, TagID)
    local WeaponID = read_dword(DyN + 0x118)
    local WeaponObj = get_object_memory(WeaponID)
    return (WeaponObj ~= 0 and TagName(WeaponObj) == TagID) or false
end

function OnObjectSpawn(Ply)
    if (Ply and player_alive(Ply)) then
        local DyN = get_dynamic_player(Ply)
        if (DyN ~= 0) then
            for TagID, enabled in pairs(weapons) do
                if (enabled) and HoldingWeapon(DyN, TagID) then
                    return false, SpawnObject(Ply, DyN)
                end
            end
        end
    end
end

function OnTick()
    for k, v in pairs(projectiles) do
        local object = get_object_memory(v[1])
        if (object ~= 0) then
            v.timer = v.timer + time_scale
            if (v.timer >= 5) then
                CleanUpDrones(k, v[1])
            end
        else
            CleanUpDrones(k, v[1])
        end
    end
end

function OnScriptUnload()
    -- N/A
end
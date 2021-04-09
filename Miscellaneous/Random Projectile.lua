--[[
--=====================================================================================================--
Script Name: Item Spawner, for SAPP (PC & CE)
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

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_OBJECT_SPAWN"], "OnObjectSpawn")
end

local function Tag(Type, Name)
    local tag_id = lookup_tag(Type, Name)
    return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end

function OnObjectSpawn(Ply, MapID)

    if (Ply) then

        if (MapID == Tag("weap", "weapons\\gravity rifle\\gravity rifle")) then
            return
        end

        if (MapID == Tag("proj", "weapons\\flamethrower\\flame")) then
            return false, SpawnObject(Ply)
        end
    end
end

function SpawnObject(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then

        local xAim = math.sin(read_float(DyN + 0x230))
        local yAim = math.sin(read_float(DyN + 0x234))
        local zAim = math.sin(read_float(DyN + 0x238))

        local px, py, pz = read_vector3d(DyN + 0x5c)
        local distance = 5

        local x = px + distance * xAim
        local y = py + distance * yAim
        local z = pz + distance * zAim

        math.randomseed(os.clock())
        math.random();
        math.random();
        math.random();

        local tag = Tag("proj", proj[math.random(1, #proj)])
        local projectile = spawn_projectile(tag, Ply, x, y, z)

        projectile = get_object_memory(projectile)
        if (projectile ~= 0) then
            write_float(projectile + 0x68, 0.6 * xAim)
            write_float(projectile + 0x6C, 0.6 * yAim)
            write_float(projectile + 0x70, 0.6 * zAim)
        end
    end
end

function OnScriptUnload()
    -- N/A
end

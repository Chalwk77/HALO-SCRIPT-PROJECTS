--[[
--=====================================================================================================--
Script Name: Melee, for SAPP (PC & CE)
Description: Custom Melee game

Copyright (c) 2016-2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE


* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local Melee = {
    -- Configuration [starts] >> ----------
    scorelimit = 50,
    -- Melee Object (weapon index from objects table)"
    weapon = 12,
    objects = {
        -- false = prevent spawning | true = allow spawning
        [1] = { "eqip", "powerups\\health pack", true },
        [2] = { "eqip", "powerups\\over shield", true },
        [3] = { "eqip", "powerups\\active camouflage", true },
        [4] = { "eqip", "weapons\\frag grenade\\frag grenade", false },
        [5] = { "eqip", "weapons\\plasma grenade\\plasma grenade", false },

        [6] = { "vehi", "vehicles\\ghost\\ghost_mp", false },
        [7] = { "vehi", "vehicles\\rwarthog\\rwarthog", false },
        [8] = { "vehi", "vehicles\\banshee\\banshee_mp", false },
        [9] = { "vehi", "vehicles\\warthog\\mp_warthog", false },
        [10] = { "vehi", "vehicles\\scorpion\\scorpion_mp", false },
        [11] = { "vehi", "vehicles\\c gun turret\\c gun turret_mp", false },

        [12] = { "weap", "weapons\\ball\\ball", true }, -- DO NOT DISABLE if this is the melee object.
        [13] = { "weap", "weapons\\flag\\flag", false },
        [14] = { "weap", "weapons\\pistol\\pistol", false },
        [15] = { "weap", "weapons\\shotgun\\shotgun", false },
        [16] = { "weap", "weapons\\needler\\mp_needler", false },
        [17] = { "weap", "weapons\\flamethrower\\flamethrower", false },
        [18] = { "weap", "weapons\\plasma rifle\\plasma rifle", false },
        [19] = { "weap", "weapons\\sniper rifle\\sniper rifle", false },
        [20] = { "weap", "weapons\\plasma pistol\\plasma pistol", false },
        [21] = { "weap", "weapons\\plasma_cannon\\plasma_cannon", false },
        [22] = { "weap", "weapons\\assault rifle\\assault rifle", false },
        [23] = { "weap", "weapons\\rocket launcher\\rocket launcher", false }
    },
    -- Configuration [ends] << ----------

    -- DO NOT TOUCH --
    players = { }
    --
}

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    OnGameStart()
end

function OnScriptUnload()
    -- N/A
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        if (get_var(0, "$ffa") ~= "0") then
            register_callback(cb['EVENT_TICK'], "OnTick")
            register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
            register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
            register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
            register_callback(cb['EVENT_LEAVE'], "OnPlayerDisconnect")
            register_callback(cb['EVENT_WEAPON_DROP'], "OnWeaponDrop")
            register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
            execute_command("disable_all_vehicles 0 1")
            execute_command("scorelimit " .. Melee.scorelimit)
            for i = 1, 16 do
                if player_present(i) then
                    Melee:CleanUpDrones(i, false)
                    Melee:InitPlayer(i, false)
                end
            end
        else
            unregister_callback(cb['EVENT_DIE'])
            unregister_callback(cb['EVENT_TICK'])
            unregister_callback(cb['EVENT_JOIN'])
            unregister_callback(cb['EVENT_LEAVE'])
            unregister_callback(cb['EVENT_SPAWN'])
            unregister_callback(cb['EVENT_WEAPON_DROP'])
            unregister_callback(cb['EVENT_OBJECT_SPAWN'])
        end
    end
end

function OnPlayerConnect(Ply)
    Melee:InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    Melee:InitPlayer(Ply, true)
end

function Melee:InitPlayer(Ply, Reset)
    if (not Reset) then
        self.players[Ply] = { assign = false, drones = {} }
    else
        self:CleanUpDrones(Ply, false)
    end
end

function Melee:OnTick()
    for i, v in pairs(self.players) do
        if player_present(i) and player_alive(i) then
            if (v.assign) then
                v.assign = false
                execute_command("nades " .. i .. " 0")
                execute_command("wdel " .. i)
                local DyN = get_dynamic_player(i)
                if (DyN ~= 0) then
                    local x, y, z = read_vector3d(DyN + 0x5C)
                    local weapon = spawn_object("weap", self.objects[self.weapon][2], x, y, z)
                    assign_weapon(weapon, i)
                    table.insert(v.drones, weapon)
                end
            end
        end
    end
end

function OnPlayerSpawn(Ply)
    Melee.players[Ply].assign = true
end

function OnPlayerDeath(Victim)
    local DyN = get_dynamic_player(Victim)
    local WeaponID = read_dword(DyN + 0x118)
    if (WeaponID ~= 0) then
        for j = 0, 3 do
            destroy_object(read_dword(DyN + 0x2F8 + j * 4))
        end
    end
end

function Melee:CleanUpDrones(Ply, Assign)

    for _, weapon in pairs(self.players[Ply].drones) do
        if (weapon) then
            destroy_object(weapon)
        end
    end

    if (Assign) then
        self.players[Ply].assign = true
    else
        self.players[Ply] = nil
    end
end

function OnWeaponDrop(Ply)
    Melee:CleanUpDrones(Ply, true)
end

local function GetTag(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function OnObjectSpawn(_, MapID, _, _)
    for _, v in pairs(Melee.objects) do
        if (MapID == GetTag(v[1], v[2])) and (not v[3]) then
            return false
        end
    end
end

function OnTick()
    return Melee:OnTick()
end

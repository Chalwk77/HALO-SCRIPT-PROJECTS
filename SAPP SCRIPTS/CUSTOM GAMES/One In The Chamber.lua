--[[
--=====================================================================================================--
Script Name: One In The Chamber (v1.1), for SAPP (PC & CE)
Description: Each player is given a pistol - and only a pistol - with one bullet. 
             Use it wisely. Every shot kills. 
             If you miss, you're limited to Melee-Combat. 
             Every time you kill a player, you get a bullet. 
             Success requires a combination of precision and reflexes. Know when to go for the shot or close in for the kill.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

--====================================== --
-- Configuration [STARTS]
--====================================== --
local starting_primary_ammo = 1
local starting_secondary_ammo = 0
local ammo_per_kill = 1
local starting_frags = 0
local starting_plasmas = 0
local weapon = "weapons\\pistol\\pistol"
local hud_message = "Bullets: %count%"

local disable_vehicles = true
local disable_weapon_pickups = true
local disable_grenade_pickups = true
local remove_grenades_on_spawn = true

-- Damage Multipliers --
local multipliers = {
    -- TAG NAME | MULTIPLIER (0-9999) - 1 = normal damage
    -- STOCK TAGS --
    melee = {
        { "weapons\\assault rifle\\melee", 1.50 },
        { "weapons\\ball\\melee", 1.50 },
        { "weapons\\flag\\melee", 1.50 },
        { "weapons\\flamethrower\\melee", 1.50 },
        { "weapons\\needler\\melee", 1.50 },
        { "weapons\\pistol\\melee", 1.50 },
        { "weapons\\plasma pistol\\melee", 1.50 },
        { "weapons\\plasma rifle\\melee", 1.50 },
        { "weapons\\rocket launcher\\melee", 1.50 },
        { "weapons\\shotgun\\melee", 1.50 },
        { "weapons\\sniper rifle\\melee", 1.50 },
        { "weapons\\plasma_cannon\\effects\\plasma_cannon_melee", 1.50 },
    },

    grenades = {
        { "weapons\\frag grenade\\explosion", 1.00 },
        { "weapons\\plasma grenade\\explosion", 1.50 },
        { "weapons\\plasma grenade\\attached", 10.0 },
    },

    vehicles = {
        { "vehicles\\ghost\\ghost bolt", 1.015 },
        { "vehicles\\scorpion\\bullet", 1.020 },
        { "vehicles\\warthog\\bullet", 1.025 },
        { "vehicles\\c gun turret\\mp bolt", 1.030 },
        { "vehicles\\banshee\\banshee bolt", 1.035 },
        { "vehicles\\scorpion\\shell explosion", 1.00 },
        { "vehicles\\banshee\\mp_fuel rod explosion", 1.00 },
    },

    projectiles = {
        { "weapons\\pistol\\bullet", 10.0 },
        { "weapons\\plasma rifle\\bolt", 10.0 },
        { "weapons\\shotgun\\pellet", 10.0 },
        { "weapons\\plasma pistol\\bolt", 10.0 },
        { "weapons\\needler\\explosion", 10.0 },
        { "weapons\\assault rifle\\bullet", 10.0 },
        { "weapons\\needler\\impact damage", 10.0 },
        { "weapons\\flamethrower\\explosion", 10.0 },
        { "weapons\\sniper rifle\\sniper bullet", 10.0 },
        { "weapons\\rocket launcher\\explosion", 10.0 },
        { "weapons\\needler\\detonation damage", 10.0 },
        { "weapons\\plasma rifle\\charged bolt", 10.0 },
        { "weapons\\plasma_cannon\\effects\\plasma_cannon_melee", 10.0 },
        { "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion", 10.0 },
    },

    vehicle_collision = {
        { "globals\\vehicle_collision", 1.00 },
    },

    fall_damage = {
        { "globals\\falling", 1.00 },
        { "globals\\distance", 1.00 },
    },
}
--====================================== --
-- Configuration [ENDS]
--====================================== --

-- # Do Not Touch # --
local players, game_over = {}, false
local gsub = string.gsub

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb['EVENT_DIE'], "OnPlayerKill")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")

    if (disable_vehicles) then
        -- Disable all vehicles
        execute_command("disable_all_vehicles 0 1")
    end
    if (disable_weapon_pickups) then
        -- Disable weapon pick ups: 
        execute_command("disable_object 'weapons\\assault rifle\\assault rifle'")
        execute_command("disable_object 'weapons\\flamethrower\\flamethrower'")
        execute_command("disable_object 'weapons\\needler\\mp_needler'")
        execute_command("disable_object 'weapons\\pistol\\pistol'")
        execute_command("disable_object 'weapons\\plasma pistol\\plasma pistol'")
        execute_command("disable_object 'weapons\\plasma rifle\\plasma rifle'")
        execute_command("disable_object 'weapons\\plasma_cannon\\plasma_cannon'")
        execute_command("disable_object 'weapons\\rocket launcher\\rocket launcher'")
        execute_command("disable_object 'weapons\\shotgun\\shotgun'")
        execute_command("disable_object 'weapons\\sniper rifle\\sniper rifle'")
    end
    if (disable_grenade_pickups) then
        -- Disable grenade pick ups:
        execute_command("disable_object 'weapons\\frag grenade\\frag grenade'")
        execute_command("disable_object 'weapons\\plasma grenade\\plasma grenade'")
    end

    if (get_var(0, "$gt") ~= "n/a") then
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, true)
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        players = {}
    end
end

function OnGameEnd()
    game_over = true
end

function OnTick()
    if (not game_over) then
        for i, player in pairs(players) do
            if player_present(i) and player_alive(i) then
                if (player.assign) then
                    local player_object = get_dynamic_player(i)
                    local coords = getXYZ(i, player_object)
                    if (not coords.invehicle) then
                        player.assign = false
                        execute_command("wdel " .. i)
                        assign_weapon(spawn_object("weap", weapon, coords.x, coords.y, coords.z), i)
                        SetAmmo(i, "loaded", starting_primary_ammo)
                        SetAmmo(i, "unloaded", starting_secondary_ammo)
                    end
                end
            end
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function OnPlayerDisconnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnPlayerKill(VictimIndex, KillerIndex)
    if (not game_over) then

        local killer = tonumber(KillerIndex)
        local victim = tonumber(VictimIndex)

        for i, _ in pairs(players) do
            if (i == killer) then
                local ammo = GetAmmo(i, "loaded") + (ammo_per_kill)
                SetAmmo(i, "loaded", ammo)
            elseif (i == victim) then
                InitPlayer(i, true)
            end
        end
    end
end

function GetAmmo(PlayerIndex, Type)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local WeaponID = read_dword(player_object + 0x118)
        if (WeaponID ~= 0) then
            local WeaponObject = get_object_memory(WeaponID)
            if (WeaponObject ~= 0) then
                if (Type == "unloaded") then
                    return read_dword(WeaponObject + 0x2B6)
                elseif (Type == "loaded") then
                    return read_dword(WeaponObject + 0x2B8)
                end
            end
        end
    end
    return 0
end

function SetAmmo(PlayerIndex, Type, Amount)

    for w = 1, 4 do
        if (Type == "unloaded") then
            execute_command("ammo " .. PlayerIndex .. " " .. Amount .. " " .. w)
        elseif (Type == "loaded") then
            execute_command("mag " .. PlayerIndex .. " " .. Amount .. " " .. w)
        end
    end

    cls(PlayerIndex, 25)
    local ammo = GetAmmo(PlayerIndex, "loaded")
    rprint(PlayerIndex, gsub(hud_message, "%%count%%", ammo))

end

function OnPlayerSpawn(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        players[PlayerIndex].assign = true
        if (remove_grenades_on_spawn) then
            write_byte(player_object + 0x31E, starting_frags)
            write_byte(player_object + 0x31F, starting_plasmas)
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
        for Table, _ in pairs(multipliers) do
            for _, Tag in pairs(multipliers[Table]) do
                if Tag[1] then
                    if (MetaID == GetTag("jpt!", Tag[1])) then
                        return true, Damage * Tag[2]
                    end
                end
            end
        end
    end
end

function InitPlayer(PlayerIndex, Init)
    if (Init) then
        players[PlayerIndex] = { assign = false }
    else
        players[PlayerIndex] = nil
    end
end

function getXYZ(PlayerObject)
    local coords, x, y, z = { }

    local VehicleID = read_dword(PlayerObject + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        coords.invehicle = false
        x, y, z = read_vector3d(PlayerObject + 0x5c)
    else
        coords.invehicle = true
        x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end
    coords.x, coords.y, coords.z = x, y, z
    return coords
end

function cls(PlayerIndex, Count)
    Count = Count or 25
    for _ = 1, Count do
        rprint(PlayerIndex, " ")
    end
end

function GetTag(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function OnScriptUnload()
    --
end

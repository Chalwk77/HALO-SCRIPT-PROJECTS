--[[
--=====================================================================================================--
Script Name: One In The Chamber (v1.2), for SAPP (PC & CE)
Description: Each player is given a pistol - and only a pistol - with one bullet.
             Use it wisely. Every shot kills.
             If you miss, you're limited to Melee-Combat.
             Every time you kill a player, you get a bullet.
             Success requires a combination of precision and reflexes. Know when to go for the shot or close in for the kill.

Copyright (c) 2019-2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

--====================================== --
-- Configuration [STARTS]
--====================================== --

local OITC = {

    -- Loaded Ammo (clip):
    starting_primary_ammo = 1,

    -- Unloaded Ammo: (Mag):
    starting_secondary_ammo = 0,

    -- Bullets given per kill:
    ammo_per_kill = 1,

    -- Starting Grenades:
    starting_frags = 0,
    starting_plasmas = 0,

    -- Primary Weapon:
    weapon = "weapons\\pistol\\pistol",

    -- Heads Up Display Message:
    hud_message = "Bullets: %count%",

    -- Miscellaneous Settings:
    disable_vehicles = true,
    disable_weapon_pickups = true,
    disable_grenade_pickups = true,
    remove_grenades_on_spawn = true,
    --===========================================--

    -- DAMAGE MULTIPLIERS | STOCK TAGS --
    -- {tag name, multiplier }
    -- 1 = normal damage

    multipliers = {
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
}
--====================================== --
-- Configuration [ENDS]
--====================================== --

local gsub = string.gsub

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb['EVENT_DIE'], "OnPlayerKill")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    OnGameStart()
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then

        OITC.players = { }
        OITC.game_over = false

        for i = 1, 16 do
            if player_present(i) then
                OITC.players[i] = { assign = true }
            end
        end

        -- Disable all vehicles
        if (OITC.disable_vehicles) then
            execute_command("disable_all_vehicles 0 1")
        end

        -- Disable weapon pick ups:
        if (OITC.disable_weapon_pickups) then
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

        -- Disable grenade pick ups:
        if (OITC.disable_grenade_pickups) then
            execute_command("disable_object 'weapons\\frag grenade\\frag grenade'")
            execute_command("disable_object 'weapons\\plasma grenade\\plasma grenade'")
        end
    end
end

function OnGameEnd()
    OITC.game_over = true
end

local function GetXYZ(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local VehicleID = read_dword(DyN + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            return read_vector3d(DyN + 0x5c)
        end
    end
    return nil
end

local function cls(Ply, Count)
    Count = Count or 25
    for _ = 1, Count do
        rprint(Ply, " ")
    end
end

function OITC:SetAmmo(Ply, Type, Amount)

    for i = 1, 4 do
        if (Type == "unloaded") then
            execute_command("ammo " .. Ply .. " " .. Amount .. " " .. i)
        elseif (Type == "loaded") then
            execute_command("mag " .. Ply .. " " .. Amount .. " " .. i)
        end
    end

    cls(Ply, 25)
    local ammo = OITC:GetAmmo(Ply, "loaded")
    rprint(Ply, gsub(self.hud_message, "%%count%%", ammo))
end

function OITC:OnTick()
    if (not self.game_over) then
        for i, v in pairs(self.players) do
            if player_alive(i) and (v.assign) then
                local x, y, z = GetXYZ(i)
                if (x) then
                    v.assign = false
                    execute_command("wdel " .. i)
                    assign_weapon(spawn_object("weap", self.weapon, x, y, z), i)
                    self:SetAmmo(i, "loaded", self.starting_primary_ammo)
                    self:SetAmmo(i, "unloaded", self.starting_secondary_ammo)
                end
            end
        end
    end
end

function OITC:OnPlayerKill(VictimIndex, KillerIndex)
    if (not self.game_over) then
        local k, v = tonumber(KillerIndex), tonumber(VictimIndex)
        if (k > 0 and k ~= v) then
            local ammo = OITC:GetAmmo(k, "loaded") + (self.ammo_per_kill)
            self:SetAmmo(k, "loaded", ammo)
        end
    end
end

function OITC:GetAmmo(Ply, Type)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local WeaponID = read_dword(DyN + 0x118)
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

function OnPlayerSpawn(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        OITC.players[Ply] = { assign = true }
        if (OITC.remove_grenades_on_spawn) then
            write_byte(DyN + 0x31E, OITC.starting_frags)
            write_byte(DyN + 0x31F, OITC.starting_plasmas)
        end
    end
end

local function GetTag(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function OnDamageApplication(V, C, MetaID, Damage, _, _)
    if (tonumber(C) > 0 and V ~= C) then
        for Table, _ in pairs(OITC.multipliers) do
            for _, Tag in pairs(OITC.multipliers[Table]) do
                if (Tag[1]) then
                    if (MetaID == GetTag("jpt!", Tag[1])) then
                        return true, Damage * Tag[2]
                    end
                end
            end
        end
    end
end

function OnPlayerDisconnect(Ply)
    OITC.players[Ply] = nil
end

function OnScriptUnload()
    -- N/A
end

function OnTick()
    return OITC:OnTick()
end
function OnPlayerKill(V, K)
    return OITC:OnPlayerKill(V, K)
end
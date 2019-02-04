--[[
--=====================================================================================================--
Script Name: Melee, for SAPP (PC & CE)
Description: Custom Melee game (requested by RoadHog)

Fight to the death with melee attacks only!
* You cannot pick up or drop weapons nor enter vehicles, however, you can pick up health packs, camouflage and overshield.

Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE


* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local melee_object = { }


-- Configuration [starts]
melee_object[1] = "weapons\\ball\\ball"
local scorelimit = 10

local objects = {
    
    -- FALSE = prevent spawning | TRUE = allow spawning
    { "eqip", "powerups\\active camouflage", false},
    { "eqip", "powerups\\health pack", false},
    { "eqip", "powerups\\over shield", false},
    { "eqip", "weapons\\frag grenade\\frag grenade", false},
    { "eqip", "weapons\\plasma grenade\\plasma grenade", false},

    { "vehi", "vehicles\\banshee\\banshee_mp", false},
    { "vehi", "vehicles\\c gun turret\\c gun turret_mp", false},
    { "vehi", "vehicles\\ghost\\ghost_mp", false},
    { "vehi", "vehicles\\scorpion\\scorpion_mp", false},
    { "vehi", "vehicles\\rwarthog\\rwarthog", false},
    { "vehi", "vehicles\\warthog\\mp_warthog", false},

    { "weap", "weapons\\assault rifle\\assault rifle", false},
    { "weap", "weapons\\ball\\ball", true}, -- DO NOT disable.
    { "weap", "weapons\\flag\\flag", false},
    { "weap", "weapons\\flamethrower\\flamethrower", false},
    { "weap", "weapons\\needler\\mp_needler", false},
    { "weap", "weapons\\pistol\\pistol", false},
    { "weap", "weapons\\plasma pistol\\plasma pistol", false},
    { "weap", "weapons\\plasma rifle\\plasma rifle", false},
    { "weap", "weapons\\plasma_cannon\\plasma_cannon", false},
    { "weap", "weapons\\rocket launcher\\rocket launcher", false},
    { "weap", "weapons\\shotgun\\shotgun", false},
    { "weap", "weapons\\sniper rifle\\sniper rifle", false}
}

-- Configuration [ends] << ----------

local bool = {}
local drones = {}
local clean_up_dones = {}
for i = 1, 16 do drones[i] = {} end
local obj_in_memory = {}

local tag_type
local tag_name
local tagbool

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
end

function OnScriptUnload()
    --
end

function OnNewGame()
    if not isTeamPlay() then
        register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
        register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
        register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
        register_callback(cb['EVENT_TICK'], "OnTick")
        register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
        register_callback(cb['EVENT_WEAPON_DROP'], "OnWeaponDrop")
        register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
        
        -- Disable all vehicles
        execute_command("disable_all_vehicles 0 1")
        
        -- Disable weapon pick ups
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
        
        -- disable grenade pick ups
        execute_command("disable_object 'weapons\\frag grenade\\frag grenade'")
        execute_command("disable_object 'weapons\\plasma grenade\\plasma grenade'")
        
        execute_command("scorelimit " .. tonumber(scorelimit))
    else
        cprint("[!] Error (melee.lua) | This script doesn't support team play.", 4+8)
    end
end

function OnPlayerJoin(PlayerIndex)
    obj_in_memory[get_var(PlayerIndex, "$n")] = nil
end

function OnPlayerLeave(PlayerIndex)
    CleanUpDrones(PlayerIndex)
end

local function assignWeapon(PlayerIndex)
    execute_command("wdel " .. PlayerIndex)
    local player = get_dynamic_player(PlayerIndex)
    local x, y, z = read_vector3d(player + 0x5C)
    
    local oddball = spawn_object("weap", melee_object[1], x, y, z)
    local object_spawned = assign_weapon(oddball, PlayerIndex)

    local object = get_object_memory(oddball)
    drones[PlayerIndex] = drones[PlayerIndex] or {}
    table.insert(drones[PlayerIndex], oddball)
    obj_in_memory[get_var(PlayerIndex, "$n")] = object
    clean_up_dones[PlayerIndex] = true
    
    bool[PlayerIndex] = false
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            if (player_alive(i)) then
                if (bool[i] == true) then
                    assignWeapon(i)
                end
            end
        end
    end
end

function OnPlayerSpawn(PlayerIndex)
    if player_alive(PlayerIndex) then
        local PlayerObject = get_dynamic_player(PlayerIndex)
        if (PlayerObject ~= 0) then
            write_word(PlayerObject + 0x31E, 0)
            write_word(PlayerObject + 0x31F, 0)
            bool[PlayerIndex] = true
        end
    end
end

function OnWeaponDrop(PlayerIndex)
    if player_alive(PlayerIndex) then
        CleanUpDrones(PlayerIndex)
        assignWeapon(PlayerIndex)
    end
end

local function deleteWeapons(PlayerIndex)
    local PlayerObject = get_dynamic_player(PlayerIndex)
    local WeaponID = read_dword(PlayerObject + 0x118)
    if WeaponID ~= 0 then
        for j = 0, 3 do
            local ObjectID = read_dword(PlayerObject + 0x2F8 + j * 4)
            destroy_object(ObjectID)
        end
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    deleteWeapons(PlayerIndex)
end

function isTeamPlay()
    if get_var(0, "$ffa") == "0" then
        return true
    else
        return false
    end
end

function CleanUpDrones(PlayerIndex)
    if (clean_up_dones[PlayerIndex] == true) then
        if drones[PlayerIndex] ~= nil then
            for k, v in pairs(drones[PlayerIndex]) do
                if drones[PlayerIndex][k] > 0 then
                    if v then
                        if obj_in_memory[get_var(PlayerIndex, "$n")] then
                            destroy_object(v)
                        end
                        drones[PlayerIndex][k] = nil
                    end
                end
            end
        end
    end
end

local function TagInfo(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    for i = 1, #objects do
        tag_type = tostring(objects[i][1])
        tag_name = tostring(objects[i][2])
        tagbool = objects[i][3]
        if (MapID == TagInfo(tag_type, tag_name)) and (tagbool == false) then
            return false;
        end
    end
end

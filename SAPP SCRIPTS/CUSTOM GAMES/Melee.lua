--[[
--=====================================================================================================--
Script Name: Melee, for SAPP (PC & CE)
Description: Custom Melee game (requested)

Fight to the death with melee only! 
* You cannot pick up or drop weapons nor enter vehicles.

Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE


* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

bool = {}
melee_object = { }
-- Configuration [starts]
melee_object[1] = "weapons\\ball\\ball"
scorelimit = 10
-- Configuration [ends] << ----------

drones = {}
clean_up_dones = {}
for i = 1, 16 do drones[i] = {} end
obj_in_memory = {}

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

function OnTick()
    for i = 1, 16 do
        if (player_alive(i)) then
            local player = get_dynamic_player(i)
            if (bool[i] == true) then
                assignWeapon(i)
            end
        end
    end
end

function assignWeapon(PlayerIndex)
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

function OnPlayerDeath(PlayerIndex, KillerIndex)
    deleteWeapons(PlayerIndex)
end

function deleteWeapons(PlayerIndex)
    local PlayerObject = get_dynamic_player(PlayerIndex)
    local WeaponID = read_dword(PlayerObject + 0x118)
    if WeaponID ~= 0 then
        for j = 0, 3 do
            local ObjectID = read_dword(PlayerObject + 0x2F8 + j * 4)
            destroy_object(ObjectID)
        end
    end
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

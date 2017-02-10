--[[
------------------------------------
Script Name: Halo CE, Weapon Settings, for SAPP
Written for FIG Community

--  MAPS THIS SCRIPT FIXES
    emt_inverno (DONE)
    dioptase (pending)
    deadend (pending)
    municipality (pending)

Description: 
        You will spawn with a custom weapon layout.
    
Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
All Rights Reserved.

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]-- 

api_version = "1.10.0.0"
weapon = { }
weapons = { }

-- WEAPON TABLE:
-- Default Weapons
-----------------------------------------------------------------
weapons[1] = "weapons\\pistol\\pistol"
weapons[2] = "weapons\\plasma_cannon\\plasma_cannon"
weapons[3] = "weapons\\rocket launcher\\rocket launcher"
weapons[4] = "weapons\\sniper rifle\\sniper rifle"
weapons[5] = "weapons\\plasma pistol\\plasma pistol"
weapons[6] = "weapons\\plasma rifle\\plasma rifle"
weapons[7] = "weapons\\assault rifle\\assault rifle"
weapons[8] = "weapons\\flamethrower\\flamethrower"
weapons[9] = "weapons\\needler\\mp_needler"
weapons[10] = "weapons\\pistol\\pistol"
weapons[11] = "weapons\\shotgun\\shotgun"
-----------------------------------------------------------------
-- Custom Weapons:
weapons[12] = "weapons\\m16\\m16" -- Dustbeta

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    if get_var(0, "$gt") ~= "n/a" then
        game_type = get_var(0, "$mode")
        mapname = get_var(0, "$map")
    end
end

function OnScriptUnload()
    weapons = { }
end

function OnPlayerSpawn(PlayerIndex)
    weapon[PlayerIndex] = 0
end

function OnNewGame()
    game_type = get_var(0, "$mode")
    mapname = get_var(0, "$map")
end

function OnTick()
    for i = 1, 16 do
        if (player_alive(i)) then
            local player = get_dynamic_player(i)
            if (weapon[i] == 0) then
                execute_command("wdel " .. i)
                local x, y, z = read_vector3d(player + 0x5C)
                -- SLAYER
                if (game_type == "example_slayer") then -- Insert GAMEMODE here, i.e, example_slayer
                    if (mapname == "dustbeta") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        assign_weapon(spawn_object("weap", weapons[12], x, y, z), i) -- M16
                        weapon[i] = 1
                    end
                end
                -- CTF --
                if (game_type == "example_ctf") then -- Insert GAMEMODE here, i.e, example_ctf
                    if (mapname == "h2_momentum") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- pistol
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) -- Assault Rifle
                        weapon[i] = 1
                    elseif (mapname == "MAP_NAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        assign_weapon(spawn_object("weap", weapons[7], x, y, z), i) -- Sniper Rifle
                        weapon[i] = 1
                    end
                end
                if (game_type == "INSERT_GAME_TYPE_HERE") then
                    if (mapname == "MAP_NAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        weapon[i] = 1
                    elseif (mapname == "MAP_NAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        weapon[i] = 1
                    end
                elseif (game_type == "INSERT_GAME_TYPE_HERE") then
                    if (mapname == "MAP_NAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        weapon[i] = 1
                    elseif (mapname == "MAP_NAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        weapon[i] = 1
                    end
                end
            end
        end
    end
end

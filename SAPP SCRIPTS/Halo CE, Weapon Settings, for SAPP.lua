--[[
------------------------------------
Script Name: Custom Weapon Spawns, for SAPP
Written for FIG Community
    
Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
All Rights Reserved.

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]-- 

api_version = "1.10.0.0"
weapon = { }
weapons = { }

-- Default Weapons
----------------------------------------------------------------------------------------------------------------------------------
weapons[1] = "weapons\\pistol\\pistol"
weapons[2] = "weapons\\sniper rifle\\sniper rifle"
weapons[3] = "weapons\\plasma_cannon\\plasma_cannon"
weapons[4] = "weapons\\rocket launcher\\rocket launcher"
weapons[5] = "weapons\\plasma pistol\\plasma pistol"
weapons[6] = "weapons\\plasma rifle\\plasma rifle"
weapons[7] = "weapons\\assault rifle\\assault rifle"
weapons[8] = "weapons\\flamethrower\\flamethrower"
weapons[9] = "weapons\\needler\\mp_needler"
weapons[10] = "weapons\\shotgun\\shotgun"
----------------------------------------------------------------------------------------------------------------------------------
-- Custom Weapons:
    -- dust beta --
weapons[11] = "weapons\p90\p90"
weapons[12] = "cod4\weapons\desert eagle\desert eagle"

    -- snowdrop --
weapons[13] = "weapons\<weapon name>\<weapon name>"
weapons[14] = "cod4\weapons\<weapon name>\<weapon name>"

    -- h2_momentum --
weapons[15] = "weapons\<weapon name>\<weapon name>"
weapons[16] = "cod4\weapons\<weapon name>\<weapon name>"

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    if get_var(0, "$gt") ~= "n/a" then
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
    mapname = get_var(0, "$map")
end

function OnTick()
    for i = 1, 16 do
        if (player_alive(i)) then
            local player = get_dynamic_player(i)
            if (weapon[i] == 0) then
                execute_command("wdel " .. i)
                local x, y, z = read_vector3d(player + 0x5C)
                if (mapname == "dustbeta") then
                    assign_weapon(spawn_object("weap", weapons[11], x, y, z), i)
                    assign_weapon(spawn_object("weap", weapons[12], x, y, z), i)
                    weapon[i] = 1
                elseif (mapname == "snowdrop") then
                    assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                    assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                    weapon[i] = 1
                elseif (mapname == "h2_momentum") then
                    assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                    assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                    weapon[i] = 1
                elseif (mapname == "MAP_NAME_HERE") then
                    assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                    assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                    weapon[i] = 1
                elseif (mapname == "MAP_NAME_HERE") then
                    assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                    assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                    weapon[i] = 1
                elseif (mapname == "MAP_NAME_HERE") then
                    assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                    assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                    weapon[i] = 1
                elseif (mapname == "MAP_NAME_HERE") then
                    assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                    assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                    weapon[i] = 1
                elseif (mapname == "MAP_NAME_HERE") then
                    assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                    assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                    weapon[i] = 1
                end
            end
        end
    end
end

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
        mapname = get_var(0, "$map")
        team_play = getteamplay()
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
    team_play = getteamplay()
end

function getteamplay()
    if get_var(0, "$ffa") == "0" then
        return true
    else
        return false
    end
end

function OnTick()
    for i = 1, 16 do
        if (player_alive(i)) then
            local player = get_dynamic_player(i)
            if (weapon[i] == 0) then
                execute_command("wdel " .. i)
                local x, y, z = read_vector3d(player + 0x5C)
                -- Free for All (FAA) ------------------------------------------------
                if not team_play then
                    if (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[12], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[12], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[12], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[12], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[12], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[12], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[12], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[12], x, y, z), i)
                        weapon[i] = 1
                    end
                end
------------------------------------------------------------------------------------------------
                -- TEAM PLAY -------------------------------------------------------------------
                if team_play then
                    if (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "MAPNAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                        weapon[i] = 1
                    end
                end
            end
        end
    end
end

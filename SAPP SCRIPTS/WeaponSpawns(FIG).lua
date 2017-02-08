--[[
------------------------------------
Script Name: Halo CE, Weapon Settings, for SAPP
-- For Fig Community
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
        GetMetaIDs()
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
                if (game_type == "fig_slayer") then -- Insert GAMEMODE here, i.e, fig_slayer
                    if (mapname == "dustbeta") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        assign_weapon(spawn_object("weap", weapons[12], x, y, z), i) -- M16
                        weapon[i] = 1
                    end
                end
                
                
                
                -- CTF
                if (game_type == "fig_ctf") then -- Insert GAMEMODE here, i.e, fig_ctf
                    if (mapname == "h2_momentum") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- pistol
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) -- Assault Rifle
                        weapon[i] = 1
                    -- [start][ Repeat the structure to add more maps:
                    elseif (mapname == "MAP_NAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
                        assign_weapon(spawn_object("weap", weapons[7], x, y, z), i) -- Sniper Rifle
                        weapon[i] = 1
                    -------------------------------------------------------------------------------
                    end
                    --  ][finish]
                end
                
                
                
--              For "assign_weapon":
--                  Change weapons[#] (number) to the corrosponding table# (number) at the top. 
--                  See Weapon Table at the top of the script, (lines 13 through 23).
--                  You can spawn with up to 4 weapons

                -- [start][ Repeat the structure to add more gametypes and maps:
                if (game_type == "INSERT_GAME_TYPE_HERE") then
                    if (mapname == "MAP_NAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
--      [INFO]          Remove the comment(s) (--) to use these entries. 
--      [INFO]          You can spawn with up to 4 weapons.
                        --assign_weapon(spawn_object("weap", weapons[2], x, y, z), i) Plasma Cannon
                        --assign_weapon(spawn_object("weap", weapons[3], x, y, z), i) Rocket Launcher
                        --assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) Sniper Rifle
                        weapon[i] = 1
                    elseif (mapname == "MAP_NAME_HERE") then
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i) -- Pistol
--      [INFO]          Remove the comment(s) (--) to use these entries. 
--      [INFO]          You can spawn with up to 4 weapons.
                        --assign_weapon(spawn_object("weap", weapons[2], x, y, z), i) Plasma Cannon
                        --assign_weapon(spawn_object("weap", weapons[3], x, y, z), i) Rocket Launcher
                        --assign_weapon(spawn_object("weap", weapons[4], x, y, z), i) Sniper Rifle
                        weapon[i] = 1
                    -------------------------------------------------------------------------------
                    end
                end
                --  ][finish]

                
                
                -- Clean Example: SLAYER
                if (game_type == "fig_slayer") then
                    if (mapname == "bloodgulch") then
                        assign_weapon(spawn_object("weap", weapons[5], x, y, z), i) 
                        assign_weapon(spawn_object("weap", weapons[7], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[10], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[9], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "ratrace") then
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i) 
                        assign_weapon(spawn_object("weap", weapons[3], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[5], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "boardingaction") then
                        assign_weapon(spawn_object("weap", weapons[3], x, y, z), i) 
                        assign_weapon(spawn_object("weap", weapons[8], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[11], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "dangercanyon") then
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i) 
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[7], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[5], x, y, z), i)
                        weapon[i] = 1
                    end
                -- Clean Example: CTF
                elseif(game_type == "fig_ctf") then
                    if (mapname == "gephyrophobia") then
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i) 
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[9], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "infinity") then
                        assign_weapon(spawn_object("weap", weapons[3], x, y, z), i) 
                        assign_weapon(spawn_object("weap", weapons[5], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i)
                        weapon[i] = 1
                    elseif (mapname == "prisoner") then
                        assign_weapon(spawn_object("weap", weapons[5], x, y, z), i) 
                        assign_weapon(spawn_object("weap", weapons[6], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[8], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[10], x, y, z), i)
                        weapon[i] = 1
                    elseif(mapname == "putput") then
                        assign_weapon(spawn_object("weap", weapons[3], x, y, z), i) 
                        assign_weapon(spawn_object("weap", weapons[4], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[2], x, y, z), i)
                        assign_weapon(spawn_object("weap", weapons[8], x, y, z), i)
                        weapon[i] = 1
                    end
                end
            end
        end
    end
end

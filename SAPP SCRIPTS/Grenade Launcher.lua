--[[
--=====================================================================================================--
Script Name: Grenade Launcher, for SAPP (PC & CE)

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- configuration starts --
-- default projectile
default_projectile = "weapons\\frag grenade\\frag grenade"
-- velocity to launch projectile
default_velocity = 0.6
-- distance from player to spawn projectile
default_distance = 0.5

-- Enables Custom Weapon Assignment.
use_weapon_assignment = true
weapon_assignment = {}
-- Set 'true' to 'false' to disable that weapon assignment upon typing /launcher on
weapon_assignment[1] = {"weap", "weapons\\assault rifle\\assault rifle", true}
weapon_assignment[2] = {"weap", "weapons\\pistol\\pistol", true}
weapon_assignment[3] = {"weap", "weapons\\plasma rifle\\plasma rifle", true}
weapon_assignment[4] = {"weap", "weapons\\shotgun\\shotgun", true}

-- minimum admin level required to execute custom commands (set to -1 for all players. 1-4 admins)
command_permission_level = 1

-- command to enable the grenade launcher       Syntax: /launcher on|off or 1|2 or true|false
enable_launcher_command = "launcher"
-- command to change velocity and distance.     Syntax: /vd [velocity] [distance]
change_vd_command = "vd"
-- command to change projectile type.           Syntax: /nadetype frag|plasma or 1|2|3 (1 = frag, 2 = plasma, 3 = rocket)
change_projectile_type = "nadetype"
-- command to reset velocity|distance to default values
reset_command = "reset"

weapons = { }
-- grenade launcher will be enabled for these weapons. Set 'true' to 'false' to disable grenade launcher for that weapon

for i = 1, 16 do weapons[i] = {
    { "weap", "weapons\\assault rifle\\assault rifle", true, "proj", "weapons\\assault rifle\\bullet", 120},
    { "weap", "weapons\\flamethrower\\flamethrower", false, "proj", "weapons\\flamethrower\\flame", 130},
    { "weap", "weapons\\needler\\mp_needler", false, "proj", "weapons\\needler\\mp_needle", 70},
    { "weap", "weapons\\pistol\\pistol", true, "proj", "weapons\\pistol\\bullet", 24},
    { "weap", "weapons\\plasma pistol\\plasma pistol", true, "proj", "weapons\\plasma pistol\\bolt", 10},
    { "weap", "weapons\\plasma rifle\\plasma rifle", true, "proj", "weapons\\plasma rifle\\bolt", 30},
    { "weap", "weapons\\rocket launcher\\rocket launcher", false, "proj", "weapons\\rocket launcher\\rocket", 10},
    { "weap", "weapons\\plasma_cannon\\plasma_cannon", false, "proj", "weapons\\plasma_cannon\\plasma_cannon", 10},
    { "weap", "weapons\\shotgun\\shotgun", true, "proj", "weapons\\shotgun\\pellet", 12},
    { "weap", "weapons\\sniper rifle\\sniper rifle", true, "proj", "weapons\\sniper rifle\\sniper bullet", 16}
}
end

ammo_pack_locations = { }
ammo_pack_locations = {
--                                                     X                 Y                 X          R
{ "eqip", "powerups\\full-spectrum vision", 28.018934249878, - 19.682806015015, - 18.641296386719, 0.1, true},
{ "eqip", "powerups\\full-spectrum vision", - 3.6864845752716, 1.4177178144455, - 21.212497711182, 0.1, true}
}


death_location = { }
for i = 1, 16 do death_location[i] = { } end
AssignWeapon = { }
DeleteWeapons = {}

-- configuration ends --

-- do not touch --
reset_values = { }
launcher_mode = { }
values_specified = { }

velocity = { }
distance = { }
new_velocity = { }
new_distance = { }
new_projectile = { }
projectile_type = { }
grenade_type_changed = { }

has_ammo = { }
shot_fired = { }
available_shots = { }

set_initial = { }

original_data = { }
reset_bool = { }

player_equipment = { }
current_players = 0

function OnScriptLoad()
register_callback(cb['EVENT_TICK'], "OnTick")
register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
register_callback(cb['EVENT_GAME_START'], "OnNewGame")
register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPrespawn")
register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
end

function OnScriptUnload()
--
end

function OnNewGame()
for i = 1, 16 do
    for k, v in pairs(weapons[i]) do
        if v[6] ~= nil then
            table.insert(original_data, v[6])
        end
    end
end
for i = 1, #ammo_pack_locations do
    if ammo_pack_locations[i] ~= nil then
        ammo_pack = spawn_object(ammo_pack_locations[i][1], ammo_pack_locations[i][2], ammo_pack_locations[i][3], ammo_pack_locations[i][4], ammo_pack_locations[i][5] + 0.1)
    end
end
end

function OnGameEnd()
for i = 1, 16 do
    reset_values[i] = true
end
end

function OnPlayerJoin(PlayerIndex)
values_specified[PlayerIndex] = false
launcher_mode[PlayerIndex] = false
-- reset to default settings --
velocity[PlayerIndex] = default_velocity
distance[PlayerIndex] = default_distance
projectile_type[PlayerIndex] = default_projectile
current_players = current_players + 1
timer(1000 * 3, "set_initial_ammo", PlayerIndex)
set_initial[PlayerIndex] = true
AssignWeapon[PlayerIndex] = false
end

function OnPlayerPrespawn(VictimIndex)
local victim = tonumber(VictimIndex)
if VictimIndex then
    if death_location[victim][1] ~= nil then
        write_vector3d(get_dynamic_player(victim) + 0x5C, death_location[victim][1], death_location[victim][2], death_location[victim][3])
        for i = 1, 3 do
            death_location[victim][i] = nil
        end
    end
end
end

function OnPlayerDeath(victim, killer)
if (DeleteWeapons[victim] == true) then
    DeleteWeapons[victim] = false
    local player_object = get_dynamic_player(victim)
    local weaponId = read_dword(player_object + 0x118)
    write_word(player_object + 0x31E, 0)
    write_word(player_object + 0x31F, 0)
    if weaponId ~= 0 then
        for j = 0, 3 do
            local m_weapon = read_dword(player_object + 0x2F8 + j * 4)
            destroy_object(m_weapon)
        end
    end
    destroy_object(read_dword(get_player(victim) + 0x34))
    write_dword(get_player(victim) + 0x2C, 0)
    execute_command("deaths " .. victim .. " -1")
    safe_write(true)
    write_dword(deathmessages, original)
    safe_write(false)
end
end

function set_initial_ammo(PlayerIndex)
if player_alive(PlayerIndex) then
    local player_object = get_dynamic_player(PlayerIndex)
    if player_object ~= 0 then
        local current_weapon = get_object_memory(read_dword(player_object + 0x118))
        if current_weapon ~= 0 then
            local weapon_tag_id = read_string(read_dword(read_word(current_weapon) * 32 + 0x40440038))
            for k, v in pairs(weapons[tonumber(PlayerIndex)]) do
                if string.find(weapon_tag_id, v[2]) then
                    available_shots[tonumber(PlayerIndex)] = v[6]
                end
            end
        end
    end
end
end

function OnPlayerLeave(PlayerIndex)
current_players = current_players - 1
for i = 1, 3 do
    death_location[PlayerIndex][i] = nil
end
end

function OnPlayerSpawn(PlayerIndex)
if (launcher_mode[PlayerIndex] == true) then
    timer(1000, "delay_update_ammo", PlayerIndex)
end
end

function delay_update_ammo(PlayerIndex)
local weapon_id = read_dword(get_dynamic_player(PlayerIndex) + 0x118)
local weapon_object = get_object_memory(weapon_id)
if weapon_object ~= 0 then
    local weapon_name = read_string(read_dword(read_word(weapon_object) * 32 + 0x40440038))
    for k, v in pairs(weapons[tonumber(PlayerIndex)]) do
        if string.find(weapon_name, v[2]) then
            for K, V in pairs(original_data) do
                v[6] = original_data[k]
                available_shots[PlayerIndex] = v[6]
                has_ammo[PlayerIndex] = true
            end
        end
    end
end
end

function AssignNew(PlayerIndex, x, y, z)
for i = 1, 4 do execute_command("wdel " .. PlayerIndex) end
for i = 1, 2 do
    if weapon_assignment[i][3] == true then
        assign_weapon(spawn_object(weapon_assignment[i][1], weapon_assignment[i][2], x, y, z), PlayerIndex)
    end
end
timer(50, "TertiaryDelay", PlayerIndex, x, y, z)
end

function TertiaryDelay(PlayerIndex, x, y, z)
for i = 3, 4 do
    if weapon_assignment[i][3] == true then
        assign_weapon(spawn_object(weapon_assignment[i][1], weapon_assignment[i][2], x, y, z), PlayerIndex)
    end
end
end

function OnServerCommand(PlayerIndex, Command, Environment)
local UnknownCMD = nil
local t = tokenizestring(Command)
if t[1] == string.lower(enable_launcher_command) then
    if tonumber(get_var(PlayerIndex, "$lvl")) >= command_permission_level then
        -- enable|disable launcher mode
        if t[2] ~= nil then
            if string.match(t[2], "1") or string.match(t[2], "on") or string.match(t[2], "true") then
                if player_alive(PlayerIndex) then
                    if launcher_mode[PlayerIndex] ~= true then
                        launcher_mode[PlayerIndex] = true
                        if use_weapon_assignment then
                            local inventory = {}
                            inventory.loadout = {}
                            for i = 0, 3 do
                                equipment_saved = get_object_memory(read_dword(get_dynamic_player(PlayerIndex) + 0x2F8 + i * 4))
                                if equipment_saved ~= 0 then
                                    inventory.loadout[i + 1] = {
                                        ["id"] = read_dword(equipment_saved),
                                        ["ammo"] = read_word(equipment_saved + 0x2B6),
                                        ["clip"] = read_word(equipment_saved + 0x2B8),
                                        ["ammo2"] = read_word(equipment_saved + 0x2C6),
                                        ["clip2"] = read_word(equipment_saved + 0x2C8),
                                        ["age"] = read_float(equipment_saved + 0x240)
                                    }
                                end
                            end
                            inventory.frag_grenades = read_byte(get_dynamic_player(PlayerIndex) + 0x31E)
                            inventory.plasma_grenades = read_byte(get_dynamic_player(PlayerIndex) + 0x31F)
                            player_equipment[get_var(PlayerIndex, "$n")] = inventory
                            local x, y, z = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
                            AssignNew(PlayerIndex, x, y, z)
                        end
                        if (set_initial[PlayerIndex] == true) then
                            set_initial[PlayerIndex] = false
                            local weapon_id = read_dword(get_dynamic_player(PlayerIndex) + 0x118)
                            local weapon_object = get_object_memory(weapon_id)
                            if weapon_object ~= 0 then
                                local weapon_name = read_string(read_dword(read_word(weapon_object) * 32 + 0x40440038))
                                for k, v in pairs(weapons[PlayerIndex]) do
                                    if string.find(weapon_name, v[2]) then
                                        for K, V in pairs(original_data) do
                                            v[6] = original_data[k]
                                            available_shots[PlayerIndex] = tonumber(original_data[k])
                                        end
                                    end
                                end
                            end
                        end
                        rprint(PlayerIndex, "Grenade Launcher Activated")
                        UnknownCMD = false
                    else
                        rprint(PlayerIndex, "Grenade Launcher is already enabled!")
                        UnknownCMD = false
                    end
                else
                    rprint(PlayerIndex, "You are dead! Unable to activate Grenade Launcher Mode.")
                end
            elseif string.match(t[2], "0") or string.match(t[2], "off") or string.match(t[2], "false") then
                if launcher_mode[PlayerIndex] ~= false then
                    launcher_mode[PlayerIndex] = false
                    if use_weapon_assignment then
                        deathmessages = sig_scan("8B42348A8C28D500000084C9") + 3
                        original = read_dword(deathmessages)
                        safe_write(true)
                        write_dword(deathmessages, 0x03EB01B1)
                        safe_write(false)
                        local x, y, z = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
                        death_location[PlayerIndex][1] = x
                        death_location[PlayerIndex][2] = y
                        death_location[PlayerIndex][3] = z
                        DeleteWeapons[PlayerIndex] = true
                        execute_command("kill " .. PlayerIndex)
                        AssignWeapon[PlayerIndex] = true
                    end
                    rprint(PlayerIndex, "Grenade Launcher Deactivated")
                    UnknownCMD = false
                else
                    rprint(PlayerIndex, "Grenade Launcher is already disabled!")
                    UnknownCMD = false
                end
            end
        else
            rprint(PlayerIndex, "Invalid Syntax! Use: /" .. enable_launcher_command .. " on|off or 1|2 or true|false")
            UnknownCMD = false
        end
    else
        rprint(PlayerIndex, "You do not have permission to execute /" .. t[1] .. " " .. t[2])
        UnknownCMD = false
    end
    -- reset velocity|distance to default values
elseif t[1] == string.lower(reset_command) then
    if tonumber(get_var(PlayerIndex, "$lvl")) >= command_permission_level then
        local weapon_id = read_dword(get_dynamic_player(PlayerIndex) + 0x118)
        local weapon_object = get_object_memory(weapon_id)
        if weapon_object ~= 0 then
            local weapon_name = read_string(read_dword(read_word(weapon_object) * 32 + 0x40440038))
            for k, v in pairs(weapons[tonumber(PlayerIndex)]) do
                if string.find("weap", v[1]) then
                    for K, V in pairs(original_data) do
                        v[6] = original_data[k]
                        available_shots[PlayerIndex] = v[6]
                        has_ammo[PlayerIndex] = true
                        reset_values[PlayerIndex] = true
                        reset_bool[PlayerIndex] = true
                    end
                end
            end
        end
        rprint(PlayerIndex, "Values reset to default")
        UnknownCMD = false
    else
        rprint(PlayerIndex, "You do not have permission to execute /" .. t[1])
        UnknownCMD = false
    end
    -- set projectile velocity|distance
elseif t[1] == string.lower(change_vd_command) then
    if tonumber(get_var(PlayerIndex, "$lvl")) >= command_permission_level then
        if t[2] ~= nil and t[3] ~= nil then
            if launcher_mode[PlayerIndex] == true then
                if string.match(t[2], "%d+") and string.match(t[3], "%d+") then
                    values_specified[PlayerIndex] = true
                    new_velocity[PlayerIndex] = tonumber(t[2])
                    new_distance[PlayerIndex] = tonumber(t[3])
                    rprint(PlayerIndex, "Velocity set to: " .. t[2] .. "    Distance set to: " .. t[3])
                    UnknownCMD = false
                end
            else
                rprint(PlayerIndex, 'Grenade Launcher is not activated! Type "/launcher on" to activate.')
                UnknownCMD = false
            end
        else
            rprint(PlayerIndex, "Invalid Syntax! Type: /" .. change_vd_command .. " [velocity] [distance]")
            UnknownCMD = false
        end
    else
        rprint(PlayerIndex, "You do not have permission to execute /" .. t[2])
        UnknownCMD = false
    end
    -- change projectile type
elseif t[1] == string.lower(change_projectile_type) then
    if tonumber(get_var(PlayerIndex, "$lvl")) >= command_permission_level then
        if t[2] ~= nil then
            if launcher_mode[PlayerIndex] == true then
                if string.match(t[2], "frag") or string.match(t[2], "1") then
                    new_projectile[PlayerIndex] = "weapons\\frag grenade\\frag grenade"
                    grenade_type_changed[PlayerIndex] = true
                    reset_values[PlayerIndex] = false
                    rprint(PlayerIndex, "Now shooting Frag Grenades")
                    UnknownCMD = false
                elseif string.match(t[2], "plasma") or string.match(t[2], "2") then
                    new_projectile[PlayerIndex] = "weapons\\plasma grenade\\plasma grenade"
                    grenade_type_changed[PlayerIndex] = true
                    reset_values[PlayerIndex] = false
                    rprint(PlayerIndex, "Now shooting Plasma Grenades")
                    UnknownCMD = false
                elseif string.match(t[2], "rocket") or string.match(t[2], "3") then
                    new_projectile[PlayerIndex] = "weapons\\rocket launcher\\rocket"
                    grenade_type_changed[PlayerIndex] = true
                    reset_values[PlayerIndex] = false
                    rprint(PlayerIndex, "Now shooting Rocket Projectiles")
                    UnknownCMD = false
                end
            else
                rprint(PlayerIndex, 'Grenade Launcher is not activated! Type "/launcher on" to activate.')
                UnknownCMD = false
            end
        else
            rprint(PlayerIndex, "Invalid Syntax! Type /" .. change_projectile_type .. " frag|plasma|1|2")
            UnknownCMD = false
        end
    else
        rprint(PlayerIndex, "You do not have permission to execute /" .. t[2])
        UnknownCMD = false
    end
end
return UnknownCMD
end

function OnTick()
for eq = 1, current_players do
    if player_alive(eq) then
        if AssignWeapon[eq] == true then
            AssignWeapon[eq] = false
            for X = 1, 4 do execute_command("wdel " .. eq) end
            local x, y, z = read_vector3d(get_dynamic_player(eq) + 0x5C)
            local inventory = player_equipment[get_var(eq, "$n")]
            for _, equipment_saved in pairs(inventory.loadout) do
                local saved_weapons = spawn_object("null", "null", x, y, z + 0.3, 90, equipment_saved.id)
                local weapon_object = get_object_memory(saved_weapons)
                write_word(weapon_object + 0x2B6, equipment_saved.ammo)
                write_word(weapon_object + 0x2B8, equipment_saved.clip)
                write_word(weapon_object + 0x2C6, equipment_saved.ammo2)
                write_word(weapon_object + 0x2C8, equipment_saved.clip2)
                write_float(weapon_object + 0x240, equipment_saved.age)
                sync_ammo(saved_weapons)
                assign_weapon(saved_weapons, eq)
                write_byte(get_dynamic_player(eq) + 0x31E, inventory.frag_grenades)
                write_byte(get_dynamic_player(eq) + 0x31F, inventory.plasma_grenades)
            end
        end
    end
end
for i = 1, current_players do
    if player_alive(i) then
        if launcher_mode[i] == true then
            local weapon = get_object_memory(read_dword(get_dynamic_player(i) + 0x118))
            if weapon ~= 0 then
                local current_weapon = read_string(read_dword(read_word(weapon) * 32 + 0x40440038))
                for k, v in pairs(weapons[i]) do
                    if string.find(current_weapon, v[2]) then
                        if shot_fired[i] then
                            v[6] = v[6] - 1
                            available_shots[i] = v[6]
                            if has_ammo[i] then
                                for j = 1, 30 do rprint(i, " ") end
                                rprint(i, "Shots: " .. available_shots[i])
                            end
                            shot_fired[i] = false
                        end
                        if available_shots[i] ~= nil and available_shots[i] >= 1 and available_shots[i] <= v[6] then
                            has_ammo[i] = true
                        else
                            has_ammo[i] = false
                        end
                        if reset_bool[i] == true then
                            available_shots[i] = v[6]
                            reset_bool[i] = false
                        end
                        if v[6] < 1 then v[6] = 1 end
                    end
                end
            end
        end
    end
end
for m = 1, 16 do
    if (player_alive(m)) then
        if (launcher_mode[m] == true) then
            for j = 1, #ammo_pack_locations do
                if ammo_pack_locations[j] ~= nil then
                    local player = get_dynamic_player(m)
                    if player ~= 0 then
                        --                                                         X                          Y                          Z                          R
                        if getPlayerCoords(m, ammo_pack_locations[j][3], ammo_pack_locations[j][4], ammo_pack_locations[j][5], ammo_pack_locations[j][6]) == true then
                            if ammo_pack_locations[j][7] == true then
                                table.insert(ammo_pack_locations[j], tonumber(ammo_pack))
                                local ammo_pack_object = get_object_memory(tonumber(ammo_pack_locations[j][8]))
                                if ammo_pack_object ~= nil then
                                    local weapon_id = read_dword(get_dynamic_player(m) + 0x118)
                                    local weapon_object = get_object_memory(weapon_id)
                                    if weapon_object ~= 0 then
                                        local weapon_name = read_string(read_dword(read_word(weapon_object) * 32 + 0x40440038))
                                        for k, v in pairs(weapons[tonumber(m)]) do
                                            if string.find(weapon_name, v[2]) then
                                                for key, value in pairs(original_data) do
                                                    v[6] = original_data[k]
                                                    available_shots[tonumber(m)] = v[6]
                                                    has_ammo[m] = true
                                                    destroy_object(ammo_pack_object)
                                                    table.insert(ammo_pack_locations[j], 7, false)
                                                    rprint(m, "New Ammo: " .. tostring(available_shots[m]))
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
end

function getPlayerCoords(PlayerIndex, posX, posY, posZ, radius)
local x, y, z = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
if (posX - x) ^ 2 + (posY - y) ^ 2 + (posZ - z) ^ 2 <= radius then
    return true
elseif (posX - x) ^ 2 + (posY - y) ^ 2 + (posZ - z) ^ 2 > radius + 1 then
    return false
else
    return false
end
end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
if tonumber(Type) == 1 then
    if (launcher_mode[PlayerIndex] == true) then
        local weapon_object = get_object_memory(read_dword(get_dynamic_player(PlayerIndex) + 0x2F8 + (tonumber(WeaponIndex) - 1) * 4))
        local weapon_name = read_string(read_dword(read_word(weapon_object) * 32 + 0x40440038))
        for k, v in pairs(weapons[PlayerIndex]) do
            if string.find(weapon_name, v[2]) then
                for K, V in pairs(original_data) do
                    v[6] = original_data[k]
                    available_shots[PlayerIndex] = tonumber(original_data[k])
                end
            end
        end
    end
end
end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
if (launcher_mode[PlayerIndex] == true) then
    local tag_id = weapons[1], tostring(weapons[2])
    for k, v in pairs(weapons[PlayerIndex]) do
        if MapID == TagInfo(tostring(v[4]), tostring(v[5])) then
            if v[3] == true then
                shot_fired[PlayerIndex] = true
                return false, GrenadeLauncher(PlayerIndex, ParentID)
            end
        end
    end
end
end

function GrenadeLauncher(PlayerIndex, ParentID)
if get_dynamic_player(PlayerIndex) ~= nil then

    if available_shots[tonumber(PlayerIndex)] < 1 then
        for i = 1, 30 do rprint(PlayerIndex, " ") end
        rprint(PlayerIndex, "No shots available!")
    end

    if (has_ammo[PlayerIndex] == true) then
        local object_id = get_object_memory(ParentID)
        if object_id ~= nil then

            local x_aim = read_float(object_id + 0x230)
            local y_aim = read_float(object_id + 0x234)
            local z_aim = read_float(object_id + 0x238)

            local x = read_float(object_id + 0x5C)
            local y = read_float(object_id + 0x60)
            local z = read_float(object_id + 0x64)

            local z_offset = 0.5

            local proj_x = x + distance[PlayerIndex] * math.sin(x_aim)
            local proj_y = y + distance[PlayerIndex] * math.sin(y_aim)
            local proj_z = z + distance[PlayerIndex] * math.sin(z_aim) + z_offset

            if (reset_values[PlayerIndex] == true) then
                values_specified[PlayerIndex] = false
                grenade_type_changed[PlayerIndex] = false
                reset_values[PlayerIndex] = false
            end

            if (values_specified[PlayerIndex] == true) then
                velocity[PlayerIndex] = new_distance[PlayerIndex]
                distance[PlayerIndex] = new_velocity[PlayerIndex]
            else
                velocity[PlayerIndex] = default_velocity
                distance[PlayerIndex] = default_distance
            end

            if (grenade_type_changed[PlayerIndex] == true) then
                projectile_type[PlayerIndex] = new_projectile[PlayerIndex]
            else
                projectile_type[PlayerIndex] = default_projectile
            end

            local proj_x = x + distance[PlayerIndex] * math.sin(x_aim)
            local proj_y = y + distance[PlayerIndex] * math.sin(y_aim)
            local proj_z = z + distance[PlayerIndex] * math.sin(z_aim) + z_offset

            local tag_id = TagInfo("proj", projectile_type[PlayerIndex])
            local frag_projectile = spawn_projectile(tag_id, PlayerIndex, proj_x, proj_y, proj_z)
            local frag = get_object_memory(frag_projectile)

            if frag then
                write_float(frag + 0x68, velocity[PlayerIndex] * math.sin(x_aim))
                write_float(frag + 0x6C, velocity[PlayerIndex] * math.sin(y_aim))
                write_float(frag + 0x70, velocity[PlayerIndex] * math.sin(z_aim))
            end
        end
    end
end
end

function TagInfo(obj_type, obj_name)
local tag_id = lookup_tag(obj_type, obj_name)
return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end

function tokenizestring(inputstr, sep)
if sep == nil then
    sep = "%s"
end
local t = { }; i = 1
for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
t[i] = str
i = i + 1
end
return t
end

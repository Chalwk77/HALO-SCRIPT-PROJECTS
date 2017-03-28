--[[
------------------------------------
Script Name: {ØZ}-4 Snipers Dream Team Mod

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.11.0.0"
weapon = { }
weapons = { }
objects = { }
players = { }
teleports = { }
DAMAGE_APPLIED = { }
weapons[1] = "weapons\\pistol\\pistol"
weapons[2] = "weapons\\sniper rifle\\sniper rifle"
objects = {
    { "vehi", "vehicles\\banshee\\banshee_mp", 64.178, -176.802, 3.960, "Red Banshee"},
    { "vehi", "vehicles\\banshee\\banshee_mp", 70.078, -62.626, 3.758, "Blue Banshee"},
    { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 118.084, -185.346, 6.563, "Red Turret"},
    { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 29.544, -53.628, 3.302, "Blue Turret"},
    { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 51.315, -154.075, 21.561, "Cliff Turret"},
    { "vehi", "vehicles\\ghost\\ghost_mp", 59.294, -116.212, 1.797, "Ghost [Mid-Field]"},
    { "vehi", "vehicles\\scorpion\\scorpion_mp", 104.017, -129.761, 1.665, "Tank [Knoll]"},
    { "eqip", "powerups\\health pack", 37.070, -80.068, -0.286, "health pack - bluebase"},
    { "eqip", "powerups\\health pack", 37.105, -78.421, -0.286, "health pack - bluebase"},
    { "eqip", "powerups\\health pack", 43.144, -78.442, -0.286, "health pack - bluebase"},
    { "eqip", "powerups\\health pack", 43.136, -80.072, -0.286, "health pack - bluebase"},
    { "eqip", "powerups\\health pack", 43.512, -77.153, -0.286, "health pack - bluebase"},
    { "eqip", "powerups\\health pack", 74.391, -77.651, 5.698, "health pack - blue path"},
    { "eqip", "powerups\\health pack", 70.650, -61.932, 4.095, "health pack - blue banshee"},
    { "eqip", "powerups\\health pack", 63.551, -177.337, 4.181, "health pack - red banshee"},
    { "eqip", "powerups\\health pack", 98.930, -157.614, -0.249, "health pack - redbase"},
    { "eqip", "powerups\\health pack", 98.498, -158.564, -0.228, "health pack - redbase"},
    { "eqip", "powerups\\health pack", 98.508, -160.189, -0.228, "health pack - redbase"},
    { "eqip", "powerups\\health pack", 92.555, -160.193, -0.228, "health pack - redbase"},
    { "eqip", "powerups\\health pack", 92.560, -158.587, -0.228, "health pack - redbase"},
    { "eqip", "powerups\\health pack", 120.247, -185.103, 6.495, "health pack - red turret"},
    { "eqip", "powerups\\health pack", 94.351, -97.615, 5.184, "health pack - Rock between the caves"},
    { "eqip", "powerups\\health pack", 12.928, -103.277, 13.990, "health pack - Nest"},
    { "eqip", "powerups\\health pack", 48.060, -153.092, 21.190, "health pack - turret mountain"},
    { "eqip", "powerups\\health pack", 43.253, -45.376, 20.920, "health pack - rear cliff (blue)"},
    { "eqip", "powerups\\health pack", 43.253, -45.376, 20.920, "health pack - corner cliff (blue)"},
    { "eqip", "powerups\\health pack", 77.279, -89.107, 22.571, "health pack - cliff (overlooking mid field)"},
    { "eqip", "powerups\\health pack", 101.034, -117.048, 14.795, "health pack - platform (overlooking redbase)"},
    { "eqip", "powerups\\health pack", 118.244, -120.757, 17.229, "cliff - overlooking red (banshee platform)"},
    { "eqip", "powerups\\health pack", 131.737, -169.891, 15.870, "health pack - rear left-cliff (red)"},
    { "eqip", "powerups\\health pack", 121.011, -188.595, 13.771, "health pack - rear right-cliff (red)"},
    { "eqip", "powerups\\health pack", 97.504, -188.913, 15.784, "health pack - platform (behind red)"}
}

teleports["bloodgulch"] = {
    { 43.125, - 78.434, - 0.220,        0.5,    15.713, - 102.762, 13.462 },
    { 43.112, - 80.069, - 0.253,        0.5,    68.123, - 92.847, 2.167 },
    { 37.105, - 80.069, - 0.255,        0.5,    108.005, - 109.328, 1.924 },
    { 37.080, - 78.426, - 0.238,        0.5,    79.924, - 64.560, 4.669 },
    { 43.456, - 77.197, 0.633,          0.5,    29.528, - 52.746, 3.100 },
    { 74.304, - 77.590, 6.552,          0.5,    76.001, - 77.936, 11.425 },
    { 98.559, - 158.558, - 0.253,       0.5,    63.338, - 169.305, 3.702 },
    { 98.541, - 160.190, - 0.255,       0.5,    120.801, - 182.946, 6.766 },
    { 92.550, - 158.581, - 0.256,       0.5,    46.934, - 151.024, 4.496 },
    { 92.538, - 160.213, - 0.215,       0.5,    112.550, - 127.203, 1.905 },
    { 98.935, - 157.626, 0.425,         0.5,    95.725, - 91.968, 5.314 },
    { 70.499, - 62.119, 5.382,          0.5,    122.615, - 123.520, 15.916 },
    { 63.693, - 177.303, 5.606,         0.5,    19.030, - 103.428, 19.150 },
    { 120.616, - 185.624, 7.637,        0.5,    94.815, - 114.354, 15.860 },
    { 94.351, - 97.615, 5.184,          0.5,    92.792, - 93.604, 9.501 },
    { 14.852, - 99.241, 8.995,          0.5,    50.409, - 155.826, 21.830 },
    { 43.258, - 45.365, 20.901,         0.5,    82.065, - 68.507, 18.152 },
    { 82.459, - 73.877, 15.729,         0.5,    67.970, - 86.299, 23.393 },
    { 77.289, - 89.126, 22.765,         0.5,    94.772, - 114.362, 15.820 },
    { 101.224, - 117.028, 14.884,       0.5,    125.026, - 135.580, 13.593 },
    { 131.785, - 169.872, 15.951,       0.5,    127.812, - 184.557, 16.420 },
    { 120.665, - 188.766, 13.752,       0.5,    109.956, - 188.522, 14.437 },
    { 97.476, - 188.912, 15.718,        0.5,    53.653, - 157.885, 21.753 },
    { 48.046, - 153.087, 21.181,        0.5,    23.112, - 59.428, 16.352 }
}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
	register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    for i = 1, 16 do
        if player_present(i) then
            DAMAGE_APPLIED[i] = 0
        end
    end
    LoadItems()
end

function OnScriptUnload()
    weapons = { }
    DAMAGE_APPLIED = { }
end

function OnNewGame()
    LoadItems()
    mapname = get_var(1, "$map")
    if get_var(1,"$gt") == "ctf" then
        _index = 7
    elseif get_var(1,"$gt") == "slayer" then
        _index = #objects
    end
    for i = 1, _index do
        if objects[i] ~= { } and objects[i] ~= nil then
            hpn = objects[i]
            object = spawn_object(objects[i][1], objects[i][2], objects[i][3], objects[i][4], objects[i][5])
            --cprint("Spawning: " ..objects[i][6])
        end
    end
    for i = 1, 16 do
        if player_present(i) then
            DAMAGE_APPLIED[i] = 0
        end
    end
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            DAMAGE_APPLIED[i] = 0
        end
    end
end

function OnTick()
    for i = 1, 16 do
        if (player_alive(i)) then
            for j = 1, #teleports[mapname] do
                if teleports[mapname] ~= { } and teleports[mapname][j] ~= nil then
                    local player = read_dword(get_player(i) + 0x34)
                    if inSphere(i, teleports[mapname][j][1], teleports[mapname][j][2], teleports[mapname][j][3], teleports[mapname][j][4]) == true then
                        TeleportPlayer(player, teleports[mapname][j][5], teleports[mapname][j][6], teleports[mapname][j][7])
                    end
                end
            end
        end
    end
	for k = 1,16 do
		if (player_alive(k)) then
            local player = get_dynamic_player(k)
            if (weapon[k] == 0) then
                execute_command("wdel " .. k)
                local x,y,z = read_vector3d(player + 0x5C)
                assign_weapon(spawn_object("weap", weapons[1],x,y,z), k)
                assign_weapon(spawn_object("weap", weapons[2],x,y,z), k)
                weapon[k] = 1
            end
        end
	end
end

function OnPlayerSpawn(PlayerIndex)
	weapon[PlayerIndex] = 0
    timer(500, "SyncAmmo", PlayerIndex)
end

function SyncAmmo(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if player_object ~= 0 then
        local m_weaponId = read_dword(player_object + 0x118)
        local weapon_id = get_object_memory(m_weaponId)
        safe_write(true)
        write_dword(weapon_id + 0x2B8, 200)
        safe_write(false)
        sync_ammo(m_weaponId)
    end
end

function OnPlayerLeave(PlayerIndex)
    DAMAGE_APPLIED[PlayerIndex] = nil
end

function TeleportPlayer(player, x, y, z)
    local object = get_object_memory(player)
    if get_object_memory(player) ~= 0 then
        write_vector3d(object + 0x5C, x, y, z + 0.2)
    end
end

function inSphere(PlayerIndex, x, y, z, radius)
    if PlayerIndex then
        local player_static = get_player(PlayerIndex)
        local obj_x = read_float(player_static + 0xF8)
        local obj_y = read_float(player_static + 0xFC)
        local obj_z = read_float(player_static + 0x100)
        local x_diff = x - obj_x
        local y_diff = y - obj_y
        local z_diff = z - obj_z
        local dist_from_center = math.sqrt(x_diff ^ 2 + y_diff ^ 2 + z_diff ^ 2)
        if dist_from_center <= radius then
            return true
        end
    end
    return false
end

function secondsToTime(seconds, places)
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60
    if places == 2 then
        return minutes, seconds
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    DAMAGE_APPLIED[PlayerIndex] = MetaID
    if MapID == TagID("proj", "weapons\\sniper rifle\\sniper bullet") then
        return true, TagID("proj", "vehicles\\scorpion\\tank shell")
    end
    -- Pistol Bullet Projectile
    if MetaID == PISTOL_BULLET then
        return true, Damage * 4
    end
    -- Sniper Rifle Projectile
    if MetaID == SNIPER_RIFLE_BULLET then
        return true, Damage * 4
    end
    -- Rocket Projectile / Rhog Rocket
    if MetaID == ROCKET_EXPLODE then
        if PlayerInVehicle(PlayerIndex) then
            return true, Damage * 4
        else
            return true, Damage * 4
        end
    end
    -- Ghost Bolt Damage --
    if MetaID == VEHICLE_GHOST_BOLT then
        return true, Damage * 4
    end
    -- Warthog Bullet Damage --
    if MetaID == WARTHOG_BULLET then
        return true, Damage * 4
    end
    -- Tank Shell Damage --
    if MetaID == VEHICLE_TANK_SHELL then
        return true, Damage * 4
    end
    -- Tank Bullet Damage --
    if MetaID == VEHICLE_TANK_BULLET then
        return true, Damage * 4
    end
    -- Banshee Bolt Damage --
    if MetaID == VEHICLE_BANSHEE_BOLT then
        return true, Damage * 4
    end
    -- Banshee Fuelrod Damage --
    if MetaID == VEHICLE_BANSHEE_FUEL_ROD then
        return true, Damage * 4
    end
    -- Grenade Damage --
    if (MetaID == GRENADE_FRAG_EXPLOSION) or (MetaID == GRENADE_PLASMA_ATTACHED) or (MetaID == GRENADE_PLASMA_EXPLOSION) then
        return true, Damage * 4
    end
    -- Melee Damage --
    if MetaID == MELEE_PISTOL or MetaID == MELEE_SNIPER_RIFLE then
        return true, Damage * 4
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    DAMAGE_APPLIED[PlayerIndex] = 0
end

function LoadItems()
    -- Melee --
    MELEE_ASSAULT_RIFLE = TagID("jpt!", "weapons\\assault rifle\\melee")
    MELEE_ODDBALL = TagID("jpt!", "weapons\\ball\\melee")
    MELEE_FLAG = TagID("jpt!", "weapons\\flag\\melee")
    MELEE_FLAME_THROWER = TagID("jpt!", "weapons\\flamethrower\\melee")
    MELEE_NEEDLER = TagID("jpt!", "weapons\\needler\\melee")
    MELEE_PISTOL = TagID("jpt!", "weapons\\pistol\\melee")
    MELEE_PLASMA_PISTOL = TagID("jpt!", "weapons\\plasma pistol\\melee")
    MELEE_PLASMA_RIFLE = TagID("jpt!", "weapons\\plasma rifle\\melee")
    MELEE_ROCKET_LAUNCHER = TagID("jpt!", "weapons\\rocket launcher\\melee")
    MELEE_SHOTGUN = TagID("jpt!", "weapons\\shotgun\\melee")
    MELEE_SNIPER_RIFLE = TagID("jpt!", "weapons\\sniper rifle\\melee")
    MELEE_PLASMA_CANNON = TagID("jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_melee")
    -- Grenades Explosion/Attached --
    GRENADE_FRAG_EXPLOSION = TagID("jpt!", "weapons\\frag grenade\\explosion")
    GRENADE_PLASMA_EXPLOSION = TagID("jpt!", "weapons\\plasma grenade\\explosion")
    GRENADE_PLASMA_ATTACHED = TagID("jpt!", "weapons\\plasma grenade\\attached")
    -- Vehicles --
    VEHICLE_GHOST_BOLT = TagID("jpt!", "vehicles\\ghost\\ghost bolt")
    WARTHOG_BULLET = TagID("proj", "vehicles\\warthog\\bullet")
    RHOG_ROCKET = TagID("jpt!", "vehicles\\ghost\\ghost bolt")
    VEHICLE_TANK_BULLET = TagID("jpt!", "vehicles\\scorpion\\bullet")
    VEHICLE_TANK_SHELL = TagID("jpt!", "vehicles\\scorpion\\tank shell")
    VEHICLE_BANSHEE_BOLT = TagID("jpt!", "vehicles\\banshee\\banshee bolt")
    VEHICLE_BANSHEE_FUEL_ROD = TagID("jpt!", "vehicles\\banshee\\mp_banshee fuel rod")
    -- weapon projectiles --
    PISTOL_BULLET = TagID("jpt!", "weapons\\pistol\\bullet")
    SNIPER_RIFLE_BULLET = TagID("jpt!", "weapons\\sniper rifle\\sniper bullet")
    ROCKET_EXPLODE = TagID("jpt!", "weapons\\rocket launcher\\explosion")
end

function OnError(Message)
    print(debug.traceback())
end

-- Credits to 002 for this function
function TagID(tagclass, tagname)
    local tagarray = read_dword(0x40440000)
    for i = 0, read_word(0x4044000C) -1 do
        local tag = tagarray + i * 0x20
        local class = string.reverse(string.sub(read_string(tag), 1, 4))
        if (class == tagclass) then
            if (read_string(read_dword(tag + 0x10)) == tagname) then
                return read_dword(tag + 0xC)
            end
        end
    end
    return nil
end
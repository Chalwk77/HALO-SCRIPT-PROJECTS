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
weapons[1] = "weapons\\pistol\\pistol"
weapons[2] = "weapons\\sniper rifle\\sniper rifle"

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPreSpawn")
    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    LoadItems()
    for i = 1, 16 do
        if player_present(i) then
            -- null
        end
    end
end

function OnScriptUnload()
    weapons = { }
    -- null
end

function OnNewGame()
    LoadItems()
    mapname = get_var(1, "$map")
    for i = 1, #objects do
        if objects[i] ~= nil then
            local object = spawn_object(objects[i][1], objects[i][2], objects[i][3], objects[i][4], objects[i][5])
            if tostring(objects[i][1]) == "vehi" then
                local obj_id = get_object_memory(object)
                local fx, fy, fz = objects[i][7], objects[i][8], objects[i][9]
                local px, py, pz = read_vector3d(obj_id + 0x5c)
                local ox = fx - px
                local oy = fy - py
                local oz = fz - pz
                local magnitude = math.sqrt(ox * ox + oy * oy + oz * oz)
                ox = ox / magnitude
                oy = oy / magnitude
                oz = oz / magnitude
                write_float(obj_id + 0x74, ox)
                write_float(obj_id + 0x78, oy)
                write_float(obj_id + 0x7c, oz)
            end
        end
    end
    for i = 1, 16 do
        if player_present(i) then
            -- null
        end
    end
end

function OnGameEnd()
    for i = 1, 16 do
        if player_present(i) then
            -- null
        end
    end
end

function OnTick()
    for i = 1, 16 do
        if (player_alive(i)) then
            for j = 1, #teleports[mapname] do
                if teleports[mapname][j] ~= nil then
                    local player = read_dword(get_player(i) + 0x34)
                    if GEOinSpherePlayer(i, teleports[mapname][j][1], teleports[mapname][j][2], teleports[mapname][j][3], teleports[mapname][j][4]) == true then
                        TeleportPlayer(player, teleports[mapname][j][5], teleports[mapname][j][6], teleports[mapname][j][7])
                    end
                end
            end
        end
    end
    for k = 1, 16 do
        if (player_alive(k)) then
            local player = get_dynamic_player(k)
            if (weapon[k] == 0) then
                execute_command("wdel " .. k)
                local x, y, z = read_vector3d(player + 0x5C)
                assign_weapon(spawn_object("weap", weapons[1], x, y, z), k)
                assign_weapon(spawn_object("weap", weapons[2], x, y, z), k)
                weapon[k] = 1
            end
        end
    end
end

function OnPlayerPreSpawn(PlayerIndex)
    -- null
end

function OnPlayerSpawn(PlayerIndex)
    weapon[PlayerIndex] = 0
    timer(1000 * 1, "SyncAmmo", PlayerIndex)
    execute_command_sequence("w8 1; ammo " .. PlayerIndex .. " 100")
end

function OnPlayerLeave(PlayerIndex)
    -- null
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

function TeleportPlayer(player, x, y, z)
    local object = get_object_memory(player)
    if get_object_memory(player) ~= 0 then
        write_vector3d(object + 0x5C, x, y, z + 0.2)
    end
end

function GEOinSpherePlayer(PlayerIndex, posX, posY, posZ, Radius)
    local player_object = get_dynamic_player(PlayerIndex)
    local Xaxis, Yaxis, Zaxis = read_vector3d(player_object + 0x5C)
    if (posX - Xaxis) ^ 2 +(posY - Yaxis) ^ 2 +(posZ - Zaxis) ^ 2 <= Radius then
        return true
    else
        return false
    end
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

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    if MapID == TagInfo("proj", "weapons\\sniper rifle\\sniper bullet") then
        return true, TagInfo("proj", "vehicles\\scorpion\\tank shell")
    end
    if MapID == TagInfo("proj", "weapons\\pistol\\bullet") then
        return true, TagInfo("proj", "vehicles\\scorpion\\tank shell")
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    -- Prevent Tank Shell explosion suicide
    if PlayerIndex == CauserIndex then
        if (MetaID == VEHICLE_TANK_SHELL_EXPLOSION) then
            return true, Damage * 0
        end
    end
    -- Pistol Bullet Projectile
    if (MetaID == PISTOL_BULLET) then
        return true, Damage * 4
    end
    -- Sniper Rifle Projectile
    if (MetaID == SNIPER_RIFLE_BULLET) then
        return true, Damage * 4
    end
    -- Rocket Projectile / Rhog Rocket
    if (MetaID == ROCKET_EXPLODE) then
        if PlayerInVehicle(PlayerIndex) then
            return true, Damage * 4
        else
            return true, Damage * 4
        end
    end
    -- Ghost Bolt Damage --
    if (MetaID == VEHICLE_GHOST_BOLT) then
        return true, Damage * 4
    end
    -- Warthog Bullet Damage --
    if (MetaID == WARTHOG_BULLET) then
        return true, Damage * 4
    end
    -- Tank Shell Damage --
    if (MetaID == VEHICLE_TANK_SHELL) then
        return true, Damage * 4
    end
    -- Tank Bullet Damage --
    if (MetaID == VEHICLE_TANK_BULLET) then
        return true, Damage * 4
    end
    -- Banshee Bolt Damage --
    if (MetaID == VEHICLE_BANSHEE_BOLT) then
        return true, Damage * 4
    end
    -- Banshee Fuelrod Damage --
    if (MetaID == VEHICLE_BANSHEE_FUEL_ROD) then
        return true, Damage * 4
    end
    -- Grenade Damage --
    if (MetaID == FRAG_EXPLOSION) or(MetaID == FRAG_SHOCKWAVE) or(MetaID == PLASMA_ATTACHED) or(MetaID == PLASMA_EXPLOSION) or(MetaID == PLASMA_SHOCKWAVE) then
        return true, Damage * 4
    end
    -- Melee Damage --
    if (MetaID == MELEE_PISTOL) or(MetaID == MELEE_SNIPER_RIFLE) then
        return true, Damage * 4
    end
end

function LoadItems()
    objects = {
        { "vehi", "vehicles\\banshee\\banshee_mp", 64.178, - 176.802, 3.960, "Red Banshee", 280, - 10, 0 },
        { "vehi", "vehicles\\banshee\\banshee_mp", 70.078, - 62.626, 3.758, "Blue Banshee", - 90, - 200, 0 },
        { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 118.084, - 185.346, 6.563, "Red Turret", - 100.00, - 20.00, 0 },
        { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 29.544, - 53.628, 3.302, "Blue Turret", 90.00, - 150.00, 0 },
        { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 51.315, - 154.075, 21.561, "Cliff Turret", - 100.00, - 20.00, 0 },
        { "vehi", "vehicles\\ghost\\ghost_mp", 59.294, - 116.212, 1.797, "Ghost [Mid-Field]", - 100.00, - 20.00, 0 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 104.017, - 129.761, 1.665, "Tank [Knoll]", - 100.00, - 20.00, 0 },
        { "eqip", "powerups\\health pack", 37.070, - 80.068, - 0.286, "health pack - bluebase" },
        { "eqip", "powerups\\health pack", 37.105, - 78.421, - 0.286, "health pack - bluebase" },
        { "eqip", "powerups\\health pack", 43.144, - 78.442, - 0.286, "health pack - bluebase" },
        { "eqip", "powerups\\health pack", 43.136, - 80.072, - 0.286, "health pack - bluebase" },
        { "eqip", "powerups\\health pack", 43.512, - 77.153, - 0.286, "health pack - bluebase" },
        { "eqip", "powerups\\health pack", 74.391, - 77.651, 5.698, "health pack - blue path" },
        { "eqip", "powerups\\health pack", 70.650, - 61.932, 4.095, "health pack - blue banshee" },
        { "eqip", "powerups\\health pack", 63.551, - 177.337, 4.181, "health pack - red banshee" },
        { "eqip", "powerups\\health pack", 98.930, - 157.614, - 0.249, "health pack - redbase" },
        { "eqip", "powerups\\health pack", 98.498, - 158.564, - 0.228, "health pack - redbase" },
        { "eqip", "powerups\\health pack", 98.508, - 160.189, - 0.228, "health pack - redbase" },
        { "eqip", "powerups\\health pack", 92.555, - 160.193, - 0.228, "health pack - redbase" },
        { "eqip", "powerups\\health pack", 92.560, - 158.587, - 0.228, "health pack - redbase" },
        { "eqip", "powerups\\health pack", 120.247, - 185.103, 6.495, "health pack - red turret" },
        { "eqip", "powerups\\health pack", 94.351, - 97.615, 5.184, "health pack - Rock between the caves" },
        { "eqip", "powerups\\health pack", 12.928, - 103.277, 13.990, "health pack - Nest" },
        { "eqip", "powerups\\health pack", 48.060, - 153.092, 21.190, "health pack - turret mountain" },
        { "eqip", "powerups\\health pack", 43.253, - 45.376, 20.920, "health pack - rear cliff (blue)" },
        { "eqip", "powerups\\health pack", 43.253, - 45.376, 20.920, "health pack - corner cliff (blue)" },
        { "eqip", "powerups\\health pack", 77.279, - 89.107, 22.571, "health pack - cliff (overlooking mid field)" },
        { "eqip", "powerups\\health pack", 101.034, - 117.048, 14.795, "health pack - platform (overlooking redbase)" },
        { "eqip", "powerups\\health pack", 118.244, - 120.757, 17.229, "cliff - overlooking red (banshee platform)" },
        { "eqip", "powerups\\health pack", 131.737, - 169.891, 15.870, "health pack - rear left-cliff (red)" },
        { "eqip", "powerups\\health pack", 121.011, - 188.595, 13.771, "health pack - rear right-cliff (red)" },
        { "eqip", "powerups\\health pack", 97.504, - 188.913, 15.784, "health pack - platform (behind red)" }
    }

    teleports["bloodgulch"] = {
        { 43.125, - 78.434, - 0.220, 0.5, 15.713, - 102.762, 13.462 },
        { 43.112, - 80.069, - 0.253, 0.5, 68.123, - 92.847, 2.167 },
        { 37.105, - 80.069, - 0.255, 0.5, 108.005, - 109.328, 1.924 },
        { 37.080, - 78.426, - 0.238, 0.5, 79.924, - 64.560, 4.669 },
        { 43.456, - 77.197, 0.633, 0.5, 29.528, - 52.746, 3.100 },
        { 74.304, - 77.590, 6.552, 0.5, 76.001, - 77.936, 11.425 },
        { 98.559, - 158.558, - 0.253, 0.5, 63.338, - 169.305, 3.702 },
        { 98.541, - 160.190, - 0.255, 0.5, 120.801, - 182.946, 6.766 },
        { 92.550, - 158.581, - 0.256, 0.5, 46.934, - 151.024, 4.496 },
        { 92.538, - 160.213, - 0.215, 0.5, 112.550, - 127.203, 1.905 },
        { 98.935, - 157.626, 0.425, 0.5, 95.725, - 91.968, 5.314 },
        { 70.499, - 62.119, 5.382, 0.5, 122.615, - 123.520, 15.916 },
        { 63.693, - 177.303, 5.606, 0.5, 19.030, - 103.428, 19.150 },
        { 120.616, - 185.624, 7.637, 0.5, 94.815, - 114.354, 15.860 },
        { 94.351, - 97.615, 5.184, 0.5, 92.792, - 93.604, 9.501 },
        { 14.852, - 99.241, 8.995, 0.5, 50.409, - 155.826, 21.830 },
        { 43.258, - 45.365, 20.901, 0.5, 82.065, - 68.507, 18.152 },
        { 82.459, - 73.877, 15.729, 0.5, 67.970, - 86.299, 23.393 },
        { 77.289, - 89.126, 22.765, 0.5, 94.772, - 114.362, 15.820 },
        { 101.224, - 117.028, 14.884, 0.5, 125.026, - 135.580, 13.593 },
        { 131.785, - 169.872, 15.951, 0.5, 127.812, - 184.557, 16.420 },
        { 120.665, - 188.766, 13.752, 0.5, 109.956, - 188.522, 14.437 },
        { 97.476, - 188.912, 15.718, 0.5, 53.653, - 157.885, 21.753 },
        { 48.046, - 153.087, 21.181, 0.5, 23.112, - 59.428, 16.352 },
        { 118.263, - 120.761, 17.192, 0.5, 40.194, - 139.990, 2.733 }
    }
    -- Melee --
    MELEE_PISTOL = get_tag_info("jpt!", "weapons\\pistol\\melee")
    MELEE_SNIPER_RIFLE = get_tag_info("jpt!", "weapons\\sniper rifle\\melee")
    -- Grenades Explosion/Attached --
    FRAG_EXPLOSION = get_tag_info("jpt!", "weapons\\frag grenade\\explosion")
    FRAG_SHOCKWAVE = get_tag_info("jpt!", "weapons\\frag grenade\\shock wave")
    PLASMA_ATTACHED = get_tag_info("jpt!", "weapons\\plasma grenade\\attached")
    PLASMA_EXPLOSION = get_tag_info("jpt!", "weapons\\plasma grenade\\explosion")
    PLASMA_SHOCKWAVE = get_tag_info("jpt!", "weapons\\plasma grenade\\shock wave")
    -- Vehicles --
    WARTHOG_BULLET = get_tag_info("proj", "vehicles\\warthog\\bullet")
    VEHICLE_GHOST_BOLT = get_tag_info("jpt!", "vehicles\\ghost\\ghost bolt")
    VEHICLE_TANK_BULLET = get_tag_info("jpt!", "vehicles\\scorpion\\bullet")
    VEHICLE_TANK_SHELL = get_tag_info("jpt!", "vehicles\\scorpion\\tank shell")
    VEHICLE_BANSHEE_BOLT = get_tag_info("jpt!", "vehicles\\banshee\\banshee bolt")
    VEHICLE_BANSHEE_FUEL_ROD = get_tag_info("jpt!", "vehicles\\banshee\\mp_banshee fuel rod")
    VEHICLE_TANK_SHELL_EXPLOSION = get_tag_info("jpt!", "vehicles\\scorpion\\shell explosion")
    -- weapon projectiles --
    PISTOL_BULLET = get_tag_info("jpt!", "weapons\\pistol\\bullet")
    SNIPER_RIFLE_BULLET = get_tag_info("jpt!", "weapons\\sniper rifle\\sniper bullet")
    ROCKET_EXPLODE = get_tag_info("jpt!", "weapons\\rocket launcher\\explosion")
    local tag_address = read_dword(0x40440000)
    local tag_count = read_dword(0x4044000C)
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        local tag_data = read_dword(tag + 0x14)
        -- Changes proj velocity of grenades
        if (tag_class == 1651077220 and tag_name == "characters\\cyborg_mp\\cyborg_mp") then
            write_dword(tag_data + 0x2c0, 1097859072)
        end
        -- Changes proj velocity of tank shell
        if (tag_name == "vehicles\\scorpion\\tank shell") then
            write_float(tag_data + 0x1E8, 1097859072)
        end
    end
end

function get_tag_info(tagclass, tagname)
    -- Credits to 002 for this function
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

function TagInfo(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function OnError(Message)
    print(debug.traceback())
end

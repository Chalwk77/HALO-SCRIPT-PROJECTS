--[[
------------------------------------
Script Name: {ØZ}-4 Snipers Dream Team Mod

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

api_version = "1.12.0.0"
tbag = { }
weapon = { }
weapons = { }
objects = { }
players = { }
teleports = { }
flag_bool = { }
victim_coords = { }
crouch = { }

frag_check = { }
plasma_check = { }
join_trigger = {}

globals = nil
player_count = 0

weapons[1] = {"weap", "weapons\\pistol\\pistol", true}
weapons[2] = {"weap", "weapons\\sniper rifle\\sniper rifle", true}

vehicles = { }
vehicles[1] = { "vehi", "vehicles\\warthog\\mp_warthog", "Warthog"}
vehicles[2] = { "vehi", "vehicles\\ghost\\ghost_mp", "Ghost"}
vehicles[3] = { "vehi", "vehicles\\rwarthog\\rwarthog", "RocketHog"}
vehicles[4] = { "vehi", "vehicles\\banshee\\banshee_mp", "Banshee"}
vehicles[5] = { "vehi", "vehicles\\scorpion\\scorpion_mp", "Tank"}
vehicles[6] = { "vehi", "vehicles\\c gun turret\\c gun turret_mp", "Turret"}

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPreSpawn")
    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
    --register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")
    local gp = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if(gp == 3) then return end
    globals = read_dword(gp)
    InitSettings()
end

function OnScriptUnload()
    weapons = { }
end

function OnNewGame()
    InitSettings()
    mapname = get_var(1, "$map")
    for i = 1, #objects do
        if objects[i] ~= nil then
            local object = spawn_object(objects[i][1], objects[i][2], objects[i][3], objects[i][4], objects[i][5], objects[i][7])
        end
    end
    for i = 1, player_count do
        if player_present(i) then
            players[get_var(i, "$n")].flag_captures = 0
            tbag[i] = { }
        end
    end
end

function OnGameEnd()
    game_over = true
end

function OnTick()
    for i = 1, player_count do
        if (player_alive(i)) then
            for j = 1, #teleports[mapname] do
                if teleports[mapname][j] ~= nil then
                    local player = get_dynamic_player(i)
                    if player ~= 0 then
                        if getPlayerCoords(i, teleports[mapname][j][1], teleports[mapname][j][2], teleports[mapname][j][3], teleports[mapname][j][4]) == true then
                            write_vector3d(player + 0x5C, teleports[mapname][j][5], teleports[mapname][j][6], teleports[mapname][j][7] + 0.3)
                        end
                    end
                end
            end
        end
    end
    for k = 1, player_count do
        if (player_alive(k)) then
            local player = get_dynamic_player(k)
            if (weapon[k] == false) then
                execute_command("wdel " .. k)
                local x, y, z = read_vector3d(player + 0x5C)
                for i = 1, #weapons do
                    if weapons[i][3] == true then
                        assign_weapon(spawn_object(weapons[i][1], weapons[i][2], x, y, z), k)
                    end
                end
                weapon[k] = true
            end
        end
    end
    for m = 1, player_count do
        if (player_alive(m)) then
            if get_var(m, "$team") == "red" then
                if CheckBlueFlag(m) == true and flag_bool[m] then
                    if getPlayerCoords(m, 95.688, - 159.449, - 0.100, 1) then
                        say_all(get_var(m, "$name") .. " scored a flag for the red team!")
                        players[get_var(m, "$n")].flag_captures = players[get_var(m, "$n")].flag_captures + 1
                        rprint(m, "You have " .. tonumber(math.floor(players[get_var(m, "$n")].flag_captures)) .. " flag captures!")
                    end
                end
            elseif get_var(m, "$team") == "blue" then
                if CheckRedFlag(m) == true and flag_bool[m] then
                    if getPlayerCoords(m, 40.241, - 79.123, - 0.100, 1) then
                        say_all(get_var(m, "$name") .. " scored a flag for the blue team!")
                        players[get_var(m, "$n")].flag_captures = players[get_var(m, "$n")].flag_captures + 1
                        rprint(m, "You have " .. tonumber(math.floor(players[get_var(m, "$n")].flag_captures)) .. " flag captures!")
                    end
                end
            end
            if (CheckBlueFlag(m) and flag_bool[m] == nil) then
                flag_bool[m] = true
                say_all(get_var(m, "$name") .. " has the blue teams flag!")
            elseif (CheckRedFlag(m) and flag_bool[m] == nil) then
                flag_bool[m] = true
                say_all(get_var(m, "$name") .. " has the red teams flag!")
            else
                execute_command("s " .. m .. " 1")
            end
        end
    end
    for n = 1, player_count do
        if player_present(n) then
            if tbag[n] == nil then tbag[n] = { } end
            if tbag[n].name and tbag[n].x then
                if not PlayerInVehicle(n) then
                    if getPlayerCoords(n, tbag[n].x, tbag[n].y, tbag[n].z, 5) then
                        local player_object = get_dynamic_player(n)
                        local obj_crouch = read_byte(player_object + 0x2A0)
                        local id = get_var(n, "$n")
                        if obj_crouch == 3 and crouch[id] == nil then
                            crouch[id] = OnPlayerCrouch(n)
                        elseif obj_crouch ~= 3 and crouch[id] ~= nil then
                            crouch[id] = nil
                        end
                    end
                end
            end
        end
    end
    for o = 1, 16 do
        if (player_alive(o)) then
            if frag_check[o] and FragCheck(o) == false then
                frag_check[o] = nil
            elseif FragCheck(o) and frag_check[o] == nil then
                local player = get_dynamic_player(o)
                if player ~= nil then
                    safe_write(true)
                    write_word(player + 0x31E, 4)
                    safe_write(false)
                    frag_check[o] = true
                end
            end
            if plasma_check[o] and PlasmaCheck(o) == false then
                plasma_check[o] = nil
            elseif PlasmaCheck(o) and plasma_check[o] == nil then
                local player = get_dynamic_player(o)
                if player ~= nil then
                    safe_write(true)
                    write_word(player + 0x31F, 4)
                    safe_write(false)
                    plasma_check[o] = true
                end
            end
        end
    end
end

function OnPlayerJoin(PlayerIndex)
    player_count = player_count + 1
    players[get_var(PlayerIndex, "$n")] = { }
    players[get_var(PlayerIndex, "$n")].flag_captures = 0
    tbag[PlayerIndex] = { }
    join_trigger[PlayerIndex] = true
end

function OnPlayerPreSpawn(PlayerIndex)
    -- update player grenades (ONCE) upon joining the server.
    if join_trigger[PlayerIndex] == true then
        join_trigger[PlayerIndex] = false
        local player = get_dynamic_player(PlayerIndex)
        if player then
            safe_write(true)
            write_word(player + 0x31E, 4)
            write_word(player + 0x31F, 4)
            safe_write(false)
        end
    end
end

function OnPlayerSpawn(PlayerIndex)
    weapon[PlayerIndex] = false
    local wait_time = 1
    execute_command_sequence("w8 " .. wait_time .. "; ammo " .. PlayerIndex .. " " .. 999)
    execute_command_sequence("w8 " .. wait_time .. "; mag " .. PlayerIndex .. " " .. 999)
    local player = get_dynamic_player(PlayerIndex)
    frag_check[PlayerIndex] = true
    plasma_check[PlayerIndex] = true
end

function OnPlayerLeave(PlayerIndex)
    player_count = player_count - 1
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    plasma_check[PlayerIndex] = false
    frag_check[PlayerIndex] = false
    local victim = tonumber(PlayerIndex)
    local killer = tonumber(KillerIndex)
    if (killer > 0) and (victim ~= killer) then
        tbag[victim] = { }
        tbag[killer] = { }
        tbag[killer].count = 0
        tbag[killer].name = get_var(victim, "$name")
        if victim_coords[victim] == nil then victim_coords[victim] = { } end
        if victim_coords[victim].x then
            tbag[killer].x = victim_coords[victim].x
            tbag[killer].y = victim_coords[victim].y
            tbag[killer].z = victim_coords[victim].z
        end
    end
end

function OnPlayerCrouch(PlayerIndex)
    if tbag[PlayerIndex].count == nil then
        tbag[PlayerIndex].count = 0
    end
    tbag[PlayerIndex].count = tbag[PlayerIndex].count + 1
    if tbag[PlayerIndex].count == 4 then
        tbag[PlayerIndex].count = 0
        say_all(get_var(PlayerIndex, "$name") .. " is t-bagging " .. tbag[PlayerIndex].name)
        tbag[PlayerIndex].name = nil
    end
    return true
end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    if (MetaID == TagInfo("weap", "weapons\\assault rifle\\assault rifle")) then
        return true, TagInfo("weap", "weapons\\sniper rifle\\sniper rifle")
    end
    if (MetaID == TagInfo("weap", "weapons\\flamethrower\\flamethrower")) then
        return true, TagInfo("weap", "weapons\\sniper rifle\\sniper rifle")
    end
    if (MetaID == TagInfo("weap", "weapons\\needler\\mp_needler")) then
        return true, TagInfo("weap", "weapons\\sniper rifle\\sniper rifle")
    end
    if (MetaID == TagInfo("weap", "weapons\\plasma pistol\\plasma pistol")) then
        return true, TagInfo("weap", "weapons\\sniper rifle\\sniper rifle")
    end
    if (MetaID == TagInfo("weap", "weapons\\plasma rifle\\plasma rifle")) then
        return true, TagInfo("weap", "weapons\\sniper rifle\\sniper rifle")
    end
    if (MetaID == TagInfo("weap", "weapons\\plasma_cannon\\plasma_cannon")) then
        return true, TagInfo("weap", "weapons\\sniper rifle\\sniper rifle")
    end
    if (MetaID == TagInfo("weap", "weapons\\rocket launcher\\rocket launcher")) then
        return true, TagInfo("weap", "weapons\\sniper rifle\\sniper rifle")
    end
    if (MetaID == TagInfo("weap", "weapons\\shotgun\\shotgun")) then
        return true, TagInfo("weap", "weapons\\sniper rifle\\sniper rifle")
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    -- Prevent Tank Shell explosion suicide
    if PlayerIndex == CauserIndex then
        if (MetaID == TagInfo("jpt!", "vehicles\\scorpion\\shell explosion")) then
            return true, Damage * 0
        end
    end
    local player_object = get_dynamic_player(PlayerIndex)
    if player_object then
        local x, y, z = read_vector3d(player_object + 0x5C)
        if victim_coords[PlayerIndex] == nil then
            victim_coords[PlayerIndex] = { }
        end
        if victim_coords[PlayerIndex] then
            victim_coords[PlayerIndex].x = x
            victim_coords[PlayerIndex].y = y
            victim_coords[PlayerIndex].z = z
        end
    end
end

function CheckRedFlag(PlayerIndex)
    local red_flag = read_dword(globals + 0x8)
    for i = 0, 3 do
        local object = read_dword(get_dynamic_player(PlayerIndex) + 0x2F8 + 4 * i)
        if (object == red_flag) then return true end
    end
    return false
end

function CheckBlueFlag(PlayerIndex)
    local blue_flag = read_dword(globals + 0xC)
    for i = 0, 3 do
        local object = read_dword(get_dynamic_player(PlayerIndex) + 0x2F8 + 4 * i)
        if (object == blue_flag) then return true end
    end
    return false
end

function InitSettings()
    execute_command("scorelimit 50")
    objects = {
        -- blue vehicles
        { "vehi", "vehicles\\banshee\\banshee_mp", 70.078, - 62.626, 3.758, "Blue Banshee", 10 },
        { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 29.544, - 53.628, 3.302, "Blue Turret", 124.5 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 23.598, - 102.343, 2.163, "Blue Tank [Ramp]", 90 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 38.119, - 64.898, 0.617, "Blue Tank [Immediate Rear of Base]", 90 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 51.349, - 61.517, 1.759, "Blue Tank [Rear-Right of Base]", 90 },
        { "vehi", "vehicles\\rwarthog\\rwarthog", 50.655, - 87.787, 0.079, "Blue Rocket Hog [Front-Right of Base]", - 90 },
        { "vehi", "vehicles\\rwarthog\\rwarthog", 62.745, - 72.406, 1.031, "Blue Rocket Hog [Far-Right of Base]", 90 },
        { "vehi", "vehicles\\warthog\\mp_warthog", 28.854, - 90.193, 0.434, "Blue Chain Gun Hog [Front-Left of Base]", 90 },

        -- red vehicles
        { "vehi", "vehicles\\banshee\\banshee_mp", 64.178, - 176.802, 3.960, "Red Banshee", 120 },
        { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 118.084, - 185.346, 6.563, "Red Turret", 90 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 104.017, - 129.761, 1.665, "Red Tank [Dark-Side]", 90 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 97.117, - 173.132, 0.744, "Red Tank [Immediate Rear of Base]", 90 },
        { "vehi", "vehicles\\scorpion\\scorpion_mp", 81.150, - 169.359, 0.158, "Red Tank [Rear-Right of Base]", 90 },
        { "vehi", "vehicles\\rwarthog\\rwarthog", 106.885, - 169.245, 0.091, "Red Rocket Hog [Left-Rear of Base]", 90 },
        { "vehi", "vehicles\\warthog\\mp_warthog", 67.961, - 171.002, 1.428, "Red Chain Gun Hog [Far Right of Base]", 90 },
        { "vehi", "vehicles\\warthog\\mp_warthog", 102.312, - 144.626, 0.580, "Red Chain Gun Hog [Front-Left of Base]", 90 },
        { "vehi", "vehicles\\warthog\\mp_warthog", 43.559, - 64.809, 1.113, "Red Chain Gun Hog [Immediate Rear of Base]", 90 },

        -- other vehicles
        { "vehi", "vehicles\\ghost\\ghost_mp", 59.294, - 116.212, 1.797, "Ghost [Mid-Field]", 90 },
        { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 51.315, - 154.075, 21.561, "Cliff Turret", 90 },

        -- health packs [these designate portal locations]
        { "eqip", "powerups\\health pack", 37.070, - 80.068, - 0.286, "health pack - bluebase", 90},
        { "eqip", "powerups\\health pack", 37.105, - 78.421, - 0.286, "health pack - bluebase", 90},
        { "eqip", "powerups\\health pack", 43.144, - 78.442, - 0.286, "health pack - bluebase", 90},
        { "eqip", "powerups\\health pack", 43.136, - 80.072, - 0.286, "health pack - bluebase", 90},
        { "eqip", "powerups\\health pack", 43.512, - 77.153, - 0.286, "health pack - bluebase", 90},

        { "eqip", "powerups\\health pack", 98.930, - 157.614, - 0.249, "health pack - redbase", 90},
        { "eqip", "powerups\\health pack", 98.498, - 158.564, - 0.228, "health pack - redbase", 90},
        { "eqip", "powerups\\health pack", 98.508, - 160.189, - 0.228, "health pack - redbase", 90},
        { "eqip", "powerups\\health pack", 92.555, - 160.193, - 0.228, "health pack - redbase", 90},
        { "eqip", "powerups\\health pack", 92.560, - 158.587, - 0.228, "health pack - redbase", 90}

        -- { "eqip", "powerups\\health pack", 74.391, - 77.651, 5.698, "health pack - blue path", 90},
        -- { "eqip", "powerups\\health pack", 70.650, - 61.932, 4.095, "health pack - blue banshee", 90},
        -- { "eqip", "powerups\\health pack", 63.551, - 177.337, 4.181, "health pack - red banshee", 90},
        -- { "eqip", "powerups\\health pack", 120.247, - 185.103, 6.495, "health pack - red turret", 90},
        -- { "eqip", "powerups\\health pack", 94.351, - 97.615, 5.184, "health pack - Rock between the caves", 90},
        -- { "eqip", "powerups\\health pack", 12.928, - 103.277, 13.990, "health pack - Nest", 90},
        -- { "eqip", "powerups\\health pack", 48.060, - 153.092, 21.190, "health pack - turret mountain", 90},
        -- { "eqip", "powerups\\health pack", 43.253, - 45.376, 20.920, "health pack - rear cliff (blue)", 90},
        -- { "eqip", "powerups\\health pack", 43.253, - 45.376, 20.920, "health pack - corner cliff (blue)", 90},
        -- { "eqip", "powerups\\health pack", 77.279, - 89.107, 22.571, "health pack - cliff (overlooking mid field)", 90},
        -- { "eqip", "powerups\\health pack", 101.034, - 117.048, 14.795, "health pack - platform (overlooking redbase)", 90},
        -- { "eqip", "powerups\\health pack", 118.244, - 120.757, 17.229, "cliff - overlooking red (banshee platform)", 90},
        -- { "eqip", "powerups\\health pack", 131.737, - 169.891, 15.870, "health pack - rear left-cliff (red)", 90},
        -- { "eqip", "powerups\\health pack", 121.011, - 188.595, 13.771, "health pack - rear right-cliff (red)", 90},
        -- { "eqip", "powerups\\health pack", 97.504, - 188.913, 15.784, "health pack - platform (behind red)", 90}
    }

    teleports["bloodgulch"] = {
        { 43.125, - 78.434, - 0.220, 0.5, 15.713, - 102.762, 13.462, 280, - 10, 0, "1"},
        { 43.112, - 80.069, - 0.253, 0.5, 68.123, - 92.847, 2.167, 280, - 10, 0, "2"},
        { 37.105, - 80.069, - 0.255, 0.5, 108.005, - 109.328, 1.924, 280, - 10, 0, "3"},
        { 37.080, - 78.426, - 0.238, 0.5, 79.924, - 64.560, 4.669, 280, - 10, 0, "4"},
        { 43.456, - 77.197, 0.633, 0.5, 29.528, - 52.746, 3.100, 280, - 10, 0, "5"},
        { 74.304, - 77.590, 6.552, 0.5, 76.001, - 77.936, 11.425, 280, - 10, 0, "6"},
        { 98.559, - 158.558, - 0.253, 0.5, 63.338, - 169.305, 3.702, 280, - 10, 0, "7"},
        { 98.541, - 160.190, - 0.255, 0.5, 120.801, - 182.946, 6.766, 280, - 10, 0, "8"},
        { 92.550, - 158.581, - 0.256, 0.5, 46.934, - 151.024, 4.496, 280, - 10, 0, "9"},
        { 92.538, - 160.213, - 0.215, 0.5, 112.550, - 127.203, 1.905, 280, - 10, 0, "10"},
        { 98.935, - 157.626, 0.425, 0.5, 95.725, - 91.968, 5.314, 280, - 10, 0, "11"},
        { 70.499, - 62.119, 5.382, 0.5, 122.615, - 123.520, 15.916, 280, - 10, 0, "12"},
        { 63.693, - 177.303, 5.606, 0.5, 19.030, - 103.428, 19.150, 280, - 10, 0, "13"},
        { 120.616, - 185.624, 7.637, 0.5, 94.815, - 114.354, 15.860, 280, - 10, 0, "14"},
        { 94.351, - 97.615, 5.184, 0.5, 92.792, - 93.604, 9.501, 280, - 10, 0, "15"},
        { 14.852, - 99.241, 8.995, 0.5, 50.409, - 155.826, 21.830, 280, - 10, 0, "16"},
        { 43.258, - 45.365, 20.901, 0.5, 82.065, - 68.507, 18.152, 280, - 10, 0, "17"},
        { 82.459, - 73.877, 15.729, 0.5, 67.970, - 86.299, 23.393, 280, - 10, 0, "18"},
        { 77.289, - 89.126, 22.765, 0.5, 94.772, - 114.362, 15.820, 280, - 10, 0, "19"},
        { 101.224, - 117.028, 14.884, 0.5, 125.026, - 135.580, 13.593, 280, - 10, 0, "20"},
        { 131.785, - 169.872, 15.951, 0.5, 127.812, - 184.557, 16.420, 280, - 10, 0, "21"},
        { 120.665, - 188.766, 13.752, 0.5, 109.956, - 188.522, 14.437, 280, - 10, 0, "22"},
        { 97.476, - 188.912, 15.718, 0.5, 53.653, - 157.885, 21.753, 280, - 10, 0, "23"},
        { 48.046, - 153.087, 21.181, 0.5, 23.112, - 59.428, 16.352, 280, - 10, 0, "24"},
        { 118.263, - 120.761, 17.192, 0.5, 40.194, - 139.990, 2.733, 280, - 10, 0, "25"},
    }

    local red_flag = read_dword(globals + 0x8)
    local blue_flag = read_dword(globals + 0xC)
    local tag_address = read_dword(0x40440000)
    local tag_count = read_dword(0x4044000C)
    -- weapons\assault rifle\bullet.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\assault rifle\\bullet") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d0, 1133936640)
            write_dword(tag_data + 0x1d4, 1137213440)
            write_dword(tag_data + 0x1d8, 1140490240)
            write_dword(tag_data + 0x1f4, 1075838976)
            break
        end
    end
    -- weapons\pistol\pistol.weap
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 2003132784 and tag_name == "weapons\\pistol\\pistol") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x308, 32)
            write_dword(tag_data + 0x3e0, 1082130432)
            write_dword(tag_data + 0x71c, 34340864)
            write_dword(tag_data + 0x720, 1573114)
            write_dword(tag_data + 0x730, 24)
            write_dword(tag_data + 0x7a8, 1103626240)
            write_dword(tag_data + 0x7ac, 1103626240)
            write_dword(tag_data + 0x7c4, 0)
            write_dword(tag_data + 0x820, 841731191)
            write_dword(tag_data + 0x824, 869711765)
            break
        end
    end
    -- weapons\pistol\melee.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\pistol\\melee") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d0, 1148846080)
            write_dword(tag_data + 0x1d4, 1148846080)
            write_dword(tag_data + 0x1d8, 1148846080)
            break
        end
    end
    -- weapons\pistol\bullet.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1886547818 and tag_name == "weapons\\pistol\\bullet") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1c8, 1148846080)
            write_dword(tag_data + 0x1e4, 1097859072)
            write_dword(tag_data + 0x1e8, 1097859072)
            break
        end
    end
    -- weapons\pistol\bullet.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\pistol\\bullet") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d0, 1133903872)
            write_dword(tag_data + 0x1d4, 1133903872)
            write_dword(tag_data + 0x1d8, 1133903872)
            write_dword(tag_data + 0x1e4, 1065353216)
            write_dword(tag_data + 0x1ec, 1041865114)
            write_dword(tag_data + 0x1f4, 1073741824)
            break
        end
    end
    -- vehicles\warthog\warthog gun.weap
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 2003132784 and tag_name == "vehicles\\warthog\\warthog gun") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x928, 1078307906)
            SwapDependency(tag_data + 0x930, "vehicles\\scorpion\\tank shell", 1886547818)
            break
        end
    end
    -- vehicles\scorpion\tank shell.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1886547818 and tag_name == "vehicles\\scorpion\\tank shell") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1e4, 1114636288)
            write_dword(tag_data + 0x1e8, 1114636288)
            break
        end
    end
    -- vehicles\scorpion\shell explosion.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "vehicles\\scorpion\\shell explosion") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1073741824)
            write_dword(tag_data + 0x4, 1081081856)
            write_dword(tag_data + 0xcc, 1061158912)
            write_dword(tag_data + 0xd4, 1011562294)
            write_dword(tag_data + 0x1d0, 1131413504)
            write_dword(tag_data + 0x1f4, 1092091904)
            break
        end
    end
    -- weapons\frag grenade\shock wave.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\frag grenade\\shock wave") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0xd4, 1048576000)
            write_dword(tag_data + 0xd8, 1022739087)
            break
        end
    end
    -- vehicles\ghost\mp_ghost gun.weap
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 2003132784 and tag_name == "vehicles\\ghost\\mp_ghost gun") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x6dc, 1638400)
            break
        end
    end
    -- vehicles\ghost\ghost bolt.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1886547818 and tag_name == "vehicles\\ghost\\ghost bolt") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1c8, 1140457472)
            write_dword(tag_data + 0x1ec, 1056964608)
            break
        end
    end
    -- vehicles\ghost\ghost bolt.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "vehicles\\ghost\\ghost bolt") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d4, 1103626240)
            write_dword(tag_data + 0x1d8, 1108082688)
            write_dword(tag_data + 0x1f4, 1073741824)
            break
        end
    end
    -- vehicles\rwarthog\rwarthog_gun.weap
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 2003132784 and tag_name == "vehicles\\rwarthog\\rwarthog_gun") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x64c, 655294464)
            write_dword(tag_data + 0x650, 1320719)
            write_dword(tag_data + 0x660, 20)
            write_dword(tag_data + 0x6c0, 993039)
            write_dword(tag_data + 0x6d0, 15)
            write_dword(tag_data + 0x794, 131072)
            break
        end
    end
    -- weapons\rocket launcher\rocket.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1886547818 and tag_name == "weapons\\rocket launcher\\rocket") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1c8, 1148846080)
            break
        end
    end
    -- weapons\rocket launcher\explosion.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\rocket launcher\\explosion") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1077936128)
            write_dword(tag_data + 0x4, 1080033280)
            write_dword(tag_data + 0xcc, 1061158912)
            write_dword(tag_data + 0xd4, 1011562294)
            write_dword(tag_data + 0x1d0, 1120403456)
            write_dword(tag_data + 0x1d4, 1137180672)
            write_dword(tag_data + 0x1d8, 1137180672)
            write_dword(tag_data + 0x1f4, 1094713344)
            break
        end
    end
    -- vehicles\banshee\mp_banshee gun.weap
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 2003132784 and tag_name == "vehicles\\banshee\\mp_banshee gun") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x5cc, 8224)
            write_dword(tag_data + 0x5ec, 65536)
            write_dword(tag_data + 0x604, 655294464)
            write_dword(tag_data + 0x608, 141071)
            write_dword(tag_data + 0x618, 2)
            write_dword(tag_data + 0x638, 196608)
            write_dword(tag_data + 0x64c, 0)
            write_dword(tag_data + 0x678, 665359)
            write_dword(tag_data + 0x688, 10)
            write_dword(tag_data + 0x74c, 196608)
            write_dword(tag_data + 0x860, 196608)
            write_dword(tag_data + 0x88c, 1078314612)
            SwapDependency(tag_data + 0x894, "weapons\\rocket launcher\\rocket", 1886547818)
            break
        end
    end
    -- vehicles\banshee\banshee bolt.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1886547818 and tag_name == "vehicles\\banshee\\banshee bolt") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1c8, 1148846080)
            write_dword(tag_data + 0x1ec, 1056964608)
            break
        end
    end
    -- vehicles\banshee\banshee bolt.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "vehicles\\banshee\\banshee bolt") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1082130432)
            write_dword(tag_data + 0x4, 1084227584)
            write_dword(tag_data + 0x1d0, 1125515264)
            write_dword(tag_data + 0x1d4, 1125515264)
            write_dword(tag_data + 0x1d8, 1125515264)
            write_dword(tag_data + 0x1f4, 1069547520)
            break
        end
    end
    -- vehicles\banshee\mp_banshee fuel rod.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1886547818 and tag_name == "vehicles\\banshee\\mp_banshee fuel rod") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1c8, 1148846080)
            write_dword(tag_data + 0x1cc, 0)
            write_dword(tag_data + 0x1e4, 1053609165)
            write_dword(tag_data + 0x1e8, 1051372091)
            break
        end
    end
    -- weapons\shotgun\shotgun.weap
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 2003132784 and tag_name == "weapons\\shotgun\\shotgun") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x3e8, 1120403456)
            write_dword(tag_data + 0x3f0, 1120403456)
            write_dword(tag_data + 0xaf0, 1638400)
            break
        end
    end
    -- weapons\shotgun\pellet.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1886547818 and tag_name == "weapons\\shotgun\\pellet") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1c8, 1148846080)
            write_dword(tag_data + 0x1d4, 1112014848)
            break
        end
    end
    -- weapons\shotgun\pellet.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\shotgun\\pellet") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d0, 1137213440)
            write_dword(tag_data + 0x1d4, 1140490240)
            write_dword(tag_data + 0x1d8, 1142308864)
            write_dword(tag_data + 0x1f4, 1077936128)
            break
        end
    end
    -- weapons\plasma rifle\plasma rifle.weap
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 2003132784 and tag_name == "weapons\\plasma rifle\\plasma rifle") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x3e8, 1140457472)
            write_dword(tag_data + 0x3f0, 1140457472)
            write_dword(tag_data + 0xd10, 327680)
            break
        end
    end
    -- weapons\plasma rifle\bolt.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\plasma rifle\\bolt") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d4, 1097859072)
            write_dword(tag_data + 0x1d8, 1103626240)
            write_dword(tag_data + 0x1f4, 1065353216)
            break
        end
    end
    -- weapons\frag grenade\explosion.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\frag grenade\\explosion") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1073741824)
            write_dword(tag_data + 0x4, 1083703296)
            write_dword(tag_data + 0xcc, 1061158912)
            write_dword(tag_data + 0xd4, 1011562294)
            write_dword(tag_data + 0x1d0, 1131413504)
            write_dword(tag_data + 0x1d4, 1135575040)
            write_dword(tag_data + 0x1d8, 1135575040)
            write_dword(tag_data + 0x1f4, 1092091904)
            break
        end
    end
    -- weapons\rocket launcher\melee.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\rocket launcher\\melee") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d0, 1148846080)
            write_dword(tag_data + 0x1d4, 1148846080)
            write_dword(tag_data + 0x1d8, 1148846080)
            break
        end
    end
    -- weapons\rocket launcher\trigger.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\rocket launcher\\trigger") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0xcc, 1061158912)
            write_dword(tag_data + 0xd4, 1008981770)
            write_dword(tag_data + 0xd8, 1017370378)
            break
        end
    end
    -- weapons\sniper rifle\sniper rifle.weap
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 2003132784 and tag_name == "weapons\\sniper rifle\\sniper rifle") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x3e8, 1128792064)
            write_dword(tag_data + 0x3f0, 1128792064)
            write_dword(tag_data + 0x894, 7340032)
            write_dword(tag_data + 0x898, 786532)
            write_dword(tag_data + 0x8a8, 12)
            write_dword(tag_data + 0x920, 1075838976)
            write_dword(tag_data + 0x924, 1075838976)
            write_dword(tag_data + 0x9b4, 1078307906)
            SwapDependency(tag_data + 0x9bc, "vehicles\\scorpion\\tank shell", 1886547818)
            break
        end
    end
    -- weapons\sniper rifle\muzzle flash.ligh
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1818847080 and tag_name == "weapons\\sniper rifle\\muzzle flash") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1)
            write_dword(tag_data + 0x4, 1094713344)
            write_dword(tag_data + 0x10, 1060288706)
            write_dword(tag_data + 0x14, 1067945270)
            write_dword(tag_data + 0x1c, 1061428093)
            write_dword(tag_data + 0x20, 1048871919)
            write_dword(tag_data + 0x28, 1064781546)
            write_dword(tag_data + 0x38, 1065353216)
            write_dword(tag_data + 0x48, 1065353216)
            write_dword(tag_data + 0x4c, 1065353216)
            write_dword(tag_data + 0x50, 1065353216)
            write_dword(tag_data + 0x54, 1065353216)
            write_dword(tag_data + 0x68, 1078307487)
            SwapDependency(tag_data + 0x70, "vehicles\\scorpion\\bitmaps\\headlights gel scorpion", 1651078253)
            write_dword(tag_data + 0x74, 0)
            write_dword(tag_data + 0x8c, 0)
            write_dword(tag_data + 0x94, 0)
            write_dword(tag_data + 0x9c, 0)
            write_dword(tag_data + 0xb0, 1078307537)
            SwapDependency(tag_data + 0xb8, "vehicles\\scorpion\\headlights scorpion", 1818586739)
            break
        end
    end
    -- weapons\sniper rifle\melee.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\sniper rifle\\melee") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0xcc, 1061158912)
            write_dword(tag_data + 0xd4, 1011562294)
            write_dword(tag_data + 0x1d0, 1148846080)
            write_dword(tag_data + 0x1d4, 1148846080)
            write_dword(tag_data + 0x1d8, 1148846080)
            break
        end
    end
    -- weapons\sniper rifle\sniper bullet.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1886547818 and tag_name == "weapons\\sniper rifle\\sniper bullet") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x144, 1081053092)
            write_dword(tag_data + 0x180, 0)
            write_dword(tag_data + 0x1b0, 1078308047)
            SwapDependency(tag_data + 0x1b8, "vehicles\\scorpion\\shell explosion", 1701209701)
            write_dword(tag_data + 0x1e4, 1114636288)
            write_dword(tag_data + 0x1e8, 1114636288)
            write_dword(tag_data + 0x1f0, 2)
            write_dword(tag_data + 0x208, 1078308640)
            SwapDependency(tag_data + 0x210, "sound\\sfx\\impulse\\impacts\\scorpion_projectile", 1936614433)
            write_dword(tag_data + 0x228, 0)
            write_dword(tag_data + 0x230, 4294967295)
            write_dword(tag_data + 0x244, 1081053164)
            write_dword(tag_data + 0x250, 1078307935)
            SwapDependency(tag_data + 0x258, "vehicles\\scorpion\\shell", 1668247156)
            write_dword(tag_data + 0x294, 65536)
            write_dword(tag_data + 0x29c, 0)
            write_dword(tag_data + 0x2a4, 4294967295)
            write_dword(tag_data + 0x300, 1078308686)
            SwapDependency(tag_data + 0x308, "vehicles\\scorpion\\shell impact dirt", 1701209701)
            write_dword(tag_data + 0x334, 65536)
            write_dword(tag_data + 0x33c, 0)
            write_dword(tag_data + 0x344, 4294967295)
            write_dword(tag_data + 0x3d4, 65536)
            write_dword(tag_data + 0x3dc, 0)
            write_dword(tag_data + 0x3e4, 4294967295)
            write_dword(tag_data + 0x440, 1078308835)
            SwapDependency(tag_data + 0x448, "vehicles\\wraith\\effects\\impact stone", 1701209701)
            write_dword(tag_data + 0x474, 65536)
            write_dword(tag_data + 0x47c, 0)
            write_dword(tag_data + 0x484, 4294967295)
            write_dword(tag_data + 0x4e0, 1078309337)
            SwapDependency(tag_data + 0x4e8, "vehicles\\wraith\\effects\\impact snow", 1701209701)
            write_dword(tag_data + 0x514, 65536)
            write_dword(tag_data + 0x51c, 0)
            write_dword(tag_data + 0x524, 4294967295)
            write_dword(tag_data + 0x580, 1078309578)
            SwapDependency(tag_data + 0x588, "vehicles\\wraith\\effects\\impact wood", 1701209701)
            write_dword(tag_data + 0x5b4, 65536)
            write_dword(tag_data + 0x5bc, 0)
            write_dword(tag_data + 0x5c4, 4294967295)
            write_dword(tag_data + 0x620, 1078309614)
            SwapDependency(tag_data + 0x628, "weapons\\rocket launcher\\effects\\impact metal", 1701209701)
            write_dword(tag_data + 0x654, 65536)
            write_dword(tag_data + 0x65c, 0)
            write_dword(tag_data + 0x664, 4294967295)
            write_dword(tag_data + 0x6c0, 1078309614)
            SwapDependency(tag_data + 0x6c8, "weapons\\rocket launcher\\effects\\impact metal", 1701209701)
            write_dword(tag_data + 0x6f4, 65536)
            write_dword(tag_data + 0x6fc, 0)
            write_dword(tag_data + 0x704, 4294967295)
            write_dword(tag_data + 0x760, 1078309614)
            SwapDependency(tag_data + 0x768, "weapons\\rocket launcher\\effects\\impact metal", 1701209701)
            write_dword(tag_data + 0x794, 65536)
            write_dword(tag_data + 0x79c, 0)
            write_dword(tag_data + 0x7a4, 4294967295)
            write_dword(tag_data + 0x800, 1078309614)
            SwapDependency(tag_data + 0x808, "weapons\\rocket launcher\\effects\\impact metal", 1701209701)
            write_dword(tag_data + 0x834, 65536)
            write_dword(tag_data + 0x83c, 0)
            write_dword(tag_data + 0x844, 4294967295)
            write_dword(tag_data + 0x8a0, 1078309659)
            SwapDependency(tag_data + 0x8a8, "vehicles\\wraith\\effects\\impact ice", 1701209701)
            write_dword(tag_data + 0x8d4, 65536)
            write_dword(tag_data + 0x8dc, 0)
            write_dword(tag_data + 0x8e4, 4294967295)
            write_dword(tag_data + 0x974, 65536)
            write_dword(tag_data + 0x97c, 0)
            write_dword(tag_data + 0x984, 4294967295)
            write_dword(tag_data + 0xa14, 65536)
            write_dword(tag_data + 0xa1c, 0)
            write_dword(tag_data + 0xa24, 4294967295)
            write_dword(tag_data + 0xab4, 65536)
            write_dword(tag_data + 0xabc, 0)
            write_dword(tag_data + 0xac4, 4294967295)
            write_dword(tag_data + 0xb54, 65536)
            write_dword(tag_data + 0xb5c, 0)
            write_dword(tag_data + 0xb64, 4294967295)
            write_dword(tag_data + 0xbf4, 65536)
            write_dword(tag_data + 0xbfc, 0)
            write_dword(tag_data + 0xc04, 4294967295)
            write_dword(tag_data + 0xc94, 65536)
            write_dword(tag_data + 0xc9c, 0)
            write_dword(tag_data + 0xca4, 4294967295)
            write_dword(tag_data + 0xd34, 65536)
            write_dword(tag_data + 0xd3c, 0)
            write_dword(tag_data + 0xd44, 4294967295)
            write_dword(tag_data + 0xdd4, 65536)
            write_dword(tag_data + 0xddc, 0)
            write_dword(tag_data + 0xde4, 4294967295)
            write_dword(tag_data + 0xe74, 65536)
            write_dword(tag_data + 0xe7c, 0)
            write_dword(tag_data + 0xe84, 4294967295)
            write_dword(tag_data + 0xf14, 65536)
            write_dword(tag_data + 0xf1c, 0)
            write_dword(tag_data + 0xf24, 4294967295)
            write_dword(tag_data + 0xfb4, 65536)
            write_dword(tag_data + 0xfbc, 0)
            write_dword(tag_data + 0xfc4, 4294967295)
            write_dword(tag_data + 0x1054, 65536)
            write_dword(tag_data + 0x105c, 0)
            write_dword(tag_data + 0x1064, 4294967295)
            write_dword(tag_data + 0x10f4, 65536)
            write_dword(tag_data + 0x10fc, 0)
            write_dword(tag_data + 0x1104, 4294967295)
            write_dword(tag_data + 0x1194, 65536)
            write_dword(tag_data + 0x119c, 0)
            write_dword(tag_data + 0x11a4, 4294967295)
            write_dword(tag_data + 0x1234, 65536)
            write_dword(tag_data + 0x123c, 0)
            write_dword(tag_data + 0x1244, 4294967295)
            write_dword(tag_data + 0x12d4, 65536)
            write_dword(tag_data + 0x12dc, 0)
            write_dword(tag_data + 0x12e4, 4294967295)
            write_dword(tag_data + 0x1374, 65536)
            write_dword(tag_data + 0x137c, 0)
            write_dword(tag_data + 0x1384, 4294967295)
            write_dword(tag_data + 0x1414, 65536)
            write_dword(tag_data + 0x141c, 0)
            write_dword(tag_data + 0x1424, 4294967295)
            write_dword(tag_data + 0x1480, 1078309694)
            SwapDependency(tag_data + 0x1488, "weapons\\rocket launcher\\effects\\impact water", 1701209701)
            write_dword(tag_data + 0x14b4, 65536)
            write_dword(tag_data + 0x14bc, 0)
            write_dword(tag_data + 0x14c4, 4294967295)
            write_dword(tag_data + 0x1520, 1078309777)
            SwapDependency(tag_data + 0x1528, "weapons\\frag grenade\\effects\\impact water pen", 1701209701)
            write_dword(tag_data + 0x1554, 65536)
            write_dword(tag_data + 0x155c, 0)
            write_dword(tag_data + 0x1564, 4294967295)
            write_dword(tag_data + 0x15f4, 65536)
            write_dword(tag_data + 0x15fc, 0)
            write_dword(tag_data + 0x1604, 4294967295)
            write_dword(tag_data + 0x1660, 1078309659)
            SwapDependency(tag_data + 0x1668, "vehicles\\wraith\\effects\\impact ice", 1701209701)
            write_dword(tag_data + 0x1694, 65536)
            write_dword(tag_data + 0x169c, 0)
            write_dword(tag_data + 0x16a4, 4294967295)
            break
        end
    end
    -- weapons\plasma grenade\explosion.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\plasma grenade\\explosion") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x4, 1086324736)
            write_dword(tag_data + 0x1d0, 1140457472)
            write_dword(tag_data + 0x1d4, 1140457472)
            write_dword(tag_data + 0x1d8, 1140457472)
            write_dword(tag_data + 0x1f4, 1094713344)
            break
        end
    end
    -- weapons\plasma_cannon\plasma_cannon.weap
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 2003132784 and tag_name == "weapons\\plasma_cannon\\plasma_cannon") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x92c, 196608)
            break
        end
    end
    -- weapons\plasma_cannon\plasma_cannon.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1886547818 and tag_name == "weapons\\plasma_cannon\\plasma_cannon") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1b0, 1078308047)
            SwapDependency(tag_data + 0x1b8, "vehicles\\scorpion\\shell explosion", 1701209701)
            break
        end
    end
    -- weapons\plasma_cannon\effects\plasma_cannon_explosion.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d0, 1142308864)
            write_dword(tag_data + 0x1d4, 1142308864)
            write_dword(tag_data + 0x1d8, 1142308864)
            write_dword(tag_data + 0x1f4, 1083179008)
            break
        end
    end
    -- weapons\plasma_cannon\impact damage.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\plasma_cannon\\impact damage") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d0, 1142308864)
            write_dword(tag_data + 0x1d4, 1142308864)
            write_dword(tag_data + 0x1d8, 1142308864)
            write_dword(tag_data + 0x1f4, 1083179008)
            break
        end
    end
    -- weapons\plasma rifle\charged bolt.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\plasma rifle\\charged bolt") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1084227584)
            write_dword(tag_data + 0x4, 1090519040)
            write_dword(tag_data + 0xcc, 1065353216)
            write_dword(tag_data + 0xd4, 1017370378)
            write_dword(tag_data + 0x1d0, 1140457472)
            write_dword(tag_data + 0x1d4, 1140457472)
            write_dword(tag_data + 0x1d8, 1140457472)
            write_dword(tag_data + 0x1f4, 1097859072)
            break
        end
    end
    -- weapons\frag grenade\frag grenade.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1886547818 and tag_name == "weapons\\frag grenade\\frag grenade") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1bc, 1050253722)
            write_dword(tag_data + 0x1c0, 1050253722)
            write_dword(tag_data + 0x1cc, 1057803469)
            write_dword(tag_data + 0x1ec, 1065353216)
            break
        end
    end
    -- weapons\plasma grenade\plasma grenade.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1886547818 and tag_name == "weapons\\plasma grenade\\plasma grenade") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1bc, 1065353216)
            write_dword(tag_data + 0x1c0, 1065353216)
            write_dword(tag_data + 0x1cc, 1056964608)
            write_dword(tag_data + 0x1ec, 1077936128)
            break
        end
    end
    -- weapons\plasma grenade\attached.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "weapons\\plasma grenade\\attached") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d0, 1137180672)
            write_dword(tag_data + 0x1d4, 1137180672)
            write_dword(tag_data + 0x1d8, 1137180672)
            write_dword(tag_data + 0x1f4, 1092616192)
            break
        end
    end
    -- vehicles\c gun turret\c gun turret_mp.vehi
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1986357353 and tag_name == "vehicles\\c gun turret\\c gun turret_mp") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x8c, 4294967295)
            write_dword(tag_data + 0x9c0, 973078558)
            break
        end
    end
    -- vehicles\c gun turret\bitmaps\gun turret base.bitm
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1651078253 and tag_name == "vehicles\\c gun turret\\bitmaps\\gun turret base") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0xbc, 0)
            break
        end
    end
    -- vehicles\c gun turret\mp gun turret.phys
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1885895027 and tag_name == "vehicles\\c gun turret\\mp gun turret") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0xe8, 33554433)
            write_dword(tag_data + 0xec, 1069547520)
            write_dword(tag_data + 0xf4, 1073741824)
            write_dword(tag_data + 0xf8, 1017370378)
            write_dword(tag_data + 0xfc, 1056964608)
            write_dword(tag_data + 0x100, 1048871917)
            break
        end
    end
    -- vehicles\c gun turret\mp gun turret gun.weap
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 2003132784 and tag_name == "vehicles\\c gun turret\\mp gun turret gun") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x8b4, 3276800)
            break
        end
    end
    -- globals\falling.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if(tag_class == 1785754657 and tag_name == "globals\\falling") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1d4, 1092616192)
            write_dword(tag_data + 0x1d8, 1092616192)
            break
        end
    end
end

function FragCheck(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    safe_read(true)
    local frags = read_byte(player_object + 0x31E)
    safe_read(false)
    if tonumber(frags) <= 0 then
        return true
    end
    return false
end

function PlasmaCheck(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    safe_read(true)
    local plasmas = read_byte(player_object + 0x31F)
    safe_read(false)
    if tonumber(plasmas) <= 0 then
        return true
    end
    return false
end

function PlayerInVehicle(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if (player_object ~= 0) then
        local VehicleID = read_dword(player_object + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

function TagInfo(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function getPlayerCoords(PlayerIndex, posX, posY, posZ, radius)
    local x, y, z = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
    if (posX - x) ^ 2 + (posY - y) ^ 2 + (posZ - z) ^ 2 <= radius then
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

function SwapDependency(Address, ToTag, ToClass)
    local tag_address = read_dword(0x40440000)
    local tag_count = read_dword(0x4044000C)
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        if(read_dword(tag) == ToClass and read_string(read_dword(tag + 0x10)) == ToTag) then
            write_dword(Address, read_dword(tag + 0xC))
            return
        end
    end
end

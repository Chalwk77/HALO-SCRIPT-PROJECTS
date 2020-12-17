--[[
--=====================================================================================================--
Script Name: Snipers Dream Team Mod, for SAPP (PC & CE)

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local SDTM = { }

function SDTM:Init()

    self.players = { }
    self.globals = nil

    self.broadcast = true
    self.flag_holder = nil

    -- CONFIGURATION STARTS -->> ---------------------------------------------------

    if (get_var(0, "$gt") ~= "n/a") then

        -- Flag Settings --
        self.flag_runner_speed = 1.5
        self.on_flag_pickup = {
            [1] = { "%name% has %team% team's flag!" },
            [2] = {
                "Return the flag to your base to score.",
                "%speed%x speed boost."
            }
        }
        --

        self.maps = {

            ["bloodgulch"] = {

                -- grenade counts --
                frag_count = 4,
                plasma_count = 4,

                -- respawn time --
                respawn_time = 0,

                -- weapon load out --
                weapons = {
                    [1] = "Pistol",
                    [2] = "Sniper"
                },

                -- map teleport locations --
                teleports = {

                    -- from X, from Y, from Z, Trigger Radius, toX, toY, toZ, toZ height offset

                    { 43.125, -78.434, -0.220, 0.5, 15.713, -102.762, 13.462, 0.1 },
                    { 43.112, -80.069, -0.253, 0.5, 68.123, -92.847, 2.167, 0.1 },
                    { 37.105, -80.069, -0.255, 0.5, 108.005, -109.328, 1.924, 0.1 },
                    { 37.080, -78.426, -0.238, 0.5, 79.924, -64.560, 4.669, 0.1 },
                    { 43.456, -77.197, 0.633, 0.5, 29.528, -52.746, 3.100, 0.1 },
                    { 74.304, -77.590, 6.552, 0.5, 76.001, -77.936, 11.425, 0.1 },
                    { 98.559, -158.558, -0.253, 0.5, 63.338, -169.305, 3.702, 0.1 },
                    { 98.541, -160.190, -0.255, 0.5, 120.801, -182.946, 6.766, 0.1 },
                    { 92.550, -158.581, -0.256, 0.5, 46.934, -151.024, 4.496, 0.1 },
                    { 92.538, -160.213, -0.215, 0.5, 112.550, -127.203, 1.905, 0.1 },
                    { 98.935, -157.626, 0.425, 0.5, 95.725, -91.968, 5.314, 280, 0.1 },
                    { 70.499, -62.119, 5.382, 0.5, 122.615, -123.520, 15.916, 0.1 },
                    { 63.693, -177.303, 5.606, 0.5, 19.040, -103.200, 19.040, 0.1 },
                    { 120.616, -185.624, 7.637, 0.5, 94.815, -114.354, 15.860, 0.1 },
                    { 94.351, -97.615, 5.184, 0.5, 92.792, -93.604, 9.501, 0.1 },
                    { 14.852, -99.241, 8.995, 0.5, 49.300, -153.59, 21.28, 0.1 },
                    { 43.258, -45.365, 20.901, 0.5, 82.065, -68.507, 18.152, 0.1 },
                    { 82.459, -73.877, 15.729, 0.5, 67.970, -86.299, 23.393, 0.1 },
                    { 77.289, -89.126, 22.765, 0.5, 94.772, -114.362, 15.820, 0.1 },
                    { 101.224, -117.028, 14.884, 0.5, 125.026, -135.580, 13.593, 0.1 },
                    { 131.785, -169.872, 15.951, 0.5, 127.812, -184.557, 16.420, 0.1 },
                    { 120.665, -188.766, 13.752, 0.5, 109.956, -188.522, 14.437, 0.1 },
                    { 97.476, -188.912, 15.718, 0.5, 53.653, -157.885, 21.753, 0.1 },
                    { 48.046, -153.087, 21.181, 0.5, 23.112, -59.428, 16.352, 0.1 },
                    { 118.263, -120.761, 17.192, 0.5, 40.194, -139.990, 2.733, 0.1 },
                    { 84.920, -127.130, 0.540, 0.1, 69.700,-91.510,25.060, 0.1 }
                },

                objects = {
                    -- blue vehicles
                    { "vehi", "vehicles\\banshee\\banshee_mp", 70.078, -62.626, 3.758, "Blue Banshee", 10.2 },
                    { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 29.544, -53.628, 3.302, "Blue Turret", 124.5 },
                    { "vehi", "vehicles\\scorpion\\scorpion_mp", 23.598, -102.343, 2.163, "Blue Tank [Ramp]", 90 },
                    { "vehi", "vehicles\\scorpion\\scorpion_mp", 38.119, -64.898, 0.617, "Blue Tank [Immediate Rear of Base]", 90 },
                    { "vehi", "vehicles\\scorpion\\scorpion_mp", 51.349, -61.517, 1.759, "Blue Tank [Rear-Right of Base]", 90 },
                    { "vehi", "vehicles\\rwarthog\\rwarthog", 50.655, -87.787, 0.079, "Blue Rocket Hog [Front-Right of Base]", -90 },
                    { "vehi", "vehicles\\rwarthog\\rwarthog", 62.745, -72.406, 1.031, "Blue Rocket Hog [Far-Right of Base]", 90 },
                    { "vehi", "vehicles\\warthog\\mp_warthog", 28.854, -90.193, 0.434, "Blue Chain Gun Hog [Front-Left of Base]", 90 },

                    -- red vehicles
                    { "vehi", "vehicles\\banshee\\banshee_mp", 64.178, -176.802, 3.960, "Red Banshee", 120 },
                    { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 118.084, -185.346, 6.563, "Red Turret", 90 },
                    { "vehi", "vehicles\\scorpion\\scorpion_mp", 104.017, -129.761, 1.665, "Red Tank [Dark-Side]", 90 },
                    { "vehi", "vehicles\\scorpion\\scorpion_mp", 97.117, -173.132, 0.744, "Red Tank [Immediate Rear of Base]", 90 },
                    { "vehi", "vehicles\\scorpion\\scorpion_mp", 81.150, -169.359, 0.158, "Red Tank [Rear-Right of Base]", 90 },
                    { "vehi", "vehicles\\rwarthog\\rwarthog", 106.885, -169.245, 0.091, "Red Rocket Hog [Left-Rear of Base]", 90 },
                    { "vehi", "vehicles\\warthog\\mp_warthog", 67.961, -171.002, 1.428, "Red Chain Gun Hog [Far Right of Base]", 90 },
                    { "vehi", "vehicles\\warthog\\mp_warthog", 102.312, -144.626, 0.580, "Red Chain Gun Hog [Front-Left of Base]", 90 },
                    { "vehi", "vehicles\\warthog\\mp_warthog", 43.559, -64.809, 1.113, "Red Chain Gun Hog [Immediate Rear of Base]", 90 },

                    -- other vehicles
                    { "vehi", "vehicles\\ghost\\ghost_mp", 59.294, -116.212, 1.797, "Ghost [Mid-Field]", 90 },
                    { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 51.315, -154.075, 21.561, "Cliff Turret", 90 }
                }
            }
        }

        -- stock tags --
        self.tags = {
            [1] = "weapons\\pistol\\pistol",
            [2] = "weapons\\sniper rifle\\sniper rifle",
            [3] = "weapons\\plasma_cannon\\plasma_cannon",
            [4] = "weapons\\rocket launcher\\rocket launcher",
            [5] = "weapons\\plasma pistol\\plasma pistol",
            [6] = "weapons\\plasma rifle\\plasma rifle",
            [7] = "weapons\\assault rifle\\assault rifle",
            [8] = "weapons\\flamethrower\\flamethrower",
            [9] = "weapons\\needler\\mp_needler",
            [10] = "weapons\\shotgun\\shotgun",
        }
        --
        -- CONFIGURATION ENDS << -------------------------------------------------
        --
        --
        --
        -- DO NOT TOUCH BELOW THIS POINT (unless you know what you're doing) --
        local map = get_var(0, "$map")
        if (self.maps[map]) then

            -- init weapons array [table]:
            self.weapons = self.maps[map].weapons

            -- init teleports array [table]:
            self.teleports = self.maps[map].teleports

            -- Set respawn time [int]:
            self.respawn_time = self.maps[map].respawn_time

            -- Set Frag Count: [int]:
            self.frag_count = self.maps[map].frag_count

            -- Set Plasma Count: [int]:
            self.plasma_count = self.maps[map].plasma_count

            -- Spawn map objects:
            for _, v in pairs(self.maps[map].objects) do
                spawn_object(v[1], v[2], v[3], v[4], v[5], v[7])
            end

            register_callback(cb["EVENT_TICK"], "OnTick")
            register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
            register_callback(cb["EVENT_PRESPAWN"], "OnPreSpawn")
            register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
            register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
            register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

            local tag_address = read_dword(0x40440000)
            local tag_count = read_dword(0x4044000C)

            -- weapons\assault rifle\bullet.jpt!
            for i = 0, tag_count - 1 do
                local tag = tag_address + 0x20 * i
                local tag_name = read_string(read_dword(tag + 0x10))
                local tag_class = read_dword(tag)
                if (tag_class == 1785754657 and tag_name == "weapons\\assault rifle\\bullet") then
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
                if (tag_class == 2003132784 and tag_name == "weapons\\pistol\\pistol") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\pistol\\melee") then
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
                if (tag_class == 1886547818 and tag_name == "weapons\\pistol\\bullet") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\pistol\\bullet") then
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
                if (tag_class == 2003132784 and tag_name == "vehicles\\warthog\\warthog gun") then
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
                if (tag_class == 1886547818 and tag_name == "vehicles\\scorpion\\tank shell") then
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
                if (tag_class == 1785754657 and tag_name == "vehicles\\scorpion\\shell explosion") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\frag grenade\\shock wave") then
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
                if (tag_class == 2003132784 and tag_name == "vehicles\\ghost\\mp_ghost gun") then
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
                if (tag_class == 1886547818 and tag_name == "vehicles\\ghost\\ghost bolt") then
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
                if (tag_class == 1785754657 and tag_name == "vehicles\\ghost\\ghost bolt") then
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
                if (tag_class == 2003132784 and tag_name == "vehicles\\rwarthog\\rwarthog_gun") then
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
                if (tag_class == 1886547818 and tag_name == "weapons\\rocket launcher\\rocket") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\rocket launcher\\explosion") then
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
                if (tag_class == 2003132784 and tag_name == "vehicles\\banshee\\mp_banshee gun") then
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
                if (tag_class == 1886547818 and tag_name == "vehicles\\banshee\\banshee bolt") then
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
                if (tag_class == 1785754657 and tag_name == "vehicles\\banshee\\banshee bolt") then
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
                if (tag_class == 1886547818 and tag_name == "vehicles\\banshee\\mp_banshee fuel rod") then
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
                if (tag_class == 2003132784 and tag_name == "weapons\\shotgun\\shotgun") then
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
                if (tag_class == 1886547818 and tag_name == "weapons\\shotgun\\pellet") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\shotgun\\pellet") then
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
                if (tag_class == 2003132784 and tag_name == "weapons\\plasma rifle\\plasma rifle") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\plasma rifle\\bolt") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\frag grenade\\explosion") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\rocket launcher\\melee") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\rocket launcher\\trigger") then
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
                if (tag_class == 2003132784 and tag_name == "weapons\\sniper rifle\\sniper rifle") then
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

            -- weapons\sniper rifle\melee.jpt!
            for i = 0, tag_count - 1 do
                local tag = tag_address + 0x20 * i
                local tag_name = read_string(read_dword(tag + 0x10))
                local tag_class = read_dword(tag)
                if (tag_class == 1785754657 and tag_name == "weapons\\sniper rifle\\melee") then
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
                if (tag_class == 1886547818 and tag_name == "weapons\\sniper rifle\\sniper bullet") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\plasma grenade\\explosion") then
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
                if (tag_class == 2003132784 and tag_name == "weapons\\plasma_cannon\\plasma_cannon") then
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
                if (tag_class == 1886547818 and tag_name == "weapons\\plasma_cannon\\plasma_cannon") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\plasma_cannon\\impact damage") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\plasma rifle\\charged bolt") then
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
                if (tag_class == 1886547818 and tag_name == "weapons\\frag grenade\\frag grenade") then
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
                if (tag_class == 1886547818 and tag_name == "weapons\\plasma grenade\\plasma grenade") then
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
                if (tag_class == 1785754657 and tag_name == "weapons\\plasma grenade\\attached") then
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
                if (tag_class == 1986357353 and tag_name == "vehicles\\c gun turret\\c gun turret_mp") then
                    local tag_data = read_dword(tag + 0x14)
                    write_dword(tag_data + 0x8c, 4294967295)
                    write_dword(tag_data + 0x9c0, 973078558)
                    break
                end
            end

            -- vehicles\c gun turret\mp gun turret gun.weap
            for i = 0, tag_count - 1 do
                local tag = tag_address + 0x20 * i
                local tag_name = read_string(read_dword(tag + 0x10))
                local tag_class = read_dword(tag)
                if (tag_class == 2003132784 and tag_name == "vehicles\\c gun turret\\mp gun turret gun") then
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
                if (tag_class == 1785754657 and tag_name == "globals\\falling") then
                    local tag_data = read_dword(tag + 0x14)
                    write_dword(tag_data + 0x1d4, 1092616192)
                    write_dword(tag_data + 0x1d8, 1092616192)
                    break
                end
            end
        end

        local gp = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
        if (gp == 3) then
            return
        end
        self.globals = read_dword(gp)

    else
        unregister_callback(cb["EVENT_DIE"])
        unregister_callback(cb["EVENT_TICK"])
        unregister_callback(cb["EVENT_JOIN"])
        unregister_callback(cb["EVENT_SPAWN"])
        unregister_callback(cb["EVENT_LEAVE"])
        unregister_callback(cb["EVENT_PRESPAWN"])
    end
end

local sqrt = math.sqrt
local gsub = string.gsub

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "Init")
    SDTM:Init()
end

function SDTM:OnGameTick()
    for i, v in pairs(self.players) do
        if (i) and player_alive(i) then
            local DyN = get_dynamic_player(i)
            if (DyN ~= 0) then

                self:MonitorFlag(i, DyN)

                local pos = self:GetXYZ(DyN, v.assign)
                if (v.assign) then
                    if (not pos.invehicle) then
                        v.assign = false
                        execute_command("wdel " .. i)
                        local index = 0
                        for WI, _ in pairs(self.weapons) do
                            index = index + 1
                            if (index == 1 or index == 2) then
                                assign_weapon(spawn_object("weap", self.tags[WI], pos.x, pos.y, pos.z), i)
                            elseif (index == 3 or index == 4) then
                                timer(250, "DelaySecQuat", i, self.tags[WI], pos.x, pos.y, pos.z)
                            end
                        end
                    end
                elseif (pos.portal) then
                    self:Teleport(pos)
                end
            end
        end
    end
    if (self:FlagDropped() and self.flag_holder ~= nil) then
        execute_command("s " .. self.flag_holder .. " 1")
        self.flag_holder, self.broadcast = nil, true
    end
end

function SDTM:Teleport(pos)
    local obj = (pos.obj ~= 0 and pos.obj or pos.dyn)
    write_vector3d((obj) + 0x5C, pos.x, pos.y, (obj and pos.z + 0.5 or pos.z))
end

function SDTM:FlagDropped()
    for i, _ in pairs(self.players) do
        if player_present(i) then
            local DyN = get_dynamic_player(i)
            if (DyN ~= 0) then
                if self:HoldingFlag(DyN) then
                    return false
                end
            end
        end
    end
    return true
end

function SDTM:MonitorFlag(Ply, DyN)
    local team = self:HoldingFlag(DyN)
    if (team) then

        self.flag_holder = Ply

        if (self.broadcast) then
            self.broadcast = nil

            local name = self.players[Ply].name
            local speed = self.flag_runner_speed

            execute_command("s " .. Ply .. " " .. speed)

            for k, msg in pairs(self.on_flag_pickup) do
                for i = 1, #msg do
                    local str = gsub(gsub(gsub(msg[i], "%%name%%", name), "%%speed%%", speed), "%%team%%", team)
                    if (k == 1) then
                        self:Respond(Ply, str, 10, true)
                    else
                        self:Respond(Ply, str)
                    end
                end
            end
        end
    end
end

function SDTM:HoldingFlag(DyN)

    local red_flag = read_dword(self.globals + 0x8)
    local blue_flag = read_dword(self.globals + 0xC)

    for i = 0, 3 do
        local WeaponID = read_dword(DyN + 0x2F8 + (i * 4))
        if (WeaponID ~= 0xFFFFFFFF) then
            local WeaponObject = get_object_memory(WeaponID)
            if (WeaponObject ~= 0) then
                if (WeaponID == red_flag) then
                    return "red"
                elseif (WeaponID == blue_flag) then
                    return "blue"
                end
            end
        end
    end
    return nil
end

function OnPlayerSpawn(Ply)
    SDTM.players[Ply].assign = true
end

function OnPlayerConnect(Ply)
    SDTM:InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    SDTM:InitPlayer(Ply, true)
end

function SDTM:InitPlayer(Ply, Reset)
    if (not Reset) then
        self.players[Ply] = {
            assign = false,
            name = get_var(Ply, "$name")
        }
    else
        self.players[Ply] = nil
    end
end

function SDTM:OnPlayerDeath(Ply)
    local player = get_player(Ply)
    write_dword(player ~= 0 and player + 0x2C, self.respawn_time * 1 / 30)
end

function SDTM:Respond(Ply, Message, Color, Exclude)
    Color = Color or 10
    if (Ply == 0) then
        cprint(Message, Color)
    elseif (Ply and not Exclude) then
        rprint(Ply, Message)
    else
        cprint(Message, Color)
        for i = 1, 16 do
            if player_present(i) then
                if (not Exclude) then
                    rprint(i, Message)
                elseif (i ~= Ply) then
                    rprint(i, Message)
                end
            end
        end
    end
end

function SDTM:GetXYZ(DyN, Assign)
    local pos, x, y, z = { }
    pos.dyn = DyN

    local VehicleID = read_dword(DyN + 0x11C)
    local VehicleObj = get_object_memory(VehicleID)
    pos.obj = VehicleObj

    if (VehicleID == 0xFFFFFFFF) then
        pos.invehicle = false
        x, y, z = read_vector3d(DyN + 0x5c)
    elseif (VehicleObj ~= 0) then
        pos.invehicle = true
        x, y, z = read_vector3d(VehicleObj + 0x5c)
    end
    pos.x, pos.y, pos.z = x, y, z

    local portal = self:NearPortal(pos)
    if (portal and not Assign) then
        pos.portal = true
        pos.x, pos.y, pos.z = portal.x, portal.y, portal.z
    end

    return pos
end

function SDTM:NearPortal(pos)
    for _, t in pairs(self.teleports) do

        local radius = t[4]
        local x1, y1, z1 = t[1], t[2], t[3]
        local x2, y2, z2 = t[5], t[6], t[7]
        local height = t[8]

        if sqrt((pos.x - x1) ^ 2 + (pos.y - y1) ^ 2 + (pos.z - z1) ^ 2) <= radius then
            return { x = x2, y = y2, z = z2 + height }
        end
    end
    return nil
end

function SDTM:OnPreSpawn(Ply)
    local DyN = get_dynamic_player(Ply)
    write_word(DyN ~= 0 and DyN + 0x31E, self.frag_count)
    write_word(DyN ~= 0 and DyN + 0x31F, self.plasma_count)
end

function SwapDependency(Address, ToTag, ToClass)
    local tag_address = read_dword(0x40440000)
    local tag_count = read_dword(0x4044000C)
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        if (read_dword(tag) == ToClass and read_string(read_dword(tag + 0x10)) == ToTag) then
            write_dword(Address, read_dword(tag + 0xC))
            return
        end
    end
end

function DelaySecQuat(Ply, Weapon, x, y, z)
    assign_weapon(spawn_object("weap", Weapon, x, y, z), Ply)
end

function OnTick()
    return SDTM:OnGameTick()
end
function OnPreSpawn(Ply)
    return SDTM:OnPreSpawn(Ply)
end
function OnPlayerDeath(Ply)
    return SDTM:OnPlayerDeath(Ply)
end
function Init()
    return SDTM:Init()
end

function OnScriptUnload()
    -- N/A
end
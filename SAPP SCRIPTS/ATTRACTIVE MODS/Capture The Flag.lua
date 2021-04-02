--[[
--=====================================================================================================--
Script Name: Capture the Flag, for SAPP (PC & CE)
Description: This script brings Capture the Flag game mechanics to any mode.
A single flag will spawn in the middle of the map. Return it to any base (red or blue) to score.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- configuration starts --

local CTF = {

    -- Radius (in world units) a player must be from the capture point to score:
    -- 1 world unit = 10 feet or ~3.048 meters.
    trigger_radius = 1.1,

    -- Time (in seconds) until the flag will respawn if it is dropped:
    respawn_time = 15,

    -- Points awarded on capture:
    score_on_capture = 5,

    -- Enable this if you are using my Rank System script
    rank_system_support = false,
    rank_script = "Rank System",

    on_respawn = "The flag respawned!",
    on_capture = "%name% captured a flag and has [%captures%] captures",
    on_respawn_trigger = "The flag was dropped and will respawn in %time% seconds",

    -- Default running speed:
    default_runner_speed = 1,

    on_flag_pickup = {
        [1] = { "%name% has the flag!" },
        [2] = {
            "Return the flag to a base to score.",
            "%speed%x speed boost."
        }
    },

    maps = {
        ["bloodgulch"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { 65.749, -120.409, 0.118 },
            capture_points = {
                { 95.687797546387, -159.44900512695, -0.10000000149012 },
                { 40.240600585938, -79.123199462891, -0.10000000149012 }
            }
        },
        ["deathisland"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { -30.282, 31.312, 16.601 },
            capture_points = {
                { -26.576030731201, -6.9761986732483, 9.6631727218628 },
                { 29.843469619751, 15.971487045288, 8.2952880859375 }
            }
        },
        ["icefields"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { -26.032, 32.365, 9.007 },
            capture_points = {
                { 24.85000038147, -22.110000610352, 2.1110000610352 },
                { -77.860000610352, 86.550003051758, 2.1110000610352 }
            }
        },
        ["infinity"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { 9.631, -64.030, 7.776 },
            capture_points = {
                { 0.67973816394806, -164.56719970703, 15.039022445679 },
                { -1.8581243753433, 47.779975891113, 11.791272163391 }
            }
        },
        ["sidewinder"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { 2.051, 55.220, -2.801 },
            capture_points = {
                { -32.038200378418, -42.066699981689, -3.7000000476837 },
                { 30.351499557495, -46.108001708984, -3.7000000476837 }
            }
        },
        ["timberland"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { 1.250, -1.487, -21.264 },
            capture_points = {
                { 17.322099685669, -52.365001678467, -17.751399993896 },
                { -16.329900741577, 52.360000610352, -17.741399765015 }
            }
        },
        ["dangercanyon"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { -0.477, 55.331, 0.239 },
            capture_points = {
                { -12.104507446289, -3.4351840019226, -2.2419033050537 },
                { 12.007399559021, -3.4513700008392, -2.2418999671936 }
            }
        },
        ["beavercreek"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { 14.015, 14.238, -0.911 },
            capture_points = {
                { 29.055599212646, 13.732000350952, -0.10000000149012 },
                { -0.86037802696228, 13.764800071716, -0.0099999997764826 }
            }
        },
        ["boardingaction"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { 4.374, -12.832, 7.220 },
            capture_points = {
                { 1.723109960556, 0.4781160056591, 0.60000002384186 },
                { 18.204000473022, -0.53684097528458, 0.60000002384186 }
            }
        },
        ["carousel"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { 0.033, 0.003, -0.856 },
            capture_points = {
                { 5.6063799858093, -13.548299789429, -3.2000000476837 },
                { -5.7499198913574, 13.886699676514, -3.2000000476837 }
            }
        },
        ["chillout"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { 1.392, 4.700, 3.108 },
            capture_points = {
                { 7.4876899719238, -4.49059009552, 2.5 },
                { -7.5086002349854, 9.750340461731, 0.10000000149012 }
            }
        },
        ["damnation"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { -2.002, -4.301, 3.399 },
            capture_points = {
                { 9.6933002471924, -13.340399742126, 6.8000001907349 },
                { -12.17884349823, 14.982703208923, -0.20000000298023 }
            }
        },
        ["gephyrophobia"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { 63.513, -74.088, -1.062 },
            capture_points = {
                { 26.884338378906, -144.71551513672, -16.049139022827 },
                { 26.727857589722, 0.16621616482735, -16.048349380493 }
            }
        },
        ["hangemhigh"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { 21.020, -4.632, -4.229 },
            capture_points = {
                { 13.047902107239, 9.0331249237061, -3.3619771003723 },
                { 32.655700683594, -16.497299194336, -1.7000000476837 }
            }
        },
        ["longest"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { -0.84, -14.54, 2.41 },
            capture_points = {
                { -12.791899681091, -21.6422996521, -0.40000000596046 },
                { 11.034700393677, -7.5875601768494, -0.40000000596046 }
            }
        },
        ["prisoner"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { 0.902, 0.088, 1.392 },
            capture_points = {
                { -9.3684597015381, -4.9481601715088, 5.6999998092651 },
                { 9.3676500320435, 5.1193399429321, 5.6999998092651 }
            }
        },
        ["putput"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { -2.350, -21.121, 0.902 },
            capture_points = {
                { -18.89049911499, -20.186100006104, 1.1000000238419 },
                { 34.865299224854, -28.194700241089, 0.10000000149012 }
            }
        },
        ["ratrace"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { 8.662, -11.159, 0.221 },
            capture_points = {
                { -4.2277698516846, -0.85564690828323, -0.40000000596046 },
                { 18.613000869751, -22.652599334717, -3.4000000953674 }
            }
        },
        ["wizard"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { -5.035, -5.064, -2.750 },
            capture_points = {
                { -9.2459697723389, 9.3335800170898, -2.5999999046326 },
                { 9.1828498840332, -9.1805400848389, -2.5999999046326 }
            }
        }
    }
}
-- configuration ends --

local time_scale = 1 / 30

local gsub = string.gsub
local sqrt, floor = math.sqrt, math.floor

function CTF:Init(Unload)

    local gt = (get_var(0, "$gt") ~= "n/a") and (get_var(0, "$gt") ~= "ctf")

    if (gt and not Unload) then

        local map = get_var(0, "$map")
        if (not self.maps[map]) then
            return self:Init(true)
        end

        self.game_started = true
        self.params = self.maps[map]
        self.players, self.flag = { }, { }

        -- Credits to Kavawuvi (this block of code was generated by Glazed Donut)
        local tag_address = read_dword(0x40440000)
        local tag_count = read_dword(0x4044000C)
        for i = 0, tag_count - 1 do

            local tag = (tag_address + 0x20 * i)
            local tag_class = read_dword(tag)
            local globals_tag = read_dword(tag + 0x14)

            if (tag_class == 0x6D617467) then
                self.flag_obj = read_dword(read_dword(globals_tag + 0x164 + 4) + 0xC)
            end
        end
        ------------------------------------------------------------------------------

        self:SpawnFlag()

        for i = 1, 16 do
            if player_present(i) then
                self:InitPlayer(i, false)
            end
        end

        -- Register needed event callbacks:
        register_callback(cb["EVENT_TICK"], "OnTick")
        register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
        register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
        register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    elseif (not gt or Unload) then

        -- Unload sapp events:
        unregister_callback(cb["EVENT_TICK"])
        unregister_callback(cb["EVENT_JOIN"])
        unregister_callback(cb["EVENT_LEAVE"])
        unregister_callback(cb["EVENT_GAME_END"])
        if (Unload) then
            cprint("[Capture The Flag] This map is not configured for this script.", 12)
        end
    end
end

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    OnGameStart()
end

function OnScriptUnload()
    CTF:DestroyFlag()
end

function OnGameEnd()
    CTF.game_started = false
end

function CTF:InitPlayer(Ply, Reset)
    if (not Reset) then
        self.players[Ply] = {
            captures = 0,
            name = get_var(Ply, "$name"),
        }
    else
        self.players[Ply] = nil
    end
end

function OnPlayerConnect(Ply)
    CTF:InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    CTF:InitPlayer(Ply, true)
end

function CTF:OnTick()
    if (self.game_started) then
        for flag, v in pairs(self.flag) do
            if (flag) and self:FlagDropped() then
                if (v.held_by) then
                    execute_command("s " .. v.held_by .. " 1")
                    v.held_by, v.warn, v.broadcast, v.timer = nil, true, true, 0
                elseif (v.timer and v.timer >= 0) then
                    v.timer = v.timer + time_scale
                    local time = self.respawn_time - floor(v.timer % 60)
                    if (time == floor(self.respawn_time / 2)) then
                        if (v.warn) then
                            v.warn = false
                            local msg = gsub(self.on_respawn_trigger, "%%time%%", self.respawn_time / 2)
                            self:Respond(_, msg)
                        end
                    elseif (time <= 0) then
                        self:Respond(_, self.on_respawn)
                        self:SpawnFlag()
                    end
                end
            end
        end
    end
end

function CTF:GetRadius(x, y, z)
    for _, c in pairs(self.params.capture_points) do
        if sqrt((x - c[1]) ^ 2 + (y - c[2]) ^ 2 + (z - c[3]) ^ 2) <= self.trigger_radius then
            return true
        end
    end
    return false
end

function CTF:DestroyFlag()

    -- Destroy any existing flags.
    -- Reset previous flag holders speed.

    for flag, v in pairs(self.flag) do
        if (v.held_by) then
            execute_command("s " .. v.held_by .. " " .. self.default_runner_speed)
        end
        destroy_object(flag)
    end

    self.flag = { }
end

function CTF:SpawnFlag()

    -- Destroy existing flag:
    self:DestroyFlag()

    -- Spawn a new flag:
    local c = self.params.flag_coordinates
    local x, y, z = c[1], c[2], c[3]
    local flag = spawn_object("", "", x, y, z + 1, 0, self.flag_obj)
    self.flag[flag] = { broadcast = true, obj = self.flag_obj }
end

-- Check if player has the flag:
-- Note: returns true if player is holding the oddball!
local function HasFlag(DyN, Flag)
    for i = 0, 3 do
        local WeaponID = read_dword(DyN + 0x2F8 + 4 * i)
        local WeaponObject = get_object_memory(WeaponID)
        if (WeaponID ~= 0xFFFFFFFFF and WeaponObject ~= 0) then
            if (read_dword(WeaponObject) == Flag) then
                return true
            end
        end
    end
    return false
end

function CTF:FlagDropped()
    for i, _ in pairs(self.players) do
        if player_present(i) then
            local has_flag = self:MonitorFlag(i)
            if (has_flag) then
                return false
            end
        end
    end
    return true
end

local function GetXYZ(DyN)
    local VehicleID = read_dword(DyN + 0x11C)
    local VehicleMemory = get_object_memory(VehicleID)
    if (VehicleID == 0xFFFFFFFF) then
        return read_vector3d(DyN + 0x5c)
    elseif (VehicleID ~= 0) then
        return read_vector3d(VehicleMemory + 0x5c)
    end
    return nil
end

function CTF:MonitorFlag(Ply)
    local has_flag
    for _, v in pairs(self.flag) do

        local DyN = get_dynamic_player(Ply)
        if (DyN ~= 0) then

            local x, y, z = GetXYZ(DyN)
            has_flag = HasFlag(DyN, v.obj)

            if (x and has_flag) then

                v.held_by = Ply
                local name, speed = self.players[Ply].name, self.params.flag_runner_speed

                if (v.broadcast) then
                    v.broadcast = false
                    execute_command("s " .. Ply .. " " .. speed)
                    for k, msg in pairs(self.on_flag_pickup) do
                        for i = 1, #msg do
                            local str = gsub(gsub(msg[i], "%%name%%", name), "%%speed%%", speed)
                            if (k == 1) then
                                self:Respond(Ply, str, true)
                            else
                                self:Respond(Ply, str)
                            end
                        end
                    end
                end

                if self:GetRadius(x, y, z) then

                    if (self.rank_system_support) then
                        execute_command('lua_call "' .. self.rank_script .. '" OnPlayerScore ' .. Ply)
                    end

                    local score = tonumber(get_var(Ply, "$score"))
                    score = score + self.score_on_capture
                    execute_command("score " .. Ply .. " " .. score)

                    self.players[Ply].captures = self.players[Ply].captures + 1

                    local str = gsub(gsub(self.on_capture,
                            "%%name%%", name),
                            "%%captures%%",
                            self.players[Ply].captures)

                    self:Respond(_, str)
                    self:SpawnFlag()
                    break
                end
            end

        end
    end
    return has_flag
end

function CTF:Respond(Ply, Message, Exclude)

    if (Ply and not Exclude) then
        return rprint(Ply, Message)
    end

    for i = 1, 16 do
        if player_present(i) then
            if (Exclude and i ~= Ply) or (not Ply) then
                rprint(i, Message)
            end
        end
    end
end

function OnTick()
    return CTF:OnTick()
end

function OnGameStart()
    return CTF:Init()
end
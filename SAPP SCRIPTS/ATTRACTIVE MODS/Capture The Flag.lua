api_version = "1.12.0.0"

local CaptureTheFlag = {

    -- Radius (in world units) a player must be from the capture point to score:
    trigger_radius = 1.1,

    -- Time (in seconds) the flag will respawn if it is dropped
    respawn_time = 15,

    -- Points awarded on capture:
    score_on_capture = 5,

    -- Enable this if you are using my Rank System script
    rank_system_support = true,
    rank_script = "Rank System",

    flag_object = { "weap", "weapons\\flag\\flag" },

    on_respawn = "The flag respawned!",
    on_capture = "%name% captured a flag and has [%captures%] captures",
    on_respawn_trigger = "The flag was dropped and will respawn in %time% seconds",

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
                { 95.687, -159.449, -0.100 },
                { 40.240, -79.123, -0.100 }
            }
        },
        ["deathisland"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { -30.282, 31.312, 16.601 },
            capture_points = {
                { -26.576, -6.976, 9.663 },
                { 29.843, 15.971, 8.295 }
            }
        },
        ["icefields"] = {
            flag_runner_speed = 1.5,
            flag_coordinates = { -26.032, 32.365, 9.007 },
            capture_points = {
                { 24.850, -22.110, 2.111 },
                { -77.860, 86.550, 2.111 }
            }
        },
        ["infinity"] = {
            flag_coordinates = { 9.631, -64.030, 7.776 },
            flag_runner_speed = 1.5,
            capture_points = {
                { 0.679, -164.567, 15.0399 },
                { -1.858, 47.779, 11.791 }
            }
        },
        ["sidewinder"] = {
            flag_coordinates = { 2.051, 55.220, -2.801 },
            flag_runner_speed = 1.5,
            capture_points = {
                { -32.038, -42.066, -3.700 },
                { 30.351, -46.108, -3.700 }
            }
        },
        ["timberland"] = {
            flag_coordinates = { 1.250, -1.487, -21.264 },
            flag_runner_speed = 1.5,
            capture_points = {
                { 17.322, -52.365, -17.751 },
                { -16.329, 52.360, -17.741 }
            }
        },
        ["dangercanyon"] = {
            flag_coordinates = { -0.477, 55.331, 0.239 },
            flag_runner_speed = 1.5,
            capture_points = {
                { -12.104, -3.435, -2.241 },
                { 12.007, -3.451, -2.241 }
            }
        },
        ["beavercreek"] = {
            flag_coordinates = { 14.015, 14.238, -0.911 },
            flag_runner_speed = 1.5,
            capture_points = {
                { 29.055, 13.732, -0.100 },
                { -0.860, 13.764, -0.009 }
            }
        },
        ["boardingaction"] = {
            flag_coordinates = { 4.374, -12.832, 7.220 },
            flag_runner_speed = 1.5,
            capture_points = {
                { 1.723, 0.478, 0.600 },
                { 18.204, -0.536, 0.600 }
            }
        },
        ["carousel"] = {
            flag_coordinates = { 0.033, 0.003, -0.856 },
            flag_runner_speed = 1.5,
            capture_points = {
                { 5.606, -13.548, -3.200 },
                { -5.749, 13.886, -3.200 }
            }
        },
        ["chillout"] = {
            flag_coordinates = { 1.392, 4.700, 3.108 },
            flag_runner_speed = 1.5,
            capture_points = {
                { -4.677, 7.972, 0.512 },
                { -7.508, 9.750, 0.100 }
            }
        },
        ["damnation"] = {
            flag_coordinates = { -2.002, -4.301, 3.399 },
            flag_runner_speed = 1.5,
            capture_points = {
                { 9.693, -13.340, 6.800 },
                { -12.178, 14.982, -0.200 }
            }
        },
        ["gephyrophobia"] = {
            flag_coordinates = { 63.513, -74.088, -1.062 },
            flag_runner_speed = 1.5,
            capture_points = {
                { 26.884, -144.715, -16.049 },
                { 26.727, 0.166, -16.048 }
            }
        },
        ["hangemhigh"] = {
            flag_coordinates = { 21.020, -4.632, -4.229 },
            flag_runner_speed = 1.5,
            capture_points = {
                { 13.047, 9.033, -3.361 },
                { 32.655, -16.497, -1.700 }
            }
        },
        ["longest"] = {
            flag_coordinates = { -0.84, -14.54, 2.41 },
            flag_runner_speed = 1.5,
            capture_points = {
                { -12.791, -21.642, -0.400 },
                { 11.034, -7.587, -0.400 }
            }
        },
        ["prisoner"] = {
            flag_coordinates = { 0.902, 0.088, 1.392 },
            flag_runner_speed = 1.5,
            capture_points = {
                { -9.368, -4.948, 5.699 },
                { 9.367, 5.119, 5.699 }
            }
        },
        ["putput"] = {
            flag_coordinates = { -2.350, -21.121, 0.902 },
            flag_runner_speed = 1.5,
            capture_points = {
                { -18.890, -20.186, 1.100 },
                { 34.865, -28.194, 0.100 }
            }
        },
        ["ratrace"] = {
            flag_coordinates = { 8.662, -11.159, 0.221 },
            flag_runner_speed = 1.5,
            capture_points = {
                { -4.227, -0.855, -0.400 },
                { 18.613, -22.652, -3.400 }
            }
        },
        ["wizard"] = {
            flag_coordinates = { -5.035, -5.064, -2.750 },
            flag_runner_speed = 1.5,
            capture_points = {
                { -9.245, 9.333, -2.599 },
                { 9.182, -9.180, -2.599 }
            }
        }
    }
}

local gsub = string.gsub
local time_scale = 1 / 30
local sqrt, floor = math.sqrt, math.floor

function CaptureTheFlag:Init()
    if (get_var(0, "$gt") ~= "n/a") then
        if (get_var(0, "$gt") ~= "ctf") then
            self.game_started = true
            self.players, self.flag = { }, { }
            for i = 1, 16 do
                if player_present(i) then
                    self:InitPlayer(i, false)
                end
            end
            for k, v in pairs(self.maps) do
                if (k == get_var(0, "$map")) then
                    self.params = v
                end
            end

            self:SpawnFlag()

            register_callback(cb["EVENT_TICK"], "OnTick")
            register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
            register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
            register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
        else
            unregister_callback(cb["EVENT_TICK"])
            unregister_callback(cb["EVENT_JOIN"])
            unregister_callback(cb["EVENT_LEAVE"])
            unregister_callback(cb["EVENT_GAME_END"])
        end
    end
end

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    CaptureTheFlag:Init()
end

function OnScriptUnload()

end

function OnGameStart()
    CaptureTheFlag:Init()
end

function OnGameEnd()
    CaptureTheFlag.game_started = false
end

function CaptureTheFlag:InitPlayer(Ply, Reset)
    if (not Reset) then
        self.players[Ply] = {
            captures = 0,
            name = get_var(Ply, "$name"),
        }
    end
end

function OnPlayerConnect(Ply)
    CaptureTheFlag:InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    CaptureTheFlag:InitPlayer(Ply, true)
end

function CaptureTheFlag:OnTick()
    if (self.game_started) then
        for i, _ in pairs(self.players) do
            if player_present(i) then
                self:MonitorFlag(i)
            end
        end
        for flag, v in pairs(self.flag) do
            if (flag) and self:FlagDropped() then
                if (v.held_by ~= nil) then
                    execute_command("s " .. v.held_by .. " 1")
                    v.held_by, v.warn, v.broadcast, v.timer = nil, true, true, 0
                elseif (v.timer ~= nil and v.timer >= 0) then
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

function CaptureTheFlag:GetRadius(pX, pY, pZ)
    for _, f in pairs(self.params.capture_points) do
        local X, Y, Z = f[1], f[2], f[3]
        if sqrt((pX - X) ^ 2 + (pY - Y) ^ 2 + (pZ - Z) ^ 2) <= self.trigger_radius then
            return true
        end
    end
    return false
end

function CaptureTheFlag:SpawnFlag()

    for flag, _ in pairs(self.flag) do
        if (flag) then
            destroy_object(flag)
            self.flag[flag] = nil
        end
    end

    local c = self.params.flag_coordinates
    local x, y, z = c[1], c[2], c[3]
    local flag = spawn_object(self.flag_object[1], self.flag_object[2], x, y, z + 1)
    self.flag[flag] = {
        timer = nil,
        warn = false,
        held_by = nil,
        broadcast = true,
    }
end

function CaptureTheFlag:FlagDropped()
    for i, _ in pairs(self.players) do
        if player_present(i) then
            local DyN = get_dynamic_player(i)
            if (DyN ~= 0) then
                if self:hasObjective(DyN) then
                    return false
                end
            end
        end
    end
    return true
end

function CaptureTheFlag:MonitorFlag(Ply)
    for flag, v in pairs(self.flag) do
        if (flag) then

            local pos = self:GetXYZ(Ply)
            if (pos and self:hasObjective(pos.dyn)) then

                v.held_by = Ply

                local name, speed = self.players[Ply].name, self.params.flag_runner_speed

                if (v.broadcast) then
                    v.broadcast = false
                    execute_command("s " .. Ply .. " " .. speed)
                    for k, msg in pairs(self.on_flag_pickup) do
                        for i = 1, #msg do
                            local str = gsub(gsub(msg[i], "%%name%%", name), "%%speed%%", speed)
                            if (k == 1) then
                                self:Respond(Ply, str, 10, true)
                            else
                                self:Respond(Ply, str)
                            end
                        end
                    end
                end

                if self:GetRadius(pos.x, pos.y, pos.z) and (flag) then

                    local score = tonumber(get_var(Ply, "$score"))
                    if (self.rank_system_support) then
                        execute_command('lua_call "' .. self.rank_script .. '" OnPlayerScore ' .. Ply)
                    end

                    score = score + self.score_on_capture
                    execute_command("s " .. Ply .. " 1")
                    execute_command("score " .. Ply .. " " .. score)

                    self.players[Ply].captures = self.players[Ply].captures + 1
                    self:Respond(_, gsub(gsub(self.on_capture, "%%name%%", name), "%%captures%%", self.players[Ply].captures))
                    self:SpawnFlag()
                    break
                end
            end
        end
    end
end

function CaptureTheFlag:GetXYZ(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local VehicleID = read_dword(DyN + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            local x, y, z = read_vector3d(DyN + 0x5c)
            return { x = x, y = y, z = z, dyn = DyN }
        end
    end
    return nil
end

local function GetObjectTagName(TAG)
    return read_string(read_dword(read_word(TAG) * 32 + 0x40440038))
end

function CaptureTheFlag:hasObjective(DyN)
    for i = 0, 3 do
        local WeaponID = read_dword(DyN + 0x2F8 + (i * 4))
        if (WeaponID ~= 0xFFFFFFFF) then
            local WeaponObject = get_object_memory(WeaponID)
            if (WeaponObject ~= 0) then
                if (GetObjectTagName(WeaponObject) == self.flag_object[2]) then
                    return true
                end
            end
        end
    end
    return false
end

function CaptureTheFlag:Respond(Ply, Message, Color, Exclude)
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

function OnTick()
    return CaptureTheFlag:OnTick()
end
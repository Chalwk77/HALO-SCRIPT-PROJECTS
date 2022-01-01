--[[
--=====================================================================================================--
Script Name: Capture the Flag (v1.1), for SAPP (PC & CE)
Description: This script brings CTF-like mechanics to any Slayer (FFA/Team) game type.
             A single flag will spawn somewhere on the map. Return it to any base to score.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local CTF = {

    -- Time (in seconds) until a dropped flag will respawn:
    -- Default: 15 seconds
    --
    respawn_delay = 15,

    -- Message sent when a flag was dropped (appears at respawn_delay/2 seconds)
    -- Leave blank ("") to disable.
    --
    respawn_warning = "The flag was dropped and will respawn in $S second$s",

    -- Message broadcast when the flag respawns:
    -- Leave blank ("") to disable.
    --
    message_on_respawn = "The flag has respawned",

    -- Message broadcast when someone captures the flag:
    -- Leave blank ("") to disable.
    --
    message_on_capture = "$name captured a flag",

    -- Message broadcast when someone picks up the flag:
    -- Leave blank ("") to disable.
    --
    on_pickup = {
        -- message to all players:
        "$name has the flag.",
        -- message to flag carrier:
        "Return the flag to ANY base to score!",
    },

    -- Points received for capturing a flag:
    -- Default: 5
    --
    points_on_capture = 5,

    -- Set to nil to disable score limit:
    -- Default: nil
    --
    score_limit = nil,

    -----------------------------
    -- individual map settings --
    -----------------------------
    ["bloodgulch"] = {
        spawn_location = { 65.749, -120.409, 0.118 },
        capture_points = {
            { 95.687797546387, -159.44900512695, -0.10000000149012 },
            { 40.240600585938, -79.123199462891, -0.10000000149012 }
        }
    },
    ["deathisland"] = {
        spawn_location = { -30.282, 31.312, 16.601 },
        capture_points = {
            { -26.576030731201, -6.9761986732483, 9.6631727218628 },
            { 29.843469619751, 15.971487045288, 8.2952880859375 }
        }
    },
    ["icefields"] = {
        spawn_location = { -26.032, 32.365, 9.007 },
        capture_points = {
            { 24.85000038147, -22.110000610352, 2.1110000610352 },
            { -77.860000610352, 86.550003051758, 2.1110000610352 }
        }
    },
    ["infinity"] = {
        spawn_location = { 9.631, -64.030, 7.776 },
        capture_points = {
            { 0.67973816394806, -164.56719970703, 15.039022445679 },
            { -1.8581243753433, 47.779975891113, 11.791272163391 }
        }
    },
    ["sidewinder"] = {
        spawn_location = { 2.051, 55.220, -2.801 },
        capture_points = {
            { -32.038200378418, -42.066699981689, -3.7000000476837 },
            { 30.351499557495, -46.108001708984, -3.7000000476837 }
        }
    },
    ["timberland"] = {
        spawn_location = { 1.250, -1.487, -21.264 },
        capture_points = {
            { 17.322099685669, -52.365001678467, -17.751399993896 },
            { -16.329900741577, 52.360000610352, -17.741399765015 }
        }
    },
    ["dangercanyon"] = {
        spawn_location = { -0.477, 55.331, 0.239 },
        capture_points = {
            { -12.104507446289, -3.4351840019226, -2.2419033050537 },
            { 12.007399559021, -3.4513700008392, -2.2418999671936 }
        }
    },
    ["beavercreek"] = {
        spawn_location = { 14.015, 14.238, -0.911 },
        capture_points = {
            { 29.055599212646, 13.732000350952, -0.10000000149012 },
            { -0.86037802696228, 13.764800071716, -0.0099999997764826 }
        }
    },
    ["boardingaction"] = {
        spawn_location = { 4.374, -12.832, 7.220 },
        capture_points = {
            { 1.723109960556, 0.4781160056591, 0.60000002384186 },
            { 18.204000473022, -0.53684097528458, 0.60000002384186 }
        }
    },
    ["carousel"] = {
        spawn_location = { 0.033, 0.003, -0.856 },
        capture_points = {
            { 5.6063799858093, -13.548299789429, -3.2000000476837 },
            { -5.7499198913574, 13.886699676514, -3.2000000476837 }
        }
    },
    ["chillout"] = {
        spawn_location = { 1.392, 4.700, 3.108 },
        capture_points = {
            { 7.4876899719238, -4.49059009552, 2.5 },
            { -7.5086002349854, 9.750340461731, 0.10000000149012 }
        }
    },
    ["damnation"] = {
        spawn_location = { -2.002, -4.301, 3.399 },
        capture_points = {
            { 9.6933002471924, -13.340399742126, 6.8000001907349 },
            { -12.17884349823, 14.982703208923, -0.20000000298023 }
        }
    },
    ["gephyrophobia"] = {
        spawn_location = { 63.513, -74.088, -1.062 },
        capture_points = {
            { 26.884338378906, -144.71551513672, -16.049139022827 },
            { 26.727857589722, 0.16621616482735, -16.048349380493 }
        }
    },
    ["hangemhigh"] = {
        spawn_location = { 21.020, -4.632, -4.229 },
        capture_points = {
            { 13.047902107239, 9.0331249237061, -3.3619771003723 },
            { 32.655700683594, -16.497299194336, -1.7000000476837 }
        }
    },
    ["longest"] = {
        spawn_location = { -0.84, -14.54, 2.41 },
        capture_points = {
            { -12.791899681091, -21.6422996521, -0.40000000596046 },
            { 11.034700393677, -7.5875601768494, -0.40000000596046 }
        }
    },
    ["prisoner"] = {
        spawn_location = { 0.902, 0.088, 1.392 },
        capture_points = {
            { -9.3684597015381, -4.9481601715088, 5.6999998092651 },
            { 9.3676500320435, 5.1193399429321, 5.6999998092651 }
        }
    },
    ["putput"] = {
        spawn_location = { -2.350, -21.121, 0.902 },
        capture_points = {
            { -18.89049911499, -20.186100006104, 1.1000000238419 },
            { 34.865299224854, -28.194700241089, 0.10000000149012 }
        }
    },
    ["ratrace"] = {
        spawn_location = { 8.662, -11.159, 0.221 },
        capture_points = {
            { -4.2277698516846, -0.85564690828323, -0.40000000596046 },
            { 18.613000869751, -22.652599334717, -3.4000000953674 }
        }
    },
    ["wizard"] = {
        spawn_location = { -5.035, -5.064, -2.750 },
        capture_points = {
            { -9.2459697723389, 9.3335800170898, -2.5999999046326 },
            { 9.1828498840332, -9.1805400848389, -2.5999999046326 }
        }
    },

    -- A message relay function temporarily removes the server message prefix
    -- and will restore it to this when the relay is finished:
    server_prefix = "**SAPP**",

    -- Script errors (if any) will be logged to this file:
    --
    error_file = "CTF (errors).log",

    -- DO NOT TOUCH BELOW THIS POINT --
    script_version = 1.1
    --
}
-- config ends --

api_version = "1.12.0.0"

-- This function is called when the script is loaded into SAPP:
--
function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    OnGameStart()
end

-- Sets up pre-game parameters:
--
function CTF:Init()
    if (get_var(0, "$gt") ~= "n/a") then

        self.flag = { }

        if (get_var(0, "$gt") ~= "slayer") then
            return error("This game type is not supported")
        end

        local map = get_var(0, "$map")
        if (self[map]) then

            local tag_address = read_dword(0x40440000)
            local tag_count = read_dword(0x4044000C)

            for i = 0, tag_count - 1 do
                local tag = (tag_address + 0x20 * i)
                local tag_class = read_dword(tag)
                local globals_tag = read_dword(tag + 0x14)
                if (tag_class == 0x6D617467) then

                    self.announce_pickup = false
                    self.flag.id = read_dword(read_dword(globals_tag + 0x164 + 4) + 0xC)

                    self.z_off = 0.2
                    self.x = self[map].spawn_location[1]
                    self.y = self[map].spawn_location[2]
                    self.z = self[map].spawn_location[3] + self.z_off

                    self.capture_points = self[map].capture_points

                    self:SpawnFlag()

                    -- Set the score limit:
                    execute_command("scorelimit " .. (self.score_limit or ""))

                    self.team_play = (get_var(0, "$ffa") == "0")

                    register_callback(cb["EVENT_TICK"], "OnTick")
                    register_callback(cb["EVENT_GAME_END"], "OnScriptUnload")
                    goto done
                end
            end
        end

        unregister_callback(cb["EVENT_GAME_END"])
        unregister_callback(cb["EVENT_TICK"])
        :: done ::
    end
end

-- This function broadcasts a custom server message:
-- Temporarily removes the server message prefix and restores it.
-- @param Ply (player index) [number]
-- @param Msg (message) [string]
--
function CTF:Broadcast(Ply, Msg)
    if (Msg ~= "") then
        execute_command("msg_prefix \"\"")
        if (Ply) then
            say(Ply, Msg)
        else
            say_all(Msg)
        end
        execute_command("msg_prefix \" " .. self.server_prefix .. "\"")
    end
end

-- Teleports the flag back to its starting location:
--
function CTF:SpawnFlag(Ply)

    self:DestroyFlag()
    self.flag.timer = 0
    self.flag.object = spawn_object("", "", self.x, self.y, self.z, 0, self.flag.id)

    if (Ply) then
        local msg = self.message_on_capture
        msg = msg:gsub("$name", get_var(Ply, "$name"))
        self:Broadcast(nil, msg)
        return
    end

    self:Broadcast(nil, self.message_on_respawn)
end

-- Checks if a player is holding the flag:
-- @return true if holding flag, false if not [bool]
--
function CTF:GetFlagCarrier()
    for i = 1, 16 do
        if player_present(i) and player_alive(i) and self:HasFlag(i) then
            return i
        end
    end
    self.announce_pickup = true
    return false
end

-- Distance function using pythagoras theorem:
--
local function GetDistance(x, y, z, x2, y2, z2, r)
    return math.sqrt((x - x2) ^ 2 + (y - y2) ^ 2 + (z - z2) ^ 2) <= r
end

-- Returns a players map coordinates:
-- @param Ply (player index) [number]
-- @return (three 32-bit floating point numbers (player coordinates)) [float]
--
local function GetXYZ(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local VehicleID = read_dword(DyN + 0x11C)
        local VehicleObj = get_object_memory(VehicleID)
        if (VehicleID == 0xFFFFFFFF) then
            return read_vector3d(DyN + 0x5C)
        elseif (VehicleObj ~= 0) then
            return read_vector3d(VehicleObj + 0x5C)
        end
    end
    return nil
end

-- Returns the flag object coordinates:
-- @return (three 32-bit floating point numbers [float]
--
function CTF:GetFlagPos()
    local flag = self.flag.object
    if (flag) then
        local object = get_object_memory(flag)
        if (object ~= 0) then
            return read_vector3d(object + 0x5c)
        end
    end
    return nil
end

local function Plural(n)
    return (n > 1 and "s") or ""
end

-- This function is called once every 1/30th second (1 tick):
--
function CTF:GameTick()

    -- respawn the flag:
    local flag_carrier = self:GetFlagCarrier()
    if (not flag_carrier) then

        local fx, fy, fz = self:GetFlagPos()
        if (fx and not GetDistance(fx, fy, fz, self.x, self.y, self.z - self.z_off, 0.3)) then

            self.flag.timer = self.flag.timer + 1 / 30
            local time = self.respawn_delay - self.flag.timer % 60
            time = tonumber(string.format("%.2" .. "f", time))

            if (time == self.respawn_delay / 2) then
                local msg = self.respawn_warning
                msg = msg:gsub("$S", time):gsub("$s", Plural(time))
                self:Broadcast(nil, msg)

            elseif (self.flag.timer >= self.respawn_delay) then
                self:SpawnFlag()
            end
        end
        goto done
    end

    -- check for flag capture:
    for i = 1, 16 do
        if player_present(i) and player_alive(i) and (i == flag_carrier) then
            local px, py, pz = GetXYZ(i)
            if (px) then
                for _, v in pairs(self.capture_points) do
                    if GetDistance(px, py, pz, v[1], v[2], v[3] - self.z_off, 0.5) then

                        -- spawn a new flag:
                        self:SpawnFlag(i)

                        -- update score:
                        if (self.team_play) then
                            self:UpdateScore(i, true)
                        else
                            self:UpdateScore(i)
                        end

                        goto done
                    end
                end
            end
        end
    end

    :: done ::
end

function CTF:UpdateScore(Ply, TeamScore)

    local Amount = self.points_on_capture

    -- Update team score:
    if (TeamScore) then
        local team = get_var(Ply, "$team")
        local team_score
        if (team == "red") then
            team = 0
            team_score = get_var(0, "$redscore")
        else
            team = 1
            team_score = get_var(0, "$bluescore")
        end
        team_score = (team_score - 1) + Amount
        execute_command("team_score " .. team .. " " .. team_score)
    end

    -- Update player score:
    local score = tonumber(get_var(Ply, "$score"))
    score = (score - 1) + Amount
    execute_command("score " .. Ply .. " " .. score)
end

local function AnnouncePickup(Ply, self)
    if (self.announce_pickup) then
        self.announce_pickup = false

        local msg = self.on_pickup[1]
        local name = get_var(Ply, "$name")
        msg = msg:gsub("$name", name)
        self:Broadcast(nil, msg)

        self:Broadcast(Ply, self.on_pickup[2])
    end
end

-- Checks if a player is holding the flag:
-- @param Ply (player index) [number]
--
function CTF:HasFlag(Ply)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        for i = 0, 3 do
            local WeaponID = read_dword(DyN + 0x2F8 + (i * 4))
            if (WeaponID ~= 0xFFFFFFFF) then
                local Weapon = get_object_memory(WeaponID)
                if (Weapon ~= 0) then
                    local tag_address = read_word(Weapon)
                    local tag_data = read_dword(read_dword(0x40440000) + tag_address * 0x20 + 0x14)
                    if (read_bit(tag_data + 0x308, 3) == 1) then
                        self.flag.timer = 0
                        AnnouncePickup(Ply, self)
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Destroys the flag:
--
function CTF:DestroyFlag()
    destroy_object(self.flag and self.flag.object or 0)
end

function OnTick()
    return CTF:GameTick()
end

function OnGameStart()
    CTF:Init()
end

function OnScriptUnload()
    CTF:DestroyFlag()
end

-- Error handler:
--
local function WriteError(err)
    local file = io.open(CTF.error_file, "a+")
    if (file) then
        file:write(err .. "\n")
        file:close()
    end
end

-- This function is called every time an error is raised:
--
function OnError(Error)

    local log = {

        -- log format: {msg, console out [true/false], console color}
        -- If console out = false, the message will not be logged to console.

        { os.date("[%H:%M:%S - %d/%m/%Y]"), true, 12 },
        { Error, false, 12 },
        { debug.traceback(), true, 12 },
        { "--------------------------------------------------------", true, 5 },
        { "Please report this error on github:", true, 7 },
        { "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", true, 7 },
        { "Script Version: " .. CTF.script_version, true, 7 },
        { "--------------------------------------------------------", true, 5 }
    }

    for _, v in pairs(log) do
        WriteError(v[1])
        if (v[2]) then
            cprint(v[1], v[3])
        end
    end

    WriteError("\n")
end

-- For a future update:
return CTF
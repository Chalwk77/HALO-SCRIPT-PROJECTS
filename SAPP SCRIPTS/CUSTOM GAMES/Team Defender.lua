--[[
--=====================================================================================================--
Script Name: Team Defender (v1.0), for SAPP (PC & CE)
Description: This is Team Defender from Call of Duty: Modern Warfare 3.

             * A flag will spawn somewhere on the map.
             * One player must hold on to the flag for as long as possible, while his teammates defend him.
             * The team holding the flag receives double points towards the match score.
             * Players holding the flag will get +20 assist points for every kill that a teammate gets.
             * The flag respawns after 15 seconds if not held.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local TeamDefender = {

    -- Time (in seconds) until a dropped flag will respawn:
    -- Default: 15 seconds
    respawn_delay = 15,

    -- When enabled, friendly fire will be blocked:
    --
    block_friendly_fire = true,

    -- Message broadcast when the flag respawns:
    -- Leave blank ("") to disable.
    --
    message_on_respawn = "The flag has respawned",


    -- Scoring and custom messages:
    -- Leave messages blank ("") to disable.
    scoring = {

        -- The player holding the flag will get this many assist points
        -- for every kill that a teammate gets:
        -- Default: 20
        --
        { 20, "+20 Team Assist" },

        -- Team without flag (points per kill)
        -- Default: 50
        --
        { 50, "+50 Kill Bonus" },

        -- Team with flag (points per kill)
        -- Default: 100
        --
        { 100, "+100 Defence" },

        -- Flag carrier kill points:
        -- Default: 250
        --
        { 250, "+250 Flag Carrier kill" },

        -- Score limit:
        -- Default: 7500
        --
        7500
    },

    -- flag spawn coordinates:
    ["bloodgulch"] = { 65.749, -120.409, 0.118 },
    ["deathisland"] = { -30.282, 31.312, 16.601 },
    ["icefields"] = { -26.032, 32.365, 9.007 },
    ["infinity"] = { 9.631, -64.030, 7.776 },
    ["sidewinder"] = { 2.051, 55.220, -2.801 },
    ["timberland"] = { 1.250, -1.487, -21.264 },
    ["dangercanyon"] = { -0.477, 55.331, 0.239 },
    ["beavercreek"] = { 14.015, 14.238, -0.911 },
    ["boardingaction"] = { 4.374, -12.832, 7.220 },
    ["carousel"] = { 0.033, 0.003, -0.856 },
    ["chillout"] = { 1.392, 4.700, 3.108 },
    ["damnation"] = { -2.002, -4.301, 3.399 },
    ["gephyrophobia"] = { 63.513, -74.088, -1.062 },
    ["hangemhigh"] = { 21.020, -4.632, -4.229 },
    ["longest"] = { -0.84, -14.54, 2.41 },
    ["prisoner"] = { 0.902, 0.088, 1.392 },
    ["putput"] = { -2.350, -21.121, 0.902 },
    ["ratrace"] = { 8.662, -11.159, 0.221 },
    ["wizard"] = { -5.035, -5.064, -2.750 },

    -- A message relay function temporarily removes the server message prefix
    -- and will restore it to this when the relay is finished:
    server_prefix = "**SAPP**",

    -- DO NOT TOUCH BELOW THIS POINT --
    script_version = 1.0
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

-- This function is called when a new game has started:
--
function OnGameStart()
    TeamDefender:Init()
end

-- This function broadcasts a custom server message:
-- Temporarily removes the server message prefix and restores it.
-- @param Ply (player index) [number]
-- @param Msg (message) [string]
--
function TeamDefender:Broadcast(Ply, Msg)
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

-- Updates player scores:
-- @param Ply (killer index) [number]
-- @param Team (killer team) [string]
-- @param Amount (points to add) [number]
-- @param FlagCarrier (flag carrier index) [number]
--
function TeamDefender:UpdateScores(Ply, Team, Amount, FlagCarrier)

    -- Update team score:
    local team_score
    if (Team == "red") then
        Team = 0
        team_score = get_var(0, "$redscore")
    else
        Team = 1
        team_score = get_var(0, "$bluescore")
    end
    team_score = (team_score - 1) + Amount
    execute_command("team_score " .. Team .. " " .. team_score)

    -- Update player score to reflect @param Amount:
    local player_score = tonumber(get_var(Ply, "$score"))
    player_score = (player_score - 1) + Amount
    execute_command("score " .. Ply .. " " .. player_score)

    -- Update flag carrier assist points:
    if (FlagCarrier and FlagCarrier ~= Ply) then
        local assists = tonumber(get_var(FlagCarrier, "$assists"))
        assists = assists + self.scoring[1][1]
        execute_command("assists " .. FlagCarrier .. " " .. assists)
        self:Broadcast(FlagCarrier, self.scoring[1][2])
    end
end

-- This function is called during event_die and event_damage_application:
-- Updates player scores.
-- @param Victim (Victim) [number]
-- @param Killer (Killer) [number]
-- @param MetaID (damage tag id) [number]
--
function TeamDefender:OnDeath(Victim, Killer, MetaID, _, _, _)

    local victim = tonumber(Victim)
    local killer = tonumber(Killer)

    if (killer > 0) then

        local k_team = get_var(killer, "$team")
        local v_team = get_var(victim, "$team")

        local suicide = (killer == victim)
        local friendly_fire = (k_team == v_team and not suicide)

        -- event_damage_application --
        if (MetaID) then
            return (self.block_friendly_fire and friendly_fire and false) or true
        end

        -- event_die --
        if (not suicide and not friendly_fire) then

            -- flag carrier kill:
            if self:HasFlag(victim) then
                self:Broadcast(killer, self.scoring[4][2])
                self:UpdateScores(killer, k_team, self.scoring[4][1])
                return
            end

            -- Team with flag:
            local flag_carrier_team, flag_carrier = self:GetFlagCarrier()
            if (flag_carrier_team == k_team) then
                self:Broadcast(killer, self.scoring[3][2])
                self:UpdateScores(killer, k_team, self.scoring[3][1], flag_carrier)
            else
                -- Team without flag:
                self:Broadcast(killer, self.scoring[2][2])
                self:UpdateScores(killer, k_team, self.scoring[2][1])
            end
        end
    end
end

-- Teleports the flag back to its starting location:
--
function TeamDefender:SpawnFlag()
    self:DestroyFlag()
    self.flag.timer = 0
    self.flag.object = spawn_object("", "", self.x, self.y, self.z, 0, self.flag.id)
    self:Broadcast(nil, self.message_on_respawn)
end

-- Checks if a player is holding the flag:
-- @return true if holding flag, false if not [bool]
--
function TeamDefender:GetFlagCarrier()
    for i = 1, 16 do
        if player_present(i) and player_alive(i) and self:HasFlag(i) then
            return get_var(i, "$team"), i
        end
    end
    return false
end

-- Distance function using pythagoras theorem:
--
local function AtSpawn(x, y, z, self)
    local sx, sy, sz = self.x, self.y, self.z
    if math.sqrt((x - sx) ^ 2 + (y - sy) ^ 2 + (z - sz) ^ 2) <= 0.2 then
        return true
    end
    return false
end

-- This function is called once every 1/30th second (1 tick):
-- Used to respawn the flag:
--
function TeamDefender:GameTick()
    if (not self:GetFlagCarrier()) then
        local flag = self.flag.object
        if (flag) then
            local object = get_object_memory(flag)
            if (object ~= 0) then
                local x, y, z = read_vector3d(object + 0x5c)
                if (not AtSpawn(x, y, z, self)) then
                    self.flag.timer = self.flag.timer + 1 / 30
                    if (self.flag.timer >= self.respawn_delay) then
                        self:SpawnFlag()
                    end
                end
            end
        end
    end
end

-- Checks if a player is holding the flag:
-- @param Ply (player index) [number]
--
function TeamDefender:HasFlag(Ply)
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
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Sets up pre-game parameters:
--
function TeamDefender:Init()
    if (get_var(0, "$gt") ~= "n/a") then

        self.flag = { }

        local map = get_var(0, "$map")
        if (self[map]) then

            local tag_address = read_dword(0x40440000)
            local tag_count = read_dword(0x4044000C)

            for i = 0, tag_count - 1 do
                local tag = (tag_address + 0x20 * i)
                local tag_class = read_dword(tag)
                local globals_tag = read_dword(tag + 0x14)
                if (tag_class == 0x6D617467) then
                    self.flag.id = read_dword(read_dword(globals_tag + 0x164 + 4) + 0xC)

                    self.x = self[map][1]
                    self.y = self[map][2]
                    self.z = self[map][3] + 0.2

                    self:SpawnFlag()

                    execute_command("scorelimit " .. self.scoring[5])

                    register_callback(cb["EVENT_DIE"], "OnDeath")
                    register_callback(cb["EVENT_TICK"], "OnTick")
                    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDeath")
                    goto done
                end
            end
        end

        unregister_callback(cb["EVENT_DIE"])
        unregister_callback(cb["EVENT_TICK"])
        unregister_callback(cb["EVENT_DAMAGE_APPLICATION"])

        :: done ::
    end
end

-- Destroys the flag:
--
function TeamDefender:DestroyFlag()
    destroy_object(self.flag and self.flag.object or 0)
end

function OnTick()
    return TeamDefender:GameTick()
end

function OnDeath(V, K, MID)
    return TeamDefender:OnDeath(V, K, MID)
end

function OnScriptUnload()
    TeamDefender:DestroyFlag()
end

-- Error handler:
--
local function WriteError(err)
    local file = io.open(KillConfirmed.error_file, "a+")
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
        { "Script Version: " .. TeamDefender.script_version, true, 7 },
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
return TeamDefender
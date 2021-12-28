--[[
--=====================================================================================================--
Script Name: Kill Confirmed (v1.2), for SAPP (PC & CE)
Description: This is Kill Confirmed from Call of Duty: Modern Warfare 3.

             * Teams score by collecting dog tags (skulls) that enemies drop upon death.
			 * The first team to 65 points wins (or the team with the most points after the game time runs out).
			 * Dog tags (skulls) will despawn after 30 seconds (configurable).
             * Players will not be penalized points for suicide.

             NOTE: This script is designed to be run on TEAM SLAYER.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local KillConfirmed = {

    -- config starts --

    -- Team score limit required to win:
    --
    score_limit = 65,

    -- Points added for confirming a kill:
    points_on_confirm = 2,

    -- Time (in seconds) until a dog tag will despawn:
    --
    despawn_delay = 30,

    -- When enabled, friendly fire will be blocked:
    --
    block_friendly_fire = true,

    -- The object representing a dog tag:
    --
    dog_tag_object = "weapons\\ball\\ball",

    -- Kill confirm messages:
    --
    on_confirm = {
        -- Message sent when you confirm your own kill:
        "$name confirmed a kill on $victim",

        -- Message sent when a teammate confirms your kill:
        "$name confirmed $killer's kill on $victim"
    },

    -- Message sent when an opponent denies your kill:
    --
    on_deny = "$name denied $killer's kill",

    -- A message relay function temporarily removes the server message prefix
    -- and will restore it to this when the relay is finished:
    server_prefix = "**SAPP**",
    --

    -- Script errors (if any) will be logged to this file:
    --
    error_file = "Kill Confirmed (errors).log",

    -- config ends --

    -- DO NOT TOUCH BELOW THIS POINT --
    script_version = 1.2
    --
}

api_version = "1.12.0.0"

-- Destroys a specific dog tag (skull) from the world and clears its array index:
-- @param k (array index) [number]
-- @param v (dog tag array) [table]
--
local function DestroyDogTag(k, v)
    destroy_object(v.object)
    KillConfirmed.dog_tags[k] = nil
end

-- Destroys existing dog tags (skulls) from the world:
--
local function RemoveAllDogTags()
    for k, v in pairs(KillConfirmed.dog_tags) do
        if (k) then
            DestroyDogTag(k, v)
        end
    end
end

-- Register needed event callbacks:
-- Unregisters callbacks if the game mode is not Team Slayer.
--
local function EventsRegistered(gt)

    if (gt == "slayer" and get_var(0, "$ffa") == "0") then
        register_callback(cb["EVENT_TICK"], "OnTick")
        register_callback(cb["EVENT_DIE"], "DeathHandler")
        register_callback(cb["EVENT_WEAPON_PICKUP"], "OnWeaponPickUp")
        register_callback(cb["EVENT_DAMAGE_APPLICATION"], "DeathHandler")
        return true
    end

    unregister_callback(cb["EVENT_TICK"])
    unregister_callback(cb["EVENT_DIE"])
    unregister_callback(cb["EVENT_WEAPON_PICKUP"])
    unregister_callback(cb["EVENT_DAMAGE_APPLICATION"])
    error("This game type is not supported! Must be Team Slayer")

    return false
end

-- Sets up pre-game parameters:
--
function KillConfirmed:Init()

    self.game_started = false
    self.dog_tags = self.dog_tags or { }

    RemoveAllDogTags()

    local gt = get_var(0, "$gt")
    if (gt ~= "n/a" and EventsRegistered(gt)) then
        self.game_started = true
        execute_command("scorelimit " .. self.score_limit)
    end
end

-- This function is called when the script is loaded into SAPP:
--
function OnScriptLoad()
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnNewGame")
    KillConfirmed:Init()
end

-- This function is called when a new game has started:
--
function OnNewGame()
    KillConfirmed:Init()
end

-- This function is called when a game ends (pre post-game-carnage report):
--
function OnGameEnd()
    KillConfirmed.game_started = false
end

-- This function is called once every 1/30th second (1 tick):
-- Used to despawn dog tags (skulls).
--
function KillConfirmed:GameTick()
    if (self.game_started) then
        for k, v in pairs(self.dog_tags) do
            if (k) then
                v.timer = v.timer + 1 / 30
                if (v.timer >= self.despawn_delay) then
                    DestroyDogTag(k, v)
                end
            end
        end
    end
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

-- Spawns a new dog tag (skull) at a players location upon death:
-- @param Victim (player index) [number]
-- @param Killer (player index) [number]
--
function KillConfirmed:SpawnNewTag(Victim, Killer)

    local x, y, z = GetXYZ(Victim)

    if (x) then

        -- Z-offset used to prevent the object from falling through the map (in world units):
        local z_off = 0.2
        --

        local object = spawn_object("weap", self.dog_tag_object, x, y, z + z_off)
        local tag = get_object_memory(object)

        self.dog_tags[tag] = {
            timer = 0,
            kid = Killer,
            vid = Victim,
            object = object,
            v_name = get_var(Victim, "$name"),
            k_name = get_var(Killer, "$name")
        }
    end
end

-- Changes team score to reflect number of confirmed kills:
-- @param Ply (player index) [number]
-- @param Add (add to score) [bool]
--
local function EditTeamScore(Ply, Add)
    local team = get_var(Ply, "$team")
    local score
    if (team == "red") then
        team = 0
        score = get_var(0, "$redscore")
    else
        team = 1
        score = get_var(0, "$bluescore")
    end
    score = (Add and score + KillConfirmed.points_on_confirm) or score - 1
    execute_command("team_score " .. team .. " " .. score)
end

-- Updates player score when confirming a kill or committing suicide:
-- @param Ply (player index) [number]
-- @param Deduct (deduct score) [bool]
-- @param Add (add to score) [bool]
--
local function UpdateScore(Ply, Deduct, Add)

    local score = tonumber(get_var(Ply, "$score"))

    if (Deduct) then
        score = (score - 1 <= 0 and 0) or score - 1
        EditTeamScore(Ply, false)
        goto done
    elseif (Add) then
        score = score + 1
        goto done
    elseif (not Deduct and not Add) then
        EditTeamScore(Ply, true)
        goto next
    end

    :: next ::
    score = score + KillConfirmed.points_on_confirm

    :: done ::
    execute_command("score " .. Ply .. " " .. score)
end

-- This function is called during event_die and event_damage_application:
-- Spawns a new dog tag (skull) during PvP.
-- Updates player scores.
-- @param Victim (Victim) [number]
-- @param Killer (Killer) [number]
-- @param MetaID (damage tag id) [number]
--
function KillConfirmed:DeathHandler(Victim, Killer, MetaID, _, _, _)

    local victim = tonumber(Victim)
    local killer = tonumber(Killer)

    if (killer > 0 and self.game_started) then

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
            UpdateScore(Killer, true, false)
            self:SpawnNewTag(victim, killer)
        elseif (suicide) then
            UpdateScore(victim, false, true)
        end
    end
end

-- Returns the tag name of a given object:
-- @param obj (object id) [number]
-- @return object tag name [string]
local function TagID(obj)
    if (obj ~= nil and obj ~= 0) then
        return read_string(read_dword(read_word(obj) * 32 + 0x40440038))
    end
    return nil
end

-- This function broadcasts a custom server message:
-- Temporarily removes the server message prefix and restores it.
-- @param Msg (message) [string]
--
local function Broadcast(Msg)
    execute_command("msg_prefix \"\"")
    say_all(Msg)
    execute_command("msg_prefix \" " .. KillConfirmed.server_prefix .. "\"")
end

-- This function is called every time a player picks up a weapon:
-- Updates player score when confirming a kill and broadcasts a custom message.
-- @param Ply (player index) [number]
-- @param WeapIndex (weapon index (slot)) [number]
-- @param Type (weapon type) [string]
--
function KillConfirmed:OnWeaponPickUp(Ply, WeapIndex, Type)
    if (tonumber(Type) == 1 and self.game_started) then

        WeapIndex = tonumber(WeapIndex)

        local DyN = get_dynamic_player(Ply)
        if (DyN ~= 0) then

            local weapon = read_dword(DyN + 0x2F8 + (WeapIndex - 1) * 4)
            local object = get_object_memory(weapon)
            if (object ~= 0) then

                if (TagID(object) == self.dog_tag_object) then
                    for k, v in pairs(self.dog_tags) do
                        if (k and k == object) then

                            local team = get_var(Ply, "$team")
                            local name = get_var(Ply, "$name")

                            local confirmed = (Ply == v.kid) or (team == get_var(v.kid, "$team"))
                            local denied = (Ply == v.vid) or (team == get_var(v.vid, "$team"))

                            local msg = (v.kid == Ply and self.on_confirm[1]) or self.on_confirm[2]
                            if (confirmed) then
                                UpdateScore(Ply, false, false)
                            elseif (denied) then
                                msg = self.on_deny
                            end
                            msg = msg:gsub("$name", name):gsub("$killer", v.k_name):gsub("$victim", v.v_name)

                            Broadcast(msg)
                            DestroyDogTag(k, v)
                            break
                        end
                    end
                end
            end
        end
    end
end

function DeathHandler(V, K, MID, _, _, _)
    KillConfirmed:DeathHandler(V, K, MID, _, _, _)
end

function OnWeaponPickUp(P, WI, T)
    KillConfirmed:OnWeaponPickUp(P, WI, T)
end

function OnTick()
    return KillConfirmed:GameTick()
end

function OnScriptUnload()
    RemoveAllDogTags()
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
        { "Script Version: " .. KillConfirmed.script_version, true, 7 },
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
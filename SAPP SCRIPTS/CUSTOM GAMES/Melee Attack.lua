--[[
--=====================================================================================================--
Script Name: Melee Attack, for SAPP (PC & CE)
Description: In Melee Attack, players are limited to melee-only combat and can only use an oddball (skull).
             Striking your opponent will insta-kill them.

Settings:

* Set the score limit (default 50).

* Easily define the melee weapon (default: skull).

* Optionally prevent friendly fire.

* Respawn time override

* Define starting frag/plasma grenades (default: 0 each).

* Works on any game type (if melee weapon is the oddball or flag, do not use on ctf or oddball).

* Object interactions with equipment, vehicles & weapons can
  be individually disabled or enabled for everyone or a defined team.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local Melee = {

    -- config starts --

    -- Sets the game score limit:
    -- Set to nil to disable custom score limit.
    -- Default: 25
    --
    score_limit = 25,

    -- Respawn time delay (in seconds):
    --
    respawn_time = 0,

    -- Melee weapon (index from objects table):
    --
    weapon = 12,

    -- When enabled, friendly fire will be blocked:
    --
    block_friendly_fire = true,

    -- Starting frag grenades:
    --
    frags = 0,

    -- Starting plasma grenades:
    --
    plasmas = 0,

    -- Game objects:
    -- Interaction with objects in this list can be individually disabled or enabled.
    -- Format: {tag type, tag name, enabled/disabled}.

    -- Disabling/Enabling:
    -- nil  =   enable for both teams
    -- 0    =   disable for both teams
    -- 1    =   enable for red team only
    -- 2    =   enable for blue team only
    -- If an object is disabled for both teams, it will not spawn (by design).
    --
    -- Note: Do not disable the melee object.
    --
    objects = {

        -- equipment:
        [1] = { "eqip", "powerups\\health pack", nil },
        [2] = { "eqip", "powerups\\over shield", nil },
        [3] = { "eqip", "powerups\\active camouflage", nil },
        [4] = { "eqip", "weapons\\frag grenade\\frag grenade", 0 },
        [5] = { "eqip", "weapons\\plasma grenade\\plasma grenade", 0 },

        -- vehicles:
        [6] = { "vehi", "vehicles\\ghost\\ghost_mp", 0 },
        [7] = { "vehi", "vehicles\\rwarthog\\rwarthog", 0 },
        [8] = { "vehi", "vehicles\\banshee\\banshee_mp", 0 },
        [9] = { "vehi", "vehicles\\warthog\\mp_warthog", 0 },
        [10] = { "vehi", "vehicles\\scorpion\\scorpion_mp", 0 },
        [11] = { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 0 },

        -- weapons:
        [12] = { "weap", "weapons\\ball\\ball", nil },
        [13] = { "weap", "weapons\\flag\\flag", 0 },
        [14] = { "weap", "weapons\\pistol\\pistol", 0 },
        [15] = { "weap", "weapons\\shotgun\\shotgun", 0 },
        [16] = { "weap", "weapons\\needler\\mp_needler", 0 },
        [17] = { "weap", "weapons\\flamethrower\\flamethrower", 0 },
        [18] = { "weap", "weapons\\plasma rifle\\plasma rifle", 0 },
        [19] = { "weap", "weapons\\sniper rifle\\sniper rifle", 0 },
        [20] = { "weap", "weapons\\plasma pistol\\plasma pistol", 0 },
        [21] = { "weap", "weapons\\plasma_cannon\\plasma_cannon", 0 },
        [22] = { "weap", "weapons\\assault rifle\\assault rifle", 0 },
        [23] = { "weap", "weapons\\rocket launcher\\rocket launcher", 0 },

        -- custom tags --
        -- Put non-stock (custom) tags here:

        --
    }
    -- config ends --
}

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    OnGameStart()
end

local function RegisterSAPPEvents(Register)

    if (Register) then
        register_callback(cb['EVENT_TICK'], "OnTick")
        register_callback(cb['EVENT_JOIN'], "OnJoin")
        register_callback(cb['EVENT_LEAVE'], "OnQuit")
        register_callback(cb['EVENT_SPAWN'], "OnSpawn")
        register_callback(cb["EVENT_DIE"], "DeathHandler")
        register_callback(cb["EVENT_WEAPON_DROP"], "OnWeaponDrop")
        register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
        register_callback(cb["EVENT_DAMAGE_APPLICATION"], "DeathHandler")
        return
    end

    unregister_callback(cb['EVENT_DIE'])
    unregister_callback(cb['EVENT_TICK'])
    unregister_callback(cb['EVENT_JOIN'])
    unregister_callback(cb['EVENT_LEAVE'])
    unregister_callback(cb['EVENT_SPAWN'])
    unregister_callback(cb['EVENT_WEAPON_DROP'])
    unregister_callback(cb['EVENT_OBJECT_SPAWN'])
    unregister_callback(cb['EVENT_DAMAGE_APPLICATION'])
end

-- Create (new) or delete (old) player array:
-- @param Ply (player index) [number]
-- @param Reset (reset players array for this player) [boolean]
--
function Melee:InitPlayer(Ply, Reset)

    if (not Reset) then
        self.players[Ply] = {
            -- Used to keep track of weapon assignments.
            -- They are destroyed when a player dies, quits or attempts to drop it.
            drones = {},

            -- Used to determine when to assign weapons.
            -- True when a player spawns or tries to drop their weapon.
            assign = false
        }
        return
    end

    -- Delete their weapons from the world:
    self:CleanUpDrones(Ply, false)

    -- clear array index for this player:
    self.players[Ply] = nil
end

local function GetTag(type, name)
    local tag = lookup_tag(type, name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function Melee:Init()

    self.players = { }
    self.melee_weapon = nil

    if (get_var(0, "$gt") ~= "n/a") then

        local object = self.objects[self.weapon]
        local weapon_id = GetTag(object[1], object[2])
        if (weapon_id) then

            self.melee_weapon = weapon_id

            execute_command("scorelimit " .. (self.score_limit or ""))

            self:GameObjects(false)

            for i = 1, 16 do
                if player_present(i) then
                    self:InitPlayer(i, false)
                end
            end

            RegisterSAPPEvents(true)

            return
        end
    end

    RegisterSAPPEvents(false)
end

-- This function is responsible for enabling/disabling game objects:
-- Applies to weapons, vehicles and equipment.
--
function Melee:GameObjects(State)

    if (not State) then
        State = "disable_object"

    else
        State = "enable_object"
    end

    -- Disable game objects:
    for _, v in pairs(self.objects) do
        if (v[3] ~= nil) then
            execute_command(State .. " '" .. v[2] .. "' " .. v[3])
        end
    end
end

-- This function is called when a player has connected:
-- @param Ply (player index) [number]
--
function OnJoin(Ply)
    Melee:InitPlayer(Ply, false)
end

-- This function is called when a player has disconnected:
-- @param Ply (player index) [number]
--
function OnQuit(Ply)
    Melee:InitPlayer(Ply, true)
end

-- This function is called once every 1/30th second (1 tick):
-- Used to assign weapons.
--
function Melee:GameTick()
    for i, player in pairs(self.players) do
        if (i) then

            if (player.assign) then

                local DyN = get_dynamic_player(i)
                if (DyN ~= 0 and player_alive(i)) then

                    player.assign = false

                    execute_command("nades " .. i .. " " .. self.frags .. " 1")
                    execute_command("nades " .. i .. " " .. self.plasmas .. " 2")

                    -- Spawn this object under the map initially:
                    local weapon = spawn_object("", "", 0, 0, -9999, 0, self.melee_weapon)

                    -- Store a copy of this weapon to the drones table:
                    table.insert(player.drones, { weapon = weapon, timer = 0, despawn = false })

                    -- Assign this weapon:
                    assign_weapon(weapon, i)
                end
            end
        end
    end
end

--
-- This function is called when a player has finished spawning:
-- @param Ply (player index) [number]
--
function OnSpawn(Ply)
    local player = Melee.players[Ply]
    if (player) then
        player.assign = true
    end
end

-- This function is called during event_die and event_damage_application.
-- @param Victim (Victim) [number]
-- @param Killer (Killer) [number]
-- @param MetaID (damage tag id) [number]
--
function Melee:DeathHandler(Victim, Killer, MetaID, Damage, _, _)

    local victim = tonumber(Victim)
    local v = self.players[victim]

    if (v) then

        -- event_damage_application --
        -- Block friendly fire:
        if (MetaID and self.block_friendly_fire) then
            local killer = tonumber(Killer)
            local v_team = get_var(Victim, "$team")
            local k_team = get_var(Killer, "$team")
            local friend_fire = (k_team == v_team and killer ~= victim)
            return (killer > 0 and friend_fire and true) or true, Damage * 10
        end

        -- event_die --
        -- destroy weapon from world:
        self:CleanUpDrones(victim, false)

        -- set respawn time:
        local Player = get_player(victim)
        if (Player ~= 0) then
            write_dword(Player + 0x2C, Melee.respawn_time * 33)
        end
    end
end

--
-- Deletes player weapon drones:
-- @param Victim (player index) [number]
-- @param AssignWeapon (trigger assign logic) [boolean]
--
function Melee:CleanUpDrones(Ply, Assign)
    local player = self.players[Ply]
    if (player) then
        for _, v in pairs(player.drones) do
            local object = get_object_memory(v.weapon)
            if (object ~= 0 and object ~= 0xFFFFFFF) then
                destroy_object(v.weapon)
            end
        end
        player.drones = {}
        player.assign = Assign
    end
end

function OnObjectSpawn(_, MapID, _, _)
    for _, v in pairs(Melee.objects) do
        if (MapID == GetTag(v[1], v[2]) and v[3] == 0) then
            return false
        end
    end
end

-- This function is called every time a player drops a weapon:
-- @param Ply (player index) [number]
--
function OnWeaponDrop(Ply)
    Melee:CleanUpDrones(Ply, true)
end

function DeathHandler(V, K, MID, D, _, _)
    return Melee:DeathHandler(V, K, MID, D, _, _)
end

function OnTick()
    return Melee:GameTick()
end

function OnGameStart()
    Melee:Init()
end

function OnScriptUnload()
    -- Re-enable all game objects:
    for _, v in pairs(Melee.objects) do
        execute_command("enable_object '" .. v[2] .. "' 0")
    end
end
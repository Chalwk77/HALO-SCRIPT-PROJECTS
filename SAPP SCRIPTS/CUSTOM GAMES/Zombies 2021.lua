--[[
--=====================================================================================================--
Script Name: Zombies (v1.19), for SAPP (PC & CE)

-- Introduction --
Players in zombies matches are split into two teams: Humans (red team) and Zombies (blue team).

When a human dies, they switch to the zombie team.
A human's goal is to remain alive (uninfected) until the end of the round, while a zombie's goal is to kill (infect) as many humans as possible.

When only one human remains, that human becomes the "Last Man Standing".
The Last Man Standing is given unique player traits; including a waypoint revealing their location to zombies, making survival an extreme challenge.

See more on traits in the config section.

The players who start a round as zombies are Alpha Zombies.
Alpha Zombies have unique player traits to distinguish them from standard zombies.

Standard Zombies are:
	* Humans who have been infected.
	* Players who joined after a game has already begun will get standard-zombie status.
	* Humans who commit suicide will get standard-zombie status.

Zombies have melee weapons at their disposal and are capable of killing humans in a single blow.
Humans are given short - and medium-range firearms.

* See the bottom of this script for recommended game type settings.

Please report any bugs and feedback on the page linked below (script changelogs are posted on this page).
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues/132

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local Zombies = {

    -- Time (in seconds) until a game begins:
    -- Default: 5
    --
    game_start_delay = 5,

    -- Number of players required to start the game:
    -- Default: 2
    --
    required_players = 2,

    -- The players who start a round as zombies are Alpha Zombies.
    -- The script will dynamically determine how many Alpha Zombies there should be
    -- based on how many players are online.
    -- Format: {min players, max players, zombie count}
    -- Example: { 13, 16, 4 } = if there are between 13-16 players, 4 of them will become alpha-z.
    zombie_count = {
        { 1, 4, 1 }, -- 1-4 players
        { 5, 8, 2 }, -- 5-8 players
        { 9, 12, 3 }, -- 9-12 players
        { 13, 16, 4 }, -- 13-16 players
    },

    -- When enabled, the script will broadcast a continuous message
    -- showing how many players are required to start the game.
    -- Default: true
    --
    show_not_enough_players_message = true,

    -- How often should the "not enough players" message appear (in seconds)?
    -- Default: 15
    --
    not_enough_players_message_frequency = 15,

    -- When enabled, chat will be cleared when showing the "not enough players" message.
    -- Default: false
    --
    clear_chat = false,

    -- Time (in seconds) until a human is selected to become a zombie:
    -- Default: 5
    --
    no_zombies_delay = 5,

    -- Human Team:
    -- Default: red
    --
    human_team = "red",

    -- Zombie Team:
    -- Default: blue
    --
    zombie_team = "blue",

    -- Zombie Curing:
    -- When enabled, a zombie needs X (cure_threshold) consecutive kills to become human again.
    -- Default: true
    --
    zombies_can_be_cured = true,

    -- Cure Threshold:
    -- Number of kills required to become a human again:
    -- Do not set this value to 1 or curing will not work.
    -- Default: 3
    --
    cure_threshold = 3,

    -- Regenerating Health (off by default):
    -- When enabled, the last man standing will have regenerating health (see attributes table).
    -- This feature is only practical if the zombie damage_multiplier is set to 1.
    -- Default: false
    --
    regenerating_health = false,

    -- Nav Marker (off by default):
    -- When enabled, the last man standing will have a nav marker above his head.
    -- Default: false
    --
    nav_marker = false,

    -- Player trait tables:
    --
    attributes = {

        --[[

            ------------------------
            Notes on variables --
            ------------------------
            *   speed:                  Set to 0 to use map settings (1 = normal speed).
            *   health:                 Units of health range from 0 to 99999, (1 = normal health).
                                        Last Man has optional Health Regeneration that regenerates at increments of 0.0005 units per 30 ticks.

            *   respawn_time:           Range from 0-999 (in seconds).
            *   weapons:                Leave the array blank to use default weapon sets.
            *   damage_multiplier:      Units of damage range from 0-10.
            *   nav_marker:             A NAV marker will appear above the last man standing's head.
            *   camo:                   Alpha-Zombies and Standard Zombies have optional Crouch Camo traits.
            *   grenades:               Allows you to define the starting number of frags & plasmas.
                                        Format: {frags [number], plasmas [number]}
                                        Example: {1, 3} = 1 frag, 3 plasmas

            --=====================================================================================================================--
            -- NOTES --

            Weapons:
            You can define up to four weapon tag names (see example below):

            weapons = { "weapons\\flag\\flag", "weapons\\pistol\\pistol", "weapons\\shotgun\\shotgun", "weapons\\ball\\ball" }
            See the "weapons" section of the "objects" table below (on or near line 311) for a full list of weapon tags.

            Nav Markers:
            If the Nav Marker attribute is enabled, the kill-in-order game type flag must be set to YES.
            The objectives indicator flag must also be set to NAV POINTS.

            Grenade Attributes:
            If you want to use game type settings for a specific grenade,
            set the grenade value to nil. For example: {1, nil}
            In the above example, the script will override the value for frags (by setting it to 1) but plasmas will use game mode settings.

            IMPORTANT:
            Zombies will only be able to use their grenades if they have been assigned a weapon other than the oddball or flag.
            This is a limitation with Halo, unfortunately.
            --=====================================================================================================================--

        --]]

        ["Alpha Zombies"] = {
            speed = 1.5,
            health = 2,
            camo = true,
            respawn_time = 1.5,
            grenades = { 0, 2 },
            damage_multiplier = 10,
            weapons = { 'weapons\\plasma rifle\\plasma rifle' }
        },

        ["Standard Zombies"] = {
            speed = 1.4,
            health = 1,
            camo = false,
            respawn_time = 2.5,
            grenades = { 0, 0 },
            damage_multiplier = 10,
            weapons = { "weapons\\ball\\ball" }
        },

        ["Humans"] = {
            speed = 1.2,
            health = 1,
            weapons = {
                "weapons\\pistol\\pistol",
                "weapons\\shotgun\\shotgun",
                "weapons\\assault rifle\\assault rifle"
            },
            respawn_time = 3,
            grenades = { 2, 2 },
            damage_multiplier = 1
        },

        ["Last Man Standing"] = {
            speed = 1.5,
            weapons = { },
            respawn_time = 1,
            grenades = { 4, 4 },
            damage_multiplier = 2,
            health = {
                base = 1,
                increment = 0.0005
            }
        }
    },

    -- Game messages:
    --
    messages = {

        -- Continuous message announced when there aren't enough players:
        -- Variables:        $current (current players online [number])
        --                   $required (number of required players)
        --
        not_enough_players = "$current/$required players needed to start the game",

        -- Pre-Game message:
        -- Variables:        $time (time remaining until game begins)
        --                   $s placeholder to pluralize the word "seconds" (if $time is >1)
        --
        pre_game_message = "Game will begin in $time second$s",

        -- End of Game message:
        -- Variables:        $team (team name [string])
        --
        end_of_game = "The $team team won!",

        -- Game has Begun:
        --
        on_game_begin = {
            "You're a Human! (Eres un humano)",
            "You're an Alpha-Zombie! (¡Eres un Alpha zombi!)"
        },

        -- Message sent to new standard zombies:
        --
        new_standard_zombie = "You're a Standard Zombie! (Eres un zombi estándar)",

        -- Message announced when you kill a human:
        -- Variables:        $victim (victim name)
        --                   $killer (killer name)
        --
        on_zombify = "$victim was zombified (zombificado) by $killer",

        -- Last Man Alive message:
        -- Variables:        $name (last man standing name)
        --
        on_last_man = "$name is the Last Human Alive! (último hombre vivo)",

        -- Message announced when there are no zombies:
        -- Variables:        $time (time remaining until a random human is chosen to become a zombie)
        --                   $s placeholder to pluralize the word "seconds" (if $time is >1)
        --
        no_zombies = "No Zombies! Switching random human in $time second$s",

        -- Message announced when a human is selected to become a zombie:
        -- Variables:        $name (name of human who was switched to zombie team)
        --
        no_zombies_switch = "$name was switched to the Zombie team",

        -- Message announced when a zombie has been cured:
        -- Variables:        $name (name of human who was cured)
        --
        on_cure = "$name was cured! ($name estaba curado)",

        -- Message announced when someone commits suicide:
        -- Variables:        $name (name of person who died)
        --
        suicide = "$victim committed suicide (suicidio)",

        -- Message announced when PvP event occurs:
        -- Variables:        $victim (victim name)
        --                   $killer (killer name)
        --
        pvp = "$victim was killed by $killer",

        -- Message announced when someone dies by unknown means:
        -- Variables:        $victim (victim name)
        --
        generic_death = "$victim died (murió)",

        -- Message announced when someone dies by guardians:
        -- Variables:        $victim (victim name)
        -- Variables:        $killer (killer name)
        --
        guardians_death = "$victim and $killer were killed by the guardians"
    },

    --
    -- Game objects to disable:

    -- Format: {tag name, team}
    -- Teams: 0 = both, 1 = red, 2 = blue

    -- To enable an object for both teams, prefix the line with a double-hyphen (--).
    -- For example: -- { 'powerups\\health pack', 2 }
    --
    objects = {

        -- vehicles:
        --
        { 'vehicles\\ghost\\ghost_mp', 2 },
        { 'vehicles\\rwarthog\\rwarthog', 2 },
        { 'vehicles\\warthog\\mp_warthog', 2 },
        { 'vehicles\\banshee\\banshee_mp', 2 },
        { 'vehicles\\scorpion\\scorpion_mp', 2 },
        { 'vehicles\\c gun turret\\c gun turret_mp', 2 },

        -- weapons:
        --
        { 'weapons\\flag\\flag', 2 },
        { 'weapons\\ball\\ball', 2 },
        { 'weapons\\pistol\\pistol', 2 },
        { 'weapons\\shotgun\\shotgun', 2 },
        { 'weapons\\needler\\mp_needler', 2 },
        { 'weapons\\plasma rifle\\plasma rifle', 2 },
        { 'weapons\\flamethrower\\flamethrower', 2 },
        { 'weapons\\sniper rifle\\sniper rifle', 2 },
        { 'weapons\\plasma_cannon\\plasma_cannon', 2 },
        { 'weapons\\plasma pistol\\plasma pistol', 2 },
        { 'weapons\\assault rifle\\assault rifle', 2 },
        { 'weapons\\gravity rifle\\gravity rifle', 2 },
        { 'weapons\\rocket launcher\\rocket launcher', 2 },

        -- equipment:
        --
        -- { 'powerups\\health pack', 0 },
        { 'powerups\\over shield', 2 },
        { 'powerups\\active camouflage', 2 },
        { 'weapons\\frag grenade\\frag grenade', 2 },
        { 'weapons\\plasma grenade\\plasma grenade', 2 },
    },

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    server_prefix = "**SAPP**",
    --

    -- Script errors (if any) will be logged to this file:
    error_file = "Zombies (errors).log",

    -- config ends --

    -- DO NOT TOUCH BELOW THIS POINT --
    script_version = 1.19
    --
}

--
-- do not touch anything below this point --
--

api_version = "1.12.0.0"

-- This function registers needed event callbacks:
--
function OnScriptLoad()

    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "DeathHandler")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_WEAPON_DROP"], "OnWeaponDrop")
    register_callback(cb["EVENT_WEAPON_PICKUP"], "OnWeaponPickup")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "DeathHandler")

    -- Disable default server messages:
    DisableDeathMessages()

    if (get_var(0, "$gt") ~= "n/a") then
        Zombies.health_increment = Zombies.attributes["Last Man Standing"].health.increment
    end

    -- Set up game base game parameters:
    Zombies:Init()
end

function OnScriptUnload()
    if (get_var(0, "$gt") ~= "n/a") then
        execute_command("sv_map_reset")
    end
    EnableDeathMessages()
end

-- This function returns the memory address [int] of a tag in the map using
-- the tag’s class and path.
local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

-- Sets up pre-game parameters:
--
function Zombies:Init()

    self.players = { }
    self.last_man = nil
    self.switching = false
    self.game_started = false
    self.block_death_messages = true

    self.timers = {

        ["Not Enough Players"] = {
            timer = 0,
            init = false
        },

        ["Pre-Game Countdown"] = {
            timer = 0,
            init = false,
            enough_players = false,
            delay = self.game_start_delay + 1
        },

        ["No Zombies"] = {
            timer = 0,
            init = false,
            delay = self.no_zombies_delay + 1
        }
    }

    if (get_var(0, "$gt") ~= "n/a") then

        self.fall_damage = GetTag("jpt!", "globals\\falling")
        self.distance_damage = GetTag("jpt!", "globals\\distance")

        -- Enable game objects:
        self:GameObjects(false)

        -- Init new players array for each player:
        for i = 1, 16 do
            if player_present(i) then
                self:InitPlayer(i, false)
                self:GameStartCheck(i, false)
            end
        end
    end
end

-- Create (new) or delete (old) player array:
-- @param Ply (player index) [number]
-- @param Reset (reset players array for this player) [boolean]
--
function Zombies:InitPlayer(Ply, Reset)

    Ply = tonumber(Ply)

    if (not Reset) then
        self.players[Ply] = {

            -- Used to track applied damage tag ids (meta id)
            -- to distinguish fall damage from distance damage.
            meta_id = 0,

            -- Used to keep track of zombie weapon objects.
            -- They are deleted from the world when a zombie dies/quits/cured.
            drones = {},

            -- Player alpha-zombie status (false initially):
            alpha = false,

            -- Used to determine when to assign weapons.
            -- True when a player spawns or when a zombie tries to drop their weapon.
            assign = false,

            -- One-time save of their name so we don't have to keep calling get_var(Ply, "$name").
            name = get_var(Ply, "$name")
        }

        return
    end

    -- Delete their weapons from the world:
    self:CleanUpDrones(Ply)

    -- Delete this player array:
    self.players[Ply] = nil
end

-- Used to clear a players rcon console:
-- @param Ply (player index) [number]
--
local function ClearConsole(Ply)
    for _ = 1, 25 do
        rprint(Ply, " ")
    end
end

-- Used to pluralize a string based on whether n>0.
-- @param n (time remaining) [number]
-- @return char n [string]
local function Plural(n)
    return (n > 0 and "s") or ""
end

-- Starts a given timer:
-- @param t (timer table) [table]
function Zombies:StartTimer(t, Callback, Delay)
    t.init = true
    t.timer = 0
    timer(1000 * Delay, Callback)
end

-- Stops a given timer:
-- @param t (timer table) [table]
function Zombies:StopTimer(t)
    t.init = false
    t.timer = 0
end

-- Game Start Check logic:
-- @param Ply (player index) [number]
-- @param Deduct (deduct 1 from player count) [boolean]
--
function Zombies:GameStartCheck(Ply, Deduct)

    local player_count = tonumber(get_var(0, "$pn"))
    if (Deduct) then
        -- Server var $pn does not update immediately when someone quits.
        -- So we have to deduct 1 from the count manually:
        player_count = player_count - 1
    end

    local countdown1 = self.timers["Pre-Game Countdown"]
    local countdown2 = self.timers["Not Enough Players"]
    local countdown3 = self.timers["No Zombies"]
    local enough_players = (player_count >= self.required_players)
    local show_countdown = (enough_players and not countdown1.init and not self.game_started)

    -- Show pre-game countdown or "not enough players" message:
    if (not enough_players) then
        self:StopTimer(countdown1) -- in case it was running
        if (self.show_not_enough_players_message) then
            local delay = self.not_enough_players_message_frequency
            self:StartTimer(countdown2, "NotEnoughPlayers", delay)
        end
    elseif (show_countdown) then
        self:StartTimer(countdown1, "StartPreGameTimer", 1)
        self:StopTimer(countdown2)
        self:StopTimer(countdown3)
    elseif (self.game_started) then

        -- Game has already begun.
        -- Switch this player (Ply) to zombie team:
        local team = get_var(Ply, "$team")
        if (team ~= self.zombie_team) then
            self:SwitchTeam(Ply, self.zombie_team)
        end

        -- Stop No Zombies timer (in case it was running when this player joined):
        if (countdown3.init) then
            self:StopTimer(countdown3)
        end
    end
end

-- This function returns the number of players in each team:
-- @return humans [number], zombies [number]
--
function Zombies:GetTeamCounts()

    local human_team = self.human_team
    local zombie_team = self.zombie_team

    local humans, zombies
    if (human_team == "red" and zombie_team == "blue") then
        humans = get_var(0, "$reds")
        zombies = get_var(0, "$blues")
    elseif (human_team == "blue" and zombie_team == "red") then
        humans = get_var(0, "$blues")
        zombies = get_var(0, "$reds")
    end

    return tonumber(humans), tonumber(zombies)
end

-- Returns the appropriate weapon table for a given player:
-- @param Ply (player index) [number]
-- @return, weapon table [table]
--
function Zombies:GetWeaponTable(Ply)
    local team = get_var(Ply, "$team")
    if (team == self.zombie_team) then
        local alpha = self:IsAlphaZombie(Ply)
        if (alpha) then
            return self.attributes["Alpha Zombies"].weapons
        else
            return self.attributes["Standard Zombies"].weapons
        end
    elseif (team == self.human_team) then
        if (self.last_man == nil) then
            return self.attributes["Humans"].weapons
        else
            return self.attributes["Last Man Standing"].weapons
        end
    end
end

-- This function is responsible for increment player health:
-- Only applies to the Last Man Standing
-- @param Ply (player index) [number]
--
function Zombies:HealthRegeneration(Ply)
    if (self.regenerating_health and self.last_man == Ply) then
        local DyN = get_dynamic_player(Ply)
        if (DyN ~= 0 and player_alive(Ply)) then
            local health = read_float(DyN + 0xE0)
            if (health < 1) then
                write_float(DyN + 0xE0, health + self.health_increment)
            end
        end
    end
end

-- This function is responsible for making a zombie go invisible when they crouch:
-- @param Ply (player index) [number]
--
function Zombies:CrouchCamo(Ply)
    if (get_var(Ply, "$team") == self.zombie_team) then

        -- Check if zombie is allowed to use camo:
        local camo
        local alpha = self:IsAlphaZombie(Ply)
        if (alpha) then
            camo = self.attributes["Alpha Zombies"].camo
        else
            camo = self.attributes["Standard Zombies"].camo
        end

        -- Apply Camo:
        if (camo) then
            local DyN = get_dynamic_player(Ply)
            if (DyN ~= 0 and player_alive(Ply)) then
                local couching = read_float(DyN + 0x50C)
                if (couching == 1) then
                    execute_command("camo " .. Ply .. " 1")
                end
            end
        end
    end
end

-- Removes Ammo and Grenades from zombie weapons:
--
local function RemoveAmmo(Ply)
    if (Zombies.game_started) then
        local team = get_var(Ply, "$team")
        if (team == Zombies.zombie_team) then
            local DyN = get_dynamic_player(Ply)
            if (DyN ~= 0) then
                for i = 0, 3 do
                    local WeaponID = read_dword(DyN + 0x2F8 + (i * 4))
                    if (WeaponID ~= 0xFFFFFFFF) then
                        local WeaponObject = get_object_memory(WeaponID)
                        if (WeaponObject ~= 0) then
                            write_word(WeaponObject + 0x2B8, 0)
                            write_word(WeaponObject + 0x2B6, 0)
                            execute_command_sequence("w8 1; battery " .. Ply .. " 0 " .. i)
                            sync_ammo(WeaponID)
                        end
                    end
                end
            end
        end
    end
end

-- This function is called once every 1/30th second (1 tick):
-- Used for weapon assignments, health regeneration and Last-Man Nav Makers.
--
function Zombies:GameTick()

    self:SetNavMarker()

    for i, player in pairs(self.players) do
        if (i and self.game_started) then

            for k, drone in pairs(player.drones) do
                if (k and drone.despawn) and (not player_alive(i)) then
                    local object = get_object_memory(drone.weapon)
                    if (object ~= 0) then
                        --drone.timer = drone.timer + 1 / 30
                        --write_vector3d(object + 0x5C, 0, 0, -9999)
                        --if (drone.timer >= 5) then
                        destroy_object(drone.weapon)
                        --end
                    else
                        player.drones[k] = nil
                    end
                end
            end

            self:CrouchCamo(i)
            self:HealthRegeneration(i)

            if (player.assign) then
                local DyN = get_dynamic_player(i)
                if (DyN ~= 0 and player_alive(i)) then

                    player.assign = false

                    -- Get the appropriate weapon array for this player:
                    -- If the weapons array is empty, the player will receive default weapons.
                    local weapons = self:GetWeaponTable(i)
                    if (#weapons > 0) then

                        -- Delete this players inventory:
                        execute_command("wdel " .. i)

                        -- Assign Weapons:
                        for slot, v in pairs(weapons) do

                            -- Assign primary & secondary weapons:
                            if (slot == 1 or slot == 2) then

                                -- Spawn the weapon:
                                local weapon = spawn_object("weap", v, 0, 0, -9999)

                                -- Store a copy of this weapon to the drones table:
                                table.insert(player.drones, { weapon = weapon, timer = 0, despawn = false })

                                -- Assign this weapon:
                                assign_weapon(weapon, i)

                                -- Assign tertiary & quaternary weapons:
                            elseif (slot >= 3) then
                                timer(250, "DelaySecQuat", i, v)
                                --
                                -- Technical note:
                                -- It's important that we delay the logic responsible for assigning tertiary and quaternary weapon
                                -- assignments otherwise they will fall to the ground and never be assigned.
                                --
                            end
                        end
                    end
                end
            end
        end
    end
end

--
-- Deletes player weapon drones:
-- @param Victim (player index) [number]
-- @param Assign (assign new weapons) [boolean]
--
function Zombies:CleanUpDrones(Ply, Assign)
    local team = get_var(Ply, "$team")
    if (team == self.zombie_team) then
        if (self.players[Ply]) then
            local drones = self.players[Ply].drones
            for _, v in pairs(drones) do
                local object = get_object_memory(v.weapon)
                if (object ~= 0 and object ~= 0xFFFFFFF) then
                    destroy_object(v.weapon)
                end
            end
            drones = {}
            if (Assign) then
                self.players[Ply].assign = true
            end
        end
    end
end

-- This function is responsible for enabling/disabling game objects:
-- Applies to weapons, vehicles and equipment.
--
function Zombies:GameObjects(State)

    if (State) then
        State = "disable_object"
    else
        State = "enable_object"
    end

    -- Disable game objects:
    for _, v in pairs(self.objects) do
        execute_command(State .. " '" .. v[1] .. "' " .. v[2])
    end
end

--
-- Returns the team type (red = human, blue = zombie):
-- @param Ply (player index) [number]
-- @return player team type [string]
function Zombies:GetTeamType(Ply)
    local team = get_var(Ply, "$team")
    return (team == self.human_team and "human") or "zombie"
end

-- Fisher-yates shuffle algorithm:
--
local function shuffle(t)
    for i = #t, 2, -1 do
        local j = rand(i) + 1
        t[i], t[j] = t[j], t[i]
    end
    return t
end

-- Shows the pre-game countdown message,
-- resets the map and sorts players into teams:
--
function Zombies:StartPreGameTimer()

    local countdown = self.timers["Pre-Game Countdown"]
    if (countdown.init) then
        countdown.timer = countdown.timer + 1

        local time_remaining = (countdown.delay - countdown.timer)
        if (time_remaining <= 0) then

            -- Stop the timer:
            self:StopTimer(countdown)

            -- Reset the map:
            execute_command("sv_map_reset")

            self.game_started = true

            -- Disable game objects:
            self:GameObjects(true)

            local players = { }
            for i = 1, 16 do
                if player_present(i) and self.players[i] then
                    table.insert(players, i)
                end
            end
            players = shuffle(players)

            local zombies = 1
            for _, v in pairs(self.zombie_count) do
                local min, max, count = v[1], v[2], v[3]
                if (#players >= min and #players <= max) then
                    zombies = count
                end
            end

            for i, id in pairs(players) do
                if (i > zombies) then
                    -- Set player to human team (only if they're not already on human team):
                    self:SwitchTeam(id, self.human_team)

                    -- Tell player what team they are on:
                    self:Broadcast(id, self.messages.on_game_begin[1])
                else
                    -- Set zombie type to Alpha-Zombie:
                    self.players[id].alpha = true

                    -- Set player to zombie team (only if they're not already on zombie team):
                    self:SwitchTeam(id, self.zombie_team)

                    -- Tell player what team they are on:
                    self:Broadcast(id, self.messages.on_game_begin[2])
                end
            end

            self.block_death_messages = false
            self:GamePhaseCheck(nil, nil)
            return false
        end

        -- Show the pre-game message:
        --
        local msg = self.messages.pre_game_message
        msg = msg:gsub("$time", time_remaining):gsub("$s", Plural(time_remaining))
        self:Broadcast(nil, msg)
    end

    return countdown.init
end

-- Broadcasts self.messages.not_enough_players:
--
function Zombies:NotEnoughPlayers()
    local countdown = self.timers["Not Enough Players"]
    if (countdown.init) then
        for i = 1, 16 do
            if player_present(i) then
                local msg = self.messages.not_enough_players
                msg = msg:gsub("$current", get_var(0, "$pn"))
                msg = msg:gsub("$required", self.required_players)
                if (self.clear_chat) then
                    ClearConsole(i)
                end
                rprint(i, msg)
            end
        end
    end
    return (countdown.init)
end

-- This function chooses a random human to become a zombie
-- when there are no zombies left:
--
function Zombies:SwitchHumanToZombie()

    local countdown = self.timers["No Zombies"]
    if (countdown.init) then
        countdown.timer = countdown.timer + 1

        local time_remaining = (countdown.delay - countdown.timer)
        if (time_remaining <= 0) then

            self:StopTimer(countdown)

            -- Save all players on the human team to the humans array:
            local humans = {}
            for i = 1, 16 do
                local team = get_var(i, "$team")
                if (team == self.human_team) then
                    humans[#humans + 1] = i
                end
            end

            --Pick a random human (from humans array) to become the zombie:
            math.randomseed(os.time())
            math.random();
            math.random();
            math.random();
            local new_zombie = humans[math.random(1, #humans)]
            local name = self.players[new_zombie].name

            -- Tell player what team they're on:
            --
            local msg = self.messages.no_zombies_switch
            msg = msg:gsub("$name", name)
            self:Broadcast(nil, msg)

            -- Set zombie type to Alpha-Zombie:
            self.players[new_zombie].alpha = true

            -- Switch them:
            self:SwitchTeam(new_zombie, self.zombie_team)

            -- Check game phase:
            self:GamePhaseCheck(nil, nil)

            return false
        end

        local msg = self.messages.no_zombies
        msg = msg:gsub("$time", time_remaining):gsub("$s", Plural(time_remaining))
        self:Broadcast(nil, msg)
    end

    return countdown.init
end

-- This function sets a nav marker above the Last Man Standing's head:
--
function Zombies:SetNavMarker()
    if (self.nav_marker and self.game_started) then
        for i, _ in pairs(self.players) do
            -- Get static memory address of each player:
            local p1 = get_player(i)
            if (p1 ~= 0) then
                -- Set slayer target indicator to the last man:
                if (self.last_man ~= nil and i ~= self.last_man) and player_alive(i) then
                    write_word(p1 + 0x88, to_real_index(self.last_man))
                else
                    -- Set slayer target indicator to themselves:
                    write_word(p1 + 0x88, to_real_index(i))
                end
            end
        end
    end
end

-- Used to check if someone is an Alpha Zombie:
-- @return [boolean]
--
function Zombies:IsAlphaZombie(Ply)
    return self.players[Ply].alpha
end

-- @param Ply (player index) [number]
-- @param Team (new team) [string]
function Zombies:SwitchTeam(Ply, Team)
    self.switching = true
    execute_command("st " .. Ply .. " " .. Team)
end

-- This function ends the game:
-- @param Team (player team) [string]
function Zombies:EndTheGame(Team)
    Team = Team or ""
    local msg = self.messages.end_of_game
    self:Broadcast(nil, msg:gsub("$team", Team))
    execute_command("sv_map_next")
end

--
-- Assigns tertiary & quaternary weapons:
-- Stores a copy of the weapon object to a table called drones.
--
-- @param Ply (player index) [number]
-- @param Tag (weapon tag type) [string]
-- @param x,y,z (three 32-bit floating point numbers (player coordinates)) [float]
--
function DelaySecQuat(Ply, Tag)
    Ply = tonumber(Ply)
    local weapon = spawn_object("weap", Tag, 0, 0, -9999)
    local drones = Zombies.players[Ply].drones
    table.insert(drones, { weapon = weapon, timer = 0, despawn = false })
    assign_weapon(weapon, Ply)
end

-- This function:
-- .Checks if we need to end the game.
-- .Sets the last man alive.
-- .Switches random human to zombie team when there are no zombies.
--
-- @param Ply (player index) [number]
-- @param PlayerCount (total number of players) [number]
function Zombies:GamePhaseCheck(Ply, PlayerCount)

    -- Returns the number of humans and zombies:
    local humans, zombies = self:GetTeamCounts()

    -- Returns the total player count:
    local player_count = (PlayerCount or tonumber(get_var(0, "$pn")))
    local team = (Ply ~= nil and get_var(Ply, "$team")) or ""
    if (team == self.human_team) then
        humans = humans - 1
    elseif (team == self.zombie_team) then
        zombies = zombies - 1
    end

    -- Check for (and set) last man alive:
    if (humans == 1 and zombies > 0) then

        for i = 1, 16 do
            if player_present(i) then
                local last_man_team = get_var(i, "$team")
                if (last_man_team == self.human_team and not self.last_man) then
                    if (self.players[i]) then
                        self.last_man = i
                        local name = self.players[i].name
                        local msg = self.messages.on_last_man
                        self:Broadcast(nil, msg:gsub("$name", name))
                        self:SetAttributes(i)
                    end
                end
            end
        end

        -- Announce zombie team won:
    elseif (humans == 0 and zombies >= 1) then
        self:EndTheGame("Zombie")

        -- One player remains | end the game:
    elseif (player_count == 1 and Ply ~= nil) then

        for i = 1, 16 do
            if (i ~= Ply and player_present(i)) then
                local team_type = self:GetTeamType(i)
                self:EndTheGame(team_type)
            end
        end

        -- No zombies left | Select random player to become zombie:
    elseif (zombies <= 0 and humans >= 1) then
        local countdown = self.timers["No Zombies"]
        self:StartTimer(countdown, "SwitchHumanToZombie", 1)
    end
end

-- This function cures a zombie when they have >= self.cure_threshold kills:
-- @param Ply (player index) [number]
--
function Zombies:CureZombie(Ply)
    if (self.cure_threshold > 1 and self.players[Ply] ~= nil) then
        local streak = tonumber(get_var(Ply, "$streak"))
        if (streak >= self.cure_threshold) then

            self:DespawnWeapons(Ply)

            -- Switch zombie to the human team:
            self:SwitchTeam(Ply, self.human_team)

            -- Announce that this player has been cured:
            local msg = self.messages.on_cure
            local name = self.players[Ply].name
            msg = msg:gsub("$name", name)

            self:Broadcast(nil, msg)
        end
    end
end

-- Announces suicide messages:
-- @param victim_name (player index) [number]
--
local function AnnounceSuicide(victim)
    local msg = Zombies.messages.suicide
    msg = msg:gsub("$victim", victim)
    Zombies:Broadcast(nil, msg)
end

-- Announces pvp messages:
-- @param victim_name (victim index) [number]
-- @param killer_name (killer index) [number]
--
local function AnnouncePvP(victim, killer)
    local msg = Zombies.messages.pvp
    msg = msg:gsub("$victim", victim)
    msg = msg:gsub("$killer", killer)
    Zombies:Broadcast(nil, msg)
end

-- Announces generic death messages:
-- @param victim_name (player index) [number]
--
local function AnnounceGenericDeath(victim)
    local msg = Zombies.messages.generic_death
    msg = msg:gsub("$victim", victim)
    Zombies:Broadcast(nil, msg)
end

-- Announces guardians:
-- @param victim_name (player index) [number]
--
local function AnnounceGuardians(victim, killer)
    local msg = Zombies.messages.guardians_death
    msg = msg:gsub("$victim", victim)
    msg = msg:gsub("$killer", killer)
    Zombies:Broadcast(nil, msg)
end

local function AnnounceZombify(victim, killer)
    local msg = Zombies.messages.on_zombify
    msg = msg:gsub("$victim", victim)
    msg = msg:gsub("$killer", killer)
    Zombies:Broadcast(nil, msg)
end

-- This function returns the relevant respawn time for this player:
-- @param Ply (player index) [number]
-- @param return (respawn time) [number]
--
function Zombies:GetRespawnTime(Ply)
    local time
    local team = get_var(Ply, "$team")
    if (team == self.zombie_team) then
        local alpha = self:IsAlphaZombie(Ply)
        if (alpha) then
            time = self.attributes["Alpha Zombies"].respawn_time
        else
            time = self.attributes["Standard Zombies"].respawn_time
        end
    elseif (team == self.human_team) then
        time = self.attributes["Humans"].respawn_time
        if (self.last_man == Ply) then
            time = self.attributes["Last Man Standing"].respawn_time
        end
    end
    return time
end

-- This function sets this players speed:
-- @param Ply (player index) [number]
-- @param Instant (affect immediately) [boolean]
--
function Zombies:SetSpeed(Ply)
    local speed
    local team = get_var(Ply, "$team")
    if (team == self.zombie_team) then
        local alpha = self:IsAlphaZombie(Ply)
        if (alpha) then
            speed = self.attributes["Alpha Zombies"].speed
        else
            speed = self.attributes["Standard Zombies"].speed
        end
    elseif (team == self.human_team) then
        speed = self.attributes["Humans"].speed
        if (self.last_man == Ply) then
            speed = self.attributes["Last Man Standing"].speed
        end
    end
    if (speed ~= 0) then
        execute_command_sequence("w8 1;s " .. Ply .. " " .. speed)
    end
end

-- This function sets this players health:
-- @param Ply (player index) [number]
--
function Zombies:SetHealth(Ply)
    local health
    local team = get_var(Ply, "$team")
    if (team == self.zombie_team) then
        local alpha = self:IsAlphaZombie(Ply)
        if (alpha) then
            health = self.attributes["Alpha Zombies"].health
        else
            health = self.attributes["Standard Zombies"].health
        end
    elseif (team == self.human_team) then
        health = self.attributes["Humans"].health
        if (self.last_man == Ply) then
            health = self.attributes["Last Man Standing"].health.base
        end
    end
    if (health ~= 0) then
        execute_command_sequence("w8 1;hp " .. Ply .. " " .. health)
    end
end

-- Sets player grenades (frags/plasmas):
-- @param Ply (player index) [number]
--
function Zombies:SetGrenades(Ply)
    local grenades
    local team = get_var(Ply, "$team")
    if (team == self.zombie_team) then
        local alpha = self:IsAlphaZombie(Ply)
        if (alpha) then
            grenades = self.attributes["Alpha Zombies"].grenades
        else
            grenades = self.attributes["Standard Zombies"].grenades
        end
    elseif (team == self.human_team) then
        if (Ply ~= self.last_man) then
            grenades = self.attributes["Humans"].grenades
        else
            grenades = self.attributes["Last Man Standing"].grenades
        end
    end
    if (grenades[1] ~= nil) then
        execute_command("nades " .. Ply .. " " .. grenades[1] .. " 1")
    end
    if (grenades[2] ~= nil) then
        execute_command("nades " .. Ply .. " " .. grenades[2] .. " 2")
    end
end

--
-- This function Sets player attributes:
-- @param Ply (player index) [number]
--
function Zombies:SetAttributes(Ply)

    if (self.game_started) then

        local team = get_var(Ply, "$team")
        if (team == self.zombie_team) then
            local alpha = self:IsAlphaZombie(Ply)
            if (not alpha) then
                self:Broadcast(Ply, self.messages.new_standard_zombie)
            end
        end

        if (player_alive(Ply)) then
            -- Set Player Health:
            self:SetHealth(Ply)

            -- Set Player Speed:
            self:SetSpeed(Ply)

            -- Set Grenades:
            self:SetGrenades(Ply)
        end
    end
end

function Zombies:DespawnWeapons(Ply)
    local drones = self.players[Ply].drones
    for _, weapon in pairs(drones) do
        weapon.despawn = true
    end
end

--
-- This function broadcasts a custom server message:
-- @param Msg (message) [string]
--
function Zombies:Broadcast(Ply, Msg)
    execute_command("msg_prefix \"\"")
    if (Ply) then
        say(Ply, Msg)
    else
        say_all(Msg)
    end
    execute_command("msg_prefix \" " .. self.server_prefix .. "\"")
end

local function Falling(MetaID)
    if (MetaID == Zombies.fall_damage or MetaID == Zombies.distance_damage) then
        return true
    end
    return false
end

local function DeathSwitch(Victim, Killer)
    -- Switch victim to the zombie team:
    Zombies:SwitchTeam(Victim, Zombies.zombie_team)

    -- Set zombie type to Standard-Zombie:
    Zombies.players[Victim].alpha = false

    -- Check if we need to cure this zombie:
    if (Killer and Zombies.players[Killer]) then
        Zombies:CureZombie(Killer)
    end

    -- Check game phase:
    Zombies:GamePhaseCheck(nil, nil)
end

-- Set respawn time:
--
local function SetRespawn(Ply)
    if (Zombies.game_started) then
        local time = Zombies:GetRespawnTime(Ply)
        local Player = get_player(Ply)
        if (Player ~= 0) then
            write_dword(Player + 0x2C, time * 33)
        end
    end
end

-- This function is called during event_die and event_damage_application.
-- @param Ply (Victim) [number]
-- @param Causer (Killer) [number]
-- @param MetaID (damage tag id) [number]
-- @param Damage (applied damage %) [number]
--
function Zombies:DeathHandler(Victim, Killer, MetaID, Damage, _, _)

    local victim = tonumber(Victim)
    local killer = tonumber(Killer)

    local v_team = get_var(Victim, "$team")
    local c_team = get_var(Killer, "$team")

    local v = self.players[victim]
    local k = self.players[killer]

    if (v) then

        -- event_damage_application:
        if (MetaID) then

            v.meta_id = MetaID

            if (killer > 0) then

                local friendly_fire = (c_team == v_team and killer ~= victim)

                -- Block friendly fire:
                if (friendly_fire) then
                    return false

                    -- Multiply units of damage by the appropriate damage multiplier property:
                    -- zombie vs human:
                elseif (c_team == self.zombie_team) then
                    local alpha = self:IsAlphaZombie(killer)
                    if (alpha) then
                        return true, Damage * self.attributes["Alpha Zombies"].damage_multiplier
                    else
                        return true, Damage * self.attributes["Standard Zombies"].damage_multiplier
                    end
                    -- human vs zombie:
                elseif (c_team == self.human_team) then
                    if (killer ~= self.last_man) then
                        return true, Damage * self.attributes["Humans"].damage_multiplier
                    else
                        return true, Damage * self.attributes["Last Man Standing"].damage_multiplier
                    end
                end
            end
            return true
        end

        SetRespawn(victim)

        -- event_die:
        if (not self.block_death_messages and self.game_started) then

            local server = (killer == -1)
            local squashed = (killer == 0)
            local guardians = (v and k and killer == nil)
            local suicide = (v and killer == victim)
            local falling = Falling(v.meta_id)
            local pvp = (killer > 0 and killer ~= victim)

            if (pvp) then

                -- zombie vs human:
                if (v_team == self.human_team) then

                    -- If the last man alive was killed by someone who is about to be cured,
                    -- reset their last-man status:
                    if (self.last_man == victim) then
                        self.last_man = nil
                    end

                    DeathSwitch(victim, killer)
                    AnnounceZombify(v.name, k.name)

                    -- human vs zombie:
                elseif (k) then
                    AnnouncePvP(v.name, k.name)
                end

                -- suicide
            elseif (suicide) then
                if (v_team == self.human_team) then
                    DeathSwitch(victim)
                    goto skip
                end
                AnnounceSuicide(v.name)
                :: skip ::

                -- guardians
            elseif (guardians) then
                AnnounceGuardians(v.name, k.name)

                -- squashed or killed by server
            elseif (squashed or (server and not falling)) then
                if (not self.switching) then
                    AnnounceGenericDeath(v.name)
                end

                -- fall damage:
            elseif (falling) then
                if (v_team == self.human_team) then
                    DeathSwitch(victim)
                    goto next
                end
                AnnounceGenericDeath(v.name)
                :: next ::
            else
                -- unknown death:
                AnnounceGenericDeath(v.name)
            end

            -- Prepare weapons for deletion:
            if (v_team == self.zombie_team) then
                execute_command("nades " .. victim .. " 0")
                self:DespawnWeapons(victim)
            end
        end
    end

    self.switching = false
end

-- This function is called every time a new game begins:
--
function OnGameStart()
    Zombies:Init()
end

-- This function is called every time a game ends:
--
function OnGameEnd()
    Zombies.game_started = false
    local countdown1 = self.timers["Pre-Game Countdown"]
    local countdown2 = self.timers["Not Enough Players"]
    local countdown3 = self.timers["No Zombies"]
    Zombies:StopTimer(countdown1)
    Zombies:StopTimer(countdown2)
    Zombies:StopTimer(countdown3)
end

-- This function is called when a player has connected:
-- @param Ply (player index) [number]
--
function OnPlayerConnect(Ply)
    Zombies:InitPlayer(Ply, false)
    Zombies:GameStartCheck(Ply)
end

-- This function is called when a player has disconnected:
-- @param Ply (player index) [number]
--
function OnPlayerDisconnect(Ply)

    execute_command("wdel " .. Ply)

    Zombies:InitPlayer(Ply, true)

    if (Zombies.game_started) then

        local player_count = tonumber(get_var(0, "$pn"))
        player_count = player_count - 1

        -- Stop timers:
        if (player_count <= 0) then

            local countdown = Zombies.timers["Pre-Game Countdown"]
            Zombies:StopTimer(countdown)

            countdown = Zombies.timers["No Zombies"]
            Zombies:StopTimer(countdown)
        end

        Zombies:GamePhaseCheck(Ply, player_count)
    else
        Zombies:GameStartCheck(Ply, true)
    end
end

--
-- This function is called when a player has finished spawning:
-- @param Ply (player index) [number]
--
function OnPlayerSpawn(Ply)
    local player = Zombies.players[Ply]
    if (player) then
        player.meta_id = 0
        player.assign = true
        Zombies:SetAttributes(Ply)
    end
end

-- This function is called every time a player drops a weapon:
-- @param Ply (player index) [number]
--
function OnWeaponDrop(Ply)
    Zombies:CleanUpDrones(Ply, true)
end

-- This function is called every time a player picks up a weapon:
-- @param Ply (player index) [number]
--
function OnWeaponPickup(Ply)
    RemoveAmmo(Ply)
end

-- Error handler:
--
local function WriteError(err)
    local file = io.open(Zombies.error_file, "a+")
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
        { "Script Version: " .. Zombies.script_version, true, 7 },
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

-- Enables the servers default death messages:
--
function EnableDeathMessages()
    safe_write(true)
    write_dword(Zombies.kill_message_address, Zombies.original_kill_message)
    safe_write(false)
end

-- Disables the servers default death messages:
--
function DisableDeathMessages()
    Zombies.kill_message_address = sig_scan("8B42348A8C28D500000084C9") + 3
    Zombies.original_kill_message = read_dword(Zombies.kill_message_address)
    safe_write(true)
    write_dword(Zombies.kill_message_address, 0x03EB01B1)
    safe_write(false)
end

-- Functions with a call to another function:
--
function OnTick()
    return Zombies:GameTick()
end
function StartPreGameTimer()
    return Zombies:StartPreGameTimer()
end
function NotEnoughPlayers()
    return Zombies:NotEnoughPlayers()
end
function SwitchHumanToZombie()
    return Zombies:SwitchHumanToZombie()
end
function DeathHandler(V, K, MID, D, _, _)
    return Zombies:DeathHandler(V, K, MID, D, _, _)
end

--[[

    -----------------------------------------------------------------------
    Quality of Life feedback:
    This script is designed to run Team Slayer on the following stock maps:

    Ratrace,            Hangemhigh,         Beavercreek,          Carousel
    Chillout,           Damnation,          Gephyrophobia,        Prisoner
    Timberland,         Bloodgulch,         Putput
    -----------------------------------------------------------------------


    -------------------------------
    RECOMMENDED GAME TYPE SETTINGS:
    -------------------------------

    ----------* Game Options * ----------
    SELECT GAME:                    SLAYER
    DEATH BONUS:                    NO
    KILL IN ORDER:                  NO (set to YES if using Nav Marker feature)
    KILL PENALTY:                   NO
    KILLS TO WIN:                   50
    TEAM PLAY                       YES
    TIME LIMIT:                     45 MINUTES

    ----------* Player Options * ----------
    NUMBER OF LIVES:                INFINITE
    MAXIMUM HEALTH:                 100%
    SHIELDS:                        NO
    RESPAWN TIME:                   INSTANT
    RESPAWN TIME GROWTH:            NONE
    ODD MAN OUT:                    NO
    INVISIBLE PLAYERS:              NO
    SUICIDE PENALTY:                NONE

    ----------* Item Options * ----------
    INFINITE GRENADES:              NO
    WEAPON SET:                     NORMAL
    STARTING EQUIPMENT:             GENERIC

    ----------* Vehicle Options * ----------
    VEHICLE RESPAWN TIME:           90 SECONDS
    SIDE:                           BLUE TEAM
    VEHICLE SET:                    NONE
    SIDE:                           RED TEAM
    VEHICLE SET:                    1 ROCKET HOG, 1 CHAIN GUN HOG

    ----------* Indicator Options * ----------
    OBJECTIVES INDICATOR:           NONE (set to NAV POINTS if using Nav Marker feature)
    OTHER PLAYERS ON RADAR:         NO
    FRIEND INDICATORS ON SCREEN:    YES
]]

-- For a future update:
return Zombies
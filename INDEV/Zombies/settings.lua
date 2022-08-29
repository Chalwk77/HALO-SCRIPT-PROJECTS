-- Zombies [Settings File] (v1.0)
-- See the bottom of this file for recommended game type settings.
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

return {

    -- Time (in seconds) until a game begins:
    -- Default: 5
    --
    game_start_delay = 5,

    -- Number of players required to start the game:
    -- Default: 2
    --
    required_players = 3,

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

    -- When enabled, fall damage will be disabled for all players:
    --
    block_fall_damage = true,

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
            *   damage_multiplier:      Units of damage range from 0-10 (1 = normal damage)
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
            weapons = { "weapons\\plasma rifle\\plasma rifle" }
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
    -- Teams:
    -- 0    = disabled for both teams
    -- 1    = disabled for red team
    -- 2    = disabled for blue team
    -- nil  = enabled for both teams

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
        { 'powerups\\health pack', nil }, -- enabled for both teams by default
        { 'powerups\\over shield', 2 },
        { 'powerups\\active camouflage', 2 },
        { 'weapons\\frag grenade\\frag grenade', 2 },
        { 'weapons\\plasma grenade\\plasma grenade', 2 }
    },

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    server_prefix = "**SAPP**"
}

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
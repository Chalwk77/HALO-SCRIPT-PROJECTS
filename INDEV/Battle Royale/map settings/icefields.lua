return {

    --- Safe zone coordinates and size:
    -- The safe zone is a sphere that players cannot leave.
    -- The safe zone will shrink over time, forcing players to fight in a tight space.
    -- When the safe zone is at its minimum size, players will have an extra 2 minutes (end_after) to fight.
    -- The x,y,z coordinates are the center of the sphere.
    -- [note]: 1 world unit is 10 feet or ~3.048 meters.
    --
    safe_zone = {
        x = -24.920,
        y = 33.416,
        z = 0.680,
        min = 7, -- default (7 world/units)
        max = 610 -- default (610 world/units)
    },


    --- Reduction rate:
    -- How often the safe zone will shrink (in seconds):
    -- Default (60) = 1 minute
    --
    duration = 60,


    --- Reduction amount:
    -- How much the safe zone will shrink by (in world units):
    -- Default (15)
    --
    shrink_amount = 15,


    --- End after:
    -- The game will end this many minutes after
    -- the safe zone has shrunk to its minimum size:
    -- Default (2)
    --
    end_after = 2,


    --- Required players:
    -- The minimum amount of players required to start the game:
    -- Default: (2)
    --
    required_players = 2,


    --- Game start delay:
    -- The amount of time (in seconds) to wait before starting the game:
    -- The start delay will not begin until the required players have joined.
    -- Default (30)
    --
    start_delay = 30,


    --- Lives:
    -- When a player's lives have been depleted, they will be eliminated from the game.
    -- An eliminated player will be forced to spectate the remaining players.
    -- Default: 3
    max_lives = 3,


    --- Health:
    -- The amount of health that players will spawn with.
    -- Full health = 1
    -- Default (1) = 100% health
    --
    health = 1,


    --- Health reduction:
    -- The amount of health that players will lose every second if they
    -- are outside the safe zone:
    -- Default (1/30) = 0.033% health every 1 second.
    -- The default value will kill the player in '30' seconds.
    --
    health_reduction = 1 / 30,


    --- Default running speed:
    -- Default (1)
    default_running_speed = 1,


    --- Sky spawn coordinates:
    -- When the game begins, players will be randomly assigned to one of these coordinates.
    -- Coordinates are in the format: {x, y, z, rotation, height}.
    -- The 'rotation' value is the direction that the player will face (in radians, not degrees).
    -- The 'height' value is the height above the ground that the player will spawn at.
    -- [Note]: Make sure there are at least 16 sets of coordinates.
    --
    sky_spawn_coordinates = {

        --- red base:
        {20.530, -26.365, 0.756, 5.190, 25},
        {29.136, -26.417, 0.734, 4.382, 25},
        {28.970, -17.990, 0.737, 1.925, 25},
        {24.772, -16.339, 0.761, 2.081, 25},
        {24.851, -22.085, 2.100, 6.265, 25},
        {14.390, -25.645, 0.783, 0.351, 25},
        {28.682, -8.171, 0.826, 4.366, 25},

        --- blue base:
        {-73.649, 90.773, 0.787, 1.960, 25},
        {-82.091, 90.775, 0.739, 1.201, 25},
        {-77.863, 81.133, 0.775, 5.207, 25},
        {-77.838, 86.560, 2.100, 3.151, 25},
        {-82.519, 74.541, 0.772, 0.396, 25},
        {-66.125, 85.180, 0.751, 2.979, 25},
        {-77.834, 97.242, 1.167, 4.693, 25},

        --- random locations:
        {-66.672, 70.649, 1.355, 5.643, 25},
        {-64.324, 56.265, 0.939, 4.329, 25},
        {-77.568, 53.483, 0.896, 0.690, 25},
        {-71.054, 44.169, 0.786, 5.662, 25},
        {-49.053, 28.480, 0.693, 0.381, 25},
        {-40.017, 46.015, 0.680, 3.890, 25},
        {-38.218, 22.356, 0.680, 0.680, 25},
        {-13.385, 43.253, 0.680, 3.989, 25},
        {-13.139, 18.679, 0.680, 0.589, 25},
        {4.520, 27.649, 0.741, 5.938, 25},
        {20.553, 19.636, 0.748, 2.663, 25},
        {24.900, 10.496, 0.904, 3.595, 25},
        {19.774, -2.620, 0.763, 5.417, 25},
        {17.437, -10.015, 0.910, 2.457, 25},
        {-3.592, -4.341, 3.108, 2.937, 25},
        {-26.051, 26.971, 9.007, 4.711, 25},
        {-26.050, 37.997, 9.007, 1.576, 25},
        {-30.354, 48.994, 8.685, 5.657, 25},
        {-28.036, 68.951, 5.638, 4.906, 25},
    },


    --- Weapon weight:
    --
    weight = {

        enabled = true,

        -- Combine:
        -- If true, your speed will be the sum of the
        -- combined weight of all the weapons in your inventory.
        -- Otherwise the speed will be based on weight of the weapon currently held.
        --
        combined = true,

        -- Format: ['tag name'] = weight reduction value
        weapons = {

            ['weapons\\flag\\flag'] = 0.028,
            ['weapons\\ball\\ball'] = 0.028,

            ['weapons\\pistol\\pistol'] = 0.036,
            ['weapons\\plasma pistol\\plasma pistol'] = 0.036,

            ['weapons\\needler\\mp_needler'] = 0.042,
            ['weapons\\plasma rifle\\plasma rifle'] = 0.042,

            ['weapons\\shotgun\\shotgun'] = 0.047,
            ['weapons\\assault rifle\\assault rifle'] = 0.061,

            ['weapons\\flamethrower\\flamethrower'] = 0.073,

            ['weapons\\sniper rifle\\sniper rifle'] = 0.075,

            ['weapons\\plasma_cannon\\plasma_cannon'] = 0.098,
            ['weapons\\rocket launcher\\rocket launcher'] = 0.104
        }
    },


    --- Weapon degradation (decay):
    weapon_degradation = {

        -- If enabled, weapons will degrade over time.
        -- Default (true)
        --
        enabled = true,

        decay_rate = {

            -- All weapons start with a decay value of 0 and a max decay value of 100.
            -- The lower the percentage value, the faster the weapon will degrade.
            -- The percentage is added to the weapons decay value every 1/30th second (while firing).
            -- Example: 0.066%*30 = 1.98% per second.

            -- 1.98% every second (0.066% every 1/30th second)
            ['weapons\\pistol\\pistol'] = 1.98,
            ['weapons\\needler\\mp_needler'] = 1.98,

            -- 2.10% every second (0.07% every 1/30th second)
            ['weapons\\flamethrower\\flamethrower'] = 2.10,

            -- 1.20% every second (0.04% every 1/30th second)
            ['weapons\\plasma rifle\\plasma rifle'] = 1.2,
            ['weapons\\plasma pistol\\plasma pistol'] = 1.2,

            -- 1.90% every second (0.063% every 1/30th second)
            ['weapons\\shotgun\\shotgun'] = 1.90,

            -- 2.30% every second (0.078% every 1/30th second)
            ['weapons\\assault rifle\\assault rifle'] = 2.30,

            -- 2.45% every second (0.078% every 1/30th second)
            ['weapons\\sniper rifle\\sniper rifle'] = 2.45,
            ['weapons\\plasma_cannon\\plasma_cannon'] = 2.45,

            -- 2.35% every second (0.078% every 1/30th second)
            ['weapons\\rocket launcher\\rocket launcher'] = 2.35,
        }
    },


    --- Loot:
    -- The loot system will spawn items at pre-defined locations.
    --
    looting = {

        enabled = true,

        --- Spoils found in loot crates:
        -- Format: [chance] = { label = 'Spoil label (seen in game)' }
        -- To disable a spoil, set its chance to 0.
        -- [!] Do not touch the '_function__' value. It is used internally.
        --
        spoils = {

            --- NUKE:
            [1] = {
                label = 'Nuke',
                radius = 10, -- kills all players within this radius
                _function_ = 'giveNuke'
            },

            --- AIR STRIKE:
            [5] = {
                label = 'Air Strike Ability',
                _function_ = 'enableAirstrike'
            },

            --- STUN GRENADES:
            [10] = {
                label = 'Stun Grenade(s)',
                _function_ = 'giveStunGrenades'
            },

            --- FRAG GRENADES:
            [15] = {
                label = 'Frag Grenade(s)',
                _function_ = 'giveFragGrenades'
            },

            --- GRENADE LAUNCHER:
            [20] = {
                label = 'Grenade Launcher',
                _function_ = 'giveGrenadeLauncher'
            },

            --- WEAPON PARTS:
            [25] = {
                label = 'Weapon Parts! Use /repair',
                _function_ = 'giveWeaponParts'
            },

            --- RANDOM WEAPON:
            [30] = {
                label = 'Weapon(s)',
                _function_ = 'giveRandomWeapon'
            },

            --- SPEED BOOST:
            -- Format: { { multiplier, duration (in seconds) } }
            [35] = {
                label = '$speedX Speed Boost for $duration seconds',
                multipliers = { { 1.2, 10 }, { 1.3, 15 }, { 1.4, 20 }, { 1.5, 25 } },
                _function_ = 'giveSpeedBoost'
            },

            --- AMMO:
            [40] = {
                label = 'Ammo',
                _function_ = 'giveAmmo'
            },

            --- CAMOUFLAGE:
            [45] = {
                label = 'Active Camo',
                _function_ = 'giveCamo'
            },

            --- OVERSHIELD:
            [50] = {
                label = 'Overshield',
                _function_ = 'giveOvershield'
            },

            --- HEALTH BOOST:
            [55] = {
                label = 'Health Boost',
                levels = { 1.2, 1.3, 1.4, 1.5 },
                _function_ = 'giveHealthBoost'
            }
        },

        --- Loot crates:
        -- Format: ['tag class'] = { ['tag name'] = { x, y, z, respawn time (in seconds) } }
        --
        crates = {
            ['eqip'] = {
                ['powerups\\full-spectrum vision'] = {
                }
            }
        },

        --- Random Loot weapon/power up spawns:
        objects = {

            ['weap'] = {
                ['weapons\\assault rifle\\assault rifle'] = {
                },
                ['weapons\\flamethrower\\flamethrower'] = {
                },
                ['weapons\\pistol\\pistol'] = {
                },
                ['weapons\\plasma pistol\\plasma pistol'] = {
                },
                ['weapons\\needler\\mp_needler'] = {
                },
                ['weapons\\plasma rifle\\plasma rifle'] = {
                },
                ['weapons\\shotgun\\shotgun'] = {
                },
                ['weapons\\sniper rifle\\sniper rifle'] = {
                },
                ['weapons\\plasma_cannon\\plasma_cannon'] = {
                },
                ['weapons\\rocket launcher\\rocket launcher'] = {
                },
                ['weapons\\sniper rifle\\sniper rifle'] = {
                },
            },

            ['eqip'] = {
                ['powerups\\flamethrower ammo\\flamethrower ammo'] = {
                },
                ['powerups\\shotgun ammo\\shotgun ammo'] = {
                },
                ['powerups\\sniper rifle ammo\\sniper rifle ammo'] = {
                },
                ['powerups\\active camouflage'] = {
                },
                ['powerups\\health pack'] = {
                },
                ['powerups\\over shield'] = {
                },
                ['powerups\\assault rifle ammo\\assault rifle ammo'] = {
                },
                ['powerups\\needler ammo\\needler ammo'] = {
                },
                ['powerups\\rocket launcher ammo\\rocket launcher ammo'] = {
                },
                ['weapons\\frag grenade\\frag grenade'] = {
                },
                ['weapons\\plasma grenade\\plasma grenade'] = {
                },
            }
        }
    }
}
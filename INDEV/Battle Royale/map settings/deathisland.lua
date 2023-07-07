return {

    --- Safe zone coordinates and size:
    -- The safe zone is a sphere that players cannot leave.
    -- The safe zone will shrink over time, forcing players to fight in a tight space.
    -- When the safe zone is at its minimum size, players will have an extra 2 minutes (end_after) to fight.
    -- The x,y,z coordinates are the center of the sphere.
    -- [note]: 1 world unit is 10 feet or ~3.048 meters.
    --
    safe_zone = {
        x = -30.237,
        y = 30.534,
        z = 14.270,
        min = 6, -- default (6 world/units)
        max = 155 -- default (155 world/units)
    },


    --- Reduction rate:
    -- How often the safe zone will shrink (in seconds):
    -- Default (240)
    --
    duration = 240,


    --- Reduction amount:
    -- How much the safe zone will shrink by (in world units):
    -- Default (15) = 15 world units
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
        {-30.272, -2.461, 9.416, 3.938, 35},
        {-28.694, -11.998, 9.416, 2.567, 35},
        {-37.937, -18.749, 9.160, 2.540, 35},
        {-38.029, -9.644, 9.416, 4.336, 35},
        {-38.125, -4.243, 9.416, 4.071, 35},
        {-38.600, 2.089, 10.299, 4.119, 35},
        {-35.211, -14.059, 4.861, 2.871, 35},

        --- blue base:
        {31.801, 23.153, 8.049, 5.371, 35},
        {36.878, 10.895, 8.049, 0.491, 35},
        {40.399, 19.095, 8.049, 1.398, 35},
        {40.767, 13.450, 8.049, 5.033, 35},
        {37.321, 32.209, 4.348, 5.437, 35},
        {41.885, 15.947, 4.813, 0.043, 35},
        {39.993, 7.351, 4.592, 0.640, 35},

        --- random locations:
        {55.978, 9.804, 1.607, 4.208, 35},
        {40.924, 45.187, 2.996, 0.598, 35},
        {28.536, 43.808, 3.737, 2.424, 35},
        {15.036, 53.079, 3.862, 4.173, 35},
        {11.130, 61.929, 1.881, 0.333, 35},
        {6.437, 57.963, 6.602, 1.758, 35},
        {-30.108, 64.228, 3.085, 0.102, 35},
        {-44.438, 45.171, 5.145, 2.327, 35},
        {-57.438, 51.166, 2.886, 3.821, 35},
        {-92.187, 10.471, 5.364, 6.005, 35},
        {-73.362, 12.881, 1.538, 5.549, 35},
        {-53.736, 7.222, 3.939, 3.581, 35},
        {-46.247, 14.455, 7.926, 4.554, 35},
        {-48.578, -23.611, 2.882, 2.799, 35},
        {-16.357, -49.983, 1.949, 5.006, 35},
        {-15.114, -33.192, 4.389, 5.985, 35},
        {16.200, -35.229, 5.599, 4.503, 35},
        {47.586, -36.576, 2.036, 5.257, 35},
        {41.308, -17.279, 3.130, 0.569, 35},
        {34.658, -6.568, 6.437, 5.187, 35},
        {5.278, 8.365, 12.207, 2.264, 35},
        {-8.524, 12.696, 13.293, 0.887, 35},
        {-30.730, 39.630, 16.619, 4.754, 35},
        {-33.141, 44.392, 12.614, 0.965, 35},
        {-29.962, 42.304, 21.139, 4.813, 35},
        {-42.326, 19.422, 22.086, 0.279, 35},
        {-11.136, 9.218, 21.979, 0.372, 35},
        {-24.359, -1.028, 21.278, 1.443, 35},
        {-24.626, -19.870, 20.251, 2.008, 35},
        {-25.565, -32.904, 19.889, 0.885, 35},
        {7.823, -15.020, 17.045, 0.208, 35},
        {14.597, -0.313, 20.270, 1.291, 35},
        {20.571, -24.003, 17.676, 0.370, 35},
        {47.432, -37.421, 13.934, 3.208, 35},
        {27.242, 31.269, 17.936, 2.658, 35},
        {14.220, 41.215, 16.244, 0.998, 35},
        {-69.204, 18.944, 15.270, 5.727, 35},
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
            -- The higher the percentage value, the faster the weapon will degrade.
            -- Example: 1.98% = 0.066*30% per 30 ticks.
            -- [note]: Weapons will only decay while in use (firing, but not reloading).

            -- 1.20% every second (0.04% every 1/30th second)
            ['weapons\\plasma rifle\\plasma rifle'] = 1.2,
            ['weapons\\plasma pistol\\plasma pistol'] = 1.2,

            -- 1.90% every second (0.063% every 1/30th second)
            ['weapons\\shotgun\\shotgun'] = 1.90,

            -- 2.10% every second (0.07% every 1/30th second)
            ['weapons\\flamethrower\\flamethrower'] = 2.10,

            -- 2.12% every second (0.070% every 1/30th second)
            ['weapons\\pistol\\pistol'] = 2.12,
            ['weapons\\needler\\mp_needler'] = 2.12,

            -- 2.35% every second (0.078% every 1/30th second)
            ['weapons\\rocket launcher\\rocket launcher'] = 2.35,

            -- 2.45% every second (0.081% every 1/30th second)
            ['weapons\\sniper rifle\\sniper rifle'] = 2.45,
            ['weapons\\plasma_cannon\\plasma_cannon'] = 2.45,

            -- 3.45% every second (0.115% every 1/30th second)
            ['weapons\\assault rifle\\assault rifle'] = 3.45,
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

        --- Loot crate locations:
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
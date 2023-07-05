return {

    --- Safe zone coordinates and size:
    -- The safe zone is a sphere that players cannot leave.
    -- The safe zone will shrink over time, forcing players to fight in a tight space.
    -- When the safe zone is at its minimum size, players will have an extra 2 minutes (end_after) to fight.
    -- The x,y,z coordinates are the center of the sphere.
    -- [note]: 1 world unit is 10 feet or ~3.048 meters.
    --
    safe_zone = {
        x = -0.054,
        y = 45.395,
        z = -8.366,
        min = 6, -- default (6 world/units)
        max = 206 -- default (4700 world/units)
    },


    --- Reduction rate:
    -- How often the safe zone will shrink (in seconds):
    -- Default (60)
    --
    duration = 60,


    --- Reduction amount:
    -- How much the safe zone will shrink by (in world units):
    -- Default (103) = 103 world units
    --
    shrink_amount = 5,


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
        {-9.007, -4.607, -4.032, 5.632, 20},
        {-9.007, -2.296, -4.032, 0.716, 20},
        {-4.103, -3.552, -4.024, 3.114, 20},
        {-6.053, -12.038, -4.124, 2.176, 20},
        {-13.317, -6.507, -4.033, 3.635, 20},
        {-15.207, -2.296, -4.032, 2.656, 20},
        {-19.392, -12.193, -4.156, 1.026, 20},

        --- blue base:
        {8.904, -2.296, -4.032, 2.504, 20},
        {8.904, -4.607, -4.032, 4.212, 20},
        {6.309, -14.432, -4.202, 0.361, 20},
        {13.214, -6.507, -4.033, 5.651, 20},
        {15.104, -2.296, -4.032, 0.871, 20},
        {11.984, -3.497, -2.243, 0.043, 20},

        --- random locations:
        {-40.147, -7.830, -1.147, 1.280, 20},
        {-46.153, -4.121, -2.209, 1.337, 20},
        {-54.402, 8.693, -5.434, 0.956, 20},
        {-42.424, 19.730, -8.794, 1.294, 20},
        {-57.197, 26.878, -11.470, 6.069, 20},
        {-31.376, 30.477, -6.331, 0.720, 20},
        {-20.903, 32.484, -6.109, 1.422, 20},
        {-26.550, 45.467, -9.825, 6.147, 20},
        {-18.792, 54.519, -9.228, 4.938, 20},
        {-15.699, 38.317, -7.734, 1.795, 20},
        {-1.257, 48.413, -8.366, 2.545, 20},
        {1.950, 37.907, -8.366, 6.268, 20},
        {-1.580, 42.009, -8.366, 2.690, 20},
        {20.544, 54.181, -9.317, 5.111, 20},
        {18.405, 37.870, -7.512, 2.327, 20},
        {26.524, 29.264, -5.532, 1.564, 20},
        {42.711, 34.299, -8.204, 4.881, 20},
        {53.730, 26.437, -10.704, 3.456, 20},
        {42.855, 20.599, -8.497, 0.180, 20},
        {52.234, 5.204, -4.658, 2.227, 20},
        {45.252, -4.204, -2.208, 2.114, 20},
        {32.526, 2.839, -2.240, 4.310, 20},
        {39.350, -7.237, -1.143, 2.406, 20},
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


    --- Loot:
    -- The loot system will spawn items at pre-defined locations.
    --
    looting = {

        enabled = true,

        --- Spoils found in loot crates:
        -- Format: [chance] = { label = 'Spoil label (seen in game)' }
        -- To disable a spoil, set its chance to 0.
        -- [!] Do not touch the index value.
        --
        spoils = {
            [1] = {
                index = 1,
                label = 'Nuke'
            },
            [5] = {
                index = 2,
                label = 'Air Strike Ability'
            },
            [10] = {
                index = 3,
                label = 'Stun Grenade(s)'
            },
            [15] = {
                index = 4,
                label = 'Grenade Launcher'
            },
            [25] = {
                index = 5,
                label = 'Weapon Parts'
            },
            [30] = {
                index = 6,
                label = 'Weapon(s)'
            },
            [40] = {
                index = 7,
                label = '$speedX Speed Boost'
            },
            [45] = {
                index = 8,
                label = 'Ammo'
            },
            [50] = {
                index = 9,
                label = 'Active Camo'
            },
            [55] = {
                index = 10,
                label = 'Overshield'
            },
            [60] = {
                index = 11,
                label = 'Health Boost'
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
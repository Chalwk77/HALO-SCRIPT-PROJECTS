return {

    --- Safe zone coordinates and size:
    -- The safe zone is a sphere that players cannot leave.
    -- The safe zone will shrink over time, forcing players to fight in a tight space.
    -- When the safe zone is at its minimum size, players will have an extra 2 minutes (end_after) to fight.
    -- The x,y,z coordinates are the center of the sphere.
    -- [note]: 1 world unit is 10 feet or ~3.048 meters.
    --
    safe_zone = {
        x = 1.245,
        y = -1.028,
        z = -21.186,
        min = 6, -- default (6 world/units)
        max = 4700 -- default (4700 world/units)
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
    shrink_amount = 103,


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
        {13.505, -50.329, -17.586, 2.189, 35},
        {20.976, -50.308, -17.652, 1.294, 35},
        {17.412, -47.249, -17.932, 1.680, 35},
        {7.548, -42.685, -17.048, 0.834, 35},
        {25.585, -41.356, -16.481, 3.490, 35},
        {16.535, -36.548, -16.950, 4.767, 35},
        {17.349, -43.527, -18.165, 1.936, 35},

        --- blue base:
        {-12.817, 50.250, -17.628, 5.320, 35},
        {-20.055, 50.331, -17.650, 4.420, 35},
        {-16.208, 47.301, -17.832, 4.987, 35},
        {-5.992, 42.321, -16.783, 3.749, 35},
        {-24.433, 43.589, -16.989, 0.131, 35},
        {-16.004, 43.543, -18.188, 5.324, 35},
        {-16.105, 35.453, -16.580, 1.598, 35},

        --- random locations:
        {-5.130, -34.157, -21.726, 1.094, 35},
        {3.287, -15.268, -22.008, 0.372, 35},
        {1.014, 14.968, -21.893, 2.915, 35},
        {6.067, 34.193, -21.637, 4.393, 35},
        {-15.863, 12.535, -20.735, 5.331, 35},
        {-39.861, 33.584, -19.582, 5.783, 35},
        {-33.849, 15.627, -20.580, 5.779, 35},
        {-24.759, -13.775, -20.698, 0.027, 35},
        {-31.055, -32.722, -20.980, 0.403, 35},
        {-9.381, -40.382, -20.353, 0.941, 35},
        {-4.412, -13.981, -20.763, 6.205, 35},
        {9.626, -15.226, -21.027, 3.092, 35},
        {19.146, -7.242, -20.933, 3.971, 35},
        {42.453, -27.017, -20.742, 1.961, 35},
        {19.655, -25.953, -20.633, 2.556, 35},
        {26.918, 15.004, -20.954, 3.776, 35},
        {33.074, 32.879, -21.387, 4.166, 35},
        {17.004, 20.854, -16.115, 4.277, 35},
        {10.764, 1.191, -19.139, 3.492, 35},
        {31.042, -21.462, -18.446, 2.918, 35},
        {-17.024, -24.225, -16.706, 0.155, 35},
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
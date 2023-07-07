return {

    --- Safe zone coordinates and size:
    -- The safe zone is a sphere that players cannot leave.
    -- The safe zone will shrink over time, forcing players to fight in a tight space.
    -- When the safe zone is at its minimum size, players will have an extra 2 minutes (end_after) to fight.
    -- The x,y,z coordinates are the center of the sphere.
    -- [note]: 1 world unit is 10 feet or ~3.048 meters.
    --
    safe_zone = {
        x = 3.583,
        y = 31.963,
        z = -3.922,
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
        {-28.417, -31.040, -3.842, 1.215, 25},
        {-35.560, -30.986, -3.842, 2.046, 25},
        {-32.019, -28.722, -3.842, 1.369, 25},
        {-31.748, -31.998, 0.558, 1.598, 25},
        {-50.270, -16.243, -3.842, 5.751, 25},
        {-19.695, -37.751, -3.842, 2.128, 25},
        {-35.441, -14.632, -2.856, 4.975, 25},

        --- blue base:
        {26.264, -34.826, -3.842, 1.750, 25},
        {34.248, -34.915, -3.842, 1.373, 25},
        {30.374, -32.048, -3.790, 1.748, 25},
        {17.648, -31.824, -3.842, 0.679, 25},
        {45.466, -23.819, -3.922, 2.986, 25},
        {33.489, -18.948, -3.837, 4.468, 25},
        {30.323, -35.890, 0.558, 1.558, 25},

        --- random locations:
        {-48.320, -0.772, -3.922, 0.589, 25},
        {-48.481, 20.776, -3.842, 5.765, 25},
        {-31.778, 33.574, -3.842, 1.964, 25},
        {-21.911, 44.985, -3.842, 0.509, 25},
        {-25.589, 17.108, -3.943, 0.392, 25},
        {-10.295, -1.403, -3.842, 2.089, 25},
        {-11.572, -17.346, 0.232, 2.006, 25},
        {-46.518, 24.581, 0.158, 5.368, 25},
        {-38.308, 40.470, 0.158, 6.165, 25},
        {21.044, 13.195, -3.729, 5.411, 25},
        {52.396, 13.914, -3.842, 3.833, 25},
        {53.210, 28.996, 0.158, 3.250, 25},
        {46.166, 42.317, 0.158, 3.901, 25},
        {6.576, 2.518, 0.158, 6.245, 25},
        {7.809, -19.889, 0.182, 0.816, 25},
        {32.068, -3.465, -3.319, 3.398, 25},
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
    -- Weapons will jam over time, as they degrade.
    -- They will progressively jam more often as they get closer to breaking.
    -- When a weapon jams, it will not fire until it is unjammed.
    -- The player will have to unjam the weapon by pressing the melee button.
    weapon_degradation = {

        -- If enabled, weapons will degrade over time.
        -- Default (true)
        --
        enabled = true,

        -- Weapons cannot jam if the decay is below this value:
        min = 10,

        -- Weapons will always jam if the decay is above this value:
        max = 100,

        -- Format: ['tag name'] = decay rate
        decay_rate = {

            -- All weapons start with a decay value of 0 and a max decay value of 100.
            -- The higher the percentage value, the faster the weapon will degrade.
            -- Example: 1.98% = 0.066*30% per 30 ticks.
            -- [note]: Weapons will only decay while in use (firing, but not reloading).

            ['weapons\\plasma rifle\\plasma rifle'] = 3.0,
            ['weapons\\plasma pistol\\plasma pistol'] = 3.0,

            ['weapons\\shotgun\\shotgun'] = 4.5,

            ['weapons\\flamethrower\\flamethrower'] = 5.0,

            ['weapons\\pistol\\pistol'] = 5.3,
            ['weapons\\needler\\mp_needler'] = 5.3,

            ['weapons\\assault rifle\\assault rifle'] = 5.5,

            ['weapons\\rocket launcher\\rocket launcher'] = 10.0,

            ['weapons\\sniper rifle\\sniper rifle'] = 10.50,
            ['weapons\\plasma_cannon\\plasma_cannon'] = 10.50
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
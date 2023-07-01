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
    -- Default (60) = 1 minute
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
    -- Default (2) = 2 minutes
    --
    end_after = 2,


    --- Required players:
    -- The minimum amount of players required to start the game:
    --
    required_players = 1,


    --- Game start delay:
    -- The amount of time (in seconds) to wait before starting the game:
    -- The start delay will not begin until the required players have joined.
    -- Default (30) = 30 seconds
    --
    start_delay = 2,


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


    --- Sky spawn coordinates:
    -- When the game begins, players will be randomly assigned to one of these coordinates.
    -- Coordinates are in the format: {x, y, z, height}.
    -- The 'height' value is the height above the ground that the player will spawn at.
    --
    sky_spawn_coordinates = {

        --- red base:
        { 17.27, -46.85, -17.95, 35 },
        { 16.86, -43.96, -18.16, 35 },
        { 12.55, -49.42, -17.48, 35 },
        { 22.11, -49.14, -17.50, 35 },
        { 23.31, -42.19, -17.14, 35 },
        { 9.99, -38.28, -16.96, 35 },
        { 15.96, -34.87, -16.26, 35 },

        --- blue base:
        { -16.34, 47.30, -17.84, 35 },
        { -16.29, 44.24, -18.14, 35 },
        { -12.10, 49.70, -17.52, 35 },
        { -20.79, 49.45, -17.54, 35 },
        { -23.49, 42.21, -16.98, 35 },
        { -7.32, 41.62, -17.20, 35 },
        { -15.55, 34.67, -16.33, 35 },

        --- random locations:
        { 16.25, 24.46, -16.69, 35 },
        { 5.23, 31.86, -21.83, 35 },
        { -4.60, -33.38, -21.78, 35 },
        { -15.55, -24.34, -16.69, 35 },
        { -25.38, -13.21, -20.71, 35 },
        { 18.13, -8.62, -20.97, 35 },
        { 31.38, -21.18, -18.45, 35 },
        { 38.87, -33.13, -19.87, 35 },
        { 26.59, 14.65, -20.96, 35 },
        { 34.11, 33.89, -21.40, 35 },
        { -16.20, 11.87, -20.72, 35 },
        { -29.88, 20.80, -18.54, 35 },
        { -39.18, 34.03, -19.67, 35 },
        { -31.09, -34.47, -21.07, 35 }
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
    -- [!] These locations may be randomised in a later update.
    --
    looting = {

        enabled = true,

        -- Format:
        -- Format: ['tag class'] = { ['tag name'] = { x, y, z, respawn time (in seconds) } }
        --

        -- Loot crates:
        --
        crates = {
            ['eqip'] = {
                ['powerups\\full-spectrum vision'] = {
                    { 11.57, -14.18, -20.98, 30 }
                }
            }
        },

        -- Loot weapons/powerups:
        objects = {

            ['weap'] = {
                ['weapons\\assault rifle\\assault rifle'] = {

                },
                ['weapons\\flamethrower\\flamethrower'] = {
                    { 1.13, -0.98, -21.17, 30 }
                },
                ['weapons\\pistol\\pistol'] = {
                    { -4.74, -33.42, -21.78 }
                },
                ['weapons\\plasma pistol\\plasma pistol'] = {

                },
                ['weapons\\needler\\mp_needler'] = {
                    { -13.44, 18.48, -20.85 }
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
                    { 17.01, 24.38, -16.69, 30 },
                    { -24.31, 17.07, -18.78, 30 },
                    { 18.48, -25.26, -20.60, 30 }
                },
                ['powerups\\shotgun ammo\\shotgun ammo'] = {
                    { -6.17, 12.29, -21.11, 30 }
                },
                ['powerups\\sniper rifle ammo\\sniper rifle ammo'] = {
                    { -5.15, -18.59, -20.89, 30 }
                },
                ['powerups\\active camouflage'] = {

                },
                ['powerups\\health pack'] = {

                },
                ['powerups\\over shield'] = {

                },
                ['weapons\\frag grenade\\frag grenade'] = {

                },
                ['weapons\\plasma grenade\\plasma grenade'] = {

                },
                ['powerups\\assault rifle ammo\\assault rifle ammo'] = {

                },
                ['powerups\\needler ammo\\needler ammo'] = {

                },
                ['powerups\\rocket launcher ammo\\rocket launcher ammo'] = {

                }
            }
        }
    }
}
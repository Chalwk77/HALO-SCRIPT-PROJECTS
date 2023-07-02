return {

    --- Safe zone coordinates and size:
    -- The safe zone is a sphere that players cannot leave.
    -- The safe zone will shrink over time, forcing players to fight in a tight space.
    -- When the safe zone is at its minimum size, players will have an extra 2 minutes (end_after) to fight.
    -- The x,y,z coordinates are the center of the sphere.
    -- [note]: 1 world unit is 10 feet or ~3.048 meters.
    --
    safe_zone = {
        x = 65.749,
        y = -120.409,
        z = 0.118,
        min = 6, -- default (6 world/units)
        max = 206 -- default (206 world/units)
    },


    --- Reduction rate:
    -- How often the safe zone will shrink (in seconds):
    -- Default (60)
    --
    duration = 60,


    --- Reduction amount:
    -- How much the safe zone will shrink by (in world units):
    -- Default (5)
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
    -- Coordinates are in the format: {x, y, z, rotation, height}.
    -- The 'rotation' value is the direction that the player will face (in radians, not degrees).
    -- The 'height' value is the height above the ground that the player will spawn at.
    -- [Note]: Make sure there are at least 16 sets of coordinates.
    --
    sky_spawn_coordinates = {

        --- red base:
        { 111.08, -176.01, 0.83, 2.336, 35 },
        { 108.50, -168.04, 0.05, 2.469, 35 },
        { 109.78, -160.53, 0.03, 2.490, 35 },
        { 104.16, -151.83, 0.09, 2.911, 35 },
        { 94.60, -149.44, 0.06, 1.736, 35 },
        { 83.13, -155.03, -0.14, 2.293, 35 },
        { 83.46, -164.04, 0.09, 0.983, 35 },

        --- blue base:
        { 49.21, -88.68, 0.11, 2.283, 35 },
        { 56.00, -84.74, 0.09, 2.790, 35 },
        { 62.52, -72.11, 1.02, 3.539, 35 },
        { 54.81, -66.20, 0.92, 4.616, 35 },
        { 42.03, -66.88, 0.71, 5.146, 35 },
        { 30.66, -68.10, 0.35, 5.517, 35 },
        { 28.36, -78.37, 0.23, 5.587, 35 },
        { 37.12, -93.44, 0.04, 5.470, 35 },

        --- random locations:
        { 84.03, -144.51, 0.08, 5.294, 35 },
        { 66.19, -144.16, 1.04, 5.735, 35 },
        { 74.93, -132.26, -0.17, 0.694, 35 },
        { 84.63, -126.30, 0.54, 4.089, 35 },
        { 105.81, -133.12, 1.13, 2.980, 35 },
        { 111.04, -132.92, 0.52, 3.099, 35 },
        { 111.51, -145.59, 0.24, 3.450, 35 },
        { 79.14, -117.54, 0.22, 4.351, 35 },
        { 88.40, -105.56, 1.54, 3.600, 35 },
        { 82.43, -93.98, 1.78, 4.401, 35 },
        { 66.53, -99.43, 1.33, 4.739, 35 },
        { 64.98, -120.74, 0.16, 0.275, 35 },
        { 47.84, -124.63, -0.32, 0.008, 35 },
        { 51.95, -108.22, 0.22, 1.509, 35 },
        { 65.34, -109.34, 2.02, 4.047, 35 },
        { 42.26, -144.77, 2.76, 0.917, 35 }
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

        --
        -- Spoils found in loot crates:
        -- Set an item to 'false' to disable.
        --
        --
        -- [!] Do not rename the labels!
        spoils = {
            ['Nuke'] = true,
            ['Stun Grenade(s)'] = true,
            ['Ammo'] = true,
            ['Weapon(s)'] = true,
            ['Air Strike Ability'] = true,
            ['Weapon Parts'] = true,
            ['Grenade Launcher'] = true
        },

        -- Format:
        -- Format: ['tag class'] = { ['tag name'] = { x, y, z, respawn time (in seconds) } }
        --

        -- Loot crates:
        --
        crates = {
            ['eqip'] = {
                ['powerups\\full-spectrum vision'] = {
                    { 98.77, -108.72, 4.32, 30 },
                    { 109.81, -110.36, 2.14, 30 },
                    { 91.30, -92.90, 5.12, 30 },
                    { 67.95, -88.94, 5.54, 30 },
                    { 47.35, -150.79, 4.38, 30 },
                    { 61.78, -155.34, 5.94, 30 },
                    { 63.43, -177.53, 4.13, 30 },
                    { 113.13, -178.85, 1.44, 30 },
                    { 119.99, -181.58, 6.98, 30 },
                    { 75.90, -132.88, -0.08, 30 },
                    { 68.61, -93.09, 2.06, 30 },
                    { 80.07, -64.62, 4.56, 30 },
                    { 17.62, -60.62, 4.83, 30 },
                    { 21.82, -107.29, 2.25, 30 },
                }
            }
        },

        -- Loot weapons/powerups:
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
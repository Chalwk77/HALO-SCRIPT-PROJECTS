-- Rank System [Settings File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

return {

    -- Ranks database file name:
    -- This will be located in sapp cg folder.
    file = 'ranks.json',

    -- Suggestions: cR, $, Points, Candy
    currency_symbol = 'cR',

    -- Starting rank & grade for new players:
    starting_rank = 'Recruit',
    starting_grade = 1,

    -- Make sure starting credits are => (equal to or greater than) the amount for the starting grade but,
    -- but < (less than) than the amount for the immediate next grade.
    -- If not, the script will auto-set starting credits based on the starting rank & grade.
    -- For example, if the starting rank & grade is Sergeant, grade 2, the starting credits must be between 16000-16999.
    starting_credits = 0,

    -- When should we update the rank database (ranks.json)?
    -- It's not recommended to save stats to file during player join & quit as this
    -- may cause undesirable (albeit temporary) lag.
    update_file_database = {
        ["OnEnd"] = true,
        ["OnJoin"] = false,
        ["OnQuit"] = false
    },

    -- Fully customizable messages:
    messages = {

        -- Excluding message #6, the first line is sent to the player.
        -- The second line is sent to everyone else on the server.
        -- Set line to blank ('') to disable it.

        -- Join message:
        [1] = {
            'You are [$rank, grade $grade] Credits: $credits, Prestige: $prestige',
            '$name is [$rank, grade $grade] Credits: $credits, Prestige: $prestige'
        },

        -- Grade up message:
        [2] = {
            '[GRADE UP] Congratulations! You leveled up [$rank, grade $grade]',
            '[GRADE UP] $name leveled up [$rank, grade $grade]'
        },

        -- Rank up message:
        [3] = {
            '[RANK UP] Congratulations! You ranked up [$rank, grade $grade]',
            '[RANK UP] $name ranked up [$rank, grade $grade]'
        },

        -- All ranks completed message:
        [4] = {
            '[RANKS COMPLETE] Congratulations! You have completed all ranks.',
            '[RANKS COMPLETE] $name has completed all ranks!'
        },

        -- Downgrade message (server-wide message) | Set to false to make it private message:
        [5] = {
            '[DOWNGRADED] You were downgraded to [$rank, grade $grade]',
            '[DOWNGRADED] $name was downgraded to [$rank, grade $grade]'
        },

        -- Multi-line message seen when typing /rank (player [number]):
        [6] = {
            'Rank: [$rank, grade $grade] Position: $pos/$total',
            'Credits: $credits Prestige: $prestige',
            ' ',
            'Next Rank: [$next_rank, grade $next_grade]',
            '[Credits Required: $req]'
        }
    },

    -- Credits table defines experience levels earned & action-specific messages:
    --
    credits = {

        -- Score (credits added):
        score = { 5, '+5 $currency_symbol (Flag Cap)' },

        -- Killed by Server (credits deducted):
        server = { -0, '-0 $currency_symbol (Server)' },

        -- killed by guardians (credits deducted):
        guardians = { -5, '-5 $currency_symbol (Guardians)' },

        -- suicide (credits deducted):
        suicide = { -10, '-10 $currency_symbol (Suicide)' },

        -- betrayal (credits deducted):
        betrayal = { -15, '-15 $currency_symbol (Betrayal)' },

        -- Killed from the grave (credits added to killer)
        killed_from_the_grave = { 5, '+5 $currency_symbol (Killed From Grave)' },

        -- Bonus points for getting the first kill
        first_blood = { 30, '+30cR (First Blood)' },

        -- {consecutive kills, xp rewarded}
        spree = {
            { 5, 5, '+5 $currency_symbol (spree)' },
            { 10, 10, '+10 $currency_symbol (spree)' },
            { 15, 15, '+15 $currency_symbol (spree)' },
            { 20, 20, '+20 $currency_symbol (spree)' },
            { 25, 25, '+25 $currency_symbol (spree)' },
            { 30, 30, '+30 $currency_symbol (spree)' },
            { 35, 35, '+35 $currency_symbol (spree)' },
            { 40, 40, '+40 $currency_symbol (spree)' },
            { 45, 45, '+45 $currency_symbol (spree)' },
            -- Award 50 credits for every 5 kills at or above 50
            { 50, 50, '+50 $currency_symbol (spree)' },
        },

        -- kill-combo required, credits awarded
        multi_kill = {
            { 2, 8, '+8 $currency_symbol (multi-kill)' },
            { 3, 10, '+10 $currency_symbol (multi-kill)' },
            { 4, 12, '+12 $currency_symbol (multi-kill)' },
            { 5, 14, '+14 $currency_symbol (multi-kill)' },
            { 6, 16, '+16 $currency_symbol (multi-kill)' },
            { 7, 18, '+18 $currency_symbol (multi-kill)' },
            { 8, 20, '+20 $currency_symbol (multi-kill)' },
            { 9, 23, '+23 $currency_symbol (multi-kill)' },
            -- Award 25 credits every 2 kills at or above 10 kill-combos
            { 10, 25, '+25 $currency_symbol (multi-kill)' },
        },

        tags = {

            --
            -- tag {type, name, credits}
            --

            -- FALL DAMAGE --
            --

            damage = {

                { 'jpt!', 'globals\\falling', -3, '-3 $currency_symbol (Fall Damage)' },
                { 'jpt!', 'globals\\distance', -4, '-4 $currency_symbol (Distance Damage)' },

                -- VEHICLE PROJECTILES --
                --
                { 'jpt!', 'vehicles\\ghost\\ghost bolt', 7, '+7 $currency_symbol (Ghost Bolt)' },
                { 'jpt!', 'vehicles\\scorpion\\bullet', 6, '+6 $currency_symbol (Tank Bullet)' },
                { 'jpt!', 'vehicles\\warthog\\bullet', 6, '+6 $currency_symbol (Warthog Bullet)' },
                { 'jpt!', 'vehicles\\c gun turret\\mp bolt', 7, '+7 $currency_symbol (Turret Bolt)' },
                { 'jpt!', 'vehicles\\banshee\\banshee bolt', 7, '+7 $currency_symbol (Banshee Bolt)' },
                { 'jpt!', 'vehicles\\scorpion\\shell explosion', 10, '+10 $currency_symbol (Tank Shell)' },
                { 'jpt!', 'vehicles\\banshee\\mp_fuel rod explosion', 10, '+10 $currency_symbol (Banshee Fuel-Rod Explosion)' },

                -- WEAPON PROJECTILES --
                --
                { 'jpt!', 'weapons\\pistol\\bullet', 5, '+5 $currency_symbol (Pistol Bullet)' },
                { 'jpt!', 'weapons\\shotgun\\pellet', 6, '+6 $currency_symbol (Shotgun Pallet)' },
                { 'jpt!', 'weapons\\plasma rifle\\bolt', 4, '+4 $currency_symbol (Plasma Rifle Bolt)' },
                { 'jpt!', 'weapons\\needler\\explosion', 8, '+8 $currency_symbol (Needler Explosion)' },
                { 'jpt!', 'weapons\\plasma pistol\\bolt', 4, '+4 $currency_symbol (Plasma Bolt)' },
                { 'jpt!', 'weapons\\assault rifle\\bullet', 5, '+5 $currency_symbol (Assault Rifle Bullet)' },
                { 'jpt!', 'weapons\\needler\\impact damage', 4, '+4 $currency_symbol (Needler Impact Damage)' },
                { 'jpt!', 'weapons\\flamethrower\\explosion', 5, '+5 $currency_symbol (Flamethrower)' },
                { 'jpt!', 'weapons\\flamethrower\\burning', 5, '+5 $currency_symbol (Flamethrower)' },
                { 'jpt!', 'weapons\\flamethrower\\impact damage', 5, '+5 $currency_symbol (Flamethrower)' },
                { 'jpt!', 'weapons\\rocket launcher\\explosion', 8, '+8 $currency_symbol (Rocket Launcher Explosion)' },
                { 'jpt!', 'weapons\\needler\\detonation damage', 3, '+3 $currency_symbol (Needler Detonation Damage)' },
                { 'jpt!', 'weapons\\plasma rifle\\charged bolt', 4, '+4 $currency_symbol (Plasma Rifle Bolt)' },
                { 'jpt!', 'weapons\\sniper rifle\\sniper bullet', 6, '+6 $currency_symbol (Sniper Rifle Bullet)' },
                { 'jpt!', 'weapons\\plasma_cannon\\effects\\plasma_cannon_explosion', 8, '+8 $currency_symbol (Plasma Cannon Explosion)' },

                -- GRENADES --
                --
                { 'jpt!', 'weapons\\frag grenade\\explosion', 8, '+8 $currency_symbol (Frag Explosion)' },
                { 'jpt!', 'weapons\\plasma grenade\\attached', 7, '+7 $currency_symbol (Plasma Grenade - attached)' },
                { 'jpt!', 'weapons\\plasma grenade\\explosion', 5, '+5 $currency_symbol (Plasma Grenade explosion)' },

                -- MELEE --
                --
                { 'jpt!', 'weapons\\flag\\melee', 5, '+5 $currency_symbol (Melee: Flag)' },
                { 'jpt!', 'weapons\\ball\\melee', 5, '+5 $currency_symbol (Melee: Ball)' },
                { 'jpt!', 'weapons\\pistol\\melee', 4, '+4 $currency_symbol (Melee: Pistol)' },
                { 'jpt!', 'weapons\\needler\\melee', 4, '+4 $currency_symbol (Melee: Needler)' },
                { 'jpt!', 'weapons\\shotgun\\melee', 5, '+5 $currency_symbol (Melee: Shotgun)' },
                { 'jpt!', 'weapons\\flamethrower\\melee', 5, '+5 $currency_symbol (Melee: Flamethrower)' },
                { 'jpt!', 'weapons\\sniper rifle\\melee', 5, '+5 $currency_symbol (Melee: Sniper Rifle)' },
                { 'jpt!', 'weapons\\plasma rifle\\melee', 4, '+4 $currency_symbol (Melee: Plasma Rifle)' },
                { 'jpt!', 'weapons\\plasma pistol\\melee', 4, '+4 $currency_symbol (Melee: Plasma Pistol)' },
                { 'jpt!', 'weapons\\assault rifle\\melee', 4, '+4 $currency_symbol (Melee: Assault Rifle)' },
                { 'jpt!', 'weapons\\rocket launcher\\melee', 10, '+10 $currency_symbol (Melee: Rocket Launcher)' },
                { 'jpt!', 'weapons\\plasma_cannon\\effects\\plasma_cannon_melee', 10, '+10 $currency_symbol (Melee: Plasma Cannon)' },
            },

            -- VEHICLE COLLISION --
            --
            collision = { 'jpt!', 'globals\\vehicle_collision' },
            vehicles = {
                { 'vehi', 'vehicles\\ghost\\ghost_mp', 5, '+5 $currency_symbol (Vehicle Squash: GHOST)' },
                { 'vehi', 'vehicles\\rwarthog\\rwarthog', 6, '+6 $currency_symbol (Vehicle Squash: R-Hog)' },
                { 'vehi', 'vehicles\\warthog\\mp_warthog', 7, '+7 $currency_symbol (Vehicle Squash: Warthog)' },
                { 'vehi', 'vehicles\\banshee\\banshee_mp', 8, '+8 $currency_symbol (Vehicle Squash: Banshee)' },
                { 'vehi', 'vehicles\\scorpion\\scorpion_mp', 10, '+10 $currency_symbol (Vehicle Squash: Tank)' },
                { 'vehi', 'vehicles\\c gun turret\\c gun turret_mp', 1000, '+1000 $currency_symbol (Vehicle Squash: Turret)' },
            }
        }
    },


    -- STAR OF THE SHOW --
    -- This table defines all rank requirements:
    -- Add as many grades to each rank as you like.
    ranks = {
        [1] = {
            rank = "Recruit",
            grade = {
                [1] = 0
            }
        },
        [2] = {
            rank = "Apprentice",
            grade = {
                [1] = 3000,
                [2] = 6000
            }
        },
        [3] = {
            rank = "Private",
            grade = {
                [1] = 9000,
                [2] = 12000
            }
        },
        [4] = {
            rank = "Corporal",
            grade = {
                [1] = 13000,
                [2] = 14000
            }
        },
        [5] = {
            rank = "Sergeant",
            grade = {
                [1] = 15000,
                [2] = 16000,
                [3] = 17000,
                [4] = 18000
            }
        },
        [6] = {
            rank = "Gunnery Sergeant",
            grade = {
                [1] = 19000,
                [2] = 20000,
                [3] = 21000,
                [4] = 22000
            }
        },
        [7] = {
            rank = "Lieutenant",
            grade = {
                [1] = 23000,
                [2] = 24000,
                [3] = 25000,
                [4] = 26000
            }
        },
        [8] = {
            rank = "Captain",
            grade = {
                [1] = 27000,
                [2] = 28000,
                [3] = 29000,
                [4] = 30000
            }
        },
        [9] = {
            rank = "Major",
            grade = {
                [1] = 31000,
                [2] = 32000,
                [3] = 33000,
                [4] = 34000
            }
        },
        [10] = {
            rank = "Commander",
            grade = {
                [1] = 35000,
                [2] = 36000,
                [3] = 37000,
                [4] = 38000
            }
        },
        [11] = {
            rank = "Colonel",
            grade = {
                [1] = 39000,
                [2] = 40000,
                [3] = 41000,
                [4] = 42000
            }
        },
        [12] = {
            rank = "Brigadier",
            grade = {
                [1] = 43000,
                [2] = 44000,
                [3] = 45000,
                [4] = 46000
            }
        },
        [13] = {
            rank = "General",
            grade = {
                [1] = 47000,
                [2] = 48000,
                [3] = 49000,
                [4] = 50000
            }
        }
    }
}
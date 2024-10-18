--[[
--=====================================================================================================--
Script Name: Loadout (v1.9), for SAPP (PC & CE)

~ acknowledgements ~
Concept credit goes to OSH Clan, a gaming community operating on Halo CE:
website: https://oldschoolhalo.boards.net/

Special thanks:
xOSHx Yalda (script concept, alpha testing, bug reporting)
xOSHx Adio (alpha testing, bug reporting)
xOSHx djp1 (alpha testing, bug reporting)
xOSHx Thus (alpha testing)
community (playing during alpha)

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local Loadout = {

    --=================================================================================--
    -- CONFIGURATION STARTS --
    --=================================================================================--

    -- This is the class players will start with when they join the server:
    default_class = "Regeneration",
    -- This is the starting level for the above class:
    starting_level = 1,

    --============== SET-LEVEL COMMAND ==============--
    -- Command Syntax: /level_cmd [number: 1-16] | */all | me <level>
    level_cmd = "level",
    -- Minimum permission level required to execute /level_cmd
    level_cmd_permission = 1,
    -- Minimum permission level required to execute /level_cmd on other players (besides yourself)
    level_cmd_permission_others = 4,
    --==============================================================================================--

    --============== CREDITS COMMAND ==============--
    -- Command Syntax: /credits_cmd [number: 1-16] | */all | me <credits>
    credits_cmd = "credits",
    -- Minimum permission level required to execute /credits_cmd
    credits_cmd_permission = 1,
    -- Minimum permission level required to execute /credits_cmd on other players (besides yourself)
    credits_cmd_permission_others = 4,
    --==============================================================================================--

    --============== BOUNTY COMMAND ==============--
    -- Command Syntax: /bounty_cmd [number: 1-16] | */all | me <bounty>
    bounty_cmd = "bounty",
    -- Minimum permission level required to execute /bounty_cmd
    bounty_cmd_permission = 1,
    -- Minimum permission level required to execute /bounty_cmd on other players (besides yourself)
    bounty_cmd_permission_others = 4,
    --==============================================================================================--

    -- If true, a player's credits and score will be able to fall into the negatives.
    allow_negatives = false,

    -- Enable or disable HUD:
    show_hud = true,

    -- If the server needs to send a message to RCON,
    -- we need to temporarily disable the HUD to prevent it from overwriting other information.
    -- How long should it disappear for?
    hud_pause_duration = 5,

    -- Command used to display information about your current class:
    info_command = "help",

    -- If a player types /info_command, how long should the information be on screen for? (in seconds)
    help_hud_duration = 5,

    -- Time (in seconds) a player must return to the server before their credits are reset.
    disconnect_cooldown = 120,

    -- If true, a player will receive spawn protection after X death spree:
    death_sprees_bonus = true,

    -- If true, this script will change a players armor based on their class (and team)
    modify_armor_color = false,

    -- =========================== --
    -- SCORE LIMIT SETTINGS --
    -- =========================== --
    scorelimits = {
        -- TEAM
        ["ctf"] = { 3 },
        -- FFA | TEAM
        ["slayer"] = { 3000, 3500 },
        ["race"] = { 2500, 3000 },
    },

    -- Toggle t-bag on or off:
    --
    tbag = true,
    -- Radius (in world units) a player must be to trigger a t-bag
    tbag_trigger_radius = 2,

    -- A player's death coordinates expire after this many seconds;
    tbag_coordinate_expiration = 30,

    -- A player must crouch over a victim's body this many times in order to trigger the t-bag scenario
    tbag_crouch_count = 3,
    --

    messages = {
        [1] = "%name% has a bounty of +%bounty% cR! - Kill to claim!",
        [2] = "%name% collected the bounty of %bounty% credits on %victim%!",
        [3] = {
            "Adding +%bounty% bounty points. Total: %total_bounty%cR",
            "Adding +%bounty% bounty points to %name%. Total: %total_bounty%",
            "%target% has a bounty of %total_bounty%cR - Kill to Claim!",
        },
        [4] = {
            "Your level has been set to %level%",
            "Setting %name% to level %level%",
        },
        [5] = {
            "Your credits have been set to %credits%",
            "Setting %name%'s credits to %credits%",
        },
        [6] = "Invalid level! Please enter a number between 1-%max%",
        [7] = "You are already level %level%",
        [8] = "Credits cannot be higher than %max%",
        [9] = "You do not have permission to execute this command.",
        [10] = "You do not have permission to execute this command on other players",

        -- On Level Up:
        [11] = "%name% is now level [%level%] %class%",

        -- For T-Bagging:
        [12] = "%name% is t-bagging %victim%",
    },

    classes = {
        ["Regeneration"] = {
            color = {
                ffa = "purple",
                team = {
                    red = "purple",
                    blue = "teal",
                }
            },
            command = "regen",
            hud = "Class: [Regen] Level: [%lvl%] Credits: [%cr%/%cr_req%] State: [%state%]",
            info = {
                "Regeneration: Good for players who want the classic Halo experience. This is the Default.",
                "Level 1 - Health regenerates 3 seconds after shields recharge, at 20%/second.",
                "Level 2 - 2 Second Delay after shields recharge, at 25%/second. Unlocks Weapon 3.",
                "Level 3 - 1 Second Delay after shields recharge, at 30%/second. Melee damage is increased to 200%",
                "Level 4 - Health regenerates as soon as shields recharge, at 35%/second. You now spawn with full grenade count.",
                "Level 5 - Shields now charge 1 second sooner as well.",
            },
            levels = {
                [1] = {
                    -- Health will start regenerating this many seconds after shields regenerate to full:
                    regen_delay = 0,

                    -- Amount of health regenerated. (1 is full health)
                    increment = 0.0200,

                    -- Time (in seconds) between each incremental increase in health:
                    regen_rate = 1,

                    -- Credits required to level up:
                    until_next_level = 200,

                    -- Nil = normal shield regen delay. (Set in milliseconds at or above 50)
                    shield_regen_delay = nil,

                    -- GRENADES | <frag/plasma> (set to nil to use default grenade settings)
                    grenades = { 2, 0 },

                    -- Weapon Assignments:
                    weapons = {

                        -- [Weapon Index] {ammo loaded, ammo unloaded, battery age}
                        stock_maps = {
                            [1] = { nil, nil, nil }, -- pistol
                            [7] = { nil, nil, nil }, -- assault rifle
                        },

                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [19] = { nil, nil, nil }, -- pistol
                                [24] = { nil, nil, nil }, -- assault rifle
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, nil, nil }, -- magnum
                                [32] = { nil, nil, nil }, -- assault rifle
                            },
                        }
                    }
                },
                [2] = {
                    regen_delay = 0,
                    increment = 0.0350,
                    regen_rate = 1,
                    until_next_level = 500,
                    grenades = { 3, 0 },
                    shield_regen_delay = nil,
                    weapons = {
                        stock_maps = {
                            [1] = { nil, 60, nil }, -- pistol
                            [7] = { nil, 240, nil }, -- assault rifle
                            [2] = { nil, 12, nil }, -- sniper
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [19] = { nil, 60, nil }, -- pistol
                                [24] = { nil, 240, nil }, -- assault rifle
                                [26] = { nil, 108, nil }, -- battle rifle
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, 60, nil }, -- magnum
                                [32] = { nil, 240, nil }, -- assault rifle
                                [43] = { nil, 60, nil }, -- dmr
                            },
                        }
                    }
                },
                [3] = {
                    regen_delay = 0,
                    increment = 0.0450,
                    regen_rate = 1,
                    until_next_level = 1000,
                    shield_regen_delay = nil,
                    grenades = { 3, 2 },
                    weapons = {
                        stock_maps = {
                            [1] = { nil, 72, nil }, -- pistol
                            [7] = { nil, 300, nil }, -- assault rifle
                            [2] = { nil, 16, nil }, -- sniper
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [19] = { nil, 72, nil }, -- pistol
                                [24] = { nil, 300, nil }, -- assault rifle
                                [26] = { nil, 140, nil }, -- battle rifle
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, 72, nil }, -- magnum
                                [32] = { nil, 300, nil }, -- assault rifle
                                [43] = { nil, 72, nil }, -- dmr
                            },
                        }
                    }
                },
                [4] = {
                    regen_delay = 0,
                    increment = 0.0550,
                    regen_rate = 1,
                    until_next_level = 2000,
                    shield_regen_delay = nil,
                    grenades = { 4, 4 },
                    weapons = {
                        stock_maps = {
                            [1] = { nil, 84, nil }, -- pistol
                            [7] = { nil, 360, nil }, -- assault rifle
                            [2] = { nil, 20, nil }, -- sniper
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [19] = { nil, 84, nil }, -- pistol
                                [24] = { nil, 360, nil }, -- assault rifle
                                [26] = { nil, 172, nil }, -- battle rifle
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, 84, nil }, -- magnum
                                [32] = { nil, 360, nil }, -- assault rifle
                                [43] = { nil, 84, nil }, -- dmr
                            },
                        }
                    }
                },
                [5] = {
                    regen_delay = 0,
                    increment = 0.1000,
                    regen_rate = 1,
                    until_next_level = nil,
                    shield_regen_delay = 50,
                    grenades = { 5, 5 },
                    weapons = {
                        stock_maps = {
                            [1] = { nil, 168, nil }, -- pistol
                            [7] = { nil, 840, nil }, -- assault rifle
                            [2] = { nil, 48, nil }, -- sniper
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [19] = { nil, 168, nil }, -- pistol
                                [24] = { nil, 840, nil }, -- assault rifle
                                [26] = { nil, 344, nil }, -- battle rifle
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, 168, nil }, -- magnum
                                [32] = { nil, 840, nil }, -- assault rifle
                                [43] = { nil, 168, nil }, -- dmr
                            },
                        }
                    }
                }
            }
        },

        ["Armor Boost"] = {
            color = {
                ffa = "black",
                team = {
                    red = "black",
                    blue = "orange",
                }
            },
            command = "armor",
            hud = "Class: [Armor] Level: [%lvl%] Credits: [%cr%/%cr_req%] %state%",
            info = {
                "Armor Boost: Good for players who engage vehicles or defend.",
                "Level 1 - 1.20x durability.",
                "Level 2 - 1.30x durability. Unlocks Weapon 3.",
                "Level 3 - 1.40x durability. Melee damage is increased to 200%",
                "Level 4 - 1.50x durability. You now spawn with full grenades.",
                "Level 5 - 1.55x durability. You are now immune to falling damage in addition to all other perks in this class.",
            },
            levels = {
                [1] = {
                    until_next_level = 200,

                    -- Set to 0 to use default damage resistance:
                    -- Foot Resistance | Vehicle Resistance
                    damage_resistance = { 1.25, 1.27 },

                    -- Set to true to enable fall damage immunity:
                    fall_damage_immunity = false,

                    -- Set to true to enable self-harm:
                    self_damage = true,

                    melee_damage_multiplier = 1.20,
                    grenades = { 2, 0 },
                    weapons = {
                        stock_maps = {
                            [10] = { nil, nil, nil }, -- shotgun
                            [1] = { nil, nil, nil }, -- pistol
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [19] = { nil, nil, nil }, -- pistol
                                [21] = { nil, nil, nil }, -- shotgun
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, nil, nil }, -- magnum
                                [40] = { nil, nil, nil }, -- shotgun
                            },
                        }
                    }
                },
                [2] = {
                    until_next_level = 500,
                    damage_resistance = { 1.35, 1.37 },
                    fall_damage_immunity = false,
                    self_damage = true,
                    melee_damage_multiplier = 1.25,
                    grenades = { 3, 0 },
                    weapons = {
                        stock_maps = {
                            [10] = { nil, 24, nil }, -- shotgun
                            [1] = { nil, 60, nil }, -- pistol
                            [3] = { nil, nil, 100 }, -- fuelrod
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [19] = { nil, 60, nil }, -- pistol
                                [21] = { nil, 24, nil }, -- shotgun
                                [23] = { nil, 60, nil }, -- dmr
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, 60, nil }, -- magnum
                                [40] = { nil, 24, nil }, -- shotgun
                                [42] = { nil, nil, 120 }, -- spartan laser
                            },
                        }
                    }
                },
                [3] = {
                    until_next_level = 1000,
                    damage_resistance = { 1.45, 1.47 },
                    fall_damage_immunity = false,
                    self_damage = true,
                    melee_damage_multiplier = 1.30,
                    grenades = { 3, 2 },
                    weapons = {
                        stock_maps = {
                            [10] = { nil, 48, nil }, -- shotgun
                            [1] = { nil, 72, nil }, -- pistol
                            [3] = { nil, nil, 100 }, -- fuelrod
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [19] = { nil, 72, nil }, -- pistol
                                [21] = { nil, 48, nil }, -- shotgun
                                [23] = { nil, 72, nil }, -- dmr
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, 72, nil }, -- magnum
                                [40] = { nil, 48, nil }, -- shotgun
                                [42] = { nil, nil, 140 }, -- spartan laser
                            },
                        }
                    }
                },
                [4] = {
                    until_next_level = 2000,
                    damage_resistance = { 1.55, 1.57 },
                    fall_damage_immunity = false,
                    self_damage = true,
                    melee_damage_multiplier = 1.45,
                    grenades = { 4, 4 },
                    weapons = {
                        stock_maps = {
                            [10] = { nil, 96, nil }, -- shotgun
                            [1] = { nil, 84, nil }, -- pistol
                            [3] = { nil, nil, 100 }, -- fuelrod
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [19] = { nil, 84, nil }, -- pistol
                                [21] = { nil, 96, nil }, -- shotgun
                                [23] = { nil, 84, nil }, -- dmr
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, 84, nil }, -- magnum
                                [40] = { nil, 96, nil }, -- shotgun
                                [42] = { nil, nil, 160 }, -- spartan laser
                            },
                        }
                    }
                },
                [5] = {
                    until_next_level = nil,
                    damage_resistance = { 1.65, 1.67 },
                    fall_damage_immunity = true,
                    self_damage = false,
                    melee_damage_multiplier = 1.50,
                    grenades = { 5, 5 },
                    weapons = {
                        stock_maps = {
                            [10] = { nil, 192, nil }, -- shotgun
                            [1] = { nil, 168, nil }, -- pistol
                            [3] = { nil, nil, 100 }, -- fuelrod
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [19] = { nil, 168, nil }, -- pistol
                                [21] = { nil, 192, nil }, -- shotgun
                                [23] = { nil, 168, nil }, -- dmr
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, 168, nil }, -- magnum
                                [40] = { nil, 192, nil }, -- shotgun
                                [42] = { nil, nil, 180 }, -- spartan laser
                            },
                        }
                    }
                }
            }
        },

        ["Cloak"] = {
            color = {
                ffa = "cyan",
                team = {
                    red = "cyan",
                    blue = "blue",
                }
            },
            command = "cloak",
            hud = "Class: [Cloak] Level: [%lvl%] Credits: [%cr%/%cr_req%] State: [%state%]",
            info = {
                "Partial Camo: Good for players who prefer stealth and quick kills or CQB.",
                "Level 1 - Camo works until you fire your weapon or take damage. Reinitialize delays are 3s/Weapon, 5s/Damage",
                "Level 2 - Reinitialize delays are 2s/Weapon, 5s/Damage. Unlocks Weapon 3.",
                "Level 3 - Reinitialize delays are 2s/Weapon, 3s/Damage. Melee damage is increased to 200%",
                "Level 4 - Reinitialize delays are 1s/Weapon, 3s/Damage. You now spawn with full grenades.",
                "Level 5 - Reinitialize delays are 0.5s/Weapon, 2s/Damage.",
            },
            levels = {
                [1] = {
                    -- Time (in seconds) that camo lasts:
                    duration = 10,
                    -- If you receive damage or fire your weapon, your camo is disabled and will reinitialize after this many seconds:
                    reinitialize_delay = 8,
                    until_next_level = 200,
                    grenades = { 2, 0 },
                    weapons = {
                        stock_maps = {
                            [1] = { nil, nil, nil }, -- pistol
                            [10] = { nil, nil, nil }, -- shotgun
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [21] = { nil, nil, nil }, -- shotgun
                                [17] = { nil, nil, nil }, -- silenced battle rifle
                            },
                            ["Bigassv2,104"] = {
                                [45] = { nil, nil, nil }, -- magnum
                                [40] = { nil, nil, nil }, -- shotgun
                            },
                        }
                    }
                },
                [2] = {
                    duration = 15,
                    reinitialize_delay = 8,
                    until_next_level = 500,
                    grenades = { 3, 0 },
                    weapons = {
                        stock_maps = {
                            [1] = { nil, 60, nil }, -- pistol
                            [10] = { nil, 24, nil }, -- shotgun
                            [8] = { nil, 300, nil }, -- flamethrower
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [21] = { nil, 24, nil }, -- shotgun
                                [17] = { nil, 108, nil }, -- silenced battle rifle
                                [18] = { nil, nil, 120 }, -- plasma rifle
                            },
                            ["Bigassv2,104"] = {
                                [45] = { nil, 60, nil }, -- magnum
                                [40] = { nil, 24, nil }, -- shotgun
                                [43] = { nil, 60, nil }, -- dmr
                            },
                        }
                    }
                },
                [3] = {
                    duration = 20,
                    reinitialize_delay = 8,
                    until_next_level = 1000,
                    grenades = { 3, 2 },
                    weapons = {
                        stock_maps = {
                            [1] = { nil, 72, nil }, -- pistol
                            [10] = { nil, 48, nil }, -- shotgun
                            [8] = { nil, 500, nil }, -- flamethrower
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [21] = { nil, 48, nil }, -- shotgun
                                [17] = { nil, 144, nil }, -- silenced battle rifle
                                [18] = { nil, nil, 140 }, -- plasma rifle
                            },
                            ["Bigassv2,104"] = {
                                [45] = { nil, 72, nil }, -- magnum
                                [40] = { nil, 48, nil }, -- shotgun
                                [43] = { nil, 72, nil }, -- dmr
                            },
                        }
                    }
                },
                [4] = {
                    duration = 25,
                    reinitialize_delay = 0,
                    until_next_level = 2000,
                    grenades = { 4, 4 },
                    weapons = {
                        stock_maps = {
                            [1] = { nil, 84, nil }, -- pistol
                            [10] = { nil, 96, nil }, -- shotgun
                            [8] = { nil, 700, nil }, -- flamethrower
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [21] = { nil, 96, nil }, -- shotgun
                                [17] = { nil, 180, nil }, -- silenced battle rifle
                                [18] = { nil, nil, 160 }, -- plasma rifle
                            },
                            ["Bigassv2,104"] = {
                                [45] = { nil, 84, nil }, -- magnum
                                [40] = { nil, 96, nil }, -- shotgun
                                [43] = { nil, 84, nil }, -- dmr
                            },
                        }
                    }
                },
                [5] = {
                    duration = 1000,
                    reinitialize_delay = 0,
                    until_next_level = nil,
                    grenades = { 5, 5 },
                    weapons = {
                        stock_maps = {
                            [1] = { nil, 168, nil }, -- pistol
                            [10] = { nil, 192, nil }, -- shotgun
                            [8] = { nil, 1400, nil }, -- flamethrower
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [21] = { nil, 192, nil }, -- shotgun
                                [17] = { nil, 360, nil }, -- silenced battle rifle
                                [18] = { nil, nil, 320 }, -- plasma rifle
                            },
                            ["Bigassv2,104"] = {
                                [45] = { nil, 168, nil }, -- magnum
                                [40] = { nil, 192, nil }, -- shotgun
                                [43] = { nil, 168, nil }, -- dmr
                            },
                        }
                    }
                }
            }
        },

        ["Recon"] = {
            color = {
                ffa = "salmon",
                team = {
                    red = "salmon",
                    blue = "pink",
                }
            },
            command = "recon",
            hud = "Class: [Recon] Level: [%lvl%] Credits: [%cr%/%cr_req%] State: %state%",
            info = {
                "Recon: Good for players who don't use vehicles. Also good for capturing.",
                "Level 1 - Default speed raised to 1.5x. Sprint duration is 200%.",
                "Level 2 - Default speed raised to 1.6x. Sprint duration is 225%. Unlocks Weapon 3.",
                "Level 3 - Default speed raised to 1.7x. Sprint duration is 250%. Melee damage is increased to 200%.",
                "Level 4 - Default speed raised to 1.8x. Sprint duration is 300%. You now spawn with full grenades.",
                "Level 5 - Sprint speed is raised from 2.5x to 3x in addition to all other perks in this class.",
            },
            levels = {
                [1] = {
                    -- Speed boost multiplier (1 = normal speed):
                    speed = 2,
                    -- Time (in seconds) speed boost lasts for:
                    speed_duration = 10,
                    until_next_level = 200,
                    grenades = { 2, 0 },
                    weapons = {
                        stock_maps = {
                            [1] = { nil, nil, nil }, -- pistol
                            [7] = { nil, nil, nil }, -- assault rifle
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [24] = { nil, nil, nil }, -- assault rifle
                                [27] = { nil, nil, nil }, -- covenant carbine (auto carbine)
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, nil, nil }, -- magnum
                                [44] = { nil, nil, nil }, -- ma5k
                            },
                        }
                    }
                },
                [2] = {
                    speed = 2,
                    speed_duration = 12,
                    until_next_level = 500,
                    grenades = { 3, 0 },
                    weapons = {
                        stock_maps = {
                            [1] = { nil, 60, nil }, -- pistol
                            [7] = { nil, 240, nil }, -- assault rifle
                            [10] = { nil, 24, nil }, -- shotgun
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [24] = { nil, nil, nil }, -- assault rifle
                                [27] = { nil, 72, nil }, -- covenant carbine (auto carbine)
                                [21] = { nil, 24, nil }, -- shotgun
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, 60, nil }, -- magnum
                                [44] = { nil, 90, nil }, -- ma5k
                                [40] = { nil, 24, nil }, -- shotgun
                            },
                        }
                    }
                },
                [3] = {
                    speed = 2,
                    speed_duration = 15,
                    until_next_level = 1000,
                    grenades = { 3, 2 },
                    weapons = {
                        [1] = { nil, 72, nil }, -- pistol
                        [7] = { nil, 300, nil }, -- assault rifle
                        [10] = { nil, 48, nil }, -- shotgun

                    },
                    custom_maps = {
                        ["TSCE_MultiplayerV1"] = {
                            [24] = { nil, nil, nil }, -- assault rifle
                            [27] = { nil, 90, nil }, -- covenant carbine (auto carbine)
                            [21] = { nil, 48, nil }, -- shotgun
                        },
                        ["Bigassv2,104"] = {
                            [33] = { nil, 72, nil }, -- magnum
                            [44] = { nil, 120, nil }, -- ma5k
                            [40] = { nil, 48, nil }, -- shotgun
                        },
                    }
                },
                [4] = {
                    speed = 2,
                    speed_duration = 18,
                    until_next_level = 2000,
                    grenades = { 4, 4 },
                    weapons = {
                        stock_maps = {
                            [1] = { nil, 84, nil }, -- pistol
                            [7] = { nil, 360, nil }, -- assault rifle
                            [10] = { nil, 96, nil }, -- shotgun
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [24] = { nil, nil, nil }, -- assault rifle
                                [27] = { nil, 108, nil }, -- covenant carbine (auto carbine)
                                [21] = { nil, 96, nil }, -- shotgun
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, 84, nil }, -- magnum
                                [44] = { nil, 150, nil }, -- ma5k
                                [40] = { nil, nil, nil }, -- shotgun
                            },
                        }
                    }
                },
                [5] = {
                    speed = 2.5,
                    speed_duration = 20,
                    until_next_level = nil,
                    grenades = { 5, 5 },
                    weapons = {
                        stock_maps = {
                            [1] = { nil, 168, nil }, -- pistol
                            [7] = { nil, 840, nil }, -- assault rifle
                            [10] = { nil, 192, nil }, -- shotgun
                        },
                        custom_maps = {
                            ["TSCE_MultiplayerV1"] = {
                                [24] = { nil, nil, nil }, -- assault rifle
                                [27] = { nil, 216, nil }, -- covenant carbine (auto carbine)
                                [21] = { nil, 192, nil }, -- shotgun
                            },
                            ["Bigassv2,104"] = {
                                [33] = { nil, 168, nil }, -- magnum
                                [44] = { nil, 300, nil }, -- ma5k
                                [40] = { nil, 192, nil }, -- shotgun
                            },
                        }
                    }
                }
            }
        }
    },
    credits = {

        -- If true, players will receive a bonus based on the difference (percentage)
        -- between your kdr and theirs (only awarded if the victim has a higher kdr than you).
        use_pvp_bonus = true,

        -- PvP Bonus Formula:
        -- victim kdr - killer kdr / offset * flat-rate

        -- {Flat-Rate, Offset, Message}
        pvp_bonus = { 5, 1.5, "+%credits%cR (Show Stopper Bonus)" },

        -- Bonus credits for killing the flag carrier
        flag_carrier_kill_bonus = { 100, "+30cR (Flag Carrier Kill Bonus)" },

        -- Score (credits added):
        score = { 100, "+100cR (Flag Cap)" },

        head_shot = { 5, "+5cR (head shot!)" },

        -- Killed by Server (credits deducted):
        server = { -0, "" },

        tbag = { 5, "5+cR (T-Bagging)" },

        -- killed by guardians (credits deducted):
        guardians = { -5, "-5cR (Killed by Guardians)" },

        -- suicide (credits deducted):
        suicide = { -10, "-10cR (Suicide)" },

        -- betrayal (credits deducted):
        betrayal = { -15, "-15cR (Betrayal)" },

        -- Killed from the grave (credits added to killer)
        killed_from_the_grave = { 5, "+5cR (Killed From Grave)" },

        -- Bonus Credits given to someone when they capture the flag:
        bounty_on_score = 1,

        -- Bonus Credits per bounty level:
        bounty_bonus = 25,

        -- Bonus credits for killing someone in a vehicle:
        vehicle_kill = { 5, "+5cR (Vehicle Kill)" },

        -- Bonus points for getting the first kill
        first_blood = { 30, "+30cR (First Blood)" },

        -- {consecutive kills, xp rewarded, "message sent", bounty level added}
        spree = {
            { 5, 5, "+5cR (spree)", 1 },
            { 10, 10, "+10cR (spree)", 2 },
            { 15, 15, "+15cR (spree)", 3 },
            { 20, 20, "+20cR (spree)", 4 },
            { 25, 25, "+25cR (spree)", 5 },
            { 30, 30, "+30cR (spree)", 6 },
            { 35, 35, "+35cR (spree)", 7 },
            { 40, 40, "+40cR (spree)", 8 },
            { 45, 45, "+45cR (spree)", 9 },
            -- Award 50 credits for every 5 kills at or above 50 and +10 bounty level
            { 50, 50, "+50cR (spree)", 10 },
        },

        -- kill-combo required, credits awarded
        multi_kill = {
            { 2, 8, "+8cR (multi-kill)" },
            { 3, 10, "+10cR (multi-kill)" },
            { 4, 12, "+12cR (multi-kill)" },
            { 5, 14, "+14cR (multi-kill)" },
            { 6, 16, "+16cR (multi-kill)" },
            { 7, 18, "+18cR (multi-kill)" },
            { 8, 20, "+20cR (multi-kill)" },
            { 9, 23, "+23cR (multi-kill)" },
            -- Award 25 credits every 2 kills at or above 10 kill-combos
            { 10, 25, "+25cR (multi-kill)" },
        },

        tags = {

            --
            -- tag {type, name, credits, message}
            --

            fall_damage = {
                -- stock --
                { "jpt!", "globals\\falling", -3, "-3cR (Fall Damage)", },
                { "jpt!", "globals\\distance", -4, "-4cR (Distance Damage)" },
                --
            },

            vehicle_projectiles = {
                -- stock --
                { "jpt!", "vehicles\\ghost\\ghost bolt", 7, "+7cR (Ghost Bolt)" },
                { "jpt!", "vehicles\\scorpion\\bullet", 6, "+6cR (Tank Bullet)" },
                { "jpt!", "vehicles\\warthog\\bullet", 6, "+6cR (Warthog Bullet)" },
                { "jpt!", "vehicles\\c gun turret\\mp bolt", 7, "+7cR (Turret Bolt)" },
                { "jpt!", "vehicles\\banshee\\banshee bolt", 7, "+7cR (Banshee Bolt)" },
                { "jpt!", "vehicles\\scorpion\\shell explosion", 10, "+10cR (Tank Shell)" },
                { "jpt!", "vehicles\\banshee\\mp_fuel rod explosion", 10, "+10cR (Banshee Fuel-Rod Explosion)" },
                --
                -- TSCE_MultiplayerV1:
                { "jpt!", "cmt\\vehicles\\evolved_h1-spirit\\ghost\\weapons\\ghost_cannon\\damage_effects\\ghost_cannon_bolt_impact", 7, "+7cR (Ghost Bolt)" },
                { "jpt!", "cmt\\vehicles\\evolved_h1-spirit\\warthog\\weapons\\warthog_turret\\damage_effects\\warthog_turret_bullet_impact", 6, "+6cR (Warthog Bullet)" },
                { "jpt!", "cmt\\vehicles\\evolved_h1-spirit\\scorpion\\weapons\\scorpion_cannon\\damage_effects\\scorpion_cannon_shell_explosion", 10, "+10cR (Tank Shell)" },
                { "jpt!", "cmt\\vehicles\\evolved_h1-spirit\\scorpion\\weapons\\scorpion_chaingun\\damage_effects\\scorpion_chaingun_bullet_impact", 6, "+6cR (Tank Bullet)" },
                --
                -- Bigassv2,104:
                { "jpt!", "altis\\effects\\missile_impact", 7, "+7cR (Falcon Missile)" },
                { "jpt!", "vehicles\\scorpion\\bomb explosion", 10, "+10cR (Tank Shell)" },
                { "jpt!", "bourrin\\effects\\explosions\\medium\\small exp", 7, "+7cR (Falcon Missile)" },
                { "jpt!", "bourrin\\effects\\explosions\\medium\\warthog gauss explosion", 7, "+7cR (Gauss Hog)" },
            },

            weapon_projectiles = {
                -- stock --
                { "jpt!", "weapons\\pistol\\bullet", 5, "+5cR (Pistol Bullet)" },
                { "jpt!", "weapons\\shotgun\\pellet", 6, "+6cR (Shotgun Pallet)" },
                { "jpt!", "weapons\\plasma rifle\\bolt", 4, "+4cR (Plasma Rifle Bolt)" },
                { "jpt!", "weapons\\needler\\explosion", 8, "+8cR (Needler Explosion)" },
                { "jpt!", "weapons\\plasma pistol\\bolt", 4, "+4cR (Plasma Bolt)" },
                { "jpt!", "weapons\\assault rifle\\bullet", 5, "+5cR (Assault Rifle Bullet)" },
                { "jpt!", "weapons\\needler\\impact damage", 4, "+4cR (Needler Impact Damage)" },
                { "jpt!", "weapons\\flamethrower\\explosion", 10, "+10cR (Flamethrower)" },
                { "jpt!", "weapons\\flamethrower\\burning", 10, "+10cR (Flamethrower)" },
                { "jpt!", "weapons\\flamethrower\\impact damage", 10, "+10cR (Flamethrower)" },
                { "jpt!", "weapons\\rocket launcher\\explosion", 8, "+8cR (Rocket Launcher Explosion)" },
                { "jpt!", "weapons\\needler\\detonation damage", 3, "+3cR (Needler Detonation Damage)" },
                { "jpt!", "weapons\\plasma rifle\\charged bolt", 4, "+4cR (Plasma Rifle Bolt)" },
                { "jpt!", "weapons\\sniper rifle\\sniper bullet", 6, "+6cR (Sniper Rifle Bullet)" },
                { "jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion", 8, "+8cR (Plasma Cannon Explosion)" },
                --
                -- TSCE_MultiplayerV1:
                { "jpt!", "cmt\\weapons\\evolved_h1-spirit\\rocket_launcher\\damage_effects\\rocket_launcher_rocket_explosion", 8, "+8cR (Rocket Launcher Explosion)" },
                { "jpt!", "cmt\\weapons\\evolved_h1-spirit\\needler\\damage_effects\\needler_needle_explosion", 3, "+3cR (Needler)" },
                { "jpt!", "cmt\\weapons\\evolved_h1-spirit\\needler\\damage_effects\\needler_needle_detonation", 3, "+3cR (Needler)" },
                { "jpt!", "cmt\\weapons\\evolved_h1-spirit\\needler\\damage_effects\\needler_needle_impact", 3, "+3cR (Needler)" },
                { "jpt!", "cmt\\weapons\\evolved\\human\\battle_rifle\\damage_effects\\battle_rifle_bullet_impact silent", 5, "+5cR (Battle Rifle)" },
                { "jpt!", "cmt\\weapons\\evolved\\human\\battle_rifle\\damage_effects\\battle_rifle_bullet_impact", 5, "+5cR (Battle Rifle)" },
                { "jpt!", "cmt\\weapons\\evolved_h1-spirit\\plasma_rifle\\damage_effects\\plasma_rifle_bolt_impact", 4, "+4cR (Plasma Rifle Bolt)" },
                { "jpt!", "cmt\\weapons\\evolved_h1-spirit\\pistol\\damage_effects\\pistol_bullet_impact", 5, "+5cR (Pistol Bullet)" },
                { "jpt!", "cmt\\weapons\\covenant\\brute_plasma_rifle\\bolt", 4, "+4cR (Brute Plasma Rifle Bolt)" },
                { "jpt!", "cmt\\weapons\\evolved_h1-spirit\\shotgun\\damage_effects\\shotgun_pellet_impact", 6, "+6cR (Shotgun)" },
                { "jpt!", "cmt\\weapons\\evolved_h1-spirit\\sniper_rifle\\damage_effects\\sniper_rifle_bullet_impact", 6, "+6cR (Sniper Rifle Bullet)" },
                { "jpt!", "cmt\\weapons\\evolved\\human\\dmr\\damage_effects\\dmr_bullet_impact", 5, "+5cR (DMR Bullet)" },
                { "jpt!", "cmt\\weapons\\evolved_h1-spirit\\assault_rifle\\damage_effects\\assault_rifle_bullet", 5, "+5cR (Assault Rifle Bullet)" },
                { "jpt!", "cmt\\weapons\\evolved\\human\\rocket_launcher\\damage_effects\\rocket_launcher_rocket_explosion", 8, "+8cR (Rocket Launcher Explosion)" },
                { "jpt!", "cmt\\weapons\\evolved\\human\\battle_rifle\\damage_effects\\battle_rifle_bullet_impact h2a", 5, "+5cR (DMR Bullet)" },
                { "jpt!", "cmt\\weapons\\evolved\\covenant\\carbine\\damage_effects\\carbine_bolt_impact", 8, "+8cR (Carbine Bullet)" },
                { "jpt!", "zteam\\objects\\weapons\\single\\battle_rifle\\h2\\bullet", 5, "+5cR (Battle Rifle)" },
                --
                -- Bigassv2,104:
                { "jpt!", "weapons\\pistol\\bullet", 5, "+5cR (Pistol Bullet)" },
                { "jpt!", "altis\\scenery\\capsule2\\bam", 7, "+5cR (Capsule)" },
                { "jpt!", "bourrin\\weapons\\dmr\\bullet", 5, "+5cR (DMR Bullet)" },
                { "jpt!", "cmt\\weapons\\human\\ma5k\\bullet", 5, "+5cR (MA5K Bullet)" },
                { "jpt!", "weapons\\sniper rifle\\sniper bullet", 6, "+6cR (Sniper Rifle)" },
                { "jpt!", "halo3\\weapons\\odst pistol\\bullet", 5, "+5cR (Pistol Bullet)" },
                { "jpt!", "bourrin\\weapons\\masternoob's assault rifle\\bullet", 5, "+5cR (Assault Rifle)" },
                { "jpt!", "zteam\\objects\\weapons\\single\\spartan_laser\\h3\\laser", 10, "+10cR (Spartan Lazer)" },
            },

            grenades = {
                -- stock --
                { "jpt!", "weapons\\frag grenade\\explosion", 8, "+8cR (Frag Explosion)" },
                { "jpt!", "weapons\\plasma grenade\\attached", 7, "+7cR (Plasma Grenade - attached)" },
                { "jpt!", "weapons\\plasma grenade\\explosion", 5, "+5cR (Plasma Grenade explosion)" },
                --
                -- TSCE_MultiplayerV1:
                { "jpt!", "cmt\\weapons\\evolved_h1-spirit\\frag_grenade\\damage_effects\\frag_grenade_explosion", 8, "+8cR (Frag Explosion)" },
                { "jpt!", "cmt\\weapons\\evolved\\human\\frag_grenade\\damage_effects\\frag_grenade_explosion", 8, "+8cR (Frag Explosion)" },
                { "jpt!", "cmt\\weapons\\evolved\\human\\frag_grenade\\damage_effects\\frag_grenade_bounce", 4, "+4cR (Frag Bounce)" },
                { "jpt!", "cmt\\weapons\\evolved_h1-spirit\\plasma_grenade\\damage_effects\\plasma_grenade_explosion", 5, "+5cR (Frag Explosion)" },
                { "jpt!", "cmt\\weapons\\evolved\\covenant\\plasma_grenade\\damage_effects\\plasma_grenade_explosion", 5, "+5cR (Frag Explosion)" },
                { "jpt!", "cmt\\weapons\\evolved\\covenant\\plasma_grenade\\damage_effects\\plasma_grenade_attached", 7, "+7cR (Plasma Stick)" },
                { "jpt!", "cmt\\weapons\\evolved\\covenant\\plasma_grenade\\damage_effects\\plasma_grenade_stick_flash", 7, "+7cR (Plasma Stick Flash)" },
                { "jpt!", "cmt\\weapons\\evolved\\covenant\\plasma_grenade\\damage_effects\\plasma_grenade_stick_hunter", 7, "+7cR (Plasma Stick hunter)" },
                --
                -- Bigassv2,104:
                { "jpt!", "h2\\weapons\\grenade\\fragmentation_grenade\\explosion", 8, "+8cR (Frag Explosion)" },
                { "jpt!", "weapons\\rocket launcher\\mine", 8, "+8cR (Mine)" },
            },

            melee = {
                -- stock --
                { "jpt!", "weapons\\flag\\melee", 5, "+5cR (Melee: Flag)" },
                { "jpt!", "weapons\\ball\\melee", 5, "+5cR (Melee: Ball)" },
                { "jpt!", "weapons\\pistol\\melee", 4, "+4cR (Melee: Pistol)" },
                { "jpt!", "weapons\\needler\\melee", 4, "+4cR (Melee: Needler)" },
                { "jpt!", "weapons\\shotgun\\melee", 5, "+5cR (Melee: Shotgun)" },
                { "jpt!", "weapons\\flamethrower\\melee", 5, "+5cR (Melee: Flamethrower)" },
                { "jpt!", "weapons\\sniper rifle\\melee", 5, "+5cR (Melee: Sniper Rifle)" },
                { "jpt!", "weapons\\plasma rifle\\melee", 4, "+4cR (Melee: Plasma Rifle)" },
                { "jpt!", "weapons\\plasma pistol\\melee", 4, "+4cR (Melee: Plasma Pistol)" },
                { "jpt!", "weapons\\assault rifle\\melee", 4, "+4cR (Melee: Assault Rifle)" },
                { "jpt!", "weapons\\rocket launcher\\melee", 10, "+10cR (Melee: Rocket Launcher)" },
                { "jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_melee", 10, "+10cR (Melee: Plasma Cannon)" },
                --
                -- TSCE_MultiplayerV1:
                { "jpt!", "cmt\\weapons\\evolved\\melee\\rifle\\melee", 5, "+5cR (Melee)" },
                { "jpt!", "cmt\\weapons\\evolved_h1-spirit\\melee\\melee", 5, "+5cR (Melee)" },
            },

            -- VEHICLE COLLISION --
            vehicles = {
                collision = { "jpt!", "globals\\vehicle_collision" },
                -- stock --
                { "vehi", "vehicles\\ghost\\ghost_mp", 5, "+5cR (Vehicle Squash: GHOST)" },
                { "vehi", "vehicles\\rwarthog\\rwarthog", 6, "+6cR (Vehicle Squash: R-Hog)" },
                { "vehi", "vehicles\\warthog\\mp_warthog", 7, "+7cR (Vehicle Squash: Warthog)" },
                { "vehi", "vehicles\\banshee\\banshee_mp", 8, "+8cR (Vehicle Squash: Banshee)" },
                { "vehi", "vehicles\\scorpion\\scorpion_mp", 10, "+10cR (Vehicle Squash: Tank)" },
                { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 1000, "+1000R (Vehicle Squash: Turret)" },
                --
                -- TSCE_MultiplayerV1:
                { "vehi", "cmt\\vehicles\\evolved_h1-spirit\\ghost\\_ghost_mp\\ghost_mp", 5, "+5cR (Vehicle Squash: GHOST)" },
                { "vehi", "cmt\\vehicles\\evolved_h1-spirit\\warthog\\_warthog_mp\\warthog_mp", 7, "+7cR (Vehicle Squash: Warthog)" },
                { "vehi", "cmt\\vehicles\\evolved_h1-spirit\\warthog\\_warthog_rocket\\warthog_rocket", 6, "+6cR (Vehicle Squash: R-Hog)" },
                { "vehi", "soi\\vehicles\\scorpion\\scorpion", 10, "+10cR (Vehicle Squash: Tank)" },
                --
                -- Bigassv2,104:
                { "vehi", "bourrin\\halo reach\\vehicles\\warthog\\h2 mp_warthog", 5, "+5cR (Vehicle Squash: Warthog)" },
                { "vehi", "bourrin\\halo reach\\vehicles\\warthog\\reach gauss hog", 5, "+5cR (Vehicle Squash: Gauss Hog)" },
                { "vehi", "vehicles\\falcon\\falcon", 4, "+4cR (Vehicle Squash: Falcon)" },
                { "vehi", "altis\\vehicles\\spade\\spade", 3, "+3cR (Vehicle Squash: Spade)" },
                { "vehi", "halo reach\\objects\\vehicles\\human\\civilian\\military_truck\\military truck", 4, "+4cR (Vehicle Squash: Truck)" },
                { "vehi", "vehicles\\falcon_destroyed\\falcon_destroyed", 5, "+5cR (Vehicle Squash: Falcon)" },
                { "vehi", "bourrin\\halo reach\\vehicles\\warthog\\rocket warthog", 4, "+4cR (Vehicle Squash: RHog)" },
                { "vehi", "altis\\vehicles\\scorpion_destroyed\\scorpion_destroyed", 7, "+7cR (Vehicle Squash: Tank)" },
                { "vehi", "altis\\vehicles\\scorpion\\scorpion", 6, "+6cR (Vehicle Squash: Tank)" },
                { "vehi", "altis\\vehicles\\mongoose\\mongoose", 6, "+6cR (Vehicle Squash: Mongoose)" },
                { "vehi", "altis\\vehicles\\truck_destroyed\\truck_destroyed", 3, "+3cR (Vehicle Squash: Truck)" },
                { "vehi", "altis\\vehicles\\truck_destroyed\\wheel\\wheel", 2, "+2cR (Vehicle Squash: Wheel)" },
                { "vehi", "altis\\vehicles\\mongoose\\mongoose_spin", 4, "+4cR (Vehicle Squash: Mongoose)" },
                { "vehi", "vehicles\\falcon_destroyed\\left_wing\\left_wing", 3, "+3cR (Vehicle Squash: Left Wing)" },
                { "vehi", "vehicles\\falcon_destroyed\\right_wing\\right_wing", 3, "+3cR (Vehicle Squash: Right Wing)" },
                { "vehi", "vehicles\\falcon_destroyed\\tail\\tail", 3, "+3cR (Vehicle Squash: Tail)" },
            }
        }
    },

    --
    -- Advanced users only:
    --
    --

    weapon_tags = {
        -- ============= [ STOCK WEAPONS ] ============= --
        [1] = "weapons\\pistol\\pistol",
        [2] = "weapons\\sniper rifle\\sniper rifle",
        [3] = "weapons\\plasma_cannon\\plasma_cannon",
        [4] = "weapons\\rocket launcher\\rocket launcher",
        [5] = "weapons\\plasma pistol\\plasma pistol",
        [6] = "weapons\\plasma rifle\\plasma rifle",
        [7] = "weapons\\assault rifle\\assault rifle",
        [8] = "weapons\\flamethrower\\flamethrower",
        [9] = "weapons\\needler\\mp_needler",
        [10] = "weapons\\shotgun\\shotgun",

        -- ============= [ CUSTOM WEAPONS ] ============= --
        -- TSCE_MultiplayerV1:
        [11] = "cmt\\vehicles\\evolved_h1-spirit\\warthog\\weapons\\warthog_turret\\warthog_turret",
        [12] = "cmt\\vehicles\\evolved_h1-spirit\\warthog\\_warthog_rocket\\weapons\\warthog_rocket_turret\\warthog_rocket_turret",
        [13] = "cmt\\vehicles\\evolved_h1-spirit\\ghost\\_ghost_mp\\weapons\\ghost_mp_cannon\\ghost_mp_cannon",
        [14] = "soi\\vehicles\\scorpion\\scorpion cannon",
        [15] = "altis\\weapons\\sprint\\sprint",
        [16] = "cmt\\weapons\\evolved_h1-spirit\\needler\\_needler_mp\\needler_mp",
        [17] = "cmt\\weapons\\evolved\\human\\battle_rifle\\_battle_rifle_specops\\battle_rifle_specops",
        [18] = "cmt\\weapons\\evolved_h1-spirit\\plasma_rifle\\_plasma_rifle_mp\\plasma_rifle_mp",
        [19] = "cmt\\weapons\\evolved_h1-spirit\\pistol\\_pistol_mp\\pistol_mp",
        [20] = "cmt\\weapons\\covenant\\brute_plasma_rifle\\reload\\brute plasma rifle",
        [21] = "cmt\\weapons\\evolved_h1-spirit\\shotgun\\shotgun",
        [22] = "cmt\\weapons\\evolved_h1-spirit\\sniper_rifle\\sniper_rifle",
        [23] = "cmt\\weapons\\evolved\\human\\dmr\\dmr",
        [24] = "cmt\\weapons\\evolved_h1-spirit\\assault_rifle\\assault_rifle",
        [25] = "cmt\\weapons\\evolved_h1-spirit\\rocket_launcher\\rocket_launcher",
        [26] = "dreamweb\\weapons\\human\\battle_rifle\\_h2a\\battle_rifle",
        [27] = "cmt\\weapons\\evolved\\covenant\\carbine\\carbine",
        [28] = "cmt\\weapons\\evolved\\human\\battle_rifle\\battle_rifle",
        [29] = "cmt\\globals\\_shared\\empty_objects\\empty_weapon",
        --
        -- Bigassv2,104:
        [30] = "weapons\\gauss sniper\\gauss sniper",
        [31] = "altis\\weapons\\binoculars\\gauss spawner\\create gauss",
        [32] = "bourrin\\weapons\\masternoob's assault rifle\\assault rifle",
        [33] = "reach\\objects\\weapons\\pistol\\magnum\\magnum",
        [34] = "vehicles\\warthog\\warthog gun",
        [35] = "bourrin\\halo reach\\vehicles\\warthog\\gauss\\gauss gun",
        [36] = "vehicles\\le_falcon\\weapon",
        [37] = "bourrin\\halo reach\\vehicles\\warthog\\rocket\\rocket",
        [38] = "vehicles\\scorpion\\scorpion cannon_heat",
        [39] = "altis\\weapons\\smoke\\smoke",
        [40] = "cmt\\weapons\\human\\shotgun\\shotgun",
        [41] = "cmt\\weapons\\human\\stealth_sniper\\sniper rifle",
        [42] = "halo reach\\objects\\weapons\\support_high\\spartan_laser\\spartan laser",
        [43] = "bourrin\\weapons\\dmr\\dmr",
        [44] = "bourrin\\weapons\\ma5k\\cmt's ma5k reloaded",
        [45] = "halo3\\weapons\\odst pistol\\odst pistol",
        [56] = "altis\\weapons\\binoculars\\binoculars",
        [47] = "weapons\\rocket launcher\\rocket launcher test",
        [48] = "my_weapons\\trip-mine\\trip-mine",
    },

    -- Color Table --
    -- Do Not Touch Unless you know what you're doing.
    colors = {
        ["white"] = 0,
        ["black"] = 1,
        ["red"] = 2,
        ["blue"] = 3,
        ["gray"] = 4,
        ["yellow"] = 5,
        ["green"] = 6,
        ["pink"] = 7,
        ["purple"] = 8,
        ["cyan"] = 9,
        ["cobalt"] = 10,
        ["orange"] = 11,
        ["teal"] = 12,
        ["sage"] = 13,
        ["brown"] = 14,
        ["tan"] = 15,
        ["maroon"] = 16,
        ["salmon"] = 17,
    },

    -- The array index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for ip-only indexing.
    ClientIndexType = 2,

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    server_prefix = "**SAPP**",
    --

    --=================================================================================--
    -- CONFIGURATION ENDS --
    --=================================================================================--

    -- DO NOT TOUCH --
    players = { },
    ammo_set_delay = 300,
}

local ip_addresses = { }
local time_scale = 1 / 30
local script_version = 1.9
local gmatch, gsub = string.gmatch, string.gsub
local lower = string.lower
local floor, sqrt, format = math.floor, math.sqrt, string.format

local function IsTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
    end
    return false
end

local function Init(reset)
    local events_registered = RegisterSAPPEvents()
    if (events_registered) then

        if (reset) then
            Loadout.players = { }
            execute_command('sv_map_reset')
            for i = 1, 16 do
                if player_present(i) then
                    Loadout:InitPlayer(i)
                end
            end
        end

        local gt = get_var(0, "$gt")
        for k, v in pairs(Loadout.scorelimits) do
            if (gt == k) then
                if IsTeamPlay() then
                    execute_command("scorelimit " .. v[1])
                else
                    execute_command("scorelimit " .. v[2])
                end
            end
        end
        Loadout.first_blood = { }
        Loadout.first_blood.active = true
        Loadout.gamestarted = true
        Loadout.map = get_var(0, "$map")
    end
end

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    if (get_var(0, "$gt") ~= "n/a") then
        Init(true)
    end
end

function OnScriptUnload()
    LSS(false)
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        Init()

        -- DEBUGGING:
        --local tag_address = read_dword(0x40440000)
        --local tag_count = read_dword(0x4044000C)
        --for i = 0, tag_count - 1 do
        --    local tag = tag_address + 0x20 * i
        --    local tag_name = read_string(read_dword(tag + 0x10))
        --    local tag_class = read_dword(tag)
        --    if (tag_class == 1986357353) then
        --        print(tag_name)
        --    end
        --end
    end
end

function OnGameEnd()
    Loadout.gamestarted = false
end

function OnPlayerConnect(Ply)
    Loadout:InitPlayer(Ply)
end

function Loadout:OnPlayerPreSpawn(Ply)
    local ip = self:GetIP(Ply)
    local t = self.players[ip]
    if (t.switch_on_respawn[1]) then
        t.switch_on_respawn[1] = false
        t.class = t.switch_on_respawn[2]
    end
end

local function SetGrenades(DyN, Class, Level)
    local frag_count = Class.levels[Level].grenades[1]
    local plasma_count = Class.levels[Level].grenades[2]
    if (frag_count ~= nil) then
        write_word(DyN + 0x31E, frag_count)
    end
    if (plasma_count ~= nil) then
        write_word(DyN + 0x31F, plasma_count)
    end
end

function DelaySecQuat(Ply, Weapon, x, y, z)
    assign_weapon(spawn_object("weap", Weapon, x, y, z), Ply)
end

function Loadout:CompareKDR(k, v)
    local KK, KD = get_var(k, "$kills"), get_var(k, "$deaths")
    local VK, VD = get_var(v, "$kills"), get_var(v, "$deaths")
    local VKDR, KKDR = tonumber(VK / VD), tonumber(KK / KD)
    if (VKDR > KKDR) then

        local s = self.credits.pvp_bonus
        local difference = (VKDR - KKDR)
        local result = math.round((difference / s[2]) * s[1])

        local str = gsub(s[3], "%%credits%%", result)
        self:UpdateCredits(k, { result, str })
    end
end

local function SecondsToClock(seconds)
    seconds = tonumber(seconds)
    if (seconds <= 0) then
        return "00:00:00";
    else
        local hours, mins, secs
        hours = format("%02.f", floor(seconds / 3600));
        mins = format("%02.f", floor(seconds / 60 - (hours * 60)));
        secs = format("%02.f", floor(seconds - hours * 3600 - mins * 60));
        return hours .. ":" .. mins .. ":" .. secs
    end
end

function Loadout:RegenCamo(Ply, v, current_class, level)
    v.camo_cooldown = v.camo_cooldown + time_scale
    local t = SecondsToClock(current_class.levels[level].duration - v.active_camo_timer)
    v.state = "Cloak Regen: " .. t
    if (math.floor(v.camo_cooldown % 2) == 0) and (v.active_camo_timer > 0) then
        v.active_camo_timer = v.active_camo_timer - 1 / 30
        if (v.active_camo_timer < 0) then
            self:ResetCamo(Ply)
        end
    end
end

function SetAmmo(Ply, DyN)
    for i = 0, 3 do
        local WeaponID = read_dword(DyN + 0x2F8 + (i * 4))
        if (WeaponID ~= 0xFFFFFFFF) then
            local WeaponObject = get_object_memory(WeaponID)
            if (WeaponObject ~= 0) then
                local tag = GetObjectTagName(WeaponObject)
                if (tag) then
                    local weapons = Loadout:GetWeaponTable(Ply)
                    if (weapons) then
                        for WI, A in pairs(weapons) do
                            if (tag == Loadout.weapon_tags[WI]) then
                                -- loaded:
                                if (A[1]) then
                                    write_word(WeaponObject + 0x2B8, A[1])
                                end
                                -- unloaded:
                                if (A[2]) then
                                    write_word(WeaponObject + 0x2B6, A[2])
                                end
                                -- battery:
                                if (A[3]) then
                                    execute_command_sequence("w8 1;battery " .. Ply .. " " .. A[3] .. " " .. i)
                                end
                            end
                        end
                        sync_ammo(WeaponID)
                    end
                end
            end
        end
    end
end

function Loadout:GetWeaponTable(Ply)
    local info = self:GetLevelInfo(Ply)
    if (info and info.class and info.level) then
        local weapon_table = self.classes[info.class].levels[info.level].weapons
        if (weapon_table.custom_maps) then
            for map, tab in pairs(weapon_table.custom_maps) do
                if (lower(map) == lower(self.map)) then
                    return tab
                end
            end
        end
        return weapon_table.stock_maps
    end
    return nil
end

local function GetRadius(pX, pY, pZ, X, Y, Z)
    if (pX) then
        return sqrt((pX - X) ^ 2 + (pY - Y) ^ 2 + (pZ - Z) ^ 2)
    end
    return nil
end

function Loadout:OnTick()
    for ip, v in pairs(self.players) do
        if (ip) then

            local i = v.id

            if (player_present(i)) then
                if player_alive(i) then

                    local DyN = get_dynamic_player(i)
                    if (DyN ~= 0) then

                        --
                        -- t-bag Support:
                        --
                        if (self.tbag) then
                            for _, ply in pairs(self.players) do
                                local j = ply.id
                                if (i ~= j and ply.death_coords) then
                                    local pos = GetXYZ(i)
                                    if (pos) and (not pos.invehicle) then
                                        for k, tbag in pairs(ply.death_coords) do
                                            tbag.timer = tbag.timer + time_scale
                                            if (tbag.timer >= self.tbag_coordinate_expiration) then
                                                ply.death_coords[k] = nil
                                            else
                                                local distance = GetRadius(pos.x, pos.y, pos.z, tbag.x, tbag.y, tbag.z)
                                                if (distance) and (distance <= self.tbag_trigger_radius) then
                                                    local crouch = read_bit(pos.dyn + 0x208, 0)
                                                    if (crouch ~= v.crouch_state and crouch == 1) then
                                                        v.crouch_count = v.crouch_count + 1
                                                    elseif (v.crouch_count >= self.tbag_crouch_count) then
                                                        ply.death_coords[k] = nil
                                                        v.crouch_count = 0
                                                        local str = gsub(gsub(self.messages[12], "%%name%%", v.name), "%%victim%%", ply.name)
                                                        self:Respond(i, str, say, 10, i, _)
                                                        self:UpdateCredits(i, { self.credits.tbag[1], self.credits.tbag[2] })
                                                    end
                                                    v.crouch_state = crouch
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        --
                        --
                        -- Check for level up:
                        self:UpdateLevel(i)

                        local level = v.levels[v.class].level
                        local current_class = self.classes[v.class]

                        if (v.assign) then
                            local coords = GetXYZ(i)
                            if (not coords.invehicle) then

                                local flag = self:hasObjective(DyN)
                                if (flag) then
                                    v.assign_delay = true
                                    v.assign_delay_timer = v.assign_delay_timer - time_scale
                                    if (v.assign_delay_timer <= 0) then
                                        v.assign_delay = false
                                    end
                                end

                                if (not v.assign_delay) then

                                    if (flag) then
                                        drop_weapon(i)
                                    end

                                    v.assign = false
                                    v.assign_delay_timer = 1
                                    v.assign_delay = false

                                    --=======================================================================--
                                    -- WEAPON ASSIGNMENT LOGIC --
                                    --=======================================================================--

                                    SetGrenades(DyN, current_class, level)
                                    execute_command("wdel " .. i)

                                    local weapons = self:GetWeaponTable(i)
                                    if (weapons) then
                                        local index = 0
                                        for WI, _ in pairs(weapons) do
                                            index = index + 1
                                            if (index == 1 or index == 2) then
                                                assign_weapon(spawn_object("weap", self.weapon_tags[WI], coords.x, coords.y, coords.z), i)
                                            elseif (index == 3 or index == 4) then
                                                timer(250, "DelaySecQuat", i, self.weapon_tags[WI], coords.x, coords.y, coords.z)
                                            end
                                        end
                                        timer(self.ammo_set_delay, "SetAmmo", i, DyN)
                                    end
                                end
                            end
                        elseif (v.class == "Regeneration") then

                            local health = read_float(DyN + 0xE0)
                            local shield = read_float(DyN + 0xE4)

                            local delay = tonumber(current_class.levels[level].shield_regen_delay)
                            if (shield < 1 and delay ~= nil and v.regen_shield) then
                                v.regen_shield = false
                                write_word(DyN + 0x104, delay)
                            end

                            -- Begin regenerating when shield regenerates to full:
                            if (health < 1 and shield >= 1) then
                                v.time_until_regen_begin = v.time_until_regen_begin - time_scale
                                if (v.time_until_regen_begin <= 0) and (not v.begin_regen) then
                                    v.time_until_regen_begin = current_class.levels[level].regen_delay
                                    v.begin_regen = true
                                elseif (v.begin_regen) then
                                    v.regen_timer = v.regen_timer + time_scale
                                    v.state = "healing: " .. math.round((health / 1) * 100, 2) .. "%%"
                                    if (v.regen_timer >= current_class.levels[level].regen_rate) then
                                        v.regen_timer = 0
                                        write_float(DyN + 0xE0, health + current_class.levels[level].increment)
                                    end
                                end
                            elseif (v.begin_regen and health >= 1) then
                                v.state = "Max Health 100%%"
                                v.begin_regen = false
                                v.regen_timer = 0
                            elseif (health < 1 and shield < 1) then
                                v.state = "health: " .. math.round((health / 1) * 100, 2) .. "%%"
                            else
                                v.state = "Max Health 100%%"
                            end

                        elseif (v.class == "Armor Boost") then
                            local VictimInVehicle = self:InVehicle(i, true)
                            if (not VictimInVehicle) then
                                v.state = "[On-Foot] Damage Resistance: " .. current_class.levels[level].damage_resistance[1] .. "x"
                            else
                                v.state = "[In-Vehicle] Damage Resistance: " .. current_class.levels[level].damage_resistance[2] .. "x"
                            end
                        elseif (v.class == "Cloak") then

                            local invisible = read_float(DyN + 0x37C)
                            local flashlight_state = read_bit(DyN + 0x208, 4)

                            -- Pause CAMO:
                            if (v.camo_pause) then
                                v.camo_pause_timer = v.camo_pause_timer + time_scale
                                if (v.camo_pause_timer >= current_class.levels[level].reinitialize_delay) then
                                    v.camo_pause = false
                                end
                            end

                            local case = (v.flashlight_state ~= flashlight_state and flashlight_state == 1)

                            if (case) and (v.camo_pause) then
                                v.camo_pause = false
                                v.active_camo = true
                                execute_command("camo " .. i .. " 1")
                                -- TURN ON MANUALLY
                            elseif (case) and (not v.active_camo) then
                                v.active_camo = true
                                v.camo_pause = false
                                -- TURN OFF MANUALLY
                            elseif (case) and (v.active_camo) and (invisible ~= 0) and (not v.camo_pause) then

                                v.active_camo = false
                                v.regen_camo = true
                                execute_command("camo " .. i .. " 1")

                                -- Begin Cloaking...
                            elseif (not case) and (v.active_camo) and (not v.camo_pause) then
                                execute_command("camo " .. i .. " 1")
                                v.active_camo_timer = v.active_camo_timer + time_scale
                                v.state = "CLOAKING: " .. SecondsToClock(current_class.levels[level].duration - v.active_camo_timer)

                                -- Timer ran out, begin regen:
                                if (v.active_camo_timer >= current_class.levels[level].duration) then
                                    v.regen_camo = true
                                    v.active_camo = false
                                    execute_command("camo " .. i .. " 1")
                                end
                                -- Regenerate Cloak
                            elseif (v.regen_camo) then
                                self:RegenCamo(i, v, current_class, level)
                            else
                                v.state = "CLOAK: READY"
                            end
                            v.flashlight_state = flashlight_state

                            local shooting = read_float(DyN + 0x490)
                            if (shooting ~= v.shooting and shooting == 1) then
                                v.camo_pause = true
                            end
                            v.shooting = shooting

                        elseif (v.class == "Recon") then
                            local key = read_byte(DyN + 0x2A3)

                            local double_tap_delay = .150

                            -- RESET CASE --
                            --
                            local case1 = (key == 0 and v.key_released == 3)
                            local case2 = (v.button_press_delay >= double_tap_delay) and (key == 0 or key == 4)
                            local case3 = (v.press_count == 1 and key == 0) and (v.button_press_delay >= double_tap_delay)
                            local case4 = (v.button_press_delay >= double_tap_delay) and (key == 0 and v.key_released == 2)

                            -- press 1:
                            if (key == 4 and v.press_count == 0 and v.key_released == 0) then
                                v.press_count = v.press_count + 1

                                -- release:
                            elseif (key == 0 and v.press_count == 1 and v.key_released == 0) then
                                v.key_released = 2

                                -- checking for press 2:
                            elseif (key == 0 and v.key_released == 2 and v.button_press_delay < double_tap_delay) and (v.press_count == 1) then
                                v.button_press_delay = v.button_press_delay + time_scale

                                -- press 2:
                            elseif (key == 4 and v.key_released == 2 and v.button_press_delay < double_tap_delay) and (v.press_count == 1) then
                                v.press_count = v.press_count + 1
                                v.key_released = 3

                                -- apply speed:
                            elseif (key == 4 and v.key_released == 3) then
                                v.speed_timer = v.speed_timer + time_scale
                                local t = SecondsToClock(current_class.levels[level].speed_duration - v.speed_timer)
                                v.state = "Sprinting: " .. t

                                -- Apply Speed:
                                if (v.speed_timer <= current_class.levels[level].speed_duration) then
                                    execute_command("s" .. " " .. i .. " " .. current_class.levels[level].speed)
                                else
                                    self:ResetSpeed(i, true)
                                end

                                -- reset
                            elseif (case1 or case2 or case3 or case4) then
                                self:ResetSpeed(i, true)

                                -- begin regenerating time:
                            elseif (v.regen and v.speed_timer > 0) then

                                v.speed_cooldown = v.speed_cooldown + time_scale
                                local t = SecondsToClock(current_class.levels[level].speed_duration - v.speed_timer)
                                v.state = "Speed Regen: " .. t

                                if (math.floor(v.speed_cooldown % 2) == 1) and (v.speed_timer > 0) then
                                    v.speed_timer = v.speed_timer - 1 / 30
                                    if (v.speed_timer < 0) then
                                        self:ResetSpeed(i)
                                    end
                                end
                            else
                                v.state = "Sprint Ready"
                            end
                            if (key == 20) and (v.key_released == 3) then
                                v.speed_timer = v.speed_timer + (time_scale * 1.5)
                                local t = SecondsToClock(current_class.levels[level].speed_duration - v.speed_timer)
                                v.state = "Airborne Friction:  " .. t
                            end
                        end

                        -- ======================================= --
                        -- HUD LOGIC --
                        -- ======================================= --
                        if (self.show_hud) then
                            if (v.hud_pause) then
                                v.hud_pause_duration = v.hud_pause_duration - time_scale
                                if (v.hud_pause_duration <= 0) then
                                    v.hud_pause = false
                                    v.hud_pause_duration = self.hud_pause_duration
                                end
                            elseif (self.gamestarted) then
                                self:PrintHUD(i)
                            end
                        end
                        if (v.show_help and self.gamestarted) then
                            v.help_hud_duration = v.help_hud_duration - time_scale
                            self:PrintHelp(i, self.classes[v.class].info)
                            if (v.help_hud_duration <= 0) then
                                v.help_page = nil
                                v.show_help = false
                                v.help_hud_duration = self.help_hud_duration
                            end
                        end
                    end
                end
            else
                v.disconnect_timer = v.disconnect_timer - time_scale
                if (v.disconnect_timer <= 0) then
                    self.players[ip] = nil
                end
            end
        end
    end
end

function Loadout:PauseHUD(Ply, Clear)

    local ip = self:GetIP(Ply)
    local p = self.players[ip]
    if (p) then

        if (Clear) then
            self:cls(Ply, 25)
        end

        p.hud_pause = true
        p.hud_pause_duration = self.hud_pause_duration
    end
end

function Loadout:PrintHelp(Ply, InfoTab)
    self:cls(Ply, 25)
    for i = 1, #InfoTab do
        self:Respond(Ply, InfoTab[i], rprint, 10)
    end
end

function Loadout:PrintSpeedBoostHUD(Ply, Time)
    self:cls(Ply, 25)
    self:Respond(Ply, "Boost Time: " .. SecondsToClock(Time), rprint, 10)
end

function math.round(n, d)
    return tonumber(format("%." .. (d or 0) .. "f", n))
end

function Loadout:PrintHUD(Ply)

    local ip = self:GetIP(Ply)
    local t = self.players[ip]
    if (not t.hud_pause) then

        local info = self:GetLevelInfo(Ply)
        self:cls(Ply, 25)
        local str = self.classes[t.class].hud

        local words = {
            ["%%cr%%"] = math.round(info.credits),
            ["%%lvl%%"] = info.level,
            ["%%cr_req%%"] = info.cr_req,
            ["%%state%%"] = info.state,
            ["%%total_levels%%"] = #self.classes[t.class].levels,
        }
        for k, v in pairs(words) do
            str = gsub(str, k, v)
        end
        self:Respond(Ply, str, rprint, 10, _, true)
    end
end

local function CMDSplit(CMD)
    local Args, index = { }, 1
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = lower(Params)
        index = index + 1
    end
    return Args
end

function Loadout:OnServerCommand(Executor, Command)
    local Args = CMDSplit(Command)
    if (Args == nil) then
        return
    else

        local etab
        local eip = self:GetIP(Executor)

        if (Executor > 0) then
            etab = self.players[eip]
            self:PauseHUD(Executor, true)
        end

        for class, v in pairs(self.classes) do
            if (Args[1] == v.command) then
                if (etab.class == class) then
                    self:Respond(Executor, "You already have " .. class .. " class", rprint, 12)
                else
                    etab.switch_on_respawn[1] = true
                    etab.switch_on_respawn[2] = class
                    self:Respond(Executor, "You will switch to " .. class .. " when you respawn", rprint, 12)
                end
                return false
            end
        end

        --=======================================================================--
        -- SET LEVEL COMMAND --
        --=======================================================================--
        local lvl = tonumber(get_var(Executor, "$lvl"))
        if (Args[1] == self.level_cmd) then
            if (lvl >= self.level_cmd_permission or (Executor == 0)) then
                local pl = self:GetPlayers(Executor, Args)
                if (pl) then
                    for i = 1, #pl do
                        local TargetID = tonumber(pl[i])
                        if (TargetID ~= Executor and lvl < self.level_cmd_permission_others) then
                            self:Respond(Executor, self.messages[10], rprint, 10)
                        elseif (Args[3]:match("^%d+$")) then

                            local ip = self:GetIP(TargetID)
                            local t = self.players[ip]
                            local level = tonumber(Args[3])
                            local max_levels = #self.classes[t.class].levels

                            -- Level is the same!
                            if (level == t.levels[t.class].level) then
                                local s = gsub(self.messages[7], "%%level%%", level)
                                self:Respond(Executor, s, rprint, 10)

                            elseif (level <= max_levels and level > 0) then

                                t.assign = true
                                t.levels[t.class].level = level
                                t.levels[t.class].credits = 0
                                if (TargetID == Executor) then
                                    local s = gsub(self.messages[4][1], "%%level%%", level)
                                    self:Respond(TargetID, s, rprint, 10)
                                else
                                    local s1 = gsub(self.messages[4][1], "%%level%%", level)
                                    self:Respond(TargetID, s1, rprint, 10)
                                    local s2 = gsub(gsub(self.messages[4][2], "%%level%%", level), "%%name%%", t.name)
                                    self:Respond(Executor, s2, rprint, 10)
                                end
                            else
                                local s = gsub(self.messages[6], "%%max%%", max_levels)
                                self:Respond(Executor, s, rprint, 10)
                            end
                        end
                    end
                end
            else
                self:Respond(Executor, self.messages[9], rprint, 10)
            end
            return false

            --=======================================================================--
            -- SET CREDITS COMMAND --
            --=======================================================================--
        elseif (Args[1] == self.credits_cmd) then
            if (lvl >= self.credits_cmd_permission or (Executor == 0)) then
                local pl = self:GetPlayers(Executor, Args)
                if (pl) then
                    for i = 1, #pl do
                        local TargetID = tonumber(pl[i])
                        if (TargetID ~= Executor and lvl < self.credits_cmd_permission_others) then
                            self:Respond(Executor, self.messages[10], rprint, 10)
                        elseif (Args[3]:match("^%d+$")) then

                            local ip = self:GetIP(TargetID)
                            local t = self.players[ip]

                            local credits = tonumber(Args[3])
                            local info = self:GetLevelInfo(TargetID)
                            local max_credits = self.classes[t.class].levels[info.level].until_next_level

                            if (credits <= max_credits or max_credits == nil) then
                                t.levels[t.class].credits = t.levels[t.class].credits + credits

                                if (TargetID == Executor) then
                                    local s = gsub(self.messages[5][1], "%%credits%%", credits)
                                    self:Respond(TargetID, s, rprint, 10)
                                else
                                    local s1 = gsub(self.messages[5][1], "%%credits%%", credits)
                                    self:Respond(TargetID, s1, rprint, 10)
                                    local s2 = gsub(gsub(self.messages[5][2], "%%credits%%", credits), "%%name%%", t.name)
                                    self:Respond(Executor, s2, rprint, 10)
                                end
                            else
                                local s = gsub(self.messages[8], "%%max%%", max_credits)
                                self:Respond(Executor, s, rprint, 10)
                            end
                        end
                    end
                end
            else
                self:Respond(Executor, self.messages[9], rprint, 10)
            end
            return false

            --=======================================================================--
            -- SET BOUNTY COMMAND --
            --=======================================================================--
        elseif (Args[1] == self.bounty_cmd) then
            if (lvl >= self.bounty_cmd_permission or (Executor == 0)) then
                local pl = self:GetPlayers(Executor, Args)
                if (pl) then
                    for i = 1, #pl do
                        local TargetID = tonumber(pl[i])
                        if (TargetID ~= Executor and lvl < self.bounty_cmd_permission_others) then
                            self:Respond(Executor, self.messages[10], rprint, 10)
                        elseif (Args[3]:match("^%d+$")) then

                            local ip = self:GetIP(TargetID)
                            local t = self.players[ip]

                            local bounty = tonumber(Args[3])
                            t.bounty = t.bounty + bounty

                            local m = self.messages[3]
                            if (TargetID == Executor) then
                                local s = gsub(gsub(m[1], "%%bounty%%", bounty), "%%total_bounty%%", t.bounty)
                                self:Respond(TargetID, s, rprint, 10)
                            else

                                local s1 = gsub(m[1], "%%bounty%%", bounty)
                                self:Respond(TargetID, s1, rprint, 10)
                                local s2 = gsub(gsub(gsub(m[2],
                                        "%%name%%", t.name),
                                        "%%bounty%%", bounty),
                                        "%%bounty_total%%", t.bounty)
                                self:Respond(Executor, s2, rprint, 10)
                            end

                            local s = gsub(gsub(m[3], "%%total_bounty%%", t.bounty), "%%target%%", t.name)
                            self:Respond(Executor, s, say, 10, Executor, _)
                        end
                    end
                end
            else
                -- Invalid Syntax:
                self:Respond(Executor, self.messages[9], rprint, 10)
            end
            return false
        elseif (Args[1] == self.info_command) then
            etab.help_page, etab.show_help = etab.class, true
            return false
        end
    end
end

function Loadout:OnPlayerScore(Ply)
    local ip = self:GetIP(Ply)
    self.players[ip].bounty = self.players[ip].bounty + self.credits.bounty_on_score
    self:UpdateCredits(Ply, { self.credits.score[1], self.credits.score[2] })
end

function Loadout:ResetSpeed(Ply, Regenerating)

    local ip = self:GetIP(Ply)

    if (Regenerating) then
        self.players[ip].regen = true
    else
        self.players[ip].regen = false
        self.players[ip].speed_timer = 0
        self.players[ip].speed_cooldown = 0
    end

    self.players[ip].press_count = 0
    self.players[ip].key_released = 0
    self.players[ip].button_press_delay = 0
    execute_command("s" .. " " .. Ply .. " 1")
end

function Loadout:ResetCamo(Ply, SpawnTrigger)
    local ip = self:GetIP(Ply)
    self.players[ip].camo_cooldown = 0
    self.players[ip].camo_pause = false
    self.players[ip].active_camo = false
    self.players[ip].regen_camo = false
    self.players[ip].camo_pause_timer = 0
    self.players[ip].active_camo_timer = 0
    self.players[ip].state = "CLOAK: READY"
    if (not SpawnTrigger) then
        execute_command("camo " .. Ply .. " 1")
    end
end

function Loadout:InitPlayer(Ply)

    local ip = self:GetIP(Ply)
    ip_addresses[Ply] = ip
    if (not self.players[ip]) then
        self.players[ip] = {

            state = "",

            levels = { },

            bounty = 0,
            class = self.default_class,

            -- Recon Class --
            speed_timer = 0,
            speed_cooldown = 0,
            button_press_delay = 0,

            deaths = 0,

            camo_pause = false,
            regen_camo = false,
            camo_pause_timer = 0,
            camo_cooldown = 0,

            disconnect_timer = self.disconnect_cooldown,

            switch_on_respawn = { false, nil },

            help_page = nil,
            show_help = false,
            help_hud_duration = self.help_hud_duration,

            hud_pause = false,
            hud_pause_duration = self.hud_pause_duration,
        }
        for k, _ in pairs(self.classes) do
            self.players[ip].levels[k] = {
                credits = 0,
                level = self.starting_level,
                ammo = self.classes[self.default_class].levels[self.starting_level].ammo
            }
        end
    end

    self.players[ip].id = Ply
    self.players[ip].name = get_var(Ply, "$name")
    self.players[ip].disconnect_timer = self.disconnect_cooldown

    -- T-Bag Support:
    self.players[ip].death_coords = { }
    self.players[ip].crouch_state = 0
    self.players[ip].crouch_count = 0
    --

    self:SetColor(Ply)
    ip_addresses[Ply] = ip
end

function Loadout:OnPlayerSpawn(Ply)

    local ip = self:GetIP(Ply)
    local t = self.players[ip]
    local info = self:GetLevelInfo(Ply)

    -- Weapon Assignment Variables
    t.assign = true

    -- Health regeneration Variables --
    t.regen_timer = 0
    t.begin_regen = false

    t.head_shot = nil
    t.last_damage = nil
    t.regen_shield = false

    self:ResetSpeed(Ply)
    self:ResetCamo(Ply, true)

    t.time_until_regen_begin = self.classes["Regeneration"].levels[info.level].regen_delay

    t.assign_delay = false
    t.assign_delay_timer = 1

    if (self.death_sprees_bonus) then
        if (t.deaths >= 5 and t.deaths < 10) then
            powerup_interact(spawn_object("eqip", "powerups\\over shield"), Ply)
        elseif (t.deaths >= 10) then
            powerup_interact(spawn_object("eqip", "powerups\\over shield"), Ply)
            powerup_interact(spawn_object("eqip", "powerups\\active camouflage"), Ply)
        end
    end
end

local function GetTag(ObjectType, ObjectName)
    if type(ObjectType == "string") then
        local Tag = lookup_tag(ObjectType, ObjectName)
        return Tag ~= 0 and read_dword(Tag + 0xC) or nil
    end
    return nil
end

local function CheckDamageTag(DamageMeta, Params)
    local t = Loadout.credits.tags
    for _, tab in pairs(Params) do
        for _, d in pairs(t[tab]) do
            local tag = GetTag(d[1], d[2])
            if (tag ~= nil) and (tag == DamageMeta) then
                return { d[3], d[4] }
            end
        end
    end
    return { 0, "Rank System: Invalid Tag Address Damage Meta" }
end

function Loadout:KillingSpree(Ply)
    local player = get_player(Ply)
    if (player ~= 0) then

        local t = self.credits.spree
        local k = read_word(player + 0x96)

        for _, v in pairs(t) do
            if (k == v[1]) or (k >= t[#t][1] and k % 5 == 0) then

                local ip = self:GetIP(Ply)

                self:UpdateCredits(Ply, { v[2], v[3] })
                local bonus = self.credits.bounty_bonus + v[4]
                self.players[ip].bounty = self.players[ip].bounty + bonus

                local str = gsub(gsub(self.messages[1],
                        "%%name%%", self.players[ip].name),
                        "%%bounty%%", self.players[ip].bounty)
                self:Respond(_, str, say_all, 10)
                break
            end
        end
    end
end

function Loadout:MultiKill(Ply)
    local player = get_player(Ply)
    if (player ~= 0) then

        local t = self.credits.multi_kill
        local k = read_word(player + 0x98)

        for _, v in pairs(t) do
            if (k == v[1]) or (k >= t[#t][1] and k % 2 == 0) then
                self:UpdateCredits(Ply, { v[2], v[3] })
                break
            end
        end
    end
end

function Loadout:InVehicle(Ply, CheckOnly)
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then
        local VehicleID = read_dword(DyN + 0x11C)
        if (VehicleID ~= 0xFFFFFFFF) then
            if (CheckOnly) then
                return true
            else
                local VehicleObject = get_object_memory(VehicleID)
                if (VehicleObject ~= 0) then
                    local name = GetObjectTagName(VehicleObject)
                    if (name ~= nil) then
                        return name
                    end
                end
            end
        end
    end
    return false
end

function Loadout:cls(Ply, Count)
    Count = Count or 25
    for _ = 1, Count do
        rprint(Ply, " ")
    end
end

function Loadout:FirstBlood(Ply)
    local kills = tonumber(get_var(Ply, "$kills"))
    local count = 0
    if (kills == 1) then
        for i = 1, 16 do
            if player_present(i) then
                if (i ~= Ply) then
                    if (self.first_blood[i]) then
                        count = count + 1
                    end
                end
            end
        end
    end
    if (count == 1) then
        self.first_blood = { }
        self.first_blood.active = false
        self:UpdateCredits(Ply, { self.credits.first_blood[1], self.credits.first_blood[2] })
    end
end

function Loadout:OnPlayerDeath(VictimIndex, KillerIndex)
    local killer, victim = tonumber(KillerIndex), tonumber(VictimIndex)

    self:SetColor(victim)

    local kip, vip = self:GetIP(killer), self:GetIP(victim)
    local last_damage = self.players[vip].last_damage
    local kteam = get_var(killer, "$team")
    local vteam = get_var(victim, "$team")

    local server = (killer == -1)
    local guardians = (killer == nil)
    local suicide = (killer == victim)
    local pvp = ((killer > 0) and killer ~= victim) and (kteam ~= vteam)
    local betrayal = ((killer > 0) and killer ~= victim) and (kteam == vteam) and IsTeamPlay()

    local v = self.players[vip]
    if (self.tbag) then
        local pos = GetXYZ(victim)
        if (pos) then
            v.death_coords[#v.death_coords + 1] = { timer = 0, x = pos.x, y = pos.y, z = pos.z }
        end
    end

    if (pvp and not betrayal) then

        local k = self.players[kip]

        k.deaths = 0
        v.deaths = v.deaths + 1

        if (v.bounty > 0) then
            local str = self.messages[2]
            str = gsub(gsub(gsub(str, "%%name%%", k.name), "%%bounty%%", v.bounty), "%%victim%%", v.name)
            self:UpdateCredits(killer, { v.bounty, str })
            v.bounty = 0
        end

        -- Check for first blood:
        if (self.first_blood.active) then
            self.first_blood[victim] = true
            self:FirstBlood(killer)
        end

        self:MultiKill(killer)
        self:KillingSpree(killer)

        local DyN = get_dynamic_player(victim)
        if (DyN ~= 0) then
            if self:hasObjective(DyN) then
                self:UpdateCredits(killer, { self.credits.flag_carrier_kill_bonus[1], self.credits.flag_carrier_kill_bonus[2] })
            end
        end

        if (not player_alive(killer)) then
            self:UpdateCredits(killer, { self.credits.killed_from_the_grave[1], self.credits.killed_from_the_grave[2] })
        elseif (self.players[vip].head_shot) then
            self:UpdateCredits(killer, { self.credits.head_shot[1], self.credits.head_shot[2] })
        end

        -- Calculate PvP Bonus:
        if (self.credits.use_pvp_bonus) then
            self:CompareKDR(killer, victim)
        end

        local VictimInVehicle = self:InVehicle(victim, true)
        if (VictimInVehicle) then
            self:UpdateCredits(killer, { self.credits.vehicle_kill[1], self.credits.vehicle_kill[2] })
        end

        -- Vehicle check logic:
        local vehicle = self:InVehicle(killer)
        if (vehicle) then
            local t = self.credits.tags.vehicles
            for _, T in pairs(t) do
                if (vehicle == T[2]) then
                    -- vehicle squash:
                    if (last_damage == GetTag(t.collision[1], t.collision[2])) then
                        return self:UpdateCredits(killer, { T[3], T[4] })
                    else
                        -- vehicle weapon:
                        return self:UpdateCredits(killer, CheckDamageTag(last_damage, { "vehicle_projectiles" }))
                    end
                end
            end
        end
        return self:UpdateCredits(killer, CheckDamageTag(last_damage, {
            "weapon_projectiles",
            "grenades",
            "melee" }))

    elseif (server) then
        local falldamage = self:isFallDamage(last_damage)
        if (falldamage) then
            self:UpdateCredits(victim, { falldamage[1], falldamage[2] })
        else
            self:UpdateCredits(victim, { self.credits.server[1], self.credits.server[2] })
        end
    elseif (guardians) then
        self:UpdateCredits(victim, { self.credits.guardians[1], self.credits.guardians[2] })
    elseif (suicide) then
        self:UpdateCredits(victim, { self.credits.suicide[1], self.credits.suicide[2] })
    elseif (betrayal) then
        self:UpdateCredits(killer, { self.credits.betrayal[1], self.credits.betrayal[2] })
    end
end

function Loadout:GetLevelInfo(Ply)
    local ip = self:GetIP(Ply)
    local t = self.players[ip]
    if (t) then
        local c = t.class
        local l = t.levels[c].level
        local cr = t.levels[c].credits
        local crR = self.classes[c].levels[l].until_next_level
        if (crR == nil) then
            crR = "N/A"
        end
        return { class = c, level = l, credits = cr, cr_req = crR, state = t.state, switch_on_respawn = t.switch_on_respawn }
    end
    return { }
end

function Loadout:UpdateLevel(Ply)
    local ip = self:GetIP(Ply)
    local t = self.players[ip]
    local cr_req = self.classes[t.class].levels[t.levels[t.class].level].until_next_level
    if (cr_req ~= nil and t.levels[t.class].credits >= cr_req) then

        t.assign = true
        t.levels[t.class].level = t.levels[t.class].level + 1

        local str = gsub(gsub(gsub(self.messages[11],
                "%%name%%", t.name),
                "%%class%%", t.class),
                "%%level%%", t.levels[t.class].level)
        self:Respond(Ply, str, say, 10, Ply, _)
    end
end

function Loadout:UpdateCredits(Ply, Params)

    local ip = self:GetIP(Ply)
    local t = self.players[ip]
    if (t) then

        t.levels[t.class].credits = t.levels[t.class].credits + Params[1]

        if (Params[2] ~= "") then
            self:Respond(Ply, Params[2], say, 10)
        end

        local score = tonumber(get_var(Ply, "$score"))
        execute_command("score " .. Ply .. " " .. score + Params[1])

        if (not self.allow_negatives) then

            -- These must be separate if statements:

            if (t.levels[t.class].credits < 0) then
                t.levels[t.class].credits = 0
            end

            if (tonumber(get_var(Ply, "$score")) <= 0) then
                execute_command('score ' .. Ply .. ' 0')
            end
        end
    end
end

function Loadout:IsMelee(MetaID)
    local t = self.credits.tags.melee
    for i = 1, #t do
        local Type, Name = t[i][1], t[i][2]
        if (MetaID == GetTag(Type, Name)) then
            return true
        end
    end
    return false
end

function Loadout:OnDamageApplication(VictimIndex, KillerIndex, MetaID, Damage, HitString, _)
    local killer, victim = tonumber(KillerIndex), tonumber(VictimIndex)
    local hurt = true

    if player_present(victim) then

        local kip = self:GetIP(killer)
        local vip = self:GetIP(victim)

        local v = self.players[vip]
        v.head_shot = false

        local v_info = self:GetLevelInfo(victim)

        if (killer > 0) then

            local k = self.players[kip]
            local k_info = self:GetLevelInfo(killer)

            local HeadShot = OnDamageLookup(victim, killer)
            if (HeadShot ~= nil and HitString == "head") then
                v.head_shot = true
            end

            if (v.class == "Armor Boost") then
                -- Check if self inflicted damage should apply:
                if (killer == victim and not self.classes[v.class].levels[v_info.level].self_damage) then
                    hurt = false

                    -- Calculate pvp damage resistance:
                elseif (killer ~= victim and not self:IsMelee(MetaID)) then

                    local resistance = self.classes[v.class].levels[v_info.level].damage_resistance
                    local VictimInVehicle = self:InVehicle(victim, true)

                    if (not VictimInVehicle) then
                        Damage = (Damage / resistance[1])
                    else
                        Damage = (Damage / resistance[2])
                    end
                    hurt = true
                end
            end

            if (k.class == "Armor Boost" and self:IsMelee(MetaID)) then
                Damage = Damage * (self.classes[k.class].levels[k_info.level].melee_damage_multiplier)
                hurt = true
            end

            k.last_damage = MetaID
        end

        if (v.class == "Cloak") then
            local DyN = get_dynamic_player(victim)
            if (DyN ~= 0) then
                local invisible = read_float(DyN + 0x37C)
                if (v.active_camo) and (invisible ~= 0) then
                    v.camo_pause, v.active_camo = false, false
                    execute_command("camo " .. victim .. " 1")
                    hurt = true
                end
            end
        end

        if (v.class == "Armor Boost") and (self.classes[v.class].levels[v_info.level].fall_damage_immunity) then
            if Loadout:isFallDamage(MetaID) then
                hurt = false
            end
        end

        v.regen_shield = true
        v.last_damage = MetaID
    end

    return hurt, Damage
end

function Loadout:isFallDamage(MetaID)
    local t = self.credits.tags.fall_damage
    for i = 1, #t do
        local Type, Name = t[i][1], t[i][2]
        if (MetaID == GetTag(Type, Name)) then
            return { t[i][3], t[i][4] }
        end
    end
    return false
end

function Loadout:Respond(Ply, Message, Type, Color, Exclude, HUD)
    Color = Color or 10
    execute_command("msg_prefix \"\"")
    if (Ply == 0) then
        cprint(Message, Color)
    else

        if (not HUD and Ply) then
            self:PauseHUD(Ply)
        end

        if (not Exclude) then
            if (Type ~= say_all) then
                Type(Ply, Message)
            else
                Type(Message)
            end
        else
            for i = 1, 16 do
                if player_present(i) and (i ~= Ply) then
                    self:PauseHUD(i)
                    Type(i, Message)
                end
            end
        end
    end
    execute_command("msg_prefix \" " .. self.server_prefix .. "\"")
end

function Loadout:GetPlayers(Executor, Args)
    local pl = { }
    if (Args[2] == "me") then
        if (Executor ~= 0) then
            table.insert(pl, Executor)
        else
            self:Respond(Executor, "Please enter a valid player id", rprint, 10)
        end
    elseif (Args[2] ~= nil) and (Args[2]:match("^%d+$")) then
        if player_present(Args[2]) then
            table.insert(pl, Args[2])
        else
            self:Respond(Executor, "Player #" .. Args[2] .. " is not online", rprint, 10)
        end
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
        if (#pl == 0) then
            self:Respond(Executor, "There are no players online!", rprint, 10)
        end
    else
        self:Respond(Executor, "Invalid Command Syntax. Please try again!", rprint, 10)
    end
    return pl
end

function GetXYZ(Ply)
    local coords, x, y, z = { }
    local DyN = get_dynamic_player(Ply)
    if (DyN ~= 0) then

        local VehicleID = read_dword(DyN + 0x11C)
        if (VehicleID == 0xFFFFFFFF) then
            coords.invehicle = false
            x, y, z = read_vector3d(DyN + 0x5c)
        else
            local obj_mem = get_object_memory(VehicleID)
            if (obj_mem ~= 0) then
                coords.invehicle = true
                x, y, z = read_vector3d(obj_mem + 0x5c)
            end
        end
    end

    coords.x, coords.y, coords.z, coords.dyn = x, y, z, DyN
    return coords
end

function OnServerCommand(P, C)
    return Loadout:OnServerCommand(P, C)
end

function OnPlayerDeath(V, K)
    return Loadout:OnPlayerDeath(V, K)
end

function OnTick()
    return Loadout:OnTick()
end

function OnPlayerScore(Ply)
    return Loadout:OnPlayerScore(Ply)
end

function OnPlayerSpawn(Ply)
    return Loadout:OnPlayerSpawn(Ply)
end

function OnDamageApplication(V, K, M, D, H, B)
    return Loadout:OnDamageApplication(V, K, M, D, H, B)
end

function OnPlayerPreSpawn(P)
    return Loadout:OnPlayerPreSpawn(P)
end

function GetObjectTagName(TAG)
    if (TAG ~= nil and TAG ~= 0) then
        return read_string(read_dword(read_word(TAG) * 32 + 0x40440038))
    end
    return nil
end

function Loadout:SetColor(Ply)

    if (self.modify_armor_color) then

        local DyN = get_player(Ply)
        if (DyN ~= 0) then

            local t = self:GetLevelInfo(Ply)
            local class = t.class
            if (t.switch_on_respawn[1]) then
                class = t.switch_on_respawn[2]
            end

            local color = "red"
            local team = get_var(Ply, "$team")
            if not IsTeamPlay() then
                color = self.classes[class].color.ffa
            else
                color = self.classes[class].color.team[team]
            end

            safe_write(true)
            for ColorName, ColorID in pairs(self.colors) do
                if (ColorName == color) then
                    write_byte(DyN + 0x60, ColorID)
                end
            end
            safe_write(false)
        end
    end
end

function Loadout:hasObjective(DyN)
    for i = 0, 3 do
        local WeaponID = read_dword(DyN + 0x2F8 + 0x4 * i)
        if (WeaponID ~= 0xFFFFFFFF) then
            local Weapon = get_object_memory(WeaponID)
            if (Weapon ~= 0) then
                local tag_address = read_word(Weapon)
                local tag_data = read_dword(read_dword(0x40440000) + tag_address * 0x20 + 0x14)
                if (read_bit(tag_data + 0x308, 3) == 1) then
                    return true
                end
            end
        end
    end
    return false
end

function Loadout:GetIP(Ply)
    local IP = get_var(Ply, "$ip")
    if (self.ClientIndexType == 1) then
        IP = IP:match("%d+.%d+.%d+.%d+")
    end
    if (not player_present(Ply)) then
        IP = ip_addresses[Ply]
    end
    return IP
end

function RegisterSAPPEvents()
    local gt = get_var(0, "$gt")
    if (gt == "ctf") or (gt == "slayer") or (gt == "race") then
        LSS(true)
        register_callback(cb["EVENT_TICK"], "OnTick")
        register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
        register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
        register_callback(cb["EVENT_SCORE"], "OnPlayerScore")
        register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
        register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
        register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
        register_callback(cb["EVENT_PRESPAWN"], "OnPlayerPreSpawn")
        register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")
        return true
    else
        LSS(false)
        unregister_callback(cb["EVENT_TICK"])
        unregister_callback(cb["EVENT_GAME_END"])
        unregister_callback(cb["EVENT_JOIN"])
        unregister_callback(cb["EVENT_DIE"])
        unregister_callback(cb["EVENT_SCORE"])
        unregister_callback(cb["EVENT_SPAWN"])
        unregister_callback(cb["EVENT_PRESPAWN"])
        unregister_callback(cb["EVENT_COMMAND"])
        unregister_callback(cb["EVENT_DAMAGE_APPLICATION"])
        cprint("WARNING: Loadout is not compatible with " .. gt, 4 + 8)
        return false
    end
end

function LSS(state)
    if (Loadout.modify_armor_color) then
        local ls
        if (state) then
            ls = sig_scan("741F8B482085C9750C")
            if (ls == 0) then
                ls = sig_scan("EB1F8B482085C9750C")
            end
            safe_write(true)
            write_char(ls, 235)
            safe_write(false)
        else
            if (ls == 0 or ls == nil) then
                return
            end
            safe_write(true)
            write_char(ls, 116)
            safe_write(false)
        end
    end
end

--======================================================
--======================================================
-- Credits to H® Shaft for this function:
-- Taken from https://pastebin.com/edZ82aWn
function OnDamageLookup(ReceiverIndex, CauserIndex)
    local response
    if get_var(0, "$gt") ~= "n/a" then
        if (CauserIndex and ReceiverIndex ~= CauserIndex) then
            if (CauserIndex ~= 0) then
                local r_team = read_word(get_player(ReceiverIndex) + 0x20)
                local c_team = read_word(get_player(CauserIndex) + 0x20)
                if (r_team ~= c_team) then
                    local tag_address = read_dword(0x40440000)
                    local tag_count = read_word(0x4044000C)
                    for A = 0, tag_count - 1 do
                        local tag_id = tag_address + A * 0x20
                        if (read_dword(tag_id) == 1785754657) then
                            local tag_data = read_dword(tag_id + 0x14)
                            if (tag_data ~= nil) then
                                if (read_word(tag_data + 0x1C6) == 5) or (read_word(tag_data + 0x1C6) == 6) then
                                    if (read_bit(tag_data + 0x1C8, 1) == 1) then
                                        response = true
                                    else
                                        response = false
                                    end
                                end
                            end
                        end
                    end
                end
            else
                response = false
            end
        end
    end
    return response
end
--

function WriteLog(str)
    local file = io.open("loadout.log", "a+")
    if (file) then
        file:write(str .. "\n")
        file:close()
    end
end

-- In the event of an error, the script will trigger these two functions: OnError(), report()
function report(StackTrace, Error)

    cprint(StackTrace, 4 + 8)

    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. script_version, 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)

    local timestamp = os.date("[%H:%M:%S - %d/%m/%Y]")
    WriteLog(timestamp)
    WriteLog("Please report this error on github:")
    WriteLog("https://github.com/Chalwk/HALO-SCRIPT-PROJECTS/issues")
    WriteLog("Script Version: " .. tostring(script_version))
    WriteLog("MAP: " .. get_var(0, "$map"))
    WriteLog("MODE: " .. get_var(0, "$mode"))
    WriteLog(Error)
    WriteLog(StackTrace)
    WriteLog("\n")
end

-- This function will return a string with a traceback of the stack call...
-- ...and call function 'report' after 50 milliseconds.
function OnError(Error)
    local StackTrace = debug.traceback()
    timer(50, "report", StackTrace, Error)
end
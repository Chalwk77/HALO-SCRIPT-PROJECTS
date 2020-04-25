--[[
--=====================================================================================================--
Script Name: Tactical Airstrike, for SAPP (PC & CE)
Description: Players who achieve a five-kill streak (killing five enemy players consecutively without dying) 
             are given the ability to call in an airstrike.

             Players will have the opportunity to select from 1 of 3 "strike" modes.

        Command Syntax:
        * /nuke <player id [number]>
        * /nuke mode <mode id [number]>
        * /nuke info
        * /nuke pl|players|playerlist

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--


api_version = "1.12.0.0"

-- Configuration [starts] ===================================================
local airstrike = {

    -- This is the main command a player will type to activate an airstrike.
    base_command = "nuke",
    info_command = "info",
    mode_command = "mode",

    -- Players can view the ID's of all players currently online with this command.
    player_list_command = "pl",

    server_prefix = "** SAPP ** ",

    -- All output messages:
    messages = {
        mode_select = "STRIKE MODE %mode% SELECTED",
        mode_not_enabled = "Mode #%mode% is not enabled for this map.",
        not_enough_kills = "You do not have enough kills to call an airstrike",
        cannot_strike_self = "You cannot call an airstrike on yourself!",
        player_offline_or_dead = "Player is offline or dead!",
        invalid_player_id = "Invalid Player ID!",
        console_error = "You cannot execute this command from the console!",
        mode_invalid_syntax = "Invalid Syntax or Invalid Mode. Usage: /%cmd% %mode_cmd% <mode id>",
        team_play_incompatible = "This mode is incompatible with team play!",
        strike_failed = "Unable to initiate Airstrike. Please contact an Administrator.",

        player_list_cmd_feedback = {
            header = "[ID - NAME]",
            player_info = "%id%  -  %name%",
            offline = "No other players online",
        },

        on_airstrike_call = {
            broadcast = {
                ["Mode A"] = { "%killer% called an airstrike on %victim%" },
                ["Mode B"] = { "%killer% called an airstrike on %opposing_team% team's base!" },
                ["Mode C"] = { "%name% called an airstrike!" },
            },
            killer_feedback = {
                "==========================",
                "  -- AIRSTRIKE CALLED --",
                "        B O O M !!",
                "=========================="
            }
        },
        reminder_message = {
            "To select your Airstrike Mode type /%base_command% %mode_cmd% <mode id>",
            "Modes: 1|2|3",
            "For information on each mode, type /%base_command% info",
        },
        incorrect_mode = {
            "You are not in the correct mode!",
            "Use: /%cmd% %mode_cmd% <mode id>"
        },
        info = {
            "-- ============== MODE INFORMATION ============== --",
            "Mode 1). Strike at a specific player's X,Y,Z map coordinates.",
            " ",
            "Mode 2). Strike called to (1 of X) locations surrounding the enemy base.",
            " ",
            "Mode 3). Strike called to a random (pre defined) x,y,z coordinate on the map.",
            "--=============================================================================--"
        },
        on_kill = {
            ["Mode A"] = {
                "-- ============ AIRSTRIKE AVAILABLE ============ --",
                "Type /%cmd% <player id> to call an airstrike on a player!",
                "Type /%cmd% %pl_cmd% to view a list of Player IDs"
            },

            ["Mode B"] = {
                "-- ============ AIRSTRIKE AVAILABLE ============ --",
                "Type /%cmd% to call an airstrike on the enemy base!"
            },

            ["Mode C"] = {
                "-- ============ AIRSTRIKE AVAILABLE ============ --",
                "Type /%cmd% to call an airstrike at a random location on the map!"
            },
        },
    },

    maps = {

        ["beavercreek"] = {
            enabled = true, -- enable airstrike feature for this map (set to false to disable).
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- NOTE: Two of the three modes MUST be FALSE (only ONE must be TRUE)
            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5, -- Number of kills required to enable airstrike mode
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5, -- Number of kills required to enable airstrike mode
                    strike_locations = {
                        -- X,Y,Z, Height From Ground
                        ["red"] = {
                            { 28.937, 13.523, 0.836, 20 },
                            { 25.841, 19.198, -0.217, 20 },
                            { 32.852, 13.935, -0.217, 20 },
                            { 26.323, 6.408, -0.217, 20 },
                            { 19.510, 13.729, -0.217, 20 },
                        },
                        ["blue"] = {
                            { 7.934, 13.743, -0.217, 20 },
                            { -0.964, 13.743, 0.836, 20 },
                            { 2.418, 8.010, -0.217, 20 },
                            { -4.459, 13.678, -0.217, 20 },
                            { 0.848, 20.180, -0.217, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5, -- Number of kills required to enable airstrike mode
                    strike_locations = {
                        { 11.362, 18.538, -0.217, 20 },
                        { 17.996, 8.274, -0.217, 20 },
                        { 18.001, 5.870, 3.548, 20 },
                        { 16.268, 17.293, 5.135, 20 },
                        { 24.902, 14.849, 2.061, 20 },
                        { 28.474, 15.185, 2.495, 20 },
                        { 28.804, 11.453, 2.494, 20 },
                        { 3.639, 11.435, 1.800, 20 },
                        { -0.687, 16.919, 2.259, 20 },
                        { 14.016, 8.132, -0.843, 20 },
                    }
                }
            }
        },

        ["bloodgulch"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 100,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 95.738, -159.466, -0.287, 20 },
                            { 102.924, -159.576, 0.187, 20 },
                            { 95.482, -166.738, 0.116, 20 },
                            { 88.513, -159.604, 0.116, 20 },
                            { 95.500, -152.701, 0.100, 20 },
                            { 95.436, -162.429, 1.783, 20 },
                            { 95.577, -156.274, 1.703, 20 },
                            { 84.881, -155.846, -0.075, 20 },
                            { 89.931, -172.344, 0.209, 20 },
                            { 100.009, -170.296, 0.227, 20 },
                            { 119.462, -182.986, 6.781, 20 },
                            { 112.651, -142.841, 0.239, 20 },
                            { 113.154, -128.205, 1.390, 20 },
                            { 63.167, -169.477, 3.651, 20 },
                            { 63.591, -176.145, 3.999, 20 },
                        },
                        ["blue"] = {
                            { 40.238, -79.124, -0.287, 20 },
                            { 40.314, -72.410, 0.186, 20 },
                            { 47.047, -79.165, 0.125, 20 },
                            { 40.016, -85.736, 0.131, 20 },
                            { 33.317, -79.109, 0.071, 20 },
                            { 40.276, -76.249, 1.783, 20 },
                            { 40.114, -81.944, 1.703, 20 },
                            { 28.655, -70.226, 0.460, 20 },
                            { 28.014, -112.472, 6.247, 20 },
                            { 44.626, -93.932, 0.810, 20 },
                            { 68.350, -73.734, 1.531, 20 },
                            { 77.544, -65.869, 4.725, 20 },
                            { 49.942, -81.076, 0.108, 20 },
                            { 59.401, -92.119, 0.174, 20 },
                            { 35.852, -65.083, 0.496, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 1,
                    strike_locations = {
                        { 95.696, -158.750, 1.703, 20 },
                        { 98.109, -151.062, 0.044, 20 },
                        { 82.585, -151.451, 0.121, 20 },
                        { 62.700, -168.103, 3.969, 20 },
                        { 60.492, -149.435, 6.265, 20 },
                        { 41.995, -126.763, 0.163, 20 },
                        { 63.247, -124.611, 0.813, 20 },
                        { 71.909, -125.715, 1.074, 20 },
                        { 64.594, -136.829, 1.977, 20 },
                        { 81.375, -117.107, 0.407, 20 },
                        { 82.755, -100.448, 1.984, 20 },
                        { 65.480, -104.017, 1.792, 20 },
                        { 53.695, -100.258, -0.077, 20 },
                        { 58.931, -96.066, 0.293, 20 },
                        { 44.190, -94.972, 0.879, 20 },
                        { 24.251, -105.223, 3.002, 20 },
                        { 40.899, -85.687, 0.132, 20 },
                        { 29.091, -73.504, 1.097, 20 },
                        { 58.638, -66.808, 1.266, 20 },
                        { 40.045, -80.791, 1.703, 20 },
                        { 97.752, -132.690, 0.549, 20 },
                        { 75.352, -136.137, 0.518, 20 },
                        { 57.396, -140.704, 1.015, 20 },
                        { 71.486, -138.073, 0.977, 20 },
                        { 95.902, -96.726, 4.048, 20 },
                        { 90.307, -91.818, 5.083, 20 },
                        { 68.473, -95.509, 1.551, 20 },
                    }
                }
            }
        },

        ["boardingaction"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 1,
                    strike_locations = {
                        ["red"] = {
                            { 3.463, -1.260, 0.220, 3 },
                            { -0.360, -1.590, 0.220, 3 },
                            { -0.340, 2.618, 0.220, 3 },
                            { 2.861, 3.821, 0.220, 3 },
                            { 3.180, -6.274, 0.220, 3 },
                            { -0.568, 5.113, 0.220, 3 },
                            { -0.631, 9.367, 0.220, 3 },
                            { -0.556, 12.966, 0.220, 3 },
                            { 0.266, 16.793, 0.220, 3 },
                            { 0.581, 21.682, 0.220, 3 },
                        },
                        ["blue"] = {
                            { 16.669, 1.473, 0.220, 3 },
                            { 16.901, -3.694, 0.220, 3 },
                            { 20.371, -2.470, 0.220, 3 },
                            { 20.534, -4.379, 0.220, 3 },
                            { 20.193, 1.394, 0.220, 3 },
                            { 16.951, 6.297, 0.220, 3 },
                            { 20.675, -9.011, 0.220, 3 },
                            { 20.538, -13.429, 0.220, 3 },
                            { 19.988, -16.314, 0.220, 3 },
                            { 19.689, -21.496, 0.220, 3 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 3.077, -19.802, 5.218, 3 },
                        { 0.984, -10.769, 5.218, 3 },
                        { 2.452, -12.817, 7.220, 3 },
                        { -0.437, -8.173, 5.218, 3 },
                        { 0.605, -2.045, 5.218, 3 },
                        { 0.605, 7.874, 5.218, 3 },
                        { 0.169, 17.625, 5.218, 3 },
                        { 1.161, 20.476, 5.218, 3 },
                        { 3.722, -17.002, 2.720, 3 },
                        { 0.773, -11.982, 2.720, 3 },
                        { -3.373, -6.386, 2.720, 3 },
                        { -2.464, -4.736, 2.720, 3 },
                        { -0.587, 0.425, 2.720, 3 },
                        { 2.933, 6.219, 2.520, 3 },
                        { 3.175, 11.235, 2.520, 3 },
                        { -0.221, 6.376, 2.720, 3 },
                        { 0.936, 9.583, 2.720, 3 },
                        { 0.424, 16.640, 2.720, 3 },
                        { 0.534, 20.834, 2.720, 3 },
                        { 1.252, -9.785, 0.220, 3 },
                        { 2.682, -4.743, 0.220, 3 },
                        { 3.027, -1.318, 0.220, 3 },
                        { 0.093, -1.566, 0.220, 3 },
                        { 0.064, 0.499, 0.220, 3 },
                        { -0.068, 2.741, 0.220, 3 },
                        { 2.939, 3.666, 0.220, 3 },
                        { -0.364, 6.721, 0.220, 3 },
                        { -1.933, 9.015, 0.220, 3 },
                        { -0.500, 11.837, 0.220, 3 },
                        { 0.169, 16.688, 0.220, 3 },
                        { 1.122, 14.675, 0.220, 3 },
                        { 0.549, 21.332, 0.220, 3 },
                        { 3.414, -20.539, -2.281, 3 },
                        { 0.785, -14.204, -2.281, 3 },
                        { 1.256, -7.433, -2.281, 3 },
                        { 3.787, -4.985, -2.281, 3 },
                        { 3.827, -0.389, -2.281, 3 },
                        { 3.714, 4.433, -2.281, 3 },
                        { 1.418, 14.699, -2.281, 3 },
                        { 1.207, 20.461, -2.281, 3 },
                        { 3.910, 21.232, -4.779, 3 },
                        { 3.581, 14.737, -4.779, 3 },
                        { 3.249, 9.184, -4.779, 3 },
                        { 3.303, 3.921, -2.281, 3 },
                        { 4.072, -1.063, -2.281, 3 },
                        { 3.241, -4.216, -4.779, 3 },
                        { 3.252, -8.563, -4.779, 3 },
                        { 3.748, -19.211, -4.779, 3 },
                        { 16.179, 19.253, 5.218, 3 },
                        { 19.072, 10.567, 5.218, 3 },
                        { 19.560, 1.670, 5.218, 3 },
                        { 22.249, -2.532, 5.218, 3 },
                        { 16.859, -7.295, 2.520, 3 },
                        { 16.634, -11.985, 2.520, 3 },
                        { 19.253, -19.703, 2.720, 3 },
                        { 18.956, -9.204, 2.720, 3 },
                        { 16.936, 12.785, 7.220, 3 },
                        { 15.872, 16.997, 2.720, 3 },
                        { 19.661, 9.673, 2.720, 3 },
                        { 23.144, 6.892, 2.720, 3 },
                        { 23.462, 4.388, 2.720, 3 },
                        { 21.052, 0.656, 2.720, 3 },
                        { 16.962, -7.248, 2.520, 3 },
                        { 16.918, -12.293, 2.520, 3 },
                        { 19.779, -20.488, 2.720, 3 },
                        { 18.998, -9.041, 2.720, 3 },
                        { 19.202, -21.364, 0.220, 3 },
                        { 20.199, -16.405, 0.220, 3 },
                        { 21.461, -8.917, 0.220, 3 },
                        { 20.569, -5.726, 0.220, 3 },
                        { 20.059, -2.793, 0.220, 3 },
                        { 16.681, -3.013, 0.220, 3 },
                        { 19.081, 1.040, 0.220, 3 },
                        { 16.570, 1.429, 0.220, 3 },
                        { 16.976, 6.121, 0.220, 3 },
                        { 20.305, 5.341, 0.220, 3 },
                        { 18.754, 19.191, 0.220, 3 },
                        { 16.572, 20.458, -2.281, 3 },
                        { 20.045, 16.693, -2.281, 3 },
                        { 15.920, 14.677, -2.281, 3 },
                        { 19.088, 7.286, -2.281, 3 },
                        { 17.089, 3.745, -2.281, 3 },
                        { 16.828, -4.406, -2.281, 3 },
                        { 19.634, -20.184, -2.281, 3 },
                        { 16.289, -21.026, -4.779, 3 },
                        { 16.893, -9.813, -4.779, 3 },
                        { 16.850, 4.735, -4.779, 3 },
                        { 16.760, 13.942, -4.779, 3 },
                        { 15.860, 20.192, -4.779, 3 },
                    }
                }
            }
        },

        ["carousel"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 4.733, -11.292, -3.358, 3 },
                            { 6.963, -12.817, -3.358, 3, 3 },
                            { 4.003, -13.948, -3.358 },
                            { -1.020, -13.754, -3.358, 3 },
                            { 9.320, -8.742, -3.358, 3 },
                            { 4.733, -11.292, -3.358, 6 },
                            { 6.963, -12.817, -3.358, 6 },
                            { 4.003, -13.948, -3.358, 6 },
                            { -1.020, -13.754, -3.358, 6 },
                            { 9.320, -8.742, -3.358, 6 },
                            { 2.049, -9.197, -3.358, 6 },
                            { -2.165, -9.160, -3.358, 6 },
                            { -6.677, -6.768, -3.358, 6 },
                            { 5.080, -10.380, -0.856, 6 },
                            { -0.218, -10.429, -0.856, 6 },
                            { -8.408, -9.678, -0.856, 6 },
                        },
                        ["blue"] = {
                            { -4.763, 11.222, -3.358, 3 },
                            { -4.292, 13.943, -3.358, 3 },
                            { -6.959, 12.801, -3.358, 3 },
                            { -9.911, 9.887, -3.358, 3 },
                            { 0.076, 13.896, -3.358, 3 },
                            { -0.047, 10.069, -0.856, 3, },
                            { 7.602, 7.578, -3.358, 3 },
                            { -5.416, 10.236, -0.856, 3 },
                            { -10.813, 5.053, -0.856, 3 },
                            { -3.848, 9.312, -3.358, 6 },
                            { -1.967, 6.683, -2.732, 6 },
                            { -6.964, 5.311, -3.264, 6 },
                            { 2.044, 7.588, -2.973, 6 },
                            { 6.751, 6.361, -3.358, 6 },
                            { 3.480, 3.070, -2.556, 6 },
                            { -3.920, 3.923, -2.556, 6 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 3.072, -3.370, -2.556, 6 },
                        { 9.606, -1.664, -3.358, 6 },
                        { 1.727, -9.578, -3.358, 6 },
                        { 6.583, -6.751, -3.358, 6 },
                        { 4.615, -4.807, -2.725, 6 },
                        { 3.556, -5.053, -2.571, 6 },
                        { 4.906, -3.155, -2.556, 6 },
                        { -11.023, -3.664, -0.856, 3 },
                        { -14.010, 0.215, -0.856, 3 },
                        { -9.603, 5.250, -0.856, 3 },
                        { -7.550, 7.970, -0.856, 3 },
                        { -5.123, 9.955, -0.856, 3 },
                        { 0.081, 10.486, -0.856, 3 },
                        { 9.910, 9.885, -0.856, 3 },
                        { 14.064, -0.016, -0.856, 3 },
                        { 10.659, 0.086, -0.856, 3 },
                        { 0.143, -0.045, -0.856, 3 },
                        { -5.582, 0.008, -0.856, 3 },
                        { 6.485, 0.017, -0.856, 3 },
                        { 0.011, 6.380, -0.856, 3 },
                        { 0.043, -5.961, -0.856, 3 },
                        { 4.398, 0.039, -2.556, 1 },
                        { -0.088, 4.866, -2.556, 1 },
                        { -4.783, 0.062, -2.556, 1 },
                        { 0.007, -4.530, -2.556, 1 },
                        { 4.620, -0.109, -2.556, 1 },
                        { 0.152, 4.555, -2.556, 1 },
                    }
                }
            }
        },

        ["chillout"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 6.071, -4.513, 2.381, 3 },
                            { 10.198, -4.316, 2.381, 3 },
                            { 8.809, 0.977, 2.381, 3 },
                            { 7.060, 0.902, 2.381, 3 },
                            { 3.881, -0.433, 2.381, 3 },
                            { 8.749, -0.367, 3.535, 1 },
                            { 10.605, 2.609, 3.535, 1 },
                        },
                        ["blue"] = {
                            { -6.582, 2.230, 1.215, 6 },
                            { -4.689, 8.050, 0.501, 6 },
                            { -5.792, 4.590, -0.000, 6 },
                            { -8.823, 4.956, -0.000, 6 },
                            { -8.704, 8.811, -0.000, 6 },
                            { -6.212, 9.880, -0.000, 6 },
                            { -6.204, 0.660, -0.000, 6 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 7.617, -4.106, 2.381, 1 },
                        { 7.294, -0.070, 2.381, 1 },
                        { 3.700, -0.461, 2.381, 1 },
                        { -0.605, -0.461, 2.784, 1 },
                        { 1.524, -2.938, -0.000, 1 },
                        { 4.099, -0.528, -0.000, 1 },
                        { -1.629, -0.555, -0.000, 1 },
                        { 0.064, 4.074, 0.746, 1 },
                        { 2.929, 3.727, 0.746, 1 },
                        { 1.493, 0.282, -0.000, 1 },
                        { -0.036, 6.650, 0.746, 1 },
                        { 1.320, 10.128, 0.746, 1 },
                        { 5.714, 9.889, 1.263, 1 },
                        { 4.710, 7.300, 3.535, 1 },
                        { -0.323, 9.012, 3.668, 1 },
                        { -0.275, 11.112, 4.168, 1 },
                        { 11.023, 2.865, 3.535, 1 },
                        { 9.682, 9.924, -0.000, 1 },
                        { 10.376, 5.052, -0.000, 1 },
                        { 9.763, 2.717, -0.000, 1 },
                        { 5.429, -0.452, -0.000, 1 },
                        { -6.249, 0.791, -0.000, 1 },
                        { -6.255, 2.253, 1.215, 1 },
                        { -6.289, 4.804, -0.000, 1 },
                        { -5.556, 10.122, -0.000, 1 },
                    }
                }
            }
        },

        ["damnation"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["dangercanyon"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["deathisland"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["gephyrophobia"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["hangemhigh"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["icefields"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["infinity"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["longest"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["prisoner"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["putput"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["ratrace"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["sidewinder"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["timberland"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        },

        ["wizard"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = { "proj", "weapons\\rocket launcher\\rocket" },
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                    height_from_ground = 20
                },
                ["Mode B"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0, 20 },
                        },
                        ["blue"] = {
                            { 0, 0, 0, 20 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = true,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0, 20 },
                    }
                }
            }
        }
    }
}
-- Configuration [ends] ===================================================


-- Do Not Touch --
-- TABLES:
local players = { }

-- Variables
local delta_time = 1 / 30
local game_over, map_name
local gmatch, lower, upper, gsub = string.gmatch, string.lower, string.upper, string.gsub

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")

    if (get_var(0, "$gt") ~= "n/a") then
        map_name = get_var(0, "$map")
    end
end

-- for projectile debugging --
local projectile_debug_mode = false
local TIMER = 0
local DELAY = 2 -- in seconds
--local MiddleX, MiddleY, MiddleZ, MiddleHeight = 65.749893188477, -120.40949249268, 0.11860413849354, 20
local MiddleX, MiddleY, MiddleZ, MiddleHeight = 4.620, -0.109, -2.556, 1
--

function OnTick()

    --for k,v in pairs(players) do
    --    if (k) then
    --        if (v.reminder.init) then
    --            v.reminder.timer = v.reminder.timer + delta_time
    --            if (v.reminder.timer == 0 and v.reminder.timer < 0.1) then
    --                cls(k, 25)
    --                for i = 1,#airstrike.messages.reminder_message do
    --                    rprint(k, airstrike.messages.reminder_message[i])
    --                end
    --            end
    --        end
    --    end
    --end

    -- PROJECTILE DEBUGGING:
    if (projectile_debug_mode) then
        TIMER = TIMER + 1 / 30
        if (TIMER >= DELAY) then
            TIMER = 0
            InitiateStrike(_, _, MiddleX, MiddleY, MiddleZ, MiddleHeight)
        end
    end

    local t = airstrike.objects
    if (not game_over) and (t) then

        if (#t > 0) then
            for i = 1, #t do
                local projectile_memory = get_object_memory(t[i])
                if (projectile_memory == 0) then
                    t[i] = nil
                end
            end
        end
    end
end

function OnDamageApplication(_, CauserIndex, MetaID, Damage, _, _)
    if (not game_over) and (CauserIndex == 0) then
        local t = airstrike.maps[map_name].dmg
        if (MetaID == TagInfo(t[1], t[2])) then
            return Damage * 10
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnPlayerSpawn(PlayerIndex)
    -- Reset victim kill count:
    players[PlayerIndex].kills = 0
end

function OnPlayerDisconnect(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function OnGameStart()
    game_over = false
    if (get_var(0, "$gt") ~= "n/a") then
        map_name = get_var(0, "$map")
    end
end

function OnGameEnd()
    game_over = true
end

function OnPlayerDeath(VictimIndex, KillerIndex)

    if (not game_over) then
        local killer, victim = tonumber(KillerIndex), tonumber(VictimIndex)
        if (killer > 0) and (killer ~= victim) then

            players[killer].kills = players[killer].kills + 1

            if HasRequiredKills(killer) then
                cls(killer, 25)
                local m = airstrike.messages.on_kill[players[killer].mode]
                for i = 1, #m do
                    local msg = gsub(gsub(m[i], "%%cmd%%", airstrike.base_command), "%%pl_cmd%%", airstrike.player_list_command)
                    Send(killer, msg, "rcon")
                end
            end
        end
    end
end

function HasRequiredKills(PlayerIndex)
    local t = players[PlayerIndex].mode
    local kills_required = airstrike.maps[map_name].modes[t].kills_required
    return players[PlayerIndex].kills >= kills_required
end

function IsTeamGame()
    if (get_var(0, "$ffa") == "0") then
        return true
    end
end

function InitPlayer(PlayerIndex, Reset)
    if (Reset) then
        players[PlayerIndex] = {}
    else
        players[PlayerIndex] = {
            name = get_var(PlayerIndex, "$name"),
            mode = airstrike.maps[map_name].default_mode
        }
    end
end

function InitiateStrike(Killer, Victim, x, y, z, height)

    local params = airstrike.maps[map_name]

    local min_x_vel = 0
    local max_x_vel = 0

    local min_y_vel = 0
    local max_y_vel = 0

    local min_z_vel = -1
    local max_z_vel = -1

    local projectile_x_vel = math.random(min_x_vel, max_x_vel)
    local projectile_y_vel = math.random(min_y_vel, max_y_vel)
    local projectile_z_vel = math.random(min_z_vel, max_z_vel)

    local projectile_object = params.projectile
    local object = TagInfo(projectile_object[1], projectile_object[2])
    if (object) then

        players[Killer].kills = 0

        for _ = params.min_projectiles, params.max_projectiles do

            local payload = spawn_object(projectile_object[1], projectile_object[2], x, y, z + height)
            local projectile = get_object_memory(payload)
            if (projectile ~= 0) then

                write_float(projectile + 0x68, projectile_x_vel)
                write_float(projectile + 0x6C, projectile_y_vel)
                write_float(projectile + 0x70, projectile_z_vel)

                airstrike.objects = airstrike.objects or {}
                airstrike.objects[#airstrike.objects + 1] = payload
            end
        end

        local msg = airstrike.messages.on_airstrike_call
        local Feedback = msg.killer_feedback
        for i = 1, #Feedback do
            Send(Killer, Feedback[i], "rcon")
        end

        local mode = players[Killer].mode
        for i = 1, 16 do
            if player_present(i) and (tonumber(i) ~= Killer) then
                Victim = Victim or 0
                local victim_name = get_var(Victim, "$name")
                local team = GetOpposingTeam(Killer)
                for j = 1, #msg.broadcast[mode] do
                    local Msg = gsub(gsub(gsub(msg.broadcast[mode][j],
                            "%%killer%%", players[Killer].name),
                            "%%victim%%", victim_name),
                            "%%opposing_team%%", team)
                    Send(i, Msg, "chat")
                end
            end
        end
    else
        Send(Killer, airstrike.messages.strike_failed, "rcon")
    end
end

function OnServerCommand(Killer, Command, _, _)

    local Cmd = CmdSplit(Command)
    if (#Cmd == 0) then
        return false
    else
        Cmd[1] = lower(Cmd[1]) or upper(Cmd[1])
        if (Cmd[1] == airstrike.base_command) then
            if (Killer ~= 0) then
                for player, v in pairs(players) do

                    if (player == Killer) then

                        cls(Killer, 25)
                        local args1, args2 = Cmd[2], Cmd[3]

                        -- MODE INFO COMMAND:
                        if (args1 ~= nil) then
                            if (tostring(args1) == airstrike.info_command) then

                                for i = 1, #airstrike.messages.info do
                                    Send(Killer, airstrike.messages.info[i], "rcon")
                                end

                                -- MODE SELECT COMMAND:
                            elseif (tostring(args1) == airstrike.mode_command) then
                                local mode = tonumber(args2)
                                if (mode ~= nil) then

                                    local old_mode = v.mode

                                    if (mode == 1) then
                                        v.mode = "Mode A"
                                    elseif (mode == 2) then
                                        v.mode = "Mode B"
                                    elseif (mode == 3) then
                                        v.mode = "Mode C"
                                    else
                                        mode = nil
                                    end

                                    local enabled, msg = airstrike.maps[map_name].modes[v.mode].enabled, ""
                                    if (mode) and (not enabled) then
                                        v.mode = old_mode
                                        msg = gsub(airstrike.messages.mode_not_enabled, "%%mode%%", mode)
                                    elseif (mode) and (enabled) then
                                        msg = gsub(airstrike.messages.mode_select, "%%mode%%", mode)
                                    end
                                    Send(Killer, msg, "rcon")
                                end

                                if (mode == nil) then
                                    local t = airstrike.messages.mode_invalid_syntax
                                    local msg = gsub(gsub(t, "%%cmd%%", airstrike.base_command), "%%mode_cmd%%", airstrike.mode_command)
                                    Send(Killer, msg, "rcon")
                                end

                                -- CUSTOM PLAYER LIST COMMAND
                            elseif (tostring(args1) == airstrike.player_list_command) then

                                local pl = GetPlayers(Killer)
                                if (#pl > 0) then
                                    local t = airstrike.messages.player_list_cmd_feedback
                                    Send(Killer, t.header, "rcon")
                                    for i = 1, #pl do
                                        local msg = gsub(gsub(t.player_info, "%%id%%", pl[i].id), "%%name%%", pl[i].name)
                                        Send(Killer, msg, "rcon")
                                    end
                                else
                                    Send(Killer, t.offline, "rcon")
                                end
                                -- AIRSTRIKE COMMAND MODE A

                                -- todo: fix NaN error
                            elseif (tonumber(args1) > 0 and tonumber(args1) < 17) then
                                if IsCorrectMode(Killer, "Mode A") then
                                    args1 = tonumber(args1)
                                    if (args1 ~= Killer) then
                                        local valid_player = player_present(args1) and player_alive(args1)
                                        if (valid_player) then
                                            if HasRequiredKills(Killer) then
                                                local DynamicPlayer = get_dynamic_player(args1)
                                                if (DynamicPlayer ~= 0) then
                                                    local player = GetXYZ(DynamicPlayer)
                                                    if (player) then
                                                        local height = airstrike.maps[map_name].modes["Mode A"].height_from_ground
                                                        InitiateStrike(Killer, args1, player.x, player.y, player.z, height)
                                                    end
                                                end
                                            else
                                                Send(Killer, airstrike.messages.not_enough_kills, "rcon")
                                            end
                                        else
                                            Send(Killer, airstrike.messages.player_offline_or_dead, "rcon")
                                        end
                                    else
                                        Send(Killer, airstrike.messages.cannot_strike_self, "rcon")
                                    end
                                end
                            else
                                Send(Killer, airstrike.messages.invalid_player_id, "rcon")
                            end
                            -- AIRSTRIKE COMMAND MODE B
                        elseif (v.mode == "Mode B") then
                            if IsTeamGame(Killer) then
                                if HasRequiredKills(Killer) then

                                    local team = GetOpposingTeam(Killer)
                                    local t = airstrike.maps[map_name].modes[v.mode].strike_locations[team]
                                    math.randomseed(os.clock())
                                    local coordinates = math.random(#t)
                                    local C = t[coordinates]
                                    local x, y, z, height = C[1], C[2], C[3], C[4]
                                    InitiateStrike(Killer, _, x, y, z, height)

                                else
                                    Send(Killer, airstrike.messages.not_enough_kills, "rcon")
                                end
                            else
                                Send(Killer, airstrike.messages.team_play_incompatible, "rcon")
                            end
                            -- AIRSTRIKE COMMAND MODE C
                        elseif (v.mode == "Mode C") then
                            if HasRequiredKills(Killer) then
                                local t = airstrike.maps[map_name].modes[v.mode].strike_locations
                                math.randomseed(os.clock())
                                local coordinates = math.random(#t)
                                local C = t[coordinates]
                                local x, y, z, height = C[1], C[2], C[3], C[4]
                                InitiateStrike(Killer, _, x, y, z, height)
                            else
                                Send(Killer, airstrike.messages.not_enough_kills, "rcon")
                            end
                        end
                    end
                end
            else
                cprint(airstrike.messages.console_error, 4 + 8)
            end
            return false
        end
    end
end

function GetXYZ(DynamicPlayer)
    local coordinates, x, y, z = {}
    local VehicleID = read_dword(DynamicPlayer + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        coordinates.invehicle = false
        x, y, z = read_vector3d(DynamicPlayer + 0x5c)
    else
        coordinates.invehicle = true
        x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end
    coordinates.x, coordinates.y, coordinates.z = x, y, z
    return coordinates
end

function CmdSplit(Command)
    local t, i = {}, 1
    for Args in gmatch(Command, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

function GetPlayers(ExcludePlayer)
    local pl = {}
    for i = 1, 16 do
        if player_present(i) then
            if (i ~= ExcludePlayer) then
                pl[#pl + 1] = { id = i, name = players[i].name }
            end
        end
    end
    return pl
end

function Send(PlayerIndex, Message, Environment)

    local responseFunction = say
    if (Environment == "rcon") then
        responseFunction = rprint
    end

    execute_command("msg_prefix \"\"")
    if (type(Message) ~= "table") then
        responseFunction(PlayerIndex, Message)
    else
        for j = 1, #Message do
            responseFunction(PlayerIndex, Message[j])
        end
    end
    execute_command("msg_prefix \" " .. airstrike.server_prefix .. "\"")
end

function TagInfo(Type, Name)
    local tag_id = lookup_tag(Type, Name)
    return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end

function GetOpposingTeam(PlayerIndex)
    local team = get_var(PlayerIndex, "$team")
    if (team == "red") then
        return "blue"
    elseif (team == "blue") then
        return "red"
    end
end

function IsCorrectMode(Killer, Mode)
    local CurrentMode = players[Killer].mode

    if (CurrentMode == Mode) then
        return true
    else
        local t = airstrike.messages.incorrect_mode
        for i = 1, #t do
            local msg = gsub(gsub(t[i], "%%cmd%%", airstrike.base_command), "%%mode_cmd%%", airstrike.mode_command)
            Send(Killer, msg, "rcon")
        end
    end
end

function cls(PlayerIndex, Count)
    for _ = 1, Count do
        Send(PlayerIndex, " ", "rcon")
    end
end

function OnScriptUnload()

end

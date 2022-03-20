-- Snipers Dream Team Mod [Settings File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

return {

    --[[
        -- MAP PORTAL FORMAT:
        format: {oX, oY, oZ, R, dX, dY, dZ, zOff}
        oX =     origin x
        oY =     origin y
        oZ =     origin z
        R =      origin x,y,z trigger radius
        dX =     destination x coord
        dY =     destination y coord
        dZ =     destination z coord
        zOff =   Extra height above ground at dZ
    ]]

    ["bloodgulch"] = {

        portals = {
            ---------------
            -- MAP PORTALS:
            ---------------
            { 48.046, -153.087, 21.181, 0.5, 23.112, -59.428, 16.352, 0.1 },
            { 43.258, -45.365, 20.901, 0.5, 82.068, -68.505, 18.101, 0.1 },
            { 82.459, -73.877, 15.729, 0.5, 67.970, -86.299, 23.393, 0.1 },
            { 77.756, -89.082, 22.434, 0.5, 92.456, -111.263, 14.945, 0.1 },
            { 101.136, -117.054, 14.962, 0.5, 105.877, -117.677, 15.323, 0.1 },
            { 116.826, -120.564, 15.109, 0.5, 124.988, -135.579, 13.575, 0.1 },
            { 131.785, -169.872, 15.951, 0.5, 127.812, -184.557, 16.420, 0.1 },
            { 120.665, -188.766, 13.752, 0.5, 109.956, -188.522, 14.437, 0.1 },
            { 97.476, -188.912, 15.718, 0.5, 53.653, -157.885, 21.753, 0.1 },
            { 56.664, -164.837, 22.795, 0.5, 96.744, -186.242, 14.131, 0.1 },
            { 111.995, -188.984, 14.651, 0.5, 122.376, -187.829, 13.938, 0.1 },
            { 129.211, -183.764, 17.222, 0.5, 130.083, -170.598, 14.916, 0.1 },
            { 128.141, -136.294, 14.547, 0.5, 112.550, -127.203, 1.905, 0.1 },
            { 118.263, -120.761, 17.192, 0.5, 39.968, -139.983, 2.518, 0.1 },
            { 102.131, -117.216, 14.871, 0.5, 100.467, -116.833, 14.929, 0.1 },
            { 90.741, -109.854, 14.751, 0.5, 74.335, -89.752, 23.676, 0.1 },
            { 68.909, -82.116, 22.843, 0.5, 82.065, -68.507, 18.152, 0.1 },
            { 78.907, -64.793, 19.836, 0.5, 33.687, -50.148, 19.162, 0.1 },
            { 21.916, -61.007, 16.189, 0.5, 50.409, -155.826, 21.830, 0.1 },
            { 14.852, -99.241, 8.995, 0.5, 50.409, -155.826, 21.830, 0.1 },
            { 98.559, -158.558, -0.253, 0.5, 63.338, -169.305, 3.702, 0.1 },
            { 98.541, -160.190, -0.255, 0.5, 119.995, -183.364, 6.667, 0.1 },
            { 92.538, -160.213, -0.215, 0.5, 112.550, -127.203, 1.905, 0.1 },
            { 92.550, -158.581, -0.256, 0.5, 46.934, -151.024, 4.496, 0.1 },
            { 98.935, -157.626, 0.425, 0.5, 96.431, -121.027, 3.757, 0.1 },
            { 74.304, -77.590, 6.552, 0.5, 76.001, -77.936, 11.425, 0.1 },
            { 94.351, -97.615, 5.184, 0.5, 92.792, -93.604, 9.501, 0.1 },
            { 84.848, -127.267, 0.563, 0.5, 74.335, -89.752, 23.676, 0.1 },
            { 63.693, -177.303, 5.606, 0.5, 19.030, -103.428, 19.150, 0.1 },
            { 70.535, -62.097, 5.392, 0.5, 122.491, -123.891, 15.646, 0.1 },
            { 89.473, -115.480, 17.013, 0.5, 108.005, -109.328, 1.924, 0.1 },
            { 120.605, -185.611, 7.626, 0.5, 95.746, -114.248, 16.032, 0.1 },
            { 43.125, -78.434, -0.273, 0.5, 15.720, -102.766, 13.465, 0.1 },
            { 43.112, -80.069, -0.278, 0.5, 68.123, -92.847, 2.167, 0.1 },
            { 37.105, -80.069, -0.255, 0.5, 108.005, -109.328, 1.924, 0.1 },
            { 37.080, -78.426, -0.238, 0.5, 79.924, -64.560, 4.669, 0.1 },
            { 38.559, -79.209, 0.769, 0.5, 69.833, -88.165, 5.660, 0.1 },
            { 43.456, -77.197, 0.633, 0.5, 29.528, -52.746, 3.100, 0.1 },
        },


        vehicles = {
            ---------------------------
            -- VEHICLE SPAWN LOCATIONS:
            ---------------------------
            ["LNZ-SDTM"] = { -- replace with your own game mode name
                { "vehi", "vehicles\\scorpion\\scorpion_mp", 23.598, -102.343, 2.163, 0, 30, 1 },
                { "vehi", "vehicles\\scorpion\\scorpion_mp", 38.119, -64.898, 0.617, -2.260, 30, 1 },
                { "vehi", "vehicles\\scorpion\\scorpion_mp", 51.349, -61.517, 1.759, -1.611, 30, 1 },
                { "vehi", "vehicles\\warthog\\mp_warthog", 28.854, -90.193, 0.434, -0.848, 30, 1 },
                { "vehi", "vehicles\\warthog\\mp_warthog", 43.559, -64.809, 1.113, 5.524, 30, 1 },
                { "vehi", "vehicles\\rwarthog\\rwarthog", 50.655, -87.787, 0.079, -1.936, 30, 1 },
                { "vehi", "vehicles\\rwarthog\\rwarthog", 62.745, -72.406, 1.031, 3.657, 30, 1 },
                { "vehi", "vehicles\\banshee\\banshee_mp", 70.078, -62.626, 3.758, 4.011, 30, 1 },
                { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 29.537, -53.667, 2.945, 5.110, 30, 1 },
                { "vehi", "vehicles\\scorpion\\scorpion_mp", 104.017, -129.761, 1.665, -3.595, 30, 1 },
                { "vehi", "vehicles\\scorpion\\scorpion_mp", 81.150, -169.359, 0.158, 1.571, 30, 1 },
                { "vehi", "vehicles\\scorpion\\scorpion_mp", 97.117, -173.132, 0.744, 1.532, 30, 1 },
                { "vehi", "vehicles\\warthog\\mp_warthog", 102.312, -144.626, 0.580, 1.895, 30, 1 },
                { "vehi", "vehicles\\warthog\\mp_warthog", 67.961, -171.002, 1.428, 0.524, 30, 1 },
                { "vehi", "vehicles\\rwarthog\\rwarthog", 106.885, -169.245, 0.091, 2.494, 30, 1 },
                { "vehi", "vehicles\\banshee\\banshee_mp", 64.178, -176.802, 3.960, 0.785, 30, 1 },
                { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 118.084, -185.346, 6.563, 2.411, 30, 1 },
                { "vehi", "vehicles\\ghost\\ghost_mp", 59.765, -116.449, 1.801, 0.524, 30, 1 },
                { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 51.315, -154.075, 21.561, 1.346, 30, 1 },
                { "vehi", "vehicles\\rwarthog\\rwarthog", 78.124, -131.192, -0.027, 2.112, 30, 1 },
            }
        }
    },

    ["deathisland"] = {

        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["icefields"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["infinity"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["sidewinder"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["timberland"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["dangercanyon"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["beavercreek"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["boardingaction"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["carousel"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["chillout"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["damnation"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["gephyrophobia"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["hangemhigh"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["longest"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["prisoner"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["putput"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["ratrace"] = {
        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    ["wizard"] = {

        ---------------
        -- MAP PORTALS:
        ---------------
        portals = {
            { 0, 0, 0, 0.5, 0, 0, 0, 0.1 },
        },


        ---------------------------
        -- VEHICLE SPAWN LOCATIONS:
        ---------------------------
        vehicles = {
            ["example_game_mode"] = {
                { "vehi", "", 0, 0, 0, 0, 30, 1 },
            }
        }
    },

    -- Message announced when a player is tea bagging:
    --
    t_bag_message = "$name is lap-dancing on $victim's body!",


    -- Radius (in w/units) a player must be from a victim's corpse to trigger a t-bag:
    --
    t_bag_radius = 2.5,


    -- A player's death coordinates expire after this many seconds:
    --
    t_bag_expiration = 120,


    -- A player must crouch over a victim's corpse this
    -- many times in order to trigger t-bag:
    --
    t_bag_crouch_count = 3,


    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished:
    server_prefix = "**ADMIN**"
}
-- Parkour Timer script by Jericho Crosby (Chalwk).
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

return {

    -- Path to the database file:
    --
    database_path = "./Parkour/database.json",

    -- Client data will be saved as a json array and
    -- the array index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for IP-only indexing.
    --
    client_index_type = 1,

    ----------------------------------
    -- Parkour Maps:
    ----------------------------------

    ['bloodgulch'] = {
        start = {
            96.45, -154.21, 0.13,
            94.65, -154.21, 0.13,
        },
        finish = {
            39.18, -84.43, 0.13,
            40.97, -84.43, 0.13,
        }
    },

    ['EV_Jump'] = {

        -- Starting line (straight line between the two points):
        start = {
            -- Point A (3x 32-bit floating point numbers):
            -0.80, -9.93, .30,

            -- Point B (3x 32-bit floating point numbers):
            0.30, -9.93, 0.30
        },

        -- Finish line (straight line between the two points):
        -- 3x 32-bit floating point numbers.
        finish = {
            -- Point A (3x 32-bit floating point numbers):
            50.19, 259.27, -18.62,

            -- Point B (3x 32-bit floating point numbers):
            52.79, 259.27, -18.62
        }
    },

    --
    -- Repeat the structure to add more maps:
    --
    ['another_map'] = {
        start = {
        },
        finish = {
        }
    }
}
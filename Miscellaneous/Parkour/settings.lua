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


    -- Player HUD:
    -- Shows the player's current time for this run.
    -- Shows the ID of the last checkpoint they reached.
    -- Shows the player's best time for this map.
    heads_up_display = "Time: $time | Checkpoint: $checkpoint | Best: $best",


    -- Set to true to enable flag spawning:
    -- Flag poles are a visual representation of the start/finish lines:
    -- Players need to cross a line to start or finish the course.
    -- Default: true
    --
    spawn_flags = true,


    -- If you die this many times, you will have to restart the course:
    -- Default: 10
    --
    restart_after = 10, -- CURRENTLY SET TO TWO FOR TESTING PURPOSES


    -- Set the respawn time (in seconds):
    -- Default: 3
    --
    respawn_time = 3, -- CURRENTLY SET TO ZERO FOR TESTING PURPOSES


    -- Set the running speed:
    -- Default: 1.4
    running_speed = 1.4,


    ----------------------------------
    -- Parkour Maps:
    ----------------------------------

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
        },

        -- Checkpoint coordinates:
        --
        checkpoints = {
            { 0.13, 11.79, 0.00 },
            { -10.32, 44.99, 0.00 },
            { -7.40, 63.75, 1.00 },
            { 10.30, 104.67, -6.62 },
            { 29.80, 125.55, -6.62 },
            { 27.86, 129.01, 0.28 },
            { 40.88, 129.08, 2.78 },
            { 28.25, 134.73, 5.23 },
            { 39.51, 137.22, 2.78 },
            { 51.54, 198.80, 5.36 }
        }
    },

    --
    -- Repeat the structure to add more maps:
    --
    ['another_map'] = {
        start = {
        },
        finish = {
        },
        checkpoints = {
        }
    }
}
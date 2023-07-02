return {

    -- Lock the server after a game has started:
    -- Default: false
    -- NOTE: This will prevent players from joining mid-game.
    --       If you want to allow players to join mid-game, set this to false.
    --       If this is set to false, new players will be put into spectator mode.
    lock_server = false,


    -- Server password set if the server is locked:
    -- Default: 'Broy@13'
    --
    password = 'Broy@13',


    -- If a player joins mid-game, should they be put into spectator mode?
    -- Default: true
    --
    new_player_spectate = true,

    commands = {
        ['restart'] = {
            enabled = true,
            name = 'restart',
            description = 'Restart the game',
            level = 4,
            help = 'Syntax: /$cmd'
        },
        ['get_spawn_coords'] = {
            enabled = true,
            name = 'c',
            description = 'Get coordinates: {x,y,z,rotation,height}',
            level = 4,
            help = 'Syntax: /$cmd'
        }
    },

    --- Server prefix:
    -- A message relay function temporarily removes the 'msg_prefix' (server prefix),
    -- and will restore it after the message has been sent.
    --
    prefix = '**SAPP**'
}
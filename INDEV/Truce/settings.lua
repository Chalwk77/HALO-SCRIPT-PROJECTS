return {
    commands = {
        ['accept'] = true,
        ['deny'] = true,
        ['truce'] = true,
        ['trucelist'] = true,
        ['untruce'] = true
    },

    --
    -- [!] These settings are for advanced users only [!]
    --

    -- When a player joins, the server will create an iterable
    -- cache of data for them.

    -- If you want a player's truce to expire when they quit,
    -- you must index this by IP address, as opposed to player id.
    -- Valid options: 'ip' or 'id'.
    --
    player_cache_index = 'ip',

    -- These two settings only apply if player_cache_index is set to 'ip'.
    --
    expire_on_quit = false,
    expire_on_new_game = false
}

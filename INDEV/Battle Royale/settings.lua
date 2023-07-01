return {

    commands = {
        ['restart'] = {
            enabled = true,
            name = 'restart',
            description = 'Restart the game',
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
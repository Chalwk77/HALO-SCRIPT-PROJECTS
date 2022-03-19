-- Word Buster Settings file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

return {

    -- Infraction Count:
    -- How many infractions before a user is punished
    -- Default: 5
    warnings = 5,


    -- Grace Period:
    -- Infractions reset after this many days of no profanity.
    -- Default: 1
    grace_period = 1,


    -- Notify Text:
    -- Warn user when they use profanity (if not last warning).
    notify_text = 'Please do not use profanity.',


    -- Notify Warning Text:
    last_warning = 'Last warning. You will be punished if you continue to use profanity.',


    -- Punishment:
    -- Valid punishments: 'kick' or 'ban'
    punishment = 'kick',


    -- Notify Punish Text:
    on_punish = '"You were $punishment for profanity"',


    -- Ban Time:
    -- Maximum time (in minutes) that a user will be banned
    ban_duration = 10,


    -- Language Directory.
    -- Folder path to language files database:
    lang_directory = './WordBuster/langs/',


    -- Infractions Directory.
    -- Folder path to infractions json database:
    infractions_directory = './WordBuster/infractions.json',


    -- Console notification:
    -- Sends a notification to the server console when someone gets an infraction:
    notify_console = true,


    -- Notify infraction message:
    notify_console_format = '[INFRACTION] | $name | $word | $regex | $lang',


    -- Ignore bad words in commands?
    ignore_commands = true,


    -- Commands:
    -- Remove the command name to disable it.
    --
    -- However, do not change the command name here.
    -- Do that in in the command file (see below): "/WordBuster/Commands/command_name" -> name property.
    --
    commands = {
        'wb_langs',
        'wb_add_word',
        'wb_add_word',
        'wb_add_word',
        'wb_del_word',
        'wb_enable_lang',
        'wb_disable_lang'
    },


    -- Languages:
    -- Which languages should be loaded?
    languages = {
        ['cs.txt'] = false, -- Czech
        ['da.txt'] = false, -- Danish
        ['de.txt'] = false, -- German
        ['en.txt'] = true, -- English
        ['eo.txt'] = false, -- Esperanto
        ['es.txt'] = true, -- Spanish
        ['fr.txt'] = false, -- French
        ['hu.txt'] = false, -- Hungry
        ['it.txt'] = false, -- Italy
        ['ja.txt'] = false, -- Japan
        ['ko.txt'] = false, -- Korea
        ['nl.txt'] = false, -- Dutch
        ['no.txt'] = false, -- Norway
        ['pl.txt'] = false, -- Poland
        ['pt.txt'] = false, -- Portuguese
        ['ru.txt'] = false, -- Russia
        ['sv.txt'] = false, -- Swedish
        ['th.txt'] = false, -- Thai
        ['tr.txt'] = false, -- Turkish
        ['zh.txt'] = false, -- Chinese
        ['tlh.txt'] = false -- Vietnamese
    },

    -- Patterns                [!] ADVANCED USERS ONLY [!]
    -- Lua patterns used to block variations of bad words:

    patterns = {
        ['a'] = { '[aA@]', '[aA@][%-%s]' },
        ['b'] = { '[bB]', '[bB][%-%s]' },
        ['c'] = { '[cCkK]', '[cCkK][%-%s]' },
        ['d'] = { '[dD]', '[dD][%-%s]' },
        ['e'] = { '[eE3]', '[eE3][%-%s]' },
        ['f'] = { '[fF]', '[fF][%-%s]' },
        ['g'] = { '[gG6]', '[gG6][%-%s]' },
        ['h'] = { '[hH]', '[hH][%-%s]' },
        ['i'] = { '[iIl!1]', '[iIl!1][%-%s]' },
        ['j'] = { '[jJ]', '[jJ][%-%s]' },
        ['k'] = { '[cCkK]', '[cCkK][%-%s]' },
        ['l'] = { '[lL1!i]', '[lL1!i][%-%s]' },
        ['m'] = { '[mM]', '[mM][%-%s]' },
        ['n'] = { '[nN]', '[nN][%-%s]' },
        ['o'] = { '[oO0]', '[oO0][%-%s]' },
        ['p'] = { '[pP]', '[pP][%-%s]' },
        ['q'] = { '[qQ9]', '[qQ9][%-%s]' },
        ['r'] = { '[rR]', '[rR][%-%s]' },
        ['s'] = { '[sS$5]', '[sS$5][%-%s]' },
        ['t'] = { '[tT7]', '[tT7][%-%s]' },
        ['u'] = { '[uUvV]', '[uUvV][%-%s]' },
        ['v'] = { '[vVuU]', '[vVuU][%-%s]' },
        ['w'] = { '[wW]', '[wW][%-%s]' },
        ['x'] = { '[xX]', '[xX][%-%s]' },
        ['y'] = { '[yY]', '[yY][%-%s]' },
        ['z'] = { '[zZ2]', '[zZ2][%-%s]' },
    }
}
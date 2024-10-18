--========================================================================--
-- Expressions (v2.1), for SAPP (PC & CE)
-- Description: Want to express your rage, taunt your opponents or
--              cuss in a family-friendly-ish way? Look no further!
-- Copyright (c) 2022-2024, Jericho Crosby <jericho.crosby227@gmail.com>
-- License: See https://github.com/Chalwk/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--========================================================================--

api_version = "1.12.0.0"

local expressions = {
    phrases = {
        ["!cuss"] = { -- type this in chat to cuss
            "Shnookerdookies!",
            "Fudge nuggets!",
            "Cheese and rice!",
            "Sugar!",
            "Poo!",
            "Snickerdoodle!",
            "Banana shenanigans!",
            "Six and two is eight!",
            "God bless it!",
            "Barbara Streisand!",
            "Fiddlesticks!",
            "Jiminy Crickets!",
            "Son of a gun!",
            "Egad!",
            "Great Scott!",
            "Caesar's ghost!",
            "Merlin's beard!",
            "Merlin's pants!",
            "Shucks!",
            "Darn!",
            "Dagnabbit!",
            "Dang rabbit!",
            "Dadgummit!",
            "Jumpin' Jiminy!"
            --
            -- repeat the structure to add more entries
            --
        },

        ["!anger"] = { -- type this in chat to express anger
            "FOR GOODNESS SAKES",
            "OUH C'MON!",
            "ARE YOU SERIOUS!?",
            "WHAT A LOAD OF BOLLOCKS",
            "OH HELL NAH!",
            "GRRRRRRR!!",
            "*FLARES NOSTRILS*",
            "*SCREAMS AT TOP OF LUNGS*",
            "BOLLOCKS"
            --
            -- repeat the structure to add more entries
            --
        },

        ["!taunt"] = { -- type this in chat to taunt
            "Ees too bad you got manure for brains!!",
            "Hell's full a' retired Gamers, And it's time you join em!",
            "Hell! My horse pisses straighter than you shoot!!",
            "Can't you do better than that! I've seen worms move faster!",
            "Not good enough!",
            "Hell - I can already smell your rotting corpse.",
            "Today is a good day to die, Mr!",
            "I'm going to send ya to an early grave",
            "Had enough yet?!",
            "Damn you and the horse you rode in on!",
            "Time to fit you for a coffin!",
            "Your life ends in the wasteland...",
            "Sell your PC. Just do it.",
            "Don't be shy! You can shoot at me next time, I don't mind!",
            "You must be new at this!",
            "Is that really a gun in your hand or is it just wishful thinkin'!",
            --
            -- repeat the structure to add more entries
            --
        }
    },

    output = {
        [0] = '$name: $msg',
        [1] = '[$name]: $msg',
        [2] = '[$name]: $msg'
    },
    server_prefix = '**SAPP**'
}

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], 'OnChat')
end

local function formatMessage(chatType, playerName, message)
    local format = expressions.output[chatType]
    return format:gsub('$name', playerName):gsub('$msg', message)
end

local function getRandomPhrase(phrases)
    local randomIndex = rand(1, #phrases + 1)
    return phrases[randomIndex]
end

function OnChat(playerId, message, chatType)
    local lowerMessage = message:lower()
    local phrases = expressions.phrases[lowerMessage]

    if phrases then
        local randomPhrase = getRandomPhrase(phrases)
        local playerName = get_var(playerId, '$name')
        local formattedMessage = formatMessage(chatType, playerName, randomPhrase)

        execute_command('msg_prefix ""')
        say_all(formattedMessage)
        execute_command('msg_prefix "' .. expressions.server_prefix .. '"')

        return false
    end
end

function OnScriptUnload()
    -- N/A
end
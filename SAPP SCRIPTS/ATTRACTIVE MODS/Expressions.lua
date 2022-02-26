--[[
--=====================================================================================================--
Script Name: Expressions (v2.1), for SAPP (PC & CE)
Description: Want to express your rage, taunt your opponents or
             cuss in a family-friendly-ish way? Look no further!

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local Expressions = {

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

    -- Taunt message output format:
    output = {

        -- Global chat:
        [0] = "$name: $msg",

        -- Team chat:
        [1] = "[$name]: $msg",

        -- Vehicle chat:
        [2] = "[$name]: $msg"
    },

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    server_prefix = "**SAPP**"
}

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnChat")
end

function OnChat(Ply, Msg, Type)

    Msg = Msg:lower()
    Msg = Expressions.phrases[Msg]

    if (Msg) then
        Msg = Msg[rand(1, #Msg + 1)]
        local name = get_var(Ply, "$name")
        local output = Expressions.output[Type]
        local msg = output:gsub("$name", name):gsub("$msg", Msg)
        execute_command("msg_prefix \"\"")
        say_all(msg)
        execute_command("msg_prefix \"" .. Expressions.server_prefix .. "\"")
        return false
    end
end

function OnScriptUnload()
    -- N/A
end

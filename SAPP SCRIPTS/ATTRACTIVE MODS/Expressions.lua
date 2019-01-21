--[[
--=====================================================================================================--
Script Name: Expressions, for SAPP (PC & CE)
Description: Want to express your rage, taunt your opponents or cuss in a family-friendly-ish way? Look no further!

Type "!cuss" to cuss
Type "!anger" to express anger
Type "!taunt" to taunt the enemy!

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"

-- Configuration [starts]
cuss_expression = "!cuss"
anger_expression = "!anger"
taunt_expression = "!taunt"
server_prefix = "**SERVER** "

expressions = {
    anger = {
        "FOR GOODNESS SAKES",
        "OUH C'MON!",
        "ARE YOU SERIOUS!?",
        "WHAT A LOAD OF BOLLOCKS",
        "OH HELL NAH!",
        "GRRRRRRR!!",
        "*FLARES NOSTRILS*",
        "*SCREAMS AT TOP OF LUNGS*",
        "BOLLOCKS"
        -- Make sure the last entry in the table doesn't have a comma.
        -- Repeat the structure to add more entries.
    },
    cuss = {
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
        -- Make sure the last entry in the table doesn't have a comma.
        -- Repeat the structure to add more entries.
    },
    taunt = {
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
        "Is that really a gun in your hand or is it just wishful thinkin'!"
        -- Make sure the last entry in the table doesn't have a comma.
        -- Repeat the structure to add more entries.
    }
}
-- Configuration [ends] -----------------------------------------------------------------

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
end

function OnScriptUnload()

end

function OnPlayerChat(PlayerIndex, Message, Type)
    local msg = string.lower(Message)
    if (msg == anger_expression) then
        execute_command("msg_prefix \"\"")
        say_all(get_var(PlayerIndex, "$name") .. ": " .. expressions.anger[randomize(expressions.anger)])
        execute_command("msg_prefix \"" .. server_prefix .. "\"")
        return false

    elseif (msg == cuss_expression) then
        execute_command("msg_prefix \"\"")
        say_all(get_var(PlayerIndex, "$name") .. ": " .. expressions.cuss[randomize(expressions.cuss)])
        execute_command("msg_prefix \"" .. server_prefix .. "\"")
        return false

    elseif (msg == taunt_expression) then
        execute_command("msg_prefix \"\"")
        say_all(get_var(PlayerIndex, "$name") .. ": " .. expressions.taunt[randomize(expressions.taunt)])
        execute_command("msg_prefix \"" .. server_prefix .. "\"")
        return false
    end
end

function randomize(array)
    math.randomseed(os.time())
    math.random();
    math.random();
    math.random()
    local index = math.random(1, #array)
    return index
end

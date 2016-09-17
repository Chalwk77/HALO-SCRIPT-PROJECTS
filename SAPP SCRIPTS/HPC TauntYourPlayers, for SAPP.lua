--[[
------------------------------------
Script Name: HPC TauntYourPlayers, for SAPP
    - Implementing API version: 1.10.0.0

Description: This script will display 1-30 random taunting messages
             from a lua table to your players under two events:
             events: OnGameEnd | OnPlayerDie

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]-- 

api_version = "1.10.0.0"

-- Script Settings
local tPrefix = "[TAUNT]"
-- If True, the script will send taunt messages to the victim.
local tauntsonDeath = true
-- If True, the script will send taunt messages to the player.
local tauntsOnGameEnd = true

function OnScriptUnload()

end

function OnScriptLoad(PlayerIndex, Message)
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_DIE'], "OnPlayerDie")
end

function OnPlayerDie(PlayerIndex, KillerIndex)

    local victimPlayer = tonumber(KillerIndex)
    if PlayerIndex == victimPlayer then return false
    elseif (victimPlayer == 0) then return false
    elseif (victimPlayer == -1) then return false
    elseif (PlayerIndex == nil) then return false
    
    -- We only want to display messages to the victim if he was killed 
    -- by another player, not from suicides and vehicle deaths ect.
    elseif (victimPlayer == > 0) and tauntsonDeath == true then
        local tauntMessages = {
            " Aw, "..get_var(PlayerIndex,"$name")..", I seen better shooting at the county fair!",
            " Ees too bad you got manure for brains!!",
            " Hell's full a' retired Gamers, "..get_var(PlayerIndex,"$name")..", And it's time you join em!",
            " Hell! My horse pisses straighter than you shoot!!",
            " Can't you do better than that! I've seen worms move faster!",
            " Not good enough "..get_var(PlayerIndex,"$name")..", not good enough!",
            " Hell - I can already smell your rotting corpse.",
            " Today is a good day to die "..get_var(PlayerIndex,"$name").."!!",
            " Huh, too slow!! You will regret that!!",
            " You insult me, "..get_var(PlayerIndex,"$name").."!!",
            " I'm going to send ya to an early grave!!",
            " Had enough yet?!",
            " Hope ya plant better than ya shoot!!",
            " Damn you and the cyber you rode in on!!",
            " Time to fit you for a coffin!!",
            " You have a date with the undertaker!!",
            " Your life ends in the wasteland...",
            " Rest in peace, "..get_var(PlayerIndex,"$name")..".",
            " You fought valiantly... but to no avail.",
            " You're dead. Again, "..get_var(PlayerIndex,"$name").."!",
            " You're dead as a doornail.",
            " Time to reload, "..get_var(PlayerIndex,"$name")..".",
            " Here's a picture of your corpse. Not pretty.",
            " Boy, are you stupid. And dead.",
            " Ha ha ha ha ha. You're dead, moron!",
            " Couldn't charm your way out of that one, "..get_var(PlayerIndex,"$name")..".",
            " Nope. Just Nope.",
            " You have perished. What a Shame.",
            " Sell your PC. Just do it.",
            " You disappoint me, "..get_var(PlayerIndex,"$name").."."
        }
        -- Temporarily modify Server Prefix
        execute_command("msg_prefix " ..tPrefix)
        local tauntPlayer = GetRandomElement(tauntMessages)
        rprint(PlayerIndex, tauntPlayer)
        -- Reset Server Prefix
        execute_command("msg_prefix \"** SAPP ** \"")
    end
end

-- I plan on updating this function in the future.
function OnGameEnd(PlayerIndex)
    
    if tauntsOnGameEnd == true then
    local validatePlayer = GetValidPlayer(PlayerIndex)
        if validatePlayer then
            local kills = tonumber(read_word(validatePlayer + 0x9C))
            if (kills == 0) then
                say(PlayerIndex, "You have no kills... noob alert!")
            end
            if (kills == 1) then
                say(PlayerIndex, "One kill? You must be new at this...")
            end
            if (kills == 2) then
                say(PlayerIndex, "Eh, two kills... not bad. But you still suck.")
            end
            if (kills == 3) then
                say(PlayerIndex, "Relax sonny! 3 kills, and you be like... mad bro?")
            end
            if (kills == 4) then
                say(PlayerIndex, "Dun dun dun... them 4 kills though!")
            end
            if (kills > 4) then
                say(PlayerIndex, "Well, you've got more than 4 kills... #AchievingTheImpossible")
            end
        end
    end
end

function GetValidPlayer(PlayerIndex)
    if tonumber(PlayerIndex) then
        if tonumber(PlayerIndex) ~= 0 then
            local validatePlayer = get_player(PlayerIndex)
            if validatePlayer ~= 0 then return validatePlayer end
        end
    end
    return nil
end

function GetRandomElement(a)
    return a[math.random(#a)]
end

function OnError(Message)
    print(debug.traceback())
end
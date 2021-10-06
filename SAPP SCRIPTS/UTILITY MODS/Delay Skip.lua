--[[
--=====================================================================================================--
Script Name: Skip Delay, for SAPP (PC & CE)
Description: This script prevents players from skipping the game too early.

Scenario: A player with a good ping (and bad intentions) joins the server after a new game has just begun
          and immediately types "skip", thus ending the game before anyone else joins.

I've heard cases of people binding this to a key too.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

-- Time (in seconds) until skipping can occur:
--
local delay = 10

-- config ends --

api_version = "1.12.0.0"

local time

function OnScriptLoad()

    register_callback(cb["EVENT_CHAT"], "Skip")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    OnGameStart()
end

local function Plural(n)
    return (n > 1 and "s") or ""
end

function Skip(Ply, Msg)
    if (time and Msg:sub(1, Msg:len()):lower() == "skip") then
        local n = math.ceil(time + delay - os.clock())
        if (n > 0) then
            rprint(Ply, "Please wait " .. n .. " second" .. Plural(n) .. " before attempting to skip")
            return false
        end
    end
end

function OnGameStart()
    time = nil
    if (get_var(0, "$gt") ~= "n/a") then
        time = os.clock()
    end
end

function OnGameEnd()
    time = nil
end

function OnScriptUnload()
    -- N/A
end
--[[
--=====================================================================================================--
Script Name: Rules Command, for SAPP (PC & CE)
Description: Custom command to show server rules.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

--------------------------
-- configuration starts --
--------------------------

-- This is the custom command used to view the rules (See Rules table):
--
local command = "rules"


-- This announcement will be broadcast every "interval" seconds:
--
local announcement = "Type /" .. command .. " to view the game rules."


-- Time (in seconds) between each announcement (see above):
--
local interval = 180


-- Rules Table:
--
local Rules = {
    "1. Do not betray your team mates.",
    "2. Do not block any entrances or teleports.",
    "3. Do not be toxic, be a good spot!",
    "5. Do not camp on any forbidden places.",
    "4. If you're a zombie, press melee key to infect them.",
}


-- A message relay function temporarily removes the server prefix
-- and will restore it to this when the relay is finished:
--
local server_prefix = "**BK**"

------------------------
-- configuration ends --
------------------------

api_version = "1.12.0.0"

local game_started

function OnScriptLoad()

    register_callback(cb["EVENT_COMMAND"], "ShowRules")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    OnGameStart()
end

function ShowRules(Ply, CMD, _, _)
    if (CMD:sub(1, command:len()):lower() == command) then
        for _, Rule in pairs(Rules) do
            rprint(Ply, Rule)
        end
        return false
    end
end

function ShowAnnouncement()
    execute_command("msg_prefix \"\"")
    say_all(announcement)
    execute_command("msg_prefix \"" .. server_prefix .. "\"")
    return game_started
end

function OnGameStart()
    game_started = false
    if (get_var(0, "$gt") ~= "n/a") then
        game_started = true
        timer(1000 * interval, "ShowAnnouncement")
    end
end

function OnGameEnd()
    game_started = false
end
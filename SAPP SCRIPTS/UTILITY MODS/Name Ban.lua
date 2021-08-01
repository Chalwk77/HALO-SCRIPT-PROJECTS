--[[
--=====================================================================================================--
Script Name: Name Blacklist, for SAPP (PC & CE)
Description: Players have names that you don't like? No problem!

-- NOTE: This is not an anti-impersonator script!

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

api_version = "1.12.0.0"

-- config starts --
-- When a player joins, their name is cross-checked against this list.
-- If a match is made, they will be instantly kicked.
--
local blacklist = {

    "Hacker",
    "{BK} DIEGO",
    "TᑌᗰᗷᗩᑕᑌᒪOᔕ",
    "TUMBACULOS",

    -- repeat the structure to add more entries
}

-- How soon after they join should the player be kicked (in seconds)?
--
local time_until_kick = 1 / 30

-- Kick Reason:
--
local reason = "Inappropriate Name"
-- config ends --

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "CheckName")
end

function CheckName(Ply)
    local name = get_var(Ply, "$name")
    for i = 1, #blacklist do
        if (name == blacklist[i]) then
            timer(1000 * time_until_kick, "KickPlayer", Ply)
            break
        end
    end
end

function KickPlayer(Ply)
    execute_command("k" .. " " .. Ply .. " \"" .. reason .. "\"")
end
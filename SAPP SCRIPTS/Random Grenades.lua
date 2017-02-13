--[[
------------------------------------
Script Name: Random Grenades, for SAPP | (PC\CE)
    - Implementing API version: 1.11.0.0
    
    Description:    You will spawn with a random number of Frag/Plasma grenades
                    If you do not wish to spawn with a random number of grenades,
                    you can manually define how many you spawn with (on a per map basis) from line 108 onwards.
                    
Do not remove comments unless you're debugging.
A comment starts anywhere with a double hyphen ( -- ).

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]--

api_version = "1.11.0.0"
frags = { }
plasmas = { }

-- Configuration Starts --
Min_Frags = 1 -- Minimum number of frag grenades to spawn with
Max_Frags = 4 -- Maximum number of frag grenades to spawn with

Min_Plasmas = 1 -- Minimum number of plasma grenades to spawn with
Max_Plasmas = 4 -- Maximum number of plasma grenades to spawn with

gamesettings = {
    ["RANDOM_FRAGS"] = true,
    ["RANDOM_PLASMAS"] = true
}
-- Configuration Ends --

function OnScriptLoad()
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    -- Debugging --
    -- Uncomment the 'EVENT_DIE' callback element for debugging.
    --  register_callback(cb['EVENT_DIE'], "OnPlayerKill")
end

function OnScriptUnload()
    frags = { }
    plasmas = { }
end

function OnPlayerSpawn(PlayerIndex)
    if player_alive(PlayerIndex) then
        local RandomFR = math.random(tonumber(Min_Frags), tonumber(Max_Frags))
        local RandomPL = math.random(tonumber(Min_Plasmas), tonumber(Max_Plasmas))
        local player_object = get_dynamic_player(PlayerIndex)
        local mapname = get_var(0, "$map")
        if (player_object ~= 0) then
            if (gamesettings["RANDOM_FRAGS"]) == true then
                frags = {
                    beavercreek = RandomFR,
                    bloodgulch = RandomFR,
                    boardingaction = RandomFR,
                    carousel = RandomFR,
                    dangercanyon = RandomFR,
                    deathisland = RandomFR,
                    gephyrophobia = RandomFR,
                    icefields = RandomFR,
                    infinity = RandomFR,
                    sidewinder = RandomFR,
                    timberland = RandomFR,
                    hangemhigh = RandomFR,
                    ratrace = RandomFR,
                    damnation = RandomFR,
                    putput = RandomFR,
                    prisoner = RandomFR,
                    wizard = RandomFR,
                }
            end
            if (gamesettings["RANDOM_PLASMAS"]) == true then
                plasmas = {
                    beavercreek = RandomPL,
                    bloodgulch = RandomPL,
                    boardingaction = RandomPL,
                    carousel = RandomPL,
                    dangercanyon = RandomPL,
                    deathisland = RandomPL,
                    gephyrophobia = RandomPL,
                    icefields = RandomPL,
                    infinity = RandomPL,
                    sidewinder = RandomPL,
                    timberland = RandomPL,
                    hangemhigh = RandomPL,
                    ratrace = RandomPL,
                    damnation = RandomPL,
                    putput = RandomPL,
                    prisoner = RandomPL,
                    wizard = RandomPL,
                }
            end
--=======================================================================================--
            -- [MANUAL CONFIG START] --
            -- Manually define number of frag grenades given on spawn --
            if (gamesettings["RANDOM_FRAGS"]) == false then
                frags = {
                    beavercreek = 3, -- Spawn with 3 Frags on the map beavercreek
                    bloodgulch = 4,
                    boardingaction = 1,
                    carousel = 3,
                    dangercanyon = 4,
                    deathisland = 1,
                    gephyrophobia = 3,
                    icefields = 1,
                    infinity = 2,
                    sidewinder = 3,
                    timberland = 2,
                    hangemhigh = 3,
                    ratrace = 3,
                    damnation = 1,
                    putput = 4,
                    prisoner = 2,
                    wizard = 1,
                }
            end
            -- Manually define number of plasma grenades given on spawn --
            if (gamesettings["RANDOM_PLASMAS"]) == false then
                plasmas = {
                    beavercreek = 1, -- Spawn with 1 Plasma on the map beavercreek
                    bloodgulch = 2,
                    boardingaction = 3,
                    carousel = 3,
                    dangercanyon = 4,
                    deathisland = 1,
                    gephyrophobia = 3,
                    icefields = 1,
                    infinity = 4,
                    sidewinder = 2,
                    timberland = 4,
                    hangemhigh = 3,
                    ratrace = 2,
                    damnation = 3,
                    putput = 1,
                    prisoner = 1,
                    wizard = 2,
                    -- [MANUAL CONFIG END] --
                }
            end
--===============================================================================================--
            -- DO NOT TOUCH ---------------------------------------
            if (frags[mapname] == nil) then 
                cprint("Frags not defined for " .. mapname) 
            else
                write_word(player_object + 0x31E, frags[mapname])
            end
            if (plasmas[mapname] == nil) then 
                cprint("Plasmas not defined for " .. mapname) 
            else
                write_word(player_object + 0x31F, plasmas[mapname])
            end
            -- Debugging --
            -- Uncomment the 'cprint' element for debugging.
            -- cprint("Spawning with " .. frags[mapname] .. " frags and " .. plasmas[mapname] .. " plasmas", 2+8)
        end
    end
end

    -- Debugging --
function OnPlayerKill(PlayerIndex)
    local player = get_player(PlayerIndex)
    -- Spawn time = 0 seconds
    write_dword(player + 0x2C, 0 * 33)
end	

function OnError(Message)
    print(debug.traceback())
end  

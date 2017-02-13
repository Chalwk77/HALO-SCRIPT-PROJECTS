--[[
Document Name: Spawn with Random # of Grenades

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
All Rights Reserved.

* Written by Jericho Crosby
]]

api_version = "1.11.0.0"
frags = { }
plasmas = { }

gamesettings = {
    ["RandomNumberberFrags"] = true,
    ["RandomNumberberPlasmas"] = true,
}

function OnScriptLoad()
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
end

function OnScriptUnload()
    frags = { }
    plasmas = { }
end

function OnNewGame()
    frags = { }
    plasmas = { }
end

function OnPlayerSpawn(PlayerIndex)
    RandomNumber = math.random(1, 4)
    if player_alive(PlayerIndex) then
        local player_object = get_dynamic_player(PlayerIndex)
        local mapname = get_var(0, "$map")
        if (player_object ~= 0) then
            if (gamesettings["RandomNumberberFrags"]) == true then
                frags = {
                    beavercreek = RandomNumber,
                    bloodgulch = RandomNumber,
                    boardingaction = RandomNumber,
                    carousel = RandomNumber,
                    dangercanyon = RandomNumber,
                    deathisland = RandomNumber,
                    gephyrophobia = RandomNumber,
                    icefields = RandomNumber,
                    infinity = RandomNumber,
                    sidewinder = RandomNumber,
                    timberland = RandomNumber,
                    hangemhigh = RandomNumber,
                    ratrace = RandomNumber,
                    damnation = RandomNumber,
                    putput = RandomNumber,
                    prisoner = RandomNumber,
                    wizard = RandomNumber,
                    mapname = RandomNumber,
                }
            elseif (gamesettings["RandomNumberberFrags"]) == false then
                frags = {
                    beavercreek = 3,
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
            if (gamesettings["RandomNumberberPlasmas"]) == true then
                plasmas = {
                    beavercreek = RandomNumber,
                    bloodgulch = RandomNumber,
                    boardingaction = RandomNumber,
                    carousel = RandomNumber,
                    dangercanyon = RandomNumber,
                    deathisland = RandomNumber,
                    gephyrophobia = RandomNumber,
                    icefields = RandomNumber,
                    infinity = RandomNumber,
                    sidewinder = RandomNumber,
                    timberland = RandomNumber,
                    hangemhigh = RandomNumber,
                    ratrace = RandomNumber,
                    damnation = RandomNumber,
                    putput = RandomNumber,
                    prisoner = RandomNumber,
                    wizard = RandomNumber,
                    mapname = RandomNumber,
                }
            elseif (gamesettings["RandomNumberberPlasmas"]) == false then
                plasmas = {
                    beavercreek = 1,
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
                }
            end
            write_word(player_object + 0x31E, frags[mapname])
            write_word(player_object + 0x31F, plasmas[mapname])
        end
    end
end

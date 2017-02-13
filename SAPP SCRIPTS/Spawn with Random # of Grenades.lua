--[[ 
Document Name: Spawn with Random # of Grenades

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
All Rights Reserved.

* Written by Jericho Crosby
]]

api_version = "1.11.0.0"
frags = { }
plasmas = { }

-- Pick a random number between 1 and 4
PickRandomNum = math.random(1,4)

gamesettings = {
    ["PickRandomNumberFrags"] = true,
    ["PickRandomNumberPlasmas"] = true,
}

function GrenadeTable()
    if (gamesettings["PickRandomNumberFrags"]) == true then
        frags = {
            beavercreek = PickRandomNum,
            bloodgulch = PickRandomNum,
        }
    elseif (gamesettings["PickRandomNumberFrags"]) == false then
        frags = {
            beavercreek = 2,
            bloodgulch = 3,
        }
    end
    if (gamesettings["PickRandomNumberPlasmas"]) == true then
        plasmas = {
            beavercreek = PickRandomNum,
            bloodgulch = PickRandomNum,
        }
    elseif (gamesettings["PickRandomNumberPlasmas"]) == false then
        plasmas = {
            beavercreek = 3,
            bloodgulch = 1,
        }
    end
end

function OnScriptUnload()
    frags = { }
    plasmas = { }
end

function OnScriptLoad()
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    if get_var(0, "$gt") ~= "n/a" then
        mapname = get_var(0, "$map")
        GrenadeTable()
    end
end

function OnPlayerSpawn(PlayerIndex)
    if player_alive(PlayerIndex) then
        local player_object = get_dynamic_player(PlayerIndex)
        if (player_object ~= 0) then
            write_word(player_object + 0x31E, frags[mapname])
            write_word(player_object + 0x31F, plasmas[mapname])
        end
    end
end

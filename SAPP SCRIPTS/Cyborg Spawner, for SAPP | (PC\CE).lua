--[[
    Script Name: Cyborg Spawner, for SAPP | (PC\CE)
    Implementing API version: 1.11.0.0

    Description: Spawn cyborgs at designated locations!

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
]]

api_version = "1.11.0.0"
function OnScriptLoad( )
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
end

function OnScriptUnload() 
    objects = { }
end

objects = {
    -- bloodgulch
    {"bipd", "characters\\cyborg_mp\\cyborg_mp", 97.29, -163.54, 1.7 },
    {"bipd", "characters\\cyborg_mp\\cyborg_mp", 84.15, -160.48, 0.05 },
    {"bipd", "characters\\cyborg_mp\\cyborg_mp", 98.49, -157.64, 1.7 },
    {"bipd", "characters\\cyborg_mp\\cyborg_mp", 93.97, -161.08, 1.7 },
    {"bipd", "characters\\cyborg_mp\\cyborg_mp", 91.89, -157.78, 1.7 }
}

function OnNewGame(TagID)
    for k, v in pairs(objects) do
        local tag = lookup_tag(v[1], v[2])
        if tag ~= 0 then
            v[5] = spawn_object(v[1], v[2], v[3], v[4], v[5])
        end
    end
end

--[[
--=====================================================================================================--
Script Name: Cyborg Spawner, for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description: Spawn cyborgs at designated locations

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
end

function OnScriptUnload()
    objects = { }
end

-- class, tagname, x,y,z, mapname
objects = {
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 95.68, - 155.46, 2.92, "bloodgulch" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 79.05, - 141.19, 2.16, "bloodgulch" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 74.23, - 106.13, 3.87, "bloodgulch" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 22.67, - 81.11, 1.46, "bloodgulch" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 66.25, - 64.81, 2.52, "bloodgulch" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", -16.68, - 13.25, - 0, "longest" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", -6.48, - 10.83, 2.06, "longest" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 6.05, - 10.42, 2.06, "longest" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 13.67, - 7.64, - 0.6, "longest" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 3.44, - 19.45, 2.06, "longest" },
    
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 29.03, 13.56, 0.84, "beavercreek" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 18.02, 7.73, - 0.22, "beavercreek" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 13.87, 20.15, - 0.97, "beavercreek" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 4.77, 16.61, 1.8, "beavercreek" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 17.14, 19.12, 5.18, "beavercreek" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 1.97, 0.59, 0.42, "boardingaction" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 17.63, 14.12, 2.72, "boardingaction" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 3.16, - 9.81, - 4.78, "boardingaction" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 18.76, - 16.37, - 2.28, "boardingaction" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 4.17, - 19, 5.22, "boardingaction" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 2.45, - 6.89, - 2.79, "carousel" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 0.65, 5.3, - 2.56, "carousel" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 1.58, - 11.39, - 0.86, "carousel" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 10.75, 3.4, - 0.86, "carousel" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 11.4, 9.92, - 0.86, "carousel" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 30.3, - 6.81, - 2.28, "dangercanyon" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 9.22, 54.35, 0.33, "dangercanyon" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 0.61, 44.16, - 6.63, "dangercanyon" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 24.51, - 10.22, - 3.93, "dangercanyon" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 0.72, 18.71, - 0.92, "dangercanyon" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 29.49, 16.53, 8.29, "deathisland" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 44.67, - 37.26, 13.67, "deathisland" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 10.26, 28.14, 22.79, "deathisland" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 30.87, 34.35, 14.27, "deathisland" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 31.86, 66.06, 3.02, "deathisland" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 28.97, - 26.05, - 18.33, "gephyrophobia" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 26.43, - 110.51, - 18.33, "gephyrophobia" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 24.12, - 99.21, - 1.25, "gephyrophobia" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 21.58, - 32.52, - 1.25, "gephyrophobia" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 26.13, - 81.17, - 1.25, "gephyrophobia" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 71.18, 94.65, 0.86, "icefields" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 76.92, 87.91, 0.8, "icefields" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 14.4, - 20.08, 0.76, "icefields" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 26.2, - 21.82, 0.8, "icefields" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 26.92, 27.75, 8.96, "icefields" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 0.31, - 164.72, 15.01, "infinity" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 3.33, 48.08, 11.7, "infinity" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 15.48, - 64.3, 21.87, "infinity" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 42.35, - 135.46, 12.7, "infinity" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 47.26, - 123.08, 11.18, "infinity" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 33.51, - 35.13, 0.56, "sidewinder" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 9.06, - 12.35, 0.16, "sidewinder" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 43.49, 31.26, 0.16, "sidewinder" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 39.82, 30.19, 0.16, "sidewinder" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 30.71, - 37.71, 0.56, "sidewinder" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 14.74, 44.9, - 18.04, "timberland" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 17.05, - 52.32, - 11.75, "timberland" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 35.03, - 28.4, - 20.64, "timberland" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 7.18, - 5.38, - 18.71, "timberland" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 41.34, - 27.9, - 20.64, "timberland" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 28.21, - 18.87, - 3.91, "hangemhigh" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 15.79, 8.98, - 3.36, "hangemhigh" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 16.15, - 5.03, - 3.47, "hangemhigh" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 20.59, - 2.28, - 4.38, "hangemhigh" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 32.74, - 4.97, - 5.58, "hangemhigh" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 14.02, - 19.72, - 3.61, "ratrace" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 3.01, - 10.84, 0.22, "ratrace" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 6.62, - 2.3, - 0.59, "ratrace" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 19.81, 0.7, - 2.13, "ratrace" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 8.57, - 13.93, - 2.9, "ratrace" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 5.13, 10.28, 3.4, "damnation" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 1.6, 1.5, - 0.2, "damnation" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 12.44, - 5.56, - 0.2, "damnation" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 5.04, - 5.67, 3.4, "damnation" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 4.9, - 10.12, 4.5, "damnation" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 30.76, - 25.42, 1, "putput" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 17.87, - 3.97, 1.7, "putput" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 2.05, - 1.22, 0.9, "putput" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 16.26, - 19.55, 2.3, "putput" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 16.69, - 22.04, 0.9, "putput" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 5.13, 7.15, 1.39, "prisoner" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 1.62, - 6.68, 1.39, "prisoner" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 9.79, 4.43, 5.59, "prisoner" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 9.61, - 5.48, 5.59, "prisoner" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 8.47, - 1.55, 2.52, "prisoner" },

    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 8.84, - 9.08, - 2.75, "wizard" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 7.36, - 6.34, - 4.5, "wizard" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", - 8.96, 9.24, - 2.75, "wizard" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 7.22, 6.4, - 4.5, "wizard" },
    { "bipd", "characters\\cyborg_mp\\cyborg_mp", 0.08, - 1.15, - 2.3, "wizard" }
}

function OnNewGame()
    for k, v in pairs(objects) do
        local map = get_var(1, "$map")
        local tag = lookup_tag(v[1], v[2])
        if v[1] == "bipd" and v[2] == "characters\\cyborg_mp\\cyborg_mp" then
            object = "Cyborg"
        end
        if tag ~= 0 then
            if (v[6] == nil) then 
                cprint("Object Creation failed. Number: " .. k) 
            else
                if (v[6] == map) then
                    -- v1 = class, v2 = tagname, v3 = X, v4 = Y, v5 = Z
                    v[6] = spawn_object(v[1], v[2], v[3], v[4], v[5])
                    cprint("[".. k .."] Spawning " .. object .. " at " .. v[3] .. ", " .. v[4] .. ", " .. v[5], 2+8)
                end
            end
        end
    end
end

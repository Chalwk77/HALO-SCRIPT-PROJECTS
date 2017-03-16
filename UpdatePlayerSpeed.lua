player_speed = { }

function UpdatePlayerSpeed(PlayerIndex)
    -- LEVEL 1 (shotgun)
    player_speed[1] = { 
    wizard = 1.0, putput = 1.0, ratrace = 1.0, carousel = 1.0, 
    infinity = 1.0, icefields = 1.0, bloodgulch = 1.0, timberland = 1.0, 
    sidewinder = 1.0, deathisland = 1.0, dangercanyon = 1.0, gephyrophobia = 1.0, 
    prisoner = 1.0, damnation = 1.0, hangemhigh = 1.0, beavercreek = 1.0, boardingaction = 1.0
    }
    -- LEVEL 2 (assault rifle)
    player_speed[2] = { 
    wizard = 1.0, putput = 1.0, ratrace = 1.0, carousel = 1.0, 
    infinity = 1.0, icefields = 1.0, bloodgulch = 1.0, timberland = 1.0, 
    sidewinder = 1.0, deathisland = 1.0, dangercanyon = 1.0, gephyrophobia = 1.0, 
    prisoner = 1.0, damnation = 1.0, hangemhigh = 1.0, beavercreek = 1.0, boardingaction = 1.0
    }
    -- LEVEL 3 (pistol)
    player_speed[3] = { 
    wizard = 1.0, putput = 1.0, ratrace = 1.0, carousel = 1.0, 
    infinity = 1.0, icefields = 1.0, bloodgulch = 1.0, timberland = 1.0, 
    sidewinder = 1.0, deathisland = 1.0, dangercanyon = 1.0, gephyrophobia = 1.0, 
    prisoner = 1.0, damnation = 1.0, hangemhigh = 1.0, beavercreek = 1.0, boardingaction = 1.0
    }
    -- LEVEL 4 (sniper rifle)
    player_speed[4] = { 
    wizard = 1.0, putput = 1.0, ratrace = 1.0, carousel = 1.0, 
    infinity = 1.0, icefields = 1.0, bloodgulch = 1.0, timberland = 1.0, 
    sidewinder = 1.0, deathisland = 1.0, dangercanyon = 1.0, gephyrophobia = 1.0, 
    prisoner = 1.0, damnation = 1.0, hangemhigh = 1.0, beavercreek = 1.0, boardingaction = 1.0
    }
    -- LEVEL 5 (rocket launcher)
    player_speed[5] = { 
    wizard = 1.0, putput = 1.0, ratrace = 1.0, carousel = 1.0, 
    infinity = 1.0, icefields = 1.0, bloodgulch = 1.0, timberland = 1.0, 
    sidewinder = 1.0, deathisland = 1.0, dangercanyon = 1.0, gephyrophobia = 1.0, 
    prisoner = 1.0, damnation = 1.0, hangemhigh = 1.0, beavercreek = 1.0, boardingaction = 1.0
    }
    -- LEVEL 6 (plasma cannon)
    player_speed[6] = { 
    wizard = 1.0, putput = 1.0, ratrace = 1.0, carousel = 1.0, 
    infinity = 1.0, icefields = 1.0, bloodgulch = 1.0, timberland = 1.0, 
    sidewinder = 1.0, deathisland = 1.0, dangercanyon = 1.0, gephyrophobia = 1.0, 
    prisoner = 1.0, damnation = 1.0, hangemhigh = 1.0, beavercreek = 1.0, boardingaction = 1.0
    }
    -- LEVEL 7 (ghost)
    player_speed[7] = { 
    wizard = 1.0, putput = 1.0, ratrace = 1.0, carousel = 1.0, 
    infinity = 1.0, icefields = 1.0, bloodgulch = 1.0, timberland = 1.0, 
    sidewinder = 1.0, deathisland = 1.0, dangercanyon = 1.0, gephyrophobia = 1.0, 
    prisoner = 1.0, damnation = 1.0, hangemhigh = 1.0, beavercreek = 1.0, boardingaction = 1.0
    }
    -- LEVEL 8 (rocket hog)
    player_speed[8] = { 
    wizard = 1.0, putput = 1.0, ratrace = 1.0, carousel = 1.0, 
    infinity = 1.0, icefields = 1.0, bloodgulch = 1.0, timberland = 1.0, 
    sidewinder = 1.0, deathisland = 1.0, dangercanyon = 1.0, gephyrophobia = 1.0, 
    prisoner = 1.0, damnation = 1.0, hangemhigh = 1.0, beavercreek = 1.0, boardingaction = 1.0
    }
    -- LEVEL 9 (tank)
    player_speed[9] = { 
    wizard = 1.0, putput = 1.0, ratrace = 1.0, carousel = 1.0, 
    infinity = 1.0, icefields = 1.0, bloodgulch = 1.0, timberland = 1.0, 
    sidewinder = 1.0, deathisland = 1.0, dangercanyon = 1.0, gephyrophobia = 1.0, 
    prisoner = 1.0, damnation = 1.0, hangemhigh = 1.0, beavercreek = 1.0, boardingaction = 1.0
    }
    -- LEVEL 10 (banshee)
    player_speed[10] = { 
    wizard = 1.0, putput = 1.0, ratrace = 1.0, carousel = 1.0, 
    infinity = 1.0, icefields = 1.0, bloodgulch = 1.0, timberland = 1.0, 
    sidewinder = 1.0, deathisland = 1.0, dangercanyon = 1.0, gephyrophobia = 1.0, 
    prisoner = 1.0, damnation = 1.0, hangemhigh = 1.0, beavercreek = 1.0, boardingaction = 1.0
    }
    mapname = get_var(1, "$map")
    PlayerSpeed = player_speed[players[PlayerIndex][1]][mapname]
    execute_command("s " .. PlayerIndex .. " :" .. tonumber(PlayerSpeed))
end

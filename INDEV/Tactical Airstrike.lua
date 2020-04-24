--[[
--=====================================================================================================--
Script Name: Tactical Airstrike, for SAPP (PC & CE)
Description: Players who achieve a five-kill streak (killing five enemy players consecutively without dying) 
             are given the ability to call in an airstrike.

             Players will have the opportunity to select from 1 of 3 "strike" modes.game_over


todo================================================================
NEW IDEA:
-- Gives players the option to choose what "MODE" the use:
-- Will require several commands.


-- CMD Syntax to select strike mode: "/mode 1|2|3"
-- CMD Syntax for MODE 1: /nuke <player id>
-- CMD Syntax for MODE 2 & 3: /nuke
-- /pl <custom player list command for MODE 1)

New IDEA:
if the player has enough kills -> remind them every 10 seconds that
they can select their strike "mode" until the command /mode <mode>
is successfully executed.

Example Reminder Message:
"-- ============ AIRSTRIKE AVAILABLE ============ --"
"To select your Airstrike Mode type /mode <mode id>"
"Modes: 1|2|3"
"For information on each mode, type /airstrike info"

TODO: Implement PERIODIC REMINDER MESSAGE (to change modes)
TODO: Custom player list command

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--


api_version = "1.12.0.0"

-- Configuration [starts] ===================================================
local airstrike = {


    -- Command Syntax:
    -- /nuke <player id [number]>
    -- /nuke mode <mode id [number]>
    -- /nuke info
    -- /nuke pl|players|playerlist

    -- This is the main command a player will type to activate an airstrike.
    base_command = "nuke",
    info_command = "info",
    mode_command = "mode",

    -- Players can view the ID's of all players currently online with this command.
    player_list_command = "pl",

    -- All output messages:
    messages = {

        mode_select = "STRIKE MODE %mode% SELECTED",
        not_enough_kills = "You do not have enough kills to call an airstrike",
        console_error = "You cannot execute this command from the console!",
        mode_invalid_syntax = "Invalid Syntax. Usage: /%cmd% %mode_cmd% <mode id>",
        player_list_cmd_feedback = {
            header = "[ID - NAME]",
            player_info = "%id%  -  %name%",
            offline = "No other players online",
        },

        reminder_message = {
            "To select your Airstrike Mode type /%base_command% %mode_cmd% <mode id>",
            "Modes: 1|2|3",
            "For information on each mode, type /%base_command% info",
        },

        info = {
            "-- ============== MODE INFORMATION ============== --",
            "Mode 1). Strike at a specific player's X,Y,Z map coordinates.",
            " ",
            "Mode 2). Strike called to (1 of X) locations surrounding the enemy base.",
            " ",
            "Mode 3). Strike called to a random (pre defined) x,y,z coordinate on the map.",
            "--=============================================================================--"
        },

        on_kill = {
            ["Mode A"] = {
                "-- ============ AIRSTRIKE AVAILABLE ============ --",
                "Type /%cmd% <player id> to call an airstrike on a player!",
                "Type /%cmd% %pl_cmd% to view a list of Player IDs"
            },

            ["Mode B"] = {
                "-- ============ AIRSTRIKE AVAILABLE ============ --",
                "Type /%cmd% to call an airstrike on the enemy base!"
            },

            ["Mode C"] = {
                "-- ============ AIRSTRIKE AVAILABLE ============ --",
                "Type /%cmd% to call an airstrike at a random location on the map!"
            },
        },
    },

    maps = {

        ["beavercreek"] = {
            enabled = true, -- enable airstrike feature for this map (set to false to disable).
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            -- NOTE: Two of the three modes MUST be FALSE (only ONE must be TRUE)
            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5, -- Number of kills required to enable airstrike mode
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5, -- Number of kills required to enable airstrike mode
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5, -- Number of kills required to enable airstrike mode
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["bloodgulch"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 20,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 1,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 1,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 1,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["boardingaction"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["carousel"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["chillout"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["damnation"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["dangercanyon"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["deathisland"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["gephyrophobia"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["hangemhigh"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["icefields"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["infinity"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["longest"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["prisoner"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["putput"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["ratrace"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["sidewinder"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["timberland"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        },

        ["wizard"] = {
            enabled = true,
            default_mode = "Mode A",

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",
            dmg = { "jpt!", "weapons\\rocket launcher\\explosion" },

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 5,
                },
                ["Mode B"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        ["red"] = {
                            { 0, 0, 0 },
                        },
                        ["blue"] = {
                            { 0, 0, 0 },
                        }
                    }
                },
                ["Mode C"] = {
                    enabled = false,
                    kills_required = 5,
                    strike_locations = {
                        { 0, 0, 0 },
                    }
                }
            }
        }
    }
}
-- Configuration [ends] ===================================================


-- Do Not Touch --
-- TABLES:
local players = { }

-- Variables
local delta_time = 1 / 30
local game_over, mode, map_name
local gmatch, lower, upper, gsub = string.gmatch, string.lower, string.upper, string.gsub

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")

    if (get_var(0, "$gt") ~= "n/a") then
        map_name = get_var(0, "$map")
    end
end

local TIMER = 0
local MiddleX, MiddleY, MiddleZ = 65.749893188477, -120.40949249268, 0.11860413849354

function OnTick()

    --for k,v in pairs(players) do
    --    if (k) then
    --        if (v.reminder.init) then
    --            v.reminder.timer = v.reminder.timer + delta_time
    --            if (v.reminder.timer == 0 and v.reminder.timer < 0.1) then
    --                cls(k, 25)
    --                for i = 1,#airstrike.messages.reminder_message do
    --                    rprint(k, airstrike.messages.reminder_message[i])
    --                end
    --            end
    --        end
    --    end
    --end

    -- SPAWN PROJECTILES EVERY 3 SECONDS IN THE MIDDLE OF THE MAP
    --TIMER = TIMER + 1 / 30
    --if (TIMER >= 1) then
    --    TIMER = 0
    --    InitiateStrike(MiddleX, MiddleY, MiddleZ)
    --end

    if (not game_over) and (airstrike.objects) then
        for k, v in pairs(airstrike.objects) do
            local projectile_memory = get_object_memory(v)
            if (projectile_memory == 0) then
                k = nil
            end
        end
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, _, _)
    if (not game_over) and (CauserIndex == 0) then
        local t = airstrike.maps[map_name].dmg
        if (MetaID == TagInfo(t[1], t[2])) then
            return Damage * 10
        end
    end
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnPlayerSpawn(PlayerIndex)
    -- Reset victim kill count:
    players[PlayerIndex].kills = 0
end

function OnPlayerDisconnect(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function OnGameStart()
    game_over = false
    if (get_var(0, "$gt") ~= "n/a") then
        map_name = get_var(0, "$map")
    end
end

function OnGameEnd()
    game_over = true
    mode = nil
end

function OnPlayerDeath(VictimIndex, KillerIndex)

    local killer = tonumber(KillerIndex)

    -- Check if Killer has enough kills to enabled airstrike:
    if (killer > 0) and (VictimIndex ~= KillerIndex) then

        players[killer].kills = players[killer].kills + 1

        if HasRequiredKills(killer) then
            cls(killer, 25)
            local m = airstrike.messages.on_kill[players[killer].mode]
            for i = 1, #m do
                local msg = gsub(gsub(m[i], "%%cmd%%", airstrike.base_command), "%%pl_cmd%%", airstrike.player_list_command)
                rprint(killer, msg)
            end
        end
    end
end

function HasRequiredKills(PlayerIndex)
    local t = players[PlayerIndex].mode
    local kills_required = airstrike.maps[map_name].modes[t].kills_required
    return players[PlayerIndex].kills >= kills_required
end

function IsTeamGame()
    if (get_var(0, "$ffa") == "0") then
        return true
    end
end

function InitPlayer(PlayerIndex, Reset)
    if (Reset) then
        players[PlayerIndex] = {}
    else
        players[PlayerIndex] = {
            name = get_var(PlayerIndex, "$name"),
            mode = airstrike.maps[map_name].default_mode
        }
    end
end

function InitiateStrike(x, y, z)
    local params = airstrike.maps[map_name]

    local min_x_vel = 0
    local max_x_vel = 0

    local min_y_vel = 0
    local max_y_vel = 0

    local min_z_vel = -1.3
    local max_z_vel = -3

    local projectile_x_vel = math.random(min_x_vel, max_x_vel)
    local projectile_y_vel = math.random(min_y_vel, max_y_vel)
    local projectile_z_vel = math.random(min_z_vel, max_z_vel)

    for _ = params.min_projectiles, params.max_projectiles do
        local payload = spawn_object("proj", params.projectile, x, y, z + params.height_from_ground)
        local projectile = get_object_memory(payload)
        if (projectile ~= 0) then

            write_float(projectile + 0x68, projectile_x_vel)
            write_float(projectile + 0x6C, projectile_y_vel)
            write_float(projectile + 0x70, projectile_z_vel)

            airstrike.objects = airstrike.objects or {}
            airstrike.objects[#airstrike.objects + 1] = payload
        end
    end
end

function OnServerCommand(Killer, Command, _, _)

    local Cmd = CmdSplit(Command)
    if (#Cmd == 0) then
        return false
    else
        Cmd[1] = lower(Cmd[1]) or upper(Cmd[1])
        if (Cmd[1] == airstrike.base_command) then
            cls(Killer, 25)
            if (Killer ~= 0) then
                local args1, args2 = Cmd[2], Cmd[3]

                -- MODE INFO COMMAND:
                if (args1 ~= nil) then
                    if (tostring(args1) == airstrike.info_command) then
                        for i = 1, #airstrike.messages.info do
                            rprint(Killer, airstrike.messages.info[i])
                        end
                        -- MODE SELECT COMMAND:
                    elseif (tostring(args1) == airstrike.mode_command) then
                        local mode = tonumber(args2)
                        if (mode ~= nil) then
                            if (mode == 1) then
                                players[Killer].mode = "Mode A"
                            elseif (mode == 2) then
                                players[Killer].mode = "Mode B"
                            elseif (mode == 3) then
                                players[Killer].mode = "Mode C"
                            else
                                mode = nil
                            end
                            if (mode) then
                                local msg = gsub(airstrike.messages.mode_select, "%%mode%%", mode)
                                rprint(Killer, msg)
                            end
                        end
                        if (mode == nil) then
                            local t = airstrike.messages.mode_invalid_syntax
                            local msg = gsub(gsub(t, "%%cmd%%",airstrike.base_command), "%%mode_cmd%%", airstrike.mode_command)
                            rprint(Killer, msg)
                        end
                    elseif (tostring(args1) == airstrike.player_list_command) then

                        local players = GetPlayers(Killer)
                        local t = airstrike.messages.player_list_cmd_feedback
                        if (#players > 0) then
                            rprint(Killer, t.header)
                            for i = 1, #players do
                                local msg = gsub(gsub(t.player_info, "%%id%%", players[i].id), "%%name%%", players[i].name)
                                rprint(Killer, msg)
                            end
                        else
                            rprint(Killer, t.offline)
                        end

                    elseif (players[Killer].mode == "Mode A") then
                        args1 = tonumber(args1)
                        if (args1 ~= nil) and (args1 > 0 and args1 < 17 and args1 ~= Killer) then
                            local valid_player = player_present(args1) and player_alive(args1)
                            if (valid_player) then
                                if HasRequiredKills(Killer) then
                                    players[Killer].kills = 0

                                    local DynamicPlayer = get_dynamic_player(args1)
                                    if (DynamicPlayer ~= 0) then
                                        local player = GetXYZ(DynamicPlayer)
                                        if (player) then
                                            InitiateStrike(player.x, player.y, player.z)
                                        end
                                    end
                                else
                                    -- todo: NOT ENOUGH KILLS
                                end
                            else
                                -- todo: NOT ONLINE OR DEAD
                            end
                        else
                            -- todo: INVALID PLAYER ID
                        end
                    elseif (players[Killer].mode == "Mode B") and (args1 == nil) then

                    elseif (players[Killer].mode == "Mode C") and (args1 == nil) then

                    end
                else
                    -- todo: NO ARGS SPECIFIED
                end
            else
                cprint(airstrike.messages.console_error, 4 + 8)
            end
            return false
        end
    end
end

function GetXYZ(DynamicPlayer)
    local coordinates, x, y, z = {}
    local VehicleID = read_dword(DynamicPlayer + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        coordinates.invehicle = false
        x, y, z = read_vector3d(DynamicPlayer + 0x5c)
    else
        coordinates.invehicle = true
        x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end
    coordinates.x, coordinates.y, coordinates.z = x, y, z
    return coordinates
end

function CmdSplit(Command)
    local t, i = {}, 1
    for Args in gmatch(Command, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

function GetPlayers(ExcludePlayer)
    local pl = {}
    for i = 1, 16 do
        if player_present(i) then
            if (i ~= ExcludePlayer) then
                pl[#pl + 1] = { id = i, name = players[i].name }
            end
        end
    end
    return pl
end

function TagInfo(Type, Name)
    local tag_id = lookup_tag(Type, Name)
    return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end

function cls(PlayerIndex, Count)
    for _ = 1, Count do
        rprint(PlayerIndex, " ")
    end
end

function OnScriptUnload()

end

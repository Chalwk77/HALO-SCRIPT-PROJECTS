--[[
--=====================================================================================================--
Script Name: Tactical Airstrike, for SAPP (PC & CE)
Description: Players who achieve a five-kill streak (killing five enemy players consecutively without dying) 
             are given the ability to call in an airstrike.

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
    -- * Mode A = /command <player id>
    -- * Mode A & B = /command


    -- This is the main command a player will type to activate an airstrike.
    base_command = "nuke",

    -- Players can view the ID's of all players currently online with this command.
    player_list_command = "pl",

    -- All output messages:
    messages = {
        ["Mode A"] = {
            "AIRSTRIKE AVAILABLE. Type /%cmd% <%pid%> to call an airstrike on a player!",
            "Type /%pl_list_cmd% to view a list of Player IDs",
        },
        ["Mode B"] = {
            "AIRSTRIKE AVAILABLE. Type /%cmd% to call an airstrike on the enemy base!",
        },
        ["Mode C"] = {
            "AIRSTRIKE AVAILABLE. Type /%cmd% to call an airstrike at a random location on the map!",
        },
    },

    maps = {

        -- Mode A). Strike called to a specific player's X,Y,Z map coordinates
        -- Mode B). Strike called at one of X locations surrounding the enemy base (only compatible with team based games)
        -- Mode C). Strike called at a random (pre defined) x,y,z coordinate on the map

        -- NOTE: Only one mode can be enabled at a time per map.

        ["beavercreek"] = {
            enabled = true, -- enable airstrike feature for this map (set to false to disable).

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

            -- Quantity of projectiles spawned:
            min_projectiles = 1,
            max_projectiles = 10,

            -- Height from ground the object will spawn:
            height_from_ground = 20,

            modes = {
                ["Mode A"] = {
                    enabled = true,
                    kills_required = 0,
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

        ["boardingaction"] = {
            enabled = true,

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

            -- Airstrike projectile object:
            projectile = "weapons\\rocket launcher\\rocket",

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

-- Variables (local)
local game_over, mode
local gmatch, lower, upper = string.gmatch, string.lower, string.upper

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")

    if (get_var(0, "$gt") ~= "n/a") then
        mode = GetMode()
    end
end

function OnTick()
    -- todo: calculate project velocities and trajectory
    -- requires (Pythagorean equation)
    -- basic trigonometry
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, _, _)
    -- todo: Calculate damage multipliers for projectiles
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnPlayerDisconnect(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function OnGameStart()
    game_over = false
    if (get_var(0, "$gt") ~= "n/a") then
        mode = GetMode()
    end
end

function OnGameEnd()
    game_over = true
    mode = nil
end

function OnPlayerDeath(PlayerIndex, KillerIndex)

    -- Reset victim kill count:
    players[PlayerIndex].kills = 0

    -- Check if Killer has enough kills to enabled airstrike:
    if (KillerIndex > 0) then
        local current_kills = get_var(KillerIndex, "$kills")
        local kills_required = mode.kills_required
        if (current_kills == kills_required) then
            -- Enable Airstrike ability for this player:
            -- todo: enable airstrike mode for this player
        end
    end
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
            kills = 0,
            name = get_var(PlayerIndex, "$name")
        }
    end
end

function GetMode()
    local mapname = get_var(0, "$map")
    local t = airstrike.maps[mapname]
    if (t.enabled) then
        for k, _ in pairs(t.modes) do
            if (t.modes[k].enabled) then
                t.modes[k].type = k
                return t.modes[k]
            end
        end
    end
    return nil
end

function InitiateStrike(x,y,z)
    local params = airstrike.maps[get_var(0, "$map")]
    for _ = params.min_projectiles, params.max_projectiles do

        local payload = spawn_object("proj", params.projectile, x, y, z + params.height_from_ground)
        write_float(get_object_memory(payload) + 0x68, x)
        write_float(get_object_memory(payload) + 0x6C, y)
        write_float(get_object_memory(payload) + 0x70, z)

        airstrike.objects = airstrike.objects or {}
        airstrike.objects[#airstrike.objects+1] = payload
    end
end

function OnServerCommand(Killer, Command, _, _)

    local Cmd = CmdSplit(Command)
    if (#Cmd == 0) then
        return false
    else
        Cmd[1] = lower(Cmd[1]) or upper(Cmd[1])
        if (Cmd[1] == airstrike.base_command) then
            if (Killer ~= 0) then
                if (mode.type == "Mode A") then
                    local ID = tonumber(Cmd[2])
                    if (ID ~= nil) and (ID > 0 and ID < 17 and ID ~= Killer) then
                        local valid_player = player_present(ID) and player_alive(ID)
                        if (valid_player) then
                            if (players[Killer].kills >= mode.kills_required) then
                                players[Killer].kills = 0
                                local DynamicPlayer = get_dynamic_player(ID)
                                if (DynamicPlayer ~= 0) then
                                    local player = GetXYZ(DynamicPlayer)
                                    if (player) then
                                        InitiateStrike(player.x, player.y, player.z)
                                    end
                                end
                            else
                                -- NOT ENOUGH KILLS
                            end
                        else
                            -- NOT ONLINE OR DEAD
                        end
                    else
                        -- INVALID PLAYER ID
                    end
                end
            else
                cprint("You cannot execute this command from the console!", 4 + 8)
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

function OnScriptUnload()

end	
	
	
	
	
	
	
	
	
	

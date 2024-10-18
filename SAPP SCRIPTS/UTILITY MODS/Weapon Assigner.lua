--[[
--=====================================================================================================--
Script Name: Weapon Assigner, for SAPP (PC & CE)
Description: Custom weapon assigner script.

             Weapons are assigned based on the player's team.
             You can also set the ammo for each weapon (loaded, reserve, and battery).

             - Features -
                * Weapon loadouts for individual custom game modes (per map).
                  These include separate weapon settings for red/blue or ffa teams.
                * If the current map has no game mode layout configured, the script will use the default weapon loadout for that map.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local WeaponAssigner = {

    -------------------
    -- config starts --
    -------------------

    -- Weapon tags:
    --
    [1] = 'weapons\\pistol\\pistol',
    [2] = 'weapons\\sniper rifle\\sniper rifle',
    [3] = 'weapons\\plasma_cannon\\plasma_cannon',
    [4] = 'weapons\\rocket launcher\\rocket launcher',
    [5] = 'weapons\\plasma pistol\\plasma pistol',
    [6] = 'weapons\\plasma rifle\\plasma rifle',
    [7] = 'weapons\\assault rifle\\assault rifle',
    [8] = 'weapons\\flamethrower\\flamethrower',
    [9] = 'weapons\\needler\\mp_needler',
    [10] = 'weapons\\shotgun\\shotgun',
    [11] = 'weapons\\ball\\ball',
    [12] = 'weapons\\gravity rifle\\gravity rifle',
    --
    -- repeat the structure to add custom tags.
    --

    --
    -- Weapon settings:
    --
    -- Customize weapons for red/blue/ffa teams on a per game mode basis.
    -- Format: [weapon id (see above)] = {loaded ammo, reserve ammo, battery}
    -- Leave any of the values blank to use the default values.
    --

    -------------------------------
    -- Pre-configured map settings:
    -------------------------------

    ["beavercreek"] = {

        --
        -- SCRIPT WILL USE (default) TABLE SETTINGS IF NO GAME MODE LAYOUT IS CONFIGURED FOR THE CURRENT MAP.
        --

        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },

        -- CUSTOM GAME MODE 1:
        ["example_game_mode"] = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },

        -- CUSTOM GAME MODE 2:
        ["another_example_game_mode"] = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
    },

    ["bloodgulch"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [7] = { nil, 240, nil }, -- assault rifle
            },
            ["blue"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [9] = { nil, 120, nil }, -- needler
                [5] = { nil, nil, 100 }, -- plasma pistol
            },
            ["ffa"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [9] = { nil, 120, nil }, -- needler
                [5] = { nil, nil, 100 }, -- plasma pistol
            }
        }
    },

    ["boardingaction"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [10] = { nil, 24, nil }, -- shotgun
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [10] = { nil, 24, nil }, -- shotgun
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [10] = { nil, 24, nil }, -- shotgun
                [1] = { nil, 60, nil }, -- pistol
            }
        }
    },

    ["carousel"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [10] = { nil, 24, nil }, -- shotgun
            },
            ["blue"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [10] = { nil, 24, nil }, -- shotgun
            },
            ["ffa"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [10] = { nil, 24, nil }, -- shotgun
            }
        }
    },

    ["dangercanyon"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
                [4] = { nil, 8, nil }, -- rocket launcher
                [7] = { nil, 240, nil }, -- assault rifle
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
                [4] = { nil, 8, nil }, -- rocket launcher
                [7] = { nil, 240, nil }, -- assault rifle
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [4] = { nil, 8, nil }, -- rocket launcher
                [7] = { nil, 240, nil }, -- assault rifle
            }
        }
    },

    ["chillout"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [7] = { nil, 240, nil }, -- assault rifle
            },
            ["blue"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [7] = { nil, 240, nil }, -- assault rifle
            },
            ["ffa"] = {
                [2] = { nil, 12, nil }, -- sniper
                [8] = { nil, 300, nil }, -- flamethrower
                [1] = { nil, 60, nil }, -- pistol
                [12] = { nil, 240, nil }, -- assault rifle
            }
        }
    },

    ["deathisland"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [7] = { nil, 240, nil }, -- assault rifle
            },
            ["blue"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [7] = { nil, 240, nil }, -- assault rifle
            },
            ["ffa"] = {
                [2] = { nil, 12, nil }, -- sniper
                [8] = { nil, 300, nil }, -- flamethrower
                [1] = { nil, 60, nil }, -- pistol
                [12] = { nil, 240, nil }, -- assault rifle
            }
        }
    },

    ["gephyrophobia"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [4] = { nil, 8, nil }, -- rocket launcher
            },
            ["blue"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [4] = { nil, 8, nil }, -- rocket launcher
            },
            ["ffa"] = {
                [2] = { nil, 12, nil }, -- sniper
                [1] = { nil, 60, nil }, -- pistol
                [4] = { nil, 8, nil }, -- rocket launcher
            }
        }
    },

    ["icefields"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
                [7] = { nil, 240, nil }, -- assault rifle
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
                [7] = { nil, 240, nil }, -- assault rifle
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [7] = { nil, 240, nil }, -- assault rifle
            }
        }
    },

    ["infinity"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
                [4] = { nil, 8, nil }, -- rocket launcher
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
                [4] = { nil, 8, nil }, -- rocket launcher
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
                [4] = { nil, 8, nil }, -- rocket launcher
            }
        }
    },

    ["sidewinder"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
                [4] = { nil, 8, nil }, -- rocket launcher
                [3] = { nil, nil, 100 }, -- plasma cannon
                [2] = { nil, 12, nil }, -- sniper
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
                [4] = { nil, 8, nil }, -- rocket launcher
                [3] = { nil, nil, 100 }, -- plasma cannon
                [2] = { nil, 12, nil }, -- sniper
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [4] = { nil, 8, nil }, -- rocket launcher
                [3] = { nil, nil, 100 }, -- plasma cannon
                [2] = { nil, 12, nil }, -- sniper
            }
        }
    },

    ["timberland"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
                [7] = { nil, 240, nil }, -- assault rifle
                [9] = { nil, 120, nil }, -- needler
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
                [7] = { nil, 240, nil }, -- assault rifle
                [9] = { nil, 120, nil }, -- needler
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [7] = { nil, 240, nil }, -- assault rifle
                [9] = { nil, 120, nil }, -- needler
            }
        }
    },

    ["hangemhigh"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
                [10] = { nil, 24, nil }, -- shotgun
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
                [10] = { nil, 24, nil }, -- shotgun
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [10] = { nil, 24, nil }, -- shotgun
            }
        }
    },

    ["ratrace"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [4] = { nil, 14, nil }, -- assault rifle
                [1] = { nil, 60, nil }, -- pistol
                [9] = { nil, 120, nil }, -- needler
            },
            ["blue"] = {
                [7] = { nil, 240, nil }, -- assault rifle
                [1] = { nil, 60, nil }, -- pistol
                [9] = { nil, 120, nil }, -- needler
            },
            ["ffa"] = {
                [7] = { nil, 240, nil }, -- assault rifle
                [1] = { nil, 60, nil }, -- pistol
                [9] = { nil, 120, nil }, -- needler
            }
        }
    },

    ["damnation"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [7] = { nil, 240, nil }, -- assault rifle
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [7] = { nil, 240, nil }, -- assault rifle
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [7] = { nil, 240, nil }, -- assault rifle
                [1] = { nil, 60, nil }, -- pistol
            }
        }
    },

    ["putput"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [5] = { nil, nil, 100 }, -- plasma pistol
                [6] = { nil, nil, 100 }, -- plasma rifle
                [3] = { nil, nil, 100 }, -- plasma cannon
                [8] = { nil, 300, nil }, -- flamethrower
            },
            ["blue"] = {
                [5] = { nil, nil, 100 }, -- plasma pistol
                [6] = { nil, nil, 100 }, -- plasma rifle
                [3] = { nil, nil, 100 }, -- plasma cannon
                [8] = { nil, 300, nil }, -- flamethrower
            },
            ["ffa"] = {
                [5] = { nil, nil, 100 }, -- plasma pistol
                [6] = { nil, nil, 100 }, -- plasma rifle
                [3] = { nil, nil, 100 }, -- plasma cannon
                [8] = { nil, 300, nil }, -- flamethrower
            }
        }
    },

    ["prisoner"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
                [4] = { nil, 8, nil }, -- rocket launcher
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
                [4] = { nil, 8, nil }, -- rocket launcher
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [4] = { nil, 8, nil }, -- rocket launcher
            }
        }
    },

    ["wizard"] = {
        default = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
        },
        ["example_game_mode"] = {
            ["red"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
            ["blue"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            },
            ["ffa"] = {
                [1] = { nil, 60, nil }, -- pistol
                [2] = { nil, 12, nil }, -- sniper
            }
        }
    }
}

-----------------
-- config ends --
-----------------

api_version = "1.12.0.0"

local players = {}
local weapons = {}

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
end

-- Sets ammo for this player:
-- @arg [number] (player) - Player Index
-- @arg [number] (dyn) - Player Memory Address Index
function SetAmmo(player, dyn)

    player = tonumber(player)
    local playerWeapons = players[player].weapons

    for i = 0, 3 do
        local weapon = read_dword(dyn + 0x2F8 + (i * 4))
        local object = get_object_memory(weapon)
        if (weapon ~= 0xFFFFFFFF and object ~= 0) then

            local metaID = read_dword(object)
            local weaponSettings = playerWeapons[metaID]

            local loaded_ammo = weaponSettings[1]
            local reserve_clip = weaponSettings[2]
            local battery = weaponSettings[3]

            if (loaded_ammo) then
                write_word(object + 0x2B8, loaded_ammo)
            end

            if (reserve_clip) then
                write_word(object + 0x2B6, reserve_clip)
            end

            if (battery) then
                execute_command_sequence('w8 1;battery ' .. player .. ' ' .. battery .. ' ' .. i)
            end

            sync_ammo(weapon)
        end
    end
end

-- Called when a player spawns:
-- @arg [number] (player) - Player Index
function OnSpawn(player)
    players[player] = { assign = true }
end

-- Called when a player joins the server:
-- @arg [number] (player) - Player Index
-- Create a table for the player:
function OnJoin(player)
    players[player] = { assign = false }
end

-- Called when a player quits the server:
-- @arg [number] (player) - Player Index
-- Delete player table (no longer needed):
function OnQuit(player)
    players[player] = nil
end

-- Returns the weapon table for this player:
-- @arg [number] (p) - Player Index
-- @return [table] - Weapon table
local function getWeaponTable(player)
    local ffa = (get_var(0, '$ffa') == '1')
    local team = get_var(player, '$team')
    return (weapons[ffa and 'ffa' or team])
end

-- Weapon Assigner function:
-- Called every tick (1/30th second)
function OnTick()

    -- Loop over all players in the server and check if we need to assign a weapon:
    for i, player in pairs(players) do
        if (i and player.assign and player_alive(i)) then

            local dyn = get_dynamic_player(i)
            if (dyn ~= 0) then

                player.assign = false
                execute_command("wdel " .. i)

                -- Returns the correct weapon table for this player:
                local weaponTable = getWeaponTable(i)
                player.weapons = weaponTable

                -- Assign the weapons:
                local slot = 0
                for metaID, _ in pairs(weaponTable) do
                    slot = slot + 1
                    local object = spawn_object('', '', 0, 0, 0, 0, metaID)
                    if (slot == 1 or slot == 2) then
                        Assign(object, i)
                    else
                        timer(250, 'Assign', object, i)
                    end
                end

                -- Tertiary and quaternary weapons are not assigned immediately, so we need to delay this:
                timer(300, 'SetAmmo', i, dyn)
            end
        end
    end
end

-- Assigns the weapon to the player using its object ID:
function Assign(weaponID, player)
    assign_weapon(weaponID, player)
end

-- Returns the meta id of an object using its tag class and name:
-- @arg [string] (class) - Tag class of the object.
-- @arg [string] (name) - Tag name of the object.
-- @return [number] (Meta ID) - Meta ID of the object.
local function GetTag(class, name)
    local Tag = lookup_tag(class, name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

-- Converts weapon tag addresses to their meta IDs:
local function tagsToID()

    local t = {}
    for team, v in pairs(weapons) do
        t[team] = t[team] or {}
        for weaponID, _ in pairs(v) do
            local tag = GetTag('weap', WeaponAssigner[weaponID])
            if (tag) then
                t[team][tag] = weapons[team][weaponID]
            end
        end
    end

    return t
end

-- Called when a new game begins:
function OnStart()

    if (get_var(0, '$gt') ~= 'n/a') then

        players = { }
        weapons = nil

        local map = get_var(0, '$map')
        local mode = get_var(0, '$mode')

        -- Load the settings for this map:
        local map_settings = WeaponAssigner[map]

        -- Get the weapon table for this map and mode:
        weapons = (map_settings and map_settings[mode])

        -- Get the default weapon table for this map if the mode table is not set:
        if (not weapons and map_settings) then
            weapons = map_settings.default
        end

        if (weapons) then

            weapons = tagsToID(mode)

            register_callback(cb['EVENT_TICK'], 'OnTick')
            register_callback(cb['EVENT_JOIN'], 'OnJoin')
            register_callback(cb['EVENT_LEAVE'], 'OnQuit')
            register_callback(cb['EVENT_SPAWN'], 'OnSpawn')

            for i = 1, 16 do
                if player_present(i) then
                    OnJoin(i)
                end
            end

            return
        end

        unregister_callback(cb['EVENT_TICK'])
        unregister_callback(cb['EVENT_JOIN'])
        unregister_callback(cb['EVENT_SPAWN'])
        unregister_callback(cb['EVENT_LEAVE'])
    end
end

function OnScriptUnload()
    -- N/A
end
--[[
--=====================================================================================================--
Script Name: Weapon Assigner, for SAPP (PC & CE)
Description: This script will assign weapons to players when they spawn.

             Weapons are assigned based on the player's team.
             You can also set the ammo for each weapon (loaded, reserve, and battery).

Copyright (c) 2019-2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local WA = {

    -- config starts --

    -- Weapon tags:
    --
    [1] = "weapons\\pistol\\pistol",
    [2] = "weapons\\sniper rifle\\sniper rifle",
    [3] = "weapons\\plasma_cannon\\plasma_cannon",
    [4] = "weapons\\rocket launcher\\rocket launcher",
    [5] = "weapons\\plasma pistol\\plasma pistol",
    [6] = "weapons\\plasma rifle\\plasma rifle",
    [7] = "weapons\\assault rifle\\assault rifle",
    [8] = "weapons\\flamethrower\\flamethrower",
    [9] = "weapons\\needler\\mp_needler",
    [10] = "weapons\\shotgun\\shotgun",
    [11] = "weapons\\ball\\ball",
    [12] = "weapons\\gravity rifle\\gravity rifle",
    --
    -- repeat the structure to add custom tags.
    --

    -- Format: [weapon id (see above)] = {loaded ammo, reserve ammo, battery}

    -- map settings:
    --
    ["beavercreek"] = {
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

    ["bloodgulch"] = {
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
    },

    ["boardingaction"] = {
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
    },

    ["carousel"] = {
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
    },

    ["dangercanyon"] = {
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
    },

    ["chillout"] = {
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
    },

    ["deathisland"] = {
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
    },

    ["gephyrophobia"] = {
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
    },

    ["icefields"] = {
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
    },

    ["infinity"] = {
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
    },

    ["sidewinder"] = {
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
    },

    ["timberland"] = {
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
    },

    ["hangemhigh"] = {
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
    },

    ["ratrace"] = {
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
    },

    ["damnation"] = {
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
    },

    ["putput"] = {
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
    },

    ["prisoner"] = {
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
    },

    ["wizard"] = {
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

-- config ends --

local players = {}
local weapons = {}

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
end

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

function OnSpawn(p)
    players[p] = { assign = true }
end

function OnJoin(p)
    players[p] = { assign = false }
end

function OnQuit(p)
    players[p] = nil
end

local function getWeaponTable(p)
    local ffa = (get_var(0, '$ffa') == '1')
    local team = get_var(p, '$team')
    return (weapons[ffa and 'ffa' or team])
end

function OnTick()
    for i, player in ipairs(players) do
        if (i and player.assign and player_alive(i)) then

            local dyn = get_dynamic_player(i)
            if (dyn ~= 0) then

                player.assign = false
                execute_command("wdel " .. i)

                local weaponTable = getWeaponTable(i)
                player.weapons = weaponTable

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
                timer(300, 'SetAmmo', i, dyn)
            end
        end
    end
end

function Assign(weaponID, player)
    assign_weapon(weaponID, player)
end

local function GetTag(Class, Name)
    local Tag = lookup_tag(Class, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

local function tagsToID()

    local t = {}
    for team, v in pairs(weapons) do
        t[team] = t[team] or {}
        for weaponID, _ in pairs(v) do
            local tag = GetTag('weap', WA[weaponID])
            if (tag) then
                t[team][tag] = weapons[team][weaponID]
            end
        end
    end

    return t
end

function OnStart()

    if (get_var(0, '$gt') ~= 'n/a') then

        players = { }
        weapons = nil

        local map = get_var(0, '$map')
        weapons = (WA[map] or nil)

        if (weapons) then

            weapons = tagsToID()

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
--[[
--=====================================================================================================--
Script Name: Weapon Assigner, for SAPP (PC & CE)
Description: Easily assign up to 4 weapons on a per-map basis & Per-Team Basis

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

    -- Format: [weapon id (see above)] = {reserve ammo, loaded ammo, battery}

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

function WA:Init()

    self.players = { }
    self.weapons = nil

    if (get_var(0, "$gt") ~= "n/a") then

        local map = get_var(0, "$map")
        self.weapons = self[map]

        if (self.weapons) then
            register_callback(cb["EVENT_TICK"], "OnTick")
            register_callback(cb["EVENT_JOIN"], "OnJoin")
            register_callback(cb["EVENT_LEAVE"], "OnQuit")
            register_callback(cb["EVENT_SPAWN"], "OnSpawn")
        else
            unregister_callback(cb["EVENT_TICK"])
            unregister_callback(cb["EVENT_JOIN"])
            unregister_callback(cb["EVENT_SPAWN"])
            unregister_callback(cb["EVENT_LEAVE"])
            error("[Weapon Assigner] " .. map .. " not configured.")
        end
    end
end

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnStart")
end

local function GetXYZ(DyN)
    local vehicle = read_dword(DyN + 0x11C)
    if (vehicle == 0xFFFFFFFF) then
        return read_vector3d(DyN + 0x5C)
    end
    return nil
end

function WA:GameTick()
    for i, player in pairs(self.players) do
        if (i and player.assign and player_alive(i)) then

            local DyN = get_dynamic_player(i)
            if (DyN ~= 0) then

                local x, y, z = GetXYZ(DyN)
                if (x) then

                    player.assign = false
                    execute_command("wdel " .. i)

                    local slot = 0
                    for j, _ in pairs(player.weapons) do
                        slot = slot + 1
                        if (slot == 1 or slot == 2) then
                            assign_weapon(spawn_object("weap", self[j], x, y, z), i)
                        elseif (slot == 3 or slot == 4) then
                            timer(250, "DelaySecQuat", i, self[j], x, y, z)
                        end
                    end
                    timer(300, "SetAmmo", i, DyN)
                end
            end
        end
    end
end

function WA:InitPlayer(Ply, Reset)
    if (not Reset) then
        self.players[Ply] = { weapons = nil, assign = false }
    else
        self.players[Ply] = nil
    end
end

function WA:WeaponTable(Ply)
    local ffa = (get_var(0, "$ffa") == "1")
    local team = get_var(Ply, "$team")
    return (self.weapons[ffa and "ffa" or team])
end

local function GetTagName(Object)
    if (Object ~= nil and Object ~= 0) then
        return read_string(read_dword(read_word(Object) * 32 + 0x40440038))
    end
    return nil
end

function SetAmmo(Ply, DyN)

    Ply = tonumber(Ply)

    for i = 0, 3 do
        local WeaponID = read_dword(DyN + 0x2F8 + (i * 4))
        if (WeaponID ~= 0xFFFFFFFF) then
            local object = get_object_memory(WeaponID)
            local tag = GetTagName(object)
            if (tag) then
                for j, v in pairs(WA.players[Ply].weapons) do
                    if (tag == WA[j]) then
                        -- loaded:
                        if (v[1]) then
                            write_word(object + 0x2B8, v[1])
                        end
                        -- unloaded:
                        if (v[2]) then
                            write_word(object + 0x2B6, v[2])
                        end
                        -- battery:
                        if (v[3]) then
                            execute_command_sequence("w8 1;battery " .. Ply .. " " .. v[3] .. " " .. i)
                        end
                    end
                end
                sync_ammo(WeaponID)
            end
        end
    end
end

function DelaySecQuat(Ply, Weapon, x, y, z)
    assign_weapon(spawn_object("weap", Weapon, x, y, z), Ply)
end

function OnSpawn(Ply)
    WA.players[Ply].weapons = WA:WeaponTable(Ply)
    WA.players[Ply].assign = true
end

function OnJoin(Ply)
    WA:InitPlayer(Ply, false)
end

function OnQuit(Ply)
    WA:InitPlayer(Ply, true)
end

function OnTick()
    WA:GameTick()
end

function OnStart()
    WA:Init()
end

function OnScriptUnload()
    -- N/A
end
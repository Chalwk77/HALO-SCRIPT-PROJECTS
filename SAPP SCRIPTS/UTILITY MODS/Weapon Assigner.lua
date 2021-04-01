--[[
--=====================================================================================================--
Script Name: Weapon Assigner, for SAPP (PC & CE)
Description: Easily assign up to 4 weapons on a per-map basis & Per-Team Basis

Copyright (c) 2019-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local MOD = { }
function MOD:Init()

    self.players = { }
    self.weapons = nil

    -- CONFIGURATION STARTS -->> ---------------------------------------------------
    self.ammo_set_delay = 300 -- in milliseconds
    if (get_var(0, "$gt") ~= "n/a") then
        local weapons = {

            --[[

            [weapon index] = {primary ammo, secondary ammo, battery}

            ]]

            ["beavercreek"] = {
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
                },
            },

            ["bloodgulch"] = {
                ["red"] = {
                    [2] = { nil, 12, nil }, -- sniper
                    [1] = { nil, 60, nil }, -- pistol
                    [9] = { nil, 120, nil }, -- needler
                    [5] = { nil, nil, 100 }, -- plasma pistol
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
                    [1] = { nil, 60, nil }, -- pistol
                    [7] = { nil, 240, nil }, -- assault rifle
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
                    [7] = { nil, 240, nil }, -- assault rifle
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

            -- Repeat the structure to add more maps:
        }

        self.tags = {
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
        }
        -- CONFIGURATION ENDS << -------------------------------------------------
        --
        --
        --
        -- DO NOT TOUCH BELOW THIS POINT --
        local map = get_var(0, "$map")
        self.weapons = weapons[map]
        if (self.weapons) then
            register_callback(cb["EVENT_TICK"], "OnTick")
            register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
            register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
            register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
        else
            unregister_callback(cb["EVENT_TICK"])
            unregister_callback(cb["EVENT_JOIN"])
            unregister_callback(cb["EVENT_SPAWN"])
            unregister_callback(cb["EVENT_LEAVE"])
        end
    end
end

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "Init")
    MOD:Init()
end

local function GetXYZ(DyN)
    local pos = { }
    local vehicle = read_dword(DyN + 0x11C)
    if (vehicle == 0xFFFFFFFF) then
        pos.x, pos.y, pos.z = read_vector3d(DyN + 0x5c)
    end
    return pos
end

function MOD:WeaponTable(Ply)

    local ffa = (get_var(0, "$ffa") == "1")
    local team = get_var(Ply, "$team")

    if (ffa) then
        return self.weapons["ffa"]
    else
        return self.weapons[team]
    end
end

function MOD:GameUpdate()
    for i, player in pairs(self.players) do
        if (i) and player_alive(i) then
            if (player.assign) then

                local DyN = get_dynamic_player(i)
                if (DyN ~= 0) then
                    local pos = GetXYZ(DyN)
                    if (pos) then
                        player.assign = false
                        execute_command("wdel " .. i)
                        local weapon_index = 0

                        local t = MOD:WeaponTable(i)

                        for WI, _ in pairs(t) do
                            weapon_index = weapon_index + 1
                            if (weapon_index == 1 or weapon_index == 2) then
                                assign_weapon(spawn_object("weap", self.tags[WI], pos.x, pos.y, pos.z), i)
                            elseif (weapon_index == 3 or weapon_index == 4) then
                                timer(250, "DelaySecQuat", i, self.tags[WI], pos.x, pos.y, pos.z)
                            end
                        end
                        timer(self.ammo_set_delay, "SetAmmo", i, DyN)
                    end
                end
            end
        end
    end
end

function OnPlayerSpawn(Ply)
    MOD.players[Ply].assign = true
end

function OnPlayerConnect(Ply)
    MOD:InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    MOD:InitPlayer(Ply, true)
end

function MOD:InitPlayer(Ply, Reset)
    if (not Reset) then
        self.players[Ply] = { assign = false }
    else
        self.players[Ply] = nil
    end
end

function DelaySecQuat(Ply, Weapon, x, y, z)
    assign_weapon(spawn_object("weap", Weapon, x, y, z), Ply)
end

local function GetTagName(TAG)
    if (TAG ~= nil and TAG ~= 0) then
        return read_string(read_dword(read_word(TAG) * 32 + 0x40440038))
    end
    return nil
end

function SetAmmo(Ply, DyN)
    for i = 0, 3 do
        local WeaponID = read_dword(DyN + 0x2F8 + (i * 4))
        if (WeaponID ~= 0xFFFFFFFF) then
            local WeaponObject = get_object_memory(WeaponID)
            local tag = GetTagName(WeaponObject)
            if (tag) then
                for WI, A in pairs(MOD.weapons) do
                    if (tag == MOD.tags[WI]) then
                        -- loaded:
                        if (A[1]) then
                            write_word(WeaponObject + 0x2B8, A[1])
                        end
                        -- unloaded:
                        if (A[2]) then
                            write_word(WeaponObject + 0x2B6, A[2])
                        end
                        -- battery:
                        if (A[3]) then
                            execute_command_sequence("w8 1;battery " .. Ply .. " " .. A[3] .. " " .. i)
                        end
                    end
                end
                sync_ammo(WeaponID)
            end
        end
    end
end

function OnTick()
    return MOD:GameUpdate()
end
function Init()
    return MOD:Init()
end

function OnScriptUnload()
    -- N/A
end
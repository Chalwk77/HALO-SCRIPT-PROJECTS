--[[
--=====================================================================================================--
Script Name: LoadOut, for SAPP (PC & CE)
Description: N/A

~ acknowledgements ~
Concept credit goes to OSH Clan, a gaming community operating on Halo CE.
- website:  https://oldschoolhalo.boards.net/

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
-- Configuration Begins --
local loadout = {

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    server_prefix = "**SAPP**",

    default_class = "Regeneration",
    starting_level = 1,

    -- Command Syntax: /info_command <class>
    info_command = "help",

    -- If a player types /help <class>, how long should the information be on screen for? (in seconds)
    help_hud_duration = 5,

    -- Enable or disable rank HUD:
    show_rank_hud = true,

    -- If a player types any command, the rank_hud info will disappear to prevent it from overwriting other information.
    -- How long should rank_hud info disappear for?
    rank_hud_pause_duration = 5,
    rank_hud = "Class: %class% | Level: %lvl%/%total_levels% | Exp: %exp%->%req_exp%",

    classes = {
        ["Regeneration"] = {
            command = "regen",
            info = {
                identifier = "regen",
                "Regeneration: Good for players who want the classic Halo experience. This is the Default.",
                "Level 1 - Health regenerates 3 seconds after shields recharge, at 20%/second.",
                "Level 2 - 2 Second Delay after shields recharge, at 25%/second. Unlocks Weapon 3.",
                "Level 3 - 1 Second Delay after shields recharge, at 30%/second. Melee damage is increased to 200%",
                "Level 4 - Health regenerates as soon as shields recharge, at 35%/second. You now spawn with full grenade count.",
                "Level 5 - Shields now charge 1 second sooner as well.",
            },

            levels = {
                [1] = {
                    until_next_rank = 200,
                    weapons = { 1, 2, nil, nil },
                },
                [2] = {
                    until_next_rank = 500,
                    weapons = { 1, 2, nil, nil },
                },
                [3] = {
                    until_next_rank = 1000,
                    weapons = { 1, 2, nil, nil },
                },
                [4] = {
                    until_next_rank = 2000,
                    weapons = { 1, 2, nil, nil },
                },
                [5] = {
                    until_next_rank = 3500,
                    weapons = { 1, 2, nil, nil },
                }
            },

            ["Armor Boost"] = {
                command = "armor",
                info = {
                    identifier = "armor",
                    "Armor Boost: Good for players who engage vehicles or defend.",
                    "Level 1 - 1.20x durability.",
                    "Level 2 - 1.30x durability. Unlocks Weapon 3.",
                    "Level 3 - 1.40x durability. Melee damage is increased to 200%",
                    "Level 4 - 1.50x durability. You now spawn with full grenades.",
                    "Level 5 - You are now immune to falling damage in addition to all other perks in this class.",
                },
                levels = {
                    [1] = {
                        until_next_rank = 200,
                        weapons = { 1, 2, nil, nil },
                    },
                    [2] = {
                        until_next_rank = 500,
                        weapons = { 1, 2, nil, nil },
                    },
                    [3] = {
                        until_next_rank = 1000,
                        weapons = { 1, 2, nil, nil },
                    },
                    [4] = {
                        until_next_rank = 2000,
                        weapons = { 1, 2, nil, nil },
                    },
                    [5] = {
                        until_next_rank = 3500,
                        weapons = { 1, 2, nil, nil },
                    }
                }
            },
            ["Partial Camo"] = {
                command = "camo",
                info = {
                    identifier = "camo",
                    "Partial Camo: Good for players who prefer stealth and quick kills or CQB.",
                    "Level 1 - Camo works until you fire your weapon or take damage. Reinitialize delays are 3s/Weapon, 5s/Damage",
                    "Level 2 - Reinitialize delays are 2s/Weapon, 5s/Damage. Unlocks Weapon 3.",
                    "Level 3 - Reinitialize delays are 2s/Weapon, 3s/Damage. Melee damage is increased to 200%",
                    "Level 4 - Reinitialize delays are 1s/Weapon, 3s/Damage. You now spawn with full grenades.",
                    "Level 5 - Reinitialize delays are 0.5s/Weapon, 2s/Damage.",
                },
                levels = {
                    [1] = {
                        until_next_rank = 200,
                        weapons = { 1, 2, nil, nil },
                    },
                    [2] = {
                        until_next_rank = 500,
                        weapons = { 1, 2, nil, nil },
                    },
                    [3] = {
                        until_next_rank = 1000,
                        weapons = { 1, 2, nil, nil },
                    },
                    [4] = {
                        until_next_rank = 2000,
                        weapons = { 1, 2, nil, nil },
                    },
                    [5] = {
                        until_next_rank = 3500,
                        weapons = { 1, 2, nil, nil },
                    }
                }
            },
            ["Recon"] = {
                command = "speed",
                info = {
                    identifier = "speed",
                    "Recon: Good for players who don't use vehicles. Also good for capturing.",
                    "Level 1 - Default speed raised to 1.5x. Sprint duration is 200%.",
                    "Level 2 - Default speed raised to 1.6x. Sprint duration is 225%. Unlocks Weapon 3.",
                    "Level 3 - Default speed raised to 1.7x. Sprint duration is 250%. Melee damage is increased to 200%.",
                    "Level 4 - Default speed raised to 1.8x. Sprint duration is 300%. You now spawn with full grenades.",
                    "Level 5 - Sprint speed is raised from 2.5x to 3x in addition to all other perks in this class.",
                },
                levels = {
                    [1] = {
                        until_next_rank = 200,
                        weapons = { 1, 2, nil, nil },
                    },
                    [2] = {
                        until_next_rank = 500,
                        weapons = { 1, 2, nil, nil },
                    },
                    [3] = {
                        until_next_rank = 1000,
                        weapons = { 1, 2, nil, nil },
                    },
                    [4] = {
                        until_next_rank = 2000,
                        weapons = { 1, 2, nil, nil },
                    },
                    [5] = {
                        until_next_rank = 3500,
                        weapons = { 1, 2, nil, nil },
                    }
                }
            }
        }
    },

    weapon_tags = {
        -- ============= [ STOCK WEAPONS ] ============= --
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

        -- ============= [ CUSTOM WEAPONS ] ============= --
        [11] = "some_random\\weapon\\epic",

        -- repeat the structure to add more weapon tags:
        [12] = "a tag\\will go\\here",
    }
}
-- Configuration Ends --

local time_scale = 1 / 30

local gmatch, gsub = string.gmatch, string.gsub
local lower, upper = string.lower, string.upper

local function Init()
    loadout.players = { }
    for i = 1, 16 do
        if player_present(i) then
            InitPlayer(i, false)
        end
    end
end

function OnScriptLoad()

    register_callback(cb["EVENT_TICK"], "OnTick")

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")

    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    if (get_var(0, '$gt') ~= "n/a") then
        Init()
    end
end

function OnScriptUnload()

end

function OnGameStart()
    if (get_var(0, '$gt') ~= "n/a") then
        Init()
    end
end

function OnGameEnd()

end

local function CmdSplit(Cmd)
    local t, i = {}, 1
    for Args in gmatch(Cmd, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

local function cls(Ply, Count)
    Count = Count or 25
    for _ = 1, Count do
        rprint(Ply, " ")
    end
end

function OnServerCommand(Executor, Command, _, _)
    local Args = CmdSplit(Command)
    if (Args == nil) then
        return
    else

        local state
        Args[1] = lower(Args[1]) or upper(Args[1])
        local p = loadout.players[Executor]

        cls(Executor, 25)
        p.rank_hud_pause = true
        p.rank_hud_pause_duration = loadout.rank_hud_pause_duration

        for class, v in pairs(loadout.classes) do
            if (Args[1] == v.command) then
                if (p.class == class) then
                    Respond(Executor, "You already have " .. class .. " class", "rprint", 12)
                else
                    p.class = class
                    Respond(Executor, "Switching to " .. class .. " class", "rprint", 12)
                end
                return false
            elseif (Args[1] == loadout.info_command and Args[2] == v.info.identifier) then
                p.show_help = true
                p.help_page = v.info
                return false
            end
        end
    end
end

local function GetWeapon(WeaponIndex)
    return loadout.weapon_tags[WeaponIndex]
end

function PrintRank(Ply)

    local p = loadout.players[Ply]
    if (not p.rank_hud_pause) then

        cls(Ply, 25)
        local str = loadout.rank_hud
        local req_exp = loadout.classes[p.class].levels[p.level].until_next_rank

        local words = {
            ["%%exp%%"] = p.exp,
            ["%%lvl%%"] = p.level,
            ["%%class%%"] = p.class,
            ["%%req_exp%%"] = req_exp,
            ["%%total_levels%%"] = #loadout.classes[p.class].levels,
        }
        for k, v in pairs(words) do
            str = gsub(str, k, v)
        end
        Respond(Ply, str, "rprint", 10)
    end
end

function PrintHelp(Ply, Tab)
    cls(Ply, 25)
    for i = 1, #Tab do
        Respond(Ply, Tab[i], "rprint", 10)
    end
end

function OnTick()
    for i, player in pairs(loadout.players) do
        if (i) then
            if player_alive(i) then

                if (player.assign) then

                    local DyN = get_dynamic_player(i)
                    local coords = getXYZ(DyN)

                    if (not coords.invehicle) then
                        player.assign = false
                        execute_command("wdel " .. i)

                        local weapon_table = loadout.classes[player.class].levels[player.level].weapons

                        for Slot, WeaponIndex in pairs(weapon_table) do
                            if (Slot == 1 or Slot == 2) then
                                assign_weapon(spawn_object("weap", GetWeapon(WeaponIndex), coords.x, coords.y, coords.z), i)
                            elseif (Slot == 3 or Slot == 4) then
                                timer(250, "DelaySecQuat", i, GetWeapon(WeaponIndex), coords.x, coords.y, coords.z)
                            end
                        end
                    end
                end
            end

            if (loadout.show_rank_hud) then
                PrintRank(i)
                if (player.rank_hud_pause) then
                    player.rank_hud_pause_duration = player.rank_hud_pause_duration - time_scale
                    if (player.rank_hud_pause_duration <= 0) then
                        player.rank_hud_pause = false
                        player.rank_hud_pause_duration = loadout.rank_hud_pause_duration
                    end
                end
            end

            if (player.show_help) then
                player.help_hud_duration = player.help_hud_duration - time_scale
                PrintHelp(i, player.help_page)
                if (player.help_hud_duration <= 0) then
                    player.show_help = false
                    player.help_hud_duration = loadout.help_hud_duration
                end
            end
        end
    end
end

function InitPlayer(Ply, Reset)
    if (Reset) then
        loadout.players[Ply] = { }
    else
        loadout.players[Ply] = {
            exp = 0,

            assign = true,
            rank_up = false,

            class = loadout.default_class,
            level = loadout.starting_level,

            help_page = nil,

            show_help = false,
            help_hud_duration = loadout.help_hud_duration,

            rank_hud_pause = false,
            rank_hud_pause_duration = loadout.rank_hud_pause_duration,
        }
    end
end

function OnPlayerConnect(Ply)
    InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    InitPlayer(Ply, true)
end

function OnPlayerSpawn(Ply)
    loadout.players[Ply].assign = true
end

function Respond(Ply, Message, Type, Color)

    Color = Color or 10
    execute_command("msg_prefix \"\"")

    if (Ply == 0) then
        cprint(Message, Color)
    end

    if (Type == "rprint") then
        rprint(Ply, Message)
    elseif (Type == "say") then
        say(Ply, Message)
    elseif (Type == "say_all") then
        say_all(Message)
    end
    execute_command("msg_prefix \" " .. loadout.server_prefix .. "\"")
end

function DelaySecQuat(Ply, Weapon, x, y, z)
    assign_weapon(spawn_object("weap", Weapon, x, y, z), Ply)
end

function getXYZ(DyN)
    local coords, x, y, z = { }

    local VehicleID = read_dword(DyN + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        coords.invehicle = false
        x, y, z = read_vector3d(DyN + 0x5c)
    else
        coords.invehicle = true
        x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end

    coords.x, coords.y, coords.z = x, y, z
    return coords
end
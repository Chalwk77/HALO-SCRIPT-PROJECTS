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

    -- Should we allow negative experience?
    allow_negative_exp = false,

    -- Command used to display information about your current class:
    info_command = "help",

    -- If a player types /info_command, how long should the information be on screen for? (in seconds)
    help_hud_duration = 5,

    -- Enable or disable rank HUD:
    show_rank_hud = true,

    -- If a player types any command, the rank_hud info will disappear to prevent it from overwriting other information.
    -- How long should rank_hud info disappear for?
    rank_hud_pause_duration = 5,
    rank_hud = "Class: %class% | Level: %lvl%/%total_levels% | Exp: %exp%->%req_exp%",

    ---- Command Syntax: /rank_up_command <pid>
    --level_up_command = "levelup",
    ---- Command Syntax: /rank_up_command <pid>
    --level_down_command = "leveldown",
    ---- Minimum permission level required to execute /level_up_command or /level_down_command
    --change_level_permission_node = 2,

    messages = {

        flag_score = "Flag Score [+%exp%exp]",
        flag_score_team = "Flag Team Score [+%exp%exp]",
        new_bounty = "%name% has a bounty of %bounty% exp!",

        death_messages = {
            head_shot = "Head Shot: [+%exp%exp]",
            melee = "Melee: [+%exp%exp]",
            frag_kill = "Frag Kill: [+%exp%exp]",
            plasma_stick = "Plasma Stick: [+%exp%exp]",
            plasma_explosion = "Plasma Explosion: [+%exp%exp]",
            skill_bonus = "Skill Bonus: [+%exp%exp]",
            pvp = "PvP: [+%exp%exp]",
            pvp_bonus = "PvP Bonus: [+%exp%exp]",
            suicide = "Suicide: [%exp%exp]",
            betrayal = "Betrayal: [%exp%exp]",
            vehicle_squash = "Vehicle Squash: [%exp%exp]",
            guardians = "Guardians: [%exp%exp]",
            server = "Server: [%exp%exp]",
            fall_damage = "Fall Damage: [%exp%exp]",
            distance_damage = "Distance Damage: [%exp%exp]",
            unknown_or_glitched = "Unknown Death: [%exp%exp]",
            killed_from_the_grave = "Kill From Grave: [%exp%exp]",
            spree = "Spree: (%kills%x kills) - [%exp%exp]",
            multi_kill = "Multi-Kill: (%kills%x kills) - [%exp%exp]"
        }
    },

    experience = {

        pvp = 15,
        use_pvp_bonus = true,
        pvp_bonus = function(EnemyKDR)
            return tonumber((10 * EnemyKDR))
        end,

        melee = 5,
        suicide = -15,
        betrayal = -15,
        vehicle_squash = 5,
        guardians = 15,
        server = -15,
        fall_damage = -15,
        distance_damage = -15,

        -- Skill Bonus for killing an enemy with a higher class level than you:
        skill_bonus = 5,

        flag_score = 100,
        flag_score_team = 10,

        head_shot = 5,
        beat_down = 5,
        frag_kill = 5,
        plasma_stick = 5,
        plasma_explosion = 5,
        killed_from_the_grave = 10,

        -- Bonus EXP per bounty level:
        bounty_exp = 25,

        -- consecutive kills required, xp rewarded, bounty levels added
        spree = {
            { 5, 5, 1 },
            { 10, 10, 2 },
            { 15, 15, 3 },
            { 20, 20, 4 },
            { 25, 25, 5 },
            { 30, 30, 6 },
            { 35, 35, 7 },
            { 40, 40, 8 },
            { 45, 45, 9 },

            -- Award 50 XP for every 5 kills at or above 50 and +1 bounty level
            { 50, 50, 10 },
        },

        -- multi-kills required, xp rewarded
        multi_kill = {
            { 2, 8 },
            { 3, 10 },
            { 4, 12 },
            { 5, 14 },
            { 6, 16 },
            { 7, 18 },
            { 8, 20 },
            { 9, 23 },

            -- Award 25 XP every 2 kills at or above 10
            { 10, 25 },
        }
    },

    classes = {
        ["Regeneration"] = {
            command = "regen",
            info = {
                "Regeneration: Good for players who want the classic Halo experience. This is the Default.",
                "Level 1 - Health regenerates 3 seconds after shields recharge, at 20%/second.",
                "Level 2 - 2 Second Delay after shields recharge, at 25%/second. Unlocks Weapon 3.",
                "Level 3 - 1 Second Delay after shields recharge, at 30%/second. Melee damage is increased to 200%",
                "Level 4 - Health regenerates as soon as shields recharge, at 35%/second. You now spawn with full grenade count.",
                "Level 5 - Shields now charge 1 second sooner as well.",
            },
            levels = {
                [1] = {
                    -- Amount of health regenerated. (1 is full health)
                    increment = 0.0300,
                    -- Health will start regenerating this many seconds after shields are full:
                    regen_delay = 5,
                    -- Time (in seconds) between each incremental increase in health:
                    regen_rate = 1,
                    -- Experience Points required to rank up:
                    until_next_rank = 200,
                    grenades = { nil, nil },
                    weapons = { 2, nil, nil, nil },
                    shield_regen_delay = nil,
                },
                [2] = {
                    increment = 0.0550,
                    regen_delay = 4,
                    regen_rate = 1,
                    until_next_rank = 500,
                    grenades = { 2, 2 },
                    weapons = { 1, 2, nil, nil },
                    shield_regen_delay = nil,
                },
                [3] = {
                    increment = 0.750,
                    regen_delay = 3,
                    regen_rate = 1,
                    until_next_rank = 1000,
                    grenades = { 4, 4 },
                    weapons = { 1, 2, 4, nil },
                    shield_regen_delay = nil,
                },
                [4] = {
                    increment = 0.950,
                    regen_delay = 2,
                    regen_rate = 1,
                    until_next_rank = 2000,
                    grenades = { 5, 5 },
                    weapons = { 1, 2, nil, nil },
                    shield_regen_delay = nil,
                },
                [5] = {
                    increment = 0.1100,
                    regen_delay = 0,
                    regen_rate = 1,
                    until_next_rank = 3500,
                    grenades = { 7, 7 },
                    weapons = { 1, 2, nil, nil },
                    shield_regen_delay = 50,
                }
            },
        },

        ["Armor Boost"] = {
            command = "armor",
            info = {
                "Armor Boost: Good for players who engage vehicles or defend.",
                "Level 1 - 1.20x durability.",
                "Level 2 - 1.30x durability. Unlocks Weapon 3.",
                "Level 3 - 1.40x durability. Melee damage is increased to 200%",
                "Level 4 - 1.50x durability. You now spawn with full grenades.",
                "Level 5 - 1.55x durability. You are now immune to falling damage in addition to all other perks in this class.",
            },
            levels = {
                [1] = {
                    until_next_rank = 200,
                    -- Set to 0 to use default damage resistance:
                    damage_resistance = 1.20,
                    -- Set to true to enable fall damage immunity:
                    fall_damage_immunity = false,
                    melee_damage_multiplier = 0,
                    grenades = { nil, nil },
                    weapons = { 1, 2, nil, nil },
                },
                [2] = {
                    until_next_rank = 500,
                    damage_resistance = 1.30,
                    fall_damage_immunity = false,
                    melee_damage_multiplier = 0,
                    grenades = { nil, nil },
                    weapons = { 1, 2, 10, nil },
                },
                [3] = {
                    until_next_rank = 1000,
                    damage_resistance = 1.40,
                    fall_damage_immunity = false,
                    melee_damage_multiplier = 200,
                    grenades = { nil, nil },
                    weapons = { 1, 2, 10, nil },
                },
                [4] = {
                    until_next_rank = 2000,
                    damage_resistance = 1.50,
                    fall_damage_immunity = false,
                    melee_damage_multiplier = 200,
                    grenades = { nil, nil },
                    weapons = { 1, 2, 10, nil },
                },
                [5] = {
                    until_next_rank = nil,
                    damage_resistance = 1.55,
                    fall_damage_immunity = true,
                    melee_damage_multiplier = 200,
                    grenades = { 7, 7 },
                    weapons = { 1, 2, 10, nil },
                }
            }
        },

        ["Partial Camo"] = {
            command = "camo",
            info = {
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
                    grenades = { nil, nil },
                    weapons = { 1, 2, nil, nil },
                },
                [2] = {
                    until_next_rank = 500,
                    grenades = { nil, nil },
                    weapons = { 1, 2, nil, nil },
                },
                [3] = {
                    until_next_rank = 1000,
                    grenades = { nil, nil },
                    weapons = { 1, 2, nil, nil },
                },
                [4] = {
                    until_next_rank = 2000,
                    grenades = { nil, nil },
                    weapons = { 1, 2, nil, nil },
                },
                [5] = {
                    until_next_rank = 3500,
                    grenades = { nil, nil },
                    weapons = { 1, 2, nil, nil },
                }
            }
        },

        ["Recon"] = {
            command = "speed",
            info = {
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
                    grenades = { nil, nil },
                    weapons = { 1, 2, nil, nil },
                },
                [2] = {
                    until_next_rank = 500,
                    grenades = { nil, nil },
                    weapons = { 1, 2, nil, nil },
                },
                [3] = {
                    until_next_rank = 1000,
                    grenades = { nil, nil },
                    weapons = { 1, 2, nil, nil },
                },
                [4] = {
                    until_next_rank = 2000,
                    grenades = { nil, nil },
                    weapons = { 1, 2, nil, nil },
                },
                [5] = {
                    until_next_rank = 3500,
                    grenades = { nil, nil },
                    weapons = { 1, 2, nil, nil },
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
        [11] = "some_random\\epic\\weapon",

        -- repeat the structure to add more weapon tags:
        [12] = "a tag\\will go\\here",
    }
}
-- Configuration Ends --

-- Do not touch unless you know what you're doing!
local time_scale = 1 / 30
--

local tags = { }
local gmatch, gsub = string.gmatch, string.gsub
local lower, upper = string.lower, string.upper

local function Init()

    loadout.players = { }
    for i = 1, 16 do
        if player_present(i) then
            InitPlayer(i, false)
        end
    end

    -- # Disable Weapon Pick Ups
    execute_command("disable_object 'weapons\\assault rifle\\assault rifle'")
    execute_command("disable_object 'weapons\\flamethrower\\flamethrower'")
    execute_command("disable_object 'weapons\\needler\\mp_needler'")
    execute_command("disable_object 'weapons\\pistol\\pistol'")
    execute_command("disable_object 'weapons\\plasma pistol\\plasma pistol'")
    execute_command("disable_object 'weapons\\plasma rifle\\plasma rifle'")
    execute_command("disable_object 'weapons\\plasma_cannon\\plasma_cannon'")
    execute_command("disable_object 'weapons\\rocket launcher\\rocket launcher'")
    execute_command("disable_object 'weapons\\shotgun\\shotgun'")
    execute_command("disable_object 'weapons\\sniper rifle\\sniper rifle'")

    -- # Disable Grenade Pick Ups
    execute_command("disable_object 'weapons\\frag grenade\\frag grenade'")
    execute_command("disable_object 'weapons\\plasma grenade\\plasma grenade'")

    tags = {
        -- fall damage --
        [1] = GetTag("jpt!", "globals\\falling"),
        [2] = GetTag("jpt!", "globals\\distance"),

        -- vehicle collision --
        [3] = GetTag("jpt!", "globals\\vehicle_collision"),

        -- vehicle projectiles --
        [4] = GetTag("jpt!", "vehicles\\ghost\\ghost bolt"),
        [5] = GetTag("jpt!", "vehicles\\scorpion\\bullet"),
        [6] = GetTag("jpt!", "vehicles\\warthog\\bullet"),
        [7] = GetTag("jpt!", "vehicles\\c gun turret\\mp bolt"),
        [8] = GetTag("jpt!", "vehicles\\banshee\\banshee bolt"),
        [9] = GetTag("jpt!", "vehicles\\scorpion\\shell explosion"),
        [10] = GetTag("jpt!", "vehicles\\banshee\\mp_fuel rod explosion"),

        -- weapon projectiles --
        [11] = GetTag("jpt!", "weapons\\pistol\\bullet"),
        [12] = GetTag("jpt!", "weapons\\plasma rifle\\bolt"),
        [13] = GetTag("jpt!", "weapons\\shotgun\\pellet"),
        [14] = GetTag("jpt!", "weapons\\plasma pistol\\bolt"),
        [15] = GetTag("jpt!", "weapons\\needler\\explosion"),
        [16] = GetTag("jpt!", "weapons\\assault rifle\\bullet"),
        [17] = GetTag("jpt!", "weapons\\needler\\impact damage"),
        [18] = GetTag("jpt!", "weapons\\flamethrower\\explosion"),
        [19] = GetTag("jpt!", "weapons\\sniper rifle\\sniper bullet"),
        [20] = GetTag("jpt!", "weapons\\rocket launcher\\explosion"),
        [21] = GetTag("jpt!", "weapons\\needler\\detonation damage"),
        [22] = GetTag("jpt!", "weapons\\plasma rifle\\charged bolt"),
        [23] = GetTag("jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion"),

        -- grenades --
        [24] = GetTag("jpt!", "weapons\\frag grenade\\explosion"),
        [25] = GetTag("jpt!", "weapons\\plasma grenade\\attached"),
        [26] = GetTag("jpt!", "weapons\\plasma grenade\\explosion"),

        melee = {
            -- weapon melee --
            [1] = GetTag("jpt!", "weapons\\flag\\melee"),
            [2] = GetTag("jpt!", "weapons\\ball\\melee"),
            [3] = GetTag("jpt!", "weapons\\pistol\\melee"),
            [4] = GetTag("jpt!", "weapons\\needler\\melee"),
            [5] = GetTag("jpt!", "weapons\\shotgun\\melee"),
            [6] = GetTag("jpt!", "weapons\\flamethrower\\melee"),
            [7] = GetTag("jpt!", "weapons\\sniper rifle\\melee"),
            [8] = GetTag("jpt!", "weapons\\plasma rifle\\melee"),
            [9] = GetTag("jpt!", "weapons\\plasma pistol\\melee"),
            [10] = GetTag("jpt!", "weapons\\assault rifle\\melee"),
            [11] = GetTag("jpt!", "weapons\\rocket launcher\\melee"),
            [12] = GetTag("jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_melee"),
        },
    }
end

function OnScriptLoad()

    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_SCORE"], "OnPlayerScore")

    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")

    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_PRESPAWN"], "OnPlayerPreSpawn")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")

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

-- Returns and array: {exp, level}
local function GetLvlInfo(Ply)
    local p = loadout.players[Ply]
    return p.levels[p.class]
end

function GetPlayers(Executor, Args)
    local pl = { }
    if (Args[2] == "me" or Args[2] == nil) then
        if (Executor ~= 0) then
            table.insert(pl, Executor)
        else
            Respond(Executor, "The server cannot execute this command!", "rprint", 10)
        end
    elseif (Args[2] ~= nil) and (Args[2]:match("^%d+$")) then
        if player_present(Args[2]) then
            table.insert(pl, Args[2])
        else
            Respond(Executor, "Player #" .. Args[2] .. " is not online", "rprint", 10)
        end
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
        if (#pl == 0) then
            Respond(Executor, "There are no players online!", "rprint", 10)
        end
    else
        Respond(Executor, "Invalid Command Syntax. Please try again!", "rprint", 10)
    end
    return pl
end

function PauseRankHUD(Player, Clear)
    local p = loadout.players[Player]
    if (Clear) then
        cls(Player, 25)
    end
    p.rank_hud_pause = true
    p.rank_hud_pause_duration = loadout.rank_hud_pause_duration
end

function OnServerCommand(Executor, Command, _, _)
    local Args = CmdSplit(Command)
    if (Args == nil) then
        return
    else

        Args[1] = lower(Args[1]) or upper(Args[1])
        if (Executor > 0) then
            local p = loadout.players[Executor]
            PauseRankHUD(Executor, true)
            for class, v in pairs(loadout.classes) do
                if (Args[1] == v.command) then
                    if (p.class == class) then
                        Respond(Executor, "You already have " .. class .. " class", "rprint", 12)
                    else
                        p.switch_on_respawn[1] = true
                        p.switch_on_respawn[2] = class
                        Respond(Executor, "You will switch to " .. class .. " when you respawn", "rprint", 12)
                    end
                    return false
                elseif (Args[1] == loadout.info_command) then
                    p.help_page, p.show_help = class, true
                    return false
                end
            end
        end
    end

    --if (Args[1] == loadout.rank_up_command or Args[1] == loadout.rank_down_command) then
    --    local lvl = tonumber(get_var(Executor, "$lvl"))
    --    if (lvl >= loadout.change_level_permission_node) or (Executor == 0) then
    --        local pl = GetPlayers(Executor, Args)
    --        if (pl) and (#pl > 0) then
    --            local function Check(E, T)
    --                if (Args[1] == loadout.rank_up_command) then
    --                    Promote(E, T)
    --                elseif (Args[1] == loadout.rank_down_command) then
    --                    Demote(E, T)
    --                end
    --            end
    --            if (Args[2] == nil) then
    --                Check(Executor, Executor)
    --            else
    --                for i = 1, #pl do
    --                    Check(Executor, tonumber(pl[i]))
    --                end
    --            end
    --        end
    --        return false
    --    end
    --end
end

local function GetWeapon(WeaponIndex)
    return loadout.weapon_tags[WeaponIndex]
end

local function PrintRank(Ply)
    local p = loadout.players[Ply]
    if (not p.rank_hud_pause) then

        local lvl = GetLvlInfo(Ply)

        cls(Ply, 25)
        local str = loadout.rank_hud
        local req_exp = loadout.classes[p.class].levels[lvl.level].until_next_rank

        local words = {
            ["%%exp%%"] = lvl.exp,
            ["%%lvl%%"] = lvl.level,
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

local function PrintHelp(Ply, InfoTab)
    cls(Ply, 25)
    for i = 1, #InfoTab do
        Respond(Ply, InfoTab[i], "rprint", 10)
    end
end

function OnTick()

    for i, player in pairs(loadout.players) do
        if (i) then
            if player_alive(i) then

                local DyN = get_dynamic_player(i)
                if (DyN ~= 0) then

                    local level = player.levels[player.class].level
                    local current_class = loadout.classes[player.class]

                    if (player.assign) then
                        local coords = getXYZ(DyN)
                        if (not coords.invehicle) then
                            player.assign = false

                            SetGrenades(DyN, current_class, level)

                            execute_command("wdel " .. i)
                            local weapon_table = current_class.levels[level].weapons
                            for Slot, WeaponIndex in pairs(weapon_table) do
                                if (Slot == 1 or Slot == 2) then
                                    assign_weapon(spawn_object("weap", GetWeapon(WeaponIndex), coords.x, coords.y, coords.z), i)
                                elseif (Slot == 3 or Slot == 4) then
                                    timer(250, "DelaySecQuat", i, GetWeapon(WeaponIndex), coords.x, coords.y, coords.z)
                                end
                            end
                        end
                    elseif (player.class == "Regeneration") then

                        local health = read_float(DyN + 0xE0)
                        local shield = read_float(DyN + 0xE4)

                        local shield_regen_delay = tonumber(current_class.levels[level].shield_regen_delay)
                        if (shield < 1 and shield_regen_delay ~= nil and player.regen_shield) then
                            player.regen_shield = false
                            write_word(DyN + 0x104, shield_regen_delay)
                        end

                        if (health < 1 and shield == 1) then
                            player.time_until_regen_begin = player.time_until_regen_begin - time_scale
                            if (player.time_until_regen_begin <= 0) and (not player.begin_regen) then
                                player.time_until_regen_begin = current_class.levels[level].regen_delay
                                player.begin_regen = true
                            elseif (player.begin_regen) then
                                player.regen_timer = player.regen_timer + time_scale
                                if (player.regen_timer >= current_class.levels[level].regen_rate) then
                                    player.regen_timer = 0
                                    write_float(DyN + 0xE0, health + current_class.levels[level].increment)
                                end
                            end
                        elseif (player.begin_regen and health >= 1) then
                            player.begin_regen = false
                            player.regen_timer = 0
                        end
                    end
                end
            end

            if (loadout.show_rank_hud) then
                if (player.rank_hud_pause) then
                    player.rank_hud_pause_duration = player.rank_hud_pause_duration - time_scale
                    if (player.rank_hud_pause_duration <= 0) then
                        player.rank_hud_pause = false
                        player.rank_hud_pause_duration = loadout.rank_hud_pause_duration
                    end
                else
                    PrintRank(i)
                end
            end

            if (player.show_help) then
                player.help_hud_duration = player.help_hud_duration - time_scale
                PrintHelp(i, loadout.classes[player.class].info)
                if (player.help_hud_duration <= 0) then
                    player.help_page = nil
                    player.show_help = false
                    player.help_hud_duration = loadout.help_hud_duration
                end
            end
        end
    end
end

function OnPlayerScore(Ply)
    UpdateExp(Ply, loadout.experience.flag_score)
    SendStatsMessage(Ply, loadout.experience.flag_score, loadout.messages.flag_score)

    local pteam = get_var(Ply, "$team")
    for i = 1, 16 do
        if player_present(i) then
            local iteam = get_var(i, "$team")
            if (pteam == iteam) then
                if (i ~= Ply) then
                    SendStatsMessage(i, loadout.experience.flag_score, loadout.messages.flag_score_team)
                end
            end
        end
    end
end

function InitPlayer(Ply, Reset)
    if (Reset) then
        loadout.players[Ply] = nil
    else

        loadout.players[Ply] = {

            name = get_var(Ply, "$name"),

            bounty = 0,
            levels = { },

            class = loadout.default_class,
            switch_on_respawn = { false, nil },

            help_page = nil,
            show_help = false,
            help_hud_duration = loadout.help_hud_duration,

            rank_hud_pause = false,
            rank_hud_pause_duration = loadout.rank_hud_pause_duration,

            last_damage = nil,
            head_shot = nil,
        }

        for k, _ in pairs(loadout.classes) do
            loadout.players[Ply].levels[k] = {
                exp = 0,
                level = loadout.starting_level,
            }
        end
    end
end

function OnPlayerConnect(Ply)
    InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    InitPlayer(Ply, true)
end

function OnPlayerPreSpawn(Ply)
    local p = loadout.players[Ply]
    if (p.switch_on_respawn[1]) then
        p.switch_on_respawn[1] = false
        p.class = p.switch_on_respawn[2]
    end
end

function OnPlayerSpawn(Ply)

    local t = loadout.players[Ply]
    local info = GetLvlInfo(Ply)

    -- Weapon Assignment Variables
    t.assign = true

    -- Health regeneration Variables --
    t.regen_timer = 0
    t.begin_regen = false

    t.head_shot = nil
    t.last_damage = nil
    t.regen_shield = false

    t.time_until_regen_begin = loadout.classes["Regeneration"].levels[info.level].regen_delay
end

function SetGrenades(DyN, Class, Level)
    local frag_count = Class.levels[Level].grenades[1]
    local plasma_count = Class.levels[Level].grenades[2]
    if (frag_count ~= nil) then
        write_word(DyN + 0x31E, frag_count)
    end
    if (plasma_count ~= nil) then
        write_word(DyN + 0x31F, plasma_count)
    end
end

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    local killer, victim = tonumber(CauserIndex), tonumber(PlayerIndex)
    local v = loadout.players[victim]

    local hurt = true

    if player_present(victim) then
        if (CauserIndex > 0) then

            local k = loadout.players[killer]
            local k_info = GetLvlInfo(killer)

            local CausesHeadShot = OnDamageLookup(victim, killer)
            if (CausesHeadShot ~= nil) then
                if (HitString == "head") then
                    v.head_shot = true
                else
                    v.head_shot = false
                end
            else
                v.head_shot = false
            end

            if (k.class == "Armor Boost") and (killer ~= victim) then
                if (not IsMelee(MetaID)) then
                    Damage = Damage - (10 * loadout.classes[k.class].levels[k_info.level].damage_resistance)
                else
                    Damage = Damage + (loadout.classes[k.class].levels[k_info.level].melee_damage_multiplier)
                end
                hurt = true
            end
            k.last_damage = MetaID
        end
        local v_info = GetLvlInfo(victim)
        if (v.class == "Armor Boost") and (loadout.classes[v.class].levels[v_info.level].fall_damage_immunity) then
            if (MetaID == tags[1] or MetaID == tags[2]) then
                hurt = false
            end
        end

        v.regen_shield = true
        v.last_damage = MetaID
        return hurt, Damage
    end
end

function Promote(Executor, TargetID)
    local p = loadout.players[TargetID]
    local info = GetLvlInfo(TargetID)

    local name = get_var(TargetID, "$name")
    if (info.level >= #loadout.classes[p.class].levels) then
        local str = "[DEBUG] " .. name .. " is already on the highest tier for this class"
        if (Executor == TargetID) then
            str = "[DEBUG] You are already on the highest tier for this class"
        end
        Respond(Executor, str, "rprint", 10)
    else
        info.level = info.level + 1
        local str = "[DEBUG] Promoting " .. name .. " to level %lvl%"
        if (Executor == TargetID) then
            str = "[DEBUG] Promoting to level %lvl%"
        end
        Respond(Executor, gsub(str, "%%lvl%%", p.level), "rprint", 10)
        p.assign = true
        p.exp[p.class] = 0
    end
end

function Demote(Executor, TargetID)
    local p = loadout.players[TargetID]
    local info = GetLvlInfo(TargetID)
    local name = get_var(TargetID, "$name")
    info.level = info.level - 1
    if (info.level < 1) then
        info.level = 1
        local str = "[DEBUG] " .. name .. " is already on the first level"
        if (Executor == TargetID) then
            str = "[DEBUG] You are already on the first level"
        end
        return Respond(Executor, str, "rprint", 10)
    else
        local str = "[DEBUG] demoting " .. name .. " to level %lvl%"
        if (Executor == TargetID) then
            str = "[DEBUG] demoting to level %lvl%"
        end
        Respond(Executor, gsub(str, "%%lvl%%", info.level), "rprint", 10)
        p.assign = true
    end
end

local function Melee(Ply)
    for i = 1, #tags.melee do
        if (loadout.players[Ply].last_damage == tags.melee[i]) then
            return true
        end
    end
end

local function KillingSpree(killer)
    local player = get_player(killer)
    if (player ~= 0) then

        local m = loadout.messages
        local s = loadout.experience.spree
        local name = loadout.players[killer].name
        local bounty_level = loadout.players[killer].bounty

        local spree = read_word(player + 0x96)
        for _, v in pairs(s) do
            if (spree == v[1]) or (spree >= s[#s][1] and spree % 5 == 0) then
                bounty_level = bounty_level + v[3]
                SendStatsMessage(killer, v[2], m.death_messages.spree)

                local bonus = (bounty_level * loadout.experience.bounty_exp)
                local str = gsub(gsub(m.new_bounty, "%%name%%", name), "%%bounty%%", bonus)
                Respond(_, str, "say_all", 10)
            end
        end
    end
end

local function MultiKill(killer)
    local player = get_player(killer)
    if (player ~= 0) then
        local multikill = read_word(player + 0x98)
        local mk = loadout.experience.multi_kill
        local dm = loadout.messages.death_messages
        for _, v in pairs(mk) do
            if (multikill == v[1]) then
                return SendStatsMessage(killer, v[2], dm.multi_kill)
            elseif (multikill >= mk[#mk][1]) and (multikill % 2 == 0) then
                return SendStatsMessage(killer, v[2], dm.multi_kill)
            end
        end
    end
end

function SendStatsMessage(Ply, EXP, STR)
    UpdateExp(Ply, EXP)
    local kills = tonumber(get_var(Ply, "$kills"))
    STR = gsub(gsub(STR, "%%exp%%", EXP), "%%kills%%", kills)
    Respond(Ply, STR, "rprint", 10)
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local killer = tonumber(KillerIndex)
    local victim = tonumber(VictimIndex)

    local kteam = get_var(killer, "$team")
    local vteam = get_var(victim, "$team")
    local exp = loadout.experience
    local message = loadout.messages.death_messages

    local pvp = ((killer > 0) and killer ~= victim)
    local suicide = (killer == victim)
    local betrayal = ((kteam == vteam) and killer ~= victim)
    local vehicle_squash = (killer == 0)
    local guardians = (killer == nil)
    local server = (killer == -1)
    local fall_damage = (loadout.players[victim].last_damage == tags[1])
    local distance_damage = (loadout.players[victim].last_damage == tags[2])

    local frag_kill = (loadout.players[victim].last_damage == tags[24])
    local plasma_stick = (loadout.players[victim].last_damage == tags[25])
    local plasma_explosion = (loadout.players[victim].last_damage == tags[26])

    if (pvp) then

        MultiKill(killer)
        KillingSpree(killer)
        SendStatsMessage(killer, exp.pvp, message.pvp)

        if (loadout.players[victim].head_shot) then
            SendStatsMessage(killer, exp.head_shot, message.head_shot)
        elseif (frag_kill) then
            SendStatsMessage(killer, exp.frag_kill, message.frag_kill)
        elseif (plasma_stick) then
            SendStatsMessage(killer, exp.plasma_stick, message.plasma_stick)
        elseif (plasma_explosion) then
            SendStatsMessage(killer, exp.plasma_explosion, message.plasma_explosion)
        elseif (Melee(victim)) then
            SendStatsMessage(killer, exp.melee, message.melee)
        end

        -- Killed from the grave
        if (not player_alive(killer)) then
            SendStatsMessage(killer, exp.killed_from_the_grave, message.killed_from_the_grave)
        end

        -- PvP Bonus:
        if (exp.use_pvp_bonus) then
            local enemy_kills = tonumber(get_var(victim, "$kills"))
            local enemy_deaths = tonumber(get_var(victim, "$deaths"))
            local kdr_bonus = (enemy_kills / enemy_deaths)
            local pvp_bonus = exp.pvp_bonus(kdr_bonus)

            if (pvp_bonus > 0) then
                SendStatsMessage(killer, pvp_bonus, message.pvp_bonus)
            end
        end

        -- Skill bonus:

        local k_info = GetLvlInfo(killer)
        local v_info = GetLvlInfo(victim)

        local killer_class, killer_lvl = loadout.players[killer].class, k_info.level
        local victim_class, victim_lvl = loadout.players[victim].class, v_info.level
        if (killer_class == victim_class and killer_lvl > victim_lvl) then
            SendStatsMessage(killer, exp.skill_bonus, message.skill_bonus)
        end

    elseif (suicide) then
        SendStatsMessage(victim, exp.suicide, message.suicide)
    elseif (betrayal) then
        SendStatsMessage(victim, exp.betrayal, message.betrayal)
    elseif (vehicle_squash) then
        SendStatsMessage(victim, exp.vehicle_squash, message.vehicle_squash)
    elseif (guardians) then
        SendStatsMessage(victim, exp.guardians, message.guardians)
    elseif (server) then
        SendStatsMessage(victim, exp.server, message.server)
    elseif (fall_damage) then
        SendStatsMessage(victim, exp.fall_damage, message.fall_damage)
    elseif (distance_damage) then
        SendStatsMessage(victim, exp.distance_damage, message.distance_damage)
    end
end

function UpdateExp(Ply, Amount)
    local t = loadout.players[Ply]
    local info = GetLvlInfo(Ply)

    info.exp = info.exp + Amount
    if (not loadout.allow_negative_exp and info.exp < 0) then
        info.exp = 0
    end
end

function Respond(Ply, Message, Type, Color, Clear)

    Color = Color or 10
    execute_command("msg_prefix \"\"")

    if (Ply == 0) then
        cprint(Message, Color)
    else
        PauseRankHUD(Ply, Clear)
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

function IsMelee(MetaID)
    local melee
    for i = 1, #tags.melee do
        if (MetaID == tags.melee[i]) then
            melee = true
        end
    end
    return melee
end

function GetTag(ObjectType, ObjectName)
    local Tag = lookup_tag(ObjectType, ObjectName)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

-- Credits to H® Shaft for this function:
-- Taken from https://pastebin.com/edZ82aWn
function OnDamageLookup(ReceiverIndex, CauserIndex)
    local response
    if get_var(0, "$gt") ~= "n/a" then
        if (CauserIndex and ReceiverIndex ~= CauserIndex) then
            if (CauserIndex ~= 0) then
                local r_team = read_word(get_player(ReceiverIndex) + 0x20)
                local c_team = read_word(get_player(CauserIndex) + 0x20)
                if (r_team ~= c_team) then
                    local tag_address = read_dword(0x40440000)
                    local tag_count = read_word(0x4044000C)
                    for A = 0, tag_count - 1 do
                        local tag_id = tag_address + A * 0x20
                        if (read_dword(tag_id) == 1785754657) then
                            local tag_data = read_dword(tag_id + 0x14)
                            if (tag_data ~= nil) then
                                if (read_word(tag_data + 0x1C6) == 5) or (read_word(tag_data + 0x1C6) == 6) then
                                    if (read_bit(tag_data + 0x1C8, 1) == 1) then
                                        response = true
                                    else
                                        response = false
                                    end
                                end
                            end
                        end
                    end
                end
            else
                response = false
            end
        end
    end
    return response
end
--
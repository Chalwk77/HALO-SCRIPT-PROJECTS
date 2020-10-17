--[[
--=====================================================================================================--
Script Name: LoadOut, for SAPP (PC & CE)
Description: N/A

~ acknowledgements ~
Concept credit goes to OSH Clan, a gaming community operating on Halo CE.
- website:  https://oldschoolhalo.boards.net/

todo: implement vehicle noob protection

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

    experience = {

        pvp = 15,
        use_pvp_bonus = true,
        pvp_bonus = function(EnemyKDR)
            return (10 * EnemyKDR)
        end,

        suicide = -15,
        betrayal = -15,
        vehicle_squash = 15,
        guardians = 15,
        server = 15,
        fall_damage = -15,
        distance_damage = -15,

        -- Skill Bonus for killing an enemy with a higher class level than you:
        skill_bonus = 5,

        head_shot = 5,
        beat_down = 5,
        frag_kill = 5,
        plasma_stick = 5,
        plasma_explosion = 5,
        killed_from_the_grave = 10,

        -- consecutive kills required, xp rewarded
        spree = {
            { 5, 5 },
            { 10, 10 },
            { 15, 15 },
            { 20, 20 },
            { 25, 25 },
            { 30, 30 },
            { 35, 35 },
            { 40, 45 },
            { 50, 50 },
            -- The last entry is special:
            -- Award 100 XP every 5 kills at or above 55
            { 55, 100 },
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
                    -- Experience Points require to rank up:
                    until_next_rank = 200,
                    weapons = { 2, nil, nil, nil },
                },
                [2] = {
                    increment = 0.0550,
                    regen_delay = 4,
                    regen_rate = 1,
                    until_next_rank = 500,
                    weapons = { 1, 2, nil, nil },
                },
                [3] = {
                    increment = 0.750,
                    regen_delay = 3,
                    regen_rate = 1,
                    until_next_rank = 1000,
                    weapons = { 1, 2, 4, nil },
                },
                [4] = {
                    increment = 0.950,
                    regen_delay = 2,
                    regen_rate = 1,
                    until_next_rank = 2000,
                    weapons = { 1, 2, nil, nil },
                },
                [5] = {
                    increment = 0.1100,
                    regen_delay = 1,
                    regen_rate = 1,
                    until_next_rank = 3500,
                    weapons = { 1, 2, nil, nil },
                }
            },

            ["Armor Boost"] = {
                command = "armor",
                info = {
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

-- Do not touch unless you know what you're doing!
local time_scale = 1 / 30
--

local gmatch, gsub = string.gmatch, string.gsub
local lower, upper = string.lower, string.upper

local tags = { }

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

    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")

    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
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

function OnServerCommand(Executor, Command, _, _)
    local Args = CmdSplit(Command)
    if (Args == nil) then
        return
    else

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
            elseif (Args[1] == loadout.info_command) then
                p.help_page, p.show_help = class, true
                return false
            end
        end
    end
end

local function GetWeapon(WeaponIndex)
    return loadout.weapon_tags[WeaponIndex]
end

local function PrintRank(Ply)
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

                    local current_class = loadout.classes[player.class]
                    if (player.assign) then
                        local coords = getXYZ(DyN)
                        if (not coords.invehicle) then
                            player.assign = false
                            execute_command("wdel " .. i)
                            local weapon_table = current_class.levels[player.level].weapons
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

                        if (health < 1 and shield == 1) then
                            player.time_until_regen_begin = player.time_until_regen_begin - time_scale
                            if (player.time_until_regen_begin <= 0) and (not player.begin_regen) then
                                player.time_until_regen_begin = current_class.levels[player.level].regen_delay
                                player.begin_regen = true
                            elseif (player.begin_regen) then
                                player.regen_timer = player.regen_timer + time_scale
                                if (player.regen_timer >= current_class.levels[player.level].regen_rate) then
                                    player.regen_timer = 0
                                    write_float(DyN + 0xE0, health + current_class.levels[player.level].increment)
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

function InitPlayer(Ply, Reset)
    if (Reset) then
        loadout.players[Ply] = nil
    else
        loadout.players[Ply] = {
            exp = 0,

            rank_up = false,

            class = loadout.default_class,
            level = loadout.starting_level,

            help_page = nil,

            show_help = false,
            help_hud_duration = loadout.help_hud_duration,

            rank_hud_pause = false,
            rank_hud_pause_duration = loadout.rank_hud_pause_duration,

            last_damage = nil,
            head_shot = nil,

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

    local t = loadout.players[Ply]
    -- Weapon Assignment Variables
    t.assign = true

    -- Health regeneration Variables --
    t.regen_timer = 0
    t.begin_regen = false

    t.head_shot = nil
    t.last_damage = nil

    t.time_until_regen_begin = loadout.classes["Regeneration"].levels[t.level].regen_delay
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

function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    local killer, victim = tonumber(CauserIndex), tonumber(PlayerIndex)
    if player_present(victim) and (CauserIndex > 0) then
        local CausesHeadShot = OnDamageLookup(victim, killer)
        if (CausesHeadShot ~= nil) then
            if (HitString == "head") then
                loadout.players[victim].head_shot = true
            else
                loadout.players[victim].head_shot = false
            end
        else
            loadout.players[victim].head_shot = false
        end
        loadout.players[killer].last_damage = MetaID
        loadout.players[victim].last_damage = MetaID
    end
end

local function Melee(Victim)
    for i = 1, #tags.melee do
        if (loadout.players[Victim].last_damage == tags.melee[i]) then
            return true
        end
    end
end

local function KillingSpree(killer)
    local player = get_player(killer)
    if (player ~= 0) then
        local spree = read_word(player + 0x96)
        local s = loadout.experience.spree
        local max = s[#s]
        for _, v in pairs(s) do
            if (spree == v[1]) then
                return UpdateExp(killer, v[2])
            elseif (spree >= max[1]) and (spree % 5 == 0) then
                return UpdateExp(killer, max[2])
            end
        end
    end
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local killer = tonumber(KillerIndex)
    local victim = tonumber(VictimIndex)

    local kteam = get_var(killer, "$team")
    local vteam = get_var(victim, "$team")

    local k_kills = tonumber(get_var(killer, "$kills"))

    local pvp = ((killer > 0) and killer ~= victim)
    local suicide = (killer == victim)
    local betrayal = ((kteam == vteam) and killer ~= victim)
    local vehicle_squash = (killer == 0)
    local guardians = (killer == nil)
    local server = (killer == -1)
    local fall_damage = (loadout.players[victim].last_damage == tags[1])
    local distance_damage = (loadout.players[victim].last_damage == tags[2])

    if (pvp) then

        KillingSpree(killer)

        if (loadout.players[victim].head_shot) then
            UpdateExp(killer, loadout.experience.head_shot)
        elseif (Melee(victim)) then
            UpdateExp(killer, loadout.experience.beat_down)
        end

        -- Killed from the grave
        if (not player_alive(killer)) then
            UpdateExp(killer, loadout.experience.killed_from_the_grave)
        end

        local pvp_bonus = 0
        if (loadout.experience.use_pvp_bonus) then
            local enemy_kills = tonumber(get_var(victim, "$kills"))
            local enemy_deaths = tonumber(get_var(victim, "$deaths"))
            local kdr_bonus = (enemy_kills / enemy_deaths)
            pvp_bonus = loadout.experience.pvp_bonus(kdr_bonus)
        end
        UpdateExp(killer, loadout.experience.pvp + pvp_bonus)

        -- Skill bonus for killing an enemy with a higher class level than you:
        local killer_class, killer_lvl = loadout.players[killer].class, loadout.players[killer].level
        local victim_class, victim_lvl = loadout.players[victim].class, loadout.players[victim].level
        if (killer_class == victim_class and killer_lvl > victim_lvl) then
            UpdateExp(killer, loadout.experience.skill_bonus)
        end

    elseif (suicide) then
        UpdateExp(victim, loadout.experience.suicide)
    elseif (betrayal) then
        UpdateExp(victim, loadout.experience.betrayal)
    elseif (vehicle_squash) then
        UpdateExp(victim, loadout.experience.vehicle_squash)
    elseif (guardians) then
        UpdateExp(victim, loadout.experience.guardians)
    elseif (server) then
        UpdateExp(victim, loadout.experience.server)
    elseif (fall_damage) then
        UpdateExp(victim, loadout.experience.fall_damage)
    elseif (distance_damage) then
        UpdateExp(victim, loadout.experience.distance_damage)
    end
end

function UpdateExp(Player, Amount)
    loadout.players[Player].exp = loadout.players[Player].exp + Amount
    if (not loadout.allow_negative_exp and loadout.players[Player].exp < 0) then
        loadout.players[Player].exp = 0
    end
end

function GetTag(ObjectType, ObjectName)
    local Tag = lookup_tag(ObjectType, ObjectName)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

-- Credits to H® Shaft for this function:
-- Taken from https://pastebin.com/edZ82aWn
function OnDamageLookup(ReceiverIndex, CauserIndex)
    local response = nil
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
                                    -- damage category: bullets
                                    if (read_bit(tag_data + 0x1C8, 1) == 1) then
                                        -- damage effect: can cause head shots
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
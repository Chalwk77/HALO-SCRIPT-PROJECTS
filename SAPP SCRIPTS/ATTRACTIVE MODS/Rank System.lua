--[[
--=====================================================================================================--
Script Name: Rank System (v1.29), for SAPP (PC & CE)
Description: Rank System is fully integrated halo 3 style ranking system for SAPP servers.

Players earn credits for killing, scoring and achievements, such as sprees, kill-combos and more.
The higher your credit score, the higher your rank.
Stats are permanently saved to a database saved in the servers root directory.

Credits vary for individual weapons.
For example, you will earn 6 credits for killing someone with the sniper rifle, however, only 4 credits with the plasma pistol.

1): This mod requires that the following json library is installed to your server:
    Place "json.lua" in your servers root directory:
    http://regex.info/blog/lua/json

Copyright (c) 2020-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local Rank = {

    -- A JSON database containing information about all player ranks.
    -- This file will be located in the server's root directory.
    dir = "ranks.json",

    -- Suggestions: cR, $, Points, Candy
    currency_symbol = "cR",

    -- When enabled, players will earn 2X experience points.
    --
    double_exp = false,

    -- Starting rank & grade for new players:
    starting_rank = "Recruit",
    starting_grade = 1,
    starting_credits = 0,

    -- When should we update the rank database (ranks.json)?
    -- It's not recommended to save stats to file during player join & quit as this
    -- may cause undesirable (albeit temporary) lag.
    update_file_database = {
        ["OnGameEnd"] = true,
        ["OnPlayerConnect"] = false,
        ["OnPlayerDisconnect"] = false
    },

    -- Use this command to view stats on your current rank:
    -- Command Syntax: /check_rank_cmd [number: 1-16] | */all | me
    check_rank_cmd = "rank",
    check_rank_cmd_permission = -1,
    check_rank_cmd_permission_other = -1,

    -- Use this command to view a list of the top 10 players:
    -- Command Syntax: /toplist_cmd
    toplist_cmd = "toplist",
    toplist_cmd_permission = -1,
    toplist_format = "Rank#: [%pos%] %name% | Credits: %cr%",
    topplayers = {
        header = "--------------------------------------",
        txt = "Rank#: [%pos%] %name% | Credits: %cr%",
        footer = "--------------------------------------",
    },
    --

    -- TEA BAGGING SUPPORT --
    -- Toggle t-bag on or off:
    tbag = true,

    -- Radius (in world units) a player must be to trigger a t-bag
    tbag_trigger_radius = 2.5,

    -- A player's death coordinates expire after this many seconds;
    tbag_coordinate_expiration = 30,

    -- A player must crouch over a victim's body this many times in order to trigger the t-bag scenario
    tbag_crouch_count = 4,
    ------------------------------

    -- Fully customizable messages:
    messages = {

        -- This message is sent to a player when they join:
        [1] = {
            "You are rank [%rank%] Grade [%grade%] Position: [%pos%/%totalplayers%]",
            "Credits: %credits%",
        },
        --

        -- This message is broadcast server-wide when someone joins:
        [2] = { -- /rank command output (other player)
            "%name% is rank [%rank%] Grade [%grade%] Position: [%pos%/%totalplayers%]",
            "Credits: %credits%",
        },

        -- Messages sent to player lacking permission to execute a X command:
        [3] = { "You do not have permission to execute this command." },
        [4] = { "You do not have permission to execute this command on other players" },

        -- This message is broadcast server-wide when someone tea bags a body:
        [5] = "%name% is t-bagging %victim%",
        --

        -- This message is broadcast server-wide when someone ranks up:
        [6] = "%name% is now rank [%rank%] grade [%grade%]",

        -- This message is broadcast server-wide when someone completes all ranks:
        [7] = "%name% has completed all ranks!",

        -- This message is broadcast server-wide when someone completes all ranks:
        [8] = "%name% was downgraded and is now rank [%rank%] grade [%grade%]",

        -- This message is sent to a player they execute "/rank" command:
        [9] = {
            "You are rank [%rank%] Grade [%grade%] Position: [%pos%/%totalplayers%]",
            "Credits: %credits%",
            " ",
            "Next Rank: [%next_rank% Grade %next_grade%]",
            "[Credits Required: %req%]"
        }
    },

    -- Credits table defines experience levels earnt & action-specific messages:
    --
    credits = {

        -- Generic Zombie Mod support:
        zombies = {
            -- Set to "true" to enable.
            enabled = false,
            --
            human_team = "red",
            zombie_team = "blue",
            credits = { 25, "+25 %currency_symbol% (Zombie-Bite)" },
        },

        -- Tea Bagging (credits added):
        tbag = { 1, "+1 %currency_symbol% (T-Bagging)" },

        -- Score (credits added):
        score = { 5, "+5 %currency_symbol% (Flag Cap)" },

        -- Killed by Server (credits deducted):
        server = { -0, "-0 %currency_symbol% (Server)" },

        -- killed by guardians (credits deducted):
        guardians = { -5, "-5 %currency_symbol% (Guardians)" },

        -- suicide (credits deducted):
        suicide = { -10, "-10 %currency_symbol% (Suicide)" },

        -- betrayal (credits deducted):
        betrayal = { -15, "-15 %currency_symbol% (Betrayal)" },

        -- Killed from the grave (credits added to killer)
        killed_from_the_grave = { 5, "+5 %currency_symbol% (Killed From Grave)" },

        -- Bonus points for getting the first kill
        first_blood = { 30, "+30cR (First Blood)" },

        -- {consecutive kills, xp rewarded}
        spree = {
            { 5, 5, "+5 %currency_symbol% (spree)" },
            { 10, 10, "+10 %currency_symbol% (spree)" },
            { 15, 15, "+15 %currency_symbol% (spree)" },
            { 20, 20, "+20 %currency_symbol% (spree)" },
            { 25, 25, "+25 %currency_symbol% (spree)" },
            { 30, 30, "+30 %currency_symbol% (spree)" },
            { 35, 35, "+35 %currency_symbol% (spree)" },
            { 40, 40, "+40 %currency_symbol% (spree)" },
            { 45, 45, "+45 %currency_symbol% (spree)" },
            -- Award 50 credits for every 5 kills at or above 50
            { 50, 50, "+50 %currency_symbol% (spree)" },
        },

        -- kill-combo required, credits awarded
        multi_kill = {
            { 2, 8, "+8 %currency_symbol% (multi-kill)" },
            { 3, 10, "+10 %currency_symbol% (multi-kill)" },
            { 4, 12, "+12 %currency_symbol% (multi-kill)" },
            { 5, 14, "+14 %currency_symbol% (multi-kill)" },
            { 6, 16, "+16 %currency_symbol% (multi-kill)" },
            { 7, 18, "+18 %currency_symbol% (multi-kill)" },
            { 8, 20, "+20 %currency_symbol% (multi-kill)" },
            { 9, 23, "+23 %currency_symbol% (multi-kill)" },
            -- Award 25 credits every 2 kills at or above 10 kill-combos
            { 10, 25, "+25 %currency_symbol% (multi-kill)" },
        },

        tags = {

            --
            -- tag {type, name, credits}
            --

            -- FALL DAMAGE --
            --
            { "jpt!", "globals\\falling", -3, "-3 %currency_symbol% (Fall Damage)" },
            { "jpt!", "globals\\distance", -4, "-4 %currency_symbol% (Distance Damage)" },

            -- VEHICLE PROJECTILES --
            --
            { "jpt!", "vehicles\\ghost\\ghost bolt", 7, "+7 %currency_symbol% (Ghost Bolt)" },
            { "jpt!", "vehicles\\scorpion\\bullet", 6, "+6 %currency_symbol% (Tank Bullet)" },
            { "jpt!", "vehicles\\warthog\\bullet", 6, "+6 %currency_symbol% (Warthog Bullet)" },
            { "jpt!", "vehicles\\c gun turret\\mp bolt", 7, "+7 %currency_symbol% (Turret Bolt)" },
            { "jpt!", "vehicles\\banshee\\banshee bolt", 7, "+7 %currency_symbol% (Banshee Bolt)" },
            { "jpt!", "vehicles\\scorpion\\shell explosion", 10, "+10 %currency_symbol% (Tank Shell)" },
            { "jpt!", "vehicles\\banshee\\mp_fuel rod explosion", 10, "+10 %currency_symbol% (Banshee Fuel-Rod Explosion)" },

            -- WEAPON PROJECTILES --
            --
            { "jpt!", "weapons\\pistol\\bullet", 5, "+5 %currency_symbol% (Pistol Bullet)" },
            { "jpt!", "weapons\\shotgun\\pellet", 6, "+6 %currency_symbol% (Shotgun Pallet)" },
            { "jpt!", "weapons\\plasma rifle\\bolt", 4, "+4 %currency_symbol% (Plasma Rifle Bolt)" },
            { "jpt!", "weapons\\needler\\explosion", 8, "+8 %currency_symbol% (Needler Explosion)" },
            { "jpt!", "weapons\\plasma pistol\\bolt", 4, "+4 %currency_symbol% (Plasma Bolt)" },
            { "jpt!", "weapons\\assault rifle\\bullet", 5, "+5 %currency_symbol% (Assault Rifle Bullet)" },
            { "jpt!", "weapons\\needler\\impact damage", 4, "+4 %currency_symbol% (Needler Impact Damage)" },
            { "jpt!", "weapons\\flamethrower\\explosion", 5, "+5 %currency_symbol% (Flamethrower)" },
            { "jpt!", "weapons\\flamethrower\\burning", 5, "+5 %currency_symbol% (Flamethrower)" },
            { "jpt!", "weapons\\flamethrower\\impact damage", 5, "+5 %currency_symbol% (Flamethrower)" },
            { "jpt!", "weapons\\rocket launcher\\explosion", 8, "+8 %currency_symbol% (Rocket Launcher Explosion)" },
            { "jpt!", "weapons\\needler\\detonation damage", 3, "+3 %currency_symbol% (Needler Detonation Damage)" },
            { "jpt!", "weapons\\plasma rifle\\charged bolt", 4, "+4 %currency_symbol% (Plasma Rifle Bolt)" },
            { "jpt!", "weapons\\sniper rifle\\sniper bullet", 6, "+6 %currency_symbol% (Sniper Rifle Bullet)" },
            { "jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_explosion", 8, "+8 %currency_symbol% (Plasma Cannon Explosion)" },

            -- GRENADES --
            --
            { "jpt!", "weapons\\frag grenade\\explosion", 8, "+8 %currency_symbol% (Frag Explosion)" },
            { "jpt!", "weapons\\plasma grenade\\attached", 7, "+7 %currency_symbol% (Plasma Grenade - attached)" },
            { "jpt!", "weapons\\plasma grenade\\explosion", 5, "+5 %currency_symbol% (Plasma Grenade explosion)" },

            -- MELEE --
            --
            { "jpt!", "weapons\\flag\\melee", 5, "+5 %currency_symbol% (Melee: Flag)" },
            { "jpt!", "weapons\\ball\\melee", 5, "+5 %currency_symbol% (Melee: Ball)" },
            { "jpt!", "weapons\\pistol\\melee", 4, "+4 %currency_symbol% (Melee: Pistol)" },
            { "jpt!", "weapons\\needler\\melee", 4, "+4 %currency_symbol% (Melee: Needler)" },
            { "jpt!", "weapons\\shotgun\\melee", 5, "+5 %currency_symbol% (Melee: Shotgun)" },
            { "jpt!", "weapons\\flamethrower\\melee", 5, "+5 %currency_symbol% (Melee: Flamethrower)" },
            { "jpt!", "weapons\\sniper rifle\\melee", 5, "+5 %currency_symbol% (Melee: Sniper Rifle)" },
            { "jpt!", "weapons\\plasma rifle\\melee", 4, "+4 %currency_symbol% (Melee: Plasma Rifle)" },
            { "jpt!", "weapons\\plasma pistol\\melee", 4, "+4 %currency_symbol% (Melee: Plasma Pistol)" },
            { "jpt!", "weapons\\assault rifle\\melee", 4, "+4 %currency_symbol% (Melee: Assault Rifle)" },
            { "jpt!", "weapons\\rocket launcher\\melee", 10, "+10 %currency_symbol% (Melee: Rocket Launcher)" },
            { "jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_melee", 10, "+10 %currency_symbol% (Melee: Plasma Cannon)" },

            -- VEHICLE COLLISION --
            --
            vehicles = {
                collision = { "jpt!", "globals\\vehicle_collision" },
                { "vehi", "vehicles\\ghost\\ghost_mp", 5, "+5 %currency_symbol% (Vehicle Squash: GHOST)" },
                { "vehi", "vehicles\\rwarthog\\rwarthog", 6, "+6 %currency_symbol% (Vehicle Squash: R-Hog)" },
                { "vehi", "vehicles\\warthog\\mp_warthog", 7, "+7 %currency_symbol% (Vehicle Squash: Warthog)" },
                { "vehi", "vehicles\\banshee\\banshee_mp", 8, "+8 %currency_symbol% (Vehicle Squash: Banshee)" },
                { "vehi", "vehicles\\scorpion\\scorpion_mp", 10, "+10 %currency_symbol% (Vehicle Squash: Tank)" },
                { "vehi", "vehicles\\c gun turret\\c gun turret_mp", 1000, "+1000 %currency_symbol% (Vehicle Squash: Turret)" },
            }
        }
    },


    -- STAR OF THE SHOW --
    -- This table defines all rank requirements:
    ranks = {
        [1] = {
            rank = "Recruit",
            grade = {
                [1] = 0
            }
        },
        [2] = {
            rank = "Apprentice",
            grade = {
                [1] = 3000,
                [2] = 6000
            }
        },
        [3] = {
            rank = "Private",
            grade = {
                [1] = 9000,
                [2] = 12000
            }
        },
        [4] = {
            rank = "Corporal",
            grade = {
                [1] = 13000,
                [2] = 14000
            }
        },
        [5] = {
            rank = "Sergeant",
            grade = {
                [1] = 15000,
                [2] = 16000,
                [3] = 17000,
                [4] = 18000
            }
        },
        [6] = {
            rank = "Gunnery Sergeant",
            grade = {
                [1] = 19000,
                [2] = 20000,
                [3] = 21000,
                [4] = 22000
            }
        },
        [7] = {
            rank = "Lieutenant",
            grade = {
                [1] = 23000,
                [2] = 24000,
                [3] = 25000,
                [4] = 26000
            }
        },
        [8] = {
            rank = "Captain",
            grade = {
                [1] = 27000,
                [2] = 28000,
                [3] = 29000,
                [4] = 30000
            }
        },
        [9] = {
            rank = "Major",
            grade = {
                [1] = 31000,
                [2] = 32000,
                [3] = 33000,
                [4] = 34000
            }
        },
        [10] = {
            rank = "Commander",
            grade = {
                [1] = 35000,
                [2] = 36000,
                [3] = 37000,
                [4] = 38000
            }
        },
        [11] = {
            rank = "Colonel",
            grade = {
                [1] = 39000,
                [2] = 40000,
                [3] = 41000,
                [4] = 42000
            }
        },
        [12] = {
            rank = "Brigadier",
            grade = {
                [1] = 43000,
                [2] = 44000,
                [3] = 45000,
                [4] = 46000
            }
        },
        [13] = {
            rank = "General",
            grade = {
                [1] = 47000,
                [2] = 48000,
                [3] = 49000,
                [4] = 50000
            }
        }
    },


    --
    -- Advanced users only:
    --
    --

    -- Client data is saved as a json array.
    -- The array index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for IP-only indexing.
    ClientIndexType = 2,

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    server_prefix = "**SAPP**",
    --
}

local time_scale = 1 / 30
local script_version = 1.29

local sqrt = math.sqrt
local gsub = string.gsub

-- Preload JSON Interpreter Library:
--
local json = (loadfile "json.lua")()

function OnScriptLoad()

    -- register needed event callbacks:
    --

    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")
    register_callback(cb["EVENT_SCORE"], "OnPlayerScore")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamageApplication")
    --

    Rank:CheckFile(true)
end

function OnScriptUnload()
    Rank:UpdateJSON()
end

function OnGameStart()
    Rank:CheckFile()
end

function OnGameEnd()
    Rank:ShowEndResults()
    Rank:UpdateJSON("OnGameEnd")
end

function Rank:UpdateJSON(TYPE)
    if (self.update_file_database[TYPE]) then
        local ranks = self:GetRanks(true)
        if (ranks) then
            local file = assert(io.open(self.dir, "w"))
            if (file) then
                file:write(json:encode_pretty(ranks))
                file:close()
            end
        end
    end
end

function Rank:ShowEndResults()

    -- todo:
    -- this needs to show top 3 ONLINE players
    -- Not the top 3 on record.

    if tonumber(get_var(0, "$pn")) > 0 then

        local results = { }
        for i = 1, 16 do
            if player_present(i) then
                results[i] = self.players[i]
            end
        end

        if (#results > 0) then

            local t = { }
            for _, v in pairs(results) do
                t[#t + 1] = {
                    ["ip"] = v.ip,
                    ["credits"] = v.credits,
                    ["name"] = v.name
                }
            end

            table.sort(t, function(a, b)
                return a.credits > b.credits
            end)

            self:Respond(_, self.topplayers.header, say_all, 10)
            for i, v in pairs(t) do
                if (i > 0 and i < 4) then

                    if (i == 1) then
                        i = "1st"
                    elseif (i == 2) then
                        i = "2nd"
                    else
                        i = "3rd"
                    end

                    local str = gsub(gsub(gsub(self.topplayers.txt,
                            "%%pos%%", i),
                            "%%name%%", v.name),
                            "%%cr%%", v.credits)
                    self:Respond(_, str, say_all, 10)
                end
            end
            self:Respond(_, self.topplayers.footer, say_all, 10)
        end
    end
end

function Rank:InProximity(pX, pY, pZ, X, Y, Z)
    return sqrt((pX - X) ^ 2 + (pY - Y) ^ 2 + (pZ - Z) ^ 2) <= self.tbag_trigger_radius
end

function Rank:OnTick()
    if (self.tbag) then

        -- 1st Loop (tea baggers)
        --
        for i, itab in pairs(self.players) do

            -- 2nd Loop (victims)
            --
            for j, jtab in pairs(self.players) do
                if (i ~= j and jtab.coordinates and #jtab.coordinates > 0) then

                    -- Get x,y,z position of tea bagger:
                    --
                    local pos = self:GetXYZ(i)

                    -- Loop through all victim coordinate tables:
                    --
                    for cIndex, CTab in pairs(jtab.coordinates) do

                        -- increment expiration timer:
                        --
                        CTab.timer = CTab.timer + time_scale

                        -- Delete coordinate table on expire:
                        --
                        if (CTab.timer >= self.tbag_coordinate_expiration) then
                            jtab.coordinates[cIndex] = nil


                            -- Monitor tea bagger position --
                        elseif ((pos and pos.x) and not pos.in_vehicle) then

                            -- tea bagger coordinates:
                            local px, py, pz = pos.x, pos.y, pos.z
                            --

                            -- corpse coordinates:
                            local x, y, z = CTab.x, CTab.y, CTab.z
                            --

                            -- Check if tea bagger is within proximity of victim's corpse:
                            if self:InProximity(px, py, pz, x, y, z) then

                                -- Check if player is crouching & increment crouch count:
                                local crouch = read_bit(pos.dyn + 0x208, 0)
                                if (crouch ~= itab.crouch_state and crouch == 1) then
                                    itab.crouch_count = itab.crouch_count + 1


                                    -- Broadcast tea bag message:
                                    --
                                elseif (itab.crouch_count >= self.tbag_crouch_count) then
                                    local str = gsub(gsub(self.messages[5], "%%name%%", itab.name), "%%victim%%", jtab.name)
                                    self:Respond(i, str, say, 10, true)
                                    self:UpdateCredits(i, { self.credits.tbag[1], self.credits.tbag[2] })
                                    itab.crouch_count = 0
                                    itab.crouch_state = 0
                                    jtab.coordinates[cIndex] = nil
                                end
                                itab.crouch_state = crouch
                            end
                        end
                    end
                end
            end
        end
    end
end

function OnPlayerConnect(Ply)
    Rank:AddNewPlayer(Ply, false)
end

function OnPlayerSpawn(Ply)
    if (Rank.players[Ply]) then
        Rank.players[Ply].crouch_state = 0
        Rank.players[Ply].crouch_count = 0
    end
end

function OnPlayerDisconnect(Ply)
    Rank:UpdateJSON("OnPlayerDisconnect")
    Rank.players[Ply ~= nil and Ply] = nil
end

function OnPlayerScore(Ply)
    Rank:UpdateCredits(tonumber(Ply), {
        Rank.credits.score[1],
        Rank.credits.score[2]
    })
end

local function Completed()
    local done = { }
    for i, stats in pairs(Rank.ranks) do
        for k, _ in pairs(stats.grade) do
            done[i] = done[i] or { }
            if (done[i][k] == nil) then
                if (i == 1 and #stats.grade == 1) then
                    done[i][k] = true
                else
                    done[i][k] = false
                end
            end
        end
    end
    return done
end

function Rank:AddNewPlayer(Ply, ManualLoad)

    local IP = self:GetIP(Ply)
    local name = get_var(Ply, "$name")

    local pl = self.database
    if (pl[IP] == nil) then
        pl[IP] = {
            ip = IP,
            name = name,
            rank = self.starting_rank,
            grade = self.starting_grade,
            credits = self.starting_credits,
            done = Completed()
        }
        self.database = pl
    end

    self.players[Ply] = { }
    self.players[Ply] = pl[IP]
    self.players[Ply].name = name
    self.players[Ply].last_damage = 0

    if (self.players[Ply].credits < 0) then
        self.players[Ply].credits = 0
    end

    -- T-Bag Support:
    self.players[Ply].coordinates = { }
    self.players[Ply].crouch_state = 0
    self.players[Ply].crouch_count = 0
    --

    -- false when called from OnPlayerConnect()
    if (not ManualLoad) then
        self:UpdateJSON("OnPlayerConnect")
        self:GetRank(Ply, IP)
    end
end

function Rank:GetRanks(QUIT)

    local ranks = self.database
    if (ranks) then
        for i = 1, 16 do
            if player_present(i) and (self.players[i]) then
                if (QUIT) then
                    self.players[i].coordinates = nil
                    self.players[i].last_damage = nil
                    self.players[i].crouch_count = nil
                    self.players[i].crouch_state = nil
                end
                ranks[self:GetIP(i)] = self.players[i]
            end
        end
    end

    return ranks
end

function SortRanks()

    local ranks = Rank:GetRanks()
    local results = { }
    if (ranks) then

        for _, v in pairs(ranks) do
            results[#results + 1] = {
                ["ip"] = v.ip,
                ["name"] = v.name,
                ["rank"] = v.rank,
                ["grade"] = v.grade,
                ["credits"] = v.credits
            }
        end

        table.sort(results, function(a, b)
            return a.credits > b.credits
        end)
    end
    return results
end

function Rank:PrintRank(Ply, Pos, Stats, Total, I, NextRank, NextGrade, Required)
    local replace = {
        ["%%pos%%"] = Pos,
        ["%%req%%"] = Required,
        ["%%name%%"] = Stats.name,
        ["%%rank%%"] = Stats.rank,
        ["%%grade%%"] = Stats.grade,
        ["%%totalplayers%%"] = Total,
        ["%%next_rank%%"] = NextRank,
        ["%%next_grade%%"] = NextGrade,
        ["%%credits%%"] = Stats.credits
    }
    for _, str in pairs(self.messages[I]) do
        for key, value in pairs(replace) do
            str = gsub(str, key, value)
        end
        self:Respond(Ply, str, say, 10)
    end
end

function Rank:GetRank(Ply, IP, CMD)
    local results = SortRanks()
    if (#results > 0) then
        for k, v in pairs(results) do
            if (IP == v.ip) then

                if (CMD) then
                    if (self:GetIP(Ply) == IP) then

                        local t = self.players[Ply]
                        local grade, credits = t.grade, t.credits

                        for i, stats in pairs(self.ranks) do
                            if (stats.rank == t.rank) then
                                for _, _ in pairs(stats.grade) do
                                    if (stats.grade[grade + 1] ~= nil) then
                                        self:PrintRank(Ply, k, v, #results, 9, stats.rank, grade + 1, stats.grade[grade + 1] - credits)
                                        break
                                    elseif (self.ranks[i + 1] ~= nil) then
                                        self:PrintRank(Ply, k, v, #results, 9, self.ranks[i + 1].rank, 1, self.ranks[i + 1].grade[1] - credits)
                                        break
                                    else
                                        self:Respond(Ply, "COMPLETED ALL RANKS", say, 10)
                                        break
                                    end
                                end
                            end
                        end
                    else
                        self:PrintRank(Ply, k, v, #results, 2)
                    end
                else

                    self:PrintRank(Ply, k, v, #results, 1)

                    local a = " connected -> Rank [" .. v.rank .. "] "
                    local b = a .. "Grade [" .. v.grade .. "] Position: "
                    local Str = b .. k .. " of " .. #results .. " with " .. v.credits .. " credits."
                    self:Respond(Ply, Str, say, 10, true)
                end
            end
        end
    end
end

function Rank:FirstBlood(Ply)
    local kills = tonumber(get_var(Ply, "$kills"))
    if (kills == 1) then
        self.first_blood = false
        self:UpdateCredits(Ply, {
            self.credits.first_blood[1],
            self.credits.first_blood[2]
        })
    end
end

function Rank:GetIP(Ply)
    local IP = get_var(Ply, "$ip")
    IP = IP or self.players[Ply].ip
    if (self.ClientIndexType == 1) then
        IP = IP:match("%d+.%d+.%d+.%d+")
    end
    return IP
end

function Rank:CheckFile(ScriptLoad)

    if (ScriptLoad) then
        self.database = nil
    end

    self.players = { }
    self.game_started = false

    if (get_var(0, "$gt") ~= "n/a") then

        self.team_play = (get_var(0, "$ffa") == "0")
        self.game_started = true
        self.first_blood = true

        if (self.database == nil) then

            local content = ""
            local file = io.open(self.dir, "r")
            if (file) then
                content = file:read("*all")
                file:close()
            end

            local records = json:decode(content)
            if (not records) then
                file = assert(io.open(self.dir, "w"))
                if (file) then
                    records = { }
                    file:write(json:encode_pretty(records))
                    file:close()
                end
            end

            self.database = records

            for i = 1, 16 do
                if player_present(i) then
                    self:AddNewPlayer(i, true)
                end
            end
        end
    end
end

-- Returns the MetaID of the tag address:
local function GetTag(Type, Name)
    if type(Type) == "string" then
        local Tag = lookup_tag(Type, Name)
        return Tag ~= 0 and read_dword(Tag + 0xC) or nil
    end
    return nil
end

local function CheckDamageTag(DamageMeta)
    for _, d in pairs(Rank.credits.tags) do
        local tag = GetTag(d[1], d[2])
        if (tag ~= nil and tag == DamageMeta) then
            return { d[3], d[4] }
        end
    end
    return { 0, "Rank System: Invalid Tag Address Damage Meta" }
end

function Rank:KillingSpree(Ply)
    local player = get_player(Ply)
    if (player ~= 0) then
        local t = self.credits.spree
        local k = read_word(player + 0x96)
        for _, v in pairs(t) do
            if (k == v[1]) or (k >= t[#t][1] and k % 5 == 0) then
                self:UpdateCredits(Ply, { v[2], v[3] })
            end
        end
    end
end

function Rank:MultiKill(Ply)
    local player = get_player(Ply)
    if (player ~= 0) then
        local k = read_word(player + 0x98)
        local t = self.credits.multi_kill
        for _, v in pairs(t) do
            if (k == v[1]) or (k >= t[#t][1] and k % 2 == 0) then
                self:UpdateCredits(Ply, { v[2], v[3] })
            end
        end
    end
end

function Rank:GetXYZ(Ply)

    local pos = { }

    local DyN = get_dynamic_player(Ply)
    if (player_alive(Ply) and DyN ~= 0) then

        pos.dyn = DyN
        pos.in_vehicle = false
        pos.x, pos.y, pos.z = read_vector3d(DyN + 0x5c)

        local VehicleID = read_dword(DyN + 0x11C)
        local VObject = get_object_memory(VehicleID)
        if (VObject ~= 0) then
            pos.in_vehicle = true
            pos.x, pos.y, pos.z = read_vector3d(VObject + 0x5c)
        end
    end

    return (pos.x and pos) or nil
end

function Rank:OnPlayerDeath(V, K)

    local killer, victim = tonumber(K), tonumber(V)

    local last_damage = self.players[victim].last_damage
    local kteam = get_var(killer, "$team")
    local vteam = get_var(victim, "$team")

    local server = (killer == -1)
    local guardians = (killer == nil)
    local suicide = (killer == victim)
    local pvp = ((killer > 0) and killer ~= victim)
    local betrayal = (kteam == vteam and killer ~= victim and self.team_play)
    if (pvp and not betrayal) then

        self:MultiKill(killer)
        self:KillingSpree(killer)

        -- Killed from Grave:
        if (not player_alive(killer)) then
            self:UpdateCredits(killer, {
                self.credits.killed_from_the_grave[1],
                self.credits.killed_from_the_grave[2]
            })
        end

        -- Check for first blood:
        if (self.first_blood) then
            self:FirstBlood(killer)
        end
        --

        -- T-Bag Support:
        if (self.tbag) then
            local pos = self:GetXYZ(victim)
            if (pos and self.players[victim]) then
                table.insert(self.players[victim].coordinates, {
                    timer = 0,
                    x = pos.x,
                    y = pos.y,
                    z = pos.z
                })
            end
        end
        --

        -- Check if killer is in Vehicle:
        local pos = self:GetXYZ(killer)
        if (pos and pos.in_vehicle) then
            local t = self.credits.tags.vehicles
            for _, v in pairs(t) do
                if (pos.name == v[2]) then
                    if (last_damage == GetTag(t.collision[1], t.collision[2])) then
                        return self:UpdateCredits(killer, { v[3], v[4] })
                    else
                        return self:UpdateCredits(killer, CheckDamageTag(last_damage))
                    end
                end
            end
        end

        -- Zombie Support:
        local case = (kteam == self.credits.zombies.zombie_team and vteam == self.credits.zombies.human_team)
        local zombie_infect = (self.credits.zombies.enabled) and (case)
        if (zombie_infect) then
            self:UpdateCredits(killer, { self.credits.zombies.credits[1], self.credits.zombies.credits[2] })
        else
            return self:UpdateCredits(killer, CheckDamageTag(last_damage))
        end

    elseif (server) then
        self:UpdateCredits(victim, { self.credits.server[1], self.credits.server[2] })
    elseif (guardians) then
        self:UpdateCredits(victim, { self.credits.guardians[1], self.credits.guardians[2] })
    elseif (suicide) then
        self:UpdateCredits(victim, { self.credits.suicide[1], self.credits.suicide[2] })
    elseif (betrayal) then
        self:UpdateCredits(killer, { self.credits.betrayal[1], self.credits.betrayal[2] })
    else
        self:UpdateCredits(victim, CheckDamageTag(last_damage))
    end
end

function Rank:UpdateCredits(Ply, Params)

    local cr = Params[1]
    if (self.double_exp) then
        cr = (cr * 2)
    end

    local str = Params[2]
    self.players[Ply].credits = self.players[Ply].credits + cr

    str = gsub(str, "%%currency_symbol%%", self.currency_symbol)
    self:Respond(Ply, str, rprint, 10)

    if (self.players[Ply].credits < 0) then
        self.players[Ply].credits = 0
    end

    self:UpdateRank(Ply)
end

function Rank:UpdateRank(Ply, Silent)

    local t = self.players[Ply]
    local cr, name = t.credits, t.name
    for i, stats in pairs(self.ranks) do
        for k, v in pairs(stats.grade) do

            if (not self.players[Ply].done[i][k]) then

                local next_rank = self.ranks[i + 1]
                local next_grade = (stats.grade[k + 1] ~= nil)

                local case1 = (cr > stats.grade[#stats.grade] and next_rank == nil)
                local case2 = (next_grade and cr >= v and cr < stats.grade[k + 1])
                local case3 = (cr == stats.grade[#stats.grade]) and (cr == v)
                local case4 = (next_rank ~= nil and (cr > stats.grade[#stats.grade] and cr < next_rank.grade[1]))

                if (case1) and (not self.players[Ply].done[i][#stats.grade]) then
                    self.players[Ply].rank, self.players[Ply].grade = stats.rank, #stats.grade
                    self.players[Ply].done[i][#stats.grade] = true
                    if (not Silent) then
                        local str = self.messages[7]
                        str = gsub(str, "%%name%%", name)
                        self:Respond(_, str, say_all, 10)
                    end
                    return
                elseif (case2) or (case3) or (case4) then
                    self.players[Ply].rank, self.players[Ply].grade = stats.rank, k
                    self.players[Ply].done[i][k] = true
                    if (not Silent) then
                        local str = self.messages[6]
                        str = gsub(gsub(gsub(str, "%%name%%", name), "%%grade%%", k), "%%rank%%", stats.rank)
                        self:Respond(_, str, say_all, 10)
                    end
                    return
                end
            elseif (k == t.grade and stats.rank == t.rank) then

                local previous_rank = self.ranks[i - 1]
                local previous_grade = stats.grade[k - 1]

                if (cr < v) and (cr > 0) then
                    if (previous_grade) then
                        self.players[Ply].rank, self.players[Ply].grade = stats.rank, k - 1
                    elseif (previous_rank) then
                        self.players[Ply].rank, self.players[Ply].grade = previous_rank.rank, #previous_rank.grade
                    end
                    self.players[Ply].done[i][k] = false
                    if (not Silent) then
                        local str = self.messages[8]
                        str = gsub(gsub(gsub(str,
                                "%%name%%", name),
                                "%%grade%%", self.players[Ply].grade),
                                "%%rank%%", self.players[Ply].rank)
                        self:Respond(_, str, say_all, 10)
                    end
                end
            end
        end
    end
end

function Rank:OnDamage(V, K, MetaID, _, _, _)
    if (self.game_started) then

        local k, v = tonumber(K), tonumber(V)
        if player_present(v) then
            if (k > 0) then
                if (self.players and self.players[k]) then
                    self.players[k].last_damage = MetaID
                end
            end
            if (self.players and self.players[v]) then
                self.players[v].last_damage = MetaID
            end
        end
    end
end

function Rank:Respond(Ply, Msg, Type, Color, Exclude)
    Color = Color or 10
    execute_command("msg_prefix \"\"")

    if (Ply == 0) then
        return cprint(Msg, Color)
    elseif (not Exclude) then
        if (Type ~= say_all) then
            Type(Ply, Msg)
        else
            Type(Msg)
        end
        return
    end

    for i = 1, 16 do
        if player_present(i) and (i ~= Ply) then
            Type(i, Msg)
        end
    end
    execute_command("msg_prefix \" " .. self.server_prefix .. "\"")
end

local function CMDSplit(CMD)
    local Args = { }
    for Params in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end
    return Args
end

function Rank:OnServerCommand(Ply, Command)
    local Args = CMDSplit(Command)
    if (Args) then
        local lvl = tonumber(get_var(Ply, "$lvl"))
        if (Args[1] == self.check_rank_cmd) then
            if (lvl >= self.check_rank_cmd_permission) then
                local pl = self:GetPlayers(Ply, Args)
                if (pl) then
                    for i = 1, #pl do
                        local TargetID = tonumber(pl[i])
                        if (TargetID ~= Ply and lvl < self.check_rank_cmd_permission_other) then
                            self:Respond(Ply, self.messages[4], rprint, 10)
                        else
                            self:GetRank(Ply, self:GetIP(TargetID), true)
                        end
                    end
                end
            else
                self:Respond(Ply, self.messages[3], rprint, 10)
            end
            return false
        elseif (Args[1] == self.toplist_cmd) then
            if (lvl >= self.toplist_cmd_permission) then
                local results = SortRanks()
                if (#results > 0) then
                    for i, v in pairs(results) do
                        if (i > 0 and i < 11) then
                            local str = gsub(gsub(gsub(self.toplist_format,
                                    "%%pos%%", i),
                                    "%%name%%", v.name),
                                    "%%cr%%", v.credits)
                            self:Respond(Ply, str, rprint, 10)
                        end
                    end
                else
                    self:Respond(Ply, "Nothing to show!", rprint, 10)
                end
            end
            return false
        end
    end
end

function Rank:GetPlayers(Executor, Args)
    local pl = { }
    if (Args[2] == "me" or Args[2] == nil) then
        if (Executor ~= 0) then
            table.insert(pl, Executor)
        else
            self:Respond(Executor, "The server cannot execute this command!", rprint, 10)
        end
    elseif (Args[2] ~= nil and Args[2]:match("^%d+$")) then
        if player_present(Args[2]) then
            table.insert(pl, Args[2])
        else
            self:Respond(Executor, "Player #" .. Args[2] .. " is not online", rprint, 10)
        end
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
        if (#pl == 0) then
            self:Respond(Executor, "There are no players online!", rprint, 10)
        end
    else
        self:Respond(Executor, "Invalid Command Syntax. Please try again!", rprint, 10)
    end
    return pl
end

-- SUPPORT FOR MY RAGE QUIT SCRIPT --
function UpdateRageQuit(IP, Amount)
    local ranks = Rank:GetRanks(true)

    if (ranks and ranks[IP]) then
        ranks[IP].credits = ranks[IP].credits - Amount

        local name = ranks[IP].name
        local str = name .. " was penalized " .. Amount .. "x credits for rage-quitting"
        Rank:Respond(_, str, say_all, 10)
        Rank:Respond(0, str, "n/a", 10)
    end
end

function OnServerCommand(P, C)
    return Rank:OnServerCommand(P, C)
end

function OnPlayerDeath(V, K)
    return Rank:OnPlayerDeath(V, K)
end

function OnDamageApplication(V, K, M, _, _, _)
    return Rank:OnDamage(V, K, M, _, _, _)
end

function OnTick()
    return Rank:OnTick()
end

function WriteLog(str)
    local file = io.open("Rank System.log", "a+")
    if (file) then
        file:write(str .. "\n")
        file:close()
    end
end

-- In the event of an error, the script will trigger these two functions: OnError(), report()
function report(StackTrace, Error)

    cprint(StackTrace, 4 + 8)

    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. script_version, 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)

    local timestamp = os.date("[%H:%M:%S - %d/%m/%Y]")
    WriteLog(timestamp)
    WriteLog("Please report this error on github:")
    WriteLog("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues")
    WriteLog("Script Version: " .. tostring(script_version))
    WriteLog(Error)
    WriteLog(StackTrace)
    WriteLog("\n")
end

-- This function will return a string with a traceback of the stack call...
-- and call function 'report' after 50 milliseconds.
function OnError(Error)
    local StackTrace = debug.traceback()
    timer(50, "report", StackTrace, Error)
end
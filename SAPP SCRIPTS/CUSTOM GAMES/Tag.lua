--[[
--=====================================================================================================--
Script Name: Tag (v1.1), for SAPP (PC & CE)
Description: Tag, you're it!

This is a game involving two or more players.
A game of tag is initiated by meleeing a player; this player will become "it" (the tagger).

If a game of tag is in play, you will accumulate points as a runner.
The score limit is 10,000 & taggers get a 1.5x speed boost.

When you tag someone, you will earn 500 points.

Taggers will be "it" for a maximum of 60 seconds; after which a random
player (excluding the previous tagger) will become the new tagger.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- configuration starts  -------------------------------------------
local Tag = {

    -- Set to 0 to disable:
    points_on_tag = 500,

    -- Tagger turn timer (in seconds):
    turn_timer = 60,
    --

    -- Messages omitted when a new tagger is selected:
    on_tag = "%victim% was tagged by %tagger%!",

    -- Messages omitted when a NEW game of tag begins:
    on_game_start = {
        "%cname% has initialised a game of tag!",
        "%vname% is it!"
    },
    --

    -- Message omitted when random player is chosen to be "it":
    on_random_selection = "%name% is now the tagger!",
    --

    -- Min players required to start a game of tag:
    players_required = 2,
    --

    -- When a tagger quits, should we select a new random tagger?
    new_tagger_on_quit = true,
    --

    -- Should we pick a new tagger if the current tagger dies?
    new_tagger_on_death = false,
    --

    -- SCORING --
    -- Set to nil to disabled the score limit.
    --
    score_limit = nil,

    -- Runners will accumulate points while a game of tag is in play.
    -- Add "points_per_interval" points per "runner_time" seconds
    runner_time = 5,
    points_per = 100,
    --

    -- Players can be tagged by any of these weapons:
    -- Set to "false" to disable.
    melee = {
        ["weapons\\flag\\melee"] = true,
        ["weapons\\ball\\melee"] = true,
        ["weapons\\pistol\\melee"] = true,
        ["weapons\\needler\\melee"] = true,
        ["weapons\\shotgun\\melee"] = true,
        ["weapons\\flamethrower\\melee"] = true,
        ["weapons\\sniper rifle\\melee"] = true,
        ["weapons\\plasma rifle\\melee"] = true,
        ["weapons\\plasma pistol\\melee"] = true,
        ["weapons\\assault rifle\\melee"] = true,
        ["weapons\\rocket launcher\\melee"] = true,
        ["weapons\\plasma_cannon\\effects\\plasma_cannon_melee"] = true
    },

    ---------------- Player Speed Logic ----------------
    -- {tagger speed, runner speed)
    speed = { 1.5, 1 },

    -- If enabled, the tagger will slow down a bit, when receiving damage
    tagger_speed_reduce = false,
    --

    -- Time (in seconds) that a tagger's speed will be reduced:
    speed_reduce_interval = 0.10,

    -- The taggers speed will be reduced by this amount:
    -- (Tagger speed - speed_reduction)
    speed_reduction = 1.2,
    ------------------------------------------------------------------

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    server_prefix = "**SAPP**"
    --
}

-- configuration ends --
---=========================================================================---
---
---
local gsub = string.gsub
local time_scale = 1 / 30

-- Used for error reporting; See function report()
local script_version = 1.1

-- SAPP Lua API Version:
api_version = "1.12.0.0"

function OnScriptLoad()

    -- register needed event callbacks --
    register_callback(cb["EVENT_TICK"], "OnTick")

    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_SPAWN"], "OnPlayerSpawn")

    register_callback(cb["EVENT_JOIN"], "OnPlayerJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")

    register_callback(cb["EVENT_GAME_END"], "GameEnd")
    register_callback(cb["EVENT_GAME_START"], "GameStart")

    register_callback(cb["EVENT_DAMAGE_APPLICATION"], "OnDamage")
    Tag:Init()
end

function Tag:Init()
    if (get_var(0, "$gt") ~= "n/a") then

        -- Set the score limit:
        if (self.score_limit) then
            execute_command("scorelimit " .. self.score_limit)
        end

        self.players = { }
        self:Stop()
    end
end

function Tag:IsTagger(Ply)

    -- Returns true if Ply is the tagger:
    if (Ply) then
        return (Ply == self.tagger)
    end

    -- Returns the tagger index id:
    return self.tagger
    --
end

-- Sets a new tagger:
--
function Tag:SetTagger(Tagger)
    self.tagger = Tagger
    self:SetSpeed(Tagger)
    self:Start()
end

-- Picks a new random tagger:
--
function Tag:PickNewTagger()

    local req = self.players_required
    if tonumber(get_var(0, "$pn")) < req then
        return
    end

    --
    -- Get the index id of the current tagger if one exists:
    local excluded = self:IsTagger()
    --

    -- Only reset timer variables once we have
    -- established who the current tagger is (excluded):
    self:Stop()

    -- Reset previous taggers speed:
    self:SetSpeed(excluded)
    --

    -- set candidates:
    local t = { }
    for i, v in pairs(self.players) do

        -- ignore previous tagger
        if (i == excluded) then
            v.speed_timer = nil
        else
            -- add player:
            t[#t + 1] = i
        end
    end
    --

    -- Pick random candidate:
    if (#t > 0) then

        math.randomseed(os.clock())
        math.random();
        math.random();
        math.random();

        local i = t[math.random(1, #t)]
        self:SetTagger(i)
        self:Say(gsub(self.on_random_selection, "%%name%%", self.players[i].name))
    end
end

function Tag:InitPlayer(Ply, Reset)
    if (not Reset) then

        -- init new array for this player:
        self.players[Ply] = {
            score = 0,
            --
            -- Store a copy of this players name (store once, access whenever)
            name = get_var(Ply, "$name")
        }
        return
        --


        -- Player disconnected. Pick a new tagger:
    elseif (self:IsTagger(Ply) and self.new_tagger_on_quit) then
        self:PickNewTagger()
        --


        -- Reset tagger variables:
        -- Tagger disconnected (only if setting "new_tagger_on_quit" is false)
    elseif (self:IsTagger(Ply)) then
        self:Stop()
    end
    --


    -- Clear the array for this player (garbage collection)
    self.players[Ply] = nil
end

function OnPlayerJoin(Ply)
    Tag:InitPlayer(Ply, false)
end

function OnPlayerSpawn(Ply)
    if (Tag.players[Ply]) then
        Tag.players[Ply].timer = 0
        Tag:SetSpeed(Ply)
    end
end

function OnPlayerQuit(Ply)
    Tag:InitPlayer(Ply, true)
end

-- This function is responsible for setting the nav marker
-- above the taggers head:
function Tag:SetNav()
    for i, _ in pairs(self.players) do

        -- Get static memory address of each player:
        local p1 = get_player(i)

        -- Set slayer target indicator:
        if (i ~= self.tagger) and player_alive(i) then
            write_word(p1 + 0x88, to_real_index(self.tagger))
        else
            write_word(p1 + 0x88, to_real_index(i))
        end
        ---
    end
end

function Tag:Start()
    self.init = true
end

function Tag:Stop()
    self.tagger = nil
    self.init = false
    self.delta_time = 0
end

function Tag:SetSpeed(Ply, Reduce)

    -- tagger --
    if (self:IsTagger(Ply)) then
        if (not Reduce) then
            execute_command("s " .. Ply .. " " .. self.speed[1])
        else
            self.players[Ply].speed_timer = 0
            execute_command("s " .. Ply .. " " .. self.speed[1] - self.speed_reduction)
        end
        return
    end

    -- runner --
    execute_command("s " .. Ply .. " " .. self.speed[2])
end

-- This function is called every 1/30th of a second:
function Tag:OnTick()
    if (self.init) then

        -- Turn timer logic:
        self.delta_time = self.delta_time + time_scale
        self:SetNav()
        if (self.delta_time >= self.turn_timer) then
            self:PickNewTagger()
            return
        end
        --
        --


        -- Speed reduction timer and scoring logic:
        --
        for i, v in pairs(self.players) do

            if player_alive(i) then

                -- Reduce tagger speed if they are being shot at:
                --
                local case = (self:IsTagger(i) and self.tagger_speed_reduce)
                if (case and v.speed_timer) then
                    v.speed_timer = v.speed_timer + time_scale
                    if (v.speed_timer >= self.speed_reduce_interval) then
                        v.speed_timer = nil
                        self:SetSpeed(i)
                    end
                end
                --
                --

                --
                if (self.score_limit and not self:IsTagger(i)) then

                    v.timer = v.timer + time_scale

                    -- Increment runner score by "points_per"
                    --
                    if (v.timer >= self.runner_time) then
                        v.score = v.score + self.points_per
                        v.timer = 0
                        execute_command("score " .. i .. " " .. v.score)
                    end

                    -- Check if we need to end the game:
                    --
                    if (v.score >= self.score_limit) then
                        self:Say(v.name .. " won the game!")
                        execute_command("sv_map_next")
                    end
                    --
                end
            end
        end
    end
end

function OnPlayerDeath(V, K)
    local k, v = tonumber(K), tonumber(V)

    if (k > 0) then

        -- Deduct 1x score point for this kill
        -- Only way to score (by design) is to accumulate points as a runner!
        --
        if (self.score_limit) then
            local score = tonumber(get_var(k, "$score"))
            score = score - 1
            if (score < 0) then
                score = 0
            end
            execute_command("score " .. k .. " " .. score)
        end

        -- Tagger died, select new tagger:
        --
        if (Tag.new_tagger_on_death) then
            return Tag:IsTagger(v) and Tag:PickNewTagger()
        end
    end
end

-- Returns MetaID of tag path:
--
local function GetTag(Type, Name)
    local ObjTag = lookup_tag(Type, Name)
    return (ObjTag ~= 0 and read_dword(ObjTag + 0xC)) or nil
end

-- Checks if the Damage MetaID matches MetaID of melee tag path
--
function Tag:IsMelee(MetaID)
    for tag, enabled in pairs(self.melee) do
        if (enabled) then
            local meta = GetTag("jpt!", tag)
            if (meta and MetaID == meta) then
                return true
            end
        end
    end
    return false
end

function Tag:OnDamage(Victim, Causer, MetaID, _, _)

    -- Check if PvP and not suicide:
    if (Causer > 0 and Victim ~= Causer) then

        if (self.players[Causer]) then

            -- Get victim/causer names:
            local cname = self.players[Causer].name
            local vname = self.players[Victim].name

            -- Player has initialised a new game of tag (set initial tagger):
            --
            if (not self.init and self:IsMelee(MetaID)) then

                local t = self.on_game_start
                for i = 1, #t do
                    self:Say(gsub(gsub(t[i],
                            "%%cname%%", cname),
                            "%%vname%%", vname))
                end
                self:SetTagger(Victim)

                -- Increment player score:
                local score = tonumber(get_var(Causer, "$score"))
                score = score + self.points_on_tag
                execute_command("score " .. Causer .. " " .. score)
                --


                -- Game already running, player was tagged (set new tagger):
                --
            elseif (self:IsTagger(Causer) and self:IsMelee(MetaID)) then

                local str = gsub(gsub(self.on_tag,
                        "%%victim%%", vname),
                        "%%tagger%%", cname)
                self:Say(str)
                self:Stop()
                self.players[Causer].it = false
                self.players[Causer].speed_timer = nil
                self:SetTagger(Victim)

                -- Increment player score:
                local score = tonumber(get_var(Causer, "$score"))
                score = score + self.points_on_tag
                execute_command("score " .. Causer .. " " .. score)
                --

                -- Slow the speed of the tagger when shot at:
                --
            elseif (self:IsTagger(Victim) and self.tagger_speed_reduce) then
                self:SetSpeed(Victim, true)
            end
        end
    end
end

-- Temporarily removes the message prefix and then
-- restores it once we have finished relaying "MSG" to the server:
function Tag:Say(MSG)
    cprint(MSG)
    execute_command("msg_prefix \"\"")
    say_all(MSG)
    execute_command("msg_prefix \" " .. self.server_prefix .. "\"")
end

function GameStart()
    return Tag:Init()
end

function GameEnd()
    return Tag:Init()
end

function OnTick()
    return Tag:OnTick()
end

function OnDamage(V, C, M, _, _)
    return Tag:OnDamage(V, C, M, _, _)
end

function OnScriptUnload()
    -- N/A
end

-- Error Logging --
local function WriteLog(str)
    local file = io.open("Tag.errors", "a+")
    if (file) then
        file:write(str .. "\n")
        file:close()
    end
end

-- In the event of an error, the script will trigger
-- these two functions: OnError(), report()
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
    WriteLog("Script Version: " .. script_version)
    WriteLog(Error)
    WriteLog(StackTrace)
    WriteLog("\n")
end

-- This function will return a string with a traceback of the stack call...
-- and call function 'report' after 50 milliseconds.
function OnError(Error)
    timer(50, "report", debug.traceback(), Error)
end
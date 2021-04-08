--[[
--=====================================================================================================--
Script Name: Tag (v1.0), for SAPP (PC & CE)
Description: Tag, you're it!

             This script brings you TAG, a game involving two or more players.
             A game of tag is initiated by meleeing anyone.
             The target player will become "it" (the tagger).

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
--=====================================================================================================--
]]--

local Tag = {

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
    -- Set to nil to disabled the score limit
    score_limit = 10000,

    -- Runners will accumulate points while.
    -- Add "points_per_interval" points per "runner_time" seconds
    runner_time = 5,
    points_per = 100,
    --

    -- {tagger speed, runner speed)
    speed = { 1.5, 1 },

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished
    server_prefix = "**SAPP**"
    --
}

local gsub = string.gsub
local time_scale = 1 / 30

-- Used for error reporting; See function report()
local script_version = 1.0

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

        if (self.score_limit) then
            execute_command("scorelimit " .. self.score_limit)
        end

        Tag.players = { }
        Tag:Stop()

        Tag.melee = {
            { "jpt!", "weapons\\flag\\melee" },
            { "jpt!", "weapons\\ball\\melee" },
            { "jpt!", "weapons\\pistol\\melee" },
            { "jpt!", "weapons\\needler\\melee" },
            { "jpt!", "weapons\\shotgun\\melee" },
            { "jpt!", "weapons\\flamethrower\\melee" },
            { "jpt!", "weapons\\sniper rifle\\melee" },
            { "jpt!", "weapons\\plasma rifle\\melee" },
            { "jpt!", "weapons\\plasma pistol\\melee" },
            { "jpt!", "weapons\\assault rifle\\melee" },
            { "jpt!", "weapons\\rocket launcher\\melee" },
            { "jpt!", "weapons\\plasma_cannon\\effects\\plasma_cannon_melee" },
        }
    end
end

function Tag:SetTagger(Tagger)
    self.it = Tagger
    self.players[Tagger].it = true
    self:Start()
end

function Tag:PickNewTagger()

    self:Stop()

    local req = self.players_required
    if tonumber(get_var(0, "$pn")) < req then
        return
    end

    -- set candidates:
    local t, excluded = { }
    for i, v in pairs(self.players) do
        if (not v.it and i ~= excluded) then
            t[#t + 1] = i
        elseif (v.it) then
            excluded = i
            v.it = false
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
    end
end

function Tag:InitPlayer(Ply, Reset)
    if (not Reset) then

        -- init new array for this player:
        self.players[Ply] = {
            score = 0,
            it = false,
            name = get_var(Ply, "$name")
        }
        return
        --


        -- Player disconnected. Pick a new tagger:
    elseif (self.players[Ply].it and self.new_tagger_on_quit) then
        self:PickNewTagger()
        --


        -- Tagger disconnected (setting: new_tagger_on_quit is false)
        -- Reset tagger variables:
    elseif (self.players[Ply].it) then
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
    Tag.players[Ply].timer = 0
end

function OnPlayerQuit(Ply)
    Tag:InitPlayer(Ply, true)
end

-- This function is responsible for setting the nav marker
-- above the taggers head:
function Tag:SetNav()
    for i, _ in pairs(self.players) do

        local p1 = get_player(i)
        local p2 = get_player(self.it)

        if (p1 ~= p2) then
            -- Set slayer target indicator for tagger:
            write_word(p1 + 0x88, to_real_index(self.it))
        else
            write_word(p1 + 0x88, to_real_index(i))
        end
    end
end

function Tag:Start()
    self.init = true
end

function Tag:Stop()
    self.it = nil
    self.delta_time = 0
    self.init = false
end

function Tag:SetSpeed(Ply)
    if (self.players[Ply].it) then
        -- tagger:
        execute_command("s " .. Ply .. " " .. self.speed[1])
    else
        -- runner:
        execute_command("s " .. Ply .. " " .. self.speed[2])
    end
end

function Tag:OnTick()
    if (self.init) then

        self.delta_time = self.delta_time + time_scale
        self:SetNav()

        if (self.delta_time >= self.turn_timer) then
            self:PickNewTagger()
            return
        end

        for i, v in pairs(self.players) do

            -- Calling this every 1/30th second is probably not the best thing!
            self:SetSpeed(i)
            --

            -- loop through all players who are not "it"
            local case = (self.score_limit ~= nil and v.score >= self.score_limit)
            if (case and player_alive(i) and not v.it) then

                v.timer = v.timer + time_scale

                -- Increment their score by "points_per"
                if (v.timer >= self.runner_time) then
                    v.score = v.score + self.points_per
                    v.timer = 0
                    execute_command("score " .. i .. " " .. v.score)
                end

                -- Check if we need to end the game:
                if (v.score >= self.score_limit) then
                    self:Say(v.name .. " won the game!")
                    execute_command("sv_map_next")
                end
                --
            end
        end
    end
end

function OnPlayerDeath(V, K)
    local k, v = tonumber(K), tonumber(V)

    if (k > 0) then

        local score = tonumber(get_var(k, "$score"))
        score = score - 1
        execute_command("score " .. k .. " " .. score)

        if (Tag.new_tagger_on_death) then
            return Tag.players[v].it and Tag:PickNewTagger()
        end
    end
end

local function GetTag(Type, Name)
    local ObjTag = lookup_tag(Type, Name)
    return (ObjTag ~= 0 and read_dword(ObjTag + 0xC)) or nil
end

function Tag:IsMelee(MetaID)
    for _, v in pairs(self.melee) do
        if (MetaID == GetTag(v[1], v[2])) then
            return true
        end
    end
    return false
end

function Tag:OnDamage(Victim, Causer, MetaID, _, _)
    if (Causer > 0 and Victim ~= Causer) then

        local cname = self.players[Causer].name
        local vname = self.players[Victim].name

        -- Player has initialised a new game of tag:
        if (not self.init and self:IsMelee(MetaID)) then

            local t = self.on_game_start
            for i = 1, #t do
                self:Say(gsub(gsub(t[i],
                        "%%cname%%", cname),
                        "%%vname%%", vname))
            end
            self:SetTagger(Victim)

            -- Game already running, player was tagged:
        elseif (self.players[Causer].it and self:IsMelee(MetaID)) then

            local str = gsub(gsub(self.on_tag,
                    "%%victim%%", vname),
                    "%%tagger%%", cname)
            self:Say(str)

            self:Stop()
            self.players[Causer].it = false
            self:SetTagger(Victim)
        end
    end
end

function Tag:Say(MSG)
    execute_command("msg_prefix \"\"")
    say_all(MSG)
    cprint(MSG)
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

local function WriteLog(str)
    local file = io.open("Tag.errors", "a+")
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
    WriteLog("Script Version: " .. script_version)
    WriteLog(Error)
    WriteLog(StackTrace)
    WriteLog("\n")
end

-- This function will return a string with a traceback of the stack call...
-- ...and call function 'report' after 50 milliseconds.
function OnError(Error)
    timer(50, "report", debug.traceback(), Error)
end
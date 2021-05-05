--[[
--=====================================================================================================--
Script Name: Map Vote System, for SAPP (PC & CE)
Description: This script is a drop-in replacement for SAPP's built-in voting system.

             - features -
             1). Cast and re-cast your vote.
             2). Ability to show more than 6 map vote options.
             3). Configurable messages.
             4). Full control over script timers:
                 * Time until map votes are shown (after game ends).
                 * Time until votes are calculated (after game ends).
                 * Time until until map cycle (after PGCR screen is shown)

             - notes -
             1). You will need to import your map vote settings from mapvote.txt
             2). This script will disable SAPP's built-in map vote setting automatically.
             3). Map skipping will still work and the skip ratio is defined in the config.
             ----------------------------------------------------------------------------------------

             See config section for more information.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration Starts --
local MapVote = {

    -- Map skip setting:
    --
    -- map_skip is the percentage of people needed to skip the map.
    -- Set to 0 to disable map skipping entirely.
    -- Default: 60%
    map_skip = 60,
    --

    -- Most messages are configurable (edit them here):
    messages = {

        -- Message omitted when player votes for map:
        [1] = "%name% voted for [#%id%] %map% %msg%",
        --

        -- Message omitted when player re-votes (updates):
        [2] = "%name% updated their vote to [#%id%] %map% %msg%",
        --

        -- Map vote option format:
        [3] = "[%id%] %map% %msg%",
        --

        -- Map vote calculation messages:
        [4] = {
            "%map% %msg% won with %votes% vote%s%",
            "No Votes! Picking %map% %msg%..."
        }
        --
    },

    -- How many votes options to display when the game ends?
    amount_to_show = 5,
    --

    ----------------------------------------------------------------------------------------
    -- I do not recommend changing these values:

    -- Time (in seconds) until we show map votes (after game ends)
    time_until_show = 7,

    -- Time (in seconds) until votes are calculated (after game ends):
    time_until_tally = 13,

    -- Time (in seconds) until map cycle (after PGCR screen is shown):
    map_cycle_timeout = 13,

    -- Vote options will be re-shown every "re_show_interval" seconds until timer reaches "time_until_tally"
    re_show_interval = 5,
    ----------------------------------------------------------------------------------------

    maps = {

        --[[

        =============================
        - TECHNICAL NOTES -
        =============================

        1). Configure the map votes in the following format: {map name, game mode, message}

        2). Map vote options will be seen in-game like this:

            Examples:
            [1] bloodgulch (ctf)
            [2] deathisland (ctf)
            [3] sidewinder (ctf)
            [4] icefields (ctf)
            [5] infinity (ctf)


        3). You can define custom game modes like this:

            { "bloodgulch", "MyCustomKing", "(Custom King)" },
            Example #2 (as seen in-game): [1] bloodgulch (Custom King)

        ]]

        --======================================--
        -- CONFIGURE MAP VOTES HERE --
        --======================================--
        { "bloodgulch", "ctf", "(ctf)" },
        { "deathisland", "ctf", "(ctf)" },
        { "sidewinder", "ctf", "(ctf)" },
        { "icefields", "ctf", "(ctf)" },
        { "infinity", "ctf", "(ctf)" },

        { "timberland", "ctf", "(ctf)" },
        { "dangercanyon", "ctf", "(ctf)" },
        { "beavercreek", "ctf", "(ctf)" },
        { "boardingaction", "ctf", "(ctf)" },
        { "carousel", "ctf", "(ctf)" },

        { "chillout", "ctf", "(ctf)" },
        { "damnation", "ctf", "(ctf)" },
        { "gephyrophobia", "ctf", "(ctf)" },
        { "hangemhigh", "ctf", "(ctf)" },
        { "longest", "ctf", "(ctf)" },

        { "prisoner", "ctf", "(ctf)" },
        { "putput", "ctf", "(ctf)" },
        { "ratrace", "ctf", "(ctf)" },
        { "wizard", "ctf", "(ctf)" },
    },

    -- A message relay function temporarily removes the server prefix
    -- and will restore it to this when the relay is finished:
    server_prefix = "**SAPP**"
}
-- Configuration Ends --

local script_version = 1.3
local start_index, end_index

function OnScriptLoad()

    -- register needed event callbacks:
    register_callback(cb["EVENT_CHAT"], "OnVote")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")

    OnGameStart(true)
end

function MapVote:OnStart(reset)

    if (reset == true) then
        self:ResetVoteIndex()
    end

    self.game_started = false
    if (get_var(0, "$gt") ~= "n/a") then
        self.results = { }
        self:SetupTimer(true)
        execute_command("mapvote false")
        execute_command("map_skip " .. self.map_skip)
        execute_command("sv_mapcycle_timeout " .. self.map_cycle_timeout)
    end
end

function OnGameEnd()
    MapVote:Show()
end

-- Function used for printing messages:
function MapVote:Respond(Ply, Msg)
    if (not Ply) then
        execute_command('msg_prefix ""')
        say_all(Msg)
        execute_command('msg_prefix "' .. self.server_prefix .. ' "')
        cprint(Msg)
    else
        rprint(Ply, Msg)
    end
end

-- Sets initial values (doubles as reset function)
function MapVote:SetupTimer(game_started)
    self.timer = 0
    self.init = true
    self.show = false
    self.can_vote = false
    self.game_started = (game_started)
end

-- Picks a random vote table from self.results:
function MapVote:PickRandomMap()
    local n = rand(1, #self.results + 1)
    local vote = self.results[n]
    return {
        vote[1],
        vote[2],
        vote[3],
        #vote[4]
    }
end

local function Plural(n)
    return (n > 1 and "s") or ""
end

-- Sorts self.results by vote count:
-- todo: If two (or more) vote options have equal votes then pick one randomly.
function MapVote:SortResults()

    local results = { }
    for _, v in pairs(self.results) do
        if (#v[4] > 0) then
            table.insert(results, { v[1], v[2], v[3], #v[4] })
        end
    end

    -- print("sorting results...")
    table.sort(results, function(a, b)
        return a[4] > b[4]
    end)
    return results
end

function MapVote:Timer()

    if (not self.game_started) then

        self.timer = self.timer + 1

        -- print(self.timer)

        -- calculate votes --
        if (self.timer == self.time_until_tally) then

            -- print("calculating results")

            local results = self:SortResults()
            local vote = results[1]

            vote = vote or self:PickRandomMap()
            self.results = vote
            self.can_vote = false

            -- display winner --
            local words = {
                ["%%map%%"] = vote[1],
                ["%%mode%%"] = vote[2],
                ["%%msg%%"] = vote[3],
                ["%%votes%%"] = vote[4],
                ["%%s%%"] = Plural(vote[4])
            }

            local str = (vote[4] > 0 and self.messages[4][1] or self.messages[4][2])
            for k, v in pairs(words) do
                str = str:gsub(k, v)
            end
            self:Respond(_, str)
            --

            -- pick new map --
            execute_command("map " .. self.results[1] .. " " .. self.results[2])
            return false
        end

        -- show vote options --
        -----------------------

        -- show initial vote options --
        local case1 = (self.timer == self.time_until_show and self.init)

        -- re-show vote options every 5 seconds until timer reaches self.time_until_tally
        local case2 = (not self.init and self.timer < self.time_until_tally)

        -- Determine if we need to show vote options:
        if case1 or (case2 and self.timer % self.re_show_interval == 0) then
            self.show = true
        end

        if (self.show) then

            -- print("showing vote options")
            self.show = false
            self.can_vote = true
            if (self.init) then
                self.init, self.timer = false, 0
            end

            -- Iterate over and print results array data:
            for i = 1, 16 do
                if player_present(i) then
                    for j, R in pairs(self.results) do

                        local words = {

                            -- vote id:
                            ["%%id%%"] = j,

                            -- map:
                            ["%%map%%"] = R[1],

                            -- mode:
                            ["%%mode%%"] = R[2],

                            -- mode message:
                            ["%%msg%%"] = R[3],

                            -- votes count:
                            ["%%votes%%"] = #R[4]
                        }

                        local str = self.messages[3]
                        for k, v in pairs(words) do
                            str = str:gsub(k, v)
                        end

                        self:Respond(i, str)
                    end
                end
            end
        end
    end

    return true
end

function MapVote:Show()

    local finished = (not self.maps[end_index + 1] and true) or false
    if (finished) then
        self:ResetVoteIndex(true)
    end

    -- Determine what vote options to display:
    local index = 1
    for i = start_index, end_index do
        if (self.maps[i]) then

            -- map [string], mode [string], mode message [string], votes [table]
            self.results[index] = {

                -- map name:
                self.maps[i][1],

                -- mode:
                self.maps[i][2],

                -- mode message:
                self.maps[i][3],

                -- array of votes:
                {}
            }
            index = index + 1
        end
    end

    -- Increment vote option start & end indexes:
    start_index = (end_index + 1)
    end_index = (start_index + self.amount_to_show - 1)

    self:SetupTimer(false)

    -- Initialise vote timer:
    timer(1000 * 1, "GameTick")
end

function MapVote:Vote(Ply, MSG, _, _)
    if (not self.game_started) then

        local Args = { }
        for VoteID in MSG:gmatch("([^%s]+)") do
            Args[#Args + 1] = VoteID:lower()
        end

        if (#Args > 0) then
            local vid = tonumber(Args[1]:match("%d+"))
            if (vid and self.timer < self.time_until_tally) then
                if (not self.can_vote) then
                    local time = (self.time_until_show - self.timer)
                    self:Respond(Ply, "Please wait " .. time .. " second" .. Plural(time))
                elseif (self.results[vid]) then
                    self:AddVote(Ply, vid)
                else
                    self:Respond(Ply, "Invalid map vote id! Please type a number between 1 & " .. self.amount_to_show)
                end
            else
                return true
            end
        end
        return false
    end
end

function MapVote:AddVote(Ply, VID)

    local str = self.messages[1] -- first time vote message
    for _, Result in pairs(self.results) do
        -- iterate through votes array:
        if (Result[4]) then
            for k, PID in pairs(Result[4]) do

                -- Remove all votes for this player.
                -- This ensures player can only vote for 1 map at a time.
                if (PID == Ply) then
                    str = self.messages[2] -- re-vote message
                    Result[4][k] = nil
                end
            end
        end
    end
    -- Add current vote id:
    table.insert(self.results[VID][4], Ply)

    local words = {
        -- vote id:
        ["%%id%%"] = VID,

        -- player name:
        ["%%name%%"] = get_var(Ply, "$name"),

        -- map:
        ["%%map%%"] = self.results[VID][1],

        -- mode:
        ["%%mode%%"] = self.results[VID][2],

        -- mode message:
        ["%%msg%%"] = self.results[VID][3],

        -- votes array:
        ["%%votes%%"] = #self.results[VID][4],
    }

    for k, v in pairs(words) do
        str = str:gsub(k, v)
    end

    self:Respond(_, str)
end

-- Sets initial start & end indexes for self.maps:
-- Also reverses the order of self.maps once all groups of vote options have been shown.
function MapVote:ResetVoteIndex(Shuffle)

    if (Shuffle) then
        local t = { }
        for i = #self.maps, 1, -1 do
            t[#t + 1] = self.maps[i]
        end
        self.maps = t
    end

    start_index = 1
    end_index = self.amount_to_show
end

function OnVote(P, M)
    return MapVote:Vote(P, M)
end
function GameTick()
    return MapVote:Timer()
end
function OnGameStart(reset)
    return MapVote:OnStart(reset)
end

local function WriteLog(str)
    local file = io.open("Map Vote System (errors).log", "a+")
    if (file) then
        file:write(str .. "\n")
        file:close()
    end
end

function OnError(Error)

    local log = {
        { os.date("[%H:%M:%S - %d/%m/%Y]"), true, 12 },
        { Error, false, 12 },
        { debug.traceback(), true, 12 },
        { "--------------------------------------------------------", true, 5 },
        { "Please report this error on github:", true, 7 },
        { "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", true, 7 },
        { "Script Version: " .. script_version, true, 7 },
        { "--------------------------------------------------------", true, 5 }
    }

    for _, v in pairs(log) do
        WriteLog(v[1])
        if (v[2]) then
            cprint(v[1], v[3])
        end
    end

    WriteLog("\n")
end

-- for a future update --
return MapVote
--
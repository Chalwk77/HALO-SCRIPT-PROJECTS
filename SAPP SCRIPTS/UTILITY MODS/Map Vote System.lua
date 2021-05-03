--[[
--=====================================================================================================--
Script Name: Map Vote System, for SAPP (PC & CE)
Description: This script is a drop-in replacement for SAPP's built-in voting system.

             - features -
             1). Cast and re-cast your vote!
             2). Ability to show more than 6 map vote options.
             3). Configurable messages
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

-- config starts --
local MapVote = {

    -- Map skip setting:
    -- Enable the use of the skip command, skipping when a certain
    -- percentage of people want the game to be skipped.
    -- Set to 0 to disable map skipping entirely.
    -- Default: 60% current server population required to vote.
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
    time_until_tally = 10,

    -- Time (in seconds) until map cycle (after PGCR screen is shown)
    map_cycle_timeout = 20,
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


        4). Vote options appear in groups of 5 and do not repeat until all groups have been shown:
            Suppose we have an array of 10 map vote options (see below), and we configure this array so that we
            only display a maximum of 5 map vote options; At the end of game 1, it will display map vote options 1 through 5.
            At the end of game 2, it will show options 6 through 10 (by design).
            Once all groups have been shown, the cycle repeats; Beginning at group 1 (the first 5 maps).
            The number of maps shown can be configured (see setting: "amount_to_show").
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
-- config ends --

api_version = "1.12.0.0"

local start_index, end_index

function OnScriptLoad()
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

function MapVote:Respond(Ply, Msg)
    execute_command("msg_prefix \"\"")
    if (not Ply) then
        say_all(Msg)
        cprint(Msg)
    else
        rprint(Ply, Msg)
    end
    execute_command("msg_prefix \"" .. self.server_prefix .. "\"")
end

function MapVote:SetupTimer(game_started)
    self.timer = 0
    self.init = true
    self.show = false
    self.can_vote = false
    self.game_started = (game_started)
end

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

        -- show initial vote options --
        local case1 = (self.timer == self.time_until_show and self.init)

        -- re-show vote options every 5 seconds until timer reaches self.time_until_tally
        local case2 = (not self.init and self.timer < self.time_until_tally)

        if case1 or (case2 and self.timer % 5 == 0) then
            self.show = true
        end

        if (self.show) then
            -- print("showing vote options")
            self.show = false
            self.can_vote = true
            if (self.init) then
                self.init, self.timer = false, 0
            end

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

    -- results:
    -- map [string], mode [string], mode message [string], votes [table]

    local index, found = 1
    for i = start_index, end_index do
        if (self.maps[i]) then
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
            found = (self.maps[i + 1] and true) or false
        end
    end

    if not (found) then
        self:ResetVoteIndex()
    else
        start_index = (end_index + 1)
        end_index = (start_index + self.amount_to_show - 1)
    end

    self:SetupTimer(false)
    timer(1000 * 1, "GameTick")
end

local function STRSplit(STR)
    local Args = { }
    for String in STR:gmatch("([^%s]+)") do
        Args[#Args + 1] = String:lower()
    end
    return Args
end

function MapVote:Vote(Ply, MSG, _, _)
    if (not self.game_started) then
        local Args = STRSplit(MSG)
        if (Args) then
            local vid = tonumber(Args[1]:match("%d+"))
            if (vid and self.timer < self.time_until_tally) then
                if (not self.can_vote) then
                    local time = (self.time_until_show - self.timer)
                    self:Respond(Ply, "Please wait " .. time .. " second" .. Plural(time))
                elseif (self.results[vid]) then
                    self:AddVote(Ply, vid)
                else
                    rprint(Ply, "Invalid map vote id!")
                end
            else
                return true
            end
        end
        return false
    end
end

function MapVote:AddVote(Ply, VID)

    local str = self.messages[1] -- voted
    for _, Result in pairs(self.results) do
        -- iterate through votes array:
        if (Result[4]) then
            for k, PID in pairs(Result[4]) do
                if (PID == Ply) then
                    str = self.messages[2] -- re-voted
                    Result[4][k] = nil -- remove vote
                end
            end
        end
    end
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

function MapVote:ResetVoteIndex()
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

return MapVote
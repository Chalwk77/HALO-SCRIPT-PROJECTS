--[[
--=====================================================================================================--
Script Name: Map Vote System (v1.0), for SAPP (PC & CE)
Description: N/A

IMPORTANT: SAPP's builtin map voting system must be disabled before using this script.

[!] [!] NOT READY FOR DOWNLOAD!

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local mapvote = { }
-- mapvote config starts --

-- Players needed to vote:
mapvote.players_needed = 1

-- Map Cycle timeout (In Seconds):
mapvote.timeout = 20 -- Do not set to 0!

-- Voting Options screen alignment:
mapvote.alignment = "l"  -- Left = l, Right = r, Center = c, Tab: t

-- Number of Map Vote entries to display per page:
mapvote.maxresults = 5

-- If enabled, players will who are level 'mapvote.extrapower' (or greater) 
-- will have extra power over their vote and will add 'mapvote.extra' votes to their selection.
mapvote.extra_vote = false
mapvote.extrapower = 4
mapvote.extra = 2

--==============================================================--
-- WIP !!

-- During Voting, Chat Messages will fade after this many seconds.
mapvote.message_fade = 7

-- Total number of chat messages allowed on screen at once.
-- The 5th message will cause one of the chat message to be cleared from the screen.
mapvote.max_chat_messages = 5
--==============================================================--

-- To navigate between pages, type 'mapvote.next_page' or 'mapvote.previous_page'.
mapvote.next_page = "n"
mapvote.previous_page = "p"
--

-- Global Server Prefix:
-- Several functions temporarily removes the ** SERVER ** prefix when it announces messges.
-- The prefix will be restored to 'mapvote.serverprefix' when the relay has finished.
mapvote.serverprefix = "** SERVER ** " -- Leave a space after the last asterisk.
--

mapvote.messages = {
    on_vote = "%name% voted for [ %mapname% ]  -  [ %gametype% ]  -  Votes: %votes%",
    already_voted = "You have already voted!",
    on_win_vote = "%mapname% [ %gametype% ] won the vote ",
    no_one_voted = "No votes were processed! Chosing random map in (%seconds%) seconds",
}

mapvote.maps = {

    -- [MAP NAME] - {AVAILABLE GAMETYPES}
    -- You can specify on a per-map basis what gametypes are available.

    ["sidewinder"] = { "ctf", "slayer", "oddball" },
    ["ratrace"] = { "ctf", "slayer" },
    ["bloodgulch"] = { "ctf", "slayer", "oddball" },
    ["beavercreek"] = { "ctf", "slayer", "oddball" },
    ["boardingaction"] = { "ctf", "slayer" },
    ["carousel"] = { "ctf", "slayer" },
    ["dangercanyon"] = { "ctf", "slayer" },
    ["deathisland"] = { "ctf", "slayer" },
    ["gephyrophobia"] = { "ctf", "slayer" },
    ["icefields"] = { "ctf", "slayer", "oddball" },
    ["infinity"] = { "ctf", "slayer" },
    ["timberland"] = { "ctf", "slayer" },
    ["hangemhigh"] = { "ctf", "slayer", "oddball"},
    ["ratrace"] = { "ctf", "slayer" },
    ["damnation"] = { "ctf", "slayer" },
    ["putput"] = { "ctf", "slayer" },
    ["prisoner"] = { "ctf", "slayer" },
    ["wizard"] = { "ctf", "slayer" },
    ["longest"] = { "ctf", "slayer", "oddball" },

    -- Repeat the structure to add your own maps and gametypes.
}

-- mapvote config ends --

local results, cur_page, votes = { }, { }, { }
local start_page, map_count, total_pages = 1, 0, 0
local vote_options, has_voted = { }, { }

local sub, gsub, find = string.sub, string.gsub, string.find
local match, gmatch = string.match, string.gmatch
local upper, lower = string.upper, string.lower
local floor = math.floor
local concat = table.concat
local global_message = { }

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
end

local Say = function(p, message)
    if (p) and (message) then
        if (type(message) == "table") then
            for i = 1, #message do
                if (message[i] ~= nil) then
                    rprint(p, "|" .. mapvote.alignment .. " " .. message[i])
                end
            end
        else
            rprint(p, "|" .. mapvote.alignment .. " " .. message)
        end
    end
end

-- Receives a string and executes SAPP function 'say_all' without the **SERVER** prefix.
-- Restores the prefix when relay is done.
local SayAll = function(Message)
    if (Message) then
        execute_command("msg_prefix \"\"")
        say_all(Message) -- Sends a global message.
        execute_command("msg_prefix \" " .. mapvote.serverprefix .. "\"")
    end
end

local getPage = function(page)
    local page = tonumber(page) or nil

    if (page == nil) then
        page = 1
    end

    local max_results = mapvote.maxresults
    local start = (max_results) * page
    local startpage = (start - max_results + 1)
    local endpage = start

    return startpage, endpage
end

local getPageCount = function(total, max_results)
    local pages = total / (max_results)
    if ((pages) ~= floor(pages)) then
        pages = floor(pages) + 1
    end
    return pages
end

local function spacing(n, sep)
    sep = sep or ""
    local String = ""
    for i = 1, n do
        if i == floor(n / 2) then
            String = String .. ""
        end
        String = String .. " "
    end
    return sep .. String
end

-- Receives number - determines whether to pluralize.
-- Returns string 's' if the input is greater than 1.
local function getChar(input)
    local char = ""
    if (tonumber(input) > 1) then
        char = "s"
    elseif (tonumber(input) <= 1) then
        char = ""
    end
    return char
end

local function hasExtraVotePower(p)
    local level = tonumber(get_var(p, "$lvl"))
    if (level >= mapvote.extrapower) then
        return true
    end
end

function OnGameStart()
    execute_command("sv_mapcycle_timeout " .. mapvote.timeout)

    -- Clear all arrays and counts
    results, votes, map_count = { }, { }, 0
    vote_options = { }

    mapvote.timer, mapvote.start = { }, { }
    mapvote.timer, mapvote.start = { }, { }

    for k, _ in pairs(mapvote.maps) do
        results[#results + 1] = k
        map_count = map_count + 1
    end

    for i = 1, #results do
        if (results[i]) then

            local mapname = results[i]
            local gametype = mapvote.maps[mapname]

            for j = 1, #gametype do
                if (gametype[j] ~= nil) then
                    votes[#votes + 1] = {
                        [mapname] = {
                            [gametype[j]] = { votes = 0 }
                        }
                    }
                end
            end
        end
    end
end

local getRandomMap = function()
    local map_table = mapvote.maps

    local count = 0
    for _, _ in pairs(map_table) do
        count = count + 1
    end

    math.randomseed(os.time())
    local x = math.random(1, count)
    for mapname, _ in pairs(map_table) do
        local gametype_table = votes[x][mapname]
        if (gametype_table ~= nil) then
            for gametype, _ in pairs(gametype_table) do
                local map = mapname .. " - " .. gametype
                return mapname, gametype
            end
        end
    end
end

function mapvote:calculate_votes()
    
    global_message = nil
    
    local final_results = { }

    local map_table = mapvote.maps
    for mapname, _ in pairs(map_table) do
        -- mapname = mapname string
        for index, _ in pairs(votes) do
            local gametype_table = votes[index][mapname]
            if (gametype_table ~= nil) then
                for gametype, _ in pairs(gametype_table) do
                    -- gametype = gametype string
                    local votes = gametype_table[gametype].votes
                    if (votes ~= nil) and (votes > 0) then
                        local map = (votes .. "|" .. mapname .. "|" .. gametype)
                        final_results[#final_results + 1] = map
                    end
                end
            end
        end
    end

    local messages = mapvote.messages
    if (#final_results > 0) then
        table.sort(final_results)
        local result = {}
        result[#result + 1] = final_results[#final_results]
        if (#result > 0) then
            for _, v in pairs(result) do
                local data = stringSplit(v, "|")
                if (data) then
                    local result, i = { }, 1
                    for j = 1, 3 do
                        if (data[j] ~= nil) then
                            result[i] = data[j]
                            i = i + 1
                        end
                    end
                    if (result ~= nil) then
                        local mapname, gametype = result[2], result[3]
                        execute_command("map " .. mapname .. " " .. gametype)

                        local msg = gsub(gsub(messages.on_win_vote, "%%mapname%%", mapname), "%%gametype%%", gametype)
                        SayAll(msg)
                        cprint(msg, 2+8)
                        break
                    end
                end
            end
        end
    else
        -- RANDOM MAP SELECTION ...

        local delay = 3
        function delay_map_selection()
            local map, gametype = select(1, getRandomMap()), select(2, getRandomMap())
            execute_command("map " .. map .. " " .. gametype)

            local msg = map .. " [ " .. gametype .. " ] has been randomly selected."
            SayAll(msg)
            cprint(msg, 2+8)
        end
        timer(1000 * delay, "delay_map_selection")

        local msg = gsub(messages.no_one_voted, "%%seconds%%", delay)
        SayAll(msg)
        cprint(msg, 2+8)
    end
end

function delay_clear_chat()
    cls(0, 25, true, "chat")
end

function OnGameEnd()
    if (tonumber(get_var(0, "$pn")) >= mapvote.players_needed) then
        total_pages = getPageCount(map_count, mapvote.maxresults)
        
        global_message = { }
        global_message.timer = { }
        global_message.timer[0] = 0

        -- Register a hook into SAPP's chat event.
        register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
        -- Register a hook into SAPP's tick event.
        register_callback(cb['EVENT_TICK'], "OnTick")
        -- Begin voting process.
        timer(50, "delay_clear_chat")
        mapvote:begin()
    end
end

function mapvote:begin()
    for i = 1, 16 do
        if player_present(i) then
            cur_page[i], has_voted[i] = start_page, false
            vote_options[i] = { }
            mapvote.timer[i], mapvote.start[i] = 0, true
        end
    end
    -- Map Cycle countdown
    mapvote.timer[0], mapvote.start[0] = 0, true
    cprint("MAP VOTING HAS BEGUN", 2+8)
end

function OnScriptUnload()
    --
end

function OnTick()
    if (mapvote.start ~= nil) then

        for i = 1, 16 do
            if player_present(i) then
                if (mapvote.start[i]) then
                    mapvote.timer[i] = mapvote.timer[i] + 0.030
                    if (mapvote.timer[i] >= mapvote.timeout) then
                        mapvote.start[i], mapvote.start[i] = nil, nil
                    else
                        cls(i, 25)
                        mapvote:showMapVoteOptions(i)
                        rprint(i, ' ')
                        rprint(i, "[Page " .. cur_page[i] .. '/' .. total_pages .. "] Type 'n' -> Next Page  |  Type 'p' -> Previous Page")

                        local seconds = secondsToTime(mapvote.timer[i])
                        local char = getChar(mapvote.timeout - floor(seconds))
                        rprint(i, "Vote Time Remaining: " .. mapvote.timeout - floor(seconds) .. " second" .. char)

                        if (global_message ~= nil) then 
                            for j = 1,#global_message do
                                if (global_message[j] ~= nil) then
                                    rprint(i, global_message[j])
                                end
                            end
                        end
                        
                        for spaces = 1, (total_pages / 2 - 2) do
                            rprint(spaces, ' ')
                        end
                        
                    end
                end
            end
        end

        if (mapvote.start[0]) then
            mapvote.timer[0] = mapvote.timer[0] + 0.030
            if (mapvote.timer[0] >= mapvote.timeout) then
                mapvote.start[0], mapvote.start[0] = nil, nil
                for i = 1, 16 do
                    if player_present(i) then
                        cls(i, 25)
                        mapvote.start[i], mapvote.start[i] = nil, nil
                    end
                end
                mapvote:calculate_votes()
            else
                for i = 1, 16 do
                    if player_present(i) and (mapvote.start[i] == nil) then
                        cls(i, 25)
                        
                        if (global_message ~= nil) then 
                            for j = 1,#global_message do
                                if (global_message[j] ~= nil) then
                                    if (global_message.timer[0] ~= nil) then
                                        global_message.timer[0] = global_message.timer[0] + 0.030
                                        if (global_message.timer[0] >= mapvote.message_fade) or (#global_message >= mapvote.max_chat_messages) then
                                            global_message.timer[0] = 0
                                            table.remove(global_message, 1)
                                        else
                                            rprint(i, global_message[j])
                                        end
                                    end
                                end
                            end
                        end
                        
                        local seconds = secondsToTime(mapvote.timer[0])
                        local char = getChar(mapvote.timeout - floor(seconds))
                        rprint(i, "Vote Time Remaining: " .. mapvote.timeout - floor(seconds) .. " second" .. char)
                    end
                end
            end
        end
    end
end

function mapvote:showMapVoteOptions(p)

    if (vote_options[p][1] == nil) then
        vote_options[p] = { }
        local startpage, endpage = select(1, getPage(cur_page[p])), select(2, getPage(cur_page[p]))
        for i = startpage, endpage do
            if (results[i]) then

                local mapname, m = results[i], { }
                local gametypes = mapvote.maps[mapname]

                local part_one, part_two = i .. spacing(2) .. mapname .. ":" .. spacing(1) .. ""

                for j = 1, #gametypes do
                    if (gametypes[j] ~= nil) then
                        m[#m + 1] = "[" .. j .. spacing(2) .. gametypes[j] .. "]"
                        part_two = concat(m, ", ")
                    end
                end

                vote_options[p][#vote_options[p] + 1] = part_one .. spacing(1) .. part_two
            end
        end
    end

    if (vote_options[p] ~= nil) and (vote_options[p][1] ~= nil) then
        Say(p, vote_options[p])
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    local p = tonumber(PlayerIndex)
    local name = get_var(p, "$name")
    if (mapvote.start[p] ~= nil) and (mapvote.start[p]) then

        local msg = stringSplit(Message)
        if (#msg == 0) then
            return false
        elseif (msg[1] == mapvote.next_page) or (msg[1] == mapvote.previous_page) then

            if (msg[1] == mapvote.next_page) then
                cur_page[p] = cur_page[p] + 1
            elseif (msg[1] == mapvote.previous_page) then
                cur_page[p] = cur_page[p] - 1
            end
            
            if (cur_page[p] < start_page) then
                cur_page[p] = total_pages
            elseif (cur_page[p] > total_pages) then
                cur_page[p] = start_page
            end

            if (vote_options[p][1] ~= nil) then
                vote_options[p][1] = nil
            end


        elseif (msg[1] ~= nil and msg[2] ~= nil) then
            local messages = mapvote.messages
            local name = get_var(p, "$name")

            local map_selection_id = tonumber(msg[1]:match("%d+")) or nil
            local gamemode_selection_id = tonumber(msg[2]:match("%d+")) or nil

            -- Check if the player has already voted
            if not (has_voted[p]) then
                
                local current_start, current_end = select(1, getPage(cur_page[p])), select(2, getPage(cur_page[p]))
                
                for index = current_start, current_end do
                    if (results[index]) then

                        local mapname, gametype
                        local m = results[index]
                        local gt = mapvote.maps[m]

                        if (map_selection_id == index) then
                            mapname = m
                            for i = 1, #gt do
                                if (gt[i] ~= nil) then
                                    if (gamemode_selection_id == i) then
                                        gametype = gt[i]
                                        break
                                    end
                                end
                            end
                        end

                        if (mapname ~= nil) and (gametype ~= nil) then
                            for _, v in pairs(votes) do
                                local map_table = v[mapname]
                                if (map_table ~= nil) then
                                    local value = v[mapname][gametype]
                                    if (value ~= nil) then
                                        local cur_votes = value.votes
                                        value.votes = cur_votes + 1
                                        local msg = gsub(gsub(gsub(gsub(messages.on_vote,
                                                "%%name%%", "Chalwk"),
                                                "%%mapname%%", mapname),
                                                "%%gametype%%", gametype),
                                                "%%votes%%", value.votes)
                                        has_voted[p] = true
                                        mapvote.timer[p], mapvote.start[p] = 0, nil
                                        cls(p, 25)
                                        global_message[#global_message + 1] = msg
                                        if (global_message.timer[0] ~= nil) then
                                            global_message.timer[0] = 0
                                        end
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            else
                local msg = gsub(messages.already_voted, "%%name%%", name)
                rprint(p, msg)
            end
        end
    elseif (global_message ~= nil) then
        local chat_format = name .. ": " .. Message
        global_message[#global_message + 1] = chat_format
    else
        cls(PlayerIndex, 25)
        rprint(PlayerIndex, "Chat Muted. Please wait until the next game begins!")
    end
    return false
end

function cls(PlayerIndex, count, clear_chat, type)
    count = count or 25
    if (PlayerIndex) and not (clear_chat) then
        for _ = 1, count do
            rprint(PlayerIndex, " ")
        end
    elseif (clear_chat) then
        for i = 1, 16 do
            if player_present(i) then
                for _ = 1, count do
                    if (type == "chat") then
                        execute_command("msg_prefix \"\"")
                        say(i, " ")
                        execute_command("msg_prefix \" " .. mapvote.serverprefix .. "\"")
                    else
                        rprint(i, " ")
                    end
                end
            end
        end
    end
end

function stringSplit(inp, sep)
    if (sep == nil) then
        sep = "%s"
    end
    local t, i = {}, 1
    for str in gmatch(inp, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function secondsToTime(seconds)
    seconds = seconds % 60
    return seconds
end

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
mapvote.timeout = 10 -- Do not set to 0!

-- If this is true, Map Vote options will be displayed in the Console Environment (mapvote.show_in_chat must be false):
mapvote.show_in_console = true
-- Voting Options screen alignment:
mapvote.alignment = "l"  -- Left = l, Right = r, Center = c, Tab: t

-- If this is true, Map Voting options will be displayed in Chat (mapvote.show_in_console must be false)
mapvote.show_in_chat = false

-- Number of Map Vote entries to display per page:
mapvote.maxresults = 5

mapvote.next_page = "n"
mapvote.previous_page = "p"

mapvote.serverprefix = "** SERVER ** "

mapvote.maps = { -- Create map settings array
    -- [MAP NAME] - {AVAILABLE GAMETYPES}
    ["ratrace"] = {"ctf", "slayer"},
    ["bloodgulch"] = {"ctf", "slayer", "oddball"},
    ["beavercreek"] = {"ctf", "slayer", "Team Slayer"},
    ["boardingaction"] = {"ctf", "slayer"},
    ["carousel"] = {"ctf", "slayer"},
    ["dangercanyon"] = {"ctf", "slayer"},
    ["deathisland"] = {"ctf", "slayer"},
    ["gephyrophobia"] = {"ctf", "slayer"},
    ["icefields"] = {"ctf", "slayer", "oddball"},
    ["infinity"] = {"ctf", "slayer"},
    ["sidewinder"] = {"ctf", "slayer", "oddball"},
    ["timberland"] = {"ctf", "slayer"},
    ["hangemhigh"] = {"ctf", "slayer", "Team Slayer", "Team King"},
    ["ratrace"] = {"ctf", "slayer"},
    ["damnation"] = {"ctf", "slayer"},
    ["putput"] = {"ctf", "slayer"},
    ["prisoner"] = {"ctf", "slayer"},
    ["wizard"] = {"ctf", "slayer"},
    ["longest"] = {"ctf", "slayer", "Team Slayer"}, 
    
    -- Repeat the structure to add you own maps and gametypes.
}

-- mapvote config ends --

local results, cur_page, votes = { }, { }, { }
local start_page, map_count, total_pages = 1, 0, 0
local vote_options = { }

local sub, gsub, find = string.sub, string.gsub, string.find
local match, gmatch = string.match, string.gmatch
local upper, lower = string.upper, string.lower
local floor = math.floor
local concat = table.concat

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_GAME_START'], "OnGameStart")
    execute_command("sv_mapcycle_timeout " .. tostring(mapvote.timeout))
end

local sendToConsole = function()
    if (mapvote.show_in_console) and not (mapvote.show_in_chat) then
        return true
    elseif not (mapvote.show_in_console) and (mapvote.show_in_chat) then
        return false
    end
end

local function Chat(p, m)
    if (m ~= nil) then
        if sendToConsole() then
            rprint(p, "|" .. mapvote.alignment .. " " .. m)
        else
            execute_command("msg_prefix \"\"")
            say(p, m)
            execute_command("msg_prefix \" " .. mapvote.serverprefix .. "\"")
        end
    end
end

local Say = function(p, message)
    if (p) and (message) then
        if (type(message) == "table") then
            for i = 1,#message do
                if (message[i] ~= nil) then
                    Chat(p, message[i])
                end
            end
        else
            Chat(p, message)
        end
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

function OnGameStart()
    -- Clear all arrays and counts
    results, votes, map_count = { }, { }, 0
    vote_options = { }
    
    for k, _ in pairs(mapvote.maps) do
        results[#results + 1] = k
        map_count = map_count + 1
    end
    
    for i = 1, #results do
        if (results[i]) then
            local mapname = results[i]
            local gametype = mapvote.maps[mapname]
            
            for j = 1,#gametype do
                if (gametype[j] ~= nil) then            
                    votes[#votes + 1] = {
                        [mapname] = {
                            [gametype] = {
                                map_id = tonumber(i),
                                gametype_id = j,
                                votes = 0,
                            },
                        },
                    }
                end
            end
        end
    end
end

function OnGameEnd()
    if ( tonumber(get_var(0, "$pn")) >= mapvote.players_needed ) then
        for i = 1,16 do
            if player_present(i) then
                cur_page[i] = start_page
            end
        end
        
        total_pages = getPageCount(map_count, mapvote.maxresults)
        
        -- Register a hook into SAPP's chat event.
        register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
        -- Register a hook into SAPP's tick event.
        register_callback(cb['EVENT_TICK'], "OnTick")
        -- Begin voting process.
        mapvote:begin()
    end
end

function OnScriptUnload()
    --
end

function OnTick()
    if (mapvote.timer ~= nil) and (mapvote.start) then
        mapvote.timer = mapvote.timer + 0.030
        if (mapvote.timer >= mapvote.timeout) then
            mapvote.start, mapvote.start = nil, nil
        else for i = 1,16 do
                if player_present(i) then
                    cls(i, 25)
                    mapvote:showResults(i)
                    rprint(i, ' ')
                    rprint(i, "[Page " .. cur_page[i] .. '/' .. total_pages .. "] Type 'n' -> Next Page  |  Type 'p' -> Previous Page")
                    rprint(i, ' ')
                    rprint(i, ' ')
                    rprint(i, ' ')
                end
            end            
        end
    end
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

function mapvote:showResults(p)
    vote_options[p] = vote_options[p] or { }
    if (vote_options[p][1] == nil) then
        local startpage, endpage = select(1, getPage(cur_page[p])), select(2, getPage(cur_page[p]))
        for i = startpage, endpage do
            if (results[i]) then
                for k, _ in pairs(results) do
                    if (k == i) then
                    
                        local mapname, m = results[i], { }
                        local gametypes = mapvote.maps[mapname]
                    
                        local part_one, part_two = k .. spacing(2) .. mapname .. ":" .. spacing(1), ""

                        for j = 1,#gametypes do
                            if (gametypes[j] ~= nil) then
                                m[#m + 1] = "[" .. j .. spacing(2) .. gametypes[j] .. "]"
                                part_two = concat(m, ", ")
                            end
                        end
                        
                        vote_options[p][#vote_options[p] + 1] = part_one .. spacing(1) .. part_two
                        
                    end
                end
            end
        end
    end
   
    if (vote_options[p] ~= nil) then
        Say(p, vote_options[p])
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    local p = tonumber(PlayerIndex)
    if (mapvote.start ~= nil) and (mapvote.start) then
    
        local msg = stringSplit(Message)
        if (#msg == 0) then
            return false
        elseif ( msg[1] == mapvote.next_page ) or ( msg[1] == mapvote.previous_page ) then
        
            if (msg[1] == mapvote.next_page) then
                cur_page[p] = cur_page[p] + 1
            elseif (msg[1] == mapvote.previous_page) then
                cur_page[p] = cur_page[p] - 1
            end
            
            if (cur_page[p] <= (start_page - 1) or cur_page[p] >= total_pages) then
                cur_page[p] = start_page
            end
            
            if (vote_options[p] ~= nil) then            
                vote_options[p] = nil
            end
            
            
        elseif ( msg[1]:match("%d+") ) then
            local mapID = tonumber(msg[3]:match("%d+")) or nil
            local gametypeID = tonumber(msg[2]:match("%d+")) or nil
            
            if (mapID ~= nil and gametypeID ~= nil) then 
                local map_num, gametype_num = tonumber(msg[2]), tonumber(msg[3])
            
                local startpage, endpage = select(1, getPage(cur_page[p])), select(2, getPage(cur_page[p]))
                for i = startpage, endpage do
                    if (results[i]) then
                        for k, _ in pairs(results) do
                            if (k == i) then
                                
                                local map = results[map_num]
                                local gametype = mapvote.maps[map]
                                if (map_num == i) and (map ~= nil and gametype ~= nil) then
                                    if (gametype[gametype_num] ~= nil) then
                                        local cur_votes = votes[map][gametype].votes
                                        for k,v in ipairs(votes) do
                                            
                                        end
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end         
        end
    end
    
    -- Prevent players from typing general messages in chat while voting is in progress.
    return false
end

function mapvote:begin()
    mapvote.timer, mapvote.start = 0, true
end

function cls(PlayerIndex, count)
    if (PlayerIndex) then
        count = count or 25
        for _ = 1, count do
            if sendToConsole() then
                rprint(PlayerIndex, " ")
            else
                execute_command("msg_prefix \"\"")
                say(PlayerIndex, " ")
                execute_command("msg_prefix \" " .. mapvote.serverprefix .. "\"")
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

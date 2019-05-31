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

-- Allocated vote time:
mapvote.votetime = 10

-- Players needed to vote.
mapvote.players_needed = 1

-- Map Cycle timeout (in seconds) - time between games:
mapvote.timeout = 10 -- Do not set to 0

-- Map vote options are displayed in the console environment:
mapvote.alignment = "l"  -- Left = l, Right = r, Center = c, Tab: t

-- Number of Map Vote entries to display per page:
mapvote.maxresults = 10

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

local results = { }
local cur_page = { }
local start_page, map_count, total_pages = 1, 0, 0

local sub, gsub, find = string.sub, string.gsub, string.find
local match, gmatch = string.match, string.gmatch
local upper, lower = string.upper, string.lower
local floor = math.floor
local concat = table.concat

function OnScriptLoad()
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    execute_command("sv_mapcycle_timeout " .. tostring(mapvote.timeout))
end

local SayRcon = function(p, msg)
    if (msg) then
        rprint(p, "|" .. mapvote.alignment .. " " .. msg)
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

function OnGameEnd()
    if ( tonumber(get_var(0, "$pn")) >= mapvote.players_needed ) then
        for i = 1,16 do
            cur_page[i] = start_page
        end
        for k, _ in pairs(mapvote.maps) do
            results[#results + 1] = k
            map_count = map_count + 1
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
        if (mapvote.timer >= mapvote.votetime) then
            mapvote.start, mapvote.start = nil, nil
        else for i = 1,16 do
                if player_present(i) then
                    cls(i, 25)
                    mapvote:showResults(i)
                    rprint(i, '[Page ' .. cur_page[i] .. '/' .. total_pages .. ']')
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
    local startpage, endpage = select(1, getPage(cur_page[p])), select(2, getPage(cur_page[p]))
    for i = startpage, endpage do
        if (results[i]) then
            for k, _ in pairs(results) do
                if (k == i) then
                
                    local mapname = results[i]
                    local gametypes = mapvote.maps[mapname]
                
                    local part_one, part_two = k .. spacing(2) .. mapname .. ":" .. spacing(1), ""
                    local m = { }
                    for j = 1,#gametypes do
                        if (gametypes[j] ~= nil) then
                            m[#m + 1] = "[" .. j .. spacing(2) .. gametypes[j] .. "]"
                            part_two = concat(m, ", ")
                        end
                    end
                    
                    local vote_options = part_one .. spacing(1) .. part_two
                    SayRcon(p, vote_options)
                    m = nil
                end
            end
        end
    end 
end

function OnPlayerChat(PlayerIndex, Message, type)
    if (mapvote.start ~= nil) and (mapvote.start) then
        local message = stringSplit(Message)
        if (#message == 0) then
            return false
        elseif ( message[1]:match("%d+") ) then
            cur_page[PlayerIndex] = tonumber(message[1])
            -- add map vote entry:
        end

        -- Prevent players from typing general messages in chat while voting is in progress.
        return false
    end
end

function mapvote:begin()
    local votes = votes or { }
    mapvote.timer, mapvote.start = 0, true
end

function cls(PlayerIndex, count)
    if (PlayerIndex) then
        count = count or 25
        for _ = 1, count do
            rprint(PlayerIndex, " ")
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

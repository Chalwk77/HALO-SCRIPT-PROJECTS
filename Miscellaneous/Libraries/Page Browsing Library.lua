--[[
--=====================================================================================================--
Script Name: Page Browsing Library, for SAPP (PC & CE)
Description: This library lets you send timed rcon messages to a player.
             Console messages appear for

Steps to configure:

1.  Place 'Page Browsing Library.lua' in the server's root directory (same location as sapp.dll).
    Do not change the name of the .lua file.

2.  Place this at the top of your Lua script:
    local PageBrowser = (loadfile "Page Browsing Library.lua")()

3.  Showing results page:
    PageBrowser:ShowResults(Player, Page, 10, 1, 2, array)

    - Target Player ID:                 [number]    Memory Id of player who will receive the messages
    - Page Number:                      [number]    Optional but will default to page 1 if not defined
    - Maximum results per page:         [number]
    - Max columns:                      [number]
    - Spaces between table elements     [number]
    - Target Array                      [table]

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local PageBrowser = {}

local function GetPage(Page, MaxResults)
    local start = (MaxResults) * Page
    local start_page = (start - MaxResults + 1)
    local end_page = start
    return start_page, end_page
end

local floor = math.floor
local function GetPageCount(Total, MaxResults)
    local pages = Total / (MaxResults)
    if (pages ~= floor(pages)) then
        pages = floor(pages) + 1
    end
    return pages
end

local function spacing(n)
    local Str = ""
    for i = 1, n do
        if i == floor(n / 2) then
            Str = Str .. ""
        end
        Str = Str .. " "
    end
    return "," .. Str
end

local concat = table.concat
local function FormatTable(Table, MaxResults, Spaces)

    local longest = 0
    for i = 1, #Table do
        if (Table[i]:len() > longest) then
            longest = Table[i]:len()
        end
    end

    local rows, row, count = {}, 1, 1
    for k, v in pairs(Table) do
        if (count % MaxResults == 0) or (k == #Table) then
            rows[row] = (rows[row] or "") .. v
        else
            rows[row] = (rows[row] or "") .. v .. spacing(longest - v:len() + Spaces)
        end
        if (count % MaxResults == 0) then
            row = row + 1
        end
        count = count + 1
    end

    return concat(rows)
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

function PageBrowser:ShowResults(Ply, Page, MaxResults, MaxColumns, Spaces, Table, OutPutFunc)

    local total_pages = GetPageCount(#Table, MaxResults)

    if (Page > 0 and Page <= total_pages) then

        local start_index, end_index = 1, MaxColumns
        local start_page, end_page = GetPage(Page, MaxResults)

        local results = { }
        for page_num = start_page, end_page do
            if Table[page_num] then
                results[#results + 1] = Table[page_num]
            end
        end

        while (end_index < #Table + MaxColumns) do

            local t, row = { }
            for i = start_index, end_index do
                t[i] = results[i]
                row = FormatTable(t, Spaces)
            end

            if (row ~= nil and row ~= "" and row ~= " ") then
                Respond(Ply, row, 10)
            end

            start_index = (end_index + 1)
            end_index = (end_index + (MaxColumns))
        end

        Respond(Ply, '[Page ' .. Page .. '/' .. total_pages .. '] Showing ' .. #results .. '/' .. #Table .. ' results')
    else
        Respond(Ply, 'Invalid Page ID. Please enter a page between 1-' .. total_pages)
    end
end

return PageBrowser
--[[
--=====================================================================================================--
Script Name: Page Browsing Routine, for SAPP (PC & CE)

**Important:** This library MUST be placed inside your servers root directory (the same directory where sapp.dll is located).
Ensure the file name matches exactly *"Page Browsing Library.lua"*.

### Initialize this library like so:
* Place this at the top of your script:
local PageBrowser = (loadfile "Page Browsing Library.lua")()

### Calling the Page Browser Routine:
PageBrowser:ShowResults(Executor, tonumber(Page), 10, 1, 2, array)

#### PageBrowser:ShowResults expects 6 parameters:
- Target Player ID
- Page Number (optional - this will default to page 1 if not specified)
- Maximum results per page
- Max columns
- Spacing between array elements
- Target Array

The Target Array must be a number-key-indexed array.
For example:
* these arrays are all valid:
local array = {"a", "b", "c", "d"} 
local array = {10603, 100, 6, 1}
local array = {[1] = "string", "hello", 1}

-- THESE ARE NOT VALID:
local array = {["127.0.0.1"] = {name = Chalwk}, [1] = function print('hi')end}

**Each index element must also either be a string or number.**

Example Usage:
local names = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
Assume the target player's index id is 1:
Assume the desired page number is 2:
PageBrowser:ShowResults(TargetPlayer, tonumber(Page), 10, 5, 2, names)

#### Output: 
> K,  L,  M,  N,  O
> P,  Q,  R,  S,  T,
> [Page 2/3] Showing 10/26 results

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

local PageBrowser = { }

local len = string.len
local floor = math.floor
local concat = table.concat

local function GetPage(Page, MaxResults)
    local start = (MaxResults) * Page
    local startpage = (start - MaxResults + 1)
    local endpage = start
    return startpage, endpage
end

local function getPageCount(Total, MaxResults)
    local pages = Total / (MaxResults)
    if ((pages) ~= floor(pages)) then
        pages = floor(pages) + 1
    end
    return pages
end

local function spacing(n)
    local String, Seperator = "", ","
    for i = 1, n do
        if i == math.floor(n / 2) then
            String = String .. ""
        end
        String = String .. " "
    end
    return Seperator .. String
end

local function FormatTable(t, MaxResults, Spaces)

    local longest = 0
    for _, v in pairs(t) do
        if (len(v) > longest) then
            longest = len(v)
        end
    end

    local rows, row, count = {}, 1, 1
    for k, v in pairs(t) do
        if (count % MaxResults == 0) or (k == #t) then
            rows[row] = (rows[row] or "") .. v
        else
            rows[row] = (rows[row] or "") .. v .. spacing(longest - len(v) + Spaces)
        end
        if (count % MaxResults == 0) then
            row = row + 1
        end
        count = count + 1
    end
    return concat(rows)
end

local function Respond(Executor, Content)
    if (Executor == 0) then
        cprint(Content)
    else
        rprint(Executor, Content)
    end
end

function PageBrowser:ShowResults(Executor, Page, MaxResults, MaxColumns, Spaces, Table)
    local total_pages = getPageCount(#Table, MaxResults)

    if (Page > 0 and Page <= total_pages) then

        local startIndex, endIndex = 1, MaxColumns
        local startpage, endpage = GetPage(Page, MaxResults)

        local results = { }
        for page_num = startpage, endpage do
            if Table[page_num] then
                results[#results + 1] = Table[page_num]
            end
        end

        local function formatResults()
            local t, row = { }

            for i = startIndex, endIndex do
                t[i] = results[i]
                row = FormatTable(t, MaxResults, Spaces)
            end

            if (row ~= nil and row ~= "" and row ~= " ") then
                Respond(Executor, row)
            end

            startIndex = (endIndex + 1)
            endIndex = (endIndex + (MaxColumns))
        end

        while (endIndex < #Table + MaxColumns) do
            formatResults()
        end

        Respond(Executor, '[Page ' .. Page .. '/' .. total_pages .. '] Showing ' .. #results .. '/' .. #Table .. ' results', 2 + 8)
    else
        Respond(Executor, 'Invalid Page ID. Please type a page between 1-' .. total_pages)
    end
end

return PageBrowser
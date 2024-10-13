--[[
--=====================================================================================================--
Script Name: Page Browsing Library for SAPP (PC & CE)
Description: This library allows sending timed RCON messages to a player based on paginated results.

Configuration Steps:
1. Place 'Page Browsing Library.lua' in the server's root directory (same location as sapp.dll).
   Do not change the name of the .lua file.

2. At the top of your Lua script, include the library:
   local PageBrowser = loadfile("Page Browsing Library.lua")()

3. To show results on a page, use:
   PageBrowser:ShowResults(playerID, page, maxResults, maxColumns, spaces, dataTable)

   - playerID    [number]: Memory ID of the player receiving the messages.
   - page        [number]: Page number (default is 1 if not defined).
   - maxResults  [number]: Maximum results per page.
   - maxColumns  [number]: Maximum columns to display.
   - spaces      [number]: Spaces between table elements.
   - dataTable   [table]: Target table containing data.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
License: You can use this script subject to the conditions specified here:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

local PageBrowser = {}

--- Calculates the start and end index for the given page number.
-- @param page Number: The page number to calculate indices for.
-- @param maxResults Number: The maximum number of results per page.
-- @return Number, Number: The start and end indices for the page.
local function GetPage(page, maxResults)
    local start = maxResults * page
    local startPage = start - maxResults + 1
    local endPage = start
    return startPage, endPage
end

local floor = math.floor

--- Calculates the total number of pages based on total items and max results per page.
-- @param total Number: The total number of items.
-- @param maxResults Number: The maximum results per page.
-- @return Number: The total number of pages.
local function GetPageCount(total, maxResults)
    local pages = total / maxResults
    return pages == floor(pages) and pages or floor(pages) + 1
end

--- Generates spacing for table formatting.
-- @param n Number: The number of spaces to generate.
-- @return String: A string of spaces.
local function Spacing(n)
    return string.rep(" ", n)  -- Use string.rep for clarity and efficiency
end

local concat = table.concat

--- Formats a table of results into a string for display.
-- @param dataTable Table: The table to format.
-- @param maxResults Number: The maximum results per page.
-- @param spaces Number: The spaces between table elements.
-- @return String: Formatted string for display.
local function FormatTable(dataTable, maxResults, spaces)
    local longest = 0
    for _, value in ipairs(dataTable) do
        longest = math.max(longest, #value)  -- Find the length of the longest string
    end

    local rows = {}
    local count = 1
    for i = 1, #dataTable do
        if (count % maxResults == 0) or (i == #dataTable) then
            rows[#rows + 1] = dataTable[i]  -- Add the last entry of the row
        else
            rows[#rows + 1] = dataTable[i] .. Spacing(longest - #dataTable[i] + spaces)  -- Format current entry
        end
        count = count + 1
    end

    return concat(rows)  -- Concatenate all rows into a single string
end

--- Sends a message to the player or console.
-- @param playerID Number: The player ID to send the message to.
-- @param message String: The message content to display.
local function Respond(playerID, message)
    if playerID == 0 then
        cprint(message)  -- Print to console
    else
        rprint(playerID, message)  -- Send RCON message to player
    end
end

--- Displays paginated results to a player.
-- @param playerID Number: The player ID to show results to.
-- @param page Number: The current page number to display.
-- @param maxResults Number: The maximum results per page.
-- @param maxColumns Number: The maximum number of columns to display.
-- @param spaces Number: The number of spaces between table elements.
-- @param dataTable Table: The data table to show results from.
function PageBrowser:ShowResults(playerID, page, maxResults, maxColumns, spaces, dataTable)
    local totalPages = GetPageCount(#dataTable, maxResults)

    if page > 0 and page <= totalPages then
        local startPage, endPage = GetPage(page, maxResults)
        local results = {}

        for i = startPage, endPage do
            if dataTable[i] then
                results[#results + 1] = dataTable[i]
            end
        end

        local startIndex, endIndex = 1, maxColumns
        while endIndex <= #results do
            local row = FormatTable(results, maxColumns, spaces)
            if row and row ~= "" then
                Respond(playerID, row)  -- Send formatted row to player
            end
            startIndex = endIndex + 1
            endIndex = endIndex + maxColumns
        end

        -- Send footer with page info
        Respond(playerID, '[Page ' .. page .. '/' .. totalPages .. '] Showing ' .. #results .. '/' .. #dataTable .. ' results')
    else
        Respond(playerID, 'Invalid Page ID. Please enter a page between 1-' .. totalPages)
    end
end

return PageBrowser

-- Page Browsing Routine by Chalwk

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
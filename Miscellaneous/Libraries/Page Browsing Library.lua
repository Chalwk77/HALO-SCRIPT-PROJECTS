local PageBrowser = {}

local max_results = 50
local max_columns = 5
local spaces = 2

local function GetPage(page)
    local start = (max_results) * page
    local start_page = (start - max_results + 1)
    local end_page = start
    return start_page, end_page
end

local floor = math.floor
local function GetPageCount(total)
    local pages = total / (max_results)
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
local function FormatTable(table)

    local longest = 0
    for i = 1, #table do
        if (table[i]:len() > longest) then
            longest = table[i]:len()
        end
    end

    local rows, row, count = {}, 1, 1
    for k, v in pairs(table) do
        if (count % max_results == 0) or (k == #table) then
            rows[row] = (rows[row] or "") .. v
        else
            rows[row] = (rows[row] or "") .. v .. spacing(longest - v:len() + spaces)
        end
        if (count % max_results == 0) then
            row = row + 1
        end
        count = count + 1
    end

    return concat(rows)
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

function PageBrowser:ShowResults(Ply, Table, Page, Artifact)

    local total_pages = GetPageCount(#Table)

    if (Page > 0 and Page <= total_pages) then

        local start_index, end_index = 1, max_columns
        local start_page, end_page = GetPage(Page)

        local results = { }
        for page_num = start_page, end_page do
            if Table[page_num] then
                results[#results + 1] = Table[page_num]
            end
        end

        while (end_index < #Table + max_columns) do

            local t, row = { }
            for i = start_index, end_index do
                t[i] = results[i]
                row = FormatTable(t)
            end

            if (row ~= nil and row ~= "" and row ~= " ") then
                Respond(Ply, row, 10)
            end

            start_index = (end_index + 1)
            end_index = (end_index + (max_columns))
        end

        Respond(Ply, '[Page ' .. Page .. '/' .. total_pages .. '] Showing ' .. #results .. '/' .. #Table .. ' aliases for: "' .. Artifact .. '"')
    else
        Respond(Ply, 'Invalid Page ID. Please type a page between 1-' .. total_pages)
    end
end

return PageBrowser
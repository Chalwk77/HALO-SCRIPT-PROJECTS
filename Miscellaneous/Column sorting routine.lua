-- Column sorting routine by Chalwk

api_version = "1.12.0.0"

-- Configuration [starts]
local input = { "1", "2", "3", "4", "5", "6" } -- example input data
local max_columns, max_results = 4, #input
local startIndex = 1
local endIndex = max_columns
local spaces = 3
-- Configuration [ends].

local data, concat, gmatch = { }, table.concat, string.gmatch
local weapons_table = { }
local initialStartIndex
function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
end

local function stringSplit(inp, sep)
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

function OnGameStart()
    initialStartIndex = tonumber(startIndex)
    for k, v in pairs(input) do
        content = stringSplit(v, ",")
        weapons_table[#weapons_table + 1] = content
    end
    data:align(input)
end

local function spacing(n)
    local spacing = ""
    for i = 1, n do
        spacing = spacing .. " "
    end
    return spacing
end

function data:align(table)
    local proceed, finished = true
    local function formatResults()
        local placeholder, row = { }

        for i = tonumber(startIndex), tonumber(endIndex) do
            if table[i] then
                placeholder[#placeholder + 1] = table[i]
                row = concat(placeholder, spacing(spaces))
            end
        end

        if (row ~= nil) then
            cprint(row)
        end

        if (startIndex == max_results + 1) then
            proceed, finished = false, true
        end

        for b in pairs(placeholder) do
            placeholder[b] = nil
        end
        startIndex = (endIndex + 1)
        endIndex = (endIndex + (max_columns))
    end

    if (proceed) and not (finished) then
        while (endIndex < max_results + max_columns) do
            formatResults()
        end
    end

    if (finished) and not (proceed) then
        startIndex = initialStartIndex
        endIndex = max_columns
    end
end

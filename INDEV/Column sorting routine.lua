-- Column sorting routine by Chalwk

api_version = "1.12.0.0"

-- Configuration [starts]


local input = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13"}
local max_columns, max_results = 5, #input
local startIndex = 1
local endIndex = max_columns
local spaces = 3

-- Configuration [ends].

local data, concat, gmatch  = { }, table.concat, string.gmatch

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
end

function OnGameStart()
    data:align(input)
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

local function spacing(n)
    local spacing = ""
    for i = 1, n do
        spacing = spacing .. " "
    end
    return spacing
end

function data:align(tab)
    local initialStartIndex = tonumber(startIndex)
    local proceed, finished = true
    local function formatResults()
        local t, row, content, done = {}
        
        for k, v in pairs(tab) do
            content = stringSplit(v, ",")
            t[#t + 1] = content
        end
        
        local placeholder = { }
        
        for i = tonumber(startIndex), tonumber(endIndex) do
            if t[i] then
                placeholder[#placeholder + 1] = t[i][1]
                row = concat(placeholder, spacing(spaces))
            end
        end

        if (row ~= nil) then
            cprint(row)
        end

        for a in pairs(t) do t[a] = nil end
        for b in pairs(placeholder) do placeholder[b] = nil end
        
        startIndex = (endIndex + 1)
        endIndex = (endIndex + (max_columns))

        if (startIndex == max_results + 1) then
            proceed, finished = false, true
        end
    end
    
    if (proceed) and not (finished) then
        for i = tonumber(startIndex), tonumber(endIndex) do
            formatResults()
        end
        -- while (endIndex <= max_results) do
            -- formatResults()
        -- end
    end
    if (finished) and not (proceed) then
        startIndex = initialStartIndex
        endIndex = max_columns
    end
end

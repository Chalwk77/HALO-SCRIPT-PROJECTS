-- Page Browsing Routine by Chalwk
api_version = "1.12.0.0"

-- Configuration [starts]
local max_results_per_page = 5
local page = 1
local seperator = "|"
local input_data = {
    "Onion",
    "Kale (recipe)",
    "Japanese (satsuma) sweet potatoes",
    "Red/green cabbage",
    "Carrots",
    "Celery",
    "Lemons",
    "Organic ground beef",
    "Canned tomatoes",
    "Avocado",
    "Oranges",
    "Canned black beans",
    "French green lentils",
    "Fennel",
    "Parmesan cheese",
    "Quinoa flakes",
    "Arugula",
    "Organic eggs",
    "Apples",
    "Beets",
}
-- Configuration [ends]

local gmatch = string.gmatch
local getPage = function(params)
    local params = params or {}
    local page = tonumber(params.page) or nil
    local max_results = max_results_per_page
    local start = (max_results) * page
    local startpage = (start - max_results + 1)
    local endpage = start
    if (page) then
        return startpage, endpage
    else
        return error("Attempt to index local 'page' a nil value")
    end
end

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
end

function OnScriptUnload()
    --
end

function OnGameStart()
    if (page ~= nil) and (page > 0) then
        local p, table = { }, { }
        p.page = page

        local startpage, endpage = select(1, getPage(p)), select(2, getPage(p))

        local count = 0
        local t = {}
        for _, v in pairs(input_data) do
            t[#t + 1] = v
            count = count + 1
        end

        if (#t > 0) then
            for page_num = startpage, endpage do
                if (t[page_num]) then
                    for k, v in pairs(t) do
                        if (k == page_num) then
                            table[#table + 1] = (t[page_num] .. tostring(seperator) .. k)
                        end
                    end
                end
            end
        end

        if (#table > 0) then

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

            for _, v in pairs(table) do
                local data = stringSplit(v, tostring(seperator))
                if (data) then
                    local result, i = { }, 1
                    for j = 1, 2 do
                        if (data[j] ~= nil) then
                            result[i] = data[j]
                            i = i + 1
                        end
                    end
                    if (result ~= nil) then
                        local item_name = result[1]
                        local index = result[2]
                        print("[#" .. index .. "] " .. item_name)
                    end
                end
            end

            print("Viewing Page (" .. page .. "). Total Results: " .. count)
        else
            print("Nothing to show")
        end
    end
end

-- Word Buster BadWords file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local BadWords = {}

local time = os.clock
local lines = io.lines

local function READ()
    local content = ''
    local file = io.open('facebook_words.txt', 'r')
    if (file) then
        content = file:read('*all')
        file:close()
    end
    return content
end

local function WRITE(dir, content)
    local file = io.open(dir, 'w')
    if (file) then
        file:write(content)
        file:close()
    end
end

local function StrSplit(str, Delim)
    local args = { }
    for arg in str:gmatch("([^" .. Delim .. "]+)") do
        if not arg:find('%d+') and not arg:find('%p') then
            args[#args + 1] = arg:lower()
        end
    end
    return args
end

function BadWords:Load()

    local words = {}
    cprint('Loading languages...')

    local count, start = 0, time()
    local dir = self.settings.lang_directory
    local languages = self.settings.languages

    for lang, load in pairs(languages) do
        if (load) then
            count = count + 1
            for line in lines(dir .. lang) do
                words[#words + 1] = {
                    regex = self:GetRegex(line),
                    language = lang,
                    word = line
                }
            end
        end
    end

    if (#words > 0) then
        local total_time = time() - start
        cprint('Successfully loaded ' .. count .. ' languages:', 10)
        cprint(#words .. ' words loaded in ' .. total_time .. ' seconds', 10)
        self.settings.words = words
    else
        cprint('No words were loaded', 12)
    end
end

local function StringToTable(str)
    local t = {}
    for i = 1, str:len() do
        t[#t + 1] = str:sub(i, i)
    end
    return t
end

function BadWords:GetRegex(line)
    --local regex = ''
    --local t = StringToTable(line)
    --for _, char in pairs(t) do
    --    local chars = self.settings.patterns[char]
    --    if (chars) then
    --        for i = 1, #chars do
    --            if (chars[i]) then
    --                regex = regex .. chars[i]
    --            end
    --        end
    --    end
    --end

    local t = StringToTable(line)
    local patterns = self.settings.patterns
    local regex = {}
    for _, char in pairs(t) do
        local chars = patterns[char]
        if (chars) then
            for id, pattern in pairs(chars) do
                if (not regex[id]) then
                    regex[id] = pattern
                else
                    regex[id] = regex[id] .. pattern
                end
            end
        end
    end
    return regex
end

return BadWords
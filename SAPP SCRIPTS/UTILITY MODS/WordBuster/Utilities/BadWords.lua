-- Word Buster BadWords file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local BadWords = {}

local time = os.clock
local lines = io.lines

function BadWords:Load()

    local words = {}
    cprint('Loading languages...')

    local count, start = 0, time()
    local dir = self.settings.lang_directory
    local languages = self.settings.languages

    for lang, load in pairs(languages) do
        if (load) then
            count = count + 1
            for line in lines(dir .. lang .. '.txt') do
                words[#words + 1] = self:GetRegex(line)
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
    local regex = ''
    local characters = StringToTable(line)
    for i = 1, #characters do
        local char = characters[i]
        local chars = self.settings.patterns[char]
        if (chars) then
            for j = 1, #chars do
                if (chars[j]) then
                    regex = regex .. chars[j]
                end
            end
        end
    end
    return regex
end

return BadWords
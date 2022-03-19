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
            local success = pcall(function()
                for line in lines(dir .. lang) do
                    words[#words + 1] = {
                        regex = self:GetRegex(line),
                        language = lang,
                        word = line
                    }
                end
            end)
            if (not success) then
                cprint('Warning: ' .. lang .. ' NOT FOUND in ' .. dir, 12)
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

function BadWords:GetRegex(line)
    local t = self.stringToTable(line)
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
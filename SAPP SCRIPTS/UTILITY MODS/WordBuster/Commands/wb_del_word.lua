-- Word Buster Delete Word command file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    name = 'wb_del_word',
    description = 'Delete a word from lang file',
    admin_level = 4,
    help = 'Syntax: /$cmd (word) (lang)',
    no_perm = 'You need to be level $lvl or higher to use this command.'
}

local lines = io.lines
function Command:Run(Ply, Args)

    local word = Args[2]
    local lang = Args[3]
    local dir = self.settings.lang_directory
    local file = self.settings.languages[lang]

    if (self.permission(Ply, self.admin_level, self.no_perm)) then

        if (not word) then
            self.send(Ply, 'No word defined.')
            self.send(Ply, self.help)
        elseif (not lang) then
            self.send(Ply, 'Invalid lang file.')
            self.send(Ply, self.help)
        elseif (file == nil) then
            self.send(Ply, 'Lang file not found.')
        elseif (file == false) then
            self.send(Ply, 'Sorry, that lang file is disabled.')
        else

            local words = {}
            local success = pcall(function()
                for line in lines(dir .. lang) do
                    if (line ~= word) then
                        words[#words + 1] = line
                    end
                end
            end)

            if (not success) then
                self.send(Ply, 'Error. File not found.')
            else
                self.write(dir .. lang, table.concat(words, '\n'))
                self.send(Ply, 'Deleting "' .. word .. '" from ' .. lang)
            end
        end
    end

    return false
end

return Command